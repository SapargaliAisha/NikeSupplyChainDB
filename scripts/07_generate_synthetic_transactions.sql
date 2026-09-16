/*=============================================================
  07 — GENERATE: SYNTHETIC TRANSACTIONS
  Builds ~7.5k purchase orders and the dependent shipment,
  status, BOL, work order and fee records using cursors.
  Depends on: 01-06. Longest-running script.
=============================================================*/
-- tblPURCHASE_ORDER --
CREATE OR ALTER PROCEDURE Wrapper_PO
@RUN INT
AS 
DECLARE @RAND DATE
WHILE @RUN>0
BEGIN
SET @RAND=DATEADD(day, FLOOR(RAND()*DATEDIFF(DAY, '2015-01-01', '2025-01-01')), '2015-01-01')
INSERT INTO tblPURCHASE_ORDER(PO_Date)
VALUES(@RAND)
SET @RUN=@RUN-1
END
GO
EXEC Wrapper_PO 7567
GO




-- tblSHIPMENT --
CREATE OR ALTER PROCEDURE Factory_Nested
@FactoryName2 VARCHAR(250),
@FactoryID2 INT OUTPUT
AS
--Putting restriction 'TOP 1' to avoid encounting on duplicate factory names
SET @FactoryID2 =(SELECT TOP 1 FactoryID FROM tblFACTORY WHERE FactoryName=@FactoryName2)
GO

CREATE OR ALTER PROCEDURE Carrier_Nested
@CarrierName2 VARCHAR(70),
@CarrierID2 INT OUTPUT
AS
SET @CarrierID2=(SELECT CarrierID FROM tblCARRIER WHERE CarrierName=@CarrierName2)
GO

CREATE OR ALTER PROCEDURE Shipment_Sproc
@ShipmentDate DATE,
@CarrierName VARCHAR(70),
@FactoryName VARCHAR(250)
AS
DECLARE @CarrierID INT, @FactoryID INT, @FactStat VARCHAR(10)
EXEC Carrier_Nested
@CarrierName2=@CarrierName,
@CarrierID2=@CarrierID OUTPUT
	IF @CarrierID IS NULL
	BEGIN
	PRINT 'CarrierID is empty';
	THROW 55667, 'Check spelling',1;
	END
EXEC Factory_Nested
@FactoryName2=@FactoryName,
@FactoryID2=@FactoryID OUTPUT

/*Idk for what reason, but several times the error occured claiming that Factory couldn't be found.
But I need to save the ID integrity to manage tblMANIFEST population later (PO and shipment matching),
so instead of returning the whole proccess, 
I added supplemental column FactoryStat in tblSHIPMENT to define which row lost its factory*/ 
IF @FactoryID IS NULL
BEGIN
	SET @FactStat='Not found'
	BEGIN TRANSACTION T1
	INSERT INTO tblSHIPMENT(ShipmentBeginDate, CarrierID, FactoryID, FactoryStat)
	VALUES (NULL,NULL,NULL,@FactStat)
	IF @@ERROR<>0
	BEGIN
	PRINT 'Smth went wrong during processing'
	ROLLBACK TRANSACTION T1
	END
	ELSE
	COMMIT TRANSACTION T1
END
ELSE
BEGIN
	SET @FactStat='Found'
	BEGIN TRANSACTION T2
	INSERT INTO tblSHIPMENT(ShipmentBeginDate, CarrierID, FactoryID,FactoryStat)
	VALUES (@ShipmentDate,@CarrierID,@FactoryID,@FactStat)
	IF @@ERROR<>0
	BEGIN
	PRINT 'Smth went wrong during processing'
	ROLLBACK TRANSACTION T1
	END
	ELSE
	COMMIT TRANSACTION T1
END
GO

CREATE OR ALTER PROCEDURE Wrapper_Shipment
AS
DECLARE @PO_ID INT, @CarrierCount INT, @FactoryCount INT
DECLARE @CarrierPK INT, @FactoryPK INT
DECLARE @MatchedCarrier VARCHAR(70), @MatchedFactory VARCHAR(70)
DECLARE @PO_Date DATE, @ShipmentDate DATE

SET @CarrierCount=(SELECT COUNT(*) FROM tblCARRIER)-1
SET @FactoryCount=(SELECT COUNT(*) FROM tblFACTORY)-1

DECLARE PO_Cursor CURSOR FOR
SELECT PO_ID FROM tblPURCHASE_ORDER

OPEN PO_Cursor;
FETCH NEXT FROM PO_Cursor INTO @PO_ID;
WHILE @@FETCH_STATUS=0
BEGIN
	SET @PO_Date=(SELECT PO_Date FROM tblPURCHASE_ORDER WHERE PO_ID=@PO_ID)
	SET @ShipmentDate=DATEADD(Day, FLOOR(RAND()*(10-5+1))+5, @PO_Date)
	SET @CarrierPK=(SELECT RAND()*@CarrierCount+1)
	SET @MatchedCarrier=(SELECT CarrierName FROM tblCARRIER WHERE CarrierID=@CarrierPK)
	SET @FactoryPK=(SELECT RAND()*@FactoryCount+1)
	SET @MatchedFactory=(SELECT FactoryName FROM tblFACTORY WHERE FactoryID=@FactoryPK)

	EXEC Shipment_Sproc
	@ShipmentDate=@ShipmentDate,
	@CarrierName=@MatchedCarrier,
	@FactoryName=@MatchedFactory

	FETCH NEXT FROM PO_Cursor INTO @PO_ID;
END
CLOSE PO_Cursor;
DEALLOCATE PO_Cursor;
GO
EXEC Wrapper_Shipment
GO




-- tblSHIPMENT_STATUS --
CREATE OR ALTER PROCEDURE ShipStatusSproc
AS
BEGIN
--@Prob stands for probablility. It defines if a shipment will be canceled or not.
DECLARE @Ship_ID INT, @BaseDate DATE, @NextDate DATE, @ShipStatusDate DATE, @Prob FLOAT,
@TransitType VARCHAR(10)

DECLARE ShipStatus CURSOR FOR
SELECT ShipmentID FROM tblSHIPMENT
WHERE ShipmentBeginDate IS NOT NULL --added a filter to skip the 'bad' lines

OPEN ShipStatus;
FETCH NEXT FROM ShipStatus INTO @Ship_ID;

WHILE @@FETCH_STATUS=0
BEGIN
	--Base date won't change per fecth cycle
	SET @BaseDate=(SELECT ShipmentBeginDate FROM tblSHIPMENT WHERE ShipmentID=@Ship_ID)

	--if a probability of a random number is less or equal to 10% then a shipment will be cancelled
	SET @Prob=RAND()
	IF @Prob<=0.1
	BEGIN
		SET @NextDate=DATEADD(DAY, FLOOR((RAND()*5)+1), @BaseDate) --from 1 to 5 days to determine
		INSERT INTO tblSHIPMENT_STATUS(ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Cancelled'))
	END
	ELSE
	BEGIN
		INSERT INTO tblSHIPMENT_STATUS(ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@BaseDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Picked Up'))

--Manage cases where transit type (air/sea) chosed randomly
		SET @TransitType=CASE WHEN RAND()<0.5 THEN 'Sea' ELSE 'Air' END; 
		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @BaseDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName= CONCAT('In Transit (',@TransitType,')')));

--Continue to insert default statuses
		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Arrived at Port'));

		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Customs Clearance'));

		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Customs Hold'));

		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='At Warehouse'));

		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Quality Inspection'));

		SET @NextDate = DATEADD(DAY, FLOOR(RAND()*5)+1, @NextDate);
		INSERT INTO tblSHIPMENT_STATUS (ShipmentStatusDate, ShipmentID, StatusID)
		VALUES (@NextDate, @Ship_ID, (SELECT StatusID FROM tblSTATUS WHERE StatusName='Delivered to Factory'));
	END
	FETCH NEXT FROM ShipStatus INTO @Ship_ID;
END
CLOSE ShipStatus;
DEALLOCATE ShipStatus
END
GO
EXEC ShipStatusSproc
GO




-- tblBILL_OF_LADING --
CREATE OR ALTER PROCEDURE BOL_Sproc
@ShipmentID INT
AS
DECLARE @BOL_Date DATE
SET @BOL_Date=(DATEADD(DAY,1,(SELECT ShipmentStatusDate FROM tblSHIPMENT_STATUS ST
				JOIN tblSTATUS S ON S.StatusID=ST.StatusID
				JOIN tblSHIPMENT SP ON ST.ShipmentID=SP.ShipmentID
				WHERE S.StatusName='Delivered to Factory'
				AND SP.ShipmentID=@ShipmentID))) --filtering of shipment that were not commited or 
				--without matched factories ain't working there, because it's just a nested procedure
IF @BOL_Date IS NOT NULL
BEGIN
BEGIN TRANSACTION T1
INSERT INTO tblBILL_OF_LADING (ShipmentID, BOL_Date)
VALUES (@ShipmentID, @BOL_Date)
IF @@ERROR<>0
BEGIN
PRINT 'Smth went wrong, rollbacking transaction'
ROLLBACK TRANSACTION T1
END
ELSE
COMMIT TRANSACTION T1
END
ELSE
RETURN

GO

CREATE OR ALTER PROCEDURE BOL_Wrapper
AS
DECLARE @Ship_ID INT
DECLARE Shipment CURSOR FOR
SELECT S.ShipmentID
FROM tblSHIPMENT S
WHERE NOT EXISTS (
    SELECT 1
    FROM tblSHIPMENT_STATUS ST
    WHERE ST.ShipmentID = S.ShipmentID
      AND ST.StatusID = 10
)

OPEN Shipment;
FETCH NEXT FROM Shipment INTO @Ship_ID

WHILE @@FETCH_STATUS=0
BEGIN
EXEC BOL_Sproc
@ShipmentID=@Ship_ID
FETCH NEXT FROM Shipment INTO @Ship_ID
END
CLOSE Shipment;
DEALLOCATE Shipment;
GO
EXEC BOL_Wrapper
GO



-- tblBOL_DISCOUNT --
/*We have two types of discount calculation: percentage and fixed amount per shipment.
One bol can have 1-3 fixed discounts and 1-2 percantage-based. The max quantity of disc- 5.*/
CREATE OR ALTER PROCEDURE Wrapper_BOLDisc
AS

DECLARE @BOL_ID INT, @Rnd FLOAT, @Cycle INT, @Value INT, @i INT, @Prev_Val INT=0

DECLARE BOLDisc CURSOR FOR
SELECT BOL_ID FROM tblBILL_OF_LADING

OPEN BOLDisc;
FETCH NEXT FROM BOLDisc INTO @BOL_ID

WHILE @@FETCH_STATUS=0
BEGIN
--there we use the whole variable @Rnd, beacuse we have 3 cases, not 2
--proceeding fixed discounts
	SET @Rnd=RAND()
	SET @Cycle=CASE 
	WHEN @Rnd<0.35 THEN 1
	WHEN @Rnd<0.70 AND @Rnd>0.35 THEN 2
	ELSE 3
	END
	SET @i=1

	WHILE @i<=@Cycle
	BEGIN
		SET @Value=(FLOOR(rand()*10+1)) --picking a random discount id from 1 to 10
		IF @Value=@Prev_Val --one shipment can't have the same 2 discs, so we eliminating repetitions
		begin
		SET @i=@i-1 --instead of continue, etc, we just compensate cycle clock
		end
		ELSE
		INSERT INTO tblBOL_DISCOUNT(BOL_ID, DiscountID)
		VALUES (@BOL_ID, @Value)
		SET @Prev_Val=@Value --giving @Prev_Val new value to avoid repetitions
		SET @i=@i+1
	END

	--start proceeding [ercentage-based discounts
	SET @Cycle=CASE WHEN RAND()<0.5 THEN 1 ELSE 2 END
	SET @i=1

	WHILE @i<=@Cycle
	BEGIN
		SET @Value=FLOOR(RAND()*(15-11+1))+11 --selecting ID's from 11 to 15
		IF @Value=@Prev_Val
		begin
		SET @i=@i-1
		end
		ELSE
		INSERT INTO tblBOL_DISCOUNT(BOL_ID, DiscountID)
		VALUES (@BOL_ID, @Value)
		SET @Prev_Val=@Value
		SET @i=@i+1
	 END
	 FETCH NEXT FROM BOLDisc INTO @BOL_ID;
END
CLOSE BOLDisc;
DEALLOCATE BOLDisc;
GO
EXEC Wrapper_BOLDisc
GO




-- tblWORK_ORDER --
CREATE OR ALTER PROCEDURE WorkOrder_Sproc
@FactoryID VARCHAR(150),
@Quantity INT,
@BeginDate DATE,
@DueDate DATE
AS
BEGIN TRANSACTION T1
	INSERT INTO tblWORK_ORDER (FactoryID, DistProdQuantity, BeginDate, DueDate)
	VALUES (@FactoryID, @Quantity, @BeginDate, @DueDate)
	IF @@ERROR<>0
	BEGIN
	PRINT 'Smth went wrong during transaction...'
	ROLLBACK TRANSACTION B1
	END
	ELSE
	BEGIN
COMMIT TRANSACTION T1
END
GO


CREATE OR ALTER PROCEDURE WorkOrder_Cursor
AS
DECLARE @ShipmentID INT, @FactoryID1 INT, @BeginDate1 DATE, 
@DueDate1 DATE, @Quantity1 INT

DECLARE ShipmentWO CURSOR FOR
SELECT ShipmentID FROM tblSHIPMENT
WHERE ShipmentEndDate IS NOT NULL

OPEN ShipmentWO;
FETCH NEXT FROM ShipmentWO INTO @ShipmentID

WHILE @@FETCH_STATUS=0
BEGIN
SET @FactoryID1=(SELECT FactoryID FROM tblSHIPMENT WHERE ShipmentID=@ShipmentID);
SET @BeginDate1=DATEADD(DAY,FLOOR(RAND()*8)+4,(SELECT ShipmentEndDate FROM tblSHIPMENT WHERE ShipmentID=@ShipmentID))
--ideally, it meant to be 3-10 from BOL_Date, but I just made it 4-11 from ShipmentEndDate 
--(the difference between ShipmentEndDate and BOL_Date is one day, so I just included it in calculation
SET @DueDate1=DATEADD(DAY, FLOOR(RAND()*25)+21,@BeginDate1)
SET @Quantity1=FLOOR(RAND()*7)+7

EXEC WorkOrder_Sproc
@FactoryID=@FactoryID1,
@Quantity=@Quantity1,
@BeginDate=@BeginDate1,
@DueDate=@DueDate1

FETCH NEXT FROM ShipmentWO INTO @ShipmentID
END
CLOSE ShipmentWO
DEALLOCATE ShipmentWO
GO
EXEC WorkOrder_Cursor
GO




-- tblWORK_ORDER_ITEMS --
CREATE OR ALTER PROCEDURE WorkOrderItems_Cursor
AS
DECLARE @WorkOrderID INT, @ProductID INT, @Quantity INT, @Prod_Count INT=(SELECT COUNT(*) FROM tblPRODUCT),
@Cycle INT

DECLARE WorkOrder CURSOR FOR
SELECT WorkOrderID FROM tblWORK_ORDER

OPEN WorkOrder
FETCH NEXT FROM WorkOrder INTO @WorkOrderID

WHILE @@FETCH_STATUS=0
BEGIN
SET @Cycle=(SELECT DistProdQuantity FROM tblWORK_ORDER WHERE WorkOrderID=@WorkOrderID)

WHILE @Cycle>0
BEGIN
SET @ProductID=FLOOR(RAND()*@Prod_Count)+1
--to prevent duplicates of products in one WO
IF EXISTS (
    SELECT 1 
    FROM tblWORK_ORDER_ITEMS 
    WHERE WorkOrderID = @WorkOrderID 
      AND ProductID = @ProductID
)
CONTINUE --I'm using here continue, because I don't have a risk to fall into endless cycle like in BOL_DISCOUNT
         --since number of distinct prod per one WO (Cycle) is much less that the whole product catalog
ELSE
SET @Quantity= FLOOR(RAND()*4001)+2000
INSERT INTO tblWORK_ORDER_ITEMS (WorkOrderID, ProductID, Quantity)
VALUES (@WorkOrderID, @ProductID, @Quantity)
SET @Cycle=@Cycle-1
END
FETCH NEXT FROM WorkOrder INTO @WorkOrderID
END
CLOSE WorkOrder;
DEALLOCATE WorkOrder
GO
EXEC WorkOrderItems_Cursor
GO




-- tblPURCHASE_ORDER_LINE --
CREATE OR ALTER PROCEDURE PO_Line_Cursor
AS
BEGIN
DECLARE @PO_ID INT, @MatSupID INT, @MatSupCount INT=(SELECT COUNT(*) FROM tblMATERIAL_SUPPLIER),
@Cycle INT, @Quantity INT

DECLARE PO CURSOR FOR
SELECT PO_ID FROM tblPURCHASE_ORDER

OPEN PO
FETCH NEXT FROM PO INTO @PO_ID

WHILE @@FETCH_STATUS=0
BEGIN
	SET @Cycle=FLOOR(RAND()*61)+70
	WHILE @Cycle>0
	BEGIN
	SET @MatSupID=FLOOR(RAND()*@MatSupCount)+1
	/*IF EXISTS (
		SELECT 1 
		FROM tblPURCHASE_ORDER_LINE
		WHERE PO_ID=@PO_ID AND
		MaterialSupplierID=@MatSupID)
	BEGIN
	CONTINUE
	END
	ELSE*/
	SET @Quantity=FLOOR(RAND()*2001)+3000
	INSERT INTO tblPURCHASE_ORDER_LINE(PO_ID, MateriaLSupplierID, OrderedQuantity)
	VALUES (@PO_ID, @MatSupID, @Quantity)
	SET @Cycle=@Cycle-1
	END
	FETCH NEXT FROM PO INTO @PO_ID
END

CLOSE PO;
DEALLOCATE PO
END
GO
EXEC PO_Line_Cursor
GO




-- tblBOL_LINE --
INSERT INTO tblBOL_LINE (BOL_ID, PO_LineID, ActualQuantity)
SELECT 
    bol.BOL_ID,
    pol.PO_LineID,
    pol.OrderedQuantity * (0.9 + (RAND() * 0.15))
FROM tblBILL_OF_LADING bol
JOIN tblPURCHASE_ORDER po 
    ON bol.ShipmentID = po.PO_ID
JOIN tblPURCHASE_ORDER_LINE pol 
    ON po.PO_ID = pol.PO_ID;
GO




-- tblSHIPMENT_FEE --
/* there are 3 types oof fees: percentage-based, fixed per shipment, fixed per day.
One shipment will have 2 percentage, 3-4 fixed per shipment, 0-2 fixed per day.*/
CREATE OR ALTER PROCEDURE ShipFee
AS
DECLARE @ShipmentID INT, @Value INT, @Prev_Val INT=0, @I INT=1, @Cycle INT, @Rnd FLOAT

DECLARE Fee CURSOR FOR
SELECT ShipmentID FROM tblSHIPMENT
WHERE ShipmentEndDate IS NOT NULL
OPEN Fee;
FETCH NEXT FROM Fee INTO @ShipmentID
WHILE @@FETCH_STATUS=0
BEGIN

WHILE @I < 3
BEGIN
    SET @Value = FLOOR(RAND() * 5) + 1
    IF @Value <> @Prev_Val
    BEGIN
        INSERT INTO tblSHIPMENT_FEE(ShipmentID, FeeID)
        VALUES (@ShipmentID, @Value)
        SET @Prev_Val = @Value
        SET @I = @I + 1
    END
END

SET @Cycle=CASE WHEN RAND()<0.50 THEN 3 ELSE 4 END
SET @I=1
WHILE @I <= @Cycle
BEGIN
    SET @Value = (FLOOR(RAND()*6+6))
    IF @Value <> @Prev_Val
    BEGIN
        INSERT INTO tblSHIPMENT_FEE(ShipmentID, FeeID)
        VALUES (@ShipmentID, @Value)
        SET @Prev_Val = @Value
        SET @I = @I + 1
    END
END

SET @Rnd=RAND()
SET @Cycle=CASE 
WHEN @Rnd<0.35 THEN 0
WHEN @Rnd<0.70 THEN 1
ELSE 2
END
SET @I=1
WHILE @I <= @Cycle
BEGIN
    SET @Value = FLOOR(RAND()*2 + 12)
    IF @Value <> @Prev_Val
    BEGIN
        INSERT INTO tblSHIPMENT_FEE(ShipmentID, FeeID)
        VALUES (@ShipmentID, @Value)
        SET @Prev_Val = @Value
        SET @I = @I + 1
    END
END
FETCH NEXT FROM Fee INTO @ShipmentID
END
CLOSE Fee;
DEALLOCATE Fee
GO
EXEC ShipFee
GO
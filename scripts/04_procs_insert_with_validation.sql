/*=============================================================
  04 — PROCEDURES: MASTER DATA INSERTS
  Insert procedures with name-to-ID resolution via nested
  procedures, NULL checks and transaction handling.
  Creates procedures only — inserts nothing.
  Depends on: 01
=============================================================*/
-- tblFEE --
CREATE OR ALTER PROCEDURE FeeNestedSPROC
@FeeTypeName2 VARCHAR(70),
@FeeTypeID2 INT OUTPUT
AS
SET @FeeTypeID2=(SELECT FeeTypeID FROM tblFEE_TYPE WHERE FeeTypeName=@FeeTypeName2)
GO

CREATE OR ALTER PROCEDURE FeeSPROC
@FeeName VARCHAR(50),
@FeeAmount DECIMAL(8,2),
@FeeTypeName VARCHAR(70),
@FeeDescr VARCHAR(500)
AS
DECLARE @FeeTypeID INT
    EXEC FeeNestedSPROC
	@FeeTypeName2=@FeeTypeName,
	@FeeTypeID2=@FeeTypeID OUTPUT

IF @FeeTypeID IS NULL
BEGIN
    PRINT 'The FeeTypeID is empty, check spelling!';
	THROW 55667, 'Try again!',1;
END

BEGIN TRANSACTION T1
    INSERT INTO tblFEE(FeeName, FeeAmount, FeeTypeID, FeeDescr)
    VALUES (@FeeName, @FeeAmount, @FeeTypeID, @FeeDescr)
    IF @@ERROR<>0
	BEGIN
	    PRINT 'Something went wrong, rollbacking transaction'
		ROLLBACK TRANSACTION T1
	END
	ELSE
	COMMIT TRANSACTION
GO




-- tblMATERIAL --
CREATE OR ALTER PROCEDURE MaterialNestedTypeSPROC
@MTName2 VARCHAR(70),
@MTID2 INT OUTPUT
AS
SET @MTID2=(SELECT MaterialTypeID FROM tblMATERIAL_TYPE WHERE MaterialTypeName=@MTName2)
GO

CREATE OR ALTER PROCEDURE MaterialNestedUnitSPROC
@UOMName2 NVARCHAR(30),
@UOMID2 INT OUTPUT
AS
SET @UOMID2=(SELECT UOM_ID FROM tblUNIT_OF_MEASURE WHERE UOM_Name=@UOMName2)
GO

CREATE OR ALTER PROCEDURE MaterialSPROC
@MaterialTypeName VARCHAR(70),
@UOMName NVARCHAR(30),
@MaterialName VARCHAR(50),
@MaterialDescr VARCHAR(500)
AS
 DECLARE @MTID INT, @UOMID INT

    EXEC MaterialNestedUnitSPROC
    @UOMName2=@UOMName,
    @UOMID2=@UOMID OUTPUT

	IF @UOMID IS NULL
	BEGIN
	PRINT 'UOMID is empty';
	THROW 55667, 'Check spelling',1
	END

    EXEC MaterialNestedTypeSPROC
    @MTName2=@MaterialTypeName,
    @MTID2=@MTID OUTPUT

	IF @MTID IS NULL
	BEGIN
	PRINT 'MaterialTypeID is empty';
	THROW 55667, 'Check spelling',1
	END

BEGIN TRANSACTION T1
     INSERT INTO tblMATERIAL(MaterialTypeID, UOM_ID, MaterialName, MaterialDescr)
	 VALUES (@MTID, @UOMID, @MaterialName, @MaterialDescr)

	 IF @@ERROR<>0
	 BEGIN
	     PRINT 'Something went wrong, try again';
		 PRINT 'The material has probably already been inserted';
		 PRINT @MaterialName
		 ROLLBACK TRANSACTION T1
	 END
	 ELSE
	 COMMIT TRANSACTION
GO



-- tblDISCOUNT --
CREATE OR ALTER PROCEDURE NestedDiscountSPROC
@DiscountTypeName2 VARCHAR(50),
@DiscountTypeID2 INT OUTPUT
AS
SET @DiscountTypeID2=(SELECT DiscountTypeID FROM tblDISCOUNT_TYPE WHERE DiscountTypeName=@DiscountTypeName2)
GO
CREATE OR ALTER PROCEDURE DiscountSPROC
@DiscountName VARCHAR(100),
@DiscountTypeName VARCHAR(50),
@DiscountAmount DECIMAL(7,2),
@DiscountDescr VARCHAR(400)
AS
DECLARE @DiscountTypeID INT
EXEC NestedDiscountSPROC
@DiscountTypeName2=@DiscountTypeName,
@DiscountTypeID2=@DiscountTypeID OUTPUT
IF @DiscountTypeID IS NULL
BEGIN
PRINT 'DiscountTypeID is empty';
THROW 55667, 'Check spelling', 1;
END

BEGIN TRANSACTION T1
INSERT INTO tblDISCOUNT (DiscountName, DiscountTypeID, DiscountAmount, DiscountDescr)
VALUES (@DiscountName, @DiscountTypeID, @DiscountAmount, @DiscountDescr)
IF @@ERROR<>0
BEGIN
PRINT 'Smth went wrong, try again'
ROLLBACK TRANSACTION T1
END
ELSE
COMMIT TRANSACTION T1
GO




-- tblSUPPLIER --
CREATE OR ALTER PROCEDURE SupplierNestedTypeSPROC
@STypeName2 VARCHAR(50),
@STypeID2 INT OUTPUT
AS
SET @STypeID2=(SELECT SupplierTypeID FROM tblSUPPLIER_TYPE WHERE SupplierTypeName=@STypeName2)
GO

CREATE OR ALTER PROCEDURE SupplierNestedCountrySPROC
@SCountryName2 VARCHAR(50),
@SCountryID2 INT OUTPUT
AS
SET @SCountryID2=(SELECT SupCountryID FROM tblSUP_COUNTRY WHERE SupCountryName=@SCountryName2)
GO

CREATE OR ALTER PROCEDURE SupplierSPROC
@STypeName VARCHAR(50),
@SupplierName VARCHAR(100),
@Address VARCHAR (150),
@SCountryName VARCHAR(50)
AS
DECLARE @STypeID INT, @SCountryID INT
EXEC SupplierNestedTypeSPROC
@STypeName2=@STypeName,
@STypeID2=@STypeID OUTPUT

IF @STypeID IS NULL
BEGIN
PRINT 'SupplierTypeID is empty';
THROW 55667, 'Check SupplierTypeName spelling',1
END

EXEC SupplierNestedCountrySPROC
@SCountryName2=@SCountryName,
@SCountryID2=@SCountryID OUTPUT

IF @SCountryID IS NULL
BEGIN
PRINT 'SupplierCountryID is empty';
THROW 55667, 'Check SupplierCountryName spelling',1
END

BEGIN TRANSACTION T1
INSERT INTO tblSUPPLIER (SupplierTypeID, SupplierName, Address, SupCountryID)
VALUES (@STypeID, @SupplierName, @Address, @SCountryID)

IF @@ERROR<>0
BEGIN
PRINT 'Smth went wrong< try again'
ROLLBACK TRANSACTION T1
END
ELSE
COMMIT TRANSACTION T1
GO




-- tblMATERIAL_SUPPLIER --
CREATE OR ALTER PROCEDURE MaterialNestedSPROC
@MaterialName2 VARCHAR(60),
@MaterialID2 INT OUTPUT
AS
SET @MaterialID2=(SELECT MaterialID FROM tblMATERIAL WHERE MaterialName=@MaterialName2)
GO

CREATE OR ALTER PROCEDURE SupplierNestedSPROC
@SupplierName2 VARCHAR(100),
@SupplierID2 INT OUTPUT
AS 
SET @SupplierID2=(SELECT SupplierID FROM tblSUPPLIER WHERE SupplierName=@SupplierName2)
GO

CREATE OR ALTER PROCEDURE MatSup
@MaterialName VARCHAR(60),
@SupplierName VARCHAR(100),
@Price DECIMAL(8,2)
AS
DECLARE @MaterialID INT, @SupplierID INT
EXEC MaterialNestedSPROC
@MaterialName2=@MaterialName,
@MaterialID2=@MaterialID OUTPUT
	IF @MaterialID IS NULL
	BEGIN
		PRINT 'MaterialID is empty.';
		THROW 55667, 'Check spelling',1
	END

EXEC SupplierNestedSPROC
@SupplierName2=@SupplierName,
@SupplierID2=@SupplierID OUTPUT
	IF @SupplierID IS NULL
	BEGIN
		PRINT 'SupplierID is empty.';
		THROW 55667, 'Check spelling',1
	END

BEGIN TRANSACTION T1
	INSERT INTO tblMATERIAL_SUPPLIER (MaterialID, SupplierID, [Price (USD)])
	VALUES (@MaterialID, @SupplierID, @Price)

	IF @@ERROR<>0
	BEGIN
		PRINT 'Smth went wrong'
		ROLLBACK TRANSACTION T1
	END
	ELSE
COMMIT TRANSACTION T1
GO




-- tblPRODUCT --
CREATE OR ALTER PROCEDURE ProductTypeNestedSPROC
@ProductType2 VARCHAR(50),
@ProductTypeID2 INT OUTPUT
AS
SET @ProductTypeID2=(SELECT ProductTypeID FROM tblPRODUCT_TYPE WHERE ProductTypeName=@ProductType2)
GO

CREATE OR ALTER PROCEDURE ProductSPROC
@ProductName VARCHAR (70),
@ProductType VARCHAR (50)
AS
DECLARE @ProductTypeID INT
EXEC ProductTypeNestedSPROC
@ProductType2=@ProductType,
@ProductTypeID2=@ProductTypeID OUTPUT

IF @ProductTypeID IS NULL
BEGIN
PRINT 'ProductTypeID is empty';
THROW 55667, 'Check spelling',1
END

BEGIN TRANSACTION T1
INSERT INTO tblPRODUCT(ProductTypeID, ProductName)
VALUES (@ProductTypeID, @ProductName)

IF @@ERROR<>0
	BEGIN
	    PRINT 'Something went wrong, rollbacking transaction'
		ROLLBACK TRANSACTION T1
	END
	ELSE
	COMMIT TRANSACTION
GO




-- tblBILL_OF_MATERIAL --
CREATE OR ALTER PROCEDURE ProductNestedSPROC
@ProductName2 VARCHAR(100),
@ProductID2 INT OUTPUT
AS
SET @ProductID2=(SELECT ProductID FROM tblPRODUCT WHERE ProductName=@ProductName2)
GO

CREATE OR ALTER PROCEDURE BOMSPROC
@ProductName VARCHAR(100),
@MaterialName VARCHAR(100),
@Quantity DECIMAL(8,2)
AS
DECLARE @ProductID INT, @MaterialID INT
EXEC ProductNestedSPROC
@ProductName2=@ProductName,
@ProductID2=@ProductID OUTPUT
	IF @ProductID IS NULL
	BEGIN
	PRINT 'ProductID is empty';
	THROW 55667, 'Check spelling', 1
	END
EXEC MaterialNestedSPROC
@MaterialName2=@MaterialName,
@MaterialID2=@MaterialID OUTPUT
	IF @MaterialID IS NULL
	BEGIN
	PRINT 'MaterialID is empty.';
	THROW 55667, 'Check spelling',1
	END

BEGIN TRANSACTION T1
INSERT INTO tblBILL_OF_MATERIAL(ProductID, MaterialID, Quantity)
VALUES (@ProductID, @MaterialID, @Quantity)
	IF @@ERROR<>0
	BEGIN
	PRINT 'Smth went wrong'
	ROLLBACK TRANSACTION T1
	END
	ELSE
COMMIT TRANSACTION T1
GO
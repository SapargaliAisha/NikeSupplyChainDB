/*=============================================================
  06 — COMPUTED COLUMNS
  Scalar functions and the computed columns built on them.
  Must run before 07: ShipFee filters on ShipmentEndDate.
  Depends on: 01
=============================================================*/
-- tblMATERIAL CompColumn --
CREATE FUNCTION FN_Calc_Material (@PK INTEGER)
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER= (SELECT COUNT(*) FROM tblBILL_OF_MATERIAL BOM
JOIN tblMATERIAL M ON M.MaterialID=BOM.MaterialID
WHERE BOM.MaterialID=@PK)
    BEGIN
	RETURN @RET
	END
END
GO
ALTER TABLE tblMATERIAL
ADD UsedInProd AS (dbo.FN_Calc_Material(MaterialID))
GO




-- tblPRODUCT CompColumn --
CREATE FUNCTION FN_Calc_YTD (@PK INTEGER)
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER=(SELECT COUNT(*) 
FROM tblWORK_ORDER_ITEMS WOI
JOIN tblPRODUCT P ON WOI.ProductID=P.ProductID
JOIN tblWORK_ORDER WO ON WO.WorkOrderID=WOI.WorkOrderID
WHERE WOI.ProductID=@PK
AND WO.DueDate>=DATEFROMPARTS(YEAR(GETDATE()),1,1)
AND WO.DueDate<GETDATE())
    BEGIN
        RETURN @RET
    END
END
GO

ALTER TABLE tblPRODUCT
ADD YTD_prod_units AS (dbo.FN_Calc_YTD(ProductID))
GO




-- tblSHIPMENT CompColumn --
CREATE FUNCTION FN_ShipmentEndDate(@PK INT)
RETURNS DATE
AS
BEGIN
DECLARE @EndDate DATE=(SELECT SS.ShipmentStatusDate FROM tblSHIPMENT_STATUS SS
					JOIN tblSTATUS ST ON ST.StatusID=SS.StatusID
					JOIN tblSHIPMENT SH ON SS.ShipmentID=SH.ShipmentID
					WHERE ST.StatusName='Delivered to Factory'
					AND SS.ShipmentID=@PK AND SH.ShipmentID=@PK)
	BEGIN
	RETURN @EndDate
	END
END
GO
ALTER TABLE tblSHIPMENT
ADD ShipmentEndDate AS (dbo.FN_ShipmentEndDate(ShipmentID))
GO

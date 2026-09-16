/*=============================================================
  03 — LOAD: GEOGRAPHY AND FACTORIES
  Derives regions, countries and factories from the raw Nike
  factory list. Uses tblABBREV as a temporary mapping table.
  Depends on: 01, 02, and the imported tblFactoriesDATA
=============================================================*/
-- tblREGION --
INSERT INTO tblREGION (RegionName)
SELECT DISTINCT Region
FROM tblFactoriesDATA
WHERE Region IS NOT NULL;

UPDATE tblREGION
SET RegionDescr = 'combined geographic area of North, Central, and South America'
WHERE RegionName = 'AMERICAS'
GO
UPDATE tblREGION
SET RegionDescr = 'Europe, the Middle East, and Africa'
WHERE RegionName = 'EMEA'
GO
UPDATE tblREGION
SET RegionDescr='Southeast Asia'
WHERE RegionName='SE ASIA'




-- tblCOUNTRY --
--created temporary repository 'tblABBREV'--
CREATE TABLE tblABBREV(
CountryName VARCHAR(50),
CountryAbbrev VARCHAR(50))
GO
INSERT INTO tblABBREV(CountryName)
SELECT DISTINCT Country
FROM tblFactoriesDATA;
GO
CREATE OR ALTER PROCEDURE AbbrevForMappingTable
@Country varchar(50),
@Abbreviation varchar(10)
AS
BEGIN
   BEGIN TRANSACTION;
   UPDATE tblABBREV
   SET CountryAbbrev=@Abbreviation
   WHERE CountryName=@Country;

   IF @@ERROR<>0
       BEGIN
	   PRINT 'Something went wrong, try again';
	   ROLLBACK TRANSACTION;
	   END
	   ELSE
	   BEGIN
	   COMMIT TRANSACTION;
	   END
END
GO
EXEC AbbrevForMappingTable 'Argentina','ARG'
EXEC AbbrevForMappingTable 'Bosnia','BiH'
EXEC AbbrevForMappingTable 'Brazil','BR'
EXEC AbbrevForMappingTable 'Cambodia','KHM'
EXEC AbbrevForMappingTable 'Canada','CAN'
EXEC AbbrevForMappingTable 'China','CN'
EXEC AbbrevForMappingTable 'Egypt','EG'
EXEC AbbrevForMappingTable 'El Salvador','SLV'
EXEC AbbrevForMappingTable 'France','FR'
EXEC AbbrevForMappingTable 'Georgia','GA'
EXEC AbbrevForMappingTable 'Guatemala','GT'
EXEC AbbrevForMappingTable 'Honduras','HN'
EXEC AbbrevForMappingTable 'India','IND'
EXEC AbbrevForMappingTable 'Indonesia','ID'
EXEC AbbrevForMappingTable 'Israel','ISL'
EXEC AbbrevForMappingTable 'Italy','IT'
EXEC AbbrevForMappingTable 'Japan','JP'
EXEC AbbrevForMappingTable 'Jordan','JO'
EXEC AbbrevForMappingTable 'Laos','LAO'
EXEC AbbrevForMappingTable 'Lithuania','LT'
EXEC AbbrevForMappingTable 'Malaysia','MY'
EXEC AbbrevForMappingTable 'Mexico','MX'
EXEC AbbrevForMappingTable 'Moldova','MD'
EXEC AbbrevForMappingTable 'Netherlands','NL'
EXEC AbbrevForMappingTable 'Nicaragua','NI'
EXEC AbbrevForMappingTable 'Pakistan','PK'
EXEC AbbrevForMappingTable 'Philippines','PH'
EXEC AbbrevForMappingTable 'South Africa','SA'
EXEC AbbrevForMappingTable 'South Korea','KR'
EXEC AbbrevForMappingTable 'Spain','ES'
EXEC AbbrevForMappingTable 'Sri Lanka','LK'
EXEC AbbrevForMappingTable 'Taiwan','TW'
EXEC AbbrevForMappingTable 'Thailand','TH'
EXEC AbbrevForMappingTable 'Turkey','TR'
EXEC AbbrevForMappingTable 'United Kingdom','UK'
EXEC AbbrevForMappingTable 'USA','USA'
EXEC AbbrevForMappingTable 'Vietnam','VN'

-- tblCOUNTRY insertion --
INSERT INTO tblCOUNTRY (CountryName, CountryAbbrev, RegionID)
SELECT DISTINCT F.Country, A.CountryAbbrev, R.RegionID
FROM tblFactoriesDATA F
JOIN tblABBREV A ON A.CountryName=F.Country
JOIN tblREGION R ON F.Region=R.RegionName;




-- tblFACTORY --
INSERT INTO tblFACTORY (FactoryName, Address, City, State, PostalCode, CountryID)
SELECT DISTINCT F.FactoryName, F.Address, F.City, F.State, F.PostalCode, C.CountryID
FROM tblFactoriesDATA F
JOIN tblCOUNTRY C ON C.CountryName=F.Country
GO
DROP TABLE tblABBREV
GO









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








/*=============================================================
  05 — SEED: MASTER DATA
  Executes the procedures from 04 to load fees, materials,
  suppliers, products and the bill of materials.
  Depends on: 01, 02, 04
=============================================================*/
--tblFEE--
EXEC FeeSPROC
@FeeName='Customs Duty',
@FeeAmount='8',
@FeeTypeName='Percentage-based',
@FeeDescr='Government import tax'
EXEC FeeSPROC
@FeeName='VAT on Import',
@FeeAmount='15',
@FeeTypeName='Percentage-based',
@FeeDescr='Value-added tax applied on import'
EXEC FeeSPROC
@FeeName='Fuel Surcharge',
@FeeAmount='4',
@FeeTypeName='Percentage-based',
@FeeDescr='Applied due to fuel market fluctuation'
EXEC FeeSPROC
@FeeName='Insurance Coverage',
@FeeAmount='0.6',
@FeeTypeName='Percentage-based',
@FeeDescr='Shipment insurance protection'
EXEC FeeSPROC
@FeeName='Air Freight Charge',
@FeeAmount='22',
@FeeTypeName='Percentage-based',
@FeeDescr='Charge for air cargo transport'
EXEC FeeSPROC
@FeeName='Port Handling Fee',
@FeeAmount='520',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Port unloading and handling'
EXEC FeeSPROC
@FeeName='Documentation Fee',
@FeeAmount='125',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Cost for customs paperwork processing'
EXEC FeeSPROC
@FeeName='Security Surcharge',
@FeeAmount='55',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Anti-terrorism and cargo screening fees'
EXEC FeeSPROC
@FeeName='Ocean Freight Base Charge',
@FeeAmount='2100',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Base shipping cost on container transport'
EXEC FeeSPROC
@FeeName='Cross-Docking Fee',
@FeeAmount='140',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Direct warehouse transfer operations'
EXEC FeeSPROC
@FeeName='Final Mile Delivery Fee ',
@FeeAmount='480',
@FeeTypeName='Fixed amount per shipment (USD)',
@FeeDescr='Truck freight to final location'
EXEC FeeSPROC
@FeeName='Demurrage Charge',
@FeeAmount='150',
@FeeTypeName='Fixed amount per day (USD)',
@FeeDescr='Fee for delayed container pickup'
EXEC FeeSPROC
@FeeName='Terminal Storage Fee',
@FeeAmount='55',
@FeeTypeName='Fixed amount per day (USD)',
@FeeDescr='Fee for storing containers at port after escaping free period'
GO



-- tblMATERIAL --
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Textile Mesh',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Flyknit Yarn',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Cotton Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Polyester Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Nylon Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Spandex Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Terry Cloth',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Fleece',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Canvas',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Ripstop Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Leather',
@UOMName=N'm²',
@MaterialName='Nubuck Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Leather',
@UOMName=N'm²',
@MaterialName='Suede Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Leather',
@UOMName=N'm²',
@MaterialName='Patent Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Leather',
@UOMName=N'm²',
@MaterialName='Top-grain Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName=N'm²',
@MaterialName='PVC Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName=N'm²',
@MaterialName='Microfiber',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName=N'm²',
@MaterialName='PU Leather',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName=N'm²',
@MaterialName='TPU Film',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName='kg',
@MaterialName='EVA Sheets',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Foam',
@UOMName='kg',
@MaterialName='EVA Foam',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Foam',
@UOMName='kg',
@MaterialName='PU Foam',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Foam',
@UOMName='kg',
@MaterialName='Memory Foam',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Foam',
@UOMName='kg',
@MaterialName='Latex Foam',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Rubber',
@UOMName='kg',
@MaterialName='Natural Rubber',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Rubber',
@UOMName='kg',
@MaterialName='Synthetic Rubber',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Rubber',
@UOMName='kg',
@MaterialName='TPR Rubber',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Rubber',
@UOMName='pcs',
@MaterialName='Rubber Heel Plug',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='kg',
@MaterialName='TPU Heel Counter',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='pcs',
@MaterialName='Plastic eyelets',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='pcs',
@MaterialName='Plastic buckles',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='kg',
@MaterialName='Heel Shank',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='kg',
@MaterialName='PVC Inserts',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Metal',
@UOMName='pcs',
@MaterialName='Lace Hooks',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Metal',
@UOMName='pcs',
@MaterialName='Metal Buckles',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Metal',
@UOMName='pcs',
@MaterialName='Metal Eyelets',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Metal',
@UOMName='kg',
@MaterialName='Shank Reinforcement',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Elastic',
@UOMName='m',
@MaterialName='Elastic Band',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Elastic',
@UOMName='m',
@MaterialName='Bungee Cord',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Elastic',
@UOMName='m',
@MaterialName='Webbing with Elastic',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Textile',
@UOMName=N'm²',
@MaterialName='Mesh Lining',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Textile',
@UOMName=N'm²',
@MaterialName='Moisture-wicking Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Laminated Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Knit Fabric',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Foam',
@UOMName='kg',
@MaterialName='Molded Foam',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Synthetic',
@UOMName=N'm²',
@MaterialName='Synthetic Suede',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Leather',
@UOMName=N'm²',
@MaterialName='Leather Lining',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Plastic',
@UOMName='kg',
@MaterialName='Plastic Heel Cup',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Stretch Woven',
@MaterialDescr=''
EXEC MaterialSPROC
@MaterialTypeName='Fabric',
@UOMName=N'm²',
@MaterialName='Waterproof Membrane',
@MaterialDescr=''
GO




-- tblDISCOUNT --
EXEC DiscountSPROC
@DiscountName='Volume Purchase',
@DiscountTypeName='Percentage',
@DiscountAmount=5,
@DiscountDescr='Based on high order volume'
EXEC DiscountSPROC
@DiscountName='Early Payment',
@DiscountTypeName='Percentage',
@DiscountAmount=2,
@DiscountDescr='Pay invoice early to get discount'
EXEC DiscountSPROC
@DiscountName='Supplier Loyalty',
@DiscountTypeName='Percentage',
@DiscountAmount=3,
@DiscountDescr='Long-term repeat relationship discount'
EXEC DiscountSPROC
@DiscountName='Seasonal Supply',
@DiscountTypeName='Percentage',
@DiscountAmount=4,
@DiscountDescr='Applied in low demand seasons'
EXEC DiscountSPROC
@DiscountName='Contract Pricing',
@DiscountTypeName='Percentage',
@DiscountAmount=6,
@DiscountDescr='Fixed pricing negotiated in contract'
EXEC DiscountSPROC
@DiscountName='Promotional Deal',
@DiscountTypeName='Percentage',
@DiscountAmount=7,
@DiscountDescr='Temporary negotiation adjustment'
EXEC DiscountSPROC
@DiscountName='Currency Adjustment Discount',
@DiscountTypeName='Percentage',
@DiscountAmount=1.5,
@DiscountDescr='Exchange rate-based adjustment'
EXEC DiscountSPROC
@DiscountName='Sustainability Credit',
@DiscountTypeName='Percentage',
@DiscountAmount=2.5,
@DiscountDescr='Discount for recycled or low-emission materials'
EXEC DiscountSPROC
@DiscountName='Early Forecast Commitment',
@DiscountTypeName='Percentage',
@DiscountAmount=3.5,
@DiscountDescr='Discount for providing longer demand forecast'
EXEC DiscountSPROC
@DiscountName='Multi-Year Agreement',
@DiscountTypeName='Percentage',
@DiscountAmount=8,
@DiscountDescr='Applied for multi-year partnership'
EXEC DiscountSPROC
@DiscountName='Overproduction Clearance',
@DiscountTypeName='Fixed amount (USD)',
@DiscountAmount=750,
@DiscountDescr='Supplier clearing excess inventory'
EXEC DiscountSPROC
@DiscountName='Shipping Subsidy',
@DiscountTypeName='Fixed amount (USD)',
@DiscountAmount=500,
@DiscountDescr='Supplier covers part of logistics cost'
EXEC DiscountSPROC
@DiscountName='Sample Material Discount',
@DiscountTypeName='Fixed amount (USD)',
@DiscountAmount=300,
@DiscountDescr='Discount for small experimental batch'
EXEC DiscountSPROC
@DiscountName='Launch Support',
@DiscountTypeName='Fixed amount (USD)',
@DiscountAmount=1000,
@DiscountDescr='For new product line scale-up'
EXEC DiscountSPROC
@DiscountName='Joint Innovation Program',
@DiscountTypeName='Fixed amount (USD)',
@DiscountAmount=1500,
@DiscountDescr='Discount in R&D collaboration projects'
GO



-- tblSUPPLIER --
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Allesd',
@Address='No. 668, fengting Avenue, Suzhou Industrial Park, Jiangsu PROVINCE',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Fabric Merchants',
@Address='1430 S. Grande Vista Los Angeles, CA 90023',
@SCountryName='Los Angeles'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='iTokri',
@Address='A-7, Shri Krishna Nagar, Haider Ganj Lashkar, Gwalior, Madhya Pradesh',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Sino Silk',
@Address='5th Floor, East Building, Building 4, Xintiandi Business Centre, Gongshu District, Hangzhou, Zhejiang, China',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Lenzing AG',
@Address='Werkstraße 2, 4860 Lenzing',
@SCountryName='Austria'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Jcrafteco',
@Address='Siddharth Sadan, Near Galaxy Cinema, Opp Axis Bank, Naroda, Ahmedabad – 382330, Gujarat',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Eagle Fabrics',
@Address='1114 E. Walnut Street, Carson, CA 90746, US',
@SCountryName='USA'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Core Fabrics',
@Address='8280 Boul. Saint-Laurent, Montréal, QC H2P 2L8',
@SCountryName='Canada'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Ecological Textiles',
@Address='Marie Curieweg 3C, 6045 GH Roermond, the Netherlands',
@SCountryName='The Netherlands'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Libeco',
@Address='Tieltstraat 112, 8760 Meulebeke, Belgium',
@SCountryName='Belgium'
EXEC SupplierSPROC
@STypeName='Fabric Mill',
@SupplierName='Green Street Fabrics',
@Address='Groenestraat 24, 8501 Heule – Kortrijk, Belgium',
@SCountryName='Belgium'
EXEC SupplierSPROC
@STypeName='Tannery',
@SupplierName='PrimeAsia China',
@Address='Yue Yuen Industrial Park, Huangjiang Town, Dongguan, Guangdong Province, P.R.C.',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Tannery',
@SupplierName='PrimeAsia Indonesia',
@Address='Inti Center Building, 2/F, Jalan Taman',
@SCountryName='Indonesia'
EXEC SupplierSPROC
@STypeName='Tannery',
@SupplierName='Wollsdorf',
@Address='80 Unterfladnitz 8181 ',
@SCountryName='Austria'
EXEC SupplierSPROC
@STypeName='Tannery',
@SupplierName='Suppertannery',
@Address='Jajmau Road, Kanpur - 208010',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Tannery',
@SupplierName='Kongsiri tannery',
@Address='Ltd. 185 Moo 2 Sukhumvit Road Km.30, Tambon Taiban',
@SCountryName='Thailand'
EXEC SupplierSPROC
@STypeName='Foam & Rubber Supplier',
@SupplierName='FRS',
@Address='23 Carol Street, Clifton, NJ  07014',
@SCountryName='USA'
EXEC SupplierSPROC
@STypeName='Foam & Rubber Supplier',
@SupplierName='Zahonero',
@Address='C. Benelux, 91, 03600 Elda, Alicante, Spain',
@SCountryName='Spain'
EXEC SupplierSPROC
@STypeName='Foam & Rubber Supplier',
@SupplierName='Flexipol',
@Address='SP-812/B-3, Industrial Area, Phase -II, Bhiwadi – 301019',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Foam & Rubber Supplier',
@SupplierName='Synthomer',
@Address='London Headquarters 10 Greycoat Place London SW1P 1SB',
@SCountryName='UK'
EXEC SupplierSPROC
@STypeName='Foam & Rubber Supplier',
@SupplierName='Eva colors',
@Address='Esteban Alatorre 1481, San Juan Bosco, Guadalajara, Jalisco, Mexico',
@SCountryName='Mexico'
EXEC SupplierSPROC
@STypeName='Plastic Components Supplier',
@SupplierName='JV plastic',
@Address='B-50, Phase-1, Mayapuri Industrial Area, New Delhi-110064',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Plastic Components Supplier',
@SupplierName='Product City Co. Ltd.',
@Address='1/F So Tao Centre, 11-15 Kwai Sau Road, Kwai Chung, N.T.',
@SCountryName='Hong Kong'
EXEC SupplierSPROC
@STypeName='Trims & Elastics Supplier',
@SupplierName='Yusen Trims & Accessories',
@Address='Weide Road No.11, Hengli Town, Dongguan, Guangdong,',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Trims & Elastics Supplier',
@SupplierName='ECI',
@Address='No. 13, Xingye Rd., Fuxing Township, Changhua County 506, Taiwan (R.O.C.)',
@SCountryName='Taiwan'
EXEC SupplierSPROC
@STypeName='Trims & Elastics Supplier',
@SupplierName='Pro-Stretch',
@Address='17, John Bradshaw Court, Alexandria Way, Congleton, Cheshire CW12 1LB',
@SCountryName='UK'
EXEC SupplierSPROC
@STypeName='Trims & Elastics Supplier',
@SupplierName='MATSA Textiles',
@Address='Carrer de la Bauma, 35, 08296 Castellbell i el Vilar, Barcelona',
@SCountryName='Spain'
EXEC SupplierSPROC
@STypeName='Trims & Elastics Supplier',
@SupplierName='Lightspot',
@Address='Room 6, No.1, Longxi One New Village, Lishui South Road, Dali Town, Nanhai District, Foshan City, Guangdong Province, China 528231',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Footwear Hardware Supplier',
@SupplierName='Micromet',
@Address='Via del Maspino, 4/A – 52100 Arezzo',
@SCountryName='Italy'
EXEC SupplierSPROC
@STypeName='Footwear Hardware Supplier',
@SupplierName='Metalware Corporation',
@Address='C 49-50, Sector 63, Noida, U.P. (India)-201307',
@SCountryName='India'
EXEC SupplierSPROC
@STypeName='Footwear Hardware Supplier',
@SupplierName='Dongguan KingMing Hardware and Plastic Technology Co., Ltd.',
@Address='NO.196 LiaoFu Road LiaoFu Town DongGuan City, GuangDong Province China',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Footwear Hardware Supplier',
@SupplierName='Algeos',
@Address='Sheridan House Bridge Industrial Estate Speke Hall Road Liverpool, L24 9HB',
@SCountryName='UK'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='Nevotex',
@Address='Brogatan 12, 571 41 Nässjö Postal',
@SCountryName='Sweden'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='Micooson',
@Address='Haizhu District,Guangzhou City, Guangdong Province, 510330',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='Wandao Materials',
@Address='DongGuan Guangdong',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='Fu''an Synthetic Materials Co.,Ltd',
@Address='Fuan Industrial Park, Fuan Urbs, Dongtai urbs, Jiangsu Provincia',
@SCountryName='China'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='Crescent Textile Solutions',
@Address='1016 School St, Two Rivers, WI 54241',
@SCountryName='USA'
EXEC SupplierSPROC
@STypeName='Synthetic Supplier',
@SupplierName='YuSheng',
@Address='NO.2 SHANGCHANG ROAD, ANQIU CITY SHANDONG PROVINCE',
@SCountryName='China'
GO




-- tblMATERIAL_SUPPLIER --
EXEC MatSup
@MaterialName='Textile Mesh',
@SupplierName='Allesd',
@Price=2.85
EXEC MatSup
@MaterialName='Textile Mesh',
@SupplierName='iTokri',
@Price=3.10
EXEC MatSup
@MaterialName='Textile Mesh',
@SupplierName='Lenzing AG',
@Price=3.35
EXEC MatSup
@MaterialName='Textile Mesh',
@SupplierName='Core Fabrics',
@Price=3.75
EXEC MatSup
@MaterialName='Textile Mesh',
@SupplierName='Libeco',
@Price=4.20
EXEC MatSup
@MaterialName='Flyknit Yarn',
@SupplierName='Fabric Merchants',
@Price=2.40
EXEC MatSup
@MaterialName='Flyknit Yarn',
@SupplierName='Sino Silk',
@Price=2.65
EXEC MatSup
@MaterialName='Flyknit Yarn',
@SupplierName='Jcrafteco',
@Price=2.95
EXEC MatSup
@MaterialName='Flyknit Yarn',
@SupplierName='Ecological Textiles',
@Price=3.30
EXEC MatSup
@MaterialName='Flyknit Yarn',
@SupplierName='Libeco',
@Price=3.75
EXEC MatSup
@MaterialName='Cotton Fabric',
@SupplierName='Libeco',
@Price=3.20
EXEC MatSup
@MaterialName='Cotton Fabric',
@SupplierName='Eagle Fabrics',
@Price=3.55
EXEC MatSup
@MaterialName='Cotton Fabric',
@SupplierName='Sino Silk',
@Price=3.90
EXEC MatSup
@MaterialName='Cotton Fabric',
@SupplierName='iTokri',
@Price=4.30
EXEC MatSup
@MaterialName='Cotton Fabric',
@SupplierName='Fabric Merchants',
@Price=4.85
EXEC MatSup
@MaterialName='Polyester Fabric',
@SupplierName='Allesd',
@Price=3.30
EXEC MatSup
@MaterialName='Polyester Fabric',
@SupplierName='Fabric Merchants',
@Price=2.95
EXEC MatSup
@MaterialName='Polyester Fabric',
@SupplierName='Lenzing AG',
@Price=2.65
EXEC MatSup
@MaterialName='Polyester Fabric',
@SupplierName='Ecological Textiles',
@Price=2.35
EXEC MatSup
@MaterialName='Polyester Fabric',
@SupplierName='Libeco',
@Price=2.10
EXEC MatSup
@MaterialName='Nylon Fabric',
@SupplierName='iTokri',
@Price=4.80
EXEC MatSup
@MaterialName='Nylon Fabric',
@SupplierName='Fabric Merchants',
@Price=4.20
EXEC MatSup
@MaterialName='Nylon Fabric',
@SupplierName='Lenzing AG',
@Price=3.75
EXEC MatSup
@MaterialName='Nylon Fabric',
@SupplierName='Ecological Textiles ',
@Price=3.35
EXEC MatSup
@MaterialName='Nylon Fabric',
@SupplierName='Green Street Fabrics',
@Price=3.00
EXEC MatSup
@MaterialName='Spandex Fabric',
@SupplierName='Green Street Fabrics',
@Price=4.50
EXEC MatSup
@MaterialName='Spandex Fabric',
@SupplierName='Core Fabrics',
@Price=4.95
EXEC MatSup
@MaterialName='Spandex Fabric',
@SupplierName='Eagle Fabrics',
@Price=5.40
EXEC MatSup
@MaterialName='Spandex Fabric',
@SupplierName='iTokri',
@Price=5.95
EXEC MatSup
@MaterialName='Spandex Fabric',
@SupplierName='Allesd',
@Price=6.60
EXEC MatSup
@MaterialName='Terry Cloth',
@SupplierName='Green Street Fabrics',
@Price=4.00
EXEC MatSup
@MaterialName='Terry Cloth',
@SupplierName='Core Fabrics',
@Price=4.45
EXEC MatSup
@MaterialName='Terry Cloth',
@SupplierName='Eagle Fabrics',
@Price=4.90
EXEC MatSup
@MaterialName='Terry Cloth',
@SupplierName='Jcrafteco',
@Price=5.40
EXEC MatSup
@MaterialName='Terry Cloth',
@SupplierName='Allesd',
@Price=6.00
EXEC MatSup
@MaterialName='Fleece',
@SupplierName='Sino Silk',
@Price=3.60
EXEC MatSup
@MaterialName='Fleece',
@SupplierName='Lenzing AG',
@Price=4.00
EXEC MatSup
@MaterialName='Fleece',
@SupplierName='Jcrafteco',
@Price=4.45
EXEC MatSup
@MaterialName='Fleece',
@SupplierName='Eagle Fabrics',
@Price=4.95
EXEC MatSup
@MaterialName='Fleece',
@SupplierName='Libeco',
@Price=5.50
EXEC MatSup
@MaterialName='Canvas',
@SupplierName='Ecological Textiles',
@Price=6.30
EXEC MatSup
@MaterialName='Canvas',
@SupplierName='Eagle Fabrics',
@Price=5.70
EXEC MatSup
@MaterialName='Canvas',
@SupplierName='Lenzing AG',
@Price=5.15
EXEC MatSup
@MaterialName='Canvas',
@SupplierName='Sino Silk',
@Price=4.65
EXEC MatSup
@MaterialName='Canvas',
@SupplierName='iTokri',
@Price=4.20
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Allesd',
@Price=5.10
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Fabric Merchants',
@Price=5.60
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Jcrafteco',
@Price=6.15
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Core Fabrics',
@Price=6.75
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Ecological Textiles',
@Price=7.40
EXEC MatSup
@MaterialName='Ripstop Fabric',
@SupplierName='Green Street Fabrics',
@Price=6.25
EXEC MatSup
@MaterialName='Nubuck Leather',
@SupplierName='PrimeAsia China',
@Price=18.50
EXEC MatSup
@MaterialName='Nubuck Leather',
@SupplierName='PrimeAsia Indonesia',
@Price=19.75
EXEC MatSup
@MaterialName='Nubuck Leather',
@SupplierName='Wollsdorf',
@Price=21.20
EXEC MatSup
@MaterialName='Suede Leather',
@SupplierName='PrimeAsia China',
@Price=16.80
EXEC MatSup
@MaterialName='Suede Leather',
@SupplierName='PrimeAsia Indonesia',
@Price=17.50
EXEC MatSup
@MaterialName='Suede Leather',
@SupplierName='Suppertannery',
@Price=18.25
EXEC MatSup
@MaterialName='Suede Leather',
@SupplierName='Kongsiri tannery',
@Price=19.10
EXEC MatSup
@MaterialName='Patent Leather',
@SupplierName='Wollsdorf',
@Price=22.50
EXEC MatSup
@MaterialName='Patent Leather',
@SupplierName='Suppertannery',
@Price=23.80
EXEC MatSup
@MaterialName='Patent Leather',
@SupplierName='Kongsiri tannery',
@Price=25.20
EXEC MatSup
@MaterialName='Top-grain Leather',
@SupplierName='Suppertannery',
@Price=28.00
EXEC MatSup
@MaterialName='Top-grain Leather',
@SupplierName='Wollsdorf',
@Price=30.50
EXEC MatSup
@MaterialName='PVC Leather',
@SupplierName='Micooson',
@Price=10.40
EXEC MatSup
@MaterialName='PVC Leather',
@SupplierName='Wandao Materials',
@Price=9.75
EXEC MatSup
@MaterialName='PVC Leather',
@SupplierName='Nevotex',
@Price=9.10
EXEC MatSup
@MaterialName='PVC Leather',
@SupplierName='Fu''an Synthetic Materials Co.,Ltd',
@Price=8.50
EXEC MatSup
@MaterialName='Microfiber',
@SupplierName='Micooson',
@Price=7.30
EXEC MatSup
@MaterialName='Microfiber',
@SupplierName='YuSheng',
@Price=6.75
EXEC MatSup
@MaterialName='Microfiber',
@SupplierName='Crescent Textile Solutions',
@Price=6.20
EXEC MatSup
@MaterialName='PU Leather',
@SupplierName='Nevotex',
@Price=7.50
EXEC MatSup
@MaterialName='PU Leather',
@SupplierName='Wandao Materials',
@Price=8.10
EXEC MatSup
@MaterialName='PU Leather',
@SupplierName='Micooson',
@Price=8.70
EXEC MatSup
@MaterialName='TPU Film',
@SupplierName='YuSheng',
@Price=12.50
EXEC MatSup
@MaterialName='TPU Film',
@SupplierName='Micooson',
@Price=14.00
EXEC MatSup
@MaterialName='EVA Sheets',
@SupplierName='YuSheng',
@Price=2.10
EXEC MatSup
@MaterialName='EVA Sheets',
@SupplierName='Micooson',
@Price=2.35
EXEC MatSup
@MaterialName='EVA Foam',
@SupplierName='FRS',
@Price=3.10
EXEC MatSup
@MaterialName='EVA Foam',
@SupplierName='Zahonero',
@Price=2.80
EXEC MatSup
@MaterialName='EVA Foam',
@SupplierName='Flexipol',
@Price=2.50
EXEC MatSup
@MaterialName='PU Foam',
@SupplierName='Eva colors',
@Price=3.20
EXEC MatSup
@MaterialName='PU Foam',
@SupplierName='Zahonero',
@Price=3.55
EXEC MatSup
@MaterialName='PU Foam',
@SupplierName='FRS',
@Price=4.30
EXEC MatSup
@MaterialName='Memory Foam',
@SupplierName='Zahonero',
@Price=7.75
EXEC MatSup
@MaterialName='Memory Foam',
@SupplierName='Flexipol',
@Price=7.25
EXEC MatSup
@MaterialName='Memory Foam',
@SupplierName='Synthomer',
@Price=8.30
EXEC MatSup
@MaterialName='Latex Foam',
@SupplierName='Eva colors',
@Price=5.50
EXEC MatSup
@MaterialName='Latex Foam',
@SupplierName='Synthomer',
@Price=5.95
EXEC MatSup
@MaterialName='Latex Foam',
@SupplierName='Zahonero',
@Price=6.40
EXEC MatSup
@MaterialName='Natural Rubber',
@SupplierName='Eva colors',
@Price=4.20
EXEC MatSup
@MaterialName='Natural Rubber',
@SupplierName='Synthomer',
@Price=4.55
EXEC MatSup
@MaterialName='Natural Rubber',
@SupplierName='FRS',
@Price=5.00
EXEC MatSup
@MaterialName='Synthetic Rubber',
@SupplierName='FRS',
@Price=3.80
EXEC MatSup
@MaterialName='Synthetic Rubber',
@SupplierName='Synthomer',
@Price=4.20
EXEC MatSup
@MaterialName='TPR Rubber',
@SupplierName='Zahonero',
@Price=3.50
EXEC MatSup
@MaterialName='TPR Rubber',
@SupplierName='Eva colors',
@Price=3.85
EXEC MatSup
@MaterialName='TPR Rubber',
@SupplierName='Flexipol',
@Price=4.20
EXEC MatSup
@MaterialName='Rubber Heel Plug',
@SupplierName='Synthomer',
@Price=0.85
EXEC MatSup
@MaterialName='Rubber Heel Plug',
@SupplierName='Flexipol',
@Price=0.95
EXEC MatSup
@MaterialName='Rubber Heel Plug',
@SupplierName='FRS',
@Price=1.05
EXEC MatSup
@MaterialName='TPU Heel Counter',
@SupplierName='JV plastic',
@Price=7.50
EXEC MatSup
@MaterialName='TPU Heel Counter',
@SupplierName='Product City Co. Ltd.',
@Price=8.10
EXEC MatSup
@MaterialName='Plastic eyelets',
@SupplierName='JV plastic',
@Price=0.15
EXEC MatSup
@MaterialName='Plastic eyelets',
@SupplierName='Product City Co. Ltd.',
@Price=0.18
EXEC MatSup
@MaterialName='Plastic buckles',
@SupplierName='Product City Co. Ltd.',
@Price=0.95
EXEC MatSup
@MaterialName='Plastic buckles',
@SupplierName='JV plastic',
@Price=1.10
EXEC MatSup
@MaterialName='Heel Shank',
@SupplierName='JV plastic',
@Price=4.50
EXEC MatSup
@MaterialName='PVC Inserts',
@SupplierName='JV plastic',
@Price=3.55
EXEC MatSup
@MaterialName='PVC Inserts',
@SupplierName='Product City Co. Ltd.',
@Price=3.20
EXEC MatSup
@MaterialName='Lace Hooks',
@SupplierName='Micromet',
@Price=0.55
EXEC MatSup
@MaterialName='Lace Hooks',
@SupplierName='Metalware Corporation',
@Price=0.65
EXEC MatSup
@MaterialName='Lace Hooks',
@SupplierName='Dongguan KingMing Hardware and Plastic Technology Co., Ltd.',
@Price=0.75
EXEC MatSup
@MaterialName='Metal Buckles',
@SupplierName='Algeos',
@Price=1.80
EXEC MatSup
@MaterialName='Metal Buckles',
@SupplierName='Dongguan KingMing Hardware and Plastic Technology Co., Ltd.',
@Price=2.05
EXEC MatSup
@MaterialName='Metal Buckles',
@SupplierName='Metalware Corporation',
@Price=2.30
EXEC MatSup
@MaterialName='Metal Eyelets',
@SupplierName='Micromet',
@Price=0.90
EXEC MatSup
@MaterialName='Metal Eyelets',
@SupplierName='Dongguan KingMing Hardware and Plastic Technology Co., Ltd.',
@Price=1.05
EXEC MatSup
@MaterialName='Metal Eyelets',
@SupplierName='Algeos',
@Price=1.20
EXEC MatSup
@MaterialName='Shank Reinforcement',
@SupplierName='Micromet',
@Price=5.75
EXEC MatSup
@MaterialName='Shank Reinforcement',
@SupplierName='Algeos',
@Price=5.20
EXEC MatSup
@MaterialName='Elastic Band',
@SupplierName='Yusen Trims & Accessories',
@Price=1.40
EXEC MatSup
@MaterialName='Elastic Band',
@SupplierName='ECI',
@Price=1.10
EXEC MatSup
@MaterialName='Elastic Band',
@SupplierName='Pro-Stretch',
@Price=1.25
EXEC MatSup
@MaterialName='Elastic Band',
@SupplierName='MATSA Textiles',
@Price=1.10
EXEC MatSup
@MaterialName='Elastic Band',
@SupplierName='Lightspot',
@Price=0.95
EXEC MatSup
@MaterialName='Bungee Cord',
@SupplierName='ECI',
@Price=2.30
EXEC MatSup
@MaterialName='Bungee Cord',
@SupplierName='Pro-Stretch',
@Price=2.05
EXEC MatSup
@MaterialName='Bungee Cord',
@SupplierName='MATSA Textiles',
@Price=1.80
EXEC MatSup
@MaterialName='Webbing with Elastic',
@SupplierName='Yusen Trims & Accessories',
@Price=2.95
EXEC MatSup
@MaterialName='Webbing with Elastic',
@SupplierName='ECI',
@Price=2.65
EXEC MatSup
@MaterialName='Webbing with Elastic',
@SupplierName='MATSA Textiles',
@Price=2.35
EXEC MatSup
@MaterialName='Webbing with Elastic',
@SupplierName='Lightspot',
@Price=2.10
EXEC MatSup
@MaterialName='Mesh Lining',
@SupplierName='Sino Silk',
@Price=2.60
EXEC MatSup
@MaterialName='Mesh Lining',
@SupplierName='Fabric Merchants',
@Price=2.35
EXEC MatSup
@MaterialName='Mesh Lining',
@SupplierName='iTokri',
@Price=2.10
EXEC MatSup
@MaterialName='Mesh Lining',
@SupplierName='Core Fabrics',
@Price=1.85
EXEC MatSup
@MaterialName='Moisture-wicking Fabric',
@SupplierName='iTokri',
@Price=3.20
EXEC MatSup
@MaterialName='Moisture-wicking Fabric',
@SupplierName='Lenzing AG',
@Price=3.55
EXEC MatSup
@MaterialName='Moisture-wicking Fabric',
@SupplierName='Green Street Fabrics',
@Price=3.90
EXEC MatSup
@MaterialName='Laminated Fabric',
@SupplierName='Core Fabrics',
@Price=4.50
EXEC MatSup
@MaterialName='Laminated Fabric',
@SupplierName='Fabric Merchants',
@Price=4.95
EXEC MatSup
@MaterialName='Laminated Fabric',
@SupplierName='Lenzing AG',
@Price=5.40
EXEC MatSup
@MaterialName='Knit Fabric',
@SupplierName='Green Street Fabrics',
@Price=3.45
EXEC MatSup
@MaterialName='Knit Fabric',
@SupplierName='Jcrafteco',
@Price=3.10
EXEC MatSup
@MaterialName='Knit Fabric',
@SupplierName='Libeco',
@Price=2.80
EXEC MatSup
@MaterialName='Molded Foam',
@SupplierName='Flexipol',
@Price=4.95
EXEC MatSup
@MaterialName='Molded Foam',
@SupplierName='Synthomer',
@Price=4.50
EXEC MatSup
@MaterialName='Molded Foam',
@SupplierName='Eva colors',
@Price=4.10
EXEC MatSup
@MaterialName='Synthetic Suede',
@SupplierName='YuSheng',
@Price=7.80
EXEC MatSup
@MaterialName='Synthetic Suede',
@SupplierName='Micooson',
@Price=7.20
EXEC MatSup
@MaterialName='Leather Lining',
@SupplierName='PrimeAsia Indonesia',
@Price=12.50
EXEC MatSup
@MaterialName='Leather Lining',
@SupplierName='Suppertannery',
@Price=13.20
EXEC MatSup
@MaterialName='Leather Lining',
@SupplierName='Kongsiri tannery',
@Price=14.00
EXEC MatSup
@MaterialName='Plastic Heel Cup',
@SupplierName='JV plastic',
@Price=6.10
EXEC MatSup
@MaterialName='Plastic Heel Cup',
@SupplierName='JV plastic',
@Price=6.75
EXEC MatSup
@MaterialName='Stretch Woven',
@SupplierName='Libeco',
@Price=5.20
EXEC MatSup
@MaterialName='Stretch Woven',
@SupplierName='iTokri',
@Price=5.60
EXEC MatSup
@MaterialName='Stretch Woven',
@SupplierName='Jcrafteco',
@Price=6.05
EXEC MatSup
@MaterialName='Stretch Woven',
@SupplierName='Lenzing AG',
@Price=6.55
EXEC MatSup
@MaterialName='Waterproof Membrane',
@SupplierName='Green Street Fabrics',
@Price=9.30
EXEC MatSup
@MaterialName='Waterproof Membrane',
@SupplierName='Fabric Merchants',
@Price=8.75
EXEC MatSup
@MaterialName='Waterproof Membrane',
@SupplierName='Libeco',
@Price=8.25
EXEC MatSup
@MaterialName='Waterproof Membrane',
@SupplierName='Core Fabrics',
@Price=7.80
GO




-- tblPRODUCT --
EXEC ProductSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s 5" Shorts',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s Storm-FIT Jacket',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s High-Waisted Leggings',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s T-Shirt',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Joggers',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Max90 T-Shirt',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@ProductType='Apparel'
EXEC ProductSPROC
@ProductName='Recovery Foam Roller',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Duffel Bag (35L)',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Yoga Towel',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Training Backpack (Medium, 24L)',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Voluminous Hair Swim Cap',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Big Kids’ Dri-FIT Football Pants',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Recovery Ball',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Kids’ Soccer Shin Guards',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Tennis Visor',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Packable Running Vest',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Football Gloves (1 Pair)',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Running Waist Pack',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='Soccer Shin Guards (Adult)',
@ProductType='Equipment'
EXEC ProductSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Air Jordan 4 Retro',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Air Jordan 1 Mid SE',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Air Max 270',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike ReactX Rejuven8',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Pegasus Trail 5',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Vomero 18',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Zoom Vomero 5',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike V2K Run',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Maxfly 2',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Air Force 1 ''07',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Dunk Low Retro',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Waffle Debut',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike P-6000 Style',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike TC 7900',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Shox TL',
@ProductType='Footwear'
EXEC ProductSPROC
@ProductName='Nike Shox Z',
@ProductType='Footwear'
GO




-- tblBILL_OF_MATERIAL --
EXEC BOMSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@MaterialName='Knit Fabric',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@MaterialName='Spandex Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@MaterialName='Mesh Lining',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Women''s Tight Long-Sleeve Knit Top',
@MaterialName='Elastic Band',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Women''s Storm-FIT Jacket',
@MaterialName='Laminated Fabric',
@Quantity=1.6
EXEC BOMSPROC
@ProductName='Women''s Storm-FIT Jacket',
@MaterialName='Waterproof Membrane',
@Quantity=1.5
EXEC BOMSPROC
@ProductName='Women''s Storm-FIT Jacket',
@MaterialName='Mesh Lining',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Women''s Storm-FIT Jacket',
@MaterialName='Stretch Woven',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Women''s Storm-FIT Jacket',
@MaterialName='Elastic Band',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@MaterialName='Knit Fabric',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@MaterialName='Spandex Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@MaterialName='Mesh Lining',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@MaterialName='Elastic Band',
@Quantity=1
EXEC BOMSPROC
@ProductName='Women''s High-Waisted 8" Biker Shorts with Pockets',
@MaterialName='Stretch Woven',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Women''s 5" Shorts',
@MaterialName='Knit Fabric',
@Quantity=0.9
EXEC BOMSPROC
@ProductName='Women''s 5" Shorts',
@MaterialName='Spandex Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s 5" Shorts',
@MaterialName='Mesh Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Women''s 5" Shorts',
@MaterialName='Elastic Band',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Women''s 5" Shorts',
@MaterialName='Bungee Cord',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@MaterialName='Knit Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@MaterialName='Mesh Lining',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@MaterialName='Spandex Fabric',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT ADV Cropped Running Tank Top',
@MaterialName='Elastic Band',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@MaterialName='Moisture-wicking Fabric',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@MaterialName='Knit Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@MaterialName='Laminated Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s Dri-FIT UV 1/4-Zip Running Top',
@MaterialName='Elastic Band',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Women''s High-Waisted Leggings',
@MaterialName='Knit Fabric',
@Quantity=1.6
EXEC BOMSPROC
@ProductName='Women''s High-Waisted Leggings',
@MaterialName='Spandex Fabric',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Women''s High-Waisted Leggings',
@MaterialName='Mesh Lining',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Women''s High-Waisted Leggings',
@MaterialName='Elastic Band',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Women''s High-Waisted Leggings',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@MaterialName='Stretch Woven',
@Quantity=1.9
EXEC BOMSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@MaterialName='Cotton Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@MaterialName='Webbing with Elastic',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@MaterialName='Plastic Buckles',
@Quantity=4
EXEC BOMSPROC
@ProductName='Women''s Mid-Rise Oversized Woven Cargo Pants',
@MaterialName='Elastic Band',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@MaterialName='Fleece',
@Quantity=2
EXEC BOMSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@MaterialName='Elastic Band',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Women''s Oversized Pullover Hoodie',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s T-Shirt',
@MaterialName='Cotton Fabric',
@Quantity=1
EXEC BOMSPROC
@ProductName='Women''s T-Shirt',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Women''s T-Shirt',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Women''s T-Shirt',
@MaterialName='Mesh Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@MaterialName='Waterproof Membrane',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@MaterialName='Elastic Band',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@MaterialName='Mesh Lining',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@MaterialName='Laminated Fabric',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Men''s Full-Zip Woven Windrunner Jacket',
@MaterialName='Stretch Woven',
@Quantity=1.7
EXEC BOMSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@MaterialName='Fleece',
@Quantity=1.8
EXEC BOMSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@MaterialName='Knit Fabric',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@MaterialName='Elastic Band',
@Quantity=1
EXEC BOMSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@MaterialName='Mesh Lining',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='NOCTA Fleece CS Sweatpants',
@MaterialName='Stretch Woven',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@MaterialName='Fleece',
@Quantity=2.1
EXEC BOMSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@MaterialName='Elastic Band',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Men''s Pullover Fleece Hoodie',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Men''s Joggers',
@MaterialName='Stretch Woven',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Men''s Joggers',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Men''s Joggers',
@MaterialName='Elastic Band',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Men''s Joggers',
@MaterialName='Spandex Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Men''s Joggers',
@MaterialName='Knit Fabric',
@Quantity=1.6
EXEC BOMSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@MaterialName='Fleece',
@Quantity=1.7
EXEC BOMSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@MaterialName='Knit Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@MaterialName='Laminated Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@MaterialName='Mesh Lining',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Men''s Fleece Joggers with Reflective Accents',
@MaterialName='Elastic Band',
@Quantity=1
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@MaterialName='Stretch Woven',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@MaterialName='Elastic Band',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@MaterialName='Mesh Lining',
@Quantity=0.9
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@MaterialName='Laminated Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Half-Zip Jacket',
@MaterialName='Fleece',
@Quantity=1.6
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@MaterialName='Fleece',
@Quantity=2
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@MaterialName='Elastic Band',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT Sherpa Basketball Pants',
@MaterialName='Stretch Woven',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Max90 T-Shirt',
@MaterialName='Cotton Fabric',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Max90 T-Shirt',
@MaterialName='Knit Fabric',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Max90 T-Shirt',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Max90 T-Shirt',
@MaterialName='Mesh Lining',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@MaterialName='Laminated Fabric',
@Quantity=1.8
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@MaterialName='Waterproof Membrane',
@Quantity=1.6
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@MaterialName='Fleece',
@Quantity=0.9
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@MaterialName='Elastic Band',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Men''s Therma-FIT ADV Jacket',
@MaterialName='Mesh Lining',
@Quantity=1.1
EXEC BOMSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.9
EXEC BOMSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@MaterialName='Spandex Fabric',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@MaterialName='Elastic Band',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Men''s 5" Brief-Lined Running Shorts with Reflective Accents',
@MaterialName='Stretch Woven',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Recovery Foam Roller',
@MaterialName='EVA Foam',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Recovery Foam Roller',
@MaterialName='PU Foam',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Recovery Foam Roller',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Recovery Foam Roller',
@MaterialName='Synthetic Rubber',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Polyester Fabric',
@Quantity=2.5
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Ripstop Fabric',
@Quantity=1
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Mesh Lining',
@Quantity=1.5
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Webbing with Elastic',
@Quantity=3
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Plastic Buckles',
@Quantity=4
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Metal Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Duffel Bag (35L)',
@MaterialName='Elastic Band',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Football Gloves (1 Pair)',
@MaterialName='Elastic Band',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Football Gloves (1 Pair)',
@MaterialName='PU Foam',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Football Gloves (1 Pair)',
@MaterialName='TPR Rubber',
@Quantity=0.15
EXEC BOMSPROC
@ProductName='Football Gloves (1 Pair)',
@MaterialName='Spandex Fabric',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Football Gloves (1 Pair)',
@MaterialName='Synthetic Suede',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Running Waist Pack',
@MaterialName='Plastic Buckles',
@Quantity=1
EXEC BOMSPROC
@ProductName='Running Waist Pack',
@MaterialName='Webbing with Elastic',
@Quantity=1.5
EXEC BOMSPROC
@ProductName='Running Waist Pack',
@MaterialName='Mesh Lining',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Running Waist Pack',
@MaterialName='Ripstop Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Running Waist Pack',
@MaterialName='Polyester Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Soccer Shin Guards (Adult)',
@MaterialName='Elastic Band',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Soccer Shin Guards (Adult)',
@MaterialName='Nylon Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Soccer Shin Guards (Adult)',
@MaterialName='TPU Film',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Soccer Shin Guards (Adult)',
@MaterialName='EVA Foam',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@MaterialName='Cotton Fabric',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@MaterialName='Fleece',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@MaterialName='Elastic Band',
@Quantity=1.5
EXEC BOMSPROC
@ProductName='Heated Massage Wrap (non-electrical mock)',
@MaterialName='Elastic Band',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Yoga Towel',
@MaterialName='Microfiber',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Yoga Towel',
@MaterialName='Terry Cloth',
@Quantity=1.4
EXEC BOMSPROC
@ProductName='Big Kids’ Dri-FIT Football Pants',
@MaterialName='Elastic Band',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Big Kids’ Dri-FIT Football Pants',
@MaterialName='Spandex Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Big Kids’ Dri-FIT Football Pants',
@MaterialName='Polyester Fabric',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Big Kids’ Dri-FIT Football Pants',
@MaterialName='Moisture-wicking Fabric',
@Quantity=1.8
EXEC BOMSPROC
@ProductName='Recovery Ball',
@MaterialName='EVA Foam',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Recovery Ball',
@MaterialName='Synthetic Rubber',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Recovery Ball',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Kids’ Soccer Shin Guards',
@MaterialName='EVA Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Kids’ Soccer Shin Guards',
@MaterialName='TPU Film',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Kids’ Soccer Shin Guards',
@MaterialName='Polyester Fabric',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Kids’ Soccer Shin Guards',
@MaterialName='Elastic Band',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Tennis Visor',
@MaterialName='PU Foam',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Tennis Visor',
@MaterialName='Elastic Band',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Tennis Visor',
@MaterialName='Cotton Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Tennis Visor',
@MaterialName='Polyester Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Nylon Fabric',
@Quantity=2
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Polyester Fabric',
@Quantity=1.2
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Mesh Lining',
@Quantity=1
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Webbing with Elastic',
@Quantity=4
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Plastic Buckles',
@Quantity=5
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Training Backpack (Medium, 24L)',
@MaterialName='PU Foam',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Voluminous Hair Swim Cap',
@MaterialName='Spandex Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Voluminous Hair Swim Cap',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Voluminous Hair Swim Cap',
@MaterialName='Elastic Band',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Packable Running Vest',
@MaterialName='Nylon Fabric',
@Quantity=1
EXEC BOMSPROC
@ProductName='Packable Running Vest',
@MaterialName='Textile Mesh',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Packable Running Vest',
@MaterialName='Waterproof Membrane',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Packable Running Vest',
@MaterialName='Elastic Band',
@Quantity=1
EXEC BOMSPROC
@ProductName='Packable Running Vest',
@MaterialName='Plastic Buckles',
@Quantity=2
EXEC BOMSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@MaterialName='Latex Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@MaterialName='Synthetic Suede',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@MaterialName='Spandex Fabric',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@MaterialName='Elastic Band',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Big Kids’ Goalkeeper Soccer Gloves',
@MaterialName='PU Foam',
@Quantity=0.15
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Textile Mesh',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Flyknit Yarn',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Synthetic Suede',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='TPU Film',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='EVA Foam',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='TPR Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Plastic Eyelets',
@Quantity=10
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Lace Hooks',
@Quantity=4
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Heel Shank',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Shank Reinforcement',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='LeBron XXIII "Bubble Boy"',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Textile Mesh',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Knit Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Synthetic Suede',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='PU Leather',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='EVA Sheets',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Memory Foam',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Natural Rubber',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='TPU Heel Counter',
@Quantity=0.07
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Plastic Heel Cup',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Plastic Buckles',
@Quantity=2
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Air Jordan 4 Retro',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Flyknit Yarn',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Textile Mesh',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='TPU Film',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Synthetic Suede',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='EVA Foam',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='PU Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Synthetic Rubber',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='TPU Heel Counter',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Lace Hooks',
@Quantity=2
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Air Jordan 1 Mid SE',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Textile Mesh',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Flyknit Yarn',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='TPU Film',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='EVA Foam',
@Quantity=0.48
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Synthetic Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='TPU Heel Counter',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Air Max 270',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Flyknit Yarn',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Textile Mesh',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='EVA Foam',
@Quantity=0.38
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='PU Foam',
@Quantity=0.22
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Synthetic Rubber',
@Quantity=0.48
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='TPU Heel Counter',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike ReactX Rejuven8',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Textile Mesh',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Knit Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Synthetic Suede',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='EVA Sheets',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Memory Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Natural Rubber',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='TPU Heel Counter',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Plastic Heel Cup',
@Quantity=0.12
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Heel Shank',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Shank Reinforcement',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Pegasus Trail 5',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Textile Mesh',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Flyknit Yarn',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='TPU Film',
@Quantity=0.28
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Microfiber',
@Quantity=0.22
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='EVA Foam',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='PU Foam',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Synthetic Rubber',
@Quantity=0.58
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='TPU Heel Counter',
@Quantity=0.8
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Vomero 18',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Ripstop Fabric',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Textile Mesh',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='TPU Film',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Synthetic Suede',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='EVA Sheets',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='PU Foam',
@Quantity=0.28
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='TPR Rubber',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='TPU Heel Counter',
@Quantity=0.09
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Zoom Vomero 5',
@MaterialName='Leather Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Textile Mesh',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Waterproof Membrane',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Laminated Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='EVA Foam',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Synthetic Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Plastic Heel Cup',
@Quantity=0.1
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Shank Reinforcement',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike V2K Run',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Textile Mesh',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Microfiber',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='EVA Foam',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Memory Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Synthetic Rubber',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='TPU Heel Counter',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Mesh Lining',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Maxfly 2',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Flyknit Yarn',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Textile Mesh',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='EVA Foam',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Memory Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Synthetic Rubber',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='TPU Heel Counter',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Ja 3 "Scratch 3.0"',
@MaterialName='Leather Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Top-grain Leather',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Synthetic Suede',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='EVA Sheets',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Natural Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='TPU Heel Counter',
@Quantity=0.07
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Metal Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Leather Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Air Force 1 ''07',
@MaterialName='Mesh Lining',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Knit Fabric',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Stretch Woven',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Elastic Band',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='EVA Foam',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='PU Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Synthetic Rubber',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='TPU Heel Counter',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Dunk Low Retro',
@MaterialName='Leather Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Suede Leather',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Nubuck Leather',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='TPU Film',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='EVA Sheets',
@Quantity=0.48
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='PU Foam',
@Quantity=0.28
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Natural Rubber',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Metal Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Leather Lining',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Waffle Debut',
@MaterialName='Mesh Lining',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Canvas',
@Quantity=0.7
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Cotton Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='TPU Film',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Microfiber',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='EVA Foam',
@Quantity=0.42
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='PU Foam',
@Quantity=0.26
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Synthetic Rubber',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='TPU Heel Counter',
@Quantity=0.06
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Heel Shank',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Shank Reinforcement',
@Quantity=0.03
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike P-6000 Style',
@MaterialName='Leather Lining',
@Quantity=0.15
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Patent Leather',
@Quantity=0.65
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='PU Leather',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='TPU Film',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='EVA Sheets',
@Quantity=0.52
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Memory Foam',
@Quantity=0.28
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Natural Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Metal Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Leather Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike TC 7900',
@MaterialName='Mesh Lining',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Flyknit Yarn',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='TPU Film',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Microfiber',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Synthetic Suede',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Knit Fabric',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='EVA Sheets',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='TPU Heel Counter',
@Quantity=0.07
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Synthetic Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Mesh Lining',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike United Mercurial Vapor 16 Elite',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Synthetic Suede',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Microfiber',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Textile Mesh',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Knit Fabric',
@Quantity=0.2
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='EVA Foam',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='PU Foam',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='TPR Rubber',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Shank Reinforcement',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike United Jr. Phantom 6 Low Pro',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Textile Mesh',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Knit Fabric',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='TPU Film',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Microfiber',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Synthetic Suede',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='EVA Foam',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='PU Foam',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Synthetic Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='TPU Heel Counter',
@Quantity=0.08
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Plastic Eyelets',
@Quantity=8
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Mesh Lining',
@Quantity=0.45
EXEC BOMSPROC
@ProductName='Nike Shox TL',
@MaterialName='Moisture-wicking Fabric',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Flyknit Yarn',
@Quantity=0.6
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Textile Mesh',
@Quantity=0.35
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='TPU Film',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Microfiber',
@Quantity=0.25
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Stretch Woven',
@Quantity=0.3
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='EVA Sheets',
@Quantity=0.5
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Memory Foam',
@Quantity=0.28
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Natural Rubber',
@Quantity=0.55
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='TPU Heel Counter',
@Quantity=0.07
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Rubber Heel Plug',
@Quantity=2
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Plastic Eyelets',
@Quantity=6
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Heel Shank',
@Quantity=0.05
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Shank Reinforcement',
@Quantity=0.04
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Mesh Lining',
@Quantity=0.4
EXEC BOMSPROC
@ProductName='Nike Shox Z',
@MaterialName='Leather Lining',
@Quantity=0.2
GO








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
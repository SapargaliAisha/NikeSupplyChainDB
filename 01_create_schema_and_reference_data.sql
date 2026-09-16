/*=============================================================
  01 — SCHEMA: TABLES AND FOREIGN KEYS
  Creates all 29 tables and attaches FK constraints.
  Depends on: nothing (run first, on an empty database)
=============================================================*/

CREATE DATABASE NIKE_SUPPLY_CHAIN
GO
USE NIKE_SUPPLY_CHAIN
GO

-- Table Statements --
CREATE TABLE tblSTATUS
(StatusID INT IDENTITY(1,1) PRIMARY KEY,
StatusName VARCHAR(60) NOT NULL,
StatusDescr VARCHAR(300))
GO 
CREATE TABLE tblCARRIER(
CarrierID INT IDENTITY(1,1) PRIMARY KEY,
CarrierName VARCHAR(60) NOT NULL,
CarrierDescr VARCHAR(250))
GO
CREATE TABLE tblFEE_TYPE
(FeeTypeID INT IDENTITY(1,1) PRIMARY KEY,
FeeTypeName VARCHAR(50) NOT NULL,
FeeTypeDescr VARCHAR(250))
GO
CREATE TABLE tblFEE
(FeeID INT IDENTITY(1,1) PRIMARY KEY,
FeeName VARCHAR(50) NOT NULL,
FeeTypeID INT NOT NULL,
FeeAmount DECIMAL(10,2) NOT NULL,
FeeDescr VARCHAR(250))
GO
CREATE TABLE tblSHIPMENT_FEE(
ShipmentFeeID INT IDENTITY(1,1) PRIMARY KEY,
ShipmentID INT NOT NULL,
FeeID INT NOT NULL)
GO
--I permitted null values to manage tblMANIFEST later.. check Wrapper_Shipment
CREATE TABLE tblSHIPMENT(
ShipmentID INT IDENTITY(1,1) PRIMARY KEY,
ShipmentBeginDate DATE NULL,
CarrierID INT NULL,
FactoryID INT NULL,
FactoryStat VARCHAR(10))
GO
CREATE TABLE tblSHIPMENT_STATUS(
ShipmentStatusID INT IDENTITY(1,1) PRIMARY KEY,
ShipmentStatusDate DATE NOT NULL,
ShipmentID INT NOT NULL,
StatusID INT NOT NULL)
GO
CREATE TABLE tblBOL_LINE
(BOL_LineID INT IDENTITY(1,1) PRIMARY KEY,
BOL_ID INT NOT NULL,
PO_LineID INT NOT NULL,
ActualQuantity INT NOT NULL)
GO
CREATE TABLE tblBILL_OF_LADING(
BOL_ID INT IDENTITY(1,1) PRIMARY KEY,
ShipmentID INT NOT NULL,
BOL_Date DATE)
GO
CREATE TABLE tblBOL_DISCOUNT
(BOL_DiscountID INT IDENTITY(1,1) PRIMARY KEY,
BOL_ID INT NOT NULL,
DiscountID INT NOT NULL)
GO
CREATE TABLE tblDISCOUNT(
DiscountID INT IDENTITY(1,1) PRIMARY KEY,
DiscountName VARCHAR(50) NOT NULL,
DiscountTypeID INT NOT NULL,
DiscountAmount DECIMAL(7,2) NOT NULL,
DiscountDescr VARCHAR(200))
GO
CREATE TABLE tblDISCOUNT_TYPE(
DiscountTypeID INT IDENTITY(1,1) PRIMARY KEY,
DiscountTypeName VARCHAR(50) NOT NULL,
DiscountTypeDescr VARCHAR(200))
GO
CREATE TABLE tblUNIT_OF_MEASURE
(UOM_ID INT IDENTITY(1,1) PRIMARY KEY,
UOM_Name NVARCHAR(50),
UOM_Descr VARCHAR(50))
GO
CREATE TABLE tblMATERIAL_TYPE(
MaterialTypeID INT IDENTITY(1,1) PRIMARY KEY,
MaterialTypeName VARCHAR(50) NOT NULL,
MaterialTypeDescr VARCHAR(180))
GO
CREATE TABLE tblMATERIAL(
MaterialID INT IDENTITY(1,1) PRIMARY KEY,
MaterialName VARCHAR(80) NOT NULL,
MaterialTypeID INT NOT NULL,
UOM_ID INT NOT NULL,
MaterialDescr VARCHAR(200))
GO
CREATE TABLE tblSUPPLIER(
SupplierID INT IDENTITY(1,1) PRIMARY KEY,
SupplierName VARCHAR(80) NOT NULL,
SupplierTypeID INT NOT NULL,
Address VARCHAR(200),
SupCountryID INT NOT NULL)
GO
CREATE TABLE tblSUPPLIER_TYPE(
SupplierTypeID INT IDENTITY(1,1) PRIMARY KEY,
SupplierTypeName VARCHAR(40) NOT NULL,
SupplierTypeDescr VARCHAR(150))
GO
CREATE TABLE tblSUP_COUNTRY
(SupCountryID INT IDENTITY(1,1) PRIMARY KEY,
SupCountryName VARCHAR(50) NOT NULL)
GO
CREATE TABLE tblMATERIAL_SUPPLIER(
MaterialSupplierID INT IDENTITY(1,1) PRIMARY KEY,
MaterialID INT NOT NULL,
SupplierID INT NOT NULL,
[Price (USD)] DECIMAL(10,2) NOT NULL)
GO
CREATE TABLE tblPURCHASE_ORDER(
PO_ID INT IDENTITY(1,1) PRIMARY KEY,
PO_Date DATE NOT NULL)
GO
CREATE TABLE tblPURCHASE_ORDER_LINE
(PO_LineID INT IDENTITY(1,1) PRIMARY KEY,
PO_ID INT NOT NULL,
MaterialSupplierID INT NOT NULL,
OrderedQuantity INT NOT NULL)
GO
CREATE TABLE tblPRODUCT(
ProductID INT IDENTITY(1,1) PRIMARY KEY,
ProductName VARCHAR(100) NOT NULL,
ProductTypeID INT NOT NULL)
GO
CREATE TABLE tblPRODUCT_TYPE(
ProductTypeID INT IDENTITY(1,1) PRIMARY KEY,
ProductTypeName VARCHAR(40) NOT NULL,
ProductTypeDescr VARCHAR(200))
GO
CREATE TABLE tblBILL_OF_MATERIAL(
BOM_ID INT IDENTITY(1,1) PRIMARY KEY,
ProductID INT NOT NULL,
MaterialID INT NOT NULL,
Quantity NUMERIC(8,2) NOT NULL)
GO
CREATE TABLE tblWORK_ORDER(
WorkOrderID INT IDENTITY(1,1) PRIMARY KEY,
FactoryID INT NOT NULL,
DistProdQuantity INT NOT NULL,
BeginDate DATE NOT NULL,
DueDate DATE NOT NULL)
GO
CREATE TABLE tblWORK_ORDER_ITEMS(
WorkOrderID INT NOT NULL,
ProductID INT NOT NULL,
Quantity INT NOT NULL)
GO
CREATE TABLE tblFACTORY(
FactoryID INT IDENTITY(1,1) PRIMARY KEY,
FactoryName VARCHAR(150) NOT NULL,
Address VARCHAR(150),
City VARCHAR(60) NOT NULL,
State VARCHAR(60),
PostalCode VARCHAR(20),
CountryID INT NOT NULL)
GO
CREATE TABLE tblCOUNTRY(
CountryID INT IDENTITY(1,1) PRIMARY KEY,
CountryName VARCHAR(60) NOT NULL,
CountryAbbrev VARCHAR(3) NOT NULL,
RegionID INT NOT NULL)
GO
CREATE TABLE tblREGION(
RegionID INT IDENTITY(1,1) PRIMARY KEY,
RegionName VARCHAR(50) NOT NULL,
RegionDescr VARCHAR(150));




-- Foreign Keys Attachment --
ALTER TABLE tblSHIPMENT_STATUS
ADD CONSTRAINT FK_tblSHIPMENT_STATUS_ShipmentID
FOREIGN KEY(ShipmentID)
REFERENCES tblSHIPMENT(ShipmentID)
GO
ALTER TABLE tblSHIPMENT_STATUS
ADD CONSTRAINT FK_tblSHIPMENT_STATUS_StatusID
FOREIGN KEY(StatusID)
REFERENCES tblSTATUS(StatusID)
GO
ALTER TABLE tblFEE
ADD CONSTRAINT FK_tblFEE_FeeTypeID
FOREIGN KEY(FeeTypeID)
REFERENCES tblFEE_TYPE(FeeTypeID)
GO
ALTER TABLE tblSHIPMENT_FEE
ADD CONSTRAINT FK_tblSHIPMENT_FEE_ShipmentID
FOREIGN KEY(ShipmentID)
REFERENCES tblSHIPMENT(ShipmentID)
GO
ALTER TABLE tblSHIPMENT_FEE
ADD CONSTRAINT FK_tblSHIPMENT_FEE_FeeID
FOREIGN KEY(FeeID)
REFERENCES tblFEE(FeeID)
GO
ALTER TABLE tblSHIPMENT
ADD CONSTRAINT FK_tblSHIPMENT_CarrierID
FOREIGN KEY (CarrierID)
REFERENCES tblCARRIER(CarrierID)
GO
ALTER TABLE tblSHIPMENT
ADD CONSTRAINT FK_tblSHIPMENT_FactoryID
FOREIGN KEY (FactoryID)
REFERENCES tblFACTORY(FactoryID)
GO
ALTER TABLE tblBILL_OF_LADING
ADD CONSTRAINT FK_tblBILL_OF_LADING_ShipmentID
FOREIGN KEY(ShipmentID)
REFERENCES tblSHIPMENT(ShipmentID)
GO
ALTER TABLE tblBOL_LINE
ADD CONSTRAINT FK_tblBOL_LINE_BOL_ID
FOREIGN KEY(BOL_ID)
REFERENCES tblBILL_OF_LADING(BOL_ID)
GO
ALTER TABLE tblBOL_LINE
ADD CONSTRAINT FK_BOL_LINE_PO_LineID
FOREIGN KEY(PO_LineID)
REFERENCES tblPURCHASE_ORDER_LINE(PO_LineID)
GO
ALTER TABLE tblPURCHASE_ORDER_LINE
ADD CONSTRAINT FK_tblPURCHASE_ORDER_LINE_PO_ID
FOREIGN KEY(PO_ID)
REFERENCES tblPURCHASE_ORDER(PO_ID)
GO
ALTER TABLE tblPURCHASE_ORDER_LINE
ADD CONSTRAINT FK_tblPURCHASE_ORDER_LINE_MaterialSupplierID
FOREIGN KEY(MaterialSupplierID)
REFERENCES tblMATERIAL_SUPPLIER(MaterialSupplierID)
GO
ALTER TABLE tblBOL_DISCOUNT
ADD CONSTRAINT FK_tblBOL_DISCOUNT_BOL_ID
FOREIGN KEY(BOL_ID)
REFERENCES tblBILL_OF_LADING(BOL_ID)
GO
ALTER TABLE tblBOL_DISCOUNT
ADD CONSTRAINT FK_tblBOL_DISCOUNT_DiscountID
FOREIGN KEY(DiscountID)
REFERENCES tblDISCOUNT(DiscountID)
GO
ALTER TABLE tblDISCOUNT
ADD CONSTRAINT FK_tblDISCOUNT_DiscountTypeID
FOREIGN KEY(DiscountTypeID)
REFERENCES tblDISCOUNT_TYPE(DiscountTypeID)
GO
ALTER TABLE tblSUPPLIER
ADD CONSTRAINT FK_tblSUPPLIER_SupplierTypeID
FOREIGN KEY(SupplierTypeID)
REFERENCES tblSUPPLIER_TYPE(SupplierTypeID)
GO
ALTER TABLE tblSUPPLIER
ADD CONSTRAINT FK_tblSUPPLIER_SupCountryID
FOREIGN KEY(SupCountryID)
REFERENCES tblSUP_COUNTRY(SupCountryID)
GO
ALTER TABLE tblMATERIAL_SUPPLIER
ADD CONSTRAINT FK_tblMATERIAL_SUPPLIER_SupplierID
FOREIGN KEY(SupplierID)
REFERENCES tblSUPPLIER(SupplierID)
GO
ALTER TABLE tblMATERIAL_SUPPLIER
ADD CONSTRAINT FK_tblMATERIAL_SUPPLIER_MaterialID
FOREIGN KEY(MaterialID)
REFERENCES tblMATERIAL(MaterialID)
GO
ALTER TABLE tblMATERIAL
ADD CONSTRAINT FK_tblMATERIAL_MaterialTypeID
FOREIGN KEY(MaterialTypeID)
REFERENCES tblMATERIAL_TYPE(MaterialTypeID)
GO
ALTER TABLE tblMATERIAL
ADD CONSTRAINT FK_tblMATERIAL_UOM_ID
FOREIGN KEY (UOM_ID)
REFERENCES tblUNIT_OF_MEASURE(UOM_ID)
GO
ALTER TABLE tblBILL_OF_MATERIAL
ADD CONSTRAINT FK_tblBILL_OF_MATERIAL_MaterialID
FOREIGN KEY(MaterialID)
REFERENCES tblMATERIAL(MaterialID)
GO
ALTER TABLE tblBILL_OF_MATERIAL
ADD CONSTRAINT FK_tblBILL_OF_PRODUCT_ProductID
FOREIGN KEY(ProductID)
REFERENCES tblPRODUCT(ProductID)
GO
ALTER TABLE tblFACTORY
ADD CONSTRAINT FK_tblFACTORY_CountryID
FOREIGN KEY(CountryID)
REFERENCES tblCOUNTRY(CountryID)
GO
ALTER TABLE tblWORK_ORDER
ADD CONSTRAINT FK_tblWORK_ORDER_FactoryID
FOREIGN KEY (FactoryID)
REFERENCES tblFACTORY(FactoryID)
GO
ALTER TABLE tblWORK_ORDER_ITEMS
ADD CONSTRAINT FK_tblWORK_ORDER_ITEMS_WorkOrderID
FOREIGN KEY(WorkOrderID)
REFERENCES tblWORK_ORDER(WorkOrderID)
GO
ALTER TABLE tblWORK_ORDER_ITEMS
ADD CONSTRAINT FK_tblWORK_ORDER_ITEMS_ProductID
FOREIGN KEY(ProductID)
REFERENCES tblPRODUCT(ProductID)
GO
ALTER TABLE tblPRODUCT
ADD CONSTRAINT FK_tblPRODUCT_ProductTypeID
FOREIGN KEY(ProductTypeID)
REFERENCES tblPRODUCT_TYPE(ProductTypeID)
GO
ALTER TABLE tblCOUNTRY
ADD CONSTRAINT FK_tblCOUNTRY_RegionID
FOREIGN KEY(RegionID)
REFERENCES tblREGION(RegionID)
GO








/*=============================================================
  02 — SEED: REFERENCE DATA
  Static lookup values (statuses, types, UOM, regions/countries)
  plus the carrier list. Direct INSERTs, no procedures needed.
  Depends on: 01
=============================================================*/
-- Type Tables Population --
INSERT INTO tblSTATUS(StatusName, StatusDescr)
VALUES
('Picked Up', 'Shipment collected by carrier'),
('In Transit (Sea)', 'Shipment moving via ocean freight'),
('In Transit (Air)', 'Shipment moving by air'),
('Arrived at Port', 'Cargo arrived at destination port'),
('Customs Clearance', 'Cargo undergoing customs checks'),
('Customs Hold', 'Customs withheld cargo temporarily'),
('At Warehouse', 'Arrived at Nike inbound storage warehouse'),
('Quality Inspection', 'Materials undergoing QC check'),
('Delivered to Factory', 'Materials delivered to manufacturing plant'),
('Cancelled', 'Order or shipment cancelled')
GO
INSERT INTO tblFEE_TYPE(FeeTypeName, FeeTypeDescr)
VALUES
('Percentage-based',NULL),
('Fixed amount per shipment (USD)', NULL),
('Fixed amount per day (USD)', NULL)
GO
INSERT INTO tblDISCOUNT_TYPE(DiscountTypeName, DiscountTypeDescr)
VALUES
('Percentage', NULL),
('Fixed amount (USD)', NULL)
GO
INSERT INTO tblSUPPLIER_TYPE(SupplierTypeName, SupplierTypeDescr)
VALUES
('Tannery', 'Leather'),
('Foam & Rubber Supplier', 'Foam, Rubber'),
('Plastic Components Supplier', 'Plastic'),
('Trims & Elastics Supplier', 'Elastic'),
('Footwear Hardware Supplier', 'Metal, Plastic'),
('Fabric Mill', 'Textile, Fabric'),
('Synthetic Supplier',NULL)	
GO
INSERT INTO tblPRODUCT_TYPE(ProductTypeName, ProductTypeDescr)
VALUES
('Equipment', ''),
('Apparel', ''),
('Footwear', '')
GO
INSERT INTO tblMATERIAL_TYPE(MaterialTypeName, MaterialTypeDescr)
VALUES
('Fabric', 'Material made by weaving, knitting, or bonding fibers; soft and flexible'),
('Leather', 'Durable material from animal hides; strong and water-resistant.'),
('Synthetic', 'Man-made materials like polyester or nylon; durable and moisture-resistant.'),
('Foam', 'Lightweight, spongy material; compressible and shock-absorbing.'),
('Rubber', 'Elastic material from natural or synthetic sources; stretchable and resilient.'),
('Plastic', 'Moldable polymer material; lightweight and water-resistant.'),
('Metal', 'Strong, conductive material like steel, aluminum, or copper; durable and malleable.'),
('Elastic', 'Stretchable material that returns to its shape; flexible and resilient.'),
('Textile', 'Broad category of fiber-based materials, including fabrics, yarns, and threads; flexible and versatile.')
GO




-- tblCARRIER Population --
INSERT INTO tblCARRIER (CarrierName)
VALUES
('AIT Worldwide Logistics'),
('Allen Lund Company'),
('Alliance Shippers'),
('Allstates WorldCargo'),
('Amazon Freight'),
('APL Logistics'),
('Approved Freight Forwarders'),
('ArcBest'),
('Arvato'),
('Associated Logistics Group'),
('Automated Logistics Systems'),
('Barrett Distribution Centers'),
('BlueGrace Logistics'),
('Brown Integrated Logistics'),
('Capstone Logistics'),
('C.H. Robinson'),
('CJ Logistics America'),
('Comprehensive Logistics'),
('Covenant Logistics'),
('Crowley'),
('CT Logistics'),
('DHL Supply Chain North America'),
('Dimerco Express Group'),
('Distribution Technology'),
('EASE Logistics'),
('Echo Global Logistics'),
('ELM Global Logistics'),
('eShipping'),
('Evans Distribution Systems'),
('Fidelitone'),
('FLS Transportation Services'),
('General Dynamics'),
('GEODIS'),
('GPA Logistics Group'),
('Green Worldwide Shipping'),
('GXO'),
('Holman Logistics'),
('Hub Group'),
('Jarrett'),
('Kenco'),
('Landstar System'),
('Legacy Supply Chain'),
('Logistics Plus'),
('Logistix Company, The'),
('Loup Logistics'),
('Lynden'),
('Mallory Alexander International Logistics'),
('Matson Logistics'),
('MD Logistics'),
('MODE Global'),
('NFI'),
('Novo Logistics'),
('NRS'),
('NXTPoint Logistics'),
('ODW Logistics'),
('Odyssey Logistics'),
('Pegasus Logistics Group'),
('Penske Logistics'),
('Phoenix Logistics'),
('Polaris Transportation Group'),
('Prosponsive Logistics'),
('PSA BDP'),
('R2 Logistics'),
('RBW Logistics'),
('RedStone Logistics'),
('Regal Logistics');
GO




-- tblUNIT_OF_MEASURE Population --
INSERT INTO tblUNIT_OF_MEASURE (UOM_Name)
VALUES ('m'), ('m²'), ('pcs'),('kg')
GO



-- tblSUP_COUNTRY --
INSERT INTO tblSUP_COUNTRY(SupCountryName)
VALUES ('Italy'),
('Taiwan'),
('Hong Kong'),
('Mexico'),
('UK'),
('Spain'),
('Thailand'),
('Austria'),
('Indonesia'),
('Belgium'),
('The Netherlands'),
('Canada'),
('USA'),
('India'),
('Los Angeles'),
('China'),
('Sweden')
GO
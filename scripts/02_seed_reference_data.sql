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
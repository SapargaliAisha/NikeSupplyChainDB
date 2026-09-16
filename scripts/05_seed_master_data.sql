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
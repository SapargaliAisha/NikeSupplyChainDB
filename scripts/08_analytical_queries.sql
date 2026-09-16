/*1. For each region, return the number of factories,
the number of countries, and the average delivery time 
across shipments sent to those factories. 
Regions with no delivered shipments must still appear, with NULL.*/
SELECT RegionName, COUNT(DISTINCT C.CountryName) AS Num_Of_Countries, 
COUNT(DISTINCT FactoryName) AS Num_Of_Factories,
AVG(DATEDIFF(day, ShipmentBeginDate, ShipmentEndDate)) AS Avg_ShippingDays
FROM tblREGION R
	LEFT JOIN tblCOUNTRY C ON C.RegionID=R.RegionID
	LEFT JOIN tblFACTORY F ON C.CountryID=F.CountryID
	LEFT JOIN tblSHIPMENT S ON S.FactoryID=F.FactoryID
GROUP BY RegionName


/*2. Top 10 carriers by average delivery time, limited to carriers with at least 20 completed shipments.
Add a column showing each carrier's deviation from the overall average across all carriers.*/
SELECT TOP 10 CarrierName, AVG(DATEDIFF(DAY, ShipmentBeginDate, ShipmentEndDate)) AS Avg_Deliv_Time,
COUNT(ShipmentID) AS Num_Of_CompShip, 
ROUND(STDEVP(DATEDIFF(DAY,ShipmentBeginDate, ShipmentEndDate)),2) AS Stdev
FROM tblCARRIER C
	JOIN tblSHIPMENT S ON S.CarrierID=C.CarrierID
WHERE ShipmentEndDate IS NOT NULL
GROUP BY CarrierName
HAVING COUNT(ShipmentID)>=20
ORDER BY Avg_Deliv_Time


/*3. For each material type, return total purchase value,
its share of total purchasing as a percentage, and the number of distinct suppliers.*/
SELECT MaterialTypeName, COUNT(DISTINCT SupplierName) AS DistinctSupplier,
SUM(OrderedQuantity*[Price (USD)]) AS TotalOrderedValue,
CAST(SUM(OrderedQuantity*[Price (USD)])/(SELECT SUM(PO1.OrderedQuantity*MS1.[Price (USD)])
	FROM tblPURCHASE_ORDER_LINE PO1
	JOIN tblMATERIAL_SUPPLIER MS1 ON MS1.MaterialSupplierID=PO1.MaterialSupplierID)
	*100
	AS DECIMAL(10,2))
	AS PlannedShareOfTotal, /*-I changed alias names to avoid outer referencing (MS -> MS1)
							  -Used CAST instead of ROUND, because SSMS expanded scale for
							  precision (Initially, column types are decimal)*/

SUM(ActualQuantity*[Price (USD)]) AS TotalDeliveredValue,
CAST(SUM(ActualQuantity*[Price (USD)])/(SELECT SUM(BOL1.ActualQuantity*MS2.[Price (USD)])
	FROM tblBOL_LINE BOL1
	JOIN tblPURCHASE_ORDER_LINE PO2 ON PO2.PO_LineID=BOL1.PO_LineID
	JOIN tblMATERIAL_SUPPLIER MS2 ON PO2.MaterialSupplierID=MS2.MaterialSupplierID)
	*100
	AS DECIMAL(10,2))
	AS ActualShareOfTotal,
100-(CAST(((SUM(ActualQuantity*[Price (USD)])/(SELECT SUM(BOL2.ActualQuantity*MS4.[Price (USD)])
	FROM tblBOL_LINE BOL2
	JOIN tblPURCHASE_ORDER_LINE PO4 ON PO4.PO_LineID=BOL2.PO_LineID
	JOIN tblMATERIAL_SUPPLIER MS4 ON MS4.MaterialSupplierID=PO4.MaterialSupplierID)
	*100)-
(SUM(OrderedQuantity*[Price (USD)])/(SELECT SUM(PO3.OrderedQuantity*MS3.[Price (USD)])
	FROM tblPURCHASE_ORDER_LINE PO3
	JOIN tblMATERIAL_SUPPLIER MS3 ON MS3.MaterialSupplierID=PO3.MaterialSupplierID)
	*100))
	AS DECIMAL(10,2)))
	AS FulfillmentRate
FROM tblMATERIAL_TYPE MT
	JOIN tblMATERIAL M ON M.MaterialTypeID=MT.MaterialTypeID
	JOIN tblMATERIAL_SUPPLIER MS ON MS.MaterialID=M.MaterialID
	JOIN tblPURCHASE_ORDER_LINE PO ON PO.MaterialSupplierID=MS.MaterialSupplierID
	JOIN tblBOL_LINE BOL ON BOL.PO_LineID=PO.PO_LineID
	JOIN tblSUPPLIER S ON S.SupplierID=MS.SupplierID
GROUP BY MaterialTypeName
/* Purchasing value by material type: ordered vs actually received.
   PO lines carry OrderedQuantity (commitment at order time); BOL lines
   carry ActualQuantity (what the factory received). -> Thought it is good 
   to add actual values */
--!! Results are very close to each other, because in SPROCs used RAND() function (stable)
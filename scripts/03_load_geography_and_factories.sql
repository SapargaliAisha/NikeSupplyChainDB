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
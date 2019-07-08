Select Job, 
InspectionDate, 
MONTH(InspectionDate) as Month, 
YEAR(InspectionDate) as Year, 
Part, 
Description, 
InspectionSpecification_type, 
CalculatedResult, 
Result, 
Inspection_No 
From uniPoint_CompanyH.dbo.PT_Inspection
Where Status = 'Complete' and LEFT(Job, 2) like ('RD') and InspectionSpecification_type in ('First Article', 'In Process')
Select * FROM (
Select StockCode
,Description
,LongDesc
,InspectionFlag
,LEFT(DrawOfficeNum, CASE WHEN CHARINDEX(' ',DrawOfficeNum) - 1 < 0 Then LEN(DrawOfficeNum) Else CHARINDEX(' ',DrawOfficeNum) - 1 END) as DrawingNumber 
,CASE WHEN CHARINDEX(' ', DrawOfficeNum) = 0 THEN ' ' ELSE RIGHT(DrawOfficeNum, LEN(DrawOfficeNum) - CHARINDEX(' ',DrawOfficeNum)) END as DrawingRev 
From CompanyH.dbo.InvMaster 
Where DrawOfficeNum <> ' ') Office
Where DrawingNumber = '984277'
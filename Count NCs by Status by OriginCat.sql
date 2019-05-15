Declare @start as date
Declare @end as date

Set @start = '3/1/18'
Set @end = '3/31/19'


Select Status, Count(NCR) as CurrentStatus
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end and Material in (Select Component COLLATE Latin1_General_Bin as Material From CompanyH.dbo.BomStructure Where ParentPart = '537BK')
Group By Status
Order By Count(NCR) DESC


Select Origin_category, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end and Status NOT IN ('Origination') and Material in (Select Component COLLATE Latin1_General_Bin as Material From CompanyH.dbo.BomStructure Where ParentPart = '537BK')
Group By Origin_category
Order By Count(NCR) DESC

Select NC_type, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end and Material in (Select Component COLLATE Latin1_General_Bin From CompanyH.dbo.BomStructure Where ParentPart = '537BK')
Group By NC_type
Order By Count(NCR) DESC


Select MONTH(NCR_Date) as Month, COUNT(NCR) as Count, (MONTH(NCR_Date) - MONTH(getdate())) as OrderRank
FROM uniPoint_CompanyH.dbo.PT_NC
WHERE NCR_Date > DATEADD(dd, -365, getdate()) and Material in (Select Component COLLATE Latin1_General_Bin as Material From CompanyH.dbo.BomStructure Where ParentPart = '537BK')
Group By MONTH(NCR_Date)
Order By OrderRank DESC
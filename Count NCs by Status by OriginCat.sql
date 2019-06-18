Declare @start as date
Declare @end as date

Set @start = '5/1/19'
Set @end = '5/31/19'


Select Status, Count(NCR) as CurrentStatus
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end
Group By Status
Order By Count(NCR) DESC


Select Origin_cause, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end and Status NOT IN ('Origination')
Group By Origin_cause
Order By Count(NCR) DESC

Select NC_type, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between @start and @end
Group By NC_type
Order By Count(NCR) DESC


Select MONTH(NCR_Date) as Month, COUNT(NCR) as Count, (MONTH(NCR_Date) - MONTH(getdate())) as OrderRank
FROM uniPoint_CompanyH.dbo.PT_NC
WHERE NCR_Date > DATEADD(dd, -365, getdate())
Group By MONTH(NCR_Date)
Order By OrderRank DESC
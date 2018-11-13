Select Status, Count(NCR) as CurrentStatus
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between '8/5/18' and '9/1/18'
Group By Status
Order By Count(NCR) DESC


Select Origin_category, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between '8/5/18' and '9/1/18' --and NC_type = 'Vendor'
Group By Origin_category
Order By Count(NCR) DESC

Select NC_type, Count(NCR) as Count
From uniPoint_CompanyH.dbo.PT_NC
Where NCR_Date between '8/5/18' and '9/1/18'
Group By NC_type
Order By Count(NCR) DESC
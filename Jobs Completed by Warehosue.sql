Select COUNT(Job) As TotalJobs, Warehouse
From CompanyH.dbo.WipMaster
Where ActCompleteDate between '3/3/19' and '3/30/19'
Group By Warehouse
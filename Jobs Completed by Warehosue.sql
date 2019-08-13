Select COUNT(Job) As TotalJobs, Warehouse
From CompanyH.dbo.WipMaster
Where ActCompleteDate between '6/30/19' and '8/3/19'
Group By Warehouse
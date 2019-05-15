Select COUNT(Job) as RwkCount, StockCode, StockDescription From CompanyH.dbo.WipMaster Where Job like ('RWK%') and JobStartDate > getdate() - 365
Group By StockCode, StockDescription
Order By RwkCount DESC


Select COUNT(NCR) as NCRCount, Material, Description From uniPoint_CompanyH.dbo.PT_NC Where NCR_Date >= getdate() - 365
Group By Material, Description
Order by NCRCount DESC

Select NCR, Material, Description From uniPoint_CompanyH.dbo.PT_NC Where NCR_Date >= getdate() - 365 and Material in (Select Component COLLATE Latin1_General_BIN From CompanyH.dbo.BomStructure Where ParentPart in ('4600', '495'))


Select Sum(QtyManufactured) as JobCount, StockCode, StockDescription From CompanyH.dbo.WipMaster Where Job like ('AS%') and StockCode like ('87') and StockDescription not like ('%CUSTOM%')
Group By StockCode, StockDescription
Order By JobCount

Select COUNT(Job) as JobCount, StockCode From CompanyH.dbo.WipMaster Where Job like ('RMA%') and StockCode like ('87') and JobStartDate >= getdate()-365
Group By StockCode


Select Count(Job) as JobCount, StockCode 
From CompanyH.dbo.WipMaster 
Where Job like ('RMA%') and JobStartDate >= getdate() - 365
Group By StockCode
Order By JobCount DESC

Select SUM(TrnQty) as TotalRecieved, StockCode
From CompanyH.dbo.InvMovements 
Where TrnType = 'I'
Group By StockCode


Select SUM(a.QtyToMake) as ThisYrReturnedQty, TotalSales, CurrentSales, CASE WHEN TotalSales = 0 THEN 0 ELSE (SUM(a.QtyToMake)/TotalSales)*100 END as TotalReturnRate, CASE WHEN CurrentSales = 0 THEN 0 ELSE (SUM(a.QtyToMake)/CurrentSales)*100 END as CurrentReturnRate, a.StockCode, YEAR(LastDate) as LastYearTrns
From CompanyH.dbo.WipMaster a
Join CompanyH.dbo.RmaDetail b on RmaNumber = RIGHT(JobDescription, 15)
Join (Select SUM(TrnQty) as TotalSales, StockCode
		From CompanyH.dbo.InvMovements 
		Where Warehouse in ('F', 'RS', 'G') and SalesOrder <> ''
		Group By StockCode
		) c on a.StockCode = c.StockCode
Join (Select Max(EntryDate) as LastDate, StockCode
		From CompanyH.dbo.InvMovements
		Where Warehouse <> 'PS'
		Group By StockCode) d on d.StockCode = a.StockCode
Join (Select SUM(TrnQty) as CurrentSales, StockCode
		From CompanyH.dbo.InvMovements
		Where Warehouse in ('F', 'RS', 'G') and SalesOrder <> '' and EntryDate >= '10/1/18'
		Group By StockCode) e on e.StockCode = a.StockCode
Where a.Job like ('RMA%') and ProblemCode not in ('106', 'TS') and JobStartDate >= getdate() - 365 and TotalSales > 100 and YEAR(LastDate) >= 2018
Group By a.StockCode, TotalSales, CurrentSales, LastDate
Order By CurrentReturnRate DESC



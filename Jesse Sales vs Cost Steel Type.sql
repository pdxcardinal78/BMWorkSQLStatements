Select TrnYear
,QuantitySold
,turd.*
,SalesValue as TotalSales
From (Select StockCode
,Description
,LongDesc
,CASE When LongDesc like ('%20CV%') Then '20CV'
	  When LongDesc like ('%M390%') Then 'M390'
	  When LongDesc like ('%M4%') Then 'M4'
	  When LongDesc like ('%3V%') Then '3V'
	  When LongDesc like ('%S90V%') Then 'S90V' End as SteelType
,LabourCost + MaterialCost + FixOverhead + VariableOverhead as Cost
From CompanyH.dbo.InvMaster Where Version <> 'DISC') turd
Join [CompanyH].[dbo].[SalHistoryMaster] c
on c.StockCode = turd.StockCode
Where SteelType is not NULL and TrnYear = '2019'
Order By StockCode


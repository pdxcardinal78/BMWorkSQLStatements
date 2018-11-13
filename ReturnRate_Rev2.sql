Select CASE WHEN PilotPassed IS NOT NULL THEN PilotPassed ELSE FirstDateOfSale END as LaunchDate, t1.StockCode, SUM(TrnValue) as TotalSales, SUM(TrnQty) as TotalQtySold, TotalRmaReturns, MainProblem, CASE WHEN SUM(TrnQty) = 0 THEN 0 ELSE TotalRmaReturns / SUM(TrnQty) * 100 END as ReturnRate From CompanyH.dbo.InvMovements t1
Join CompanyH.dbo.[InvMaster+] t2
On t1.StockCode = t2.StockCode 
LEFT JOIN (Select TotalRma.StockCode
			,MainProblem
			,SUM(TotalRma.QtyToMake) as TotalRmaReturns
			From (Select t4.*
				  ,CASE WHEN UPPER(t5.ProblemType) like ('LIFE%') Then 'LIFESHARP' ELSE 'WARRANTY' END as MainProblem 
				  From (Select Job
							,StockCode
							,QtyToMake
							,StockDescription
							,RIGHT(JobDescription, LEN(JobDescription)- CHARINDEX(':', JobDescription)) as RmaNumber
							from CompanyH.dbo.WipMaster t3
							Where JobStartDate between DATEADD(yy, -3, getdate()) and getdate())t4
				  Join CompanyH.dbo.[RmaDetail+] t5
				  On t5.RmaNumber = t4.RmaNumber Where t4.Job like ('RMA%'))TotalRma
			GROUP By TotalRma.StockCode, MainProblem)t6
	On t1.StockCode = t6.StockCode
Where MovementType = 'S'
and SalesOrder <> ''
and Job = '' 
--and EntryDate between DATEADD(yy,-3,getdate()) and getdate()
and (t2.PilotPassed between DATEADD(yy,-3,getdate()) and getdate() or FirstDateOfSale between DATEADD(yy,-3,getdate()) and getdate())
and t6.MainProblem = 'WARRANTY'
GROUP BY t1.StockCode, t6.TotalRmaReturns, MainProblem, PilotPassed, FirstDateOfSale
Order By ReturnRate DESC

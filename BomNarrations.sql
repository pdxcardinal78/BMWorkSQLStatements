SELECT t1.[StockCode]
,Description
,[Route]
,[Operation]
,[WorkCentre]
,[AutoNarrCode]
,NarrationNum
,Narration = CAST(STUFF(
						(Select CHAR(10) + CHAR(13) + ' '  + [Narration] + ' ' FROM CompanyH.dbo.BomNarration t4
						Where t4.NarrationNum = t3.NarrationNum
						FOR XML PATH('')
						), 1, 8, '') as NVARCHAR(4000))
 FROM [CompanyH].[dbo].[BomOperations] t1
 join BomNarration t3
 on NarrationNum = AutoNarrCode
 join InvMaster t2
 on t1.StockCode = t2.StockCode
 Group By t1.StockCode, Description, WorkCentre, Operation, AutoNarrCode, Route, NarrationNum
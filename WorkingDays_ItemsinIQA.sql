-- Section for PO Items

SELECT t1.[Grn]
,t1.[Version]
,[GrnReceiptDate]
,t1.[StockCode]
,t2.[Description]
,[Warehouse]
,[PurchaseOrder]
,[PurchaseOrderLin]
,t1.[Supplier]
,[QtyAdvised]
,[QtyInspected]
,[QtyCounted]
,[QtyAccepted]
,[QtyScrapped]
,[QtyRejected]
,[CountCompleted]
,[InspectCompleted]
,[PoPrice]
,DATEDIFF(day, [GrnReceiptDate], GETDATE()) AS [DaysInInspection]
,WorkingDays
,LEFT(RIGHT(t2.Description, LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1), CHARINDEX(' ', RIGHT(t2.Description,LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1))) as 'Knife Model'
FROM [CompanyH].[dbo].[InvInspect] t1
Left Join [CompanyH].[dbo].[InvMaster] t2
On t1.StockCode = t2.StockCode
Left Join (Select Grn, Count(Grn) as WorkingDays 
		From CompanyH.dbo.InvInspect 
		Cross Join BenchmadeDB.dbo.fn_ProductionDays()
		Where ProductionDay >= GrnReceiptDate and ProductionDay <= DATEADD(dd, -1, getdate())
		Group By Grn) as z
On t1.Grn = z.Grn
Where (QtyAdvised - QtyCounted <> 0) and CountCompleted = 'N'


-- Section for WIP Items

Select  t1.Job
	,StockCode
	,StockDescription
	,Complete
	,t1.Operation
	,IExpUnitRunTim
	,ParentQtyPlanEnt
	,OperCompleted
	,QtyCompleted
	,QtyScrapped
	,WorkCentre
	,JobStartDate
	,ActualFinishDate
	,LEFT(RIGHT(StockDescription, CASE WHEN 
									LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 
																																																								LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 'Knife Model'
	,LAG(ActualFinishDate) OVER (PARTITION BY t1.Job Order By t1.Operation) as PrevFinishDate
	,LAG(t1.Operation) OVER (PARTITION BY t1.Job Order By t1.Operation) as PrevOperation
	,LAG(WorkCentre) OVER (PARTITION BY t1.Job Order By t1.Operation) as PrevWorkCentre
	,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY t1.Job Order By t1.Operation) IS NULL THEN 'Y' ELSE LAG(OperCompleted) OVER (PARTITION BY t1.Job Order By t1.Operation) END as PrevCompleted
	,WorkingDays
From WipJobAllLab t1
Join WipMaster t2
On t1.Job = t2.Job
Left Join (Select z.Job, z.Operation, PrevFinishDate, Count(z.Job) as WorkingDays 
			From (Select x.Job
					,Operation
					,CASE WHEN (LAG(ActualFinishDate) OVER (PARTITION BY x.Job Order By x.Operation)) IS NULL THEN y.JobStartDate ELSE (LAG(ActualFinishDate) OVER (PARTITION BY x.Job Order By x.Operation)) END as PrevFinishDate
				  FROM CompanyH.dbo.WipJobAllLab x
				  Join CompanyH.dbo.WipMaster y 
				  on x.Job = y.Job
				  WHERE ActualFinishDate >= DATEADD(mm, -6,getdate()))z
			Cross Join BenchmadeDB.dbo.fn_ProductionDays()
			Where ProductionDay <= DATEADD(dd, -1, getdate()) and ProductionDay >= PrevFinishDate
			Group By z.Job, z.Operation, PrevFinishDate) as zz
On t1.Job = zz.Job and t1.Operation = zz.Operation
Where WorkCentre = 'INSPCT'

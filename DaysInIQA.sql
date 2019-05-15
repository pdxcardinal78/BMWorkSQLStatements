Select CASE WHEN LEFT([Job/GRN], 2) in ('RD', 'PI', 'TJ') THEN 'NPI' ELSE 'IQA' END as InspectionType
,[Job/GRN]
,PrevFinishDate
,ActualFinishDate
,' ' as TransWarehouse
,DATEDIFF(dd, PrevFinishDate, ActualFinishDate) - (DATEDIFF(wk, PrevFinishDate, ActualFinishDate)*2) - (CASE WHEN DATENAME(dw,PrevFinishDate) = 'Sunday' THEN 1 ELSE 0 END) -  (CASE WHEN DATENAME(dw, ActualFinishDate) = 'Saturday' THEN 1 ELSE 0 END) as DaysInIQA
		FROM(
				SELECT t1.Job as [Job/GRN]
				,Operation
				,IExpUnitRunTim
				,ParentQtyPlanEnt
				,OperCompleted
				,QtyCompleted
				,QtyScrapped
				,WorkCentre
				,JobStartDate
				,ActualFinishDate
				,CASE WHEN LAG(ActualFinishDate) OVER (PARTITION BY t1.Job Order By Operation) IS NULL THEN JobStartDate ELSE LAG(ActualFinishDate) OVER (PARTITION BY t1.Job Order By Operation) END as PrevFinishDate
				,LAG(Operation) OVER (PARTITION BY t1.Job Order By Operation) as PrevOperation
				,CASE WHEN LAG(WorkCentre) OVER (PARTITION BY t1.Job Order By Operation) is NULL THEN 'None' ELSE LAG(WorkCentre) OVER (PARTITION BY t1.Job Order By Operation) END as PrevWorkCentre
				,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY t1.Job Order By Operation) IS NULL THEN 'Y' ELSE LAG(OperCompleted) OVER (PARTITION BY t1.Job Order By Operation) END as PrevCompleted
				From CompanyH.dbo.WipJobAllLab t1
				Join CompanyH.dbo.WipMaster t2
				on t1.Job = t2.Job) LT
Where WorkCentre = 'INSPCT' and OperCompleted = 'Y' and PrevCompleted = 'Y'

Union

SELECT CASE WHEN [TransWarehouse] = 'RD' THEN 'NPI' ELSE 'IQA' END as InspectionType 
	  ,t1.Grn as [Job/GRN]
      ,t1.GrnReceiptDate as PrevFinishDate
      ,[TransDate] as ActualFinishDate
	  ,[TransWarehouse]
	  ,DATEDIFF(dd, t1.GrnReceiptDate, TransDate) - (DATEDIFF(wk, t1.GrnReceiptDate, TransDate) *2) - (CASE WHEN DATENAME(dw, t1.GrnReceiptDate) = 'Sunday' THEN 1 ELSE 0 END)
  -(CASE WHEN DATENAME(dw, TransDate) = 'Saturday' THEN 1 ELSE 0 END) as DaysInInspection
	  
  FROM CompanyH.dbo.InvInspect as t1
  join CompanyH.dbo.InvDocument as t2
  on t1.Grn = t2.Grn
 Where TransQuantity > 0
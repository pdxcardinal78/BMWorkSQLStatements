/*** This section pulls all Jobs going to RD warehouse as FAI and all Jobs Going to P warehouse as In Process ***/
SELECT * FROM (Select WJAL.Job
,StockCode
,StockDescription
,Complete
,WJAL.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
From (Select j.Job
            ,Operation
            ,IExpUnitRunTim
            ,ParentQtyPlanEnt
            ,OperCompleted
            ,QtyCompleted
            ,QtyScrapped
            ,WorkCentre
            ,ActualFinishDate
            ,CASE WHEN Operation <= 10 THEN PlannedStartDate ELSE LAG(ActualFinishDate) OVER (PARTITION BY j.Job Order By 
			Operation) END as PrevFinishDate
            ,LAG(Operation) OVER (PARTITION BY j.Job Order By Operation) as 
			PrevOperation
            ,LAG(WorkCentre) OVER (PARTITION BY j.Job Order By Operation) as 
			PrevWorkCentre
			,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY j.Job Order By 
			Operation) IS NULL and Operation = 10 THEN 'Y' ELSE LAG(OperCompleted) OVER 
			(PARTITION BY j.Job Order By Operation) END as PrevCompleted
        From CompanyH.dbo.WipJobAllLab j
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) WJAL
Join CompanyH.dbo.WipMaster t2
On WJAL.Job = t2.Job)aj
Where ActualFinishDate = '5/1/19' and PrevFinishDate IS NULL
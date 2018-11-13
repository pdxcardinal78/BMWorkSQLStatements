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
,LEFT(RIGHT(StockDescription, CASE WHEN 
                                LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 

LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE 
LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 
'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,InspectionSpecification_No COLLATE Latin1_General_BIN as InspectionSpec_No
,InspectionSpecification_type as InspectionSpec_type
,Status
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
			,CASE WHEN Warehouse = 'RD' THEN 'First Article' When Warehouse = 'P' THEN 'In Process' ELSE 'Other' END as typeCheck
        From CompanyH.dbo.WipJobAllLab j
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) WJAL
Join CompanyH.dbo.WipMaster t2
On WJAL.Job = t2.Job
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on StockCode = Part COLLATE Latin1_General_BIN
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete' and InspectionSpecification_type = typeCheck

UNION

/*** This section pulls jobs that don't have any inspection specifications listed ***/
Select WJAL2.Job
,StockCode
,StockDescription
,Complete
,WJAL2.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,LEFT(RIGHT(StockDescription, CASE WHEN LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,'NOT CREATED' as InsepctionSpec_No
,InspectionSpecification_type
,Status
From (Select Job
        ,Operation
        ,IExpUnitRunTim
        ,ParentQtyPlanEnt
        ,OperCompleted
        ,QtyCompleted
        ,QtyScrapped
        ,WorkCentre
        ,ActualFinishDate
        ,CASE WHEN Operation <= 10 THEN PlannedStartDate ELSE LAG(ActualFinishDate) OVER (PARTITION BY Job Order By Operation) END as 
		PrevFinishDate
        ,LAG(Operation) OVER (PARTITION BY Job Order By Operation) as 
		PrevOperation
        ,LAG(WorkCentre) OVER (PARTITION BY Job Order By Operation) as 
		PrevWorkCentre
		,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY Job Order By 
		Operation) IS NULL and Operation = 10 THEN 'Y' ELSE LAG(OperCompleted) OVER (PARTITION BY 
		Job Order By Operation) END as PrevCompleted
    From CompanyH.dbo.WipJobAllLab) WJAL2
Join CompanyH.dbo.WipMaster t5
On WJAL2.Job = t5.Job
Left Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t6
On StockCode = Part Collate Latin1_General_BIN
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y' and InspectionSpecification_No is NULL

UNION

/*** Trying to find the jobs that have inspection specs but aren't In Process or First Article ***/

Select FM.Job
,t2.StockCode
,StockDescription
,Complete
,FM.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,LEFT(RIGHT(StockDescription, CASE WHEN 
                                LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 

LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE 
LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 
'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,NULL as InspectionSpec_No
,NULL as InspectionSpec_type
,'Unknown' as Status
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
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) FM
Join CompanyH.dbo.WipMaster t2
On FM.Job = t2.Job
Join CompanyH.dbo.InvMaster t4
On t2.StockCode = t4.StockCode
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on CASE WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse = 'RD' and InspectionSpecification_type = 'First Article' THEN 1
		WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse = 'P' and InspectionSpecification_type = 'In Process' THEN 1
		WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse not in ('RD', 'P') and InspectionSpecification_type not in ('First Article', 'In Process') THEN 2
		WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse ='P' and InspectionSpecification_type = 'Reciept' and Supplier is NULL THEN 2
		ELSE 0
		END = 2
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete') LARGEUNION

UNION
/*** Trying to Get ITEMS with the Wrong Spec Created ***/
/*** Trying to Get ITEMS with the wrong spec created ***/
/*** Trying to Get ITEMS with the Wrong Spec Created ***/
/*** Trying to Get ITEMS with the wrong spec created ***/
Select FM.Job
,t2.StockCode
,StockDescription
,Complete
,FM.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,LEFT(RIGHT(StockDescription, CASE WHEN 
                                LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 

LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE 
LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 
'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,NULL as InspectionSpec_No
,NULL as InspectionSpec_type
,'Unknown' as Status
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
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) FM
Join CompanyH.dbo.WipMaster t2
On FM.Job = t2.Job
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on CASE WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse = 'P' and InspectionSpecification_type = 'First Article' and not InspectionSpecification_type = 'In Process' THEN 1
		ELSE 2
		END = 1
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete' and FM.Job NOT IN(SELECT Job FROM (Select WJAL.Job
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
,LEFT(RIGHT(StockDescription, CASE WHEN 
                                LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 

LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE 
LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 
'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,InspectionSpecification_No COLLATE Latin1_General_BIN as InspectionSpec_No
,InspectionSpecification_type as InspectionSpec_type
,Status
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
			,CASE WHEN Warehouse = 'RD' THEN 'First Article' When Warehouse = 'P' THEN 'In Process' ELSE 'Other' END as typeCheck
        From CompanyH.dbo.WipJobAllLab j
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) WJAL
Join CompanyH.dbo.WipMaster t2
On WJAL.Job = t2.Job
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on StockCode = Part COLLATE Latin1_General_BIN
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete' and InspectionSpecification_type = typeCheck

UNION

/*** This section pulls jobs that don't have any inspection specifications listed ***/
Select WJAL2.Job
,StockCode
,StockDescription
,Complete
,WJAL2.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,LEFT(RIGHT(StockDescription, CASE WHEN LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,'NOT CREATED' as InsepctionSpec_No
,InspectionSpecification_type
,Status
From (Select Job
        ,Operation
        ,IExpUnitRunTim
        ,ParentQtyPlanEnt
        ,OperCompleted
        ,QtyCompleted
        ,QtyScrapped
        ,WorkCentre
        ,ActualFinishDate
        ,CASE WHEN Operation <= 10 THEN PlannedStartDate ELSE LAG(ActualFinishDate) OVER (PARTITION BY Job Order By Operation) END as 
		PrevFinishDate
        ,LAG(Operation) OVER (PARTITION BY Job Order By Operation) as 
		PrevOperation
        ,LAG(WorkCentre) OVER (PARTITION BY Job Order By Operation) as 
		PrevWorkCentre
		,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY Job Order By 
		Operation) IS NULL and Operation = 10 THEN 'Y' ELSE LAG(OperCompleted) OVER (PARTITION BY 
		Job Order By Operation) END as PrevCompleted
    From CompanyH.dbo.WipJobAllLab) WJAL2
Join CompanyH.dbo.WipMaster t5
On WJAL2.Job = t5.Job
Left Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t6
On StockCode = Part Collate Latin1_General_BIN
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y' and InspectionSpecification_No is NULL

UNION

/*** Trying to find the jobs that have inspection specs but aren't In Process or First Article ***/

Select FM.Job
,t2.StockCode
,t2.StockDescription
,Complete
,FM.Operation
,IExpUnitRunTim
,ParentQtyPlanEnt
,OperCompleted
,QtyCompleted
,QtyScrapped
,WorkCentre
,JobStartDate
,ActualFinishDate
,LEFT(RIGHT(StockDescription, CASE WHEN 
                                LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 < 0 THEN 0 ELSE LEN(StockDescription) - CHARINDEX(',', 
StockDescription) - 1 END), CHARINDEX(' ', RIGHT(StockDescription, CASE WHEN 

LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 < 0 THEN 1 ELSE 
LEN(StockDescription) - CHARINDEX(',', StockDescription) - 1 END))) as 
'Knife Model'
,PrevFinishDate
,PrevOperation
,PrevWorkCentre
,PrevCompleted
,DATEDIFF(dd, PrevFinishDate, getdate()) as DaysInInspection
,NULL as InspectionSpec_No
,NULL as InspectionSpec_type
,'Unknown' as Status
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
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) FM
Join CompanyH.dbo.WipMaster t2
On FM.Job = t2.Job
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on CASE WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse = 'RD' and InspectionSpecification_type = 'First Article' THEN 1
		WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse = 'P' and InspectionSpecification_type = 'In Process' THEN 1
		WHEN t2.StockCode = Part COLLATE Latin1_General_BIN and Warehouse not in ('RD', 'P') and InspectionSpecification_type not in ('First Article', 'In Process') THEN 2
		ELSE 0
		END = 2
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete')LARGEUNION WHERE LARGEUNION.Job = FM.Job)
Order By Job 
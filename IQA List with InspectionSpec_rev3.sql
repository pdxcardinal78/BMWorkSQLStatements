SELECT * FROM 
(Select WJAL.Job
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
,InspectionSpecification_No COLLATE Latin1_General_BIN as InspectionSpec_No
,InspectionSpecification_type
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
            ,LAG(ActualFinishDate) OVER (PARTITION BY j.Job Order By 
			Operation) as PrevFinishDate
            ,LAG(Operation) OVER (PARTITION BY j.Job Order By Operation) as 
			PrevOperation
            ,LAG(WorkCentre) OVER (PARTITION BY j.Job Order By Operation) as 
			PrevWorkCentre
			,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY j.Job Order By 
			Operation) IS NULL and Operation = 10 THEN 'Y' ELSE LAG(OperCompleted) OVER 
			(PARTITION BY j.Job Order By Operation) END as PrevCompleted
			,CASE WHEN Warehouse = 'RD' THEN 'First Article' ELSE 'Other' END as typeCheck
        From CompanyH.dbo.WipJobAllLab j
		Join CompanyH.dbo.WipMaster k on j.Job = k.Job ) WJAL
Join CompanyH.dbo.WipMaster t2
On WJAL.Job = t2.Job
Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
on StockCode = Part COLLATE Latin1_General_BIN
WHERE WorkCentre = 'INSPCT' and OperCompleted = 'N' and Complete = 'N' and PrevCompleted = 'Y' and t3.Status <> 'Obsolete' and InspectionSpecification_type = typeCheck --and WJAL.Job = 'TRN0002951'


UNION


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
,InspectionSpecification_No COLLATE Latin1_General_BIN as InsepctionSpec_No
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
        ,LAG(ActualFinishDate) OVER (PARTITION BY Job Order By Operation) as 
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
On Case
--WHEN Warehouse = 'RD' and StockCode = Part Collate Latin1_General_BIN and InspectionSpecification_type <> 'First Article' and InspectionSpecification_type <> 'FYI' THEN 1
WHEN Warehouse <> 'RD' and StockCode = Part Collate Latin1_General_BIN and InspectionSpecification_type = 'In Process' THEN 1
ELSE 0
END = 1
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y' and InspectionSpecification_No is not NULL and Status <> 'Obsolete' --and WJAL2.Job = 'TRN0002951'


UNION

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
,InspectionSpecification_No COLLATE Latin1_General_BIN as InsepctionSpec_No
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
        ,LAG(ActualFinishDate) OVER (PARTITION BY Job Order By Operation) as 
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
On Case
--WHEN Warehouse = 'RD' and StockCode = Part Collate Latin1_General_BIN and InspectionSpecification_type <> 'First Article' and InspectionSpecification_type <> 'FYI' THEN 1
WHEN Warehouse <> 'RD' and StockCode = Part Collate Latin1_General_BIN and InspectionSpecification_type = 'FYI' THEN 1
ELSE 0
END = 1
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y' and InspectionSpecification_No is not NULL and Status <> 'Obsolete' --and WJAL2.Job = 'TRN0002951'
) BIG

UNION

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
,NULL as InsepctionSpec_No
,NULL as InspectionSpec_type
,'Unknown' as Status 
From (Select s.Job
        ,s.Operation
        ,IExpUnitRunTim
        ,ParentQtyPlanEnt
        ,OperCompleted
        ,QtyCompleted
        ,QtyScrapped
        ,WorkCentre
        ,ActualFinishDate
        ,LAG(ActualFinishDate) OVER (PARTITION BY s.Job Order By s.Operation) as 
		PrevFinishDate
        ,LAG(s.Operation) OVER (PARTITION BY s.Job Order By s.Operation) as 
		PrevOperation
        ,LAG(WorkCentre) OVER (PARTITION BY s.Job Order By s.Operation) as 
		PrevWorkCentre
		,CASE WHEN LAG(OperCompleted) OVER (PARTITION BY s.Job Order By 
		s.Operation) IS NULL and s.Operation = 10 THEN 'Y' ELSE LAG(OperCompleted) OVER (PARTITION BY 
		s.Job Order By s.Operation) END as PrevCompleted
		From CompanyH.dbo.WipJobAllLab s
		Join CompanyH.dbo.WipMaster t on s.Job = t.Job
		Join uniPoint_CompanyH.dbo.PT_InspectionSpecification u
		On CASE WHEN StockCode = Part Collate Latin1_General_Bin and Warehouse <> 'RD'  and InspectionSpecification_type in ('Reciept', 'First Article') and InspectionSpecification_type <> 'In Process' THEN 1 ELSE 0 END = 1) WJAL2
Join CompanyH.dbo.WipMaster t5
On WJAL2.Job = t5.Job
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y'


UNION

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
,InspectionSpecification_No COLLATE Latin1_General_BIN as InsepctionSpec_No
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
        ,LAG(ActualFinishDate) OVER (PARTITION BY Job Order By Operation) as 
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
WHERE WorkCentre = 'INSPCT' and OperCompleted <> 'Y' and Complete = 'N' and  PrevCompleted = 'Y' and InspectionSpecification_No is NULL --and WJAL2.Job = 'TRN0002951'

Order By Job
Select Model, SUM(QtyToMake) as TotalMade, Sum(NeedComp_Cost) as CostofIssued, SUM(ValueIssued) as CostofValueIssued, SUM(NeededTotalCost) as InvValueTotal
From(
Select a.StockCode as Model
,a.QtyToMake
,b.Job
,b.StockCode
,b.StockDescription
,b.UnitQtyReqd
,b.UnitCost
,b.UnitCost*b.UnitQtyReqd as NeedComp_Cost
,b.ValueIssued
,c.MaterialCost + c.LabourCost + FixOverhead + VariableOverhead + SubContractCost as TotalCost
,(c.MaterialCost + c.LabourCost + FixOverhead + VariableOverhead + SubContractCost) * b.UnitQtyReqd as NeededTotalCost
From CompanyH.dbo.WipMaster a 
Join CompanyH.dbo.WipJobAllMat b on a.Job = b.Job
Join CompanyH.dbo.InvMaster c on b.StockCode = c.StockCode
Where a.JobClassification = 'RMA' and JobStartDate between '4/1/19' and '4/30/19' and b.Warehouse = 'WR' 
and RIGHT(JobDescription, 15) in (SELECT RmaNumber FROM CompanyH.dbo.RmaDetail WHERE ProblemCode not in ('105', '15')))PS
Group By Model
Order By TotalMade DESC
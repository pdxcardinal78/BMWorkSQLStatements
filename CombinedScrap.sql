Declare @Start as Date
Declare @End as Date

Set @Start = '6/17/19'
Set @End = '6/17/19'

Select 'WIP' as TransType, StockCode, StockDescription as Description, DateEntry as EntryDate, Job, WorkCentre as WorkCenter, Operator, '' as Reference, '' as AddReference, NonProdScrap as ScrapCode, ScrapDescription, QtyScrapped, TotalScrapCost as ScrapCost
FROM(Select t1.Job, t4.StockCode, t4.StockDescription,t1.Operation, Operator, t3.WorkCentre, Machine, DateEntry, t1.QtyScrapped, t1.Journal, t1.NonProdScrap, t2.Description as ScrapDescription,
t4.QtyToMake, t4.QtyManufactured, t4.ExpMaterial, t4.ExpLabour, IExpUnitRunTim, SubUnitValue, IExpSetUpTime, RunTimeRate1, FixOverRate1, Ebq,
UnitLabor, RTotalUnitLabor, UnitOverhead, RTotalUnitOverhead, t9.UnitMaterialCost, (RTotalUnitLabor + RTotalUnitOverhead + t9.UnitMaterialCost)*t1.QtyScrapped as TotalScrapCost
From CompanyH.dbo.WipScrapDet t1
Join (Select t5.Job, Operation, t5.WorkCentre, IExpUnitRunTim, SubUnitValue, IExpSetUpTime, RunTimeRate1, FixOverRate1, Ebq,
		CASE WHEN t5.WorkCentre = 'ZSUB' THEN SubUnitValue WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * RunTimeRate1) END as UnitLabor,
		SUM(CASE WHEN t5.WorkCentre = 'ZSUB' THEN SubUnitValue WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * RunTimeRate1) END) OVER (PARTITION BY t5.Job ORDER BY  t5.Operation) as RTotalUnitLabor,
		CASE WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * FixOverRate1) END as UnitOverhead,
		SUM(CASE WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * FixOverRate1) END) OVER (PARTITION BY t5.Job ORDER BY t5.Operation) as RTotalUnitOverhead 
		From CompanyH.dbo.WipJobAllLab t5
		Join CompanyH.dbo.BomWorkCentre t6
		on t5.WorkCentre = t6.WorkCentre
		Join CompanyH.dbo.WipMaster t7
		on t5.Job = t7.Job
		Join CompanyH.dbo.InvMaster t8
		on t7.StockCode = t8.StockCode
	  ) as RTQ
on RTQ.Job = t1.Job and RTQ.Operation = t1.Operation
Join CompanyH.dbo.WipScrapCode t2
on t1.NonProdScrap = t2.NonProdScrap
Join CompanyH.dbo.WipLabJnl t3
on t1.Job = t3.Job and t1.Operation = t3.Operation and t1.Journal = t3.Journal
Join CompanyH.dbo.WipMaster t4
on t4.Job = t1.Job
Join (Select DISTINCT Job, SUM(UnitCost * UnitQtyReqd) over (Partition By Job Order By Job) as UnitMaterialCost FROM CompanyH.dbo.WipJobAllMat) as t9
on t1.Job = t9.Job
Where LEFT(t1.Job,2) <> 'AS' and LEFT(t1.Job, 3) <> 'RMA' and DateEntry between @Start and @End) WIP

UNION ALL

Select 'NON_PROD' as TransType, StockCode, Description, EntryDate, '' as Job, '' as WorkCenter, Operator, Reference, AddReference, Notation as ScrapCode, ScrapDescription, TrnQty as QtyScrapped, TrnValue as ScrapCost
From(
select
a.StockCode,
e.Description,
a.Warehouse,
TrnYear,
TrnMonth,
EntryDate,
MovementType,
a.Journal,
a.JournalEntry,
a.TrnQty,
a.TrnValue,
a.TrnType,
a.GlCode,
a.Reference,
a.AddReference,
b.Notation,
d.Description as ScrapDescription,
c.Operator
from CompanyH.dbo.InvMovements a join CompanyH.dbo.InvJournalDet b 
on a.StockCode = b.StockCode and a.TrnYear = b.JnlYear and a.TrnMonth = b.JnlMonth and a.Journal = b.Journal and a.JournalEntry = b.EntryNumber
join CompanyH.dbo.InvJournalCtl c on a.TrnYear = c.YearPost and a.TrnMonth = c.MonthPost and a.Journal = c.Journal
join CompanyH.dbo.WipScrapCode d on Notation = NonProdScrap
join CompanyH.dbo.InvMaster e on a.StockCode = e.StockCode
where a.EntryDate between @Start and @End and a.GlCode = '59340-000') NONPROD
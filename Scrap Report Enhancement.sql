--Job Portion of Query (Scrap2)
Select t1.Job, t4.StockCode, t4.StockDescription,t1.Operation, Operator, t3.WorkCentre, Machine, DateEntry, t1.QtyScrapped, t1.Journal, t1.NonProdScrap, Description, ExpMaterial, ExpLabour
From CompanyH.dbo.WipScrapDet t1
Join CompanyH.dbo.WipScrapCode t2
on t1.NonProdScrap = t2.NonProdScrap
Join CompanyH.dbo.WipLabJnl t3
on t1.Job = t3.Job and t1.Operation = t3.Operation and t1.Journal = t3.Journal
Join CompanyH.dbo.WipMaster t4
on t4.Job = t1.Job
Where LEFT(t1.Job, 2) <> 'AS' and LEFT(t1.Job, 3) <> 'RMA' and t1.QtyScrapped <> 0 and t1.Job = 'HAN0070400'


--Labor1 Portion of Query
Select t5.Job, Operation, t5.WorkCentre, IExpUnitRunTim, SubUnitValue, IExpSetUpTime, RunTimeRate1, FixOverRate1, Ebq,
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
Where LEFT(t5.Job,2) <> 'AS' and LEFT(t5.Job, 3) <> 'RMA' and t5.Job = 'HAN0070400'

--Material Cost
Select Job, Sum(UnitCost) as UnitCost, Sum(UnitQtyReqd) as UnitQtyReqd, Sum(UnitCost*UnitQtyReqd) as UnitMaterialsCost
From CompanyH.dbo.WipJobAllMat
Where Left(Job, 2) <> 'AS' and Left(Job, 3) <> 'RMA' and Job = 'HAN0070400'
Group By Job


-- Joining Labor and Scrap and Material Together (ONLY GETTING THE ACTUAL OPERATION LINE SO THE RUNNING TOTAL ISN'T GIVING THE VALUE I WANT)
Select t1.Job, t4.StockCode, t4.StockDescription,t1.Operation, Operator, t3.WorkCentre, Machine, DateEntry, t1.QtyScrapped, t1.Journal, t1.NonProdScrap, t2.Description,
t4.QtyToMake, t4.QtyManufactured, t4.ExpMaterial, t4.ExpLabour, IExpUnitRunTim, SubUnitValue, IExpSetUpTime, RunTimeRate1, FixOverRate1, Ebq,
CASE WHEN t5.WorkCentre = 'ZSUB' THEN SubUnitValue WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * RunTimeRate1) END as UnitLabor,
SUM(CASE WHEN t5.WorkCentre = 'ZSUB' THEN SubUnitValue WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * RunTimeRate1) END) OVER (PARTITION BY t5.Job ORDER BY  t5.Operation) as RTotalUnitLabor,
CASE WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * FixOverRate1) END as UnitOverhead,
SUM(CASE WHEN Ebq = 0 THEN NULL ELSE ((IExpUnitRunTim + (IExpSetUpTime/Ebq)) * FixOverRate1) END) OVER (PARTITION BY t5.Job ORDER BY t5.Operation) as RTotalUnitOverhead,
t9.UnitCost, UnitQtyReqd, SUM(t9.UnitCost * UnitQtyReqd) over (Order By t9.Job) as UnitMaterialCost 
From CompanyH.dbo.WipScrapDet t1
Join CompanyH.dbo.WipScrapCode t2
on t1.NonProdScrap = t2.NonProdScrap
Join CompanyH.dbo.WipLabJnl t3
on t1.Job = t3.Job and t1.Operation = t3.Operation and t1.Journal = t3.Journal
Join CompanyH.dbo.WipMaster t4
on t4.Job = t1.Job
Join CompanyH.dbo.WipJobAllLab t5
on t1.Job = t5.Job and t5.Operation = t1.Operation
Join CompanyH.dbo.BomWorkCentre t6
on t5.WorkCentre = t6.WorkCentre
Join CompanyH.dbo.WipMaster t7
on t5.Job = t7.Job
Join CompanyH.dbo.InvMaster t8
on t7.StockCode = t8.StockCode
LEFT Join CompanyH.dbo.WipJobAllMat t9
on t1.Job = t9.Job
Where LEFT(t1.Job, 2) <> 'AS' and LEFT(t1.Job, 3) <> 'RMA' and t1.QtyScrapped <> 0 and EntryDate between '8/1/18' and '8/8/18' and t1.Job = 'BLA0078599'


Select Top 100 * From CompanyH.dbo.WipJobAllMat
Where Job like 'BLA%'

-- TRYING TO RUN THE RT QUERY BEFORE PULLING IN THE DATA (THIS IS WORKING)
Select t1.Job, t4.StockCode, t4.StockDescription,t1.Operation, Operator, t3.WorkCentre, Machine, DateEntry, t1.QtyScrapped, t1.Journal, t1.NonProdScrap, t2.Description,
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
Where LEFT(t1.Job,2) <> 'AS' and LEFT(t1.Job, 3) <> 'RMA' and DateEntry >= getdate() - 365 and t4.StockCode in (Select Component from CompanyH.dbo.BomStructure Where ParentPart in ('4600', '495'))
Order By TotalScrapCost

-- INV MOVEMENT SCRAP Coreys
select
a.StockCode,
e.Description,
a.Warehouse,
TrnYear,
TrnMonth,
EntryDate,
MovementType,
a.Journal,
a.TrnQty,
a.TrnValue,
a.TrnType,
a.GlCode,
a.Reference,
a.AddReference,
b.Notation,
d.Description,
c.Operator
from CompanyH.dbo.InvMovements a join CompanyH.dbo.InvJournalDet b 
on a.StockCode = b.StockCode and a.TrnYear = b.JnlYear and a.TrnMonth = b.JnlMonth and a.Journal = b.Journal and a.JournalEntry = b.EntryNumber
join CompanyH.dbo.InvJournalCtl c on a.TrnYear = c.YearPost and a.TrnMonth = c.MonthPost and a.Journal = c.Journal
join CompanyH.dbo.WipScrapCode d on Notation = NonProdScrap
join CompanyH.dbo.InvMaster e on a.StockCode = e.StockCode
where a.EntryDate >= getdate() - 365 and a.GlCode = '59340-000' and a.StockCode in (Select Component from CompanyH.dbo.BomStructure Where ParentPart in ('4600', '495'))

-- INV Scrap Ryans
Select DISTINCT
t1.StockCode,
t1.Warehouse,
TrnYear,
TrnMonth,
EntryDate,
MovementType,
t1.Journal,
JournalEntry,
t1.TrnQty,
t1.TrnValue,
t1.TrnType,
t1.GlCode,
t1.Reference,
t1.AddReference,
t3.Notation,
t4.Description,
t5.Operator
From CompanyH.dbo.InvMovements t1
Join CompanyH.dbo.InvMaster t2
On t2.StockCode = t1.StockCode
Join CompanyH.dbo.InvJournalDet t3
on t1.Journal = t3.Journal and JournalEntry = EntryNumber and t1.StockCode = t3.StockCode  and t1.TrnQty = t3.TrnQty
LEFT Join CompanyH.dbo.WipScrapCode t4
on t3.Notation = t4.NonProdScrap
Join CompanyH.dbo.InvJournalCtl t5
on t1.Journal = t5.Journal and EntryDate = t5.JnlDate 
Where EntryDate between  '2-4-2019' and '3/2/19' and t1.GlCode = '59340-000'
ORDER BY Journal



---Invent. Movements
Select * From CompanyH.dbo.InvJournalDet
Where Job = 'HAN0070400'
/****** Script for SelectTopNRows command from SSMS  ******/
Select QRP.StockCode, QRP.StockDescription, QtyToMake, TotalManf,[D1], [B1], [B2], [B3], JRP.TotalScrap as InvScrap,(QRP.TotalScrap + JRP.TotalScrap) as TotalScrap, (QRP.TotalScrap + JRP.TotalScrap)/TotalManf *100 as PercentScrap 
FROM(SELECT StockCode, StockDescription, SUM(QtyToMakeEnt) as QtyToMake ,SUM(QtyManufactured) + SUM(TotalQtyScrapped) as TotalManf, SUM(TotalQtyScrapped) as TotalScrap, SUM(TotalQtyScrapped)/(SUM(TotalQtyScrapped)+SUM(QtyManufactured))*100 as PercentScrap
  FROM [CompanyH].[dbo].[WipMaster]
  Where StockDescription like ('BLADE%') and StockDescription not like ('%BLANK%') and ActCompleteDate >= getdate() - 365 and Complete = 'Y'
  Group By StockCode, StockDescription)QRP
  join
 
(Select StockCode, StockDescription, SUM(TrnQty) as TotalScrap FROM
(select
a.StockCode,
e.Description as StockDescription,
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
where a.EntryDate >= getdate() - 365 and a.GlCode = '59340-000' and e.Description like ('BLADE%') and e.Description not like ('%BLANK%'))QRP
Group By StockCode, StockDescription)JRP
on QRP.StockCode = JRP.StockCode
Join (Select StockCode, [D1], [B1], [B2], [B3]
From(

Select t2.StockCode, StockDescription, NonProdScrap, t3.QtyScrapped From CompanyH.dbo.WipJobAllLab t1
join CompanyH.dbo.WipMaster t2 on t1.Job = t2.Job
join CompanyH.dbo.WipScrapDet t3 on t1.Job = t3.Job and t1.Operation = t3.Operation
Where DateEntry >= getdate()-365 and StockDescription like ('BLADE%') and StockDescription not like ('%BLANK%')) P
PIVOT(SUM(QtyScrapped) For NonProdScrap in ([D1], [B1], [B2], [B3])) as pvt) PRP
on JRP.StockCode = PRP.StockCode
 Where TotalManf > 1000
  Order By PercentScrap Desc

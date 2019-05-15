Select QRP.StockCode, QRP.StockDescription, QtyToMake, TotalManf,[VACMIL], [TGRPEM], [TGRVIB], [TGROIL], JRP.WarehouseScrap, (QRP.TotalScrap + JRP.WarehouseScrap) as TotalScrap, (QRP.TotalScrap + JRP.WarehouseScrap)/TotalManf *100 as PercentScrap 
FROM(SELECT StockCode, StockDescription, SUM(QtyToMakeEnt) as QtyToMake ,SUM(QtyManufactured) + SUM(TotalQtyScrapped) as TotalManf, SUM(TotalQtyScrapped) as TotalScrap, SUM(TotalQtyScrapped)/(SUM(TotalQtyScrapped)+SUM(QtyManufactured))*100 as PercentScrap
  FROM [CompanyH].[dbo].[WipMaster]
  Where StockDescription like ('HANDLE%') and StockDescription not like ('%BLANK%') and ActCompleteDate >= getdate() - 365 and Complete = 'Y'
  Group By StockCode, StockDescription)QRP
 join
 
(Select StockCode, StockDescription, SUM(TrnQty) as WarehouseScrap FROM
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
where a.EntryDate >= getdate() - 365 and a.GlCode = '59340-000' and e.Description like ('HANDLE%') and e.Description not like ('%BLANK%'))QRP
Group By StockCode, StockDescription)JRP
on QRP.StockCode = JRP.StockCode
Join (Select StockCode, [VACMIL], [TGRPEM], [TGRVIB], [TGROIL]
From(

Select StockCode, StockDescription, WorkCentre, QtyScrapped From CompanyH.dbo.WipJobAllLab t1
join CompanyH.dbo.WipMaster t2
on t1.Job = t2.Job
Where ActCompleteDate >= getdate() - 365) P
PIVOT(SUM(QtyScrapped) For WorkCentre in ([VACMIL], [TGRPEM], [TGRVIB], [TGROIL])) as pvt) PRP
on JRP.StockCode = PRP.StockCode
 Where TotalManf > 1000
  Order By PercentScrap Desc
Select StockCode, ProductClass, Buyer, Year(EntryDate) as Year, Month(EntryDate) as Month, SUM(TrnQty) as Total
FROM(Select a.StockCode
,EntryDate
,MovementType
,TrnType
,TrnQty
,SalesOrder
,Journal
,JournalEntry
,UnitCost
,a.ProductClass
,Buyer

From CompanyH.dbo.InvMovements a
Join CompanyH.dbo.InvMaster b on a.StockCode = b.StockCode
Where SalesOrder > 0 and MovementType = 'S' and a.ProductClass <> 'ACSR' and a.ProductClass <> 'COMP')WOW
Group By StockCode, ProductClass, Buyer, Year(EntryDate), Month(EntryDate)

Select
COUNT(Grn) as Counted
,Max(GrnReceiptDate) as LastInspected
,Min(GrnReceiptDate) as FirstInspected
,t1.StockCode
,t2.Description

From InvInspect t1
Join InvMaster t2
on t1.StockCode = t2.StockCode
Where InspectionFlag = 'Y'
Group By t1.StockCode, t2.Description
Order By Counted DESC


Select
Max(GrnReceiptDate) as LastInspected
,Min(GrnReceiptDate) as FirstInspected
,t1.StockCode
,t2.Description

From InvInspect t1
Join InvMaster t2
on t1.StockCode = t2.StockCode
Where InspectionFlag = 'Y'
Group By t1.StockCode, t2.Description


Select Count(Grn) Counted
,t1.StockCode
,Warehouse
From InvMaster t1
Left Outer join InvInspect t2
on t1.StockCode = t2.StockCode
Where InspectionFlag = 'Y' and LongDesc not like ('DISC%')
Group By t1.StockCode, Warehouse
Order By Counted DESC
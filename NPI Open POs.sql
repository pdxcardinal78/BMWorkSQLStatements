Select MStockCode, MStockDes, Warehouse, Supplier, a.PurchaseOrder, Line, LineType, MOrderQty, MReceivedQty, MPrice, MPriceUom, OrderEntryDate, MOrigDueDate, MLatestDueDate, MLastReceiptDat, MReschedDueDate, MSupCatalogue,
CASE WHEN MLastReceiptDat is not null THEN '3. Recieved Last 2 Weeks' WHEN OrderEntryDate >= DATEADD(ww, -1, getdate()) THEN '2. Ordered within LastWeek' ELSE '1. OpenPOs' END as PODetails
From CompanyH.dbo.PorMasterDetail a
Join CompanyH.dbo.PorMasterHdr b on a.PurchaseOrder = b.PurchaseOrder
Where MStockCode in (Select StockCode From CompanyH.dbo.InvMaster
											 Where Planner = 'NPI' and SupercessionDate is NULL)
and (MLastReceiptDat is Null or MLastReceiptDat >= DATEADD(ww,-2,getdate()))
Order By PODetails
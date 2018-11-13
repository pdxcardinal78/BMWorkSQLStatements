Select t1.PurchaseOrder
,Line
,MStockCode
,MStockDes
,MOrderQty
,MWarehouse
,t2.Supplier
,OrderEntryDate
,InspectionSpecification_No
FROM [CompanyH].[dbo].[PorMasterDetail] t1
	  join [CompanyH].[dbo].[PorMasterHdr] t2
	  on t1.PurchaseOrder = t2.PurchaseOrder
	  join [CompanyH].[dbo].[InvMaster]
	  on StockCode = MStockCode
	  left join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification]
	  on StockCode = Part COLLATE SQL_Latin1_General_CP1_CI_AS
Where InspectionFlag = 'Y' 
	and OrderEntryDate between '5/1/2018' and getdate()

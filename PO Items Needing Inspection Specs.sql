Select * 
	FROM (Select * 
	,rank() over (partition by PurchaseOrder, Line order by MOrigDueDate, PurchaseOrder, Line, FirstArticleAvail DESC) as ranknum
		FROM (Select TOP 100 Percent
		t1.PurchaseOrder
		,Line
		,MStockCode
		,MStockDes
		,MOrderQty
		,MWarehouse
		,t2.Supplier
		,OrderEntryDate
		,t1.MOrigDueDate
		,t3.InspectionSpecification_No
		,CASE WHEN t4.InspectionSpecification_type = 'First Article' THEN 'Y' Else '' END as FirstArticleAvail
		,datediff(dd, getdate(), MOrigDueDate) as TimeTillDue
		,ROW_NUMBER() OVER (Order By MOrigDueDate, t1.PurchaseOrder, Line DESC) as RowNumber
		FROM [CompanyH].[dbo].[PorMasterDetail] t1
			  join [CompanyH].[dbo].[PorMasterHdr] t2
			  on t1.PurchaseOrder = t2.PurchaseOrder
			  join [CompanyH].[dbo].[InvMaster]
			  on StockCode = MStockCode
			  left join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t3
			  on StockCode = t3.Part COLLATE SQL_Latin1_General_CP1_CI_AS and t2.Supplier = t3.Vendor COLLATE SQL_Latin1_General_CP1_CI_AS
			  left join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification] t4
			  on StockCode = t4.Part COLLATE SQL_Latin1_General_CP1_CI_AS
		Where InspectionFlag = 'Y' 
			and OrderEntryDate between Dateadd(dd, -30, getdate()) and getdate()
			and t3.InspectionSpecification_No is NULL
			and (MCompleteFlag = ' ' or MCompleteFlag = 'N'))t5 )t6
Where ranknum = 1
Order By TimeTillDue

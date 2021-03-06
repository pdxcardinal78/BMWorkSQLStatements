/****** Script for SelectTopNRows command from SSMS  ******/
SELECT t1.[StockCode]
	  ,t2.[Description]
      ,[Warehouse]
      ,[Bin]
      ,[QtyOnHand1]
      ,[QtyOnHand2]
      ,[QtyOnHand3]
      ,[LastReceiptDate]
      ,[LastIssueDate]
      ,[SoQtyToShip]
      ,[Note]
      ,[QtyDispatched]
      ,[OnHold]
      ,[OnHoldReason]
      
  FROM [CompanyH].[dbo].[InvMultBin] t1
  JOIN [CompanyH].[dbo].[InvMaster] t2
  On t1.StockCode = t2.StockCode
  /***Change SKUS in () to update list ***/
  WHERE t1.StockCode in ('665', '665BK', '6800', '6800BK', '665S', '665SBK', '6800S', '6800SBK') and Warehouse = 'F' and QtyOnHand1 > '0'
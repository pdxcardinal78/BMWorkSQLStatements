/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [StockCode]
      ,[Warehouse]
      ,[TrnYear]
      ,[TrnMonth]
      ,[EntryDate]
      ,[TrnTime]
      ,[MovementType]
      ,[TrnQty]
      ,[TrnValue]
      ,[Source]
      ,[Job]
      ,[Journal]
      ,[JournalEntry]
      ,[EnteredCost]
      ,[TrnType]
      ,[Reference]
      ,[AddReference]
      ,[UnitCost]
      ,[NewWarehouse]
      ,[Bin]
      ,[Supplier]
      ,[GlCode]
      ,[Document]
      ,[SalesOrder]
      ,[InvoiceRegister]
      ,[SummaryLine]
      ,[Invoice]
      ,[DocType]
      ,[Customer]
      ,[CostValue]
      ,[Branch]
      ,[Salesperson]
      ,[SalesBin]
      ,[CustomerPoNumber]
      ,[OrderType]
      ,[Area]
      ,[ProductClass]
      ,[DispatchNote]
      ,[DetailLine]
      ,[Version]
      ,[Release]
      ,[TimeStamp]
      ,[LotSerial]
      ,[IoProcessedFlag]
  FROM [CompanyH].[dbo].[InvMovements]
  Where GlCode = '5934-00' and StockCode in ('100586', '100587', '989905')
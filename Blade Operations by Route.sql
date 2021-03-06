/****** Script for SelectTopNRows command from SSMS  ******/
SELECT c.[StockCode]
      ,[Description]
      ,[Route]
      ,[Operation]
      ,[WorkCentre]
      
  FROM [CompanyH].[dbo].[BomOperations] c
  Join [CompanyH].[dbo].[InvMaster] d on c.StockCode = d.StockCode
  Where LongDesc not like ('DISC%') and LongDesc not like ('OBS%') and Description like ('BLADE,%') and Route = '0'
  Order By StockCode, Route, Operation
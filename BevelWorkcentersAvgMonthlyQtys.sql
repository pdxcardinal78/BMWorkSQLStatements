/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ParentPart]
       ,BO.[Route]
      ,[WorkCentre]
	  ,[Operation]
	  ,[Description]
	  ,[Warehouse]
	  ,([SalesQty1]+[SalesQty2]+[SalesQty3]+[SalesQty4]+[SalesQty5]+[SalesQty6]+[SalesQty7]+[SalesQty8]+[SalesQty9]+[SalesQty10]+[SalesQty11]+[SalesQty12])/12 as AverageSales
  FROM [CompanyH].[dbo].[BomParentInfo] BP
  Join [Companyh].[dbo].[BomOperations] BO on [ParentPart] = BO.[StockCode] and BO.[Route] = BP.[Route]
  Join [CompanyH].[dbo].[InvMaster] IV on [ParentPart] = IV.[StockCode]
  Join [CompanyH].[dbo].[InvWarehouse]IW on [ParentPart] = IW.[StockCode]
  Where [ParentPart] like '98%' and [WorkCentre] in ('GM3BVL', 'BG3', 'BG4', 'VG3', 'VG2', 'BG1', 'BG2', 'BERGER') and BO.[Route] = '0' and [LongDesc] not like 'DISC%' and [LongDesc] not like 'OBS%' and [Warehouse] = 'P'
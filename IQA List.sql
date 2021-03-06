/****** Script for SelectTopNRows command from SSMS  ******/
SELECT A.[Job]
	  ,wm.[StockCode]
	  ,wm.[StockDescription]
	  ,wm.[Complete]
      ,[Operation]
      ,[IExpUnitRunTim]
	  ,[ParentQtyPlanEnt]
      ,[OperCompleted]
      ,[QtyCompleted]
      ,[QtyScrapped]
      ,[WorkCentre]
	  ,[ActualFinishDate]
	  ,LAG (ActualFinishDate, 1, 0) OVER (Partition BY Job ORDER BY Operation DESC) as PreviousDate
	  ,(PreviousDate - GETDATE()) as DaysInIQA
  FROM [CompanyH].[dbo].[WipJobAllLab] as A
  INNER JOIN [CompanyH].[dbo].[WipMaster] as wm
  ON A.[Job] = wm.[Job]
  WHERE WorkCentre = 'INSPCT' and OperCompleted = 'N' and wm.Complete = 'N'
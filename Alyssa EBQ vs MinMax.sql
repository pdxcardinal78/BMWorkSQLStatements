/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.StockCode, Description, Buyer, WarehouseToUse, Ebq, OrderMinimum, OrderMaximum
From CompanyH.dbo.InvMaster a
Join CompanyH.dbo.InvWarehouse b on a.StockCode = b.StockCode and WarehouseToUse = Warehouse
Where Version <> 'DISC' and Warehouse not in ('WR', 'F', 'G', 'RD', 'GL') and Buyer not in ('MSC', 'INA') and a.StockCode not like ('PLAN%') 
and a.StockCode not like ('SCREW%') and a.StockCode not like ('R&D%') and a.StockCode not like ('CLIP%') and (Ebq <> OrderMaximum or Ebq <> OrderMinimum)
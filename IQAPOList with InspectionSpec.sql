SELECT [Grn]
,t1.[Version]
,[GrnReceiptDate]
,t1.[StockCode]
,t2.[Description]
,[Warehouse]
,[PurchaseOrder]
,[PurchaseOrderLin]
,t1.[Supplier]
,[QtyAdvised]
,[QtyInspected]
,[QtyCounted]
,[QtyAccepted]
,[QtyScrapped]
,[QtyRejected]
,[CountCompleted]
,[InspectCompleted]
,[PoPrice]
,DATEDIFF(day, [GrnReceiptDate], GETDATE()) AS [DaysInInspection]
,LEFT(RIGHT(t2.Description, LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1), CHARINDEX(' ', RIGHT(t2.Description,LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1))) as 'Knife Model'

FROM [CompanyH].[dbo].[InvInspect] t1
Left Join [CompanyH].[dbo].[InvMaster] t2
On t1.StockCode = t2.StockCode
Left Join [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification]
on 
Where (QtyAdvised - QtyCounted <> 0) and CountCompleted = 'N' 
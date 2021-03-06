/****** Script for SelectTopNRows command from SSMS  ******/
SELECT MONTH(TransDate) as FisMonth, Count(a.Grn) Count, LEFT(b.Description, CASE WHEN CHARINDEX(',', b.Description) = 0 THEN 0 ELSE CHARINDEX(',', b.Description)-1 END) as PartType, 'PO' as RecordType
	  FROM [CompanyH].[dbo].[InvDocument] a
	  Join CompanyH.dbo.InvInspect c
	  on a.Grn = c.Grn
	  left join CompanyH.dbo.InvMaster b
	  on a.StockCode = b.StockCode
	  Where Year(TransDate) = 2018
	  Group By Month(TransDate), LEFT(b.Description, CASE WHEN CHARINDEX(',', b.Description) = 0 THEN 0 ELSE CHARINDEX(',', b.Description)-1 END)
 
 UNION

  Select Month(d.ActualFinishDate) as FisMonth, Count(d.Job) Count, CASE WHEN f.JobClassification = 'HKS' THEN 'HOOK' ELSE LEFT(f.Description, CASE WHEN CHARINDEX(',', f.Description) = 0 THEN 0 ELSE CHARINDEX(',', f.Description)-1 END) END as PartType, 'WIP' as RecordType
	  From CompanyH.dbo.WipJobAllLab d
	  Join CompanyH.dbo.WipMaster e
	  on d.Job = e.Job
	  join CompanyH.dbo.InvMaster f
	  on e.StockCode = f.StockCode
	  Where Year(d.ActualFinishDate) = 2018 and d.WorkCentre = 'INSPCT'
	  Group By Month(d.ActualFinishDate), CASE WHEN f.JobClassification = 'HKS' THEN 'HOOK' ELSE LEFT(f.Description, CASE WHEN CHARINDEX(',', f.Description) = 0 THEN 0 ELSE CHARINDEX(',', f.Description)-1 END) END
	  Order By FisMonth, PartType
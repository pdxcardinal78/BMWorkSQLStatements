Select 'Inventory' as ScrapType, Sum(TrnQty) as Scrapped, LEFT(RIGHT(t2.Description, LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1), CHARINDEX(' ', RIGHT(t2.Description,LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1))) as FamilyDescription
From CompanyH.dbo.InvMovements t1
Join CompanyH.dbo.InvMaster t2
on t1.StockCode = t2.StockCode
Where GlCode = '59340-000' and EntryDate between '10/1/17' and '8/17/18' and Description like 'BLADE%' and Description not like '%BLANK%'
Group By LEFT(RIGHT(t2.Description, LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1), CHARINDEX(' ', RIGHT(t2.Description,LEN(t2.Description) - CHARINDEX(',', t2.Description) - 1)))

UNION

Select 'Production' as ScrapType, Sum(QtyScrapped) as Scrapped, LEFT(RIGHT(t2.StockDescription, LEN(t2.StockDescription) - CHARINDEX(',', t2.StockDescription) - 1), CHARINDEX(' ', RIGHT(t2.StockDescription,LEN(t2.StockDescription) - CHARINDEX(',', t2.StockDescription) - 1))) as FamilyDescription 
From CompanyH.dbo.WipJobAllLab t1
Join CompanyH.dbo.WipMaster t2
on t1.Job = t2.Job
Join CompanyH.dbo.InvMaster t3
on t2.StockCode = t3.StockCode
Where ActualFinishDate between '10/1/17' and '8/17/18' and t3.Description like 'BLADE%'
Group By LEFT(RIGHT(t2.StockDescription, LEN(t2.StockDescription) - CHARINDEX(',', t2.StockDescription) - 1), CHARINDEX(' ', RIGHT(t2.StockDescription,LEN(t2.StockDescription) - CHARINDEX(',', t2.StockDescription) - 1)))






Select TrnQty, GlCode, t1.StockCode, Description
From CompanyH.dbo.InvMovements t1
Join CompanyH.dbo.InvMaster t2
on t1.StockCode = t2.StockCode
Where Description like 'BLADE, 7 %' and GlCode = '59340-000' and t1.EntryDate between '10/1/17' and '8/17/18'
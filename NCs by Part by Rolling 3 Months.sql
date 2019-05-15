Select * FROM (
Select Material, YEAR(NCR_Date) as Year, Month(NCR_Date) as Month, COUNT(NCR) as NCR_Count From uniPoint_CompanyH.dbo.PT_NC
Group By Material, YEAR(NCR_Date), MONTH(NCR_Date))prd
Where NCR_Count >= 3
Order By NCR_Count DESC;



;With cte
	AS(Select YEAR(NCR_Date) as year
			 ,MONTH(NCR_Date) as month
			 ,Material
			 ,COUNT(NCR) as NCR_Count
			 From uniPoint_CompanyH.dbo.PT_NC
			 Group By YEAR(NCR_Date), MONTH(NCR_Date), Material)

Select a.year
	  ,a.month
	  ,a.Material
	  ,a.NCR_Count + ISNULL(SUM(b.NCR_Count), 0) as [3M Value]
From cte a
LEFT JOIN cte b on b.Material = a.Material AND DATEFROMPARTS(b.year, b.month, 1) IN (DATEADD(mm, -1, DATEFROMPARTS(a.year, b.month, 1)), DATEADD(mm, -2, DATEFROMPARTS(a.year, a.month, 1)))
Group By a.year, a.month, a.Material, a.NCR_Count
Order By [3M Value] DESC



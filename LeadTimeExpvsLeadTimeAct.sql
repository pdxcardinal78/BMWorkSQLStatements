/****** Avg ActLeadTime vs. ExpectedLeadTimeBlades 1/1/18 - Current  ******/

Select t3.StockCode
,StockDescription
,ManufLeadTime as InvMasLeadTime
,BomLeadTime
,AvgActLeadTime
,JobCounts
,Case WHEN AvgActLeadTime = 0 THEN 0 ELSE ManufLeadTime / AvgActLeadTime END  as InvMasPassRate
,Case WHEN AvgActLeadTime = 0 THEN 0 ELSE BomLeadTime / AvgActLeadTime END as BomPassRate
FROM
       (Select t1.StockCode
                     ,StockDescription
                     ,ManufLeadTime
                     ,AVG(DATEDIFF(dd, JobStartDate, ActCompleteDate)) as AvgActLeadTime
                     ,Count(t1.StockCode) as JobCounts
              From CompanyH.dbo.WipMaster t1
              Join CompanyH.dbo.InvMaster t2
              ON t1.StockCode = t2.StockCode
              Where Job like ('BLA%') and JobStartDate >= '1/1/18' and Complete = 'Y' and DATEDIFF(dd, JobStartDate, ActCompleteDate) > 0
              Group By t1.StockCode, StockDescription, ManufLeadTime) t3
Join (
			Select SUM(ABS(ElapsedTime)) as BomLeadTime, StockCode, Route
			FROM CompanyH.dbo.BomOperations
			Where Route = 0
			Group By StockCode, Route ) t4
ON t4.StockCode = t3.StockCode
Where JobCounts > 5
Order By BomPassRate




/************* Stated Lead Time  ********************/
Select StockCode, Description, ManufLeadTime
From CompanyH.dbo.InvMaster Where Description like ('BLADE%')
Order By ManufLeadTime DESC


/************* BOM Lead Time **********************/

  Select SUM(ElapsedTime) as BomLeadTime, StockCode, Route
  FROM CompanyH.dbo.BomOperations
   Where Route = 0
  Group By StockCode, Route 

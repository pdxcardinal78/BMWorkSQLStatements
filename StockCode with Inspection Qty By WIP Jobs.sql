/*** This Query Pulls all WIP jobs that Have INSPT Operations and Counts the number of jobs opened ***/

Select t1.StockCode
,StockDescription
,COUNT(DISTINCT t1.Job) as TimesInspected
,Max(ActualFinishDate)
From WipMaster t1
Join WipJobAllLab t2
On t1.Job = t2.Job
join InvMaster t3
on t1.StockCode = t3.StockCode
Where WorkCentre like ('INSPCT') and t1.Job not like ('RWK%') and t3.Version <> 'DISC' and t3.UserField5 <> 'D' and t3.Version <> 'OBS'
Group By t1.StockCode, t1.StockDescription
Order By TimesInspected DESC

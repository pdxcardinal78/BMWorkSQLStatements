Select * FROM(
Select ordlist.StockCode, ordlist.StockDescription, ordlist.WorkCentre, SUM(QtyCompleted) as TotalCompleted, SUM(RunTimeIssued) as TotalRunTimeIssued, SUM(RunTimeIssued) / SUM(QtyCompleted) as UnitRuntime, AVG(IExpUnitRunTim) as IExpUnitRunTime, (((SUM(RunTimeIssued) / SUM(QtyCompleted))- AVG(IExpUnitRunTim))/NULLIF(AVG(IExpUnitRunTim),0)*100)  as PercentDiff
From (
		Select ROW_NUMBER() OVER (PARTITION By StockCode, WorkCentre Order By ActualFinishDate DESC) As OrderedDate, StockCode, StockDescription, Route, a.*
		From CompanyH.dbo.WipJobAllLab a
		Join CompanyH.dbo.WipMaster b on a.Job = b.Job
		Where ActualFinishDate >= getdate() - 365
		and Warehouse = 'P'
		and QtyCompleted > 0
		and WorkCentre not in ('ZSUB', 'INSPCT')
		and OperCompleted = 'Y'
		and Route = 0
		and (a.Job not like ('RWK%') or a.Job not like ('RD%') or a.Job not like ('PI%') or a.Job not like ('TJ%'))
	) as ordlist
Join CompanyH.dbo.BomOperations c on ordlist.StockCode = c.StockCode and ordlist.WorkCentre = c.WorkCentre and ordlist.Route = c.Route
Where ordlist.OrderedDate <= 5
Group By ordlist.StockCode, ordlist.StockDescription, ordlist.WorkCentre) Tidy
Where PercentDiff >= 20 or PercentDiff <= -20
Order By PercentDiff DESC
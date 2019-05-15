Declare @start as date
Declare @end as date

Set @start = '2/1/19'
Set @end = getdate()

Select * From CompanyH.dbo.WipJobAllLab
Where ActualFinishDate between @start and @end and (Job like ('RD%') or Job like ('PI%'))


Select ActualFinishDate, [BAMMIL] as BAMMIL, [BAMVAC] as BAMVAC, ([BG1] + [BG2] + [BG3] + [BG4] + [BG5] + [BG6]) as BEVEL /* 2. Add any workcentres listed in 1 to this section, you can combine multiple as needed */ 
FROM (Select Job, ActualFinishDate, WorkCentre From CompanyH.dbo.WipJobAllLab Where ActualFinishDate between @start and @end and (Job like ('RD%') or Job like ('PI%'))) as PD
PIVOT
	(
		COUNT(Job)
		For WorkCentre
		in ([BAMMIL], [BAMVAC], [BG1], [BG2], [BG3], [BG4], [BG5], [BG6])) as PT /* 1. Add any work centers of interest in this group of () here */
ORDER BY ActualFinishDate
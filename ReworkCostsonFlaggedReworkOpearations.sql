/***** Script for running Rework Costs on Rework Flagged Operations ****/

  Select Job, Operation, 'ZSUB' as WorkCentre, PurchaseOrder, MLastReceiptDat as FinishDate, MOrderQty as Qty, 0 as SetUpTime, 0 as RunTime, CASE WHEN MPriceUom in ('ea', 'EA', 'Ea') 
																	THEN MPrice * MOrderQty ELSE MPrice END AS ReworkCost 
	FROM (Select Job, Operation
		  From [WipJobAllLab+]
		  Where SubReworkOperation = 'Yes') t1
  join PorMasterDetail t2
  on MJob = Job and MSubcontractOp = Operation
  Where MLastReceiptDat between '4/1/2018' and '4/17/2018'

Union
 
Select t1.Job, t1.Operation, WorkCentre, '' as PurchaseOrder, ActualFinishDate as FinishDate, QtyCompleted as Qty, IExpSetUpTime as SetupTime, RunTimeIssued as RunTime, ((SetUpIssued + RunTimeIssued) * 85) as ReworkCost
FROM (Select Job, Operation FROM [WipJobAllLab+] WHERE ReworkOperation = 'Yes') t1
join WipJobAllLab t2
on t1.Job = t2.Job and t1.Operation = t2.Operation
Where ActualFinishDate between '4/1/2018' and '4/17/2018'
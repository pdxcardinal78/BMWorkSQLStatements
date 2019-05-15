Select ReworkOperation
,x.Job
,x.Operation
,StockCode
,StockDescription
,x.WorkCentre
,SubcontractOp
,SubSupplier
--,PurchaseOrder
,IExpSetUpTime
,IExpUnitRunTim
,SetUpIssued
,RunTimeIssued
,QtyCompleted
,MatValueIssues1
,ValueIssued
--,MPrice * QtyCompleted as POCost
,ActualFinishDate
,SetUpRate1
,RunTimeRate1
,FixOverRate1
,VarOverRate1
From CompanyH.dbo.WipJobAllLab x
Left Join CompanyH.dbo.[WipJobAllLab+] y
on x.Job = y.Job and x.Operation = y.Operation
--Left Join CompanyH.dbo.PorMasterDetail z
--on x.Job = MJob and MSubcontractOp = x.Operation
Join CompanyH.dbo.WipMaster a
on a.Job = x.Job
Join CompanyH.dbo.BomWorkCentre b
on x.WorkCentre = b.WorkCentre
Where (ReworkOperation = 'Yes' or x.Job like ('RWK%'))


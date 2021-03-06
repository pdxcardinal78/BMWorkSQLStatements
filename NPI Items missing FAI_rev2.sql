
Select DISTINCT StockCode as Part, Description, PartNum = STUFF((Select '' + ParentPart + ', ' From BomStructure t3 Where StockCode = Component FOR XML PATH ('')),1,0,'') From InvMaster t1
Join BomStructure t2 on StockCode = Component
Where ParentPart in (Select StockCode From InvMaster Where  Planner = 'NPI' and StockOnHold <> 'P' and PartCategory <> 'COMP') and
StockCode not in (Select Part COLLATE Latin1_General_Bin  From uniPoint_CompanyH.dbo.PT_Inspection
Where InspectionSpecification_type = 'First Article') Order By StockCode

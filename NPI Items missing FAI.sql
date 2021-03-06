Select DISTINCT Component, Description From BomStructure
Join InvMaster
On Component = StockCode
Where ParentPart in ('940-1803', '427', '8551', '325', '318-2', '319-2', '537', '535-191', '560-1', '417-1901', '365', '496', '380', '5400', '200', '4300-1801', '490-181', '490-182', '980', '591', '112', '2200')

EXCEPT

Select Part COLLATE Latin1_General_Bin  as Component, PartDescription COLLATE Latin1_General_Bin as Descripton From uniPoint_CompanyH.dbo.PT_Inspection
Where InspectionSpecification_type = 'First Article'
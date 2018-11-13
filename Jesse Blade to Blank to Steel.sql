/*** Jesse Blade to Blank to Steel Query ***/
Select DISTINCT t1.StockCode
,t1.Description
,t1.Ebq as TopLevelEBQ
,t2.Component as BladeBlankStockCode
,t4.Description as BlankDesc
,t4.LongDesc as BlankLongDesc
,t4.Ebq as BlankEBQ
,t3.Component as SteelStockCode
,t5.Description as SteelDesc
,t5.LongDesc as SteelLong
From CompanyH.dbo.InvMaster t1
Join CompanyH.dbo.BomStructure t2
on t1.StockCode = t2.ParentPart
Join CompanyH.dbo.BomStructure t3
on t2.Component = t3.ParentPart
Join CompanyH.dbo.InvMaster t4
on t2.Component = t4.StockCode
Join CompanyH.dbo.InvMaster t5
on t3.Component = t5.StockCode
Where t1.LongDesc not like ('DISC%') and t1.Description like ('BLADE%') and t5.LongDesc not like ('DISC%')
Order By SteelStockCode
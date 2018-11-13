SELECT BomStructure.ParentPart, BomStructure.Component, InvMaster.Description, InvMaster.StockOnHoldReason
FROM CompanyH.dbo.InvMaster InvMaster
INNER JOIN CompanyH.dbo.BomStructure BomStructure
ON BomStructure.Component = InvMaster.StockCode
WHERE (InvMaster.StockOnHoldReason Not In ('CANCEL','NOQO','OBS','CHANGE','WPROMO','DISC','DUP','LTD','INACTV'))
AND InvMaster.Description Like '%LINER%'




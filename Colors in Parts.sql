Select Description
		,LongDesc
		,LEFT(Description, CASE 
						   WHEN CHARINDEX(',' ,Description) = '' THEN 0
						   ELSE CHARINDEX(',' ,Description) - 1
						   END
			  ) as Component
		,RIGHT(Description, CHARINDEX(' ', REVERSE(Description))) as Color
From InvMaster
Where LongDesc not like '%DISC%' and LongDesc not like ('OBS%') and StockCode not like ('%KIT%') and StockCode not like ('%TEMP%') and StockCode not like ('%S%') and StockCode not like ('C%')
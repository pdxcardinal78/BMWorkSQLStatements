Select * From CompanyH.dbo.SorDetail 
Where SalesOrder in (SELECT SalesOrder 
						FROM [CompanyH].[dbo].[SorMaster]
						Where (UPPER(ShipPostalCode) like ('[A-Z][0-9][A-Z][0-9][A-Z][0-9]') 
						or UPPER(ShipPostalCode) like ('[A-Z][0-9][A-Z] [0-9][A-Z][0-9]')) 
						and OrderDate between '10/1/18' and '4/30/19')

and MOrderQty <> 0 
and MWarehouse not in ('WR', 'PS') 
and MStockCode not like ('%F') 
and MStockCode not like ('KIT%') 
and MStockDes not like ('%FB%') 
and MStockCode not in ('CATBMK', '169BK', '176BKSN', '176BKSN-COMBO', '178SBK-COMBO', '178SKBSN', '179GRY'
						,'179GRYSN', '15008-ORG', '15009-ORG', '176BK-COMBO', '178SBK', '15001-2', '15003-1'
						,'15003-2', '15001-1', '176BK', '15100-1', '15016-1', '15016-2', '162', '162-1'
						,'200', '15200ORG', '15200DLC', '15200', '15001', '15003', '15400', '15016', '15100'
						,'15008', '15009', '176', '178', '176T', '179', '125BK', '175BK', '175BKSN', '101BK'
						,'112SBK-BLK', '133', '133BK', '375SN', '375BK', '375BKSN', '119', '119SBK', '140', '141'
						,'7 BLKW', '10 BLK', '8 BLKW')
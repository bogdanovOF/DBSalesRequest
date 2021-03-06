/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use [e-con stock and price]
declare @ltu date=convert(datetime,getdate())

select
	[Name] as [WHNAME],
	@ltu as [LAST TIME UPDATING],
	[PRIMCODE],[UM],[IN STOCK],[PRICE],[OLD PRICE],[DESC]
from
(select distinct top 100 percent name, ecgrp from [MDSDB].[mdm].[StocksOfProducts] order by ecgrp) as WAREHOUSES inner join
 (
 -- сорт только с запасами
 select
	a.code collate Cyrillic_General_100_CI_AS as [PRIMCODE],
	[Базисная ЕИ_Code] as [UM],
	[IN STOCK]=[dbo].[getStockfDate](a.code, @ltu, ecgrp),
	[PRICE]=isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0),
	[OLD PRICE]=isnull([dbo].[getOldPriceFDate](a.code,@ltu,ecgrp),0),
	ecgrp,
	[DESC]=0
		 from mdsdb.[mdm].[OZMOfProducts] as a
			inner join (select distinct ozm as code, stock as ecgrp
						 from [dbo].[stocksFDate]) as Material
							on a.Code collate Cyrillic_General_100_CI_AS =Material.code
		 where a.EC=1 and [SubCategory_Code] in (0,1,2,3,4) and not [dbo].[getStockfDate](a.Code, @ltu,ecgrp)=0
	union all
-- по метизам не показываем цен
-- попутная
	select
		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=isnull([dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		[OLD PRICE]=isnull([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		[e-con stock and price].[dbo].[getEstockByOzm](code) as [ecgrp],
		[DESC]=case
		when
		([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code))
		-[dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)))>0 then 1
		else 0 end
	from mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and [SubCategory_Code] in (17,18,19,20,21,22)
	union all
	 --плоский
	select
		MATERIAL.Code as [PRIMCODE],
		MATERIAL.[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=0,
		[OLD PRICE]=0,
		3 as ecgrp,
		[DESC]=0
	  from  (select материал as code, [Базисная ЕИ_Code], ecgrp from [dbo].[ozmForPricingNLMK]) as MATERIAL
		) as MATERIAL
	  on WAREHOUSES.ecgrp=MATERIAL.ecgrp
	  where not [PRICE]=0 
	  order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	   		for json auto


  
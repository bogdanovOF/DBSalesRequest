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
 -- сорт
 select
 		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=0,
		[OLD PRICE]=0,
		3 as [ecgrp],
		[DESC]=0
	from mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and (Code like N'LP%' or Code like N'SS%') and not code in (select материал collate SQL_Latin1_General_CP1_CI_AS as code
																from [e-con stock and price].[dbo].[ozmForPricingSORT])
 union all
 select
	материал as [PRIMCODE],
	[Базисная ЕИ_Code] as [UM],
	[IN STOCK]=case
		when [dbo].[getStockfDate](MATERIAL.материал, @ltu, ecgrp)=0 then null	
		else [dbo].[getStockfDate](MATERIAL.материал, @ltu, ecgrp) end,
	[PRICE]=isnull([dbo].[getPriceFDate](MATERIAL.материал,@ltu,ecgrp),0),
	[OLD PRICE]=isnull([dbo].[getOldPriceFDate](материал,@ltu,ecgrp),0),
	ecgrp,
	[DESC]=case
		when
		([dbo].[getOldPriceFDate](MATERIAL.материал,@ltu,ecgrp)-[dbo].[getPriceFDate](MATERIAL.материал,@ltu,ecgrp))>0 then 1
		else 0 end
	  from  (select
				материал collate SQL_Latin1_General_CP1_CI_AS as материал,
				[Базисная ЕИ_Code],
				ecgrp
					from [dbo].[ozmForPricingSORT] where материал like N'LP%' or материал like N'SS%') as MATERIAL
--	   where not (
--	   [dbo].[getStockfDate](материал, @ltu,ecgrp)=0
--			and
--				[dbo].[getPriceFDate](материал,@ltu,ecgrp)=0
--					and 
--						[dbo].[getOldPriceFDate](материал,@ltu,ecgrp)=0)
	union all
-- метизы
	select
		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=0,
		[OLD PRICE]=0,
		3 as [ecgrp],
		[DESC]=0
	from mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and Code like N'MW%'
	union all
-- попутная
	select
		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=isnull([dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		[OLD PRICE]=isnull([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		3 as [ecgrp],
		[DESC]=case
		when
		([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code))
		-[dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)))>0 then 1
		else 0 end
	from mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and Code like N'PP%'
	union all
	-- плоский
	select
		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=0,
		[OLD PRICE]=0,
		3 as ecgrp,
		[DESC]=0
	  from   mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and SubCategory_Code in (5,6,8,9,10,11,12,23,24,25,26,28,29)
	  ) as MATERIAL
	  on WAREHOUSES.ecgrp=MATERIAL.ecgrp
	  order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	   		for json auto



  
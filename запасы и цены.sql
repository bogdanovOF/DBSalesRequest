/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use [e-con stock and price]
declare @ltu date=convert(datetime,getdate())

select
	[Name] as [WHNAME],
	@ltu as [LAST TIME UPDATING],
	[PRIMCODE],[UM],[IN STOCK],[PRICE],[OLD PRICE],[DESC]
from
(select distinct top 100 percent name, ecgrp from [MDSDB].[mdm].[StocksOfProducts] order by ecgrp) as WAREHOUSES inner join
 (select
	материал as [PRIMCODE],
	[Базисная ЕИ_Code] as [UM],
	[IN STOCK]=[dbo].[getStockfDate](MATERIAL.материал, @ltu, ecgrp),
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
					from [dbo].[ozmForPricingSORT]) as MATERIAL
	   where not (
	   [dbo].[getStockfDate](материал, @ltu,ecgrp)=0
			and
				[dbo].[getPriceFDate](материал,@ltu,ecgrp)=0
					and 
						[dbo].[getOldPriceFDate](материал,@ltu,ecgrp)=0)
	union all
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
	    where EC=1 and Code like N'PP%'
	union all
	-- плоский
	select
		MATERIAL.Code as [PRIMCODE],
		MATERIAL.[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=null,
		[PRICE]=0,
		[OLD PRICE]=0,
		3 as ecgrp,
		[DESC]=0
	  from  (select материал as code, [Базисная ЕИ_Code], ecgrp from [dbo].[ozmForPricingNLMK]) as MATERIAL) as MATERIAL
	  on WAREHOUSES.ecgrp=MATERIAL.ecgrp
	  order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	   		for json auto


  
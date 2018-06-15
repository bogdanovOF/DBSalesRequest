USE [e-con stock and price]
GO
/****** Object:  StoredProcedure [dbo].[createPriceBySubCat]    Script Date: 15.06.2018 14:09:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[createPriceBySubCat]
	@ltu date,
	@cat as int,
	@subcat as int
as
set nocount on;
begin

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
	[IN STOCK]=100,
	[PRICE]=isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0),
	[OLD PRICE]=isnull([dbo].[getOldPriceFDate](a.code,@ltu,ecgrp),0),
	ecgrp,
	[DESC]=case
	when isnull([dbo].[getOldPriceFDate](a.code,@ltu,ecgrp),0)>isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0) then 1
	else 0 end
		 from mdsdb.[mdm].[OZMOfProducts] as a
			inner join (select distinct ozm as code, ecstock as ecgrp
						 from [dbo].[allPrices]) as Material
							on a.Code collate Cyrillic_General_100_CI_AS =Material.code
		 where a.EC=1 and [SubCategory_Code] in (0,1,2,3,4) and [SubCategory_Code]=@subcat
	union all
-- по метизам не показываем цен
-- попутная
	select
		Code as [PRIMCODE],
		[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=
		case
			when isnull([dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0)>0 then 10000
			else null end,
		[PRICE]=isnull([dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		[OLD PRICE]=isnull([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)),0),
		[e-con stock and price].[dbo].[getEstockByOzm](code) as [ecgrp],
		[DESC]=case
		when
		([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code))
		-[dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)))>0 then 1
		else 0 end
	from mdsdb.[mdm].[OZMOfProducts]
	    where EC=1 and [SubCategory_Code] in (17,18,19,20,21,22) and [SubCategory_Code]=@subcat
	union all
	 --плоский
	select
		MATERIAL.Code as [PRIMCODE],
		MATERIAL.[Базисная ЕИ_Code] as [UM],
		[IN STOCK]=case
			when isnull([dbo].[getPriceFDate](code,@ltu,3),0)>0 then 1000
			else null end,
		[PRICE]=isnull([dbo].[getPriceFDate](code,@ltu,3),0),
		[OLD PRICE]=isnull([dbo].[getOldPriceFDate](code,@ltu,3),0),
		3 as ecgrp,
		[DESC]=case
		when
		([dbo].[getOldPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code))
		-[dbo].[getPriceFDate](code,@ltu,[e-con stock and price].[dbo].[getEstockByOzm](code)))>0 then 1
		else 0 end
	  from  (select code, [Базисная ЕИ_Code], 3 as ecgrp from [MDSDB].mdm.[OZMOfProducts] where 
				SubCategory_Code in
				(select code from [MDSDB].mdm.[SubCategoryOfProducts]
					 where Category_Code in (2,3,4,5,6,7,9,10)) and [SubCategory_Code]=@subcat) as MATERIAL
		) as MATERIAL
	  on WAREHOUSES.ecgrp=MATERIAL.ecgrp
	  order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	  
end



  
GO

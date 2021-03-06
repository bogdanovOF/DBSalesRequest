USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getStockAndPriceAsJson]    Script Date: 13.07.2018 12:11:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 26092017
-- Description:	возвращает подкатегорию каталога в json для экспорта в e-comm
-- =============================================
CREATE FUNCTION [dbo].[getStockAndPriceAsJson]()
RETURNS nvarchar(max)
AS
BEGIN
	declare @ltu date=convert(datetime,getdate())
	return (
select
		[Name] as [WHNAME],
		@ltu as [LAST TIME UPDATING],
		[PRIMCODE], [UM], [IN STOCK], [PRICE], [OLD PRICE], [DESC]
	from
		(select distinct top 100 percent
			name, ecgrp
		from [MDSDB].[mdm].[StocksOfProducts]
		order by ecgrp) as WAREHOUSES inner join
		(
 -- сорт только с запасами
 							select
				a.code collate Cyrillic_General_100_CI_AS as [PRIMCODE],
				[Базисная ЕИ_Code] as [UM],
				[IN STOCK]=150,
				--case 
				--	when [dbo].[getStockfDate](a.code, @ltu, ecgrp)>0 then 1000
				--	else null end,
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
			where a.EC=1 and [SubCategory_Code] in (0,1,2,3,4) and isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0)>0
			-- and not [dbo].[getStockfDate](a.Code, @ltu,ecgrp)=0
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
			where EC=1 and [SubCategory_Code] in (17,18,19,20,21,22)
		union all
			--плоский под заказ
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
			from (select code, [Базисная ЕИ_Code], 3 as ecgrp
				from [MDSDB].mdm.[OZMOfProducts]
				where 
				SubCategory_Code in
				(select code
				from [MDSDB].mdm.[SubCategoryOfProducts]
				where Category_Code in (2,3,4,5,6,7,9,10))) as MATERIAL
		union ALL
			--плоский со склада
			select
				a.code collate Cyrillic_General_100_CI_AS as [PRIMCODE],
				[Базисная ЕИ_Code] as [UM],
				[IN STOCK]=100,
				--case 
				--	when [dbo].[getStockfDate](a.code, @ltu, ecgrp)>0 then 1000
				--	else null end,
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
				inner join mdsdb.[mdm].subcategoryofproducts as subcat
				on subcat.Code=a.SubCategory_Code
			where not Material.ecgrp=3 and a.EC=1
				and subcat.[Category_Code] in (2,3,4,5,6,7,9,10)
				and isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0)>0 
		) as MATERIAL
		on WAREHOUSES.ecgrp=MATERIAL.ecgrp
	where not [PRICE]=0
	order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	for json auto)
end


  
GO

USE [e-con stock and price]
GO
/****** Object:  StoredProcedure [dbo].[createPriceBySubCat]    Script Date: 05.07.2018 19:25:38 ******/
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

    IF (@subcat in (0,1,2,3,4))
    BEGIN
        -- сорт только с запасами
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
    		) as MATERIAL
            on WAREHOUSES.ecgrp=MATERIAL.ecgrp
        order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
    END
    ELSE
	if (@cat=1)
	-- метизы без цен и запасов
	begin
        select
            [Name] as [WHNAME],
            @ltu as [LAST TIME UPDATING],
            [PRIMCODE], [UM], [IN STOCK], [PRICE], [OLD PRICE], [DESC]
        from
            (select distinct top 100 percent
                name, ecgrp
            from [MDSDB].[mdm].[StocksOfProducts]
            order by ecgrp) as WAREHOUSES inner join
            (select
                    MATERIAL.Code as [PRIMCODE],
                    MATERIAL.[Базисная ЕИ_Code] as [UM],
                    [IN STOCK]=null,
                    [PRICE]=0,
                    [OLD PRICE]=0,
                    3 as ecgrp,
                    [DESC]=0
                from (select code, [Базисная ЕИ_Code], 3 as ecgrp
                    from [MDSDB].mdm.[OZMOfProducts]
                    where EC=1 and
				    SubCategory_Code
                     in (select code from [MDSDB].mdm.[SubCategoryOfProducts] where Category_Code =@cat)) as MATERIAL
					 		) as MATERIAL
							on WAREHOUSES.ecgrp=MATERIAL.ecgrp
							order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
	end
	else
    IF (@subcat in (17,18,19,20,21,22))
    -- прочая продукция
    BEGIN
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
            select
                Code as [PRIMCODE],
                [Базисная ЕИ_Code] as [UM],
                [IN STOCK]=case
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
    		) as MATERIAL
            on WAREHOUSES.ecgrp=MATERIAL.ecgrp
        order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
    END
    ELSE
    IF (@cat in (2,3,4,5,6,7,9,10))
    BEGIN
        select
            [Name] as [WHNAME],
            @ltu as [LAST TIME UPDATING],
            [PRIMCODE], [UM], [IN STOCK], [PRICE], [OLD PRICE], [DESC]
        from
            (select distinct top 100 percent
                name, ecgrp
            from [MDSDB].[mdm].[StocksOfProducts]
            order by ecgrp) as WAREHOUSES inner join
            (select
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
                    where EC=1 and
				    SubCategory_Code
                     in (select code from [MDSDB].mdm.[SubCategoryOfProducts] where Category_Code in (2,3,4,5,6,7,9,10))) as MATERIAL
            union ALL
                --плоский со склада
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
                    inner join mdsdb.[mdm].subcategoryofproducts as subcat
                    on subcat.Code=a.SubCategory_Code
                where not Material.ecgrp=3 and a.EC=1
                    and subcat.[Category_Code] in (2,3,4,5,6,7,9,10)
                    and isnull([dbo].[getPriceFDate](a.code,@ltu,ecgrp),0)>0 
		) as MATERIAL
            on WAREHOUSES.ecgrp=MATERIAL.ecgrp
        order by WAREHOUSES.ecgrp, MATERIAL.PRIMCODE
    END
end

GO

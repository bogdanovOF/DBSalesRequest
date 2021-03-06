USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getSubCatOfCatalogAsJsonWithoutDateChange]    Script Date: 26.06.2018 14:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 25062018
-- Description:	возвращает подкатегорию каталога в json для экспорта в e-comm без учета даты изменения
-- =============================================
CREATE FUNCTION [dbo].[getSubCatOfCatalogAsJsonWithoutDateChange]
(
	@subcat integer, @cat integer,@deletedView int=1)
RETURNS nvarchar(max)
AS
BEGIN
	RETURN (
	select MATERIAL.[CATEGORY_CODE],
		   MATERIAL.[CATEGORY],
		   MATERIAL.SUBCATEGORY_CODE,
		   MATERIAL.SUBCATEGORY,
		   MATERIAL.PRIMCODE,
		   MATERIAL.WNAME,
		   MATERIAL.DELETED,
		   MATERIAL.FrequencyOfMaterial,
		   MATERIAL.UM,
		   MATERIAL.UM1,
		   MATERIAL.UM2,
		   MATERIAL.UM3,
		   MATERIAL.AVAILABLE,
	 [FEATURES].[FEATURE],
	 [FEATURES].DESCRIPTION,
	 [FEATURES].VALUE_STR,
	 [FEATURES].FROM_VAL,
	 [FEATURES].TO_VAL,
	 [FEATURES].[VALUE_NUM],
	 [FEATURES].MANDATORY,
	 [FEATURES].ORDER_RANK,
	 [FEATURES].UM
	  from  (SELECT 
	  a.Code as [CATEGORY_CODE],
      a.[Name] as [CATEGORY],
	  b.Code as [SUBCATEGORY_CODE],
	  b.[Name] as [SUBCATEGORY],
	  c.Code as [PRIMCODE],
	  isnull(c.[Name],N' ') as [WNAME],
	  case c.EC
		when 1 then 0
		else 1 end as [DELETED],
	  isnull(c.ordersRank,0) as [FrequencyOfMaterial],
	  c.[Базисная ЕИ_Code] as [UM],
	  isnull(c.[ЕИ1_Code],'') as [UM1], isnull(c.[ЕИ2_Code],'') as [UM2], isnull(c.[ЕИ3_Code],'') as [UM3],
	  isnull(Av_,0) as [AVAILABLE],
	  [ausp_rank]=e.cnt_code
   FROM [MDSDB].[mdm].[CategoryOfProducts] as a inner join 
   [MDSDB].[mdm].[SubCategoryOfProducts] as b on a.code=b.[Category_Code]
   inner join [MDSDB].[mdm].[OZMOfProducts] as c on b.code=c.SubCategory_Code
   left join (select distinct OZM collate SQL_Latin1_General_CP1_CI_AS as материал, 1 as Av_
					from [dbo].[stocksFDate]) as d on d.материал=c.Code
	-- правка для вывода вначале материалов с максимальным количеством признаков
	inner join (select Материал_Code, count(a.code) as cnt_code
					 from mdsdb.mdm.AuspOfProducts as a 
						 inner join mdsdb.mdm.FeaturesOfProducts as b
							on a.Признак=b.[Код признака] and a.subCat_Code=b.Подкатегория_Code 
								where a.subCat_Code=@subcat and b.Основной in (1,0)
									group by Материал_Code) e on c.Code=e.Материал_Code
   where a.Code=@cat and b.code=@subcat and ((@deletedView=0 and c.EC=1) or @deletedView=1)
	) as [MATERIAL] inner join
    (select a.Материал_Code as Code,
	 [Признак] as [FEATURE], [Расшифровка] as [DESCRIPTION],
	 [Значение признака] as [VALUE_STR],
	 case 
		when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]=0 then 0.3
		when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]>=0.3 then [Со значения]
		when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]=0 then 15
		when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]>=15 then [Со значения]
		when ([Со значения]>0 and ([По значение]=0 or [По значение] is null)) then null -- уйдет в [VALUE_NUM]
		when [Со значения]=0 then null
		else [Со значения] end as [FROM_VAL],
	case
		when ([По значение]>0 and ([Со значения]=0 or [Со значения] is null)) then null
		when [По значение]=0 then null
		else [По значение] end as [TO_VAL],
	case 
		when [Со значения]>0 and (case
									when ([По значение]>0 and ([Со значения]=0 or [Со значения] is null)) then null
									when [По значение]=0 then null
									else [По значение] end is null) then [Со значения]
		when [По значение]>0 and (case 
									when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]=0 then 0.3
									when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]>=0.3 then [Со значения]
									when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]=0 then 15
									when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]>=15 then [Со значения]
									when ([Со значения]>0 and ([По значение]=0 or [По значение] is null)) then null
									when [Со значения]=0 then null
									else [Со значения] end is null) then [По значение]
		else null end as [VALUE_NUM],
	  FIN.[Основной] as [MANDATORY], dbo.getausprankoffeaturevalue(a.code) as [ORDER_RANK], fin.orderby, fin.[UM]
	   from [MDSDB].[mdm].[AuspOfProducts] as a inner join [MDSDB].[mdm].[FeaturesOfProducts] as FIN on a.Признак=FIN.[Код признака]
	   where FIN.[Подкатегория_Code]=@subcat and fin.Основной in (0,1)) as [FEATURES] on MATERIAL.[PRIMCODE]=[FEATURES].Code
      order by MATERIAL.ausp_rank desc, MATERIAL.[FrequencyOfMaterial] DESC, MATERIAL.PRIMCODE ASC, FEATURES.orderby ASC
	  	  for json auto)

END
GO

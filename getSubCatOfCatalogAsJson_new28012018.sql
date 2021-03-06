USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getSubCatOfCatalogAsJson]    Script Date: 26.01.2018 18:33:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 26092017
-- Description:	возвращает подкатегорию каталога в json для экспорта в e-comm
-- =============================================
ALTER FUNCTION [dbo].[getSubCatOfCatalogAsJson]
(
	@subcat integer, @cat integer)
RETURNS nvarchar(max)
AS
BEGIN
	RETURN (
	select MATERIAL.*,
	 [FEATURES].[FEATURE],
	 [FEATURES].DESCRIPTION,
	 [FEATURES].VALUE_STR,
	 [FEATURES].FROM_VAL,
	 [FEATURES].TO_VAL,
	 [FEATURES].[VALUE_NUM],
	 [FEATURES].MANDATORY,
	 [FEATURES].UM
	  from  (SELECT 
	  a.Code as [CATEGORY_CODE],
      a.[Name] as [CATEGORY],
	  b.Code as [SUBCATEGORY_CODE],
	  b.[Name] as [SUBCATEGORY],
	  c.Code as [PRIMCODE],
	  c.[Name] as [WNAME],
	  case c.EC
		when 1 then 0
		else 1 end as [DELETED],
	  isnull(c.ordersRank,0) as [FrequencyOfMaterial],
	  c.[Базисная ЕИ_Code] as [UM],
	  isnull(c.[ЕИ1_Code],'') as [UM1], isnull(c.[ЕИ2_Code],'') as [UM2], isnull(c.[ЕИ3_Code],'') as [UM3],
	  isnull(Av_,0) as [AVAILABLE]
   FROM [MDSDB].[mdm].[CategoryOfProducts] as a inner join 
   [MDSDB].[mdm].[SubCategoryOfProducts] as b on a.code=b.[Category_Code]
   inner join [MDSDB].[mdm].[OZMOfProducts] as c on b.code=c.SubCategory_Code
   left join (select distinct OZM collate SQL_Latin1_General_CP1_CI_AS as материал, 1 as Av_
					from [dbo].[stocksFDate]) as d on d.материал=c.Code
   where a.Code=@cat and b.code=@subcat
	) as [MATERIAL] inner join
    (select a.Материал_Code as Code,
	 [Признак] as [FEATURE], [Расшифровка] as [DESCRIPTION],
	 [Значение признака] as [VALUE_STR],
	 case 
		when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]=0 then 15
		when [Признак]=N'TLOT' and [Со значения]<[По значение] and [Со значения]>=15 then [Со значения]
		when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]=0 then 0.3
		when [Признак]=N'SHOT' and [Со значения]<[По значение] and [Со значения]>=0.3 then [Со значения]
		when not ([Признак]=N'TLOT' or [Признак]=N'SHOT') and ([Со значения]>0 and ([По значение]=0 or [По значение] is null)) then null
		when [Со значения]=0 then null
		else [Со значения] end as [FROM_VAL],
	case
		when not ([Признак]=N'TLOT' or [Признак]=N'SHOT') and ([По значение]>0 and ([Со значения]=0 or [Со значения] is null)) then null
		when [По значение]=0 then null
		else [По значение] end as [TO_VAL],
	case 
		when ([Признак]=N'TLOT' or [Признак]=N'SHOT') then null
		when [Со значения]>0 and ([По значение]=0 or [По значение] is null) then [Со значения]
		when [По значение]>0 and ([Со значения]=0 or [Со значения] is null) then [По значение]
		else null end as [VALUE_NUM],
	  FIN.[Основной] as [MANDATORY], fin.orderby, fin.[UM]
	   from [MDSDB].[mdm].[AuspOfProducts] as a inner join [MDSDB].[mdm].[FeaturesOfProducts] as FIN on a.Признак=FIN.[Код признака]
	   where FIN.[Подкатегория_Code]=@subcat and fin.Основной in (0,1)) as [FEATURES] on MATERIAL.[PRIMCODE]=[FEATURES].Code
      order by  MATERIAL.[FrequencyOfMaterial] DESC, MATERIAL.PRIMCODE ASC, FEATURES.orderby ASC
	  	  for json auto
		  )

END

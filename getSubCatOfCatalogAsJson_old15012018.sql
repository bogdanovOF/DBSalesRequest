USE [e-con stock and price]
GO

/****** Object:  UserDefinedFunction [dbo].[getSubCatOfCatalogAsJson]    Script Date: 15.01.2018 16:05:09 ******/
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
	 [FEATURES].MANDATORY
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
	  isnull(c.[ЕИ1_Code],'') as [UM1], isnull(c.[ЕИ2_Code],'') as [UM2], isnull(c.[ЕИ3_Code],'') as [UM3]
   FROM [MDSDB].[mdm].[CategoryOfProducts] as a inner join 
   [MDSDB].[mdm].[SubCategoryOfProducts] as b on a.code=b.[Category_Code]
   inner join [MDSDB].[mdm].[OZMOfProducts] as c on b.code=c.SubCategory_Code
   where a.Code=@cat and b.code=@subcat
    --and c.EC=1
	) as [MATERIAL] inner join
    (select a.Материал_Code as Code,
	 [Признак] as [FEATURE], [Расшифровка] as [DESCRIPTION],
	 case
		when @subcat in (23,24,5,6,8,9,10,11,12) and [Признак]=N'TLOT' and [Со значения]<[По значение] then convert(nvarchar(50),[Со значения])+N'-'+convert(nvarchar(50),[По значение])+N' мм'
		when @subcat in (23,24,5,6,8,9,10,11,12) and [Признак]=N'SHOT' and [Со значения]<[По значение] then convert(nvarchar(50),convert(int,[Со значения]))+N'-'+convert(nvarchar(50),convert(int,[По значение]))+N' мм'
		else [Значение признака] end as [VALUE_STR],
	 case 
		when [Признак]=N'TLOT' and [Со значения]<[По значение] then 0
		when [Признак]=N'SHOT' and [Со значения]<[По значение] then 0
		else [Со значения] end as [FROM_VAL],
	 case 
		when [Признак]=N'TLOT' and [Со значения]<[По значение] then 0
		when [Признак]=N'SHOT' and [Со значения]<[По значение] then 0
	 else [По значение] end as [TO_VAL],
	  FIN.[Основной] as [MANDATORY], fin.orderby
	   from [MDSDB].[mdm].[AuspOfProducts] as a inner join [MDSDB].[mdm].[FeaturesOfProducts] as FIN on a.Признак=FIN.[Код признака]
	   where FIN.[Подкатегория_Code]=@subcat and fin.Основной in (0,1)) as [FEATURES] on MATERIAL.[PRIMCODE]=[FEATURES].Code
      order by  MATERIAL.[FrequencyOfMaterial] DESC, MATERIAL.PRIMCODE ASC, FEATURES.orderby ASC
	  	  for json auto)

END
GO



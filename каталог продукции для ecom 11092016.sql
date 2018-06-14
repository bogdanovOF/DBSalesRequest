use mdsdb

select MATERIAL.*,
	case 
	when [MATERIAL].[PRIMCODE] like '%1%4' then 1
	else 0 end as [DELETED],
	 [FEATURES].[FEATURE],
	 [FEATURES].DESCRIPTION,
	 [FEATURES].VALUE_STR,
	 [FEATURES].FROM_VAL,
	 [FEATURES].TO_VAL,
	 [FEATURES].MANDATORY
	 --,[DOMAIN].CAWNID as [CODE], [DOMAIN].CAWNVAL AS [NAME] 
	  from  (SELECT 
      a.[Name] as [CATEGORY],
	  b.[Name] as [SUBCATEGORY],
	  c.Code as [PRIMCODE],
	  c.[Name] as [WNAME],
	  c.[Базисная ЕИ_Code] as [UM],
	  isnull(c.[ЕИ1_Code],'') as [UM1], isnull(c.[ЕИ2_Code],'') as [UM2], isnull(c.[ЕИ3_Code],'') as [UM3]
   FROM [MDSDB].[mdm].[CategoryOfProducts] as a inner join 
   [mdm].[SubCategoryOfProducts] as b on a.code=b.[Category_Code]
   inner join [mdm].[OZMOfProducts] as c on b.code=c.SubCategory_Code
   where a.Code=0 and b.code=2 and c.EC=1) as [MATERIAL] inner join
    (select a.Материал_Code as Code, 0 as sc, [Признак] as [FEATURE], [Расшифровка] as [DESCRIPTION],
	 [Значение признака] as [VALUE_STR], [Со значения] as [FROM_VAL],
	 [По значение] as [TO_VAL], FIN.[Основной] as [MANDATORY]
	   from [mdm].[AuspOfProducts] as a inner join [mdm].[FeaturesOfProducts] as FIN on a.Признак=FIN.[Код признака]
	   where Признак in (select [код признака] from [mdm].[FeaturesOfProducts] as a where [Подкатегория_Code]=2)
	--	union all
	--select a.Code, a.SubCategory_Code as sc, b.[Код признака] as [FEATURE], b.[Наименование] as [DESCRIPTION], '' as [VALUE_STR], 0 as [FROM_VAL],
	--0 as  [TO_VAL], b.[основной] as [MANDATORY] from MDSDB.mdm.OZMOfProducts as a cross join MDSDB.mdm.FeaturesOfProducts as b
	--where a.SubCategory_Code=5 and b.Подкатегория_Code=5 and b.[Тип данных]='DOMAIN'
	   ) as [FEATURES] on MATERIAL.[PRIMCODE]=[FEATURES].Code
	   left outer join [mdm].[CawnOfProducts] as [DOMAIN] on FEATURES.[DESCRIPTION]=[DOMAIN].[feature_Name] and [FEATURES].sc=[DOMAIN].[SubCategory_Code]
      order by MATERIAL.PRIMCODE
	  	  for json auto

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
	  c.[�������� ��_Code] as [UM],
	  isnull(c.[��1_Code],'') as [UM1], isnull(c.[��2_Code],'') as [UM2], isnull(c.[��3_Code],'') as [UM3]
   FROM [MDSDB].[mdm].[CategoryOfProducts] as a inner join 
   [mdm].[SubCategoryOfProducts] as b on a.code=b.[Category_Code]
   inner join [mdm].[OZMOfProducts] as c on b.code=c.SubCategory_Code
   where a.Code=0 and b.code=2 and c.EC=1) as [MATERIAL] inner join
    (select a.��������_Code as Code, 0 as sc, [�������] as [FEATURE], [�����������] as [DESCRIPTION],
	 [�������� ��������] as [VALUE_STR], [�� ��������] as [FROM_VAL],
	 [�� ��������] as [TO_VAL], FIN.[��������] as [MANDATORY]
	   from [mdm].[AuspOfProducts] as a inner join [mdm].[FeaturesOfProducts] as FIN on a.�������=FIN.[��� ��������]
	   where ������� in (select [��� ��������] from [mdm].[FeaturesOfProducts] as a where [������������_Code]=2)
	--	union all
	--select a.Code, a.SubCategory_Code as sc, b.[��� ��������] as [FEATURE], b.[������������] as [DESCRIPTION], '' as [VALUE_STR], 0 as [FROM_VAL],
	--0 as  [TO_VAL], b.[��������] as [MANDATORY] from MDSDB.mdm.OZMOfProducts as a cross join MDSDB.mdm.FeaturesOfProducts as b
	--where a.SubCategory_Code=5 and b.������������_Code=5 and b.[��� ������]='DOMAIN'
	   ) as [FEATURES] on MATERIAL.[PRIMCODE]=[FEATURES].Code
	   left outer join [mdm].[CawnOfProducts] as [DOMAIN] on FEATURES.[DESCRIPTION]=[DOMAIN].[feature_Name] and [FEATURES].sc=[DOMAIN].[SubCategory_Code]
      order by MATERIAL.PRIMCODE
	  	  for json auto

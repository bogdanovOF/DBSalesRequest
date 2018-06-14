declare @sDate as date=convert(date,DATETIMEOFFSETFROMPARTS(year(DATEADD(day,-365,getdate())), month(DATEADD(day,-365,getdate())),1,5,0,0,0,0,0,0))
declare @tDate as date=convert(date,getdate())
DECLARE @VersionName nvarchar(50)='VERSION_1'
DECLARE @LogFlag int=1
DECLARE @BatchTag nvarchar(50)='ozmNameRank'+convert(nvarchar(max),newid())
declare @subCat nvarchar(50)=N'8'

  -- обновляем записи блокированные
insert into [MDSDB].[stg].[OZM_Leaf]
	([ImportType]
      ,[BatchTag]
      ,[Code]
	  ,[Name]
	  ,[Базисная ЕИ],[ЕИ1],[ЕИ2],[ЕИ3]
	  ,[SubCategory]
	  ,[EC]
      ,[ordersRank]
	  ,[BE])
SELECT 2
      ,@BatchTag
      ,Code
	  ,[e-con stock and price].[dbo].[OZMName](Code)
	  ,[Базисная ЕИ_Code],[ЕИ1_Code],[ЕИ2_Code],[ЕИ3_Code]
	  ,[SubCategory_Code]
	  ,[EC]
	  ,ecrank
	  ,BE_Code
 FROM 
(select a.Code, a.[Базисная ЕИ_Code],a.[ЕИ1_Code],a.[ЕИ2_Code],a.[ЕИ3_Code],a.[SubCategory_Code],a.[EC], b.[FreqOfSale] as ecrank, a.BE_Code from [MDSDB].[mdm].[OZMOfProducts] as a
	left outer join [e-con stock and price].[dbo].[OZMFrequency] as b on a.Code collate Cyrillic_General_100_CI_AS=b.[OZM] where a.[SubCategory_Code]=@subCat) as a

 if exists(select Code from [MDSDB].[stg].[OZM_Leaf] where [BatchTag]= @BatchTag)
 begin
  EXECUTE [mdsdb].[stg].[udp_OZM_Leaf] 
    @VersionName
   ,@LogFlag
   ,@BatchTag
 end

 
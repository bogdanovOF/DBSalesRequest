declare @sDate as date=convert(date,DATETIMEOFFSETFROMPARTS(year(DATEADD(day,-365,getdate())), month(DATEADD(day,-365,getdate())),1,5,0,0,0,0,0,0))
declare @tDate as date=convert(date,getdate())
DECLARE @VersionName nvarchar(50)='VERSION_1'
DECLARE @LogFlag int=1
DECLARE @BatchTag nvarchar(50)='settingsOfProduct'+convert(nvarchar(max),newid())

  -- обновляем записи блокированные
insert into [MDSDB].[stg].[tSettingsOfProducts_Leaf]
	([ImportType]
      ,[BatchTag]
      ,[Code]
	  ,[Name]
	  ,[авто]
	  ,[вручную]
      ,[дата последнего обновления])
SELECT 2
      ,@BatchTag
      ,Code
	  ,Name
	  ,[авто]
	  ,0
	  ,getdate()
 FROM MDSDB.[mdm].[settingsOfProducts] where code=N'0'

 if exists(select Code from [MDSDB].[stg].[tSettingsOfProducts_Leaf] where [BatchTag]= @BatchTag)
 begin
  EXECUTE [mdsdb].[stg].[udp_tSettingsOfProducts_Leaf]
    @VersionName
   ,@LogFlag
   ,@BatchTag
 end


USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getAUSPrankOfFeatureValue]    Script Date: 26.06.2018 14:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 26092017
-- Description:	возвращает порядок значения признака в фильтре по справочнику
-- =============================================
CREATE FUNCTION [dbo].[getAUSPrankOfFeatureValue]
(
	@auspCode nvarchar(250))
RETURNS int
AS
BEGIN
    declare @result INT;
  
with rank_ ([Подкатегория_Code], [Признак],key_,rankOfFeature,[LastChgDateTime])
as 
(
SELECT [Подкатегория_Code], [Признак], isnull(convert(nvarchar(30),[Значение признака]),N'')+N'_'+
    ISNULL(convert(nvarchar(30),[Со значения]),N'')+N'_'
    +ISNULL(convert(nvarchar(30),[По значение]),N'') as key_
      , [Приоритет вывода в фильтре] as rankOfFeature
      , [LastChgDateTime]
        FROM [MDSDB].[mdm].[AUSPrankOfFeatureValues]),
ausp (code, subCat_Code, [Признак], key_)
AS
(
    select code, subCat_Code, [Признак], isnull(convert(nvarchar(30),[Значение признака]),N'')+N'_'+
    ISNULL(convert(nvarchar(30),convert(int,[Со значения])),N'')+N'_'
    +ISNULL(convert(nvarchar(30),convert(int,[По значение])),N'') as key_ from mdsdb.mdm.AuspOfProducts where code=@auspCode 
)
select @result=rank_.rankOfFeature
    from ausp inner join rank_ on ausp.key_=rank_.key_ and rank_.Подкатегория_Code=ausp.subCat_Code and rank_.Признак=ausp.Признак;

RETURN @result

end
GO

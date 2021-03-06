USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[OZMName]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 17102017
-- Description:	возвращает правильное наименование материала по коду ОЗМ
-- =============================================
CREATE FUNCTION [dbo].[OZMName] 
(
	-- Add the parameters for the function here
	 @ozmCode nvarchar(30)
)
RETURNS nvarchar(300)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(300)
	-- получаем код подкатегории
	Declare @subCat nvarchar(10)=(select [SubCategory_Code] from [MDSDB].mdm.[OZMOfProducts] where Code=@ozmCode)
	
	SELECT @Result = case
	-- катанка
	when @subCat=N'0' then N'Катанка диаметр, мм - '+
		(select top 1 convert(nvarchar(10),[со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'DIAMETR_ROD' and Материал_Code=@ozmCode)+N', марка стали - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode)
	-- арматура в прутках
	when @subCat=N'1' then N'Арматура в прутках, класса прочности - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLASS_PROCHN' and Материал_Code=@ozmCode)+N', группы марок - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'GR_MARKA_SORT' and Материал_Code=@ozmCode)+N', № профиля - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'NUMB_PROF' and Материал_Code=@ozmCode)+N', длина в мм - '+
		(select top 1 convert(nvarchar(10),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'NUMB_PROF' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MER_DLIN' and Материал_Code=@ozmCode)
	-- арматура в бунтах
	when @subCat=N'2' then N'Арматура в бунтах, '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'EC_PROF_VID' and Материал_Code=@ozmCode),N'')+N', класса прочности - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLASS_PROCHN' and Материал_Code=@ozmCode)+N', группы марок - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'GR_MARKA_SORT' and Материал_Code=@ozmCode)+N', № профиля - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'NUMB_PROF' and Материал_Code=@ozmCode)
	-- уголок
	when @subCat=N'4' then N'Прокат угловой равнополочный, марка стали - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode)+N', размеры, мм - '+
		ISNULL((select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHELF_WIDTH_NUM' and Материал_Code=@ozmCode),N'')+N'x'+
		isnull((select top 1 convert(nvarchar(10),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHELF_THICKNESS_NUM' and Материал_Code=@ozmCode),N'')+N'x'+
		isnull((select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),convert(int,[По значение]))
				else convert(nvarchar(10),convert(int,[Со значения])) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'LENGTH_SORT' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MER_DLIN' and Материал_Code=@ozmCode)
	-- проволока и холоднокатанная арматура
	when @subCat=N'13' or @subCat=N'3' then 
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_PROV' and Материал_Code=@ozmCode),N'')+N', '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TREATMENT_WIRE' and Материал_Code=@ozmCode),N'')+N' '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TYPE_TREATMENT_WIRE' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'COVER' and Материал_Code=@ozmCode)+N' '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'COVER_TH' and Материал_Code=@ozmCode)+N', Ø '+
		(select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),[По значение])
				else convert(nvarchar(10),[Со значения]) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'DIAMETR_WIRE' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TYPE_WINDING' and Материал_Code=@ozmCode)
	-- гвозди
	when @subCat=N'15' then 
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TYPE_NAILS' and Материал_Code=@ozmCode),N'')+N', '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'COVER' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'NAIL_SIZE' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N',  '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'CAPACITY_PACK' and Материал_Code=@ozmCode)
	-- винты и гвоздь-шурупы
	when @subCat=N'16' then 
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TYPE_SCREWS' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),[По значение])
				else convert(nvarchar(10),[Со значения]) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'DIAM_SCREWS_NEW' and Материал_Code=@ozmCode)+N'х'+
		(select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),convert(int,[По значение]))
				else convert(nvarchar(10),convert(int,[Со значения])) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'LENGTH_SCREWS_NEW' and Материал_Code=@ozmCode)+N' мм, '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'SURF_TYPE' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)
	when @subCat=N'23' then 
		N'Холоднокатанный прокат электротехнических анизотропных сталей, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),[По значение])
				else convert(nvarchar(10),[Со значения]) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения]))+N'-'+
				convert(nvarchar(10),convert(int,[По значение])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
	when @subCat=N'24' then 
		N'Холоднокатанный прокат электротехнических изотропных сталей, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 case
				when [Со значения]=0 then convert(nvarchar(10),[По значение])
				else convert(nvarchar(10),[Со значения]) end from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения]))+N'-'+
				convert(nvarchar(10),convert(int,[По значение])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
	when @subCat=N'5' then 
		case 
		when @ozmCode like N'CR_%' then N'Холоднокатанный прокат с цинковым покрытием, марки '
		else N'Горячекатанный прокат с цинковым покрытием, марки ' end+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 N'класс толщины покрытия '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLS_TOL_POKR' and Материал_Code=@ozmCode)+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения])+N'-'+convert(nvarchar(10),[По значение]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения]))+N'-'+
				convert(nvarchar(10),convert(int,[По значение])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KROM' and Материал_Code=@ozmCode)
	when @subCat=N'6' then 
		N'Горячекатанный прокат, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+
		case (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
				where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
		when N'Лист' then N' мм, длина '+ (select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
												where Признак=N'EC_DLIN' and Материал_Code=@ozmCode)+N' мм, по '
		else N' мм, по ' end+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KROM' and Материал_Code=@ozmCode)
	when @subCat=N'8' then 
		N'Горячекатанный прокат травленный с промасливанием, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+
		case (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
				where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
		when N'Лист' then N' мм, длина '+ (select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
												where Признак=N'EC_DLIN' and Материал_Code=@ozmCode)+N' мм, по '
		else N' мм, по ' end+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KROM' and Материал_Code=@ozmCode)
	when @subCat=N'9' then 
		N'Горячекатанный прокат травленный дрессированный, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+
		case (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
				where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
		when N'Лист' then N' мм, длина '+ (select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
												where Признак=N'EC_DLIN' and Материал_Code=@ozmCode)+N' мм, по '
		else N' мм, по ' end+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', точность прокатки - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TPRK' and Материал_Code=@ozmCode)+N', вид поставки - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', схема упаковки - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'SH_UP' and Материал_Code=@ozmCode)+N', развес - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'RAZVES MAX' and Материал_Code=@ozmCode)
	when @subCat=N'10' then 
		N'Прокат с полимерным покрытием полиэфирной эмалью на оцинкованной основе, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 N'класс толщины покрытия '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLS_TOL_POKR' and Материал_Code=@ozmCode)+N', '+
		(select top 1 N'цвет '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'CVET_POKR' and Материал_Code=@ozmCode)+	N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения])+N'-'+convert(nvarchar(10),[По значение]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения]))+N'-'+
				convert(nvarchar(10),convert(int,[По значение])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KROM' and Материал_Code=@ozmCode)+
		case 
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'GRUP_PRIZ_ZASCH_POV' and Материал_Code=@ozmCode)
		when '-' then N'' else N', '+(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'GRUP_PRIZ_ZASCH_POV' and Материал_Code=@ozmCode) end+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'CHISL_ST_POKR' and Материал_Code=@ozmCode)
	when @subCat=N'11' then 
		N'Холоднокатанный прокат дрессированный термообработанный, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+
		case (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
				where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
		when N'Лист' then N' мм, длина '+ (select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
												where Признак=N'EC_DLIN' and Материал_Code=@ozmCode)+N' мм, по '
		else N' мм, по ' end+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+
		case
			when not (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
				where Признак=N'GRUP_VITYAZHKA' and Материал_Code=@ozmCode) is null then
					N', Вытяжка - '+ (select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
						where Признак=N'GRUP_VITYAZHKA' and Материал_Code=@ozmCode)+N', точность прокатки - '
			else N', точность прокатки - ' end+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'TPRK' and Материал_Code=@ozmCode)+N', вид поставки - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', схема упаковки - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'SH_UP' and Материал_Code=@ozmCode)+N', развес - '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'RAZVES MAX' and Материал_Code=@ozmCode)
	when @subCat=N'12' then 
		N'Холоднокатанный прокат нагартованный, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения])+N'-'+convert(nvarchar(10),[По значение]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения]))+N'-'+
				convert(nvarchar(10),convert(int,[По значение])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KROM' and Материал_Code=@ozmCode)
	when @subCat=N'25' then 
		case 
		when @ozmCode like N'S_0102100%' then N'Сляб, марки '
		else N'Сляб обжатый, марки ' end+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_MARKA' and Материал_Code=@ozmCode)
	when @subCat=N'26' then 
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_PRODUCT' and Материал_Code=@ozmCode),N'')
	when @subCat=N'30' then
		N'Холоднокатанный прокат тонколистовой с цинковым покрытием, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 N'класс толщины покрытия '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLS_TOL_POKR' and Материал_Code=@ozmCode)+N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, длина '+
		isnull((select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'EC_DLIN' and Материал_Code=@ozmCode),' - ')+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
	when @subCat=N'31' then
		N'Прокат на оцинкованной основе с покрытием гладкий полиэфир толщиной 25 мкм, марки '+
		isnull((select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'MARKA' and Материал_Code=@ozmCode),N'')+N', '+
		(select top 1 N'класс толщины покрытия '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'KLS_TOL_POKR' and Материал_Code=@ozmCode)+N', '+
		(select top 1 N'цвет '+[Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'CVET_POKR' and Материал_Code=@ozmCode)+	N', толщина '+
		(select top 1 convert(nvarchar(50),[Со значения]) from MDSDB.mdm.AuspOfProducts
			where Признак=N'TLOT' and Материал_Code=@ozmCode)+N' мм, ширина '+
		(select top 1 convert(nvarchar(10),convert(int,[Со значения])) from MDSDB.mdm.AuspOfProducts
			where Признак=N'SHOT' and Материал_Code=@ozmCode)+N' мм, по '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'STNDRT_PROD' and Материал_Code=@ozmCode)+N', '+
		(select top 1 [Значение признака] from MDSDB.mdm.AuspOfProducts
			where Признак=N'VID_POSTAVKI' and Материал_Code=@ozmCode)
	end

	-- Return the result of the function
	RETURN replace(replace(replace(replace(@Result,N' -,',N','),N', -,',N','),N', -',N','),N',,',N',')

END
GO

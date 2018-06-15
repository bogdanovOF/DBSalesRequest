SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Богданов О.Ф.
-- Create date: 20052015
-- Description:	получить отчет по заявкам по этому виду продукции по этому клиенту за предыдущие 6 месяцев
-- =============================================
ALTER FUNCTION [dbo].[ReqHistoryReportData] 
(	
	-- Add the parameters for the function here
	@RMonth_ nvarchar(10), 
	@Customer_ nvarchar(10),
	@VidProd nvarchar(2)
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT [Плановый месяц]
      ,[Признак заказа]
      ,[вид продукции]
      ,[Признак н/с]
      ,[Регион поставки]
      ,[Страна ВР]
      ,[Экономический регион]
      ,[Название клиента]
      ,[Код клиента]
      ,[Сегмент]
      ,[Вид поставки]
      ,[Вид транспортировки]
      ,[Инкотермс]
      ,[Статус заявки]
      ,[ЕИ]
      ,[Валюта]
      ,[Заявленный объем]
      ,[Подтвержденный объем]
      ,[Площадка]
      ,[term/spot]
      ,[Идентификатор]
      ,[Фронт-офицер]
      ,[ФронтОфицерId]
      ,[Комментарий к сделке]
      ,[Договор]
      ,[ВидПродукцииId]
  FROM [dbo].[vygruzka_allactual]
  where [Плановый месяц] between DATEADD(MONTH,-6,convert(date,@RMonth_,101)) and convert(date,@RMonth_,101) and [ВидПродукцииId]=@VidProd and [Код клиента]=@Customer_

)
GO

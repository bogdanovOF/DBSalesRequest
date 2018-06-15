SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 03112015
-- Description:	vigruzka dly fo
-- =============================================
ALTER FUNCTION [dbo].[FO_report] 
(	
	-- Add the parameters for the function here
	@UserId int,
	@rmonth datetime
)
RETURNS TABLE 
AS

RETURN 

(
	-- Add the SELECT statement with parameter references here
	SELECT        [Плановый месяц], [вид продукции], [Признак н/с], [Регион поставки], [Страна ВР], [Экономический регион], [Название клиента], [Код клиента], Сегмент, [Вид поставки], [Вид транспортировки], Инкотермс, 
                         [Инкотермс 2], [Статус заявки], ЕИ, Валюта, [наименование валюты], [Заявленный объем], [Подтвержденный объем], Площадка, [term/spot], Идентификатор, [Фронт-офицер], ФронтОфицерId, 
                         [Комментарий к сделке], Договор, [годовой план]
FROM            dbo.vygruzka_allactual
WHERE        (ФронтОфицерId = @UserId) and [Плановый месяц] between DATEADD(month,-3,@rmonth) and DATEADD(month,3,@rmonth)
)
GO

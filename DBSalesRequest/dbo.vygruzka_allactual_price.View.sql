USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[vygruzka_allactual_price]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE VIEW [dbo].[vygruzka_allactual_price]
AS
SELECT        DATEADD(MONTH, datediff(MONTH ,0,a.МесяцПоставки) , 0 ) as  [Плановый месяц], CASE WHEN a.Месяцзаказа IS NULL THEN 'тек месяц' WHEN a.МесяцПоставки = a.МесяцЗаказа THEN 'тек месяц' ELSE DATENAME(month, a.месяцзаказа) 
                         + '.' + DATENAME(year, a.месяцзаказа) END AS [Признак заказа], c.[вид продукции], a.ГодныйValue AS [Признак н/с], b.РегионПоставки AS [Регион поставки], b.страна AS [Страна ВР], e.Name AS [Страна Экспорт], 
                         CASE WHEN b.страна IS NULL AND NOT e.name IS NULL THEN e.name WHEN b.страна = 'Россия' AND NOT b.РайонСбыта IS NULL THEN b.РайонСбыта WHEN b.страна <> 'Россия' AND
                          NOT b.страна IS NULL THEN 'СНГ' ELSE 'Не задана' END AS [Экономический регион], CASE WHEN a.длякогометалл IS NULL THEN a.ДебиторНаименование ELSE a.длякогометалл END AS [Название клиента], 
                         a.дебиторкод AS [Код клиента], a.сегментvalue AS Сегмент, a.видпоставкиvalue AS [Вид поставки], a.видтранспортировкиvalue AS [Вид транспортировки], a.инкотермсvalue AS Инкотермс, a.инкотермс2value AS [Инкотермс 2],
                          h.[порт перевалки], a.состояниезаявкиvalue AS [Статус заявки], a.единицаизмеренияvalue AS ЕИ, f.[код валюты] AS Валюта, f.[наименование валюты], a.[Годовой план],  a.заявленныйобъем AS [Заявленный объем], a.МинГарантОбъем AS МГО, 
                         a.допзаявка AS [Доп. заявка], a.подтвержденныйобъем AS [Подтвержденный объем], g.Площадка, a.TermSpotValue AS [term/spot], a.Идентификатор, i.[Идентификатор сотрудника] AS [Фронт-офицер], i.[Имя и Фамилия руководителя], a.БазоваяЦенаБезНДС, a.ПрочиеКомиссииИСборыБезНДС, a.ЦенаНаЗаводеБезНДС, a.ЦенаПокупателяБезНДС, a.СтоимостьПеревалкиБезНДС, a.СтоимостьТранспортировкиБезНДС,
						 a.СтоимостьФрахтаБезНДС, a.Договор
FROM            dbo.DBSRZayavki AS a LEFT OUTER JOIN
                         dbo.DBSRCountry AS e ON a.СтранаЭкспортId = e.идентификатор LEFT OUTER JOIN
                         dbo.DBSRSalesRegion AS b ON a.РегионПоставкиId = b.Идентификатор LEFT OUTER JOIN
                         dbo.DBSRVidprod AS c ON a.ВидПродукцииId = c.Идентификатор LEFT OUTER JOIN
                         dbo.DBSRCurrency AS f ON a.валютаid = f.идентификатор LEFT OUTER JOIN
                         dbo.DBSRBEList AS g ON a.площадкаid = g.идентификатор LEFT OUTER JOIN
                         dbo.DBSRPorts AS h ON a.портперевалкиid = h.идентификатор LEFT OUTER JOIN
                         dbo.VOrgStruc AS i ON a.фронтофицерid = i.EmployeeId INNER JOIN
                             (SELECT        Идентификатор AS ind_, MAX(Изменено) AS dt_
                               FROM            dbo.DBSRZayavki
                               GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
WHERE        (a.состояниезаявкиvalue not in ( 'Черновик', 'Draft')) and a.isdeleted <> 1 and i.[Идентификатор сотрудника] not in ('Богданов Олег', 'Абрамов Дмитрий')









GO

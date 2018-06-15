USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[vygruzka_allactual_price_turkey]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO














CREATE VIEW [dbo].[vygruzka_allactual_price_turkey]
AS
SELECT
	DATEADD(MONTH, datediff(MONTH ,0,a.МесяцПоставки) , 0 ) as  [Production month],
	CASE 
		WHEN a.Месяцзаказа IS NULL THEN 'current month'
		WHEN a.МесяцПоставки = a.МесяцЗаказа THEN 'current month'
		ELSE DATENAME(month, a.месяцзаказа) 
                         + '.' + DATENAME(year, a.месяцзаказа) END AS [Redate indicator],
	c.[NameEn] as [Product name],
	CASE 
		WHEN b.страна IS NULL AND NOT e.name IS NULL THEN e.name
		WHEN b.страна = 'Россия' AND NOT b.РайонСбыта IS NULL THEN b.РайонСбыта
		WHEN b.страна <> 'Россия' AND NOT b.страна IS NULL THEN 'SNG'
		 END AS [Sales region],
	CASE
		WHEN a.длякогометалл IS NULL THEN 'Domestic customer'
		when e.Name ='Turkey' and a.ДляКогоМеталл  is not null then a.ДляКогоМеталл
		ELSE 'Foreign customer' END AS [Company name],
	a.инкотермсvalue AS Инкотермс,
	a.инкотермс2value AS [Инкотермс 2],
	h.[порт перевалки], 
	CASE
		when a.состояниезаявкиvalue='Согласование' then 'Accept in progress'
		when a.состояниезаявкиvalue='Согласовано' then 'Accepted'
		else a.состояниезаявкиvalue end AS [Deal status],
	isnull(a.единицаизмеренияvalue,'т') AS [Unit of measure],
	f.[код валюты] AS [Currency ID],
	a.подтвержденныйобъем AS [Accepted Volume],
	isnull(g.Been,g.Площадка) as [Production site],
	a.TermSpotValue AS [term/spot],
	a.Идентификатор as ID_,
	case
		when i.[Идентификатор сотрудника]='Пексой Оркан' then 'Peksoy Orkan'
		else 'NLMK sales manager' end AS [Manager name],
	case
		when i.[Имя и Фамилия руководителя]='Козлов Александр' then 'Export'
		else 'Domestic' end as Direction,
	a.ПрочиеКомиссииИСборыБезНДС as OtherCosts,
	a.ЦенаНаЗаводеБезНДС as PriceOnPlantsGate,
	a.ЦенаПокупателяБезНДС as Price,
	a.СтоимостьПеревалкиБезНДС as TransshipmentCosts,
	a.СтоимостьТранспортировкиБезНДС as TransferCosts,
	a.СтоимостьФрахтаБезНДС as FrightCosts,
	case
		when f.[код валюты] = 'USD' then a.ЦенаНаЗаводеБезНДС
		when f.[код валюты] = 'EUR' then a.ЦенаНаЗаводеБезНДС* (select top 1 [EUR]/[USD] from [dbo].[DBSRSlipCurrExch] 
		 inner join
		 (select mc_ as idd, MAX(CurDate) as dt_ from DBSRSlipCurrExch group by mc_) a on mc_=a.idd )
		else a.ЦенаНаЗаводеБезНДС*(select top 1 [USD] from [dbo].[DBSRSlipCurrExch] 
		 inner join
		 (select mc_ as idd, MAX(CurDate) as dt_ from DBSRSlipCurrExch group by mc_) as b on mc_=b.idd )
			 end PriceOnPlantsGate_USD

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
WHERE        (a.состояниезаявкиvalue not in ( 'Черновик', 'Draft'))
				 and a.isdeleted <> 1
					and i.[Идентификатор сотрудника] not in ('Богданов Олег', 'Абрамов Дмитрий')
						and c.[NameEn] is not null
							and a.подтвержденныйобъем is not null















GO

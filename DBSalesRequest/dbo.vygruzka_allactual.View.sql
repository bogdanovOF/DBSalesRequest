USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[vygruzka_allactual]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vygruzka_allactual]
AS
SELECT
      convert(date,DATETIMEOFFSETFROMPARTS(year(a.МесяцПоставки), month(a.МесяцПоставки),1,0,0,0,0,0,0,0)) as [Плановый месяц],
	  CASE
		WHEN a.Месяцзаказа IS NULL THEN 'тек месяц'
		WHEN a.МесяцПоставки = a.МесяцЗаказа THEN 'тек месяц'
		ELSE DATENAME(month, a.месяцзаказа) + '.' + DATENAME(year, a.месяцзаказа) END AS [Признак заказа],
		c.[вид продукции],
		a.ГодныйValue AS [Признак н/с],
		l.code as code,
		j.[Код дебитора SAP_Code] as codej,
		case
			when not l.code is null  then l.Region_Name
			else b.РегионПоставки end AS [Регион поставки],
		case
			when not l.code is null  then l.Страна_Name
			else b.страна end AS [Страна ВР],
		e.Name AS [Страна Экспорт],
		a.[СтранаНазначенияЭкспорт],
		CASE
			WHEN b.страна IS NULL AND NOT e.name IS NULL THEN e.name
			WHEN b.страна = 'Россия' AND NOT b.РайонСбыта IS NULL THEN b.РайонСбыта
			WHEN b.страна <> 'Россия' AND NOT b.страна IS NULL THEN 'СНГ'
			ELSE 'Не задана' END AS [Экономический регион],
		case when not j.[Код дебитора SAP_Code] is null then j.[имя для отчетов] 
			 when not l.code is null then l.Name
			 when a.[ДляКогоМеталл] is null then a.[ДебиторНаименование]
			 else a.[ДляКогоМеталл] END AS [Название клиента], 
		case 
			when not a.ДебиторКод is null then a.ДебиторКод
			when not a.длякогометалл IS NULL then m.CustomerCode_Code
			else ''	end [Код клиента],
		case
			when k.Сегмент1_Name  is null then a.сегментvalue
			else k.Сегмент1_Name end AS Сегмент,
		a.видпоставкиvalue AS [Вид поставки], 
        a.видтранспортировкиvalue AS [Вид транспортировки],
		a.инкотермсvalue AS Инкотермс,
		a.инкотермс2value AS [Инкотермс 2],
		h.[порт перевалки],
		a.состояниезаявкиvalue AS [Статус заявки], 
        a.единицаизмеренияvalue AS ЕИ,
		f.[код валюты] AS Валюта,
		f.[наименование валюты],
		a.[Годовой план],
		a.заявленныйобъем AS [Заявленный объем без МГО],
		a.МинГарантОбъем AS [МГО.Длинные],
		a.допзаявка AS [МГО.Проданные],
		case 
			when a.МесяцПоставки <DATETIMEOFFSETFROMPARTS(2017,1,1,0,0,0,0,0,0,0) then a.заявленныйобъем
			else isnull(a.МинГарантОбъем,0)+isnull(a.допзаявка,0)+isnull(a.заявленныйобъем,0) end as [Всего заявлено],
        a.подтвержденныйобъем AS [Подтвержденный объем],
		g.BE as Площадка,
		a.TermSpotValue AS [term/spot],
		a.Идентификатор,
		i.[Имя] AS [Фронт-офицер],
		z.[Имя и Фамилия руководителя],
		a.фронтофицерid, 
        dbo.udf_StripHTML(a.КомментарийКСделке) AS [Комментарий к сделке],
		a.Договор,
		a.ВидПродукцииId,
		j.KeyAcc_Name as [Статус клиента],
		j.NamePlanning_Code as [Поименное планирование],
		a.Изменено,
		a.Версия,
		a.FKPI as [КПЭ]
FROM    dbo.DBSRZayavki AS a LEFT OUTER JOIN
        dbo.DBSRCountry AS e ON a.СтранаЭкспортId = e.идентификатор LEFT OUTER JOIN
        dbo.DBSRSalesRegion AS b ON a.РегионПоставкиId = b.Идентификатор LEFT OUTER JOIN
        dbo.DBSRVidprod AS c ON a.ВидПродукцииId = c.Идентификатор LEFT OUTER JOIN
        dbo.DBSRCurrency AS f ON a.валютаid = f.идентификатор LEFT OUTER JOIN
        dbo.DBSRBEList AS g ON a.площадкаid = g.идентификатор LEFT OUTER JOIN
        dbo.DBSRPorts AS h ON a.портперевалкиid = h.идентификатор
		 INNER JOIN
        (SELECT        Идентификатор AS ind_, MAX(Изменено) AS dt_
        FROM            dbo.DBSRZayavki where isdeleted=0
        GROUP BY Идентификатор ) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_ Left outer join
		(select
			a.[Код дебитора SAP_Code]  collate Cyrillic_General_100_CI_AS as [Код дебитора SAP_Code],
			[имя для отчетов] collate Cyrillic_General_100_CI_AS  as [имя для отчетов],
			KeyAcc_Name collate Cyrillic_General_100_CI_AS as KeyAcc_Name,
			NamePlanning_Code collate Cyrillic_General_100_CI_AS as NamePlanning_Code,
			Сегмент_Code
		 from MDSDB.mdm.AccDop  as a inner join 
				(select [Код дебитора SAP_Code], max(DateStart) as ds_ from MDSDB.mdm.AccDop group by [Код дебитора SAP_Code]) as c
					on a.[Код дебитора SAP_Code]=c.[Код дебитора SAP_Code] and DateStart=c.ds_) AS j
					 on a.дебиторкод = j.[Код дебитора SAP_Code]  left outer join
		(select code, Сегмент1_Name  collate Cyrillic_General_100_CI_AS as Сегмент1_Name from MDSDB.mdm.Segments) AS k on j.Сегмент_Code = k.Code left outer join 
		(select code collate Cyrillic_General_100_CI_AS as code,
				Region_Name collate Cyrillic_General_100_CI_AS as region_name,
				Страна_Name collate Cyrillic_General_100_CI_AS as страна_name,
				Name collate Cyrillic_General_100_CI_AS as name from MDSDB.mdm.CustomersAll) as l on a.дебиторкод =l.[Code] left outer join
		(select CustomerCode_Code collate Cyrillic_General_100_CI_AS as CustomerCode_Code,
				FirmName collate Cyrillic_General_100_CI_AS as FirmName from MDSDB.mdm.TrashExpFirmName) as m on a.длякогометалл = m.FirmName
		LEFT OUTER JOIN
        dbo.DBSRUsers AS i ON a.фронтофицерid = i.Идентификатор
		left outer join
		(select a.[Имя] as [Имя и Фамилия руководителя],
				b.EmployeeId
					from dbo.DBSRUsers as a inner join dbo.DBSROrgStruct as b
					on a.Идентификатор=b.ChiefId) as z on a.ФронтОфицерId=z.EmployeeId
WHERE       a.состояниезаявкиvalue not in ( 'Черновик', 'Draft', 'Аннулировано') and a.isdeleted =0
 and i.[Имя] not in ('Богданов Олег Федорович', 'Абрамов Дмитрий Геннадьевич', 'Пексой Оркан')



























GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -480
         Left = -1137
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 337
            End
            DisplayFlags = 280
            TopColumn = 32
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 268
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 138
               Left = 252
               Bottom = 268
               Right = 432
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 366
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 270
               Left = 252
               Bottom = 383
               Right = 470
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 366
               Left = 38
               Bottom = 479
               Right = 214
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "h"
            Begin Extent = 
               Top = 384
               Left = 252
               Bottom = 480
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 0
     ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_allactual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'    End
         Begin Table = "i"
            Begin Extent = 
               Top = 480
               Left = 38
               Bottom = 610
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 480
               Left = 266
               Bottom = 576
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 7920
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_allactual'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_allactual'
GO

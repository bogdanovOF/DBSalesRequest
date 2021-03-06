USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[vygruzka_v1]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vygruzka_v1]
AS
SELECT        a.МесяцПоставки, a.ДебиторКод, dbo.DBSRVidprod.[вид продукции], a.ГодныйValue, a.ДебиторНаименование, a.СостояниеЗаявкиValue, a.TermSpotValue, a.ВидПоставкиValue, 
                         dbo.DBSRSalesRegion.РайонСбыта, a.ИнкотермсValue, a.Инкотермс2Value, a.ПодтвержденныйОбъем, dbo.DBSRSalesRegion.РегионПоставки, a.Путь, a.Идентификатор, a.МинГарантОбъем, a.ДопЗаявка, 
                         a.ЗаявленныйОбъем
FROM            dbo.DBSRZayavki AS a LEFT OUTER JOIN
                         dbo.DBSRSalesRegion ON a.РегионПоставкиId = dbo.DBSRSalesRegion.Идентификатор LEFT OUTER JOIN
                         dbo.DBSRVidprod ON a.ВидПродукцииId = dbo.DBSRVidprod.Идентификатор INNER JOIN
                             (SELECT        Идентификатор AS ind_, MAX(Изменено) AS dt_
                               FROM            dbo.DBSRZayavki
                               GROUP BY Идентификатор) AS b ON a.Идентификатор = b.ind_ AND a.Изменено = b.dt_
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[59] 4[2] 2[20] 3) )"
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
         Top = 0
         Left = 0
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
            TopColumn = 52
         End
         Begin Table = "DBSRSalesRegion"
            Begin Extent = 
               Top = 240
               Left = 873
               Bottom = 370
               Right = 1053
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DBSRVidprod"
            Begin Extent = 
               Top = 79
               Left = 718
               Bottom = 175
               Right = 894
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 234
               Right = 208
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
      Begin ColumnWidths = 14
         Width = 284
         Width = 2430
         Width = 2730
         Width = 1500
         Width = 1500
         Width = 1500
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
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_v1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_v1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vygruzka_v1'
GO

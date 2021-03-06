USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[DBSR_Anisimov_1]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DBSR_Anisimov_1]
AS
SELECT        h.new_category AS Категория, c.new_name AS [Сегмент 1], c.new_groupsegments AS [Сегмент 2], f.City AS Город, f.Country AS Страна, g.new_name AS [Вид продукции], 
                         g.new_consumption_in_month AS [Общее потребление. мес./тонн], g.new_consumption_in_month_NLMK AS [В том числе НЛМК. мес./тонн], a.Name AS Заказчик, b.new_SAPcode AS [Код SAP], 
                         b.new_industry AS Отрасль, b.new_zdcode AS [ЖД код], h.new_name AS Должность, d.FullName AS [Фронт-офицер]
FROM            [NLMK-CRMDB].NLMK_MSCRM.dbo.AccountBase AS a INNER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.AccountExtensionBase AS b ON a.AccountId = b.AccountId LEFT OUTER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.new_segmentation AS c ON b.new_segmentationid = c.new_segmentationId LEFT OUTER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.SystemUserBase AS d ON b.new_ownerfo = d.SystemUserId INNER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.SystemUserExtensionBase AS e ON d.SystemUserId = e.SystemUserId LEFT OUTER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.CustomerAddressBase AS f ON a.AccountId = f.ParentId LEFT OUTER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.new_consumption_volumeExtensionBase AS g ON a.AccountId = g.new_accountid LEFT OUTER JOIN
                         [NLMK-CRMDB].NLMK_MSCRM.dbo.new_appointmentExtensionBase AS h ON e.new_appointmentid = h.new_appointmentId

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[22] 2[21] 3) )"
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
               Bottom = 348
               Right = 301
            End
            DisplayFlags = 280
            TopColumn = 68
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 339
               Bottom = 324
               Right = 538
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 576
               Bottom = 136
               Right = 835
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 873
               Bottom = 136
               Right = 1127
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 176
               Left = 729
               Bottom = 306
               Right = 933
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 306
               Left = 576
               Bottom = 436
               Right = 830
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 348
               Left = 38
               Bottom = 478
               Right = 319
            End
            DisplayFlags = 280
            TopColumn = 0
         End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DBSR_Anisimov_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Begin Table = "h"
            Begin Extent = 
               Top = 306
               Left = 868
               Bottom = 436
               Right = 1063
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
         Column = 3720
         Alias = 3495
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DBSR_Anisimov_1'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DBSR_Anisimov_1'
GO

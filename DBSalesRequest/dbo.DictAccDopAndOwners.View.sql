USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[DictAccDopAndOwners]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[DictAccDopAndOwners]
AS
with AccDop_cte (Code, ds_)
as
(
select [Код дебитора SAP_Code]as code, max(DateStart) as ds_ from MDSDB.mdm.AccDop
group by [Код дебитора SAP_Code]
)
SELECT
	   c.[Наименование площадки], 
       b.[Код предприятия_Code] AS [Код предприятия],
	   a.[Имя для отчетов] AS [Название предприятия],
	   a.ОПФ_Name as ОПФ,
	   b.AccStatusByBE_Name AS Статус,
	   b.[Фронт-Офицер_Name] AS [Фронт-офицер1],
	   b.[Фронт-офицер2_Name] AS [Фронт-офицер2],
	   b.[Фронт-офицер3_Name] AS [Фронт-офицер3], 
       b.[Мидл-офицер_Name] AS [Мидл-офицер1],
	   b.[Мидл-офицер2_Name] AS [Мидл-офицер2],
	   d.Сегмент1_Name AS Сегмент1,
	   d.Сегмент2,
	   a.KeyAcc_Name as [Статус клиента],
	   a.NamePlanning_Code as [Поименное планирование]
FROM   
         MDSDB.mdm.AccDop AS a right OUTER JOIN
		 MDSDB.mdm.OwnersByBE AS b ON a.[Код дебитора SAP_Code] = b.[Код предприятия_Code] LEFT OUTER JOIN
         MDSDB.mdm.BE AS c ON b.БЕ_Code = c.Code LEFT OUTER JOIN
         MDSDB.mdm.Segments AS d ON a.Сегмент_Code = d.Code inner join
		(SELECT [Код предприятия_Code]+'_'+[БЕ_Code] as key_, max([DateStart]) as ds_
				FROM [MDSDB].[mdm].[OwnersByBE]
				group by [Код предприятия_Code]+'_'+[БЕ_Code]) as e
				on b.[Код предприятия_Code]+'_'+b.[БЕ_Code]=e.key_ and b.DateStart=e.ds_
				inner join AccDop_cte as f
				on a.[Код дебитора SAP_Code]=f.Code and a.DateStart=f.ds_
						 


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
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "a"
            Begin Extent = 
               Top = 24
               Left = 461
               Bottom = 314
               Right = 685
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 24
               Left = 72
               Bottom = 310
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 16
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 34
               Left = 836
               Bottom = 273
               Right = 1068
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 6
               Left = 1106
               Bottom = 321
               Right = 1321
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
         Width = 2130
         Width = 4470
         Width = 1500
         Width = 2265
         Width = 3060
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
         Column = 5400
         Alias = 4785
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DictAccDopAndOwners'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DictAccDopAndOwners'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'DictAccDopAndOwners'
GO

USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[AllCrmAccInnSapC]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[AllCrmAccInnSapC]
as
SELECT Accountid, new_inn, new_sapcode
FROM [NLMK-CRMDB].NLMK_MSCRM.dbo.AccountExtensionBase
GO

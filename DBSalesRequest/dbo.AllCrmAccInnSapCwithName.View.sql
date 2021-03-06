USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[AllCrmAccInnSapCwithName]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[AllCrmAccInnSapCwithName]
as
select a.name, b.new_sapcode from [NLMK-CRMDB].NLMK_MSCRM.dbo.AccountBase as a inner join [NLMK-CRMDB].NLMK_MSCRM.dbo.AccountExtensionBase as b
 on a.Accountid=b.accountid 
 where not b.new_sapcode is null and not a.name is null

GO

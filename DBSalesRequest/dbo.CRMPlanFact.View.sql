USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[CRMPlanFact]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[CRMPlanFact]
AS

select [месяц]
      ,[год]
      ,[CustomerCode]
      ,[contractNumber]
      ,[VidProdZayavkiId]
	  ,new_Sapcode
      ,[new_ordername]
      ,[positionnumber]
      ,[planvolume]
      ,[factvolume]
      ,[new_sapstatus]
      ,[new_type]
      ,[new_status]
 from [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[NLMKAnalitik_CRMPlanFact_date]
		right join [MapVidZayavkiToCrm] on KmatCode collate Cyrillic_General_CI_AI = NLMKAnalitik_CRMPlanFact_date.new_Sapcode 


GO

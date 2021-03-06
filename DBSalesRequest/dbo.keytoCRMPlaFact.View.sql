USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[keytoCRMPlaFact]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[keytoCRMPlaFact]
as
SELECT distinct [месяц],[год],[CustomerCode],[contractNumber],[VidProdZayavkiId]
  FROM [DBSalesRequest].[dbo].[CRMPlanFact]
  where [месяц] is not  null
  and год is not null
  and CustomerCode is not null
  and contractNumber is not null
GO

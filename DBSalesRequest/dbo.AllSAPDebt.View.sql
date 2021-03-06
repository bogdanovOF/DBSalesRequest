USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[AllSAPDebt]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Script for SelectTopNRows command from SSMS  ******/
CREATE view [dbo].[AllSAPDebt]
as
SELECT distinct [Дебитор]
	  ,[ИНН]
      ,[FullName]
      ,[Страна]
	  ,ShortName
  FROM [DBSalesRequest].[dbo].[Customers]
  where LEFT([FullName],1)<>'_' and not ИНН in ('0', '00000000000','000000000000', '0000020000')


GO

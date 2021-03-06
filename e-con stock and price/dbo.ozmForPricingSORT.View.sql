USE [e-con stock and price]
GO
/****** Object:  View [dbo].[ozmForPricingSORT]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[ozmForPricingSORT]
AS
SELECT distinct a.[сбытовая организация], a.[склад заказ] as [склад], a.[материал], c.[Базисная ЕИ_Code], c.name, isnull(b.ecgrp,3) as ecgrp, b.Name as stockName
 from [NLMK_SORT].dbo.[NLMK_SORT_BR] as a
	left outer join [MDSDB].[mdm].[StocksOfProducts] as b 
	on convert(nvarchar(10),a.[Сбытовая организация])=convert(nvarchar(10),b.BE_Code) collate Cyrillic_General_CI_AS 
		and convert(nvarchar(10),a.[Склад заказ])=convert(nvarchar(10),b.Code_SAP) collate Cyrillic_General_CI_AS
		left outer join MDSDB.mdm.OZMOfProducts as c
		on a.Материал=c.Code  collate Cyrillic_General_CI_AS
	where (Материал like N'LP_%' or Материал like N'MW_%' or Материал like N'SS_%')
	and (not [Краткий текст материала] like N'/_%')
	and ([Вид ТорговДокумента] in (N'ZVR', N'ZEXP'))
	and ([Отдел сбыта]=N'0006')
	and [Завод заказ] like N'%1'
	and not [Базисная ЕИ_Code] is null
GO

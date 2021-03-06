USE [e-con stock and price]
GO
/****** Object:  View [dbo].[ozmForPricingNLMK]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[ozmForPricingNLMK]
AS
SELECT  distinct N'1010' as [сбытовая организация], [склад], [материал], c.[Базисная ЕИ_Code], c.name, 3 as ecgrp, N'НЛМК-Липецк' as stockName 
 from SAP_REP.dbo.[BRN] left outer join MDSDB.mdm.OZMOfProducts as c
		on Материал=c.Code  collate Cyrillic_General_CI_AS
 where [НаимГрКонтирМтрл] in
  (N'Горячекатный прокат',
    N'Оцинкованный прокат',
	  N'Прокат с полим покр',
	    N'Сляб',
		  N'ХолКатПрок Анизот Ст',
		    N'ХолКатПрок Изотр Ст',
			  N'Холоднокатан прокат',
			    N'Чугун')
	and not ([Внеш номер договора] like N'Х%' or [Внеш номер договора] like N'В%')
	and [Склад] like N'%1'
	and [Канал сбыта наименование] <> N'Экспорт'
	and [Сектор наименование] = N'ГП осн.производства'
	and not c.Name is null


GO

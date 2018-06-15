SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 03112015
-- Description:	vigruzka dly fo
-- =============================================
ALTER FUNCTION [dbo].[FO_report_1] 
(	
	-- Add the parameters for the function here
	@UserId nvarchar(100),
	@rmonth datetime null
)
RETURNS TABLE 
AS

RETURN 

(
	-- Add the SELECT statement with parameter references here
	SELECT [Плановый месяц],
		   a.[вид продукции],
		   [Признак н/с],
		   [Имя для отчетов] as [Клиент],
		   [Код клиента],
		   [Сегмент_Name] as [Сегмент],
		   Договор,
		   [Вид поставки],
		   [Вид транспортировки],
		   [Статус заявки],
		   [годовой план],
		   [Заявленный объем],
		   [Подтвержденный объем],
		   d.planvolume as [выдано заказов],
		   d.factvolume as [отгружено],
		   Площадка,
		   a.Идентификатор,
		   [Комментарий к сделке]
FROM  dbo.vygruzka_allactual as a left outer join MDSDB.mdm.accdop as b on [Код клиента]= [Код дебитора SAP_Code] collate Cyrillic_General_100_CI_AS
		left outer join [DBSalesRequest].[dbo].[DBSRVidprod] as c on a.[вид продукции]=c.[вид продукции]
			left outer join (
							select convert(nvarchar(2),месяц)+
									'_'+convert(nvarchar(4),год)+'_'+[CustomerCode]
									+'_'+[contractNumber]+'_'+convert(nvarchar,[VidProdZayavkiId]) as key_,
									sum([planvolume]) as [planvolume],
									sum ([factvolume]) as [factvolume]
							from [dbo].[CRMPlanFact]
							group by convert(nvarchar(2),месяц)+
							'_'+convert(nvarchar(4),год)+'_'+[CustomerCode]+
							'_'+[contractNumber]+'_'+convert(nvarchar,[VidProdZayavkiId])
							) as d
			on convert(nvarchar(2),month(a.[Плановый месяц]))+
			'_'+convert(nvarchar(4),year(a.[Плановый месяц]))+
			'_'+a.[Код клиента]+'_'+a.Договор+'_'+convert(nvarchar,c.Идентификатор) =d.key_ collate Cyrillic_General_CI_AI
WHERE (ФронтОфицерId = (select Идентификатор from dbo.DBSRUsers where [ИмяПользователя]=@UserId))
		and [Плановый месяц] between DATEADD(month,-3,isnull(@rmonth,getdate())) and DATEADD(month,3,isnull(@rmonth,getdate()))
)

GO

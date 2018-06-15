SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 09082016
-- Description:	refresh fact from CRM
-- =============================================
ALTER PROCEDURE [dbo].[RefreshSpecOrdShip] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	declare @SincId_ as uniqueidentifier = newid()
	declare @SincTime as datetime = getdate()
	declare @deepDate as date = convert(date,DATETIMEOFFSETFROMPARTS(year(DATEADD(month,-12,getdate())), month(DATEADD(month,-12,getdate())),1,5,0,0,0,0,0,0))

	begin tran RefreshSpecOrderShipData

	begin try
		delete from [DBSalesRequest].dbo.CRMSpeOrdShipFact
			where [RequestMonth]>=@deepDate or [SpecVol]>0

	-- данные по заказам

		INSERT INTO [dbo].[CRMSpeOrdShipFact]
			   ([Customer]
			   ,[Contract]
			   ,[RequestMonth]
			   ,PosMonth
			   ,[RMname]
			   ,[Kmat]
			   ,[VidProd]
			   ,[vidpostav]
			   ,[OrderVol]
			   ,[ShipVol]
			   ,[sincdate]
			   ,[sincid])
		SELECT 	
			[AccountExtensionBase].new_SAPcode as CustomerCode,
			contractExt.new_number1 as contractNumber,
			orderExt.new_mounth,
			orderPosExt.new_mounth,
			format(orderExt.new_mounth,'yyyyMM','ru-RU'),
			classExt.new_Sapcode,
			0 as vidprod,
			orderPosExt.new_product,
			orderPosExt.new_volume as planvolume,
			shipPosSum.factVolume as factvolume,
			@SincTime,
			@SincId_
		FROM [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_orderExtensionBase orderExt
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[AccountBase] on orderExt.new_account=[AccountBase].[accountid]
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[AccountExtensionBase] on [AccountBase].[accountid]=[AccountExtensionBase].[accountid]
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_contractExtensionBase contractExt on orderExt.new_contract = contractExt.new_contractId
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_contractBase [contract] on contractExt.new_contractid = [contract].new_contractId and [contract].statecode = 0
			-- только активные
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_orderBase [order] on [order].new_orderId = orderExt.new_orderId and [order].statecode = 0
			left join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_orderpositionExtensionBase orderPosExt on orderExt.new_orderid = orderPosExt.new_order 
				-- только активные
				inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_orderpositionBase orderPos on orderPos.new_orderpositionId = orderPosExt.new_orderpositionId and orderPos.statecode = 0
				left join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_classExtensionBase classExt on orderPosExt.new_class = classExt.new_classId
				left join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[ibs_new_orderposition_shipPosSum] shipPosSum on shipPosSum.new_orderposition = orderPosExt.new_orderpositionId
		where
			contractExt.new_status='Действующий'
			and (orderPosExt.new_sapstatus IS NULL OR orderPosExt.new_sapstatus <> 'АннулированиеПозиции')
			and orderExt.new_type NOT IN ('ZCR-', 'ZDR+', 'ZVOZ', 'ZVZP', 'ZIZL', 'ZIZP')
			and orderExt.new_mounth>=@deepDate
			and not classExt.new_Sapcode is null
			
	
	-- обновление видов продукции по кматам

		update [DBSalesRequest].[dbo].[CRMSpeOrdShipFact] set vidprod = b.VidProdZayavkiId from [DBSalesRequest].[dbo].[CRMSpeOrdShipFact] as a
		 inner join [DBSalesRequest].dbo.[MapVidZayavkiToCrm] as b
			on a.[Kmat] collate Cyrillic_General_100_CI_AS = b.KmatCode 

	-- добавление спецификаций на согласовании ОЗ и ОП
		INSERT INTO [dbo].[CRMSpeOrdShipFact]
					   ([Customer]
					   ,[Contract]
					   ,[RequestMonth]
					   ,[RMname]
					   ,[Kmat]
					   ,[VidProd]
					   ,[vidpostav]
					   ,[SpecVol]
					   ,[sincdate]
					   ,[sincid])
			SELECT 	
			[AccountExtensionBase].new_SAPcode as CustomerCode,
			contractExt.new_number1 as contractNumber,
			convert(date,specExt.new_date),
			replace(right(specExt.new_date,7),'.',''),
			classExt.new_Sapcode,
			b.VidProdZayavkiId,
			specPosExt.new_product,
			specPosExt.new_volume as planvolume,
			@SincTime,
			@SincId_
		FROM [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_specificationExtensionBase specExt
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[AccountBase] on specExt.new_account=[AccountBase].[accountid]
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[AccountExtensionBase] on [AccountBase].[accountid]=[AccountExtensionBase].[accountid]
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_contractExtensionBase contractExt on specExt.new_contract = contractExt.new_contractId
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_contractBase [contract] on contractExt.new_contractid = [contract].new_contractId and [contract].statecode = 0
			-- только активные
			inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_specificationBase [specs] on [specs].new_specificationId = specExt.new_specificationId and [specs].statecode = 0
			left join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_specifpositionExtensionBase specPosExt on specExt.new_specificationid = specPosExt.new_specificationid
				-- только активные
				inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_specifpositionBase specPos on specPos.new_specifpositionId = specPosExt.new_specifpositionId and specPos.statecode = 0
				left join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].new_classExtensionBase classExt on specPosExt.new_class = classExt.new_classId
				inner join [DBSalesRequest].dbo.[MapVidZayavkiToCrm] as b on classExt.[new_Sapcode] collate Cyrillic_General_100_CI_AS = b.KmatCode 
		where
			contractExt.new_status='Действующий' and specExt.new_status1 in (100000000, 100000001)

		
		-- приводим вид поставки к заявкам
		update [dbo].[CRMSpeOrdShipFact] set VidPostav=case	VidPostav
			when 'РЛН'  then 'рулон'
			when 'Рулон' then 'рулон'
			when 'ЛСТ' then 'лист'
			when 'Лист' then 'лист'
			when 'РЛН РСП' then 'рулон с роспуском'
			when 'Рулон с роспуском' then 'рулон с роспуском'
			when 'ЛНТ' then 'лента'
			when 'Лента' then 'лента'
			else 'иное' end

		commit tran RefreshSpecOrderShipData
	end try
	begin catch
		If @@TRANCOUNT > 0 Rollback Transaction RefreshSpecOrderShipData
		Print 'Произошла ошибка обновления данных';
		THROW
	end catch

END

GO

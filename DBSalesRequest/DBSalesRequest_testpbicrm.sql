SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
		ALTER function [dbo].[testpbicrm](@date_ date)
		RETURNS TABLE 
AS
RETURN 
		(SELECT 	
			[AccountExtensionBase].new_SAPcode as CustomerCode,
			contractExt.new_number1 as contractNumber,
			orderExt.new_mounth as order_month,
			orderPosExt.new_mounth as order_pos_month,
			classExt.new_Sapcode,
			0 as vidprod,
			orderPosExt.new_product,
			orderPosExt.new_volume as planvolume,
			shipPosSum.factVolume as factvolume
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
			and orderExt.new_mounth>=@date_
			and not classExt.new_Sapcode is null
			)
GO

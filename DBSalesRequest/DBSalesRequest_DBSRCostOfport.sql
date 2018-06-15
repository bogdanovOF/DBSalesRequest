SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov_of
-- Create date: 17032015
-- Description:	портовые расходы
-- =============================================
ALTER procedure [dbo].[DBSRCostOfport]
(
	-- Add the parameters for the function here
	-- месяц поставки
	@month_ date,
	-- вид продукции
	@vp_ int,
	-- порт перевалки
	@port_ int=null,
	-- валюта
	@currency_ int,
	@Result money output
)

AS
BEGIN
	-- Declare the return variable here
	set @Result =null
	declare @USDPriceCPT as money=null
	declare @EURPriceCPT as money=null
	declare @USDPriceFOB as money=null
	declare @EURPriceFOB as money=null

	-- если CPT or FOB

		if exists(select * from [dbo].[DBSRPriceOfTransportation] as a inner join [dbo].[DBSRVPGroup] as b on
		a.SRVPGroupValue=b.[SRVPGroupValue]
		where a.ДействуетС<=@month_ and [SRincoValue]='FOB' and a.SRPortId=@port_ and b.[SRVidProdId]=@vp_)
		begin
		select @USDPriceFOB=a.СтоимостьUSDТ, @EURPriceFOB=a.СтоимостьEURТ from [dbo].[DBSRPriceOfTransportation] as a inner join
			(select max(c.[Идентификатор]) id_, max(c.ДействуетС) zdate  from [dbo].[DBSRPriceOfTransportation] as c inner join 
			 [dbo].[DBSRVPGroup] as b on
			c.SRVPGroupValue=b.[SRVPGroupValue]
			where c.ДействуетС<=@month_ and c.SRPortId=@port_ and c.SRincoValue='FOB' and b.[SRVidProdId]=@vp_
			group by c.SRVPGroupValue, c.SRPortId, c.SRincoValue) b on a.Идентификатор=b.id_

		select @USDPriceCPT=a.СтоимостьUSDТ, @EURPriceCPT=a.СтоимостьEURТ from [dbo].[DBSRPriceOfTransportation] as a inner join
			(select max(c.[Идентификатор]) id_, max(c.ДействуетС) zdate  from [dbo].[DBSRPriceOfTransportation] as c inner join 
			 [dbo].[DBSRVPGroup] as b on
			c.SRVPGroupValue=b.[SRVPGroupValue]
			where  c.ДействуетС<=@month_ and c.SRPortId=@port_ and c.SRincoValue='CPT' and b.[SRVidProdId]=@vp_
			group by c.SRVPGroupValue, c.SRPortId, c.SRincoValue) b on a.Идентификатор=b.id_
		end

		if exists(select * from DBSRCurrency where Идентификатор=@currency_ and [Код валюты]='USD')
		begin
		set @Result=@USDPriceFOB-@USDPriceCPT
		end
		else
		begin
		set @Result=@EURPriceFOB-@EURPriceCPT
		end
	
	-- Return the result of the function
	RETURN @Result

END
GO

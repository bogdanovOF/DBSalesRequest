SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov_of
-- Create date: 17032015
-- Description:	провозная плата
-- =============================================
ALTER procedure [dbo].[DBSRCostOfTransfer] 
(
	-- Add the parameters for the function here
	-- месяц поставки
	@month_ date,
	-- вид продукции
	@vp_ int,
	-- порт перевалки
	@port_ int=null,
	-- страна экспортная
	@country_ int=null,
	-- инко1
	@inco1 nvarchar(3),
	-- инко2
	@inco2 nvarchar(100)=null,
	-- валюта
	@currency_ int,
	@Result money output
)

AS
BEGIN
	-- Declare the return variable here
	Set @Result = null
	declare @USDPrice as money=null
	declare @EURPrice as money=null

	-- если CPT or FOB
		if (not @port_ is null) and exists(select * from [dbo].[DBSRPriceOfTransportation] as a inner join [dbo].[DBSRVPGroup] as b on
		a.SRVPGroupValue=b.[SRVPGroupValue]
		where a.ДействуетС<=@month_ and [SRincoValue]='CPT' and a.SRPortId=@port_ and b.[SRVidProdId]=@vp_)
		begin
			select @USDPrice=a.СтоимостьUSDТ, @EURPrice=a.СтоимостьEURТ from [dbo].[DBSRPriceOfTransportation] as a inner join
				(select max(c.[Идентификатор]) id_, max(c.ДействуетС) zdate  from [dbo].[DBSRPriceOfTransportation] as c
				inner join  [dbo].[DBSRVPGroup] b
						on c.SRVPGroupValue=b.[SRVPGroupValue]
						where  c.ДействуетС<=@month_ and b.[SRVidProdId]=@vp_ and c.SRPortId=@port_ and c.SRincoValue='CPT'
				group by c.SRVPGroupValue, c.SRPortId, c.SRincoValue) b on a.Идентификатор=b.id_
		end;
	-- если DAP
		if (@port_ is null) and exists(	select * from [dbo].[DBSRPriceOfTransportation] as a inner join [dbo].[DBSRVPGroup] as b on
		a.SRVPGroupValue=b.[SRVPGroupValue]
		where a.ДействуетС<=@month_ and [SRincoValue]='DAP' and a.SRCountryId=@country_ and a.SRInco2Value=@inco2 and b.[SRVidProdId]=@vp_)
		begin
			select @USDPrice=a.СтоимостьUSDТ, @EURPrice=a.СтоимостьEURТ from [dbo].[DBSRPriceOfTransportation] as a
				inner join (
							select max(c.[Идентификатор]) id_, max(c.ДействуетС) zdate  from [dbo].[DBSRPriceOfTransportation] as c
								inner join [dbo].[DBSRVPGroup] b
								on c.SRVPGroupValue=b.[SRVPGroupValue] 
							where  c.ДействуетС<=@month_ and b.[SRVidProdId]=@vp_ and c.SRInco2Value=@inco2 and c.SRincoValue='DAP' and c.SRCountryId=@country_ 
							group by c.SRVPGroupValue, c.SRCountryId, c.SRincoValue, c.SRInco2Value
							) d on a.Идентификатор=d.id_
		end;

	if exists(select * from DBSRCurrency where Идентификатор=@currency_ and [Код валюты]='USD')
	begin
		set @Result=@USDPrice
	end
	else
	begin
		set @Result=@EURPrice
	end
	
	-- Return the result of the function
	RETURN @Result

END
GO

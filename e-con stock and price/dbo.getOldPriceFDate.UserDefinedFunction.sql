USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getOldPriceFDate]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 
-- Description:	получить рассчитанную дату
-- =============================================
CREATE FUNCTION [dbo].[getOldPriceFDate] 
(
	-- Add the parameters for the function here
	@OZM nvarchar(50),
	@date_ datetime,
	@stock int
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result money=0
	declare @datePrice date=NULL
	declare @obd_ int=0
	declare @discount money=convert(money,round(isnull((select [e-con stock and price].[dbo].getdiscountfdate(@ozm, @date_, @stock)),0),0))

	Select @datePrice=min(startDate)
	From
		(Select distinct top 2
			startDate, orderByDay
		From [e-con stock and price].[dbo].[allPrices]
		where ozm=@OZM and startDate <= @date_ and ecstock=@stock
		order by startDate desc, orderByDay desc) T1

	select @obd_=min(orderByDay)
	from
		(select distinct top 2
			orderByDay
		from [e-con stock and price].[dbo].[allPrices]
		where ozm=@OZM and startDate = @datePrice and ecstock=@stock
		order by orderByDay desc) as T2

	SELECT @Result =
			case
			when @discount>0 then convert(money,round(isnull((select [e-con stock and price].[dbo].getPriceFDate(@ozm, @date_, @stock)),0),0))+@discount
			else convert(money,round(isnull(price,0),0)) end
	from [e-con stock and price].[dbo].[allPrices]
	where ozm=@OZM and startDate=@datePrice and orderByDay=@obd_ and ecstock=@stock

	RETURN @Result

END
GO

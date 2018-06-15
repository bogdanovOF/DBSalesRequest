USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getPriceFDate]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 
-- Description:	получить рассчитанную дату
-- =============================================
CREATE FUNCTION [dbo].[getPriceFDate] 
(
	-- Add the parameters for the function here
	@OZM nvarchar(50),
	@date_ datetime,
	@stock int
)
RETURNS money
AS
BEGIN

	DECLARE @Result money=0
	declare @datePrice date=null
	declare @obd_ int=0
	declare @discount money=convert(money,round(isnull((select [e-con stock and price].[dbo].getdiscountfdate(@ozm, @date_, @stock)),0),0))

		 select @datePrice=max(startDate) from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate <= @date_ and ecstock=@stock

		 select @obd_=max(orderByDay) from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate = @datePrice and ecstock=@stock
	
		-- Add the T-SQL statements to compute the return value here
		SELECT @Result =
			case
				when @discount>0 then convert(money,round(isnull(price,0),0))-@discount
				else convert(money,round(isnull(price,0),0)) end
		 from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate=@datePrice and orderByDay=@obd_ and ecstock=@stock
	
	RETURN @Result

END
GO

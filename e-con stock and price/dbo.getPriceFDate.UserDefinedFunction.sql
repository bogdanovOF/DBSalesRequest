USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getPriceFDate]    Script Date: 25.06.2018 17:56:22 ******/
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

		 select @datePrice=max(startDate) from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate <= @date_ and ecstock=@stock

		 select @obd_=max(orderByDay) from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate = @datePrice and ecstock=@stock
	
		-- Add the T-SQL statements to compute the return value here
		SELECT @Result = convert(money,round(isnull(price,0),0))
		 from [e-con stock and price].[dbo].[allPrices]
		 where ozm=@OZM and startDate=@datePrice and orderByDay=@obd_ and ecstock=@stock
	
	RETURN @Result

END
GO

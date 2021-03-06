USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[frequencyUseOzm]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 17102017
-- Description:	количество заказов за последний год по указанному ОЗМ
-- =============================================
CREATE FUNCTION [dbo].[frequencyUseOzm]
(
	-- Add the parameters for the function here
	@ozmCode nvarchar(30)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int=0
	declare @sDate as date=convert(date,DATETIMEOFFSETFROMPARTS(year(DATEADD(day,-365,getdate())), month(DATEADD(day,-365,getdate())),1,5,0,0,0,0,0,0))
	declare @tDate as date=convert(date,getdate())

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result =(select count([торговый документ]) as ecrank from (
						select distinct [торговый документ] from (
						select [торговый документ] from SAP_REP.dbo.zuni_sd_br_2016
							where [Дата цены] between @sDate and @tDate and Материал=@ozmCode
						union all
						select [торговый документ] from SAP_REP.dbo.zuni_sd_br_2017
							where [Дата цены] between @sDate and @tDate and Материал=@ozmCode
						union all
						select [торговый документ] from  [NLMK_SORT].[dbo].[NLMK_SORT_BR]
							where [Дата цены] between @sDate and @tDate and Материал=@ozmCode
						) as b) as a )

	-- Return the result of the function
	RETURN @Result

END
GO

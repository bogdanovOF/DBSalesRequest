USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getStockfDate]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 
-- Description:	запас на складе на дату по материалу
-- =============================================
CREATE FUNCTION [dbo].[getStockfDate] 
(
	-- Add the parameters for the function here
	@OZM nvarchar(50),
	@date_ as date,
	@stock_ as nvarchar(50)
)
RETURNS numeric(15,2)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result numeric(15,2)=0
	declare @ozm1 nvarchar(50)=null

	if (select top 1 EC from MDSDB.mdm.OZMOfProducts where code = @ozm)=0
	begin
		select @ozm1=equivalent from MDSDB.mdm.equivalentsOZM where OZM=@OZM
	end

	if (@ozm1 is null)
	begin
		-- Add the T-SQL statements to compute the return value here
		SELECT @Result =volume from [e-con stock and price].dbo.stocksFDate where [stock]=@stock_ and [OZM]=@OZM
		 and [stage_date]=(select max([stage_date]) from [e-con stock and price].dbo.stocksFDate where [stock]=@stock_ and [OZM]=@OZM and
		-- 15032018 договорились на конфе Глазков, я и Лиза
	 											  [stage_date]<=@date_)
	end
	else
	begin
		-- Add the T-SQL statements to compute the return value here
		SELECT @Result =sum(volume) from [e-con stock and price].dbo.stocksFDate where [stock]=@stock_ and ([OZM]=@OZM1 or [OZM]=@OZM)
		 and [stage_date]=(select max([stage_date]) from [e-con stock and price].dbo.stocksFDate where [stock]=@stock_ and ([OZM]=@OZM1 or [OZM]=@OZM)  and
		-- 15032018 договорились на конфе Глазков, я и Лиза
	 											  [stage_date]<=@date_)
	end

	-- Return the result of the function
	RETURN @Result

END
GO

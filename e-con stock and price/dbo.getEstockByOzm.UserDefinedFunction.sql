USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getEstockByOzm]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 26102017
-- Description:	получить ид склада по озм
-- =============================================
CREATE FUNCTION [dbo].[getEstockByOzm] 
(
	-- Add the parameters for the function here
	@OZM nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 1 @Result = b.ecgrp
		FROM [MDSDB].[mdm].[AuspOfProducts] as a inner join (
		SELECT distinct 
			[Name]
			,[ecgrp]
		FROM [MDSDB].[mdm].[StocksOfProducts]) as b on a.[Значение признака]=b.Name
		 where a.Признак=N'EC_site' and a.Материал_Code=@OZM
		 
	-- Return the result of the function
	RETURN @Result

END
GO

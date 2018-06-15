SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov_oleg
-- Create date: 12062016
-- Description:	get divisions code by vkorg and customers by dictionary
-- =============================================
ALTER FUNCTION [dbo].[getDeptByCustomer]
(
	-- Add the parameters for the function here
	@customer nvarchar(11) null,
	@be nvarchar(4) null
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @divCode int

	-- Add the T-SQL statements to compute the return value here
	SELECT @divCode=DIVISIONS_CODE from [SAPBWIntergation].[SAPBW].[DictAccDopAndOwners] where CUSTOMER=@customer and VKORG=@be

	-- Return the result of the function
	RETURN @divCode

END
GO

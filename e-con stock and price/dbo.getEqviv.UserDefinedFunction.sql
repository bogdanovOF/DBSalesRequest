USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getEqviv]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[getEqviv]
(
	-- Add the parameters for the function here
	@OZM nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result_ as nvarchar(50)=null

	-- Add the T-SQL statements to compute the return value here
	SELECT @Result_=equivalent from MDSDB.mdm.equivalentsOZM where OZM=@OZM

	-- Return the result of the function
	RETURN @Result_

END
GO

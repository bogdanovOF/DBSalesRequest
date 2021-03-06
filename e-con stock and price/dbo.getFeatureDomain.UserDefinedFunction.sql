USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getFeatureDomain]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov oleg
-- Create date: 
-- Description:	get products fuature domain as json
-- =============================================
create FUNCTION [dbo].[getFeatureDomain] 
(
	-- Add the parameters for the function here
	@sCId1 int,
	@fName as nvarchar(30)
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result nvarchar(max)=(SELECT a.cawnid as CODE, a.CAWNVAL as NAME from MDSDB.[mdm].[CawnOfProducts] as a inner join
	MDSDB.mdm.FeaturesOfProducts as b on a.[feature_Code]=b.Code where a.[SubCategory_Code]=@sCId1 and b.[Код признака]=@fName for json auto)
	RETURN @Result

END
GO

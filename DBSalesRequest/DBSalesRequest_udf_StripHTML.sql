SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		bogdanov_of
-- Create date: 27032015
-- Description:	удаление html tags
-- =============================================
    ALTER FUNCTION [dbo].[udf_StripHTML] (@HTMLText nVARCHAR(MAX))
    RETURNS nVARCHAR(100) AS
    BEGIN
    	DECLARE @Start INT
    	DECLARE @End INT
    	DECLARE @Length INT
    	SET @Start = CHARINDEX('<',@HTMLText)
    	SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
    	SET @Length = (@End - @Start) + 1
    	WHILE @Start > 0 AND @End > 0 AND @Length > 0
    	BEGIN
    		SET @HTMLText = STUFF(@HTMLText,@Start,@Length,'')
    		SET @Start = CHARINDEX('<',@HTMLText)
    		SET @End = CHARINDEX('>',@HTMLText,CHARINDEX('<',@HTMLText))
    		SET @Length = (@End - @Start) + 1
    	END
    	RETURN isnull(LTRIM(RTRIM(replace(replace(replace(@HTMLText,' ?',''),'&quot;',''),'&#160;',''))),'')
    END
GO

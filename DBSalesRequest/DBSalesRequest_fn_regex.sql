SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [dbo].[fn_regex](@pattern varchar(255), @matchstring varchar(8000))
RETURNS int
AS
BEGIN
       declare @obj int
       declare @res int
       declare @match bit

       set @match=0
       exec @res=sp_OACreate 'VBScript.RegExp' ,@obj OUT
	   
       IF (@res <> 0)
	    BEGIN
			RETURN NULL
		END
		
       exec @res=sp_OASetProperty @obj, 'Pattern', @pattern


       IF (@res <> 0)
	    BEGIN
			RETURN NULL
		END

		exec @res=sp_OASetProperty @obj, 'IgnoreCase', 1


       IF (@res <> 0)
	    BEGIN
			RETURN NULL
		END

		exec @res=sp_OAMethod @obj, 'Test' ,@match OUT, @matchstring

		IF (@res <> 0)
	    BEGIN
			RETURN NULL
		END
		

       exec @res=sp_OADestroy @obj


       return @match


END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
 ALTER function [dbo].[cUserFirms]
(	
	-- Add the parameters for the function here
	@UserName nvarchar(100),
	@cCode_ nvarchar(max) null
)
RETURNS @RezTable table (
	cCode nvarchar(10) null, cName nvarchar(max) null 
)
as
begin
	set @UserName=replace(@UserName,'AONLMK\','')

	if @Username=N'bogdanov_of' set @Username  = N'vasilenko_vv'

	declare @UserLNN as nvarchar(max) = (select [фамилия]+' '+[имя] from DBSalesRequest.dbo.DBSRUsers where [имяпользователя]= @Username)
	
	if (@cCode_ is null)
	begin
		insert into @RezTable
		SELECT distinct [CustomerCode]
			  ,[CustomerName]
		  FROM [DBSalesRequest].[dbo].ctUserFirms where [FO1] = @UserLNN or [FO2] = @UserLNN or [FO3] = @UserLNN
	end
	begin
		insert into @RezTable
		SELECT distinct [CustomerCode]
			  ,[CustomerName]
		  FROM [DBSalesRequest].[dbo].ctUserFirms where [CustomerCode] = @cCode_
	end

	return
end
GO

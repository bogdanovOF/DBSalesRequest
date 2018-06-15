SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER FUNCTION [dbo].[getOnlyFirmsByDept]
(	
	@CustomerCode nvarchar(10) null
)
RETURNS @rezTable TABLE (
	[CustomerCode] [nvarchar](10) NULL,
	[CustomerName] [nvarchar](100) NULL,
	[Status] [nvarchar](50) NULL,
	[Segm1] [nvarchar](50) NULL,
	[Country_Name] [nvarchar](100) NULL
)
AS
Begin
	if (@CustomerCode is null)
	Begin
	 insert into @rezTable ([CustomerCode], [CustomerName], [Status], [Segm1], [Country_Name])
	 select distinct left([CustomerCode],10), left([CustomerName],100), [Status], [Segm1], left([Country_Name],100) from [DBSalesRequest].[dbo].[ctUserFirms]
	end
	else
	Begin
	 insert into @rezTable ([CustomerCode], [CustomerName], [Status], [Segm1], [Country_Name])
	 select top 1 left([CustomerCode],10), left([CustomerName],100), [Status], [Segm1], left([Country_Name],100) from [DBSalesRequest].[dbo].[ctUserFirms] where left([CustomerCode],10)=left(@CustomerCode,10)
	end

RETURN 
End


GO

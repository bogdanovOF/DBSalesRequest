USE [DBSalesRequest]
GO
/****** Object:  StoredProcedure [dbo].[make4packets]    Script Date: 15.06.2018 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[make4packets] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	EXECUTE [dbo].[vygruzka_allactual_PRM] 1
	EXECUTE [dbo].[vygruzka_allactual_PRM] 2
	EXECUTE [dbo].[vygruzka_allactual_PRM] 3
	EXECUTE [dbo].[vygruzka_allactual_PRM] 4
END
GO

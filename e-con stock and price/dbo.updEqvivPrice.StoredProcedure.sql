USE [e-con stock and price]
GO
/****** Object:  StoredProcedure [dbo].[updEqvivPrice]    Script Date: 15.06.2018 14:09:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[updEqvivPrice] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- все позиции из цен EC=0
	select distinct c.equivalent from dbo.allPrices as a inner join mdsdb.mdm.OZMOfProducts as b
		on a.ozm=b.Code collate Cyrillic_General_100_CI_AS
		inner join MDSDB.mdm.equivalentsOZM as c
		on b.Code=c.OZM
	
END
GO

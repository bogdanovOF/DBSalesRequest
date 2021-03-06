USE [DBSalesRequest]
GO
/****** Object:  StoredProcedure [dbo].[DBSRRecalcRequestVolume]    Script Date: 15.06.2018 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Oleg Bogdanov
-- Create date: 06042015
-- Description:	расчет суммарного объема по согласованным заявкам по виду продукции по конкреному месяцу
-- =============================================
CREATE PROCEDURE [dbo].[DBSRRecalcRequestVolume] 
	-- Add the parameters for the stored procedure here
	-- месяц поставки
	@month_ int,
	-- год поставки
	@year_	int,
	-- вид продукции
	@vp_ int,
	-- валюта
	@currency_ int,
	@Result float output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	set @Result=0.0

	if (@currency_=147)
	begin
	SELECT @result = round(SUM(isnull(a.[ПодтвержденныйОбъем],0))/1000,2) from [dbo].[DBSRZayavki] as a inner join 
	(SELECT Идентификатор AS ind_, MAX(Изменено) AS dt_
            FROM dbo.DBSRZayavki
				where not Изменено is null
                 GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
	where a.ВидПродукцииId=@vp_ and a.МесяцПоставки=DATEFROMPARTS(@year_,@month_,1) and a.ВалютаId=@currency_ and a.состояниезаявкиvalue = 'Согласовано'
	end
	else
	begin
		SELECT @result = round(SUM(isnull(a.[ПодтвержденныйОбъем],0))/1000,2) from [dbo].[DBSRZayavki] as a inner join 
	(SELECT Идентификатор AS ind_, MAX(Изменено) AS dt_
            FROM dbo.DBSRZayavki
				where not Изменено is null
                 GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
	where a.ВидПродукцииId=@vp_ and a.МесяцПоставки=DATEFROMPARTS(@year_,@month_,1) and a.ВалютаId<>147 and a.состояниезаявкиvalue = 'Согласовано'
	end

	Select @Result=ISNULL(@result,0)
END
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 03112015
-- Description:	vigruzka dly fo
-- =============================================
ALTER FUNCTION [dbo].[NLMKAnalitikCRMdata] 
(	
	-- Add the parameters for the function here
	@UserName nvarchar(100),
	@id_ int null
)
RETURNS @RezTable table (
	ReqId int,
	ReqMonth date null,
	ReqCustomer nvarchar(12) null,
	ReqContract nvarchar(30) null,
	VidProd int null,
	VidProdName nvarchar(50),
	VidPostav nvarchar(20),
	SpecVolume float null,
	OrderVolume float null,
	ShipVolume float null
	)
AS

begin
	-- удалить AONLMK\ если есть
	set @UserName=replace(@UserName,'AONLMK\','')
	if (@UserName=N'bogdanov_of') set @UserName=N'gerasimova_ma'
	--if (@UserName=N'dyrdin_nv') set @UserName=N'vasilenko_vv'
    -- это пользователь или директор: 0-нет пользователя, 1-фронт, 2-директор
	declare @UsrType as int=0
	if exists(select b.EmployeeId from [DBSalesRequest].[dbo].[DBSRUsers] as a inner join [DBSalesRequest].[dbo].[DBSROrgStruct] as b
	on a.Идентификатор=b.chiefid
	where a.ИмяПользователя=@UserName)
	begin
		set @UsrType=2
	end
	else
	if (not @UserName is null)
	begin
		set @UsrType=1
	end;


	if (@UsrType=1)
	begin
		insert into @RezTable (
			ReqId, ReqMonth, ReqCustomer, ReqContract, VidProd, vidpostav)
		select
			Идентификатор,
			DATEADD(MONTH, datediff(MONTH ,0,МесяцПоставки) , 0 ),
			ДебиторКод,
			Договор,
			ВидПродукцииId,
			ВидПоставкиValue
		from [DBSalesRequest].dbo.DBSRZayavki as a INNER JOIN
            (SELECT Идентификатор AS ind_, MAX(Изменено) AS dt_
            FROM dbo.DBSRZayavki
            GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
		where ФронтОфицерId in (select b.EmployeeId from [DBSalesRequest].[dbo].[DBSRUsers] as a inner join [DBSalesRequest].[dbo].[DBSROrgStruct] as b
								on a.Идентификатор=b.EmployeeId where a.ИмяПользователя= @UserName)
								and a.состояниезаявкиvalue not in ( 'Черновик', 'Draft') and a.isdeleted <> 1 and not ДебиторКод is null and not ДебиторКод like N'%99999%'
	end
	else
	if (@UsrType=2)
	begin
		insert into @RezTable (
			ReqId, ReqMonth, ReqCustomer, ReqContract, VidProd,VidPostav)
		select
			Идентификатор,
			DATEADD(MONTH, datediff(MONTH ,0,МесяцПоставки) , 0 ),
			ДебиторКод,
			Договор,
			ВидПродукцииId,
			ВидПоставкиValue
		from [DBSalesRequest].dbo.DBSRZayavki as a INNER JOIN
            (SELECT Идентификатор AS ind_, MAX(Изменено) AS dt_
            FROM dbo.DBSRZayavki
            GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
		where ФронтОфицерId in (select b.EmployeeId from [DBSalesRequest].[dbo].[DBSRUsers] as a inner join [DBSalesRequest].[dbo].[DBSROrgStruct] as b
								on a.Идентификатор=b.chiefid where a.ИмяПользователя= @UserName)
								and a.состояниезаявкиvalue not in ( 'Черновик', 'Draft') and a.isdeleted <> 1 and not ДебиторКод is null and not ДебиторКод like N'%99999%'
	end


	update  @RezTable set OrderVolume=c.planvolume, ShipVolume=c.factvolume from @RezTable as a
	left outer join (
					select 	RMName,
							Customer,
							Contract,
							VidProd,
							Vidpostav,
							sum(OrderVol) as planvolume,
							sum(ShipVol) as factvolume
					from [DBSalesRequest].dbo.CRMSpeOrdShipFact
					--from [DBSalesRequest].[dbo].[crmdatacolumnstore]
					group by RMName,
							Customer,
							Contract,
							VidProd,
							Vidpostav
		) as c
	on (a.ReqContract=c.Contract collate Cyrillic_General_100_CI_AS
	 and a.ReqCustomer=c.Customer collate Cyrillic_General_100_CI_AS
	 and a.vidprod = c.vidprod
	 and a.vidpostav = c.vidpostav
	 and format(a.ReqMonth,'yyyyMM','ru-RU') = c.RMname)

	 update @RezTable set VidProdName=b.[вид продукции] from @RezTable as a inner join [DBSalesRequest].[dbo].[DBSRVidprod] as b
	 on a.VidProd=b.Идентификатор

	 delete from @RezTable 
	 where SpecVolume is null and ShipVolume is null and OrderVolume is null

	 if (not @id_ is null)
	 delete from @RezTable 
	 where not(ReqId = @id_)

	return 
end



GO

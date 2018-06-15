SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bogdanov Oleg
-- Create date: 08082016
-- Description:	Raschet obyemov po spec&orders from CRM
-- =============================================
ALTER PROCEDURE [dbo].[SpecAndOrders] 
	-- Add the parameters for the stored procedure here
	@UserName nvarchar(max) = null 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

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
	end

	-- создаем результирующую таблицу
	declare @RezTable as table (
	ReqId int,
	ReqMonth date null,
	ReqCustomer nvarchar(12) null,
	ReqContract nvarchar(30) null,
	VidProd int null,
	SpecVolume float null,
	OrderVolume float null,
	ShipVolume float null
	)

	if (@UsrType=1)
	begin
		insert into @RezTable (
			ReqId, ReqMonth, ReqCustomer, ReqContract, VidProd)
		select
			Идентификатор,
			DATEADD(MONTH, datediff(MONTH ,0,МесяцПоставки) , 0 ),
			ДебиторКод,
			Договор,
			ВидПродукцииId
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
			ReqId, ReqMonth, ReqCustomer, ReqContract, VidProd)
		select
			Идентификатор,
			DATEADD(MONTH, datediff(MONTH ,0,МесяцПоставки) , 0 ),
			ДебиторКод,
			Договор,
			ВидПродукцииId
		from [DBSalesRequest].dbo.DBSRZayavki as a INNER JOIN
            (SELECT Идентификатор AS ind_, MAX(Изменено) AS dt_
            FROM dbo.DBSRZayavki
            GROUP BY Идентификатор) AS d ON a.Идентификатор = d.ind_ AND a.Изменено = d.dt_
		where ФронтОфицерId in (select b.EmployeeId from [DBSalesRequest].[dbo].[DBSRUsers] as a inner join [DBSalesRequest].[dbo].[DBSROrgStruct] as b
								on a.Идентификатор=b.chiefid where a.ИмяПользователя= @UserName)
								and a.состояниезаявкиvalue not in ( 'Черновик', 'Draft') and a.isdeleted <> 1 and not ДебиторКод is null and not ДебиторКод like N'%99999%'
	end

	select 	RMName,
			Customer,
			Contract,
			VidProd,
			sum(OrderVol) as planvolume,
			sum(ShipVol) as factvolume
	into #CalcOrdersTableAgr
	from [DBSalesRequest].dbo.CRMSpeOrdShipFact
	group by RMName,
			Customer,
			Contract,
			VidProd



	update  @RezTable set OrderVolume=c.planvolume, ShipVolume=c.factvolume from @RezTable as a
	left outer join #CalcOrdersTableAgr as c
	on (a.ReqContract=c.Contract collate Cyrillic_General_100_CI_AS
	 and a.ReqCustomer=c.Customer collate Cyrillic_General_100_CI_AS
	 and a.vidprod = c.vidprod 
	 and format(a.ReqMonth,'yyyyMM','ru-RU') = c.RMname)

	 select ReqId, ReqMonth, ReqCustomer, ReqContract, VidProd, SpecVolume, OrderVolume, ShipVolume from @RezTable 
	 where not SpecVolume is null or not ShipVolume is null or not OrderVolume is null

END
GO

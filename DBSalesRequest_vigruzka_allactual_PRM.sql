SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER procedure [dbo].[vygruzka_allactual_PRM]
(
	-- 
	@Pck_type int null
)
AS

declare @CMonth as date=convert(date,DATETIMEOFFSETFROMPARTS(year(DATEADD(day,30,getdate())), month(DATEADD(day,30,getdate())),1,5,0,0,0,0,0,0))
--declare @pknum as nvarchar(15)=(select right(replicate('0',15)+convert(nvarchar(max),max(convert(int,[PACK_NUM]))+1),15) from [QASWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS])
declare @pknum as nvarchar(15)=
(select right(replicate('0',15)+
convert(nvarchar(max),isnull(max(convert(int,convert(nvarchar(20),([PACK_NUM]))))+1,1)),15)
 from [PRDWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS])

declare @PRMTable as table(
[INQID] [nvarchar](22) null,
[PACK_NUM] [nvarchar](15) null,
[STATUS] [nvarchar](20) null default '-',
[PROD_TYPE] [nvarchar](18) null,
[DISCH] [nvarchar](3) null,
[COUNTRY] [nvarchar](3) null,
[REGION] [nvarchar](3) null,
[CUSTOMER] [nvarchar](10) null,
[KeyAcc] [nvarchar](1) null,
[INCO1] [nvarchar](3) null,
[INCO2] [nvarchar](28) null,
[CUS_SEGM] [nvarchar](3) null,
[SALESORG] [nvarchar](4) null,
[CALMONTH] [nvarchar](6) null,
[CHANGE_DATE] [date] null,
[PROCESSED] [nvarchar](1) null default '',
[TYPE_OF_CUTTING] [nvarchar](11) null,
[REQ_VOLUME] [float] null,
[ANNUAL_PLAN] [float] null,
[APPROVED_VOLUME] [float] null,
[MIN_GAR_VOLUME] [float] null,
[MARKETING_VOLUME] [float] null
);

-- сначал вставим строки, которые не требуют разбиения, где вид продукции 1=1
with AccDop_cte (Code,NamePlanning_ID,Сегмент_Code)
as
(
select
 a.[Код дебитора SAP_Code] as Code,
 NamePlanning_ID,
 Сегмент_Code
 from MDSDB.mdm.AccDop  as a inner join 
		(select [Код дебитора SAP_Code], max(DateStart) as ds_ from MDSDB.mdm.AccDop group by [Код дебитора SAP_Code]) as c
			on a.[Код дебитора SAP_Code]=c.[Код дебитора SAP_Code] and DateStart=c.ds_
)
insert into @PRMTable ([INQID],[PACK_NUM], [STATUS], [PROD_TYPE], [DISCH], [COUNTRY],[REGION], [CUSTOMER], [KeyAcc], [INCO1], [INCO2],[CUS_SEGM],[SALESORG],
 [CALMONTH], [CHANGE_DATE], [TYPE_OF_CUTTING], [REQ_VOLUME], [ANNUAL_PLAN], [APPROVED_VOLUME], [MIN_GAR_VOLUME], [MARKETING_VOLUME])
	   SELECT 
	   [INQID]=case 
			   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 and g.kmat=N'WCR_0104131' then '100'+convert(nvarchar(12),a.[идентификатор])
			   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 and g.kmat<>N'WCR_0104131' then '200'+convert(nvarchar(12),a.[идентификатор])
			   else a.[идентификатор] end,
	   [PACK_NUM]=@pknum,
	   [STATUS]=a.[Статус заявки],
	   [PROD_TYPE]=case 
				   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 then isnull(g.kmat,N'WCR_0104131')
				   else left('W'+b.[Kmat],18) end,
	   [DISCH]=case 
			   when e.Страна_Code in (select Страна_Code from mdsdb.mdm.UnionsOfCountries) and not e.Страна_Code=N'RU' then '03'
			   when e.Страна_Code=N'RU' or e.Страна_Code is null then '02' end,
	   [COUNTRY]=isnull(e.Страна_Code,'RU'),
	   [REGION]=e.Region_Code,
	   [CUSTOMER]=left(isnull(e.[Code],'9999999997'),10),
	   [KeyAcc]=case when c.NamePlanning_ID=1 then 1 else 0 end,
	   [INCO1]=a.[Инкотермс],
	   [INCO2]=case
			   when a.[Имя и Фамилия руководителя]=N'Анисимов Сергей Анатольевич' or a.[Имя и Фамилия руководителя]=N'Герасимова Марина Александровна'  then 'C002'
			   when a.[Имя и Фамилия руководителя]=N'Хорн Сергей Олегович' then 'C001'
			   when a.[Имя и Фамилия руководителя]=N'Овчинников Владислав Александрович' then 'C003' end,
	   [CUS_SEGM]=isnull(d.Сегмент1_Code,16),
	   [SALESORG]=f.Площадка,
	   [CALMONTH]=format(a.[Плановый месяц],'yyyyMM','ru-RU'),
	   [CHANGE_DATE]=getdate(),
	   [TYPE_OF_CUTTING]=case 
						   when a.[Вид поставки]=N'лист' then 'ЛСТ'
						   when a.[Вид поставки] = N'рулон' then 'РЛН'
						   when a.[Вид поставки] = N'лента' then 'ЛНТ'
						   when a.[Вид поставки] = N'рулон с роспуском' then 'РЛН РСП'
                           WHEN a.[Вид поставки] = N'рулон с роспуском/лента' then 'РС/ЛН'
						   else '' end,
	   -- заявленный объем ВР
	   [REQ_VOLUME]=case 
					   when @Pck_type=1 then round(isnull(a.[Заявленный объем без МГО],0)*isnull(g.kZn,1),2)
					   when @Pck_type=2 then round(isnull(a.[Всего заявлено],0)*isnull(g.kZn,1),2)
					   when @Pck_type=3 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999998'),10), f.Площадка))=9
						then round(isnull(a.[Заявленный объем без МГО],0)*isnull(g.kZn,1),2)
					   when @Pck_type=3 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999998'),10), f.Площадка))<>9
						then round(isnull(a.[Всего заявлено],0)*isnull(g.kZn,1),2)
					   when @Pck_type=4 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999997'),10), f.Площадка))=8
						then round(isnull(a.[Заявленный объем без МГО],0)*isnull(g.kZn,1),2)
					   when @Pck_type=4 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999997'),10), f.Площадка))<>8
						then round(isnull(a.[Всего заявлено],0)*isnull(g.kZn,1),2) end,
	   [ANNUAL_PLAN]=round(isnull(a.[Годовой план],0)*isnull(g.kZn,1),2),
	  -- подтвержденный объем ВР
  	   [APPROVED_VOLUME]=case 
						   when @Pck_type=1 then round(isnull(a.[Подтвержденный объем],0)*isnull(g.kZn,1),2)
						   when @Pck_type in (2,3,4) then 0 end,
	  -- МГО ВР
	   [MIN_GAR_VOLUME]=case 
						when @Pck_type=1 then round((isnull(a.[МГО.Длинные],0)+isnull(a.[МГО.Проданные],0))*isnull(g.kZn,1),2)
						when @Pck_type=2 then 0
						when @Pck_type=3 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999998'),10), f.Площадка))=9 then round((isnull(a.[МГО.Длинные],0)+isnull(a.[МГО.Проданные],0))*isnull(g.kZn,1),2)
						when @Pck_type=3 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999998'),10), f.Площадка))<>9 then 0
						when @Pck_type=4 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999997'),10), f.Площадка))=8 then round((isnull(a.[МГО.Длинные],0)+isnull(a.[МГО.Проданные],0))*isnull(g.kZn,1),2)
						when @Pck_type=4 and (select dbo.getDeptByCustomer(left(isnull(e.[Code],'9999999997'),10), f.Площадка))<>8 then 0 end,
	   [MARKETING_VOLUME]=a.[КПЭ]
  FROM [dbo].[vygruzka_allactual] as a left outer join dbo.kmatvpconvert as b on a.[ВидПродукцииId]=b.VidProdZayavkiId
  left outer join AccDop_cte AS c on a.[Код клиента]=c.[Code] collate Cyrillic_General_100_CI_AS
  LEFT OUTER JOIN MDSDB.mdm.Segments AS d ON c.Сегмент_Code = d.Code
  left outer join MDSDB.mdm.CustomersAll as e on a.[Код клиента]=e.Code collate Cyrillic_General_100_CI_AS
  left outer join [DBSalesRequest].[dbo].[DBSRBEList] as f on a.[площадка]=f.BE collate Cyrillic_General_100_CI_AS
  left outer join [dbo].[kZnXview] as g on (left(isnull(e.[Code],'9999999997'),10)=g.customer collate Cyrillic_General_100_CI_AS
   and N'WCR_0104131'=left('W'+b.[Kmat],18) collate Cyrillic_General_100_CI_AS and a.[видпродукцииid]=8)
  where  a.[Плановый месяц]>=@CMonth and Валюта='RUB' and  f.Площадка in (N'1010',N'1020') and [Статус заявки]<>N'Отклонено';

with AccDop_cte (Code,NamePlanning_ID,Сегмент_Code)
as
(
select
 a.[Код дебитора SAP_Code] as Code,
 NamePlanning_ID,
 Сегмент_Code
 from MDSDB.mdm.AccDop  as a inner join 
		(select [Код дебитора SAP_Code], max(DateStart) as ds_ from MDSDB.mdm.AccDop group by [Код дебитора SAP_Code]) as c
			on a.[Код дебитора SAP_Code]=c.[Код дебитора SAP_Code] and DateStart=c.ds_
)
insert into @PRMTable ([INQID], [PACK_NUM], [STATUS], [PROD_TYPE], [DISCH], [COUNTRY],[REGION], [CUSTOMER], [KeyAcc],  [INCO1],[INCO2],
 [CUS_SEGM],[SALESORG], [CALMONTH], [CHANGE_DATE], [TYPE_OF_CUTTING], [REQ_VOLUME], [ANNUAL_PLAN], [MIN_GAR_VOLUME], [APPROVED_VOLUME], [MARKETING_VOLUME])
SELECT case 
	   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 and g.kmat=N'WCR_0104131' then '100'+convert(nvarchar(12),a.[идентификатор])
	   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 and g.kmat<>N'WCR_0104131' then '200'+convert(nvarchar(12),a.[идентификатор])
	   else a.[идентификатор] end,
	   @pknum,
	   a.[Статус заявки],
	   case 
	   when left('W'+b.[Kmat],18)=N'WCR_0104131' and a.[видпродукцииid]=8 then g.kmat
	   else left('W'+b.[Kmat],18) end,
	   '01',
	   case
	   when a.[СтранаНазначенияЭкспорт] is null then e.Страна_Code
	   else a.[СтранаНазначенияЭкспорт] end,
	   e.Region_Code,
	   left(isnull(e.[Code],'9999999999'),10),
	   case when c.NamePlanning_ID=1 then 1 else 0 end,
	   [Инкотермс],
	   case
			   when a.[Имя и Фамилия руководителя]=N'Анисимов Сергей Анатольевич' or a.[Имя и Фамилия руководителя]=N'Герасимова Марина Александровна'  then 'C002'
			   when a.[Имя и Фамилия руководителя]=N'Хорн Сергей Олегович' then 'C001'
			   when a.[Имя и Фамилия руководителя]=N'Овчинников Владислав Александрович' then 'C003' end,
	   d.Сегмент1_Code,
	   f.Площадка,
	   format([Плановый месяц],'yyyyMM','ru-RU'),
	   getdate(),
	   case 
	   when a.[Вид поставки]=N'лист' then 'ЛСТ'
	   when a.[Вид поставки] = N'рулон' then 'РЛН'
	   when a.[Вид поставки] = N'лента' then 'ЛНТ'
	   when a.[Вид поставки] = N'рулон с роспуском' then 'РЛН РСП'
       WHEN a.[Вид поставки] = N'рулон с роспуском/лента' then 'РС/ЛН'
	   else '' end,
	   -- заявленный объем Экспорт
	   case 
		   when @Pck_type=1 then round(isnull(a.[Заявленный объем без МГО],0)*isnull(g.kZn,1),2)
		   when @Pck_type in (2,3,4) then 0
       end
      ,isnull(a.[Годовой план],0)
	  ,
	  -- МГО Экспорт
	case 
		when @Pck_type in (1,2) then round((isnull(a.[МГО.Длинные],0)+isnull(a.[МГО.Проданные],0))*isnull(g.kZn,1),2)
		when @Pck_type in (3,4) then 0
	end,
	-- заявленный объем Экспорт (копируется в approved_volume правка 12092017 - по требованию Максима)
	case 
        when @Pck_type in (1,2) then round(isnull(a.[Заявленный объем без МГО],0)*isnull(g.kZn,1),2)
        when @Pck_type in (3,4) then round(isnull(a.[Всего заявлено],0)*isnull(g.kZn,1),2)
    end
	  -- подтвержденный объем Экспорт
	,round(isnull(a.[Подтвержденный объем],0)*isnull(g.kZn,1),2)
	FROM [dbo].[vygruzka_allactual] as a left outer join dbo.kmatvpconvert as b on a.[ВидПродукцииId]=b.VidProdZayavkiId
  left outer join AccDop_cte AS c on a.[Код клиента]=c.[Code] collate Cyrillic_General_100_CI_AS
  LEFT OUTER JOIN MDSDB.mdm.Segments AS d ON c.Сегмент_Code = d.Code
  left outer join MDSDB.mdm.CustomersAll as e on a.[Код клиента]=e.Code collate Cyrillic_General_100_CI_AS
  left outer join [DBSalesRequest].[dbo].[DBSRBEList] as f on a.[площадка]=f.BE collate Cyrillic_General_100_CI_AS
  left outer join [dbo].[kZnXview] as g on (left(isnull(e.[Code],'9999999999'),10)=g.customer collate Cyrillic_General_100_CI_AS
   and N'WCR_0104131'=left('W'+b.[Kmat],18) collate Cyrillic_General_100_CI_AS and a.[видпродукцииid]=8)
  where a.[Плановый месяц]>=@CMonth and f.Площадка in (N'1010',N'1020') and [Статус заявки]<>N'Отклонено' and not a.[идентификатор] in (select case
	when len([INQID])>7 and left([INQID],3) in ('100','200') then right([INQID],len([INQID])-3) else [INQID] end from @PRMTable) 

  update @PRMTable set [PROD_TYPE]=N'WCR_0204210' where [PROD_TYPE]=N'WCR_0104210' and [SALESORG]=N'1020'
 
 --   select [INQID],
	--	[PACK_NUM],
	--	[STATUS],
	--	[PROD_TYPE],
	--	[DISCH],
	--	[COUNTRY],
	--	[REGION],
	--	[CUSTOMER],
	--	[KeyAcc],
	--	[INCO1],
	--	[INCO2],
	--	[CUS_SEGM],
	--	[SALESORG],
	--	[CALMONTH],
	--	[CHANGE_DATE],
	--	[PROCESSED],
	--	[TYPE_OF_CUTTING],
	--	[REQ_VOLUME],
	--	[ANNUAL_PLAN],
	--	[APPROVED_VOLUME], 0, [MIN_GAR_VOLUME]
	--from @PRMTable 

 delete from [PRDWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] where [PACK_NUM]=@pknum

 ----delete from [QASWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] where [PACK_NUM]=@pknum

  INSERT INTO [PRDWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] (
  --INSERT INTO [QASWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] (
		[INQID],
		[PACK_NUM],
		[STATUS],
		[PROD_TYPE],
		[DISCH],
		[COUNTRY],
		[REGION],
		[CUSTOMER],
		[KeyAcc],
		[INCO1],
		[INCO2],
		[CUS_SEGM],
		[SALESORG],
		[CALMONTH],
		[CHANGE_DATE],
		[PROCESSED],
		[TYPE_OF_CUTTING],
		[REQ_VOLUME],
		[ANNUAL_PLAN],
		[APPROVED_VOLUME],
		[MIN_GAR_VOLUME], [MARKETING_VOLUME])
   select [INQID],
		[PACK_NUM],
		[STATUS],
		[PROD_TYPE],
		[DISCH],
		[COUNTRY],
		[REGION],
		[CUSTOMER],
		[KeyAcc],
		[INCO1],
		[INCO2],
		[CUS_SEGM],
		[SALESORG],
		[CALMONTH],
		[CHANGE_DATE],
		[PROCESSED],
		[TYPE_OF_CUTTING],
		[REQ_VOLUME],
		[ANNUAL_PLAN],
		[APPROVED_VOLUME], [MIN_GAR_VOLUME], isnull([MARKETING_VOLUME],0)
	from @PRMTable 

 select * from [PRDWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] where [PACK_NUM]=@pknum
 --select * from [QASWSPI]..[PI_PLANNING].[PI_SALES_REQUISITIONS] where [PACK_NUM]=@pknum




GO

/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use [e-con stock and price]
go

alter procedure getCostOfMaterialByPrice

@priceCode as nvarchar(30)=1,
@OZM as nvarchar(30)=N'',
@jsonOtherParam as nvarchar(max) null,
@jsonRaschet as nvarchar(max)=N'' out,
@mRezultSum as money=0 out

as
set nocount on;

declare @sC as nvarchar(30)=(select top 1 SubCategory_Code from [MDSDB].mdm.[OZMOfProducts] where Code=@OZM)
--declare @EC_MAKROREG as nvarchar(30)=N'Москва'
--declare @EC_INCO1 as nvarchar(30)=N'СРТ'
-- таблица параметров объекта расценки
declare @mValues as table (code nvarchar(30), cValue nvarchar(100), nVal1 numeric(15,2), nVal2 numeric(15,2))
-- таблица выбранных условий, которые участвуют в расценке
declare @ruleSuccess as table (rCode nvarchar(30), iresult int, sumType nvarchar(30), mvalue int, ruleDate date)

declare @ruleCode as nvarchar(30)=''
declare @featureCode as nvarchar(30)=''
declare @iResult as int=0
declare @nVal as int=0
declare @oldIResult as int=0
declare @m0Value as money=0
declare @m1Value as money=0

-- таблица активных приплат и скидок - если iResult=1
insert into @ruleSuccess
SELECT [условие_Code]
	  , 2 as iResult
      ,[вид суммы_Code]
      ,[сумма]
      ,[дата с]
  FROM [MDSDB].[mdm].[ecpPriceItems] where [Прайс_Code]=@priceCode

-- признаки объекта расценки
insert into @mValues
SELECT 
      c.Code
      ,a.[Значение признака]
      ,a.[Со значения]
      ,a.[По значение]
  FROM [MDSDB].[mdm].[AuspOfProducts] as a
  inner join [MDSDB].[mdm].[FeaturesOfProducts] as c on c.[Код признака]=a.[признак]
   where [Материал_Code]=@OZM and c.Подкатегория_Code=@sC
   union all 
	select * from OPENJSON(@jsonOtherParam)
	with (
			code nvarchar(30) '$.code',
			cValue nvarchar(100) '$.cValue',
			nVal1 numeric(15,2) '$.nVal1',
			nVal2 numeric(15,2) '$.nVal2'
	)


declare cRules CURSOR for
select distinct Code, [Признак_Code] from
 (select top 100 percent a.[Code], a.[orderBy], b.[Признак_Code], b.[значение], b.[зн с], b.[зн по]
  from [MDSDB].mdm.[ecpPosOfPricing] as a
	inner join [MDSDB].[mdm].[ecpRules] as b 
		on a.code=b.[условие_Code]
		 where [Подкатегория_Code]=@sC order by a.[orderBy]) as a

open cRules

fetch next from cRules into @ruleCode, @featureCode

while @@FETCH_STATUS=0
begin

	select @nVal=0, @iResult=0
	print N'правило - '+@ruleCode
	print N'признак - '+@featureCode

	-- определение типа данных признака
	-- цифра
	if exists(select Code from [MDSDB].[mdm].[FeaturesOfProducts] where [Тип данных]=N'NUM' and [Подкатегория_Code]=@sC and [Code]=@featureCode)
	begin
		-- точная цифра а не диапазон
		if exists(select Code from @mValues where code=@featureCode and ((nVal2=0 and nVal1>0) or (nVal2>0 and nVal1=0)))
		begin
			select @nVal=
			case
				when exists(select Code from @mValues where code=@featureCode and (nVal2=0 and nVal1>0))
					then (select nVal1 from @mValues where code=@featureCode)
				else (select nVal2 from @mValues where code=@featureCode) end

			print N'точная цифра - '+convert(nvarchar(30),@nval)

			select @iResult=
			case
				when exists(select a.code from (select top 100 percent a.[Code], a.[orderBy], b.[Признак_Code], b.[значение], b.[зн с], b.[зн по]
					from [MDSDB].[mdm].[ecpPosOfPricing] as a inner join [MDSDB].[mdm].[ecpRules] as b
						on a.code=b.[условие_Code] where [Подкатегория_Code]=@sC order by a.[orderBy]) as a
							inner join @mValues as b
								on (a.Признак_Code collate Cyrillic_General_100_CI_AS =b.code and @nVal between a.[зн с] and a.[зн по])
									where a.[Признак_code]=@featureCode and a.Code=@ruleCode) then 1
					else 0 end
			print N'сыграло - '+convert(nvarchar(30),@iresult)
		end
		-- диапазон
		if exists(select Code from @mValues where code=@featureCode and nVal2>nVal1)
		begin

			print N'Диапазон'

			select @iResult=
			case
				when exists(select a.code from (select top 100 percent a.[Code], a.[orderBy], b.[Признак_Code], b.[значение], b.[зн с], b.[зн по]
					from [MDSDB].[mdm].[ecpPosOfPricing] as a inner join [MDSDB].[mdm].[ecpRules] as b
						on a.code=b.[условие_Code] where [Подкатегория_Code]=@sC order by a.[orderBy]) as a
							inner join @mValues as b
								on (a.Признак_Code collate Cyrillic_General_100_CI_AS =b.code and
									(b.nVal1 between a.[зн с] and a.[зн по]
										or b.nVal2 between a.[зн с] and a.[зн по]))
									where a.[Признак_code]=@featureCode and a.Code=@ruleCode) then 1
					else 0 end
			print N'сыграло - '+convert(nvarchar(30),@iresult)
		end
	end
	else
	begin

		print N'текст'

		select @iResult=
		case
			when exists(select a.code from (select top 100 percent a.[Code], a.[orderBy], b.[Признак_Code], b.[значение], b.[зн с], b.[зн по]
				from [MDSDB].[mdm].[ecpPosOfPricing] as a inner join [MDSDB].[mdm].[ecpRules] as b
					on a.code=b.[условие_Code] where [Подкатегория_Code]=@sC order by a.[orderBy]) as a
						inner join @mValues as b
							on (a.Признак_Code collate Cyrillic_General_100_CI_AS =b.code and b.cValue=a.значение collate Cyrillic_General_100_CI_AS)
								where a.[Признак_code]=@featureCode and a.Code=@ruleCode) then 1
				else 0 end
		print N'сыграло - '+convert(nvarchar(30),@iresult)
	end

	select @oldIResult=iresult from @ruleSuccess where rCode=@ruleCode

	print N'Обновление - '+convert(nvarchar(30),@oldIResult)

	if (@iResult=1 and exists(select * from @ruleSuccess where rCode=@ruleCode and iResult=2))
	begin
		update @ruleSuccess set iResult=@iResult
			from @ruleSuccess where rCode=@ruleCode
	end
	else
	if (@iResult=0 and exists(select * from @ruleSuccess where rCode=@ruleCode and iResult in (1,2)))
	begin
		update @ruleSuccess set iResult=@iResult
			from @ruleSuccess where rCode=@ruleCode
	end

	fetch next from cRules into @ruleCode, @featureCode
end

close cRules

deallocate cRules

select @jsonRaschet=(select * from (select a.rCode, b.[условие_Name] as [rName], a.mvalue, a.ruleDate, a.sumType from @ruleSuccess as a inner join 
 [MDSDB].[mdm].[ecpPriceItems] as b on a.rCode=b.[условие_Code] collate Cyrillic_General_100_CI_AS where iresult=1) as rezRaschet for json auto)


select @m0Value=Sum(mvalue) from @ruleSuccess where sumType=0 and iresult=1
select @m1Value=Sum(mvalue) from @ruleSuccess where sumType=1 and iresult=1

select @mRezultSum=isnull(@m0Value,0)+isnull(@m0Value,0)*isnull(@m1Value,0)/100

print N'абсолютная сумма - '+convert(nvarchar(30),isnull(@m0value,0))
print N'проценты сумма - '+convert(nvarchar(30),isnull(@m1value,0))

print N'Итого - '+convert(nvarchar(30),isnull(@mRezultSum,0))

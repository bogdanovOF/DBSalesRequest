USE [e-con stock and price]
GO

-- расчет цен на сорт по прайсу

DECLARE @RC int
declare @stock int
declare @cSubCat nvarchar(30)
DECLARE @priceCode nvarchar(30)=1
DECLARE @OZM nvarchar(30)
DECLARE @jsonOtherParam nvarchar(max)
declare @datePrice date= datefromparts(2018,02,01)
--(select max([дата с]) from mdsdb.mdm.ecpPriceItems where [Прайс_Code]=@priceCode)

print N'дата цены'+convert(nvarchar(50),@datePrice)

if not exists(select top 1 [Startdate] from [e-con stock and price].[dbo].allPrices where startDate=@datePrice)
begin

declare dopParam cursor for
select склад, подкатегория_Code, прайс_Code, [доп парам] from mdsdb.mdm.ecpDopParamForPricingSort
open dopParam

fetch next from dopParam into @stock, @cSubCat, @priceCode, @jsonOtherParam 

while @@FETCH_STATUS=0
begin

	DECLARE @jsonRaschet nvarchar(max)=''
	DECLARE @mRezultSum money=0
	declare @rPrice table (OZM nvarchar(30), rPrice money, jsonRezult nvarchar(max))

	declare subCat cursor  for
	select Code from MDSDB.mdm.OZMOfProducts where SubCategory_Code=@cSubCat and EC=1

	open subCat

	fetch next from subCat into @OZM

	while @@FETCH_STATUS=0
	begin
		EXECUTE @RC = [e-con stock and price].[dbo].[getCostOfMaterialByPrice] 
		   @priceCode
		  ,@OZM
		  ,@jsonOtherParam
		  ,@jsonRaschet OUTPUT
		  ,@mRezultSum OUTPUT
		  ,@datePrice

		  insert into @rPrice values(@OZM, @mRezultSum, @jsonRaschet)
		  fetch next from subCat into @OZM
	end

	close subCat

	deallocate subCat
	

	INSERT INTO [dbo].[allPrices]
			   ([ozm]
			   ,[dopParam]
			   ,[price]
			   ,[startDate]
			   ,[raschetAll]
			   ,[ecstock]
			   ,[orderByDay])
	select a.OZM, @jsonOtherParam,
	 a.rPrice, @datePrice, a.jsonRezult,
	 @stock, (select max([orderByDay]) from mdsdb.mdm.ecpPriceItems
						 where [Прайс_Code]=@priceCode and [дата с]=@datePrice)
						  from @rPrice as a

	delete from @rPrice

	fetch next from dopParam into @stock, @cSubCat, @priceCode, @jsonOtherParam 
end

close dopParam
deallocate dopParam

-- добавляем метизы на склад екатеринбурга
	INSERT INTO [dbo].[allPrices]
			   ([ozm]
			   ,[dopParam]
			   ,[price]
			   ,[startDate]
			   ,[raschetAll]
			   ,[ecstock]
			   ,[orderByDay])
	select a.OZM, null, a.Price, @datePrice, null, 2, 0 from mdsdb.[mdm].[ecpMetizAndPoputnPrices] as a
	where a.OZM like N'MW%' and a.OZM in (select Code from mdsdb.mdm.OZMOfProducts where ec=1)
	 and [StartDate]=(select max([StartDate]) from mdsdb.[mdm].[ecpMetizAndPoputnPrices] where a.OZM like N'MW%')

-- добавляем попутную
	INSERT INTO [dbo].[allPrices]
			   ([ozm]
			   ,[dopParam]
			   ,[price]
			   ,[startDate]
			   ,[raschetAll]
			   ,[ecstock],[orderByDay])
	select a.Code, NULL, isnull(c.price,0), @datePrice,null, [e-con stock and price].[dbo].[getEstockByOzm](a.Code),0
	 from mdsdb.[mdm].[OZMOfProducts] as a inner join mdsdb.[mdm].[SubCategoryOfProducts] as b
		on a.SubCategory_Code=b.Code left outer join
		mdsdb.[mdm].[ecpMetizAndPoputnPrices] as c on a.Code=c.OZM
		where b.Category_Code=11 and a.EC=1
		 and [StartDate]=(select max([StartDate]) from mdsdb.[mdm].[ecpMetizAndPoputnPrices] where [OZM] like N'%PP%')

-- весь плоский
	INSERT INTO [dbo].[allPrices]
			   ([ozm]
			   ,[dopParam]
			   ,[price]
			   ,[startDate]
			   ,[raschetAll]
			   ,[ecstock], [orderByDay])
	select a.Code, NULL, 0, @datePrice, null, 3,0
	  from mdsdb.[mdm].[OZMOfProducts] as a inner join mdsdb.[mdm].[SubCategoryOfProducts] as b
		on a.SubCategory_Code=b.Code
		where b.Category_Code in (2,3,4,5,6,7,9,10) and a.EC=1

end

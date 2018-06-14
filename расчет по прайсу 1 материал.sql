USE [e-con stock and price]
GO

DECLARE @RC int
DECLARE @priceCode nvarchar(30)=1
DECLARE @OZM nvarchar(30)=N'LP_0306001_0227'
DECLARE @jsonOtherParam nvarchar(max)=(select * from (select 158 as code, 'Екатеринбург' as cValue, 0 as nVal1,0 as nVal2
														union all
															select 159, 'CPT', 0,0
															--union all
															--select 177, 'Одинцово-1', 0,0
															) as [jsonParam] for json auto)
DECLARE @jsonRaschet nvarchar(max)
DECLARE @mRezultSum money

-- TODO: задайте здесь значения параметров.

EXECUTE @RC = [dbo].[getCostOfMaterialByPrice] 
   @priceCode
  ,@OZM
  ,@jsonOtherParam
  ,@jsonRaschet OUTPUT
  ,@mRezultSum OUTPUT
  ,null


  print 'Цена - '+convert(nvarchar(30),@mRezultSum)
  print 'Ресчет - '+@jsonRaschet



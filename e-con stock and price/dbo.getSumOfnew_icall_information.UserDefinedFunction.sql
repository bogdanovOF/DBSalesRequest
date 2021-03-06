USE [e-con stock and price]
GO
/****** Object:  UserDefinedFunction [dbo].[getSumOfnew_icall_information]    Script Date: 25.06.2018 17:56:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[getSumOfnew_icall_information]
(
	-- Add the parameters for the function here
	@intext nvarchar(max)
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @rezult money;

	with tonnCount as (
	select
	rn=ROW_NUMBER() OVER (ORDER BY value),
	convert(integer,replace(ltrim(left(value,charindex(N' т; Цена',value,1))),' ','')) as tc_ from string_split(@intext,':') where value like N'%Цена%'
	)
	,
	pT as (
		select ROW_NUMBER() OVER (ORDER BY value) as rn_,
		convert(integer,replace(ltrim(left(value,charindex(N' ₽/т; Стоимость',value,1))),' ','')) as price_
		from string_split(@intext,':') where value like N'%₽/т; Стоимость%'
	)
	select @rezult=sum(tc_*price_) from tonnCount inner join pT on tonnCount.rn=pT.rn_

	RETURN isnull(@rezult,0)

END
GO

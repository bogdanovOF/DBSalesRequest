SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Script for SelectTopNRows command from SSMS  ******/
ALTER procedure [dbo].[allIntervalsZayavki]
as

declare @counter as int =0
declare @reztable as table([RezExp] nvarchar(100))
declare @first as nvarchar(20), @second as nvarchar(20), @rezult_ as nvarchar(100) 

if exists(SELECT * FROM sys.sequences WHERE name = 'requestSequence') begin drop sequence requestSequence end

create sequence dbo.requestSequence
	start with 0
	increment by 2500

  while (@counter< 30)
	begin

		if (@counter=0) 
		begin set @first=next value for dbo.requestSequence end
		else
		begin set @first=@second end
		
		set @second=next value for dbo.requestSequence

		set @rezult_=N'Идентификатор ge '+@first
		+N' and Идентификатор lt '+@second

		insert @reztable
		 values  (@rezult_)

		set @counter=@counter+1
	end
		select * from @reztable
GO

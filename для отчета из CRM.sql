use [e-con stock and price]
go 

declare @dFrom date=convert(date,'2018-04-01')

SELECT Qb.[Description],[ObjectId],[Title],QIB.[CreatedOn],QIB.[StatusCode],[WorkerIdName], IC.*,
	[���������� ����� � ������]=(LEN([new_icall_information]) - LEN(REPLACE([new_icall_information], N'��������: ', '')))/LEN(N'��������: ')
	,
	[����� ����]=Case
		when
		 ((LEN([new_icall_information]) - LEN(REPLACE([new_icall_information], N'��������: ', '')))/LEN(N'��������: ')>0) and QB.[Description] like '%�� E.Comm%' then
		(select sum(convert(integer,replace(ltrim(left(value,charindex(N' �; ����',value,1))),' ',''))) from string_split([new_icall_information],':') where value like N'%����%')
		else 0 end,
	[����� �����]=Case
		when
		 ((LEN([new_icall_information]) - LEN(REPLACE([new_icall_information], N'��������: ', '')))/LEN(N'��������: ')>0) and QB.[Description] like '%�� E.Comm%' then
		(select [e-con stock and price].dbo.[getSumOfnew_icall_information]([new_icall_information]))
		else 0 end
  FROM [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[QueueBase]  as Qb inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[QueueItemBase] as QIB
  on qb.[QueueId]=QIB.[QueueId]
  inner join [NLMK-CRMDB].[NLMK_MSCRM].[dbo].[new_icallExtensionBase] as IC
  on IC.[new_icallId]=QIB.[ObjectId]
  where QIB.createdOn>=@dFrom and QIB.objectTypeCode=10074




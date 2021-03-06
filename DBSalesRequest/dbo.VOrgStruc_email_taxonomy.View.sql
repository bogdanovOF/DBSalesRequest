USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[VOrgStruc_email_taxonomy]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VOrgStruc_email_taxonomy]
AS
SELECT        DBSRUsers_1.Отдел AS [Подразделение руководителя], DBSRUsers_1.Должность AS [Должность руководителя], DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя AS [Имя и Фамилия руководителя], 
                         dbo.DBSRUsers.Отдел AS [Подразделение сотрудника], dbo.DBSRUsers.Должность AS [Должность сотрудника], dbo.DBSRUsers.Фамилия + ' ' + dbo.DBSRUsers.Имя AS [Идентификатор сотрудника], 
                         dbo.DBSROrgStruct.EmployeeId, convert(nvarchar(100),upper(dbo.DBSROrgStruct.Empl_email)) as emailid,
						 case
							when DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя='Овчинников Владислав' then '2075a285-fced-4a8b-b8e0-8a53cbcfc1d6'
							when DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя='Анисимов Сергей' then '10ff05d3-4292-4883-83ff-7aa6dbc4b1fd'
							when DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя='Городилов Павел' then 'ae7bca0f-a997-4793-a8fc-8cb978dde147'
							when DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя='Гущин Илья' then '5c964605-f598-4a36-b0ee-a2dd09d3031f'
							when DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя='Козлов Александр' then 'e380bb1a-4bef-4adc-b971-d9e7f002e08e'
							else '' end taxonomyname
FROM            dbo.DBSROrgStruct LEFT OUTER JOIN
                         dbo.DBSRUsers AS DBSRUsers_1 ON dbo.DBSROrgStruct.ChiefId = DBSRUsers_1.Идентификатор LEFT OUTER JOIN
                         dbo.DBSRUsers ON dbo.DBSROrgStruct.EmployeeId = dbo.DBSRUsers.Идентификатор
						 where DBSRUsers_1.Фамилия + ' ' + DBSRUsers_1.Имя in ('Овчинников Владислав','Анисимов Сергей','Городилов Павел','Гущин Илья','Козлов Александр')
GO

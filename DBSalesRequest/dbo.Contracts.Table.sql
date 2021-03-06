USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[Contracts]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contracts](
	[Вид документа] [nvarchar](255) NULL,
	[Документ] [nvarchar](40) NOT NULL,
	[Внеш номер договора] [nvarchar](255) NULL,
	[Дата регистрации договора] [datetime] NULL,
	[Дата заключения] [datetime] NULL,
	[Дебитор] [nvarchar](20) NULL,
	[БЕ] [nvarchar](255) NULL,
	[Валюта договора] [nvarchar](255) NULL,
	[Валюта платежа] [nvarchar](255) NULL,
	[Вид договора] [nvarchar](255) NULL,
	[ВНУТР № ДОГОВОРА (СГОК)] [nvarchar](255) NULL,
	[Год договора] [nvarchar](255) NULL,
	[Группа полномочий] [nvarchar](255) NULL,
	[Дата выдачи] [datetime] NULL,
	[Дата начала действия] [datetime] NULL,
	[Конечная дата] [datetime] NULL,
	[Краткий номер договора] [nvarchar](255) NULL,
	[Статус документа] [nvarchar](255) NULL,
	[ФИО Ответственного] [nvarchar](255) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Contracts]  WITH NOCHECK ADD  CONSTRAINT [FK_Contracts_betable] FOREIGN KEY([БЕ])
REFERENCES [dbo].[betable] ([BE])
GO
ALTER TABLE [dbo].[Contracts] CHECK CONSTRAINT [FK_Contracts_betable]
GO

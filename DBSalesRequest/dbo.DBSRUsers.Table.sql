USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRUsers]    Script Date: 15.06.2018 13:59:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRUsers](
	[Должность] [nvarchar](50) NULL,
	[Имя] [nvarchar](50) NULL,
	[Фамилия] [nvarchar](50) NULL,
	[РабочийТелефон] [nvarchar](50) NULL,
	[ИмяПользователя] [nvarchar](50) NULL,
	[Офис] [nvarchar](50) NULL,
	[Идентификатор] [int] NOT NULL
) ON [PRIMARY]
GO

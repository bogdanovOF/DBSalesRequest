USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Дебитор] [nvarchar](20) NOT NULL,
	[ИНН] [nvarchar](25) NULL,
	[FullName] [nvarchar](255) NULL,
	[Страна] [nvarchar](4) NULL,
	[Город] [nvarchar](255) NULL,
	[Улица] [nvarchar](255) NULL,
	[жд код предприятия] [nvarchar](10) NULL,
	[тип дебитора] [nvarchar](255) NULL,
	[ShortName] [nvarchar](255) NULL,
	[Region] [nchar](10) NULL,
	[NameI] [nchar](200) NULL,
	[CityI] [nchar](200) NULL,
	[StreetI] [nchar](200) NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Дебитор] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

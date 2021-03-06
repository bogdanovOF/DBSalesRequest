USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRCountry]    Script Date: 15.06.2018 13:59:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRCountry](
	[ISO3] [nvarchar](50) NULL,
	[ISODIG3] [nvarchar](50) NULL,
	[EUMember] [nvarchar](50) NULL,
	[Name] [nvarchar](50) NULL,
	[Идентификатор] [int] NOT NULL,
 CONSTRAINT [PK_DBSRCountry] PRIMARY KEY CLUSTERED 
(
	[Идентификатор] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

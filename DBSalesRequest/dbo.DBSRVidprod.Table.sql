USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRVidprod]    Script Date: 15.06.2018 13:59:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRVidprod](
	[вид продукции] [nvarchar](50) NULL,
	[Идентификатор] [int] NOT NULL,
	[NameEn] [nvarchar](50) NULL,
 CONSTRAINT [PK_DBSRVidprod] PRIMARY KEY CLUSTERED 
(
	[Идентификатор] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

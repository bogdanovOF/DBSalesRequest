USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRBEList]    Script Date: 15.06.2018 13:59:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRBEList](
	[BE] [nvarchar](50) NULL,
	[Площадка] [nvarchar](50) NULL,
	[Идентификатор] [int] NOT NULL,
	[BEEn] [nvarchar](50) NULL,
 CONSTRAINT [PK_DBSRBEList] PRIMARY KEY CLUSTERED 
(
	[Идентификатор] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

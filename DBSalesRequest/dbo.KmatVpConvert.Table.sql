USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[KmatVpConvert]    Script Date: 15.06.2018 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KmatVpConvert](
	[VidProdZayavkiId] [int] NULL,
	[Kmat] [nvarchar](20) NULL,
	[Percent] [float] NULL,
	[id_] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [PK_KmatVpConvert] PRIMARY KEY CLUSTERED 
(
	[id_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

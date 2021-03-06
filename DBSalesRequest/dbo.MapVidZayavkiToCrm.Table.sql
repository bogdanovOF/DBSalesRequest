USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[MapVidZayavkiToCrm]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MapVidZayavkiToCrm](
	[VidProdZayavkiId] [int] NULL,
	[KmatName] [nvarchar](50) NULL,
	[KmatCode] [nvarchar](50) NULL,
	[id_] [int] NOT NULL,
	[CRMGrp] [nvarchar](50) NULL,
 CONSTRAINT [PK_MapVidZayavkiToCrm] PRIMARY KEY CLUSTERED 
(
	[id_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

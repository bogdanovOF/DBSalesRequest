USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[calendar]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[calendar](
	[key] [datetime] NULL,
	[год] [float] NULL,
	[месяц] [nvarchar](50) NULL,
	[день] [float] NULL,
	[день нед#] [float] NULL,
	[квартал] [nvarchar](50) NULL
) ON [PRIMARY]
GO

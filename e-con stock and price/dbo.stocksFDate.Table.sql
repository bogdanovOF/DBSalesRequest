USE [e-con stock and price]
GO
/****** Object:  Table [dbo].[stocksFDate]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stocksFDate](
	[stock] [nvarchar](50) NULL,
	[OZM] [nvarchar](50) NULL,
	[stage_date] [datetime] NULL,
	[volume] [float] NULL,
	[mc_] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO

USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRSlipCurrExch]    Script Date: 15.06.2018 13:59:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRSlipCurrExch](
	[mc_] [int] NOT NULL,
	[CurDate] [date] NULL,
	[USD] [money] NULL,
	[EUR] [money] NULL,
 CONSTRAINT [PK_DBSRSlipCurrExch] PRIMARY KEY CLUSTERED 
(
	[mc_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

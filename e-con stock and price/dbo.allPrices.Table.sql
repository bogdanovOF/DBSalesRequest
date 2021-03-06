USE [e-con stock and price]
GO
/****** Object:  Table [dbo].[allPrices]    Script Date: 15.06.2018 14:09:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[allPrices](
	[ozm] [nvarchar](50) NULL,
	[dopParam] [nvarchar](1000) NULL,
	[price] [money] NULL,
	[startDate] [datetime] NULL,
	[raschetAll] [nvarchar](4000) NULL,
	[ecstock] [nvarchar](50) NULL,
	[orderByDay] [int] NULL,
	[mc_] [int] IDENTITY(1,1) NOT NULL,
	[discount] [money] NULL,
 CONSTRAINT [PK_allPrices] PRIMARY KEY NONCLUSTERED 
(
	[mc_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_allPrices_1] UNIQUE NONCLUSTERED 
(
	[ozm] ASC,
	[ecstock] ASC,
	[startDate] ASC,
	[orderByDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[allPrices] ADD  CONSTRAINT [DF_allPrices_orderByDay]  DEFAULT ((0)) FOR [orderByDay]
GO

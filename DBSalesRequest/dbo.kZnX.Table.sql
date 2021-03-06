USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[kZnX]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[kZnX](
	[customer] [nvarchar](15) NOT NULL,
	[kZnCold] [float] NULL,
	[kZnHot] [float] NULL,
	[kZnColdbPy] [float] NULL,
	[kZnHotbPy] [float] NULL,
	[kZnColdCust] [float] NULL,
	[kZnHotCust] [float] NULL,
	[kZnColdCustPy] [float] NULL,
	[kZnHotCustPy] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[kZnX] ADD  CONSTRAINT [DF_kZnX_customer]  DEFAULT ((9999999999.)) FOR [customer]
GO

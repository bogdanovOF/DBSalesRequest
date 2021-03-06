USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[ctUserFirms]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ctUserFirms](
	[CustomerCode] [nvarchar](250) NULL,
	[CustomerName] [nvarchar](100) NULL,
	[OPF] [nvarchar](250) NULL,
	[Status] [nvarchar](250) NULL,
	[FO1] [nvarchar](50) NULL,
	[FO2] [nvarchar](50) NULL,
	[FO3] [nvarchar](50) NULL,
	[MO1] [nvarchar](50) NULL,
	[MO2] [nvarchar](50) NULL,
	[Segm1] [nvarchar](50) NULL,
	[Segm2] [nvarchar](50) NULL,
	[CustomerStatus] [nvarchar](250) NULL,
	[Name planning] [nvarchar](250) NULL,
	[Country_Code] [nvarchar](250) NULL,
	[Country_Name] [nvarchar](250) NULL,
	[INN] [nvarchar](20) NULL
) ON [PRIMARY]
GO

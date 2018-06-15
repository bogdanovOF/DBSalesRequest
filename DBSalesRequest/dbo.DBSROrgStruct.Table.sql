USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSROrgStruct]    Script Date: 15.06.2018 13:59:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSROrgStruct](
	[ChiefId] [int] NOT NULL,
	[EmployeeId] [int] NULL,
	[Empl_email] [nvarchar](50) NULL,
	[Идентификатор] [int] NOT NULL
) ON [PRIMARY]
GO

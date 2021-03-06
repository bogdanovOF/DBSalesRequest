USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[DBSRPriceOfTransportation]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBSRPriceOfTransportation](
	[SRVPGroupValue] [nvarchar](50) NULL,
	[SRCountryId] [int] NULL,
	[SRPortId] [int] NULL,
	[SRincoValue] [nvarchar](50) NULL,
	[SRInco2Value] [nvarchar](50) NULL,
	[СтоимостьUSDТ] [float] NULL,
	[СтоимостьEURТ] [float] NULL,
	[ДействуетС] [datetime] NULL,
	[Идентификатор] [int] NOT NULL,
 CONSTRAINT [PK_DBSRPriceOfTransportation] PRIMARY KEY CLUSTERED 
(
	[Идентификатор] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[CRMSpeOrdShipFact]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CRMSpeOrdShipFact](
	[Customer] [nvarchar](20) NULL,
	[Contract] [nvarchar](50) NULL,
	[RequestMonth] [date] NULL,
	[PosMonth] [date] NULL,
	[RMname] [nvarchar](6) NULL,
	[Kmat] [nvarchar](50) NULL,
	[VidProd] [int] NULL,
	[VidPostav] [nvarchar](50) NULL,
	[SpecVol] [float] NULL,
	[OrderVol] [float] NULL,
	[ShipVol] [float] NULL,
	[sincdate] [datetime] NULL,
	[sincid] [uniqueidentifier] NULL
) ON [PRIMARY]
GO

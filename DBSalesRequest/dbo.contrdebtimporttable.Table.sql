USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[contrdebtimporttable]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contrdebtimporttable](
	[Kna1_004] [nvarchar](200) NULL,
	[Kna1_003] [nvarchar](200) NULL,
	[Kna1_002] [nvarchar](200) NULL,
	[Zzdog_num] [nvarchar](40) NULL,
	[Doknr] [nvarchar](25) NOT NULL,
	[Zzbukrs] [nvarchar](4) NULL,
	[Ktokd] [nvarchar](4) NULL,
	[Zzrzdcp] [nvarchar](10) NULL,
	[Stras] [nvarchar](35) NULL,
	[Ort01] [nvarchar](35) NULL,
	[Land1] [nvarchar](3) NULL,
	[Name] [nvarchar](140) NULL,
	[Stcd1] [nvarchar](16) NULL,
	[Kunnr] [nvarchar](10) NOT NULL,
	[Region] [nchar](10) NULL,
	[NameI] [nchar](200) NULL,
	[CityI] [nchar](200) NULL,
	[StreetI] [nchar](200) NULL,
 CONSTRAINT [PK_contrdebtimporttable] PRIMARY KEY CLUSTERED 
(
	[Kunnr] ASC,
	[Doknr] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

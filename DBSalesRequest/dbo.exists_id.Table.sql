USE [DBSalesRequest]
GO
/****** Object:  Table [dbo].[exists_id]    Script Date: 15.06.2018 13:59:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exists_id](
	[mc_] [int] IDENTITY(1,1) NOT NULL,
	[table_name] [nvarchar](50) NULL,
	[id_] [int] NULL,
 CONSTRAINT [PK_exists_id] PRIMARY KEY CLUSTERED 
(
	[mc_] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

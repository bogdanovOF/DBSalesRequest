USE [DBSalesRequest]
GO
/****** Object:  User [SRConnect]    Script Date: 15.06.2018 13:59:25 ******/
CREATE USER [SRConnect] FOR LOGIN [SRConnect] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [SRConnect]
GO

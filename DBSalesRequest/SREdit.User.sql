USE [DBSalesRequest]
GO
/****** Object:  User [SREdit]    Script Date: 15.06.2018 13:59:25 ******/
CREATE USER [SREdit] FOR LOGIN [SREdit] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [SREdit]
GO

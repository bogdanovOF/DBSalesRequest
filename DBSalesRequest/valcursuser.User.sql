USE [DBSalesRequest]
GO
/****** Object:  User [valcursuser]    Script Date: 15.06.2018 13:59:25 ******/
CREATE USER [valcursuser] FOR LOGIN [valcursuser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [valcursuser]
GO

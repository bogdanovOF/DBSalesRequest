USE [DBSalesRequest]
GO
/****** Object:  User [AONLMK\nl-a-mds-service1]    Script Date: 15.06.2018 13:59:23 ******/
CREATE USER [AONLMK\nl-a-mds-service1] FOR LOGIN [AONLMK\nl-a-mds-service1] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [AONLMK\nl-a-mds-service1]
GO

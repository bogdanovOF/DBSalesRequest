USE [DBSalesRequest]
GO
/****** Object:  User [AONLMK\wget]    Script Date: 15.06.2018 13:59:24 ******/
CREATE USER [AONLMK\wget] FOR LOGIN [AONLMK\wget] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [AONLMK\wget]
GO

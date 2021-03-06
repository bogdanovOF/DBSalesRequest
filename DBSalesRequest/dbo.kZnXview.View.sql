USE [DBSalesRequest]
GO
/****** Object:  View [dbo].[kZnXview]    Script Date: 15.06.2018 13:59:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[kZnXview]
as
select customer, kmat,
	 case
	 when kZnPy is null then kZn
	 else kZnPy end as kZn
 from (
-- 99 -> 97 -> 98
--HR_0103400 - гк
select [customer], 'WHR_0103400' as [kmat], [kZnHot] as [kZn],  [kZnHotbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
select '9999999997' as [customer], 'WHR_0103400' as [kmat], [kZnHot] as [kZn],  [kZnHotbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
select '9999999998' as [customer], 'WHR_0103400' as [kmat], [kZnHot] as [kZn],  [kZnHotbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
--CR_0104131 - хк
select [customer], 'WCR_0104131' as [kmat], [kZnCold] as [kZn],  [kZnColdbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
select '9999999997' as [customer], 'WCR_0104131' as [kmat], [kZnCold] as [kZn],  [kZnColdbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
select '9999999998' as [customer], 'WCR_0104131' as [kmat], [kZnCold] as [kZn],  [kZnColdbPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer='9999999999'
union all
-- exist customer
--HR_0103400 - гк
select [customer], 'WHR_0103400' as [kmat], [kZnHotCust] as [kZn],  [kZnHotCustPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer<>'9999999999'
union all
--CR_0104131 - хк
select [customer], 'WCR_0104131' as [kmat], [kZnColdCust] as [kZn],  [kZnColdCustPy] as [kZnPy] from [DBSalesRequest].[dbo].[kZnX] where customer<>'9999999999'
) as a
 where not (kZn is null and kZnPy is null)
 

GO

--exec sp_recent_sales
IF OBJECTPROPERTY(object_id('dbo.sp_recent_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_recent_sales]
GO
CREATE PROCEDURE dbo.sp_recent_sales
AS 
BEGIN

select pro_name as Product, pro_price as PriceSold, pos_datetime as TimeOfSale 
from t_pos_sales s 
inner join t_product p on p.pro_id = s.pro_id 
where pos_datetime > DateAdd(Hour, -1, GETDATE()) and pos_datetime < GETDATE(); 

END 

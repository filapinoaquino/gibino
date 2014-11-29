--exec sp_recent_sales
/* CHECK IF PROCEDURE EXISTS, DROP AND RECREATE IT */
IF OBJECTPROPERTY(object_id('dbo.sp_recent_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_recent_sales]
GO
CREATE PROCEDURE dbo.sp_recent_sales
AS 
BEGIN

SELECT pro_name AS Product, pro_price AS PriceSold, pos_datetime AS TimeOfSale 
FROM t_pos_sales s 
INNER JOIN t_product p ON p.pro_id = s.pro_id 
WHERE pos_datetime > DateAdd(Hour, -1, GETDATE()) and pos_datetime < GETDATE(); 

END 

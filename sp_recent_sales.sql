--exec sp_recent_sales
IF OBJECTPROPERTY(object_id('dbo.sp_recent_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_recent_sales]
GO
CREATE PROCEDURE dbo.sp_recent_sales
AS 
BEGIN

select pro_id, pro_price 
from t_pos_sales 
where pos_datetime > DateAdd(Hour, -1, GETDATE()) and pos_datetime < GETDATE(); 

END 

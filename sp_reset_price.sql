--exec sp_reset_price
IF OBJECTPROPERTY(object_id('dbo.sp_reset_price'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_reset_price]
GO
CREATE PROCEDURE dbo.sp_reset_price
AS 
BEGIN 
BEGIN TRANSACTION

UPDATE pri
SET pri.pro_price = pro.pro_base
FROM t_price pri INNER JOIN t_product pro
on pri.pro_id = pro.pro_id;

SELECT * FROM T_PRODUCT;
if @@error <> 0

	begin
		rollback transaction
		select ' Sale was not completed'
		return
	end

commit transaction
END
--exec sp_reset_price
IF OBJECTPROPERTY(object_id('dbo.sp_reset_price'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_reset_price]
GO
CREATE PROCEDURE dbo.sp_reset_price
AS 
BEGIN 
BEGIN TRANSACTION

INSERT INTO T_PRICE(PRO_ID, PRO_PRICE)
SELECT PRO_ID, PRO_BASE
FROM T_PRODUCT

SELECT * FROM T_PRODUCT;
if @@error <> 0

	begin
		rollback transaction
		select ' Insert was unsuccessful'
		return
	end

commit transaction
END
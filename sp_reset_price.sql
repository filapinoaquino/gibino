--exec sp_reset_price
IF OBJECTPROPERTY(object_id('dbo.sp_reset_price'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_reset_price]
GO
CREATE PROCEDURE dbo.sp_reset_price
AS 
BEGIN 
BEGIN TRANSACTION
/* RESET PRICES BACK TO THEIR ORIGINAL PRICES */
UPDATE pri
SET pri.pro_price = pro.pro_base
FROM t_price pri INNER JOIN t_product pro
ON pri.pro_id = pro.pro_id;

IF @@error <> 0

	BEGIN
		ROLLBACK TRANSACTION
		SELECT ' Sale was NOT completed'
		RETURN
	END

COMMIT TRANSACTION
SELECT * FROM T_PRICE;
END
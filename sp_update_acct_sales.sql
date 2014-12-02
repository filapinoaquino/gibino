--exec sp_update_acct_sales
/* CHECK IF PROCEDURE EXISTS, DROP AND RECREATE IT */
IF OBJECTPROPERTY(object_id('dbo.sp_update_acct_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_update_acct_sales]
GO
CREATE PROCEDURE dbo.sp_update_acct_sales
AS 
BEGIN 
SELECT * FROM T_ACCT_SALES;

BEGIN TRANSACTION;

/* INSERT DATA FROM THE POS TERMINAL INTO THE PERMANENT ACCOUNTING TABLE */
INSERT INTO T_ACCT_SALES (ACCT_DATETIME, ACCT_QTY, CUS_ID, PRO_ID, ACCT_PRICE)
SELECT pos_datetime, pos_qty, cus_id, pro_id, pro_price
FROM T_POS_SALES
WHERE POS_PAID = 1; 

/* ROLLBACK ON ERROR */
IF @@error <> 0

	BEGIN
		ROLLBACK TRANSACTION;
		SELECT ' There was a problem migrating the sales information';
		RETURN
	END

COMMIT TRANSACTION;

SELECT * FROM T_ACCT_SALES;
END
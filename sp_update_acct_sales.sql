--exec sp_update_acct_sales
IF OBJECTPROPERTY(object_id('dbo.sp_update_acct_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_update_acct_sales]
GO
CREATE PROCEDURE dbo.sp_update_acct_sales
AS 
BEGIN 

BEGIN TRANSACTION

INSERT INTO T_ACCT_SALES (ACCT_DATETIME, ACCT_QTY, CUS_ID, PRO_ID, ACCT_PRICE)
SELECT pos_datetime, pos_qty, cus_id, pro_id, pro_price
FROM T_POS_SALES
WHERE POS_PAID = 1; 

if @@error <> 0

	begin
		rollback transaction
		select ' There was a problem migrating the sales information'
		return
	end

commit transaction

END
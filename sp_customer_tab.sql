--exec sp_customer_tab @cus_id = 25
IF OBJECTPROPERTY(object_id('sp_customer_tab'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_customer_tab]
GO
CREATE PROCEDURE dbo.sp_customer_tab
@cus_id INT
AS
BEGIN
	/* ROLLBACK IF AN ERROR HAS OCCURRED */
	IF NOT EXISTS (SELECT * FROM T_CUSTOMER WHERE cus_id = @cus_id)
		BEGIN
			SELECT 'Invalid Customer!'
			RETURN
		END
	/* ITEMIZED LIST OF UNPAID ITEMS */
	SELECT pro.pro_name, s.pro_price, s.pos_qty
	FROM t_customer c 
	INNER JOIN t_pos_sales s ON c.cus_id=s.cus_id 
	INNER JOIN t_product pro ON pro.pro_id=s.pro_id
	WHERE s.pos_paid=0
	AND s.cus_id = @cus_id

	/* CUSTOMER NAME AND SUBTOTAL */
	SELECT c.cus_fname, c.cus_lname,sum(s.pro_price) AS SubTotal
	FROM t_customer c 
	INNER JOIN t_pos_sales s ON c.cus_id=s.cus_id 
	INNER JOIN t_product pro ON pro.pro_id=s.pro_id
	WHERE s.pos_paid=0
	AND s.cus_id = @cus_id
	GROUP BY c.cus_id,c.cus_fname, c.cus_lname

END

/*
EXEC sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 10, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 5, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 900, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 1000, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 1, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 6, @pur_qty = 25, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 7, @pur_qty = 5, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 8, @pur_qty = 10, @cus_id = 3, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 12, @pur_qty = 0, @cus_id = 1, @pos_paid = 1;
*/
/* CHECK IF PROCEDURE EXISTS, DROP AND RECREATE IT */
IF OBJECTPROPERTY(object_id('dbo.sp_add_pos_sale'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_add_pos_sale]
GO
CREATE PROCEDURE dbo.sp_add_pos_sale
@pro_id INT,
@pur_qty INT,
@cus_id INT,
@pos_paid INT
AS
BEGIN
/*  VALIDATE PRODUCT   */

IF NOT EXISTS(SELECT * FROM t_product WHERE pro_id = @pro_id)
	BEGIN
		SELECT 'This product does NOT exist!'
		RETURN
	END

/*  VALIDATE CUSTOMER   */

IF NOT EXISTS(SELECT * FROM t_customer WHERE cus_id = @cus_id)
	BEGIN
		SELECT 'This customer does NOT exist!'
		RETURN
	END

/*  VALIDATE CUSTOMER   */

IF @pur_qty <= 0
	BEGIN
		SELECT 'This is NOT a valid purchase amount!'
		RETURN
	END


/*  VALIDATE SUFFICIENT INVENTORY   */

IF NOT EXISTS(SELECT * FROM dbo.t_product WHERE pro_id=@pro_id AND pro_instock>=@pur_qty)
	BEGIN
		SELECT 'We do NOT have enough of this product IN stock. The amount IN stock is', (SELECT pro_instock FROM t_product WHERE pro_id=@pro_id)
		RETURN
	END

/*  VALIDATE AGE FOR RESTRICTED ITEM  */
IF EXISTS(SELECT * FROM t_product WHERE pro_id=@pro_id AND ty_id IN (SELECT ty_id FROM t_type WHERE ty_restricted=1))
	BEGIN
		/* CHECK FOR CUSTOMER AGE, CREATE A HELPER TABLE TO DETERMINE AGE */
		BEGIN TRANSACTION
		IF OBJECT_ID('dbo.t_cus_age', 'U') IS NOT NULL
		DROP TABLE dbo.t_cus_age
		CREATE TABLE dbo.t_cus_age
		(
		cage_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
		cus_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
		age			INT	NOT null
		);

		INSERT INTO T_CUS_AGE(CUS_ID, AGE)
		SELECT cus_id, DATEDIFF(hour, cus_dob, GETDATE())/8766 AS AgeInYears FROM t_customer;

		/* CUSTOMER IS NOT OF AGE */
		IF NOT EXISTS(SELECT * FROM t_cus_age a 
				INNER JOIN t_customer c ON a.cus_id = c.cus_id 
				WHERE age < 21 AND a.cus_id = @cus_id)
		BEGIN
			ROLLBACK TRANSACTION
			SELECT 'Alcoholic beverages can only be purchased BY customers who are 21 years of age or older'
			RETURN
		END
		COMMIT TRANSACTION
	END
select * from t_product where pro_id = 4;
SELECT * FROM T_POS_SALES;
BEGIN TRANSACTION


/* CREATE A SALE */
insert into dbo.t_pos_sales(pos_qty, cus_id, pro_id, pos_paid, pro_price) 
values(@pur_qty, @cus_id, @pro_id, @pos_paid, (SELECT pro_price FROM dbo.t_price WHERE pro_id = @pro_id));

update t_product
set pro_instock = (pro_instock - @pur_qty)
WHERE pro_id = @pro_id;

/* ROLLBACK IF AN ERROR HAS OCCURRED */
IF @@error <> 0

	BEGIN
		ROLLBACK TRANSACTION
		SELECT ' Sale was NOT completed'
		RETURN
	END

COMMIT TRANSACTION;

SELECT * FROM t_product where pro_id = 4;
SELECT * FROM t_pos_sales;
SELECT   'Sold ', @pur_qty, 'units of ', (SELECT pro_name FROM t_product WHERE pro_id = @pro_id), ' at ', (SELECT pro_price FROM t_price WHERE pro_id = @pro_id), ' each.';

END
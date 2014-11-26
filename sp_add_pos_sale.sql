--use david
--begin stored procedure
/*
EXEC sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 10, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 5, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 900, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 1000, @cus_id = 3, @pos_paid = 0;
*/
--select * from t_cus_age
IF OBJECTPROPERTY(object_id('dbo.sp_add_pos_sale'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_add_pos_sale]
GO
CREATE PROCEDURE dbo.sp_add_pos_sale
@pro_id INT,
@pur_qty INT,
@cus_id INT,
@pos_paid INT
AS-- Logic Comes Here
--checks that product exists in inventory
BEGIN TRANSACTION;
BEGIN TRY
--CHECK FOR EXISTING CUSTOMER
IF exists(select * from t_customer where cus_id = @cus_id)
	BEGIN
		--CHECK FOR CUSTOMER AGE
		IF OBJECT_ID('dbo.t_cus_age', 'U') IS NOT NULL
		drop table dbo.t_cus_age
		create table dbo.t_cus_age
		(
		cage_id int 		identity(1,1) 	primary key,		
		cus_id	        int			foreign key references dbo.t_product(pro_id),
		age			int	not null
		);

		INSERT INTO T_CUS_AGE(CUS_ID, AGE)
		select cus_id, DATEDIFF(hour, cus_dob, GETDATE())/8766 AS AgeInYears from t_customer;

		IF not exists(select * from t_cus_age a inner join t_customer c on a.cus_id = c.cus_id where age < 21 and a.cus_id = @cus_id)
			IF exists(select * from dbo.t_product where pro_id=@pro_id and pro_instock>=@pur_qty)
				BEGIN
				insert into dbo.t_pos_sales(pos_qty, cus_id, pro_id, pos_paid, pro_price) 
				values(@pur_qty, @cus_id, @pro_id, @pos_paid, (select pro_price from dbo.t_price where pro_id = @pro_id));

				update t_product
				set pro_instock = (pro_instock - @pur_qty)
				where pro_id = @pro_id;
				END
			ELSE
				print 'There is insufficient amount of this product available for this purchase!'
				--ROLLBACK TRANSACTION;
		ELSE
			print 'Sorry, this person is not of age!'
			--rollback transaction;
	END
	ELSE
		PRINT 'INVALID CUSTOMER'
		--ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    SELECT 
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
END CATCH;

IF @@TRANCOUNT > 0
    COMMIT TRANSACTION;
GO
--use david
--begin stored procedure
/*
EXEC sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 10, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 5, @pos_paid = 1;
*/
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
--ADD CHECK FOR EXISTING CUSTOMER
--ADD CHECK FOR CUSTOMER AGE
IF exists(select * from dbo.t_product where pro_id=@pro_id and pro_instock>=@pur_qty)
insert into dbo.t_pos_sales(pos_qty, cus_id, pro_id, pos_paid, pro_price) 
values(@pur_qty, @cus_id, @pro_id, @pos_paid, (select pro_price from dbo.t_price where pro_id = @pro_id));
--ELSE
--CANNOT SELL
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
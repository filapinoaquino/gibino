use david
--begin stored procedure
--exec sp_reset_price
IF OBJECTPROPERTY(object_id('dbo.sp_reset_price'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_reset_price]
GO
CREATE PROCEDURE dbo.sp_reset_price
AS 
BEGIN TRANSACTION;
BEGIN TRY

UPDATE pri
SET pri.pro_price = pro.pro_base
FROM t_price pri INNER JOIN t_product pro
on pri.pro_id = pro.pro_id;

SELECT * FROM T_PRODUCT;

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
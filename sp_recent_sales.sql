--exec sp_recent_sales
IF OBJECTPROPERTY(object_id('dbo.sp_recent_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_recent_sales]
GO
CREATE PROCEDURE dbo.sp_recent_sales
AS 
BEGIN TRANSACTION;
BEGIN TRY

select pro_id, pro_price 
from t_pos_sales 
where pos_datetime > DateAdd(Hour, -1, GETDATE()) and pos_datetime < GETDATE(); 

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

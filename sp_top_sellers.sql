--exec sp_top_sellers
IF OBJECTPROPERTY(object_id('dbo.sp_top_sellers'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_top_sellers]
GO
CREATE PROCEDURE dbo.sp_top_sellers
AS 
BEGIN TRANSACTION;
BEGIN TRY

select top 3 pro_id, max(pos_qty) as TopSeller
from t_pos_sales
where Day(pos_datetime) = Day(GetDate())
group by pro_id
order by TopSeller desc;

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
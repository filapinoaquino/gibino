--use david
--begin stored procedure
--select * from t_pos_sales
--exec sp_price_report @date = '2014-11-26 13:00'
IF OBJECTPROPERTY(object_id('dbo.sp_price_report'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_price_report]
GO
CREATE PROCEDURE dbo.sp_price_report
@date datetime
AS 
BEGIN TRANSACTION;
BEGIN TRY

IF OBJECT_ID('dbo.t_price_diff', 'U') IS NOT NULL
drop table dbo.t_price_diff
create table dbo.t_price_diff
(
diff_id int 		identity(1,1) 	primary key,		
pro_id	        int			foreign key references dbo.t_product(pro_id),
diff_perc			decimal(5,1)	not null

);

INSERT INTO T_PRICE_DIFF (PRO_ID, DIFF_PERC)
SELECT pri.pro_id, ((pri.pro_price - pro.pro_base)/pro.pro_base) * 100
FROM t_price pri inner join t_product pro
on pri.pro_id = pro.pro_id;

select pro.pro_base, pri.pro_price, d.diff_perc, max(s.pro_price) as DailyHigh, min(s.pro_price) as DailyLow
from t_price pri 
inner join t_product pro on pri.pro_id = pro.pro_id
inner join t_price_diff d on d.pro_id = pri.pro_id
inner join t_pos_sales s on s.pro_id = d.pro_id
where DAY(s.pos_datetime) = DAY(@date)
group by pri.pro_id, pro.pro_base, pri.pro_price, d.diff_perc;

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
--exec sp_update_price_from_sales @start_time = '2014-11-26 12:00',@end_time = '2014-11-26 13:00';
--exec sp_update_price_from_sales @start_time = '2014-11-28 16:00',@end_time = '2014-11-28 17:00';
IF OBJECTPROPERTY(object_id('dbo.sp_update_price_from_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_update_price_from_sales]
GO
CREATE PROCEDURE dbo.sp_update_price_from_sales
@start_time datetime,
@end_time datetime
AS 
BEGIN
BEGIN TRANSACTION;
IF OBJECT_ID('dbo.t_sales_info', 'U') IS NOT NULL
drop table dbo.t_sales_info
create table dbo.t_sales_info
(
sal_id int 		identity(1,1) 	primary key,		
pro_id	        int			foreign key references dbo.t_product(pro_id),
qty_sold			int	not null

);

INSERT INTO T_SALES_INFO (PRO_ID, QTY_SOLD)
SELECT b.pro_id,sum(b.qty_sold)
FROM v_beer_sales b
WHERE time_of_sale between @start_time and @end_time
GROUP BY b.pro_id 

IF OBJECT_ID('dbo.t_sales_perc', 'U') IS NOT NULL
drop table dbo.t_sales_perc
create table dbo.t_sales_perc
(
sal_id int 		identity(1,1) 	primary key,		
pro_id	        int			foreign key references dbo.t_product(pro_id),
pct_of_sales			int	not null

);

INSERT INTO T_SALES_PERC (PRO_ID, PCT_OF_SALES)
SELECT s.pro_id, ROUND(s.qty_sold * 100.0/(SELECT sum(s.qty_sold) from t_sales_info s),2)
from t_sales_info s


IF OBJECT_ID('dbo.t_price_adjust', 'U') IS NOT NULL
drop table dbo.t_price_adjust
create table dbo.t_price_adjust
(
pa_id int 		identity(1,1) 	primary key,		
pro_id	        int			foreign key references dbo.t_product(pro_id),
price_adjust	decimal(5,2)	not null

);

INSERT INTO T_PRICE_ADJUST(PRO_ID, PRICE_ADJUST)
SELECT p.pro_id, CASE
					WHEN pct_of_sales = 0 THEN 0
					WHEN pct_of_sales > 0 and pct_of_sales < 20 THEN 0
					WHEN pct_of_sales >= 20 and pct_of_sales < 40 THEN .25
					WHEN pct_of_sales >= 40 and pct_of_sales < 60 THEN .5
					WHEN pct_of_sales >= 60 and pct_of_sales < 80 THEN .75
					WHEN pct_of_sales >= 80 and pct_of_sales <= 100 THEN 1
				END
from t_sales_perc p

UPDATE p
SET p.pro_price = p.pro_price + pa.price_adjust
FROM T_PRICE p inner join T_PRICE_ADJUST pa
on p.pro_id = pa.pro_id;

if @@error <> 0

	begin
		rollback transaction
		select ' Price update was unsuccessful'
		return
	end

commit transaction;
SELECT * FROM T_PRICE;

END
--exec sp_update_price_from_sales @start_time = '2014-11-26 12:00',@end_time = '2014-11-26 13:00';
--exec sp_update_price_from_sales @start_time = '2014-11-28 16:00',@end_time = '2014-11-28 17:00';
/* CHECK IF PROCEDURE EXISTS, DROP AND RECREATE IT */
IF OBJECTPROPERTY(object_id('dbo.sp_update_price_from_sales'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_update_price_from_sales]
GO
CREATE PROCEDURE dbo.sp_update_price_from_sales
/* DATE PARAMETERS */
@start_time DATETIME,
@end_time DATETIME
AS 
BEGIN
BEGIN TRANSACTION;
/* HELPER TABLE */
IF OBJECT_ID('dbo.t_sales_info', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_info
CREATE TABLE dbo.t_sales_info
(
sal_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
qty_sold			INT	NOT null

);

/* GRAB ALL THE SALES FOR THE TIME PERIOD */
INSERT INTO T_SALES_INFO (PRO_ID, QTY_SOLD)
SELECT b.pro_id,sum(b.qty_sold)
FROM v_beer_sales b
WHERE time_of_sale between @start_time AND @end_time
GROUP BY b.pro_id 

/* HELPER TABLE */
IF OBJECT_ID('dbo.t_sales_perc', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_perc
CREATE TABLE dbo.t_sales_perc
(
sal_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
pct_of_sales			INT	NOT null

);

/* PERCENTAGE OF SALES MATH */
INSERT INTO T_SALES_PERC (PRO_ID, PCT_OF_SALES)
SELECT s.pro_id, ROUND(s.qty_sold * 100.0/(SELECT sum(s.qty_sold) FROM t_sales_info s),2)
FROM t_sales_info s

/* HELPER TABLE */
IF OBJECT_ID('dbo.t_price_adjust', 'U') IS NOT NULL
DROP TABLE dbo.t_price_adjust
CREATE TABLE dbo.t_price_adjust
(
pa_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
price_adjust	DECIMAL(5,2)	NOT null

);

/* PRICE ADJUSTMENT CALCULATIONS */
INSERT INTO T_PRICE_ADJUST(PRO_ID, PRICE_ADJUST)
SELECT p.pro_id, CASE
					WHEN pct_of_sales = 0 THEN 0
					WHEN pct_of_sales > 0 AND pct_of_sales < 20 THEN 0
					WHEN pct_of_sales >= 20 AND pct_of_sales < 40 THEN .25
					WHEN pct_of_sales >= 40 AND pct_of_sales < 60 THEN .5
					WHEN pct_of_sales >= 60 AND pct_of_sales < 80 THEN .75
					WHEN pct_of_sales >= 80 AND pct_of_sales <= 100 THEN 1
				END
FROM t_sales_perc p;

/* UPDATE T_PRICE TABLE */
UPDATE p
SET p.pro_price = p.pro_price + pa.price_adjust
FROM T_PRICE p INNER JOIN T_PRICE_ADJUST pa
ON p.pro_id = pa.pro_id;

/* ROLLBACK IF THERE WAS AN ERROR */
IF @@error <> 0

	BEGIN
		ROLLBACK TRANSACTION
		SELECT ' Price update was unsuccessful'
		RETURN
	END

COMMIT TRANSACTION;
SELECT * FROM T_PRICE;

END
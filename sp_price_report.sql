--exec sp_price_report @date = '2014-11-28 13:00'
/* CHECK IF PROCEDURE EXISTS, DROP AND RECREATE IT */
IF OBJECTPROPERTY(object_id('dbo.sp_price_report'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_price_report]
GO
CREATE PROCEDURE dbo.sp_price_report
@date DATETIME
AS 
BEGIN 

BEGIN TRANSACTION
/* HELPER TABLE */
IF OBJECT_ID('dbo.t_price_diff', 'U') IS NOT NULL
DROP TABLE dbo.t_price_diff
CREATE TABLE dbo.t_price_diff
(
diff_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
diff_perc			DECIMAL(5,1)	NOT null

);

/* CALCULATE THE PRICE DIFFERENCES */
INSERT INTO T_PRICE_DIFF (PRO_ID, DIFF_PERC)
SELECT pri.pro_id, ((pri.pro_price - pro.pro_base)/pro.pro_base) * 100
FROM t_price pri INNER JOIN t_product pro
ON pri.pro_id = pro.pro_id;

/* ROLLBACK ON ERROR */
IF @@error <> 0

	BEGIN
		ROLLBACK TRANSACTION
		SELECT ' There was a problem creating the price report'
		RETURN
	END

COMMIT TRANSACTION;

/* QUERY FOR THE REPORT */
SELECT pro.pro_name AS Product, pro.pro_base AS OriginalPrice, pri.pro_price AS CurrentPrice, d.diff_perc AS PercentageDifference 
 , (CASE WHEN max(s.pro_price) < pri.pro_price THEN pri.pro_price ELSE max(s.pro_price) END) AS DailyHigh
 , min(s.pro_price) AS DailyLow
FROM t_price pri 
INNER JOIN t_product pro ON pri.pro_id = pro.pro_id
INNER JOIN t_price_diff d ON d.pro_id = pri.pro_id
INNER JOIN t_pos_sales s ON s.pro_id = d.pro_id
WHERE DAY(s.pos_datetime) = DAY(@date)
GROUP BY pri.pro_id, pro.pro_name,pro.pro_base, pri.pro_price, d.diff_perc

UNION

/* ADD PRODUCTS WITH NO SALES */
SELECT pro.pro_name AS Product, pro.pro_base AS OriginalPrice, pri.pro_price AS CurrentPrice, 0 AS PercentageDifference, pro.pro_base AS DailyHigh, pro.pro_base AS DailyLow
FROM t_price pri 
INNER JOIN t_product pro ON pri.pro_id = pro.pro_id
INNER JOIN t_price_diff d ON d.pro_id = pri.pro_id
WHERE pri.pro_id NOT IN (SELECT pro_id FROM t_pos_sales WHERE DAY(pos_datetime) = DAY(@date));



END
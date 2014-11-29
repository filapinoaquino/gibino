--exec sp_top_sellers
IF OBJECTPROPERTY(object_id('dbo.sp_top_sellers'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_top_sellers]
GO
CREATE PROCEDURE dbo.sp_top_sellers
AS 
BEGIN
/* SELECT TOP 3 SELLING PRODUCTS FOR THE CURRENT DAY */
SELECT top 3 pro_name, max(pos_qty) AS TopSeller
FROM t_pos_sales s 
INNER JOIN t_product p ON p.pro_id = s.pro_id
WHERE Day(pos_datetime) = Day(GetDate())
GROUP BY p.pro_id, pro_name
ORDER BY TopSeller DESC;

END
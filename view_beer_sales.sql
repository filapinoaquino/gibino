/*
IF OBJECT_ID('v_beer_sales', 'V') IS NOT NULL
DROP VIEW v_beer_sales; 
*/
/* CREATE THE BEER SALES VIEW */
CREATE VIEW v_beer_sales AS 
SELECT pro.pro_id, pro.pro_name AS beer, pri.pro_price AS cost_of_beer, sal.pos_datetime AS time_of_sale, sal.pos_qty AS qty_sold  
FROM dbo.t_product pro
INNER JOIN dbo.t_price pri ON pri.pro_id = pro.pro_id
INNER JOIN dbo.t_pos_sales sal ON sal.pro_id = pro.pro_id 



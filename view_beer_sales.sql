/*
IF OBJECT_ID('v_beer_sales', 'V') IS NOT NULL
DROP VIEW v_beer_sales; 
*/
create view v_beer_sales as 
select pro.pro_id, pro.pro_name as beer, pri.pro_price as cost_of_beer, sal.pos_datetime as time_of_sale, sal.pos_qty as qty_sold  
from dbo.t_product pro
inner join dbo.t_price pri on pri.pro_id = pro.pro_id
inner join dbo.t_pos_sales sal on sal.pro_id = pro.pro_id 



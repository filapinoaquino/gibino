--exec sp_top_sellers
IF OBJECTPROPERTY(object_id('dbo.sp_top_sellers'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_top_sellers]
GO
CREATE PROCEDURE dbo.sp_top_sellers
AS 
BEGIN

select top 3 pro_name, max(pos_qty) as TopSeller
from t_pos_sales s 
inner join t_product p on p.pro_id = s.pro_id
where Day(pos_datetime) = Day(GetDate())
group by p.pro_id, pro_name
order by TopSeller desc;

END
--exec sp_top_sellers
IF OBJECTPROPERTY(object_id('dbo.sp_top_sellers'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_top_sellers]
GO
CREATE PROCEDURE dbo.sp_top_sellers
AS 
BEGIN

select top 3 pro_id, max(pos_qty) as TopSeller
from t_pos_sales
where Day(pos_datetime) = Day(GetDate())
group by pro_id
order by TopSeller desc;

END
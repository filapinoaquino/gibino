--exec sp_customer_tab @cus_id = 25
IF OBJECTPROPERTY(object_id('sp_customer_tab'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_customer_tab]
GO
CREATE PROCEDURE dbo.sp_customer_tab
@cus_id INT
As
Begin
	If not exists (Select * from T_CUSTOMER where cus_id = @cus_id)
		begin
			select 'Invalid Customer!'
			return
		end

	Select pro.pro_name, s.pro_price, s.pos_qty
	from t_customer c 
	inner join t_pos_sales s on c.cus_id=s.cus_id 
	inner join t_product pro on pro.pro_id=s.pro_id
	where s.pos_paid=0
	and s.cus_id = @cus_id


	Select c.cus_fname, c.cus_lname,sum(s.pro_price) As SubTotal
	from t_customer c 
	inner join t_pos_sales s on c.cus_id=s.cus_id 
	inner join t_product pro on pro.pro_id=s.pro_id
	where s.pos_paid=0
	and s.cus_id = @cus_id
	group by c.cus_id,c.cus_fname, c.cus_lname

End

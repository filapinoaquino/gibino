/*
EXEC sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 5, @pur_qty = 10, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 5, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 25, @cus_id = 900, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 1000, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 4, @pur_qty = 1, @cus_id = 3, @pos_paid = 0;
EXEC sp_add_pos_sale @pro_id = 6, @pur_qty = 25, @cus_id = 1, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 7, @pur_qty = 5, @cus_id = 2, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 8, @pur_qty = 10, @cus_id = 3, @pos_paid = 1;
EXEC sp_add_pos_sale @pro_id = 8, @pur_qty = 0, @cus_id = 1, @pos_paid = 1;
*/
IF OBJECTPROPERTY(object_id('dbo.sp_add_pos_sale'), N'IsProcedure') = 1
DROP PROCEDURE [dbo].[sp_add_pos_sale]
GO
CREATE PROCEDURE dbo.sp_add_pos_sale
@pro_id INT,
@pur_qty INT,
@cus_id INT,
@pos_paid INT
AS-- Logic Comes Here
--checks that product exists in inventory
BEGIN
/*  VALIDATE CUSTOMER   */

IF not exists(select * from t_product where pro_id = @pro_id)
	begin
		select 'This product does not exist!'
		return
	end

/*  VALIDATE CUSTOMER   */

IF not exists(select * from t_customer where cus_id = @cus_id)
	begin
		select 'This customer does not exist!'
		return
	end

/*  VALIDATE CUSTOMER   */

IF @pur_qty <= 0
	begin
		select 'This is not a valid purchase amount!'
		return
	end


/*  VALIDATE SUFFICIENT INVENTORY   */

IF not exists(select * from dbo.t_product where pro_id=@pro_id and pro_instock>=@pur_qty)
	begin
		select 'We do not have enough of this product in stock. The amount in stock is', (select pro_instock from t_product where pro_id=@pro_id)
		return
	end

/*  VALIDATE AGE FOR RESTRICTED ITEM  */
IF exists(select * from t_product where pro_id=@pro_id and ty_id in (select ty_id from t_type where ty_restricted=1))
	BEGIN
		--CHECK FOR CUSTOMER AGE
		BEGIN TRANSACTION
		IF OBJECT_ID('dbo.t_cus_age', 'U') IS NOT NULL
		drop table dbo.t_cus_age
		create table dbo.t_cus_age
		(
		cage_id int 		identity(1,1) 	primary key,		
		cus_id	        int			foreign key references dbo.t_product(pro_id),
		age			int	not null
		);

		INSERT INTO T_CUS_AGE(CUS_ID, AGE)
		select cus_id, DATEDIFF(hour, cus_dob, GETDATE())/8766 AS AgeInYears from t_customer;

		IF not exists(select * from t_cus_age a 
				inner join t_customer c on a.cus_id = c.cus_id 
				where age < 21 and a.cus_id = @cus_id)
		begin
			ROLLBACK TRANSACTION
			select 'Alcoholic beverages can only be purchased by customers who are 21 years of age or older'
			return
		end
		commit transaction
	END

BEGIN TRANSACTION

--select @pur_qty, @cus_id, @pro_id, @pos_paid, (select pro_price from dbo.t_price where pro_id = @pro_id);
--select * from dbo.t_price;

insert into dbo.t_pos_sales(pos_qty, cus_id, pro_id, pos_paid, pro_price) 
values(@pur_qty, @cus_id, @pro_id, @pos_paid, (select pro_price from dbo.t_price where pro_id = @pro_id));


update t_product
set pro_instock = (pro_instock - @pur_qty)
where pro_id = @pro_id;

if @@error <> 0

	begin
		rollback transaction
		select ' Sale was not completed'
		return
	end

commit transaction

select * from t_pos_sales;
select   'Sold ', @pur_qty, 'units of ', (select pro_name from t_product where pro_id = @pro_id), ' at ', (select pro_price from t_price where pro_id = @pro_id), ' each.'

END
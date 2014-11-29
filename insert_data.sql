use gibino

--t_customer
insert into dbo.t_customer values ( 
'1995-01-01 00:00:00.000','123 York Road','','Towson','MD',21252,'joesmith@gmail.com','Joe','Smith','','Dr.')
insert into dbo.t_customer values ( 
'1980-01-01 00:00:00.000','456 ABC Bld.','','Baltimore','MD',21239,'samdan@yahoo.com','Sam','Daniel','','')
insert into dbo.t_customer values ( 
'1950-01-01 00:00:00.000','789 Old Terrace','','Baltimore','MD',21239,'howdee.com','Daggly','Howard','','')
insert into dbo.t_customer values ( 
'1962-01-01 00:00:00.000','7778 Route 99','','Baltimore','MD',21239,'freddy@yahoo.com','Hoord','Fred','','')
insert into dbo.t_customer values ( 
'1978-01-01 00:00:00.000','3435 Joppa Road','','Baltimore','MD',21239,'jlanen@yahoo.com','Lane','Jane','','')

--t_vendor
Insert into dbo.t_vendor values ('TOWSON BREW GUYS','5852 York Road','','Towson','MD',21252,'443-458-8522','towson@gmail.com','Lisa Howard')
Insert into dbo.t_vendor values ('BALTIMORE SODA POP','987 Penn Blvd.','','Baltimore','MD',21239,'443-100-8970','bchill@gmail.com','Jason Doe')
Insert into dbo.t_vendor values ('GIBINO BREWING','123 Brewers Blvd.','','Baltimore','MD',21239,'443-200-8970','gb_brewery@gmail.com','Gib Ino')
Insert into dbo.t_vendor values ('MONASTIC LAGER COMPANY','123 Monastery Road.','','Baltimore','MD',21239,'410-288-5566','those_monks@gmail.com','Greg Unkl')

--t_type
Insert into dbo.t_type values ('16 OZ BEER BOTTLE',1)
Insert into dbo.t_type values ('12 OZ SODA CAN',0)
Insert into dbo.t_type values ('64 OZ BEER GROWLER',1)
Insert into dbo.t_type values ('12 OZ BEER CAN',1)

--t_product
Insert into dbo.t_product values ('TB-Tiger Tail Ale',0,1,4.50, 1)
Insert into dbo.t_product values ('TB-Uni Lager',312,1,4.50, 1)
Insert into dbo.t_product values ('BSP-Ginger Beer',185,2,2.50, 2)
Insert into dbo.t_product values ('BSP-Root Beer',320,2,2.50, 2)
Insert into dbo.t_product values ('BSP-Orange Soda',255,2,2.50, 2)
Insert into dbo.t_product values ('GB-Primal',18,1,5.00, 3)
Insert into dbo.t_product values ('GB-Hoppy',25,1,6.00, 3)
Insert into dbo.t_product values ('GB-Porter',20,1,5.00, 3)
Insert into dbo.t_product values ('GB-Lager',15,1,5.50, 3)
Insert into dbo.t_product values ('GB-Ale',20,1,5.00, 3)

--t_sales info
Insert into dbo.t_sales_info values (1,15)
Insert into dbo.t_sales_info values (2,4)
Insert into dbo.t_sales_info values (3,1)
Insert into dbo.t_sales_info values (2,3)
Insert into dbo.t_sales_info values (3,11)
Insert into dbo.t_sales_info values (1,4)

--t_sales_perc
Insert into dbo.t_sales_perc values (1,20)
Insert into dbo.t_sales_perc values (2,40)
Insert into dbo.t_sales_perc values (3,10)
Insert into dbo.t_sales_perc values (5,5)
Insert into dbo.t_sales_perc values (6,20)
Insert into dbo.t_sales_perc values (7,5)



--t_price
Insert into dbo.t_price values (4,5.50)
Insert into dbo.t_price values (2,6.00)
Insert into dbo.t_price values (3,5.00)
Insert into dbo.t_price values (5,5.75)
Insert into dbo.t_price values (2,5.25)
Insert into dbo.t_price values (6,5.00)
Insert into dbo.t_price values (3,6.00)
Insert into dbo.t_price values (1,4.50)
Insert into dbo.t_price values (7,4.75)

--t_pos_sales
Insert into dbo.t_pos_sales values (getdate(),15,2,1,5.50,1)
Insert into dbo.t_pos_sales values (getdate(),8,1,2,4.00,1)
Insert into dbo.t_pos_sales values (getdate(),8,1,2,4.00,0)
Insert into dbo.t_pos_sales values (getdate(),7,2,3,5.00,0)
Insert into dbo.t_pos_sales values (getdate(),12,2,3,5.00,0)

--t_acct_sales
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',40,2,1,5.50)
Insert into t_acct_sales values ('2014-11-22 17:25:02.650',350,1,2,4.00)
Insert into t_acct_sales values ('2014-11-21 17:25:02.650',15,2,2,5.50)
Insert into t_acct_sales values ('2014-11-02 17:25:02.650',220,1,1,4.00)
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',15,2,3,5.50)
Insert into t_acct_sales values ('2014-11-15 17:25:02.650',8,1,4,4.00)
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',155,2,3,5.50)
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',188,1,4,4.00)
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',15,2,6,5.50)
Insert into t_acct_sales values ('2014-11-13 17:25:02.650',8,1,2,2.00)
Insert into t_acct_sales values ('2014-11-13 17:25:02.650',155,2,6,5.50)
Insert into t_acct_sales values ('2014-11-23 17:25:02.650',81,1,7,2.00)
Insert into t_acct_sales values ('2014-11-13 17:25:02.650',152,2,7,4.50)
Insert into t_acct_sales values ('2014-11-12 17:25:02.650',8,1,2,4.00)
Insert into t_acct_sales values ('2014-11-11 17:25:02.650',15,2,9,5.50)
Insert into t_acct_sales values ('2014-11-11 17:25:02.650',8,1,10,4.00)
Insert into t_acct_sales values ('2014-11-11 17:25:02.650',15,2,1,5.50)
Insert into t_acct_sales values ('2014-11-11 17:25:02.650',8,1,2,4.00)

--t_purchase
Insert into dbo.t_purchase values (2,1,425,3.5,getdate())
Insert into dbo.t_purchase values (1,2,240,1.75,getdate())
Insert into dbo.t_purchase values (3,3,240,1.75,getdate())
Insert into dbo.t_purchase values (4,3,240,2.50,getdate())
Insert into dbo.t_purchase values (5,3,240,3.00,getdate())
Insert into dbo.t_purchase values (6,3,240,3.50,getdate())
Insert into dbo.t_purchase values (7,3,240,2.25,getdate())

use gibino

-- DROP tables
IF OBJECT_ID('dbo.t_cus_age', 'U') IS NOT NULL
DROP TABLE dbo.t_cus_age
IF OBJECT_ID('dbo.t_acct_sales', 'U') IS NOT NULL
DROP TABLE dbo.t_acct_sales
IF OBJECT_ID('dbo.t_pos_sales', 'U') IS NOT NULL
DROP TABLE dbo.t_pos_sales
IF OBJECT_ID('dbo.t_customer', 'U') IS NOT NULL
DROP TABLE dbo.t_customer
IF OBJECT_ID('dbo.t_price', 'U') IS NOT NULL
DROP TABLE dbo.t_price
IF OBJECT_ID('dbo.t_price_adjust', 'U') IS NOT NULL
DROP TABLE dbo.t_price_adjust
IF OBJECT_ID('dbo.t_sales_perc', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_perc
IF OBJECT_ID('dbo.t_sales_info', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_info
IF OBJECT_ID('dbo.t_purchase', 'U') IS NOT NULL
DROP TABLE dbo.t_purchase
+IF OBJECT_ID('dbo.t_price_diff', 'U') IS NOT NULL
+DROP TABLE dbo.t_price_diff
IF OBJECT_ID('dbo.t_product', 'U') IS NOT NULL
DROP TABLE dbo.t_product
IF OBJECT_ID('dbo.t_vendor', 'U') IS NOT NULL
DROP TABLE dbo.t_vendor
IF OBJECT_ID('dbo.t_type', 'U') IS NOT NULL
DROP TABLE dbo.t_type

-- CREATE tables
IF OBJECT_ID('dbo.t_customer', 'U') IS NOT NULL
DROP TABLE dbo.t_customer
CREATE TABLE dbo.t_customer
(
cus_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
cus_dob DATETIME NOT null,
cus_street1 varchar(30),
cus_street2 varchar(30),
cus_city varchar(30),
cus_state char(2),
cus_zip numeric(5,0),
cus_email varchar(50),
cus_fname varchar(25),
cus_lname varchar(30),
cus_mi varchar(1),
cus_suffix varchar(5)
);



IF OBJECT_ID('dbo.t_vendor', 'U') IS NOT NULL
DROP TABLE dbo.t_vendor
CREATE TABLE dbo.t_vendor
(
ven_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
ven_name		varchar(30) NOT null,
ven_street1		varchar(30) NOT null,
ven_street2		varchar(30),
ven_city		varchar(30) NOT null,
ven_state		char(2) NOT null,
ven_zip			numeric(5,0),
ven_phone		varchar(12),
ven_email		varchar(50),
ven_contact		varchar(50)
);

IF OBJECT_ID('dbo.t_type', 'U') IS NOT NULL
DROP TABLE dbo.t_type
CREATE TABLE dbo.t_type
(
ty_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
ty_description	varchar(50) NOT null,
ty_restricted	INT NOT null
constraint ty_restricted check (ty_restricted IN (0,1))
);

IF OBJECT_ID('dbo.t_product', 'U') IS NOT NULL
DROP TABLE dbo.t_product
CREATE TABLE dbo.t_product
(
pro_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
pro_name 		varchar(30) 	NOT null,
pro_instock		INT		NOT null,
ty_id		INT		FOREIGN KEY REFERENCES t_type(ty_id),
pro_base		numeric(5,2) NOT null,
ven_id		INT FOREIGN KEY REFERENCES t_vendor(ven_id),
constraint pro_instock check (pro_instock >=0)
);

IF OBJECT_ID('dbo.t_sales_info', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_info
CREATE TABLE dbo.t_sales_info
(
si_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
qty_sold			INT	NOT null

);

IF OBJECT_ID('dbo.t_sales_perc', 'U') IS NOT NULL
DROP TABLE dbo.t_sales_perc
CREATE TABLE dbo.t_sales_perc
(
sp_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES dbo.t_product(pro_id),
pct_of_sales			INT	NOT null

);


IF OBJECT_ID('dbo.t_price', 'U') IS NOT NULL
DROP TABLE dbo.t_price
CREATE TABLE dbo.t_price
(
pri_id INT 		IDENTITY(1,1) 	PRIMARY KEY,		
pro_id	        INT			FOREIGN KEY REFERENCES t_product(pro_id),
pro_price			DECIMAL(5,2)	NOT null,
constraint pro_price check (pro_price > 0)
);


IF OBJECT_ID('dbo.t_pos_sales', 'U') IS NOT NULL
DROP TABLE dbo.t_pos_sales
CREATE TABLE dbo.t_pos_sales
(
pos_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
pos_datetime 		DATETIME 	NOT null   default getdate(),
pos_qty 		INT 	NOT null,
cus_id 			INT 		FOREIGN KEY REFERENCES t_customer(cus_id),
pro_id	        INT			FOREIGN KEY REFERENCES t_product(pro_id),
pro_price		DECIMAL(5,2)	NOT null,
pos_paid		INT NOT null
constraint pos_paid check (pos_paid IN (0,1))

);

IF OBJECT_ID('dbo.t_acct_sales', 'U') IS NOT NULL
DROP TABLE dbo.t_acct_sales
CREATE TABLE dbo.t_acct_sales
(
acct_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
acct_datetime 		DATETIME 	NOT null,
acct_qty 		INT 	NOT null,
cus_id 			INT 		FOREIGN KEY REFERENCES t_customer(cus_id),
pro_id	        INT			FOREIGN KEY REFERENCES t_product(pro_id),
acct_price		DECIMAL(5,2)	NOT null
);



IF OBJECT_ID('dbo.t_purchase', 'U') IS NOT NULL
DROP TABLE dbo.t_purchase
CREATE TABLE dbo.t_purchase
(
pur_id INT 		IDENTITY(1,1) 	PRIMARY KEY,
pro_id INT FOREIGN KEY REFERENCES t_product(pro_id),
ven_id INT FOREIGN KEY REFERENCES t_vendor(ven_id),
pur_qty	INT NOT null,
pur_unt_price	numeric(5,2),
pur_date	DATETIME

);



--t_customer
insert into dbo.t_customer values ( 
'1999-01-01 00:00:00.000','123 York Road','','Towson','MD',21252,'joesmith@gmail.com','Joe','Smith','','Dr.')
insert into dbo.t_customer values ( 
'1980-01-01 00:00:00.000','ABC Bld.','','Baltimore','MD',21239,'samdan@yahoo.com','Sam','Daniel','','')
insert into dbo.t_customer values ( 
'1984-01-01 00:00:00.000','2500 Boston St.','','Baltimore','MD',21239,'house@yhotmail.com','Carl','Cox','','')
insert into dbo.t_customer values ( 
'1991-01-01 00:00:00.000','3500 Dillon St.','','Baltimore','MD',21224,'ssan@aol.com','Shiba','San','','')
insert into dbo.t_customer values ( 
'1998-01-01 00:00:00.000','1818 Light St.','','Cherry Hill','MD',21289,'kk@blackbutter.com','Kidnap','Kid','','')

--t_vendor
Insert into dbo.t_vendor values ('TOWSON BREW GUYS','5852 York Road','','Towson','MD',21252,'443-458-8522','towson@gmail.com','Lisa Howard')
Insert into dbo.t_vendor values ('BALTIMORE SODA POP','987 Penn Blvd.','','Baltimore','MD',21239,'443-100-8970','bchill@gmail.com','Jason Doe')
Insert into dbo.t_vendor values ('GIBINO BREWING','123 Brewers Blvd.','','Baltimore','MD',21239,'443-200-8970','gb_brewery@gmail.com','Gib Ino')

--t_type
Insert into dbo.t_type values ('16 OZ BEER BOTTLE',1)
Insert into dbo.t_type values ('12 OZ SODA CAN',0)

--t_product
Insert into dbo.t_product values ('TB-Tiger Tail Ale',525,1,4.50, 1)
Insert into dbo.t_product values ('TB-Uni Lager',325,1,4.50, 1)
Insert into dbo.t_product values ('BSP-Ginger Beer',320,2,2.50, 2)
Insert into dbo.t_product values ('BSP-Root Beer',320,2,2.50, 2)
Insert into dbo.t_product values ('BSP-Orange Soda',320,2,2.50, 2)
Insert into dbo.t_product values ('GB-Primal',180,1,5.00, 3)
Insert into dbo.t_product values ('GB-Hoppy',255,1,6.00, 3)
Insert into dbo.t_product values ('GB-Porter',20,1,5.00, 3)
Insert into dbo.t_product values ('GB-Lager',898,1,5.50, 3)
Insert into dbo.t_product values ('GB-Ale',20,1,5.00, 3)

--t_sales info
--Insert into dbo.t_sales_info values (1,15)
--Insert into dbo.t_sales_info values (2,8)

--t_sales_perc
--Insert into dbo.t_sales_perc values (1,'')
--Insert into dbo.t_sales_perc values (2,'')

--t_price
exec dbo.sp_update_price
--Insert into dbo.t_price values (1,5.50)
--Insert into dbo.t_price values (2,4.00)

--t_pos_sales
--Insert into dbo.t_pos_sales values (11/06/14,15,2,1,5.50,1)
--Insert into dbo.t_pos_sales values (11/11/14,8,1,2,4.00,1)
--Insert into dbo.t_pos_sales values (11/11/14,8,1,2,4.00,0)
--Insert into dbo.t_pos_sales values (11/11/14,7,2,3,5.00,0)
EXEC dbo.sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 6, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 7, @pur_qty = 10, @cus_id = 3, @pos_paid = 0;
EXEC dbo.sp_add_pos_sale @pro_id = 1, @pur_qty = 5, @cus_id = 4, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 3, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 8, @pur_qty = 19, @cus_id = 2, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 5, @pur_qty = 1, @cus_id = 5, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 4, @pur_qty = 2, @cus_id = 1, @pos_paid = 1;
EXEC dbo.sp_add_pos_sale @pro_id = 7, @pur_qty = 19, @cus_id = 4, @pos_paid = 0;
EXEC dbo.sp_add_pos_sale @pro_id = 5, @pur_qty = 1, @cus_id = 5, @pos_paid = 1;


--t_acct_sales
exec sp_update_acct_sales
--Insert into t_acct_sales values ('2014-11-23 17:25:02.650',15,2,1,5.50)
--Insert into t_acct_sales values ('2014-11-22 17:25:02.650',8,1,2,4.00)
--Insert into t_acct_sales values ('2014-11-21 17:25:02.650',15,2,2,5.50)
--Insert into t_acct_sales values ('2014-10-02 17:25:02.650',8,1,2,4.00)
--Insert into t_acct_sales values ('2014-09-23 17:25:02.650',15,2,3,5.50)
--Insert into t_acct_sales values ('2014-11-15 17:25:02.650',8,1,4,4.00)
--Insert into t_acct_sales values ('2014-08-23 17:25:02.650',15,2,5,5.50)
--Insert into t_acct_sales values ('2014-08-23 17:25:02.650',8,1,5,4.00)
--Insert into t_acct_sales values ('2014-08-23 17:25:02.650',15,2,5,5.50)
--Insert into t_acct_sales values ('2014-11-13 17:25:02.650',8,1,2,6.00)
--Insert into t_acct_sales values ('2014-11-13 17:25:02.650',15,2,1,5.50)
--Insert into t_acct_sales values ('2014-11-23 17:25:02.650',8,1,2,4.00)
--Insert into t_acct_sales values ('2014-11-13 17:25:02.650',15,2,1,5.50)
--Insert into t_acct_sales values ('2014-11-12 17:25:02.650',8,1,2,4.00)
--Insert into t_acct_sales values ('2014-11-11 17:25:02.650',15,2,1,5.50)
--Insert into t_acct_sales values ('2014-11-11 17:25:02.650',8,1,2,4.00)
--Insert into t_acct_sales values ('2014-11-11 17:25:02.650',15,2,1,5.50)
--Insert into t_acct_sales values ('2014-11-11 17:25:02.650',8,1,2,4.00)

--t_purchase
Insert into dbo.t_purchase values (2,1,425,3.5,getdate())
Insert into dbo.t_purchase values (1,2,240,1.75,getdate())
Insert into dbo.t_purchase values (3,3,240,1.75,getdate())
Insert into dbo.t_purchase values (4,3,240,2.50,getdate())
Insert into dbo.t_purchase values (5,3,240,3.00,getdate())
Insert into dbo.t_purchase values (6,3,240,3.50,getdate())
Insert into dbo.t_purchase values (7,3,240,2.25,getdate())
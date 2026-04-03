/*
Script purpose:
---------------

- creating database called datawarehouseanalysis
- creating three tables called dim_customers , dim_products and fact_sales
- load data into table from local 

we have to analyses based on these three tables 
*/

create database datawarehouseanalysis;


-- creating dim_customer table in database

create table dim_customers(
	customer_key int,
	customer_id int,
	customer_number nvarchar(50),
	first_name nvarchar(50),
	last_name nvarchar(50),
	country nvarchar(50),
	marital_status nvarchar(50),
	gender nvarchar(50),
	birthdate date,
	create_date date
	);

-- load the data into dim_customers 

	bulk insert dbo.dim_customers 
	from 'C:\Users\pnave\OneDrive\Desktop\sql_project_data_analytics\files\dim_customers.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)

-- creating table dim_products 
	create table dim_products(
		product_key int,
		product_id int, 
		product_number nvarchar(50),
		product_name nvarchar(50),
		category_id nvarchar(50),
		category nvarchar(50),
		subcategory nvarchar(50),
		maintenacne nvarchar(10),
		cost int,
		product_line nvarchar(50),
		"start_date" date
		)

-- loading records into dim_products 

	bulk insert dbo.dim_products 
	from 'C:\Users\pnave\OneDrive\Desktop\sql_project_data_analytics\files\dim_products.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)


-- creating table 
	create table fact_sales(
		order_number nvarchar(50),
		product_key int,
		customer_key int,
		order_date date,
		shipping_date date,
		due_date date,
		sales_amount int,
		quantity int,
		price int
		)
-- loading records into 

	bulk insert dbo.fact_sales 
	from 'C:\Users\pnave\OneDrive\Desktop\sql_project_data_analytics\files\fact_sales.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		)

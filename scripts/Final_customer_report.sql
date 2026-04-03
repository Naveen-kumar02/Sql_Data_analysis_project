/*
customer reports:
----------------

Purpose: This report consolidates key customers metrics and behaviours about the customers 

Highlight
1) Gather essential fields such as names, ages and transaction details,
2) segments customer into categorues (Vip, Regular, New) and age group,
3) aggregated customer - level metrices
	- total orders
	- total sales
	- total quantity purchased
	- total prducts 
	- lifespan (in months)

4) Calculates valuable KPI
	- recency (months since last order)
	- average order value
	- average monthly spend
*/


with cte as(
select 
	s.order_number as order_number,
	s.product_key as product_key,
	s.order_date as order_date,
	s.sales_amount as sales_amount,
	s.quantity as quantity,
	c.customer_key as customer_key,
	c.customer_number as customer_number,
	concat(c.first_name,' ',c.last_name) as customer_name,
	datediff(year,c.birthdate, getdate()) as age
from dim_customers c 
left join fact_sales s 
on c.customer_key = s.customer_key
where s.order_date is not null),
customer_aggregation as(
select 
	customer_key,
	customer_number,
	customer_name,
	age,
	count(distinct(order_number)) as total_orders,
	sum(sales_amount) as total_sales, 
	sum(quantity) as total_quantity,
	count(distinct(product_key)) as total_products,
	max(order_date) as last_order_date,
	datediff(month,min(order_date),max(order_date)) as lifespan
from cte 
group by customer_key, customer_number, customer_name, age)
select 
	customer_key,
	customer_number,
	customer_name,
	age,
	case when age < 20 then 'under 20'
		 when age between 20 and 29 then '20 - 29'
		 when age between 30 and 39 then '30 - 39'
		 when age between 40 and 49 then '40-49'
		 else '50 and above' end as age_segment,
	case when lifespan >= 12 and total_sales > 5000 then 'VIP'
		 when lifespan >= 12 and total_sales <= 5000 then 'Regular'
		 else 'New'
	end as customer_segment,
	datediff(month,last_order_date,getdate()) as recently,
	total_orders,
	total_sales,
	total_quantity,
	total_products,
	lifespan,
	-- compute average order value(AVO) 
	case when total_sales = 0 then 0
		else total_sales / total_orders end as avg_order_value,

	-- compute average monthly spend 
	case when lifespan = 0 then total_sales 
		 else total_sales / lifespan end as avg_monthly_spend
from customer_aggregation 


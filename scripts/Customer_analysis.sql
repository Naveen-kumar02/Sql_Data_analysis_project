

-- change over time analysis 
select 
	DATETRUNC(month,order_date) as order_date,
	sum(sales_amount) as total_sales,
	count(distinct(customer_key)) as total_customer,
	sum(quantity) as total_quantity
from fact_sales
where order_date is not null 
group by DATETRUNC(month,order_date)
order by DATETRUNC(month,order_date);

-- cummulative analysis over year

select 
	order_date,
	total_sales,
	sum(total_sales) over(order by order_date) as running_total_sales 
from(
select 
	DATETRUNC(year,order_date) as order_date,
	sum(sales_amount) as total_sales
from fact_sales 
where order_date is not null
group by DATETRUNC(year,order_date))t

-- moving average over year


select 
	order_date,
	total_sales,
	avg(avg_price) over(order by order_date) as moving_average 
from(
select 
	DATETRUNC(year,order_date) as order_date,
	sum(sales_amount) as total_sales,
	avg(price) as avg_price
from fact_sales 
where order_date is not null
group by DATETRUNC(year,order_date))t


-- Performance analysis 

with yearly_sales as (
select 
	year(order_date) as order_year,
	p.product_name as product_name,
	sum(sales_amount) as current_sales
from fact_sales s  
left join dim_products p
on s.product_key = p.product_key
where order_date is not null
group by year(order_date),p.product_name)
select 
	order_year,
	product_name,
	current_sales, 
	avg(current_sales) over(partition by product_name) as average_sales,
	current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
	case when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'above avg'
		when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'below avg'
		else 'avg' end as avg_indicator,
	-- year over year analysis
	lag(current_sales) over(partition by product_name order by order_year asc) as privious_sales,
	current_sales - lag(current_sales) over(partition by product_name order by order_year asc) as diff_sales,
	case when current_Sales - lag(current_sales) over(partition by product_name order by order_year asc) > 0 then 'Increase'
		 when current_Sales - lag(current_sales) over(partition by product_name order by order_year asc) < 0 then 'Decrease'
		 else 'No change'end as privious_sales_indicator
from yearly_sales
order by product_name,order_year;

-- part to whole analysis 

with category_sales as(
select 
	category,
	sum(sales_amount) as total_sales
from fact_sales s
left join dim_products p 
on s.product_key = p.product_key 
group by category)
select 
	category,
	total_sales,
	sum(total_sales) over() as overall_sales,
	concat(round((cast (total_sales as FLOAT)/sum(total_sales) over())*100,2), '%') as percentage_contribution
from category_sales
group by category,total_sales
order by percentage_contribution desc;

-- data segmentation 

with product_Segment as(
select 
	product_key,
	product_name,
	cost,
	case when cost < 100 then 'Below 100'
		 when cost between 100 and 500 then '100-500'
		 when cost between 500 and 1000 then '500-1000'
		 else 'Above 1000' 
	end as cost_segmentation
from dim_products)
select 
	cost_segmentation,
	count(*) as total_product_per_range
from product_Segment
group by cost_segmentation 
order by total_product_per_range desc;



with customer_details as(
select 
	c.customer_key as customer_key,
	sum(s.sales_amount) as total_spending,
	min(order_date) as first_order,
	max(order_date) as last_order,
	datediff(month,min(order_date),max(order_date)) as lifespan
from fact_sales s 
left join dim_customers c 
on c.customer_key = s.customer_key 
group by c.customer_key)
select customer_segmentation, count(customer_key) as total_customer_per_segment
from(
select 
	customer_key,
	case when total_spending > 5000 and lifespan >= 12 then 'VIP Customer'
		 when total_spending <= 5000 and lifespan >= 12 then 'Regular customer'
		 else 'New customer' 
		 end as customer_segmentation
from customer_details) t
group by customer_segmentation
order by total_customer_per_segment desc;

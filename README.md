# Sql_Data_analysis_project

## Problem Statement

Analyze a structured retail dataset to uncover sales trends, product 
performance, and customer behavior — culminating in a Final Customer 
Report that segments and classifies customers for business decision-making.

## 🗄️ Database Schema

### `dim_customers`
`customer_key` `customer_id` `customer_number` `first_name` `last_name` `country` `marital_status` `gender` `birthdate` `order_date`

### `dim_products`
`product_key` `product_id` `product_name` `category_id` `category` `subcategory` `maintenance` `cost` `product_line` `start_date`

### `fact_sales`
`order_number` `product_key` `customer_key` `order_date` `shipping_date` `due_date` `sales_amount` `quantity` `price`


## Analysis 
#### 1. Change Over Time Analysis
Tracks how total sales, customer count, and quantity ordered have evolved over time to identify growth trends and seasonal patterns.

**Output:** `order_date` `total_sales` `total_customer` `total_quantity`

#### 1. Cummulative Analysis
Measures running total of sales over the years to understand whether the business is growing or declining over time.

**Output:** `order_date` `total_sales` `running_total_sales`



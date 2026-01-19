/*
E-commerce Data Exploration 
*/


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--1. Database Exploration 

--All objects in database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--All columns in database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_customers'


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--2. Dimension Exploration 
--Explore countries where customer comes from
SELECT DISTINCT country FROM gold.dim_customers

--Category of products exploration 
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--3. Date Exploration 
--Date of first and last order
SELECT MIN(order_date) AS first_order, 
MAX(order_date) AS last_order 
FROM gold.fact_sales

--Months of sales
SELECT MIN(order_date) AS first_order, 
MAX(order_date) AS last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) as months_sales
FROM gold.fact_sales

--Oldest and youngest customer
SELECT MIN(birthdate) AS youngest_customer,
MAX(birthdate) AS oldest_customer
FROM gold.dim_customers

--Age of oldest and youngest customer
SELECT 
MIN(birthdate) AS youngest_customer,
DATEDIFF(year, MIN(birthdate), GETDATE()) AS youngest_age,
MAX(birthdate) AS oldest_customer,
DATEDIFF(year, MAX(birthdate), GETDATE()) AS oldest_age
FROM gold.dim_customers


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--4. Measures Exploration 
-- Total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

-- Total items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

-- Total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_name) AS total_products FROM gold.dim_products

-- Total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers

-- Total number of customers that placed an order
SELECT COUNT(customer_key) AS total_customers FROM gold.fact_sales

-- Summary of measures
SELECT 'Total sales' as measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total items', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total products', COUNT(product_name) FROM gold.dim_products
UNION ALL
SELECT 'Total customers', COUNT(customer_key) FROM gold.dim_customers


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--5. Magnitude Exploration 

-- Total customers by countries
SELECT country, COUNT(customer_key) AS total_customers 
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

-- Total customers by gender
SELECT gender, COUNT(customer_key) AS total_customers 
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- Total products by category
SELECT category, COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- Average costs of each category
SELECT category, AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY avg_cost DESC

-- Revenue by each category
SELECT p.category, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

-- Revenue by each customer
SELECT c.customer_key, c.first_name, c.last_name, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC

-- Distribution of sold items across countries
SELECT c.country, SUM(f.sales_amount) total_items_sold
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_items_sold DESC


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--6. Ranking Exploration 

-- 5 products with highest revenue
SELECT TOP 5 p.product_name, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- 5 products with worst revenue
SELECT TOP 5 p.product_name, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue

-- 5 subcategory with highest revenue
SELECT TOP 5 p.subcategory, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC

-- 5 subcategory with worst revenue
SELECT TOP 5 p.subcategory, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY total_revenue

-- 10 customers with highest revenue
SELECT TOP 10 c.first_name, c.last_name, SUM(f.sales_amount) total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.first_name, c.last_name
ORDER BY total_revenue DESC


-- 3 customers with fewest orders
SELECT TOP 3 c.first_name, c.last_name, COUNT(DISTINCT f.order_number) AS total_order
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.first_name, c.last_name
ORDER BY total_order
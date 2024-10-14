--Create a customer table--
create table customer (
customer_id varchar,
customer_name varchar,
segment varchar,
age int,
country varchar,
city varchar,
state varchar,
postal_code int,
region varchar
);


---laod the data into the customer table using the copy command---
copy customer
from 'C:\Program Files\PostgreSQL\Customer.csv' delimiter ',' csv header


----validate the table---
select *
from customer



---Sales Table--
create table Sales (
Order_Line int,
Order_ID varchar,
Order_Date date,
Ship_Date date,
Ship_Mode varchar,
Customer_ID varchar,
Product_ID varchar,
Sales decimal,
Quantity int,
Discount decimal,
Profit decimal
);



select *
from sales



---load the data into the customer table using the copy command---
copy sales
from 'C:\Program Files\PostgreSQL\sales.csv' delimiter ',' csv header




---Product Table---
create table Product(
   Product_ID varchar,
   Category varchar,
   Sub_Category varchar,
   Product_Name varchar
);


SET client_encoding = 'WIN1252';


select *
from Product


---load the data into the product table using the copy command---
copy Product
from 'C:\Program Files\PostgreSQL\Product.csv' delimiter ',' csv header





--1--List the top 5 products by sales in the last 6 years
WITH last_six_years AS (
  SELECT * FROM sales WHERE order_date >= current_date - INTERVAL '6 years'
)
SELECT product_name, SUM(sales) AS total_sales
FROM last_six_years
JOIN product ON last_six_years.product_id = product.product_id
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;


--2--List the number of customers by age segment in the last 7 years:
WITH last_7_year AS (
  SELECT * FROM sales WHERE order_date >= current_date - INTERVAL '7 year'
)
SELECT segment, COUNT(DISTINCT customer.customer_id) AS total_customers
FROM customer
JOIN last_7_year ON customer.customer_id = last_7_year.customer_id
GROUP BY segment;



--3--List the top 3 regions by average profit per sale
WITH sale_profit AS (
  SELECT order_id, profit, region FROM sales
  JOIN customer ON sales.customer_id = customer.customer_id
)
SELECT region, AVG(profit) AS avg_profit
FROM sale_profit
GROUP BY region
ORDER BY avg_profit DESC
LIMIT 3;



--4--List the top 5 products by sales in the last month, including their sales in the previous month
WITH last_month_sales AS (
  SELECT * FROM sales WHERE order_date >= current_date - INTERVAL '1 month'
  AND order_date < current_date - INTERVAL '1 day'
),
previous_month_sales AS (
  SELECT * FROM sales WHERE order_date >= current_date - INTERVAL '2 months'
  AND order_date < current_date - INTERVAL '1 month'
)
SELECT product_name, SUM(last_month_sales.sales) AS last_month_sales,
SUM(previous_month_sales.sales) AS previous_month_sales
FROM last_month_sales
JOIN product ON last_month_sales.product_id = product.product_id
JOIN previous_month_sales ON last_month_sales.product_id = previous_month_sales.product_id
GROUP BY product_name
ORDER BY last_month_sales DESC
LIMIT 5;




--5--List the customers who had the highest sales in the last year:
WITH last_year_sales AS (
  SELECT customer_id, SUM(sales) AS total_sales
  FROM sales
  WHERE order_date >= current_date - INTERVAL '1 year'
  GROUP BY customer_id
)
SELECT customer_name, total_sales
FROM customer
JOIN last_year_sales ON customer.customer_id = last_year_sales.customer_id
ORDER BY total_sales DESC
LIMIT 10;




--6--List the percentage of total sales for each subcategory in the last 6 years:
WITH last_six_years AS (
  SELECT * FROM sales WHERE order_date >= current_date - INTERVAL '6 years'
)
SELECT sub_category, SUM(sales) / (SELECT SUM(sales) FROM last_six_years) * 100 AS sales_percentage
FROM last_six_years
JOIN product ON last_six_years.product_id = product.product_id
GROUP BY sub_category
ORDER BY sales_percentage DESC;



--7--List the top 5 customers by the number of orders they made in the last year:
WITH last_year_orders AS (
  SELECT customer_id, COUNT(DISTINCT order_id) AS total_orders
  FROM sales
  WHERE order_date >= current_date - INTERVAL '1 year'
  GROUP BY customer_id
)
SELECT customer_name, total_orders
FROM customer
JOIN last_year_orders ON customer.customer_id = last_year_orders.customer_id
ORDER BY total_orders






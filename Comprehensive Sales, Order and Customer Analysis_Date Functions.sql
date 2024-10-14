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




--Date Functions--

--1--Calculate the total sales for each month of the current year
SELECT to_char(order_date, 'YYYY-MM') AS month, SUM(sales) AS total_sales
FROM sales
WHERE order_date >= date_trunc('year', current_date)
GROUP BY month
ORDER BY month;


--2--Find the top 5 customers with the highest sales in the last 6 years:
SELECT customer_name, SUM(sales) AS total_sales
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
WHERE order_date >= current_date - INTERVAL '6 years'
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 5;


--3--Calculate the total sales for each category and subcategory in the last 7 years
SELECT category, sub_category, SUM(sales) AS total_sales
FROM sales
JOIN product ON sales.product_id = product.product_id
WHERE order_date >= current_date - INTERVAL '7 year'
GROUP BY 1,2;


--4--Find the number of orders shipped in each month of the current year
SELECT to_char(ship_date, 'YYYY-MM') AS month, COUNT(*) AS num_orders
FROM sales
WHERE ship_date >= date_trunc('year', current_date)
GROUP BY month
ORDER BY month;


--5--Find the top 10 products with the highest profit margin in the last 6 years
SELECT product_name, (SUM(profit) / SUM(sales)) AS profit_margin
FROM sales
JOIN product ON sales.product_id = product.product_id
WHERE order_date >= current_date - INTERVAL '6 years'
GROUP BY product_name
ORDER BY profit_margin DESC
LIMIT 10;



--6--Calculate the total sales for each region in the last 8 year
SELECT region, SUM(sales) AS total_sales
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
WHERE order_date >= current_date - INTERVAL '8 year'
GROUP BY region;


--7--Find the top 5 customers with the highest number of orders in the last month:
SELECT customer_name, COUNT(*) AS num_orders
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
WHERE order_date >= current_date - INTERVAL '1 month'
GROUP BY customer_name
ORDER BY num_orders DESC
LIMIT 5;


--8--Calculate the total sales for each state in the current year
SELECT state, SUM(sales) AS total_sales
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
WHERE order_date >= date_trunc('year', current_date)
GROUP BY state;


--9--Find the average discount for each category and subcategory
SELECT category, sub_category, AVG(discount) AS average_discount
FROM sales
JOIN product ON sales.product_id = product.product_id
GROUP BY category, sub_category;


--10--Find the total sales and profits for each segment between the earliest and latest order date
SELECT c.segment, SUM(s.sales) AS total_sales, SUM(s.profit) AS total_profit
FROM customer c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.order_date >= (SELECT MIN(order_date) FROM sales)
  AND s.order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY c.segment
HAVING SUM(s.sales) > 10000



--11--Find the top 5 products with the highest sales between the earliest and latest order date
SELECT c.segment, SUM(s.sales) AS total_sales, SUM(s.profit) AS total_profit
FROM customer c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.order_date >= (SELECT MIN(order_date) FROM sales)
  AND s.order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY c.segment
HAVING SUM(s.sales) > 10000


--12-- Find the number of orders shipped by each city between the earliest and latest order date
SELECT c.city, COUNT(DISTINCT s.order_id) AS total_orders
FROM customer c
JOIN sales s ON c.customer_id = s.customer_id
WHERE s.order_date >= (SELECT MIN(order_date) FROM sales)
  AND s.order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY c.city
HAVING COUNT(DISTINCT s.order_id) > 50


--13--Display Order analysis by year
SELECT 
  to_char(order_date, 'YYYY') AS year,
  COUNT(DISTINCT sales.order_id) AS total_orders,
  COUNT(DISTINCT sales.customer_id) AS total_customers,
  SUM(sales.sales) AS total_sales,
  AVG(sales.profit) AS avg_profit
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
JOIN product ON sales.product_id = product.product_id
WHERE order_date >= (SELECT MIN(order_date) FROM sales)
  AND order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY year
ORDER BY year;



--14--Order analysis by country and region
SELECT 
  customer.country,
  customer.region,
  COUNT(DISTINCT sales.order_id) AS total_orders,
  COUNT(DISTINCT sales.customer_id) AS total_customers,
  SUM(sales.sales) AS total_sales,
  AVG(sales.profit) AS avg_profit
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
JOIN product ON sales.product_id = product.product_id
WHERE order_date >= (SELECT MIN(order_date) FROM sales)
  AND order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY customer.country, customer.region
ORDER BY customer.country, customer.region;


--15--Order analysis by product category and sub-category
SELECT 
  product.category,
  product.sub_category,
  COUNT(DISTINCT sales.order_id) AS total_orders,
  COUNT(DISTINCT sales.customer_id) AS total_customers,
  SUM(sales.sales) AS total_sales,
  AVG(sales.profit) AS avg_profit
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
JOIN product ON sales.product_id = product.product_id
WHERE order_date >= (SELECT MIN(order_date) FROM sales)
  AND order_date <= (SELECT MAX(order_date) FROM sales)
GROUP BY product.category, product.sub_category
ORDER BY product.category, product.sub_category;


--16--find the top 10 products with the highest profit margin in the last 6 years, extract the year and month name from the date into new columns
SELECT p.product_id, p.product_name, SUM(s.profit) AS total_profit,
       SUM(s.sales) AS total_sales,
       (SUM(s.profit) / SUM(s.sales)) AS profit_margin,
       EXTRACT(YEAR FROM s.order_date) AS order_year,---used to extract month number
       TO_CHAR(s.order_date, 'Month') AS order_month_name----used to extraxt month name
FROM product p
JOIN sales s ON p.product_id = s.product_id
WHERE s.order_date >= CURRENT_DATE - INTERVAL '6 years'---used to fetch paste date
GROUP BY p.product_id, p.product_name, order_year, order_month_name
ORDER BY profit_margin DESC
LIMIT 10;



--17--find the most discounted products by month name for all products sold in 2017,
SELECT p.product_id, p.product_name, 
       EXTRACT(MONTH FROM s.order_date) AS order_month,
	   TO_CHAR(s.order_date, 'Month') AS order_month_name,
       MAX(s.discount) AS max_discount
FROM product p
JOIN sales s ON p.product_id = s.product_id
WHERE EXTRACT(YEAR FROM s.order_date) = 2017
GROUP BY p.product_id, p.product_name, order_month, order_month_name
ORDER BY order_month, max_discount DESC;



--18--find the most profitable products by month name for all products sold in the last 7 years
SELECT p.product_id, p.product_name, 
       TO_CHAR(s.order_date, 'Month') AS order_month_name,
       SUM(s.profit) AS total_profit
FROM product p
JOIN sales s ON p.product_id = s.product_id
WHERE s.order_date >= CURRENT_DATE - INTERVAL '7 years'
GROUP BY 1,2,3
ORDER BY 2,3 DESC;



--19--find the orders that were shipped out after 3 days by month name, and list the ship_mode and total sales per order for customers above 30 years who purchased more than 2 times--
SELECT TO_CHAR(s.order_date, 'Month') AS order_month_name,
       s.ship_mode,
       s.order_id,
       SUM(s.sales) AS total_sales_per_order
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id
WHERE EXTRACT(DAY FROM AGE(s.ship_date, s.order_date)) > 3
  AND c.age > 30
GROUP BY order_month_name, s.ship_mode, s.order_id
HAVING COUNT(DISTINCT s.order_id) > 2
ORDER BY order_month_name, total_sales_per_order DESC;




--20--find the orders that were shipped after 2017 and list the ship_mode and total sales per order for customers who ordered more than 3 times
SELECT s.ship_mode,
       s.order_id,
       SUM(s.sales) AS total_sales_per_order
FROM sales s
JOIN customer c ON s.customer_id = c.customer_id

--WHERE s.ship_date > DATE '2017-01-01'
GROUP BY s.ship_mode, s.order_id
HAVING COUNT(DISTINCT s.order_id) > 2
ORDER BY total_sales_per_order DESC;













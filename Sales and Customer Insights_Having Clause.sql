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




--Having Command

--1-- Retrieve the total sales for each customer, but only include customers with a total sales value greater than $5000
SELECT customer_id, SUM(sales) AS total_sales
FROM sales
GROUP BY customer_id
HAVING SUM(sales) > 5000;


--2---Find the average age of customers in each country, but only display countries where the average age is above 30:
SELECT country, AVG(age) AS average_age
FROM customer
GROUP BY country
HAVING AVG(age) > 30;


--3--Get the count of products in each category, but only include categories with more than 10 products:
SELECT category, COUNT(*) AS product_count
FROM product
GROUP BY 1
HAVING COUNT(*) > 10;


--4--Retrieve the names of customers who have placed at least 3 orders, but only display customers in a specific region:West
SELECT customer_name, COUNT(customer.customer_id) AS order_count
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
WHERE region = 'West'
GROUP BY customer_name
HAVING COUNT(customer.customer_id) >= 3;


---5--Find the total sales and profit for each product, but only include products with a profit margin greater than 20%:
SELECT product_id, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM sales
GROUP BY product_id
HAVING SUM(profit) / SUM(sales) > 0.2;


--6--Retrieve the average quantity and discount for each product category, but only include categories where the average quantity is above 50 and the average discount is below 0.1:
SELECT category, AVG(quantity) AS average_quantity, AVG(discount) AS average_discount
FROM sales
JOIN product ON sales.product_id = product.product_id
GROUP BY 1
HAVING AVG(quantity) > 6 AND AVG(discount) < 0.2;

select *
from sales

--7--Find the total sales for each state, but only include states with a total sales value greater than $10000:
SELECT state, SUM(sales) AS total_sales
FROM sales
JOIN customer ON sales.customer_id = customer.customer_id
GROUP BY state
HAVING SUM(sales) > 10000;


--8--Retrieve the count of orders for each ship mode, but only include ship modes with more than 100 orders:
SELECT ship_mode, COUNT(*) AS order_count
FROM sales
GROUP BY ship_mode
HAVING COUNT(*) > 100;









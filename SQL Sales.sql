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

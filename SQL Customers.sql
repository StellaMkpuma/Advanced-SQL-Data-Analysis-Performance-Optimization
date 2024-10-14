--To create a customer table--
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
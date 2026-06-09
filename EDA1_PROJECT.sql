create database sql_project; 

use sql_project;
 
 create table retail_sales(
 transactions_id int primary key,	
 sale_date	date,
 sale_time	time,
 customer_id int,	
 gender	varchar(15),
 age int,
 category varchar(15),	
 quantiy int,	
 price_per_unit float,	
 cogs float,	
 total_sale float
); 

select * from retail_sales;

select count(*) from retail_sales;

select * from retail_sales
transaction_id,

sale_time,
customer_id,
gender,
age,
category,
quantiy,
price_per_unit,
cogs,
total_sale
where transactions_id is null

or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

select distinct * from retail_sales;
select sale_date from retail_sales;

show table status;

select database();

show databases;
use sql_project;

show tables;

select * from retail_sales;

describe retail_sales;

show columns from retail_sales;

select COUNT(*)
from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

set sql_safe_updates = 0;

delete from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

# DATA EXPLORATION

#how many sales we have?
SELECT COUNT(*) as TOTAL_SALES FROM retail_sales;

#HOW MANY CUSTOMERS WE HAVE?
SELECT COUNT(distinct(CUSTOMER_ID)) AS TOTAL_CUSTOMER FROM RETAIL_SALES;

#HOW MANY CATEGORIES WE HAVE ?
SELECT distinct(CATEGORY) FROM RETAIL_SALES;

#DATA ANALYSIS AND BUSINESS KEY PROBLEMS & ANSWERS

#Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM RETAIL_SALES 
WHERE SALE_DATE = '2022-11-05' ;

#Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales
where category ="Clothing"
and quantiy >= 4
and month(sale_date) =11
and year(sale_date) = 2022;

#Write a SQL query to calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale)
from retail_sales
group by category;

#Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select
round(avg(age),2) 
from retail_sales
where category="Beauty" ;

#Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales 
where total_sale > 1000;

# Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select 
gender,
category,
count(transactions_id) 
from retail_sales
group by gender,
category;

#Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
year,
month,
avg_sales
from
(
select
year(sale_date) as YEAR ,
month(sale_date) as month,
avg(total_sale) as avg_sales,
rank() over(partition by year(sale_date) order by avg(total_sale) desc ) as ranking
from retail_sales
group by YEAR,
 month
 ) as t1 
 where ranking = 1; 
    
#Write a SQL query to find the top 5 customers based on the highest total sales
select 
customer_id,
sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale)  desc
limit 5;

#Write a SQL query to find the number of unique customers who purchased items from each category
select 
category, 
count(distinct(customer_id)) as customer
from retail_sales
group by category;

#Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as 
( 
select *,
case
when hour(sale_time) < 12 then "Morning"
when hour(sale_time) between 12 and 17 then "Afternoon"
else "evening"
end as shift
from retail_sales
)
select 
shift ,
count(*) as total_order
from hourly_sale
group by shift;

# END OF PROJECT 




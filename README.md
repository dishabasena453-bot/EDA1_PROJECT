**Project Overview**
This project focuses on performing an end-to-end **Exploratory Data Analysis (EDA)** and data cleaning process on a retail sales dataset using MySQL. The project transitions raw transactional data into structured insights, tackling key business performance questions, customer demographics, and purchasing behaviour 

***Project Objectives**
1. Data Cleaning & Wrangling: Identify and remove record anomalies, null values, and ensure structural integrity.
2. Data Exploration: Understand the scale of the dataset, count total customer bases, and define product variety.
3. Business Intelligence & Analytics: Write complex SQL queries (including aggregations, window functions, and Common Table Expressions) to solve realistic retail challenges and derive actionable performance insights.

**1 DATABASE SETUP**
'''sql
create database sql_project;

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

**DATA EXPLORATION AND CLEANING*8
select count(*) from retail_sales;
select distinct * from retail_sales;
describe retail_sales;
SELECT COUNT(distinct(CUSTOMER_ID)) AS TOTAL_CUSTOMER FROM RETAIL_SALES;


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
'''


**DATA ANALYSING AND FINDINGS**
The following SQL queries were developed to answer specific business questions:

**Write a SQL query to retrieve all columns for sales made on '2022-11-05'**
'''sql
SELECT * FROM RETAIL_SALES 
WHERE SALE_DATE = '2022-11-05' ;
'''

**Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:**
''' sql
select * from retail_sales
where category ="Clothing"
and quantiy >= 4
and month(sale_date) =11
and year(sale_date) = 2022;
'''

**Write a SQL query to calculate the total sales (total_sale) for each category.**
''' sql
select 
category,
sum(total_sale)
from retail_sales
group by category;
'''

**Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**
'''sql
select
round(avg(age),2) 
from retail_sales
where category="Beauty" ;
'''

**Write a SQL query to find all transactions where the total_sale is greater than 1000.**
''' sql
select * from retail_sales 
where total_sale > 1000;
'''

** Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**
''' sql
select 
gender,
category,
count(transactions_id) 
from retail_sales
group by gender,
category;
'''

**Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
'''sql
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
 '''


**Write a SQL query to find the top 5 customers based on the highest total sales**
''' sql
select 
customer_id,
sum(total_sale)
from retail_sales
group by customer_id
order by sum(total_sale)  desc
limit 5;
'''


**Write a SQL query to find the number of unique customers who purchased items from each category**
''' sql
select 
category, 
count(distinct(customer_id)) as customer
from retail_sales
group by category;
'''

**Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
'''sql
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
'''



**Findings**
Data Quality: Cleaned the dataset by systematically removing records with missing values across critical tracking attributes like transaction IDs and customer details.

Sales Drivers: Identified cumulative revenue totals for each product category and isolated the specific average age of consumers purchasing from the Beauty segment.

Peak Trends: Captured high-volume bulk purchases in the Clothing section and isolated the highest-performing sales month for each fiscal year using window functions.

Customer & Time Metrics: Tracked the store's top 5 elite spenders and categorized overall order traffic into specific Morning, Afternoon, and Evening shifts.

**Conclusions**
Targeted Marketing: Demographic insights like customer age and gender-to-category volume splits allow teams to replace generic ads with highly optimized, data-driven campaigns.

Staffing Optimization: Grouping transaction volumes by hourly shifts enables management to align workforce scheduling perfectly with peak customer traffic windows.

Inventory Control: Isolating the best-selling month per year helps supply chain managers accurately predict and ramp up stock levels ahead of seasonal demand spikes.

Retention Strategy: Pinpointing the highest-grossing individual customers and transactions over $1,000 establishes an instant foundation for a premium loyalty program to maximize lifetime value.


#Project-Retail-Sales-Analysis-P1
create database Retail_Sales_Analysis_SQL_Project_P1;

use Retail_Sales_Analysis_SQL_Project_P1;
#Create Table
Create Table retail_sales
(
transactions_id	int,
sale_date	date,
sale_time	time,
customer_id	int,
gender	varchar(50),
age	int,
category varchar(50),
quantiy	int,
price_per_unit	float,
cogs	float,
total_sale float

);

select * from retail_sales;

#count no. of columns
select
 count(*)
from retail_sales;

# funding null value in table

select * from retail_sales
where 
     transactions_id is null
     or
     sale_date	is null
     or
     sale_time	is null
     or
     customer_id	is null
     or
     gender	is null
     or
     age	is null
     or
     category is null
     or
     quantiy  is null
     or
     price_per_unit	is null
     or
     cogs is null
     or
     total_sale is null;

     # deleting null rows
     
     DELETE from retail_sales
     where 
     transactions_id is null
     or
     sale_date	is null
     or
     sale_time	is null
     or
     customer_id	is null
     or
     gender	is null
     or
     age	is null
     or
     category is null
     or
     quantiy  is null
     or
     price_per_unit	is null
     or
     cogs is null
     or
     total_sale is null;

   # off safe mode to update/delete table  
SET SQL_SAFE_UPDATES = 0;

# check after updating
select
 count(*)
from retail_sales;

# Data exploration

#how many sales we have?

select count(*) 
As total_sales 
from retail_sales;

#how many uniuqe customers we have?

select count(distinct customer_id) 
as total_customer
from retail_sales;

#how many uniuqe customers we have?

select distinct category
as category_name
from retail_sales;


/* Data Analysis & Business Ley Problems & Answers
The following SQL queries were developed to answer specific business questions:

1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
   the quantity sold is more than 4 in the month of Nov-2022:
3. Write a SQL query to calculate the total sales (total_sale) for each category.:
4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
9. Write a SQL query to find the number of unique customers who purchased items from each category.:
10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17): */


#1. Write a SQL query to retrieve all columns for sales made on '2022-11-22:

Select *
from retail_sales
where sale_date = '2022-11-22';


/*2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
   the quantity sold is more than 4 in the month of Nov-2022:*/
             
		select category,
          Sum(quantiy)
          From retail_sales
          Where category = 'Clothing';
          
		 Select *
          From retail_sales
          Where category = 'Clothing'
          and DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
          and quantiy >=4;
		
        
	#3. Write a SQL query to calculate the total sales (total_sale) for each category.:
    
    select category,
          Sum(quantiy)
          From retail_sales
          group by 1;
          
	#4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

Select category,
 round(avg(age),2) as avg_age_customers
From  retail_sales
where category ='Beauty';

#5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

Select * From  retail_sales
where total_sale > 1000;

/*6. Write a SQL query to find the total number of transactions (transaction_id) made by each
 gender in each category.: */

select gender,category,
count(*)  as total_transactions
From  retail_sales
group by gender,category
order by 1;


/*7. Write a SQL query to calculate the average sale 
for each month. Find out best selling
 month in each year:*/


SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as 'rank'
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE 'rank' = 1;


#8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

Select customer_id,
sum(total_sale)
From retail_sales
group by 1
order by 2 desc
limit 5;


#9. Write a SQL query to find the number of unique customers who purchased items from each category.:

Select category,
count(distinct customer_id) as unique_customers
from retail_sales
group by category;

#10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17): */

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
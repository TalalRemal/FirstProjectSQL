-- creating the Database
create database sql_firstproject_talal;

-- creating the tables
-- also wanna make sure if table does exist already so i will write this code
DROP TABLE IF EXISTS retail_talal_sales;
CREATE TABLE retail_talal_sales
      (
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender varchar(15),
age INT,
category varchar(15),
quantiy INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
);

select * from retail_talal_sales
-- checking if the count of rows is correct
select count(*) from retail_talal_sales

-- removing and checking and cleaning the dataset
select * from retail_talal_sales
where transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or 
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null

----
delete from retail_talal_sales
where transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or 
	age is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- data exploration 

-- How many Sales we have ?
select count(*) as total_sale from retail_talal_sales

-- How many Unique Customers we have ?
select count(distinct customer_id) as UniqueCustomers from retail_talal_sales

select distinct category from retail_talal_sales

-- Data Analytics Business Key Problems & Answers

--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
select sale_date from retail_talal_sales
where sale_date = '2022-11-05'

--Q2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from retail_talal_sales
where 
category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND Quantiy >=4

--Q3.Write a SQL query to calculate the total sales (total_sale) for each category
select
category,
sum(total_sale) as net_sale ,
count(*) as total_orders
from retail_talal_sales
Group by 1

--Q4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age), 2) as AverageAge from retail_talal_sales
where category = 'Beauty'

--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_talal_sales
where total_sale >= 1000

--Q6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_talal_sales
GROUP 
    BY 
    category,
    gender
--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
select * from retail_talal_sales

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
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_talal_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1

--Q8.Write a SQL query to find the top 5 customers based on the highest total sales.
select customer_id, sum(total_sale) as total_sale
from retail_talal_sales
group by 1
order by 2 desc

--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.
select category, COUNT(DISTINCT customer_id) as cnt_unique_cs
from retail_talal_sales
group by category

--Q10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale AS
(
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_talal_sales
)
SELECT
shift,
COUNT(transactions_id) as total_orders
FROM hourly_sale
GROUP BY shift;


create database retail_sales;

use retail_sales;

select count(*) from retail_sale_table;
select count(distinct customer_id) from retail_sale_table;
select distinct category from retail_sale_table;

select *from retail_sale_table
where
transaction_id is null or sale_date is null or sale_time is null or customer_id is null or
gender is null or age is null or category is null or quantity is null or 
price_per_unit is null or cogs is null or total_sale is null;

delete from retail_sale_table
where
transaction_id is null or sale_date is null or sale_time is null or customer_id is null or
gender is null or age is null or category is null or quantity is null or 
price_per_unit is null or cogs is null or total_sale is null;


#1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:

SELECT *
FROM retail_sale_table
WHERE sale_date = '2022-11-05';

#2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select transaction_id , category , quantity  from retail_sale_table
where category = "clothing"and
quantity > "4" and sale_date > "2022-11-01" and sale_date < "2022-11-30";

#3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category , count(category) , sum(total_sale) from retail_sale_table
group by category;

#4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:

select avg(age) , category from retail_sale_table
where category ="beauty";

#5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select transaction_id , total_sale from retail_sale_table
where total_sale >1000;

#6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

select count(transaction_id) ,gender , category from retail_sale_table
group by gender, category;

#7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select avg(total_sale) , monthname(sale_date), year(sale_date) from  retail_sale_table
group by monthname(sale_date) , year(sale_date);


#8*Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id ,max(total_sale)  from retail_sale_table
group by customer_id
limit 5;

#9Write a SQL query to find the number of unique customers who purchased items from each category

select distinct customer_id ,category from retail_sale_table
group by category , customer_id ;

#10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
SELECT 
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sale_table
GROUP BY shift
ORDER BY shift;
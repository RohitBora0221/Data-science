SELECT * FROM project_pizzas.retail_orders_dirty;
-- Task 1
-- Display the complete dataset and inspect all columns manually.
describe retail_orders_dirty;

-- Task 2
-- Count the total number of records in the dataset.
-- Expected Learning:
-- •	COUNT(*) 

select count(*) from retail_orders_dirty;

-- Check the structure of the table.
-- Find:
-- •	Column names 
-- •	Data types 
-- •	Nullability 
-- Expected Learning:
-- •	DESC

--  Task 4Identify columns that should not be stored as VARCHAR.
-- Examples:

-- | Column Name  | Current Type | Correct Type  | Reason                                              |
-- | ------------ | ------------ | ------------- | --------------------------------------------------- |
-- | quantity     | VARCHAR      | INT           | Stores quantity numbers                             |
-- | unit_price   | VARCHAR      | DECIMAL(10,2) | Stores price values                                 |
-- | total_amount | VARCHAR      | DECIMAL(10,2) | Stores calculated sales amount                      |
-- | order_date   | VARCHAR      | DATE          | Stores dates                                        |
-- | discount     | VARCHAR      | DECIMAL(5,2)  | Stores percentage/numeric values                    |
-- | customer_age | VARCHAR      | INT           | Stores age numbers                                  |
-- | pincode      | VARCHAR      | VARCHAR(10)   | Correct as VARCHAR because pincodes are identifiers |

alter table retail_orders_dirty
MODIFY COLUMN quantity INT,
MODIFY COLUMN unit_price DECIMAL(10,2),
MODIFY COLUMN total_amount DECIMAL(10,2),
MODIFY COLUMN discount DECIMAL(5,2),
MODIFY COLUMN customer_age INT;



-- cleaning

-- 1
update retail_orders_dirty
set quantity = 2
where quantity = "null";

-- 2
update retail_orders_dirty
set unit_price = 25000
where unit_price = "abc"; 

-- 3
update retail_orders_dirty
set total_amount = 4500
where total_amount = -4500;


-- 4
update retail_orders_dirty
set customer_age = case
when customer_age = "twenty two" then 22
when customer_age = -5 then 5
end 
where customer_age = "twenty two"
or customer_age = -5;
  
  -- 5
  update retail_orders_dirty
  set discount = case 
  when discount = 'null' then 4
  when discount = ' ' then 4
  when discount =  '' then 4
  when discount =  '  ' then 4
  
  end
  where discount in ('null', '',' ','  ');
  
  -- Task5
-- Find all records where customer email is NULL.
-- Expected Learning:
-- •	IS NULL 

select * from retail_orders_dirty
where	customer_email is null;

-- Task 6
-- Find records where customer name is blank or contains only spaces.
-- Expected Learning:
-- •	TRIM() 

select customer_name
from retail_orders_dirty
where trim(customer_name) = '';

-- Find rows where quantity contains:
-- •	NULL 
-- •	blank values 
-- •	text like 'NULL' 
-- Expected Learning:
-- •	Handling fake null values

SELECT *
FROM retail_orders_dirty
WHERE Quantity = " ";

-- Task 8
-- Replace missing customer emails with:
-- unknown@gmail.com
-- Expected Learning:
-- •	UPDATE 

update retail_orders_dirty
set customer_email = 'unknown@gmail.com'
where customer_email is null;

-- Task 9
-- Identify duplicate order IDs.
-- Expected Learning:
-- •	GROUP BY 
-- •	HAVING 

SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM retail_orders_dirty
GROUP BY Order_ID
HAVING COUNT(*) > 1;

-- Task 10
-- Display complete duplicate rows.
-- Expected Learning:
-- •	Duplicate analysis 

select row_id, order_id, customer_name, customer_email, phone_number, gender, city, state_name, country, product_name, category, quantity, 
unit_price, total_amount, order_date, payment_method, order_status, discount, customer_age, pincode, remarks,
count(*) as duplicate_count
from retail_orders_dirty
group by row_id, order_id, customer_name, customer_email, phone_number, gender, city, state_name, country, product_name, category, quantity,
 unit_price, total_amount, order_date, payment_method, order_status, discount, customer_age, pincode, remarks
 having count(*) >1;
 
 
--   Task 12
-- Remove leading and trailing spaces from:
-- •	customer_name 
-- •	city 
-- •	unit_price 
-- •	total_amount 
-- Expected Learning:
-- •	TRIM() 

SELECT
    TRIM(customer_name) AS customer_name,
    TRIM(city) AS city,
    TRIM(unit_price) AS unit_price,
    TRIM(total_amount) AS total_amount
FROM retail_orders_dirty;

-- Task 13
-- Find records still containing unnecessary spaces after cleaning.
-- Expected Learning:
-- •	Validation queries 

SELECT *
FROM retail_orders_dirty
WHERE customer_name <> TRIM(customer_name)
   OR city <> TRIM(city)
   OR unit_price <> TRIM(unit_price)
   OR total_amount <> TRIM(total_amount);
-- task 14
-- Standardize gender values.
-- Current values include:
-- •	Male 
-- •	male 
-- •	M 
-- •	FEMALE 
-- •	Female 
-- Convert all into:
-- •	Male 
-- •	Female 
-- Expected Learning:
-- •	CASE WHEN 



update retail_orders_dirty
set gender =
case 
when upper(trim(gender)) in ('MALE', 'M')
then 'Male'

when upper(trim(gender)) in ('FEMALE', 'M')
then 'Female' 
else gender
END;


-- Task 15
-- Standardize city names.
-- Convert:
-- •	delhi 
-- •	Delhi 
-- •	Delhi 
-- into one format.
-- Expected Learning:
-- •	LOWER() 
-- •	UPPER() 
-- •	INITCAP() logic 

SELECT
    LOWER(city) AS city_lower,
    UPPER(city) AS city_upper
FROM retail_orders_dirty;


-- Task 16
-- Standardize order status values.
-- Convert:
-- •	delivered 
-- •	Delivered 
-- into:
-- •	Delivered

update retail_orders_dirty
set order_status = 'Delivered'
where lower(trim(order_status)) = 'delivered';


-- Task 17
-- Find invalid email addresses.
-- Rules:
-- •	Must contain @ 
-- •	Must contain . 
-- Expected Learning:
-- •	LIKE 

SELECT *
FROM retail_orders_dirty
WHERE customer_email NOT LIKE '%@%'
   OR customer_email NOT LIKE '%.%';
   
   
   -- Task 18
-- Replace invalid emails with NULL.
-- Expected Learning:
-- •	Data correction 

update retail_orders_dirty
SET customer_email = NULL
WHERE customer_email NOT LIKE '%@%'
OR customer_email NOT LIKE '%.%';



-- Task 19
-- Find invalid phone numbers.
-- Rules:
-- •	Must contain exactly 10 digits 
-- Expected Learning:
-- •	LENGTH() 

select * from retail_orders_dirty
where length(phone_number) != 10;

-- Task 20
-- Separate invalid phone numbers into an error table.
-- Expected Learning:
-- •	Error handling tables 

-- Create error table

CREATE TABLE invalid_phone_numbers (
    row_id INT,
    order_id VARCHAR(20),
    customer_name VARCHAR(100),
    phone_number VARCHAR(30),
    error_reason VARCHAR(100)
);


-- Step 2: Insert invalid phone number records

INSERT INTO invalid_phone_numbers
(row_id, order_id, customer_name, phone_number, error_reason)

SELECT
    row_id,
    order_id,
    customer_name,
    phone_number,
    'Invalid phone number'
FROM retail_orders_dirty
WHERE phone_number IS NULL
   OR LENGTH(phone_number) != 10
   OR phone_number NOT REGEXP '^[0-9]{10}$';

-- Step 3: View error records

SELECT * 
FROM invalid_phone_numbers;

-- Task 21
-- Find rows where quantity is:
-- •	negative

SELECT *
FROM retail_orders_dirty
WHERE quantity IS NULL
   OR TRIM(quantity) = ''
   OR UPPER(quantity) = 'NULL'
   OR quantity REGEXP '[A-Za-z]'
   OR quantity < 0
   OR quantity  = 0;
   
  --  Task 22
-- Find rows where unit_price contains text values.
-- Example:
-- •	abc 
-- Expected Learning:
-- •	Numeric detection

select * from retail_orders_dirty
where unit_price regexp '[A-Za-z]';

-- Task 23
-- Replace invalid prices with NULL.

update retail_orders_dirty
SET unit_price = NULL
WHERE unit_price REGEXP '[A-Za-z]';


-- Task 24
-- Find rows where total_amount does not equal:
-- quantity * unit_price
-- Expected Learning:
-- •	Data consistency checks 

 SELECT *,
(quantity * unit_price) as calculated_total
FROM retail_orders_dirty
where total_amount != (quantity * unit_price);

-- Task 25
-- Identify all different date formats in the dataset.
-- Formats include:
-- •	YYYY-MM-DD 
-- •	DD/MM/YYYY 
-- •	MM-DD-YYYY 
-- •	YYYY/MM/DD 
-- •	DD Mon YYYY 
-- Expected Learning:
-- •	Date auditing

select order_date,
case

    WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN 'YYYY-MM-DD'

    WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
        THEN 'DD/MM/YYYY'

    WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN 'MM-DD-YYYY'

    WHEN order_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
        THEN 'YYYY/MM/DD'

    WHEN order_date REGEXP '^[0-9]{2} [A-Za-z]{3} [0-9]{4}$'
        THEN 'DD Mon YYYY'

    ELSE 'Unknown Format'
END AS date_format
FROM retail_orders_dirty; 

-- Task 26
-- Convert all dates into standard MySQL DATE format.
-- Target format:
-- YYYY-MM-DD
-- Expected Learning:
-- •	STR_TO_DATE() 

ALTER TABLE retail_orders_dirty
ADD COLUMN clean_order_date date;

UPDATE retail_orders_dirty
SET clean_order_date =
CASE

    -- DD/MM/YYYY
    WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%d/%m/%Y')

    -- MM-DD-YYYY
    WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%m-%d-%Y')

    -- YYYY/MM/DD
    WHEN order_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
    THEN STR_TO_DATE(order_date, '%Y/%m/%d')
    

    -- DD Mon YYYY
    WHEN order_date REGEXP '^[0-9]{2} [A-Za-z]{3} [0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%d %b %Y')

    ELSE NULL

END;


-- Task 27
-- Find invalid dates.
-- Example:
-- •	2025-13-01

UPDATE retail_orders_dirty
SET clean_order_date =
CASE

    -- YYYY-MM-DD (valid month/day check)
    WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
         AND SUBSTRING(order_date,6,2) BETWEEN '01' AND '12'
         AND SUBSTRING(order_date,9,2) BETWEEN '01' AND '31'
    THEN STR_TO_DATE(order_date, '%Y-%m-%d')

    -- DD/MM/YYYY
    WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%d/%m/%Y')

    -- MM-DD-YYYY
    WHEN order_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%m-%d-%Y')

    -- YYYY/MM/DD
    WHEN order_date REGEXP '^[0-9]{4}/[0-9]{2}/[0-9]{2}$'
    THEN STR_TO_DATE(order_date, '%Y/%m/%d')
    

    -- DD Mon YYYY
    WHEN order_date REGEXP '^[0-9]{2} [A-Za-z]{3} [0-9]{4}$'
    THEN STR_TO_DATE(order_date, '%d %b %Y')

    ELSE NULL

END; 

-- Task 28
-- Find invalid payment methods.
-- Allowed methods:
-- •	UPI 
-- •	Card 
-- •	COD 
-- •	Cash 




SELECT *
FROM retail_orders_dirty
WHERE payment_method NOT IN ('UPI', 'Card', 'COD', 'Cash')
   OR payment_method IS NULL;
   
   
  --  Task 29
-- Find records where discount exceeds 50%.
-- Expected Learning:
-- •	Outlier detection 

SELECT *
FROM retail_orders_dirty
WHERE (discount / unit_price) * 100 > 50;

-- Task 30
-- Find negative customer ages.

SELECT *
FROM retail_orders_dirty
WHERE customer_age < 0;

-- Task 31
-- Find non-numeric customer ages.
-- Example:
-- •	Twenty Two

select * from retail_orders_dirty
where customer_age regexp '[A-Z,a-z]';

-- Task 32
-- Rename column:
-- state_name → state
-- Expected Learning:
-- •	ALTER TABLE 
-- •	RENAME COLUMN 

ALTER TABLE retail_orders_dirty
RENAME COLUMN state_name TO state;

-- Task 33
-- Change column data types.
-- Convert:
-- Column	New Data Type
-- quantity	INT
-- unit_price	DECIMAL(10,2)
-- total_amount	DECIMAL(10,2)
-- customer_age	INT
-- order_date	DATE
-- Expected Learning:
-- •	ALTER TABLE 
-- •	MODIFY COLUMN 

-- already done


-- Task 34
-- Create a new column named full_address.
-- Combine:
-- •	city 
-- •	state 
-- •	country 
-- Expected Learning:
-- •	CONCAT() 

alter table retail_orders_dirty
add column  full_address varchar (255);

update retail_orders_dirty
SET full_address = CONCAT(city, ', ', state, ', ', country);

-- Task 35
-- Create customer age groups.
-- Conditions:
-- •	0–25 → Young 
-- •	26–45 → Adult 
-- •	46+ → Senior 
-- Expected Learning:
-- •	CASE WHEN 

alter table retail_orders_dirty
add column Age_group varchar(299);
SELECT *,
       CASE
           WHEN customer_age BETWEEN 0 AND 25 THEN 'Young'
           WHEN customer_age BETWEEN 26 AND 45 THEN 'Adult'
           WHEN customer_age >= 46 THEN 'Senior'
           
       END AS Age_group
FROM retail_orders_dirty;

-- Task 36
-- Create a cleaned total amount column.
-- Formula:
-- quantity * unit_price

-- --already done

-- Task 37
-- Create a fully cleaned table named:
-- retail_orders_clean
-- The final table must:
-- •	contain no duplicates 
-- •	contain standardized values 
-- •	contain valid dates 
-- •	contain correct data types 
-- •	contain cleaned numeric values 


create table retail_orders_clean(
   row_id int,
   order_id int,
   customer_name varchar(90),
   customer_email varchar(90),
   phone_number varchar(90),
   gender varchar(90),
   city varchar(90),
   state varchar(90),
   country varchar(90),
   product_name varchar(990),
 category varchar(990), 
 quantity int,
 unit_price int, 
 total_amount int,
 clean_order_date date,
 payment_method varchar(90),
 order_status varchar(90), 
 discount int, 
 customer_age varchar(90), 
 pincode varchar(90),
 remarks varchar(90) );

INSERT INTO retail_orders_dirty (row_id, order_id, customer_name, customer_email, phone_number, gender, city, state, country, product_name, category, quantity, unit_price, total_amount, 
clean_order_date, payment_method, order_status, discount, customer_age, pincode, remarks)
select
row_id, order_id, customer_name, customer_email, phone_number, gender, city, state, country, product_name, category, quantity, unit_price, 
total_amount, clean_order_date, payment_method, order_status, discount, customer_age, pincode, remarks ;


-- Task 38
-- Remove unnecessary columns from final table.
-- Example:
-- •	remarks 

alter table retail_orders_dirty
drop column remarks;

alter table retail_orders_dirty
drop column age_group;

-- Task 39
-- Add PRIMARY KEY constraint to order_id.

-- already done 

-- Task 40
-- Add NOT NULL constraints to important columns.
-- Examples:
-- •	order_id 
-- •	customer_name 
-- •	order_date 


-- Task 41
-- Check if any duplicate order IDs still exist.

SELECT order_id,
       COUNT(*) AS duplicate_count
FROM retail_orders_dirty
GROUP BY order_id
HAVING COUNT(*) > 1;

-- Task 42
-- Check if any NULL emails still exist.

select * from retail_orders_dirty
where customer_email is null;

-- Task 43
-- Check if any invalid payment methods still exist

SELECT *
FROM retail_orders_dirty
WHERE payment_method NOT IN ('UPI', 'Card', 'COD', 'Cash')
   OR payment_method IS NULL
   OR TRIM(payment_method) = '';
   
 --   Task 44
-- Check if any negative quantities still exist.

select * from retail_orders_dirty
where quantity < 0;



-- Task 45
-- Check if any incorrect dates still exist.

select * from retail_orders_dirty
where clean_order_date is null;





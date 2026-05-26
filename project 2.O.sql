create database employee_behaviour;

use employee_behaviour;

create table employee_behaviour(
emp_no varchar(700),
gender	varchar(700),
marital_status	varchar(700),
age_band	varchar(700),
age	varchar(700),
department	varchar(700),
education	varchar(700),
education_field	varchar(700),
job_role	varchar(700),
business_travel	varchar(700),
employee_count	varchar(700),
attrition	varchar(700),
attrition_label	varchar(700),
job_satisfaction int ,	
active_employee int );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Analyzing Employee Behaviour.csv'
INTO TABLE employee_behaviour 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


select * from employee_behaviour;

describe employee_behaviour;

alter table employee_behaviour
modify column age int,
modify column employee_count int ;


-- data cleaning

SELECT	* FROM employee_behaviour 
WHERE emp_no IS NULL
or gender is null
or marital_status is null
or age_band is null
or age is null
or department is null
or education is null
or education_field is null
or job_role is null
or business_travel is null
or employee_count is null
or attrition is null
or attrition_label is null
or job_satisfaction is null
or active_employee is null;


-- 8.2 Find Duplicate Records 

select emp_no, count(*) from employee_behaviour
group by emp_no
having count(*)>1;

select * from employee_behaviour;


-- 8.3 Remove Extra Spaces 
 UPDATE employee_behaviour
SET 

    gender = TRIM(gender),
    emp_no= trim(emp_no),
    marital_status = TRIM(marital_status),
    age_band = TRIM(age_band),
    age=TRIM(age),
    department = TRIM(department),
    education = TRIM(education),
    education_field = TRIM(education_field),
    job_role = TRIM(job_role),
    business_travel = TRIM(business_travel),
    employee_count = trim(employee_count),
    attrition = TRIM(attrition),
    attrition_label = TRIM(attrition_label),
    job_satisfaction= trim(job_satisfaction),
    active_employee= trim(active_employee);
    
    
    -- 8.4 Standardize Gender Values 
    
    Select distinct gender from
    employee_behaviour;
    
    
   --  8.5 Create Clean Salary Column
   
    alter table employee_behaviour
    add column clean_salary int;

select * from employee_behaviour;

-- 8.6 Clean Salary Values 

UPDATE employee_behaviour
SET clean_salary = FLOOR(30000 + (RAND() * 70000));

-- 8.7 Detect Invalid Ages 

select * from employee_behaviour
where age is null
or age <18
or age > 60;

select age from employee_behaviour
where age regexp '[A-Z,a-z]';

describe employee_behaviour;

-- Department with the highest employee attrition rate

SELECT 
    department,
    COUNT(CASE WHEN attrition = 'Yes' THEN 1 else 0 END) AS employees_left,
    COUNT(*) AS total_employees,
    
    ROUND(
        (COUNT(CASE WHEN attrition = 'NO' THEN 0 END) * 100.0) 
        / COUNT(*),
        2
    ) AS attrition_rate
FROM employee_behaviour
GROUP BY department
ORDER BY attrition_rate DESC;
-- Attrition Rate=Employees Left/Total Employees​×100

SELECT 
    department,
SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
COUNT(*) AS total_employees,
ROUND(SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),2
    ) AS attrition_rate
FROM employee_behaviour
GROUP BY department
ORDER BY attrition_rate DESC;




alter table employee_behaviour
add column overtime varchar(900);


UPDATE employee_behaviour
SET overtime = CASE
    WHEN RAND() > 0.7 THEN 'Yes'
    ELSE 'No'
END;




-- 10.2 Does over me increase resigna on probability? 

SELECT 
    overtime,

    SUM(CASE 
            WHEN attrition = 'Yes' THEN 1 
            ELSE 0 
        END) AS resigned_employees,

    COUNT(*) AS total_employees,

   
        SUM(CASE 
                WHEN attrition = 'Yes' THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*)
        AS resignation_probability

FROM employee_behaviour
GROUP BY overtime;










ALTER TABLE employee_behaviour
ADD performance_rating INT,
ADD salary DECIMAL(10,2),
ADD work_life_balance INT,
ADD monthly_hours INT,
ADD years_at_company INT;

alter table employee_behaviour
drop column salary;

alter table employee_behaviour
rename column clean_salary  to salary;
---

# 5. Generate Sample Data for New Columns

## Random Salary


UPDATE employee_behavior
SET salary = FLOOR(30000 + (RAND() * 90000));


---

## Random Overtime


UPDATE employee_behaviour
SET overtime = CASE
    WHEN RAND() > 0.7 THEN 'Yes'
    ELSE 'No'
END;


---

## Random Performance Rating


UPDATE employee_behaviour
SET performance_rating = FLOOR(1 + (RAND() * 5));


---

## Random Work Life Balance


UPDATE employee_behaviour
SET work_life_balance = FLOOR(1 + (RAND() * 5));


---

## Random Monthly Hours


UPDATE employee_behaviour
SET monthly_hours = FLOOR(120 + (RAND() * 120));


---

## Random Years at Company


UPDATE employee_behaviour
SET years_at_company = FLOOR(1 + (RAND() * 20));


-- 10.3. Which employees are at highest a ri on risk?

select 
count(*)
from employee_behaviour
where overtime = 'yes'
and work_life_balance <=2
and job_satisfaction <=2;



#4 Which department has the highest burnout level? 

select 
department,
avg(monthly_hours) as avg_hours,
 avg(work_life_balance) as avg_work_life_balance
 from employee_behaviour
 group by department
 order by avg_hours desc , avg_work_life_balance ASC;

#5. Are high-performing employees underpaid? 

SELECT 
    emp_no,
    department,
    performance_rating,
    salary
FROM employee_behaviour
WHERE performance_rating > 4
AND salary < (
    SELECT AVG(salary)
    FROM employee_behaviour
)
ORDER BY salary DESC;

#6. Which department gives the best performance for salary paid? 

SELECT 
    department,
    round(AVG(performance_rating),2) AS avg_performance,
    round(AVG(salary),2) AS avg_salary,
    round(avg(salary)/avg(performance_rating),2) as efficiency_score
FROM employee_behaviour
GROUP BY department
order by efficiency_score ;


-- Which employees deserve promo on? 

SELECT 
    emp_no,
    department,
    performance_rating,
    years_at_company,
CASE WHEN performance_rating >= 4 
AND years_at_company >= 5
        THEN 'Promotion Eligible' ELSE 'Not Eligible'
    END AS promotion_status
FROM employee_behaviour;

-- 8. Which departments have poor work-life balance?

SELECT 
    department,
    AVG(work_life_balance) AS work_life_balance
FROM employee_behaviour
GROUP BY department
ORDER BY work_life_balance ASC; 

#9. Which employees work excessive hours? 

SELECT 
    emp_no,
    department,
    overtime
FROM employee_behaviour
WHERE overtime = 'Yes';

 --  9. Which employees work excessive hours? 
 
 select 
 emp_no,
 department,
 monthly_hours 
 from employee_behaviour
 where monthly_hours >= (select avg(monthly_hours) from employee_behaviour)
 order by monthly_hours desc;

#10 Which departments retain employees best? 

SELECT 
    department,
    ROUND(
        SUM(CASE 
                WHEN attrition = 'No' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
        ) AS retention_rate
FROM employee_behaviour
GROUP BY department
ORDER BY retention_rate DESC;


-- 11. Does work-life balance affect performance? 

SELECT 
    work_life_balance,
   round( AVG(performance_rating),2) AS avg_performance
FROM employee_behaviour
GROUP BY work_life_balance
ORDER BY work_life_balance;

-- 12. Which employees show exceptional performance? 

SELECT 
    emp_no,
    department,
    performance_rating
FROM employee_behaviour
WHERE performance_rating >= 5;

-- 13. Which departments are overstaffed or understaffed


select 
department,
count(*) as empolyee_count,
CASE
        WHEN COUNT(*) > 500 THEN 'Overstaffed'
        WHEN COUNT(*) < 200 THEN 'Understaffed'
        ELSE 'Balanced'
    END AS  workforce_status
    from employee_behaviour
    group by department;
    
    
  --   14. Which employees may require training? 
  
  SELECT 
    emp_no,
    department,
    performance_rating,
    job_satisfaction
FROM employee_behaviour
where performance_rating <=2
or job_satisfaction <=2;

#15. Does salary impact a ri on? 

select 
attrition,
round(avg(salary),2) as avg_salary
from employee_behaviour
group by attrition;

#16. Which departments have the largest salary inequality

select
department,
max(salary) as highest_salary,
min(salary) as lowest_salary,
MAX(salary) - MIN(salary) AS salary_gap
FROM employee_behaviour
GROUP BY department
ORDER BY salary_gap DESC; 


#17. Which employees are improving or declining? 

select 
emp_no,
department,
salary,
CASE
        WHEN performance_rating >= 4 THEN 'Improving'
        WHEN performance_rating <= 2 THEN 'Declining'
        ELSE 'Stable'
    END AS performance_status
from employee_behaviour;

## using window function

SELECT
    emp_no,
    department,
    salary,
    LAG(salary) OVER (
        PARTITION BY department
        ORDER BY years_at_company
    ) AS previous_salary,
     Lead(salary) OVER (
        PARTITION BY department
        ORDER BY years_at_company
    ) AS salary_growth
FROM analyzing_employee_behaviour;
 
  #18. Which departments have the highest average performance? 
  
  select
   department,
   round(avg(performance_rating),2) as avg_performance
   from employee_behaviour
   group by department
   order by avg_performance  desc;
   
   #19. Which employees are ranked highest within departments? 
   
   select 
   department,
   performance_rating,
   rank() over (
PARTITION BY department
ORDER BY performance_rating DESC
    ) AS department_rank
FROM employee_behaviour;



# 20. Workforce KPI Dashboard Summary

## KPI 1 — Total Employees


SELECT COUNT(*) AS total_employees
FROM employee_behaviour;


---

## KPI 2 — Average Salary


SELECT ROUND(AVG(salary),2) AS average_salary
FROM employee_behaviour;


---

## KPI 3 — Attrition Rate


SELECT
    ROUND(
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate
FROM employee_behaviour;


---

## KPI 4 — Average Performance Rating


SELECT ROUND(AVG(performance_rating),2) AS avg_performance_rating
FROM employee_behaviour;


---

## KPI 5 — Overtime Employees


SELECT COUNT(*) AS overtime_employees
FROM employee_behaviour
WHERE overtime = 'Yes';




-- SQL Window Functions (project)
##########################################################

-- Select Data needs for this project

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM regions;
SELECT * FROM customers;
SELECT * FROM sales;
######################################

-- 2.1: List of employee_id, first_name, hire_date, 
-- and department of all employees ordered by the hire date

SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER (ORDER BY hire_date) AS Row_N
FROM employees;

-- 2.2: Find the employee_id, first_name, 
-- hire_date of employees for different departments

SELECT employee_id, first_name, department, hire_date,
ROW_NUMBER() OVER (PARTITION BY department
	              ORDER BY hire_date) AS Row_N
FROM employees;

#############################

  --  Rank the rows of a result set
#############################

-- 3.1: Recall the use of ROW_NUMBER()

SELECT first_name, email, department, salary,
ROW_NUMBER() OVER(PARTITION BY department
				  ORDER BY salary DESC)
FROM employees;

-- 3.2: RANK() function in action

SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department
				  ORDER BY salary DESC) Rank_N
FROM employees;


-- 3.1: Find the hire_date. Return details of
-- employees hired on or before 31st Dec, 2005 and are in
-- First Aid, Movies and Computers departments 

SELECT first_name, email, department, salary, hire_date,
RANK() OVER(PARTITION BY department
			ORDER BY salary DESC)
FROM employees
WHERE hire_date <= '2005-12-31' AND department IN ('first Aid', 'Movies', 'Computers');

-- returns how many employees are in each department

SELECT department, COUNT(*) dept_count
FROM employees
GROUP BY department
ORDER BY dept_count DESC;

-- 3.3: Return the fifth ranked salary for each department

SELECT * FROM (
SELECT first_name, email, department, salary,
RANK() OVER(PARTITION BY department
				  ORDER BY salary DESC) Rank_N
FROM employees) a
WHERE rank_n = 5;


-- CTE 
-- Retrieve the customer_id,and how many times the customer has purchased from the mall 

WITH purchase_count AS (
SELECT customer_id, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id
ORDER BY purchase DESC
)
SELECT customer_id, purchase,
ROW_NUMBER() OVER (ORDER BY purchase DESC) AS Row_N,
RANK() OVER (ORDER BY purchase DESC) AS Rank_N,
DENSE_RANK() OVER (ORDER BY purchase DESC) AS Dense_Rank_N
FROM purchase_count
ORDER BY purchase DESC;

############################

-- 4. Break/page the result set into groups
################################

-- 4.1: Group the employees table into five groups
-- based on the order of their salaries

SELECT first_name, department, salary,
NTILE(5) OVER (ORDER BY salary DESC)
FROM employees;

-- Create three groups;

SELECT first_name, department, salary,
NTILE(4) OVER (ORDER BY salary DESC) group_1,
NTILE(10) OVER (ORDER BY salary DESC) group_2,
NTILE(100) OVER (ORDER BY salary DESC) group_3
FROM employees;

-- 4.2: Group the employees table into five groups for 
-- each department based on the order of their salaries

SELECT first_name, email, department, salary,
NTILE(5) OVER(PARTITION BY department
			  ORDER BY salary DESC)
FROM employees;

-- CTE
-- Group the employees into five groups,
-- based on the order of their salaries and the average salary for each group of employees

WITH salary_ranks AS (
SELECT first_name, email, department, salary,
NTILE(5) OVER(ORDER BY salary DESC) AS rank_of_salary
FROM employees)

SELECT rank_of_salary, ROUND(AVG(salary),2) Avg_salary
FROM salary_ranks
GROUP BY rank_of_salary 
ORDER BY rank_of_salary;


#############################

-- 5.1.Returns how many employees are in each department

SELECT department, COUNT(*) AS dept_count
FROM employees
GROUP BY department
ORDER BY department;

-- 5.2: Retrieve the first names, department and 
-- number of employees working in that department

SELECT first_name, department, 
(SELECT COUNT(*) AS dept_count FROM employees e1 WHERE e1.department = e2.department)
FROM employees e2
GROUP BY department, first_name
ORDER BY department;


SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department) AS dept_count
FROM employees;


-- 5.3: Total Salary for all employees

SELECT first_name, department, hire_date,
SUM(salary) OVER(ORDER BY hire_date) AS total_salary
FROM employees;



-- 5.4: Total Salary for each department

SELECT first_name, department, hire_date,salary,
SUM(salary) OVER(PARTITION BY department) AS dept_total_salary
FROM employees;


-- Total Salary for each department

SELECT first_name, hire_date, department, salary,
SUM(salary) OVER(PARTITION BY department
				 ORDER BY hire_date) AS running_total
FROM employees;

#############################

-- Retrieve the different region ids

SELECT DISTINCT region_id
FROM employees;

-- 6.1: Retrieve the first names, department and 
-- number of employees working in that department and region

SELECT first_name, department,
COUNT(*) OVER(PARTITION BY department) dept_count,
region_id,
COUNT(*) OVER(PARTITION BY region_id) region_count
FROM employees;


--  6.1: Retrieve the first names, department and 
-- number of employees working in that department and in region 2


SELECT first_name, department, 
COUNT(*) OVER(PARTITION BY department) AS dept_count
FROM employees
WHERE region_id = 2;

-- Sum of customers purchase for the different ship mode 
-- AND how many times the customer has purchased from the mall

WITH purchase_count AS (
SELECT customer_id, ship_mode, COUNT(sales) AS purchase
FROM sales
GROUP BY customer_id, ship_mode
ORDER BY purchase DESC
)

SELECT customer_id, ship_mode, purchase, 
SUM(purchase) OVER(PARTITION BY ship_mode
				   ORDER BY customer_id ASC) AS sum_of_sales
FROM purchase_count;


#############################

-- 7.1: Calculate the running total of salary
-- Retrieve the first_name, hire_date, salary
-- of all employees ordered by the hire date


SELECT first_name, hire_date, salary
FROM employees
ORDER BY hire_date;

-- The solution


SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date
				 RANGE BETWEEN
				 UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM employees;

-- 7.2: Add the current row and previous row
SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date
				 ROWS BETWEEN
				 2 PRECEDING AND CURRENT ROW) AS running_total
FROM employees;


-- 7.3: Find the running average

SELECT first_name, hire_date, salary,
SUM(salary) OVER(ORDER BY hire_date
				 ROWS BETWEEN
				 1 PRECEDING AND CURRENT ROW) AS runnig_average
FROM employees;

#############################

-- 8.1: Review of the FIRST_VALUE() function

SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) first_department
FROM departments;

-- 8.2: Retrieve the last department in the departments table

SELECT department, division,
FIRST_VALUE(department) OVER(ORDER BY department ASC) first_department,
LAST_VALUE(department) OVER(ORDER BY department ASC
						    RANGE BETWEEN UNBOUNDED PRECEDING
						    AND UNBOUNDED FOLLOWING) AS last_department
FROM departments;


#############################
-- GROUPING SETS, ROLLUP() & CUBE()

-- 9.1: Find the sum of the quantity for different ship modes

SELECT ship_mode, SUM(quantity) 
FROM sales
GROUP BY ship_mode;

-- 9.2: Find the sum of the quantity for different categories
SELECT category, SUM(quantity) 
FROM sales
GROUP BY category;

-- 9.3: Find the sum of the quantity for different subcategories
SELECT sub_category, SUM(quantity) 
FROM sales
GROUP BY sub_category;

-- 9.4: Use the GROUPING SETS clause

SELECT ship_mode, Category, sub_category, SUM(quantity)
FROM sales
GROUP BY GROUPING SETS(ship_mode, category, sub_category,());

--9.5: Use the ROLLUP clause

SELECT ship_mode, Category, sub_category, SUM(quantity)
FROM sales
GROUP BY ROLLUP(ship_mode, category, sub_category);

--9.6: Use the CUBE clause

SELECT ship_mode, Category, sub_category, SUM(quantity)
FROM sales
GROUP BY CUBE(ship_mode, category, sub_category);


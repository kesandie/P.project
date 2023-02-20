-- In this project i'm gonna use mostly SQL-string function to clean.


---Task 1: LENGTH, LEFT, RIGHT
-- In this task, we will use the LENGTH function to return the 
-- length of a specified string, expressed as the number of characters.
-- In addition, we will use the LEFT/RIGHT functions to pull a certain number of characters 
-- from the left or right side of a string and present them as a separate string


-- Retrieve the lengh of the first name of males employess

-- Change M to Males and F to Females

SELECT * FROM employees;

SELECT gender,
CASE (gender) 
WHEN 'M' THEN 'Male'
WHEN 'F' THEN 'Female'
ELSE gender
END AS gender
FROM employees;

UPDATE employees
SET gender,char(50) = CASE (gender) 
WHEN 'M' THEN 'Male'
WHEN 'F' THEN 'Female'
ELSE gender
END

SELECT first_name, LENGTH(first_name)
FROM employees
WHERE gender = 'M';


-- Find the lenght of the first name of male employees 
-- where the lenght is greater thn 5

SELECT * FROM employees;


SELECT first_name, LENGTH(first_name) AS characters_num
FROM employees
WHERE gender = 'M' AND LENGTH(first_name) > '5'
ORDER BY characters_num;


-- Retrieve a list of the customer group of all customers

SELECT * 
FROM customers;

SELECT customer_id, LEFT (customer_id,2) AS cust_group
From customers;

-- Retrieve a list of the customer number of all customers

SELECT customer_id, Right (customer_id,5) AS cust_number
From customers;

-- Retrive the lenth of the customer_id column 

SELECT customer_id, LENGTH(customer_id )
FROM customers;

-- Retrieve a list of the customer group of all customers

SELECT customer_id, RiGHT(customer_id, LENGTH(customer_id)-3) AS cust_number
FROM customers;

-- Task 3: UPPER&LOWER



-- Retrieve the details of the first employee

SELECT * FROM employees
WHERE emp_no = '10001';

-- Change the first of the first employee to upper case

UPDATE employees
SET first_name = UPPER(first_name)
WHERE emp_no = '10001';

-- USing "REPLACE" to perfom this task

-- Change M to in the gender column of the employee table

SELECT first_name, last_name, gender, 
REPLACE(gender,'M', 'Male') AS employee_name
FROM employees;

SELECT first_name, last_name, gender,
REPLACE(gender,'F', 'Female') AS employee_name
FROM employees;

-- Change United States to US in the country column of the customer table

SELECT customer_name, region, country, REPLACE(LOWER(country), 'united states','US') AS symbole
FROM customers;

-- TRIM, RTRIM, LTRIM to remove all specified characters either parts of a string

--REmove the brackets from each customer id in the bracket_cust_id column

SELECT * FROM customers;

SELECT bracket_cust_id, TRIM(bracket_cust_id,'()') AS cleaned_cust_id 
FROM customers;

##########################################

-- TASK six: Concatenation

-- Create a new column called full_name from the first_name and last_name
-- of empolyees table

SELECT emp_no,birth_date,first_name, last_name,first_name||' , '||last_name AS full_name
FROM employees;

-- Create a new column called Address from the city, state, and country

SELECT customer_name, city||', '||state||', '||country AS Address
FROM customers;

-- Create a column called desc_age from the column name and age

SELECT customer_name, CONCAT(customer_name, ' is ', age, ' years old ') AS DESC_AGE
FROM customers
ORDER BY age ASC;

##############################################################

-- This task is about SUBSTRING


-- Retrieve the IDs, names, and groups of customers

SELECT * FROM customers;

SELECT customer_id, customer_name,
SUBSTRING(customer_id FOR 2) AS cust_group
FROM customers;

-- Retrieve the IDs, names of customers in the customer group 'AB'


SELECT customer_id, customer_name,
SUBSTRING(customer_id FOR 2) AS cust_group
FROM customers
WHERE SUBSTRING(customer_id FOR 2) = 'AB';

-- Retrieve the IDs, names, and customer number of customers in the customer group 'AB'
SELECT customer_id, customer_name,
SUBSTRING(customer_id FROM 4 FOR 5) AS cust_number
FROM customers
WHERE SUBSTRING(customer_id FOR 2) = 'AB';

-- This task is about STRING AGGREGATION
-- using it to to join strings  together, separated by delimiter

-- Retrive a list of all department members for different employees

SELECT emp_no,
STRING_AGG(dept_no, ', ') AS departments
FROM dept_emp
GROUP BY emp_no;







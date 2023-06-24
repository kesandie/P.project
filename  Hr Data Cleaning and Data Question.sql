SELECT * FROM hsp.hr2;
 
 
 ALTER TABLE hr2
 CHANGE COLUMN id emp_id char(20) null;
 
 
 DESCRIBE hr2;
 
 
 SELECT birthdate FROM hr2;
 
 
 UPDATE hr2
 SET birthdate = CASE
WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate,'%m/%d/%y'), '%Y-%m-%d')
WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate,'%m-%d-%y'), '%y-%m-%d')
ELSE NULL
END;
 
 
 ALTER TABLE hr2
 MODIFY COLUMN birthdate DATE;
 

 
  UPDATE hr2
 SET hire_date = CASE
WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date,'%m/%d/%y'), '%Y-%m-%d')
WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date,'%m-%d-%y'), '%y-%m-%d')
ELSE NULL
END;

 -- SELECT termdate FROM hr2

 ALTER TABLE hr2
 MODIFY COLUMN hire_date DATE;
 
 
 UPDATE hr2
 SET termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
 WHERE termdate IS NOT NULL AND termdate != '';
 
 UPDATE HR2
SET termdate = '0000-00-00'
WHERE termdate = '';

ALTER TABLE HR2
MODIFY COLUMN termdate DATE;
 

ALTER TABLE hr2
ADD COLUMN age INT;


UPDATE hr2
SET age = timestampdiff(YEAR, birthdate,CURDATE());

SELECT 
      MIN(age) AS youngest,
      MAX(age) AS oldest
FROM hr2;


SELECT COUNT(*) FROM hr2
WHERE age < 18;

-- QUESTION

-- 1. What is the gender breakdown of employess in the company?
SELECT gender, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY gender;
-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY race
ORDER BY count(*)DESC;
-- 3. What is the age distribution of the employees in the company?
SELECT 
      MIN(age) AS youngest,
      MAX(age) AS oldest
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00';

SELECT 
      CASE
      WHEN age >= 18 AND age <= 22 THEN '18-22'
	  WHEN age >= 23 AND age <= 32 THEN '23-32'
	  WHEN age >= 33 AND age <= 42 THEN '33-42'
	  WHEN age >= 43 AND age <= 52 THEN '43-52'
	  WHEN age >= 53 AND age <= 62 THEN '53-62'
      ELSE '63+'
      END AS age_group,
      COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group
ORDER BY age_group;

SELECT 
      CASE
      WHEN age >= 18 AND age <= 22 THEN '18-22'
	  WHEN age >= 23 AND age <= 32 THEN '23-32'
	  WHEN age >= 33 AND age <= 42 THEN '33-42'
	  WHEN age >= 43 AND age <= 52 THEN '43-52'
	  WHEN age >= 53 AND age <= 62 THEN '53-62'
      ELSE '63+'
      END AS age_group,gender,
      COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- 4. How many employees work at headquaters versus remote locations?
SELECT location, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location;

-- 5. What is the average lenght of employment for employees who have been terminated?
SELECT 
	ROUND(AVG(datediff(termdate, hire_date))/365,0) AS avg_length_employment
    FROM hr2
    WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;

-- 6. how does the gender distribution vary accross depatments and job titles?
SELECT department, gender, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY department, gender 
ORDER BY department;
       
-- 7.What is the distribution of job titles across the compagny?
SELECT jobtitle, COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY jobtitle
ORDER BY jobtitle;

-- 8. Which company has the highest turnover rate?
SELECT department,
	 total_count,
     terminated_count,
     terminated_count/total_count AS termination_rate
     FROM (
     SELECT department,
     COUNT(*) AS total_count,
     SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminated_count
FROM hr2
WHERE age >= 18
GROUP BY department
) AS sub
ORDER BY termination_rate DESC;
     
-- 9. what is the distribution of employees across locations by city and state?
SELECT location_state,COUNT(*) AS count
FROM hr2
WHERE age >= 18 AND termdate = '0000-00-00'
GROUP BY location_state
ORDER BY count DESC;

-- 10.How has the company's employee count changed over time based on hire and term dates?
SELECT
year,
hires,
terminations,
hires-terminations AS net_change,
ROUND((hires-terminations)/hires*100,2) AS net_change_percent
FROM(
     SELECT 
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= curdate() THEN 1 ELSE 0 END) AS terminations
        FROM hr2
        WHERE age >= 18
        GROUP BY YEAR(hire_date)
        ) AS sub
ORDER BY year ASC;

-- 11. What is the tenue distribution for each department?
 SELECT department, ROUND(AVG(datediff(termdate, hire_date)/365),0) AS avg_tenure
 FROM hr2
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age>= 18
GROUP BY department; 


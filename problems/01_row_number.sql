-- ============================================================
-- PROBLEM 01: ROW_NUMBER()
-- ============================================================
-- 
-- ROW_NUMBER() assigns a unique sequential number to each row.
-- Unlike RANK(), it never has ties — every row gets a unique number.
-- 
-- Syntax:
--   ROW_NUMBER() OVER (ORDER BY column)
--   ROW_NUMBER() OVER (PARTITION BY group_col ORDER BY sort_col)
--
-- Most common use: "Top N per group" pattern
-- ============================================================


-- CONCEPT EXAMPLE:
-- Number all employees by salary (highest first)

SELECT
    emp_name,
    dept_id,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;


-- PROBLEM 1A:
-- Assign a row number to each employee within their department,
-- ordered by salary (highest salary = 1).
-- Columns: emp_name, dept_id, salary, dept_salary_rank

SELECT
    emp_name,
    dept_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dept_salary_rank
FROM employees
ORDER BY dept_id, dept_salary_rank;


-- PROBLEM 1B:
-- Find the MOST RECENTLY HIRED employee in each department.
-- (ROW_NUMBER + CTE + filter pattern — most asked in interviews!)

WITH ranked AS (
    SELECT
        dept_id,
        emp_name,
        hire_date,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY hire_date DESC) AS rn
    FROM employees
)
SELECT dept_id, emp_name, hire_date
FROM ranked
WHERE rn = 1;


-- PROBLEM 1C:
-- Find the TOP 3 highest paid employees in each department.

WITH ranked AS (
    SELECT
        dept_id,
        emp_name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rank_in_dept
    FROM employees
)
SELECT dept_id, emp_name, salary, rank_in_dept
FROM ranked
WHERE rank_in_dept <= 3
ORDER BY dept_id, rank_in_dept;


-- PROBLEM 1D:
-- Assign a sequential ID to each sale per employee, ordered by date.
-- This is useful for identifying "1st sale, 2nd sale, 3rd sale" per person.
-- Columns: emp_id, sale_date, amount, sale_sequence

SELECT
    emp_id,
    sale_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY sale_date) AS sale_sequence
FROM sales
ORDER BY emp_id, sale_sequence;

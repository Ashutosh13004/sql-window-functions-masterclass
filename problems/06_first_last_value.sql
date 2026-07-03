-- ============================================================
-- PROBLEM 06: FIRST_VALUE() and LAST_VALUE()
-- ============================================================
-- 
-- FIRST_VALUE(col) OVER (...) — returns the first value in the window
-- LAST_VALUE(col) OVER (...) — returns the last value in the window
--
-- WARNING: LAST_VALUE needs a frame clause to work correctly!
-- Use: ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- ============================================================

-- PROBLEM 6A:
-- For each employee, show their salary and the highest salary in their department.
-- Columns: dept_id, emp_name, salary, dept_top_salary

SELECT
    dept_id,
    emp_name,
    salary,
    FIRST_VALUE(salary) OVER (
        PARTITION BY dept_id ORDER BY salary DESC
    ) AS dept_top_salary
FROM employees
ORDER BY dept_id, salary DESC;


-- PROBLEM 6B:
-- For each employee, show the difference between their salary and
-- the highest paid person in their department.
-- Columns: dept_id, emp_name, salary, top_salary, gap_from_top

SELECT
    dept_id,
    emp_name,
    salary,
    FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS top_salary,
    salary - FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC) AS gap_from_top
FROM employees
ORDER BY dept_id, salary DESC;


-- PROBLEM 6C:
-- For each sale, show the first sale amount and last sale amount
-- for that employee (chronologically).
-- Columns: emp_id, sale_date, amount, first_sale, last_sale

SELECT
    emp_id,
    sale_date,
    amount,
    FIRST_VALUE(amount) OVER (
        PARTITION BY emp_id ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_sale,
    LAST_VALUE(amount) OVER (
        PARTITION BY emp_id ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_sale
FROM sales
ORDER BY emp_id, sale_date;


-- PROBLEM 6D:
-- For each employee, show who earns the most and least in their department.
-- Columns: dept_id, emp_name, salary, highest_earner, lowest_earner

SELECT
    dept_id,
    emp_name,
    salary,
    FIRST_VALUE(emp_name) OVER (
        PARTITION BY dept_id ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_earner,
    LAST_VALUE(emp_name) OVER (
        PARTITION BY dept_id ORDER BY salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_earner
FROM employees
ORDER BY dept_id, salary DESC;

-- ============================================================
-- PROBLEM 08: Advanced PARTITION BY
-- ============================================================
-- 
-- PARTITION BY creates "groups" within which window functions operate.
-- Multiple PARTITION BY columns = more granular grouping.
-- Combining with aggregates = powerful analytics.
-- ============================================================

-- PROBLEM 8A:
-- For each employee, show their salary vs department average and company average.
-- Columns: dept_id, emp_name, salary, dept_avg, company_avg, diff_from_dept_avg

SELECT
    dept_id,
    emp_name,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY dept_id), 2) AS dept_avg,
    ROUND(AVG(salary) OVER (), 2) AS company_avg,
    ROUND(salary - AVG(salary) OVER (PARTITION BY dept_id), 2) AS diff_from_dept_avg
FROM employees
ORDER BY dept_id, salary DESC;


-- PROBLEM 8B:
-- For each sale, show:
-- 1. Employee's running total
-- 2. Category total for the day
-- 3. Overall daily total
-- Columns: sale_date, emp_id, product_category, amount, emp_running, category_day_total, day_total

SELECT
    sale_date,
    emp_id,
    product_category,
    amount,
    SUM(amount) OVER (PARTITION BY emp_id ORDER BY sale_date) AS emp_running_total,
    SUM(amount) OVER (PARTITION BY product_category, sale_date) AS category_day_total,
    SUM(amount) OVER (PARTITION BY sale_date) AS day_total
FROM sales
ORDER BY sale_date, emp_id;


-- PROBLEM 8C:
-- Calculate each employee's salary as a percentage of their department total
-- AND as a percentage of company total.
-- Columns: dept_id, emp_name, salary, pct_of_dept, pct_of_company

SELECT
    dept_id,
    emp_name,
    salary,
    ROUND(salary * 100.0 / SUM(salary) OVER (PARTITION BY dept_id), 2) AS pct_of_dept,
    ROUND(salary * 100.0 / SUM(salary) OVER (), 2) AS pct_of_company
FROM employees
ORDER BY dept_id, salary DESC;


-- PROBLEM 8D:
-- Count employees hired before and after each employee within their department.
-- Columns: dept_id, emp_name, hire_date, hired_before_me, hired_after_me

SELECT
    dept_id,
    emp_name,
    hire_date,
    COUNT(*) OVER (PARTITION BY dept_id ORDER BY hire_date ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS hired_before_me,
    COUNT(*) OVER (PARTITION BY dept_id ORDER BY hire_date ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) AS hired_after_me
FROM employees
ORDER BY dept_id, hire_date;

-- ============================================================
-- PROBLEM 03: LEAD() and LAG()
-- ============================================================
-- 
-- LAG(column, n) — looks at the PREVIOUS row (n rows back)
-- LEAD(column, n) — looks at the NEXT row (n rows forward)
-- 
-- Use cases: comparing current vs previous, calculating differences,
-- detecting trends (month-over-month growth)
-- ============================================================

-- PROBLEM 3A:
-- For each sale by employee 201 (Anjali), show the current sale amount
-- and the previous sale amount, ordered by date.
-- Columns: sale_date, amount, previous_sale_amount

SELECT
    sale_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY sale_date) AS previous_sale_amount
FROM sales
WHERE emp_id = 201
ORDER BY sale_date;


-- PROBLEM 3B:
-- Calculate the day-over-day change in sale amount for each employee.
-- Columns: emp_id, sale_date, amount, prev_amount, daily_change

SELECT
    emp_id,
    sale_date,
    amount,
    LAG(amount, 1) OVER (PARTITION BY emp_id ORDER BY sale_date) AS prev_amount,
    amount - LAG(amount, 1) OVER (PARTITION BY emp_id ORDER BY sale_date) AS daily_change
FROM sales
ORDER BY emp_id, sale_date;


-- PROBLEM 3C:
-- For each employee's salary history, show current month salary,
-- previous month salary, and percentage change.
-- Columns: emp_id, salary_month, salary_amount, prev_salary, pct_change

SELECT
    emp_id,
    salary_month,
    salary_amount,
    LAG(salary_amount, 1) OVER (PARTITION BY emp_id ORDER BY salary_month) AS prev_salary,
    ROUND(
        (salary_amount - LAG(salary_amount, 1) OVER (PARTITION BY emp_id ORDER BY salary_month)) * 100.0
        / LAG(salary_amount, 1) OVER (PARTITION BY emp_id ORDER BY salary_month),
        2
    ) AS pct_change
FROM salaries
ORDER BY emp_id, salary_month;


-- PROBLEM 3D:
-- Find sales where the amount DECREASED compared to the employee's previous sale.
-- Show: emp_id, sale_date, amount, prev_amount, decrease_amount

WITH sales_with_prev AS (
    SELECT
        emp_id,
        sale_date,
        amount,
        LAG(amount, 1) OVER (PARTITION BY emp_id ORDER BY sale_date) AS prev_amount
    FROM sales
)
SELECT
    emp_id,
    sale_date,
    amount,
    prev_amount,
    prev_amount - amount AS decrease_amount
FROM sales_with_prev
WHERE amount < prev_amount
ORDER BY decrease_amount DESC;

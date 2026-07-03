-- ============================================================
-- PROBLEM 04: Running Total (SUM OVER)
-- ============================================================
-- 
-- SUM() OVER (ORDER BY ...) creates a cumulative/running total
-- SUM() OVER (PARTITION BY ... ORDER BY ...) resets per group
--
-- This is one of the MOST asked patterns in interviews.
-- ============================================================

-- PROBLEM 4A:
-- Calculate running total of sales amount by date (across all employees).
-- Columns: sale_date, daily_total, running_total

SELECT
    sale_date,
    SUM(amount) AS daily_total,
    SUM(SUM(amount)) OVER (ORDER BY sale_date) AS running_total
FROM sales
GROUP BY sale_date
ORDER BY sale_date;


-- PROBLEM 4B:
-- Calculate running total of sales for EACH employee separately.
-- Columns: emp_id, sale_date, amount, running_total_per_employee

SELECT
    emp_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY emp_id ORDER BY sale_date) AS running_total_per_employee
FROM sales
ORDER BY emp_id, sale_date;


-- PROBLEM 4C:
-- Calculate what percentage each sale contributes to the employee's total sales.
-- Columns: emp_id, sale_date, amount, emp_total, pct_of_total

SELECT
    emp_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY emp_id) AS emp_total,
    ROUND(amount * 100.0 / SUM(amount) OVER (PARTITION BY emp_id), 2) AS pct_of_total
FROM sales
ORDER BY emp_id, pct_of_total DESC;


-- PROBLEM 4D:
-- Calculate cumulative bonus for each employee over months.
-- Show: emp_id, salary_month, bonus, cumulative_bonus

SELECT
    emp_id,
    salary_month,
    bonus,
    SUM(bonus) OVER (PARTITION BY emp_id ORDER BY salary_month) AS cumulative_bonus
FROM salaries
ORDER BY emp_id, salary_month;


-- PROBLEM 4E:
-- Find the date when each employee crossed 30,000 in cumulative sales.
-- (First date where running total >= 30000)

WITH running AS (
    SELECT
        emp_id,
        sale_date,
        amount,
        SUM(amount) OVER (PARTITION BY emp_id ORDER BY sale_date) AS cumulative_sales
    FROM sales
),
crossed AS (
    SELECT
        emp_id,
        sale_date,
        cumulative_sales,
        ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY sale_date) AS rn
    FROM running
    WHERE cumulative_sales >= 30000
)
SELECT emp_id, sale_date AS crossed_30k_date, cumulative_sales
FROM crossed
WHERE rn = 1;

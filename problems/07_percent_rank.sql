-- ============================================================
-- PROBLEM 07: PERCENT_RANK() and CUME_DIST()
-- ============================================================
-- 
-- PERCENT_RANK() — relative rank as percentage (0 to 1)
--   Formula: (rank - 1) / (total_rows - 1)
--
-- CUME_DIST() — cumulative distribution (what % of rows are <= this value)
--   Formula: count of rows <= current / total rows
--
-- Use cases: percentile analysis, finding top/bottom X%
-- ============================================================

-- PROBLEM 7A:
-- Calculate the percentile rank of each employee's salary.
-- Columns: emp_name, salary, percent_rank, cume_dist

SELECT
    emp_name,
    salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary)::DECIMAL, 4) AS pct_rank,
    ROUND(CUME_DIST() OVER (ORDER BY salary)::DECIMAL, 4) AS cume_dist
FROM employees
ORDER BY salary;


-- PROBLEM 7B:
-- Find employees who are in the TOP 25% of salary (75th percentile and above).
-- Columns: emp_name, dept_id, salary, percentile

WITH ranked AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        PERCENT_RANK() OVER (ORDER BY salary) AS percentile
    FROM employees
)
SELECT emp_name, dept_id, salary, ROUND(percentile::DECIMAL * 100, 1) AS percentile_pct
FROM ranked
WHERE percentile >= 0.75
ORDER BY salary DESC;


-- PROBLEM 7C:
-- Within each department, find employees in the bottom 40% of salary.
-- Columns: dept_id, emp_name, salary, dept_percentile

WITH ranked AS (
    SELECT
        dept_id,
        emp_name,
        salary,
        CUME_DIST() OVER (PARTITION BY dept_id ORDER BY salary) AS dept_cume_dist
    FROM employees
)
SELECT dept_id, emp_name, salary, ROUND(dept_cume_dist::DECIMAL * 100, 1) AS dept_percentile
FROM ranked
WHERE dept_cume_dist <= 0.40
ORDER BY dept_id, salary;


-- PROBLEM 7D:
-- Rank sales by amount and find what percentile each sale falls in.
-- Columns: emp_id, sale_date, amount, percentile_rank

SELECT
    emp_id,
    sale_date,
    amount,
    ROUND(PERCENT_RANK() OVER (ORDER BY amount)::DECIMAL * 100, 1) AS percentile_rank
FROM sales
ORDER BY amount DESC;

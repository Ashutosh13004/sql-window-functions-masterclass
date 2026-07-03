-- ============================================================
-- PROBLEM 05: NTILE()
-- ============================================================
-- 
-- NTILE(n) divides rows into n equal buckets/groups.
-- Use cases: percentiles, quartiles, bucketing for analysis
-- ============================================================

-- PROBLEM 5A:
-- Divide all employees into 4 salary quartiles (Q1=lowest, Q4=highest).
-- Columns: emp_name, salary, quartile

SELECT
    emp_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees
ORDER BY salary;


-- PROBLEM 5B:
-- Divide employees within each department into 2 groups (top half vs bottom half by salary).
-- Columns: dept_id, emp_name, salary, salary_half (1=bottom, 2=top)

SELECT
    dept_id,
    emp_name,
    salary,
    NTILE(2) OVER (PARTITION BY dept_id ORDER BY salary) AS salary_half
FROM employees
ORDER BY dept_id, salary;


-- PROBLEM 5C:
-- Categorize sales into 3 tiers: Small, Medium, Large based on amount.
-- Use NTILE(3) then CASE to label them.
-- Columns: sale_id, emp_id, amount, tier

SELECT
    sale_id,
    emp_id,
    amount,
    CASE NTILE(3) OVER (ORDER BY amount)
        WHEN 1 THEN 'Small'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'Large'
    END AS sale_tier
FROM sales
ORDER BY amount;


-- PROBLEM 5D:
-- Find the average salary for each quartile.
-- Columns: quartile, avg_salary, employee_count

WITH quartiled AS (
    SELECT
        salary,
        NTILE(4) OVER (ORDER BY salary) AS quartile
    FROM employees
)
SELECT
    quartile,
    ROUND(AVG(salary), 2) AS avg_salary,
    COUNT(*) AS employee_count
FROM quartiled
GROUP BY quartile
ORDER BY quartile;

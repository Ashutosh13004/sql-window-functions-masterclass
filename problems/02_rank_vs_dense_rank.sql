-- ============================================================
-- PROBLEM 02: RANK() vs DENSE_RANK()
-- ============================================================
-- 
-- RANK() — assigns rank with gaps (1, 2, 2, 4)
-- DENSE_RANK() — assigns rank without gaps (1, 2, 2, 3)
-- ROW_NUMBER() — always unique (1, 2, 3, 4)
-- ============================================================

-- COMPARISON EXAMPLE:
SELECT
    emp_name,
    dept_id,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS rank_val,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank_val
FROM employees;


-- PROBLEM 2A:
-- Rank employees within each department by salary.
-- Show all three ranking functions side by side.
-- Columns: dept_id, emp_name, salary, row_num, rank_val, dense_rank_val

SELECT
    dept_id,
    emp_name,
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS row_num,
    RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rank_val,
    DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dense_rank_val
FROM employees
ORDER BY dept_id, salary DESC;


-- PROBLEM 2B:
-- Find employees who have the 2nd highest salary in their department.
-- Use DENSE_RANK (so if two people tie for 1st, we still get a "2nd place").

WITH ranked AS (
    SELECT
        dept_id,
        emp_name,
        salary,
        DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS dr
    FROM employees
)
SELECT dept_id, emp_name, salary
FROM ranked
WHERE dr = 2;


-- PROBLEM 2C:
-- Rank sales employees by their total sales amount.
-- Show: emp_name, total_sales, rank
-- Use RANK() since we want to see gaps if there are ties.

SELECT
    e.emp_name,
    SUM(s.amount) AS total_sales,
    RANK() OVER (ORDER BY SUM(s.amount) DESC) AS sales_rank
FROM sales s
JOIN employees e ON s.emp_id = e.emp_id
GROUP BY e.emp_name
ORDER BY sales_rank;

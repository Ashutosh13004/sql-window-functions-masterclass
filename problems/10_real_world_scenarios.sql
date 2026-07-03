-- ============================================================
-- PROBLEM 10: Real-World Interview Scenarios
-- ============================================================
-- These are actual patterns asked in BIE/Data Engineer interviews.
-- Each one combines multiple window functions.
-- ============================================================


-- SCENARIO 10A: "Find employees whose salary is above their department average"
-- (Classic BIE interview question)

SELECT
    dept_id,
    emp_name,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY dept_id), 2) AS dept_avg,
    CASE
        WHEN salary > AVG(salary) OVER (PARTITION BY dept_id) THEN 'Above Average'
        WHEN salary = AVG(salary) OVER (PARTITION BY dept_id) THEN 'At Average'
        ELSE 'Below Average'
    END AS salary_category
FROM employees
ORDER BY dept_id, salary DESC;


-- SCENARIO 10B: "Find consecutive days where sales exceeded 20,000"
-- (Pattern: detecting streaks using LAG/LEAD or difference of row numbers)

WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(amount) AS daily_total
    FROM sales
    GROUP BY sale_date
),
high_days AS (
    SELECT
        sale_date,
        daily_total,
        sale_date - (ROW_NUMBER() OVER (ORDER BY sale_date) * INTERVAL '1 day') AS grp
    FROM daily_sales
    WHERE daily_total > 20000
)
SELECT
    MIN(sale_date) AS streak_start,
    MAX(sale_date) AS streak_end,
    COUNT(*) AS consecutive_days,
    SUM(daily_total) AS total_in_streak
FROM high_days
GROUP BY grp
HAVING COUNT(*) >= 1
ORDER BY streak_start;


-- SCENARIO 10C: "Year-over-month comparison — compare each month's bonus to previous month"
-- (Very common in reporting/analytics roles)

SELECT
    emp_id,
    salary_month,
    bonus,
    LAG(bonus, 1) OVER (PARTITION BY emp_id ORDER BY salary_month) AS prev_month_bonus,
    bonus - LAG(bonus, 1) OVER (PARTITION BY emp_id ORDER BY salary_month) AS bonus_change,
    CASE
        WHEN bonus > LAG(bonus, 1) OVER (PARTITION BY emp_id ORDER BY salary_month) THEN 'Increased'
        WHEN bonus < LAG(bonus, 1) OVER (PARTITION BY emp_id ORDER BY salary_month) THEN 'Decreased'
        ELSE 'No Change'
    END AS trend
FROM salaries
ORDER BY emp_id, salary_month;


-- SCENARIO 10D: "Find the top performer per category per day"
-- (Top N per group — the most common window function interview pattern)

WITH ranked AS (
    SELECT
        sale_date,
        product_category,
        emp_id,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY sale_date, product_category
            ORDER BY amount DESC
        ) AS rn
    FROM sales
)
SELECT
    sale_date,
    product_category,
    emp_id,
    amount AS top_sale
FROM ranked
WHERE rn = 1
ORDER BY sale_date, product_category;


-- SCENARIO 10E: "Calculate department budget allocation based on headcount and avg salary"
-- (Combines window functions with business logic)

SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    COUNT(*) OVER (PARTITION BY e.dept_id) AS dept_headcount,
    SUM(e.salary) OVER (PARTITION BY e.dept_id) AS dept_total_salary,
    ROUND(AVG(e.salary) OVER (PARTITION BY e.dept_id), 2) AS dept_avg_salary,
    ROUND(e.salary * 100.0 / SUM(e.salary) OVER (), 2) AS pct_of_total_budget
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name, e.salary DESC;


-- SCENARIO 10F: "Identify salary outliers — employees earning >1.5x their department median"
-- (Uses PERCENTILE or NTILE approach)

WITH dept_stats AS (
    SELECT
        dept_id,
        emp_name,
        salary,
        NTILE(2) OVER (PARTITION BY dept_id ORDER BY salary) AS half,
        AVG(salary) OVER (PARTITION BY dept_id) AS dept_avg,
        MAX(salary) OVER (PARTITION BY dept_id) AS dept_max,
        MIN(salary) OVER (PARTITION BY dept_id) AS dept_min
    FROM employees
)
SELECT
    dept_id,
    emp_name,
    salary,
    dept_avg,
    ROUND(salary / dept_avg, 2) AS ratio_to_avg,
    CASE
        WHEN salary > dept_avg * 1.2 THEN 'High Outlier'
        WHEN salary < dept_avg * 0.8 THEN 'Low Outlier'
        ELSE 'Normal'
    END AS outlier_flag
FROM dept_stats
ORDER BY dept_id, salary DESC;

-- ============================================================
-- PROBLEM 09: Moving Average & Window Frames
-- ============================================================
-- 
-- Window frames define WHICH ROWS the function looks at:
-- 
-- ROWS BETWEEN 2 PRECEDING AND CURRENT ROW = last 3 rows
-- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING = prev + current + next
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW = all rows up to now
--
-- Use cases: smoothing data, trend analysis, anomaly detection
-- ============================================================

-- PROBLEM 9A:
-- Calculate 3-day moving average of total daily sales.
-- Columns: sale_date, daily_total, moving_avg_3day

SELECT
    sale_date,
    SUM(amount) AS daily_total,
    ROUND(
        AVG(SUM(amount)) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3day
FROM sales
GROUP BY sale_date
ORDER BY sale_date;


-- PROBLEM 9B:
-- For each employee, calculate a 3-sale moving average.
-- Columns: emp_id, sale_date, amount, moving_avg_3sales

SELECT
    emp_id,
    sale_date,
    amount,
    ROUND(
        AVG(amount) OVER (
            PARTITION BY emp_id
            ORDER BY sale_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3sales
FROM sales
ORDER BY emp_id, sale_date;


-- PROBLEM 9C:
-- Find sales that are significantly above the employee's 3-sale moving average.
-- (More than 20% above their moving average = "spike")
-- Columns: emp_id, sale_date, amount, moving_avg, pct_above_avg

WITH with_avg AS (
    SELECT
        emp_id,
        sale_date,
        amount,
        ROUND(
            AVG(amount) OVER (
                PARTITION BY emp_id
                ORDER BY sale_date
                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
            ), 2
        ) AS moving_avg
    FROM sales
)
SELECT
    emp_id,
    sale_date,
    amount,
    moving_avg,
    ROUND((amount - moving_avg) * 100.0 / moving_avg, 2) AS pct_above_avg
FROM with_avg
WHERE amount > moving_avg * 1.20
ORDER BY pct_above_avg DESC;


-- PROBLEM 9D:
-- Calculate cumulative MIN and MAX of sales amount per employee
-- (expanding window — all rows from start to current row).
-- Columns: emp_id, sale_date, amount, running_min, running_max

SELECT
    emp_id,
    sale_date,
    amount,
    MIN(amount) OVER (
        PARTITION BY emp_id ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_min,
    MAX(amount) OVER (
        PARTITION BY emp_id ORDER BY sale_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_max
FROM sales
ORDER BY emp_id, sale_date;

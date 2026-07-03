-- ============================================================
-- SAMPLE DATABASE SETUP
-- Run this first to create tables and insert data
-- Compatible with: PostgreSQL, Redshift, MySQL 8+
-- ============================================================

-- DEPARTMENTS TABLE
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50),
    location VARCHAR(50)
);

INSERT INTO departments VALUES
(1, 'Engineering', 'Bangalore'),
(2, 'Sales', 'Mumbai'),
(3, 'Marketing', 'Delhi'),
(4, 'Operations', 'Hyderabad');

-- EMPLOYEES TABLE
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    dept_id INT,
    hire_date DATE,
    salary DECIMAL(10,2),
    manager_id INT
);

INSERT INTO employees VALUES
(101, 'Rahul Sharma',    1, '2019-03-15', 95000, NULL),
(102, 'Priya Singh',     1, '2020-07-01', 88000, 101),
(103, 'Amit Patel',      1, '2021-01-10', 75000, 101),
(104, 'Sneha Reddy',     1, '2022-06-20', 72000, 101),
(105, 'Vikram Joshi',    1, '2023-02-14', 68000, 101),
(201, 'Anjali Gupta',    2, '2018-11-05', 82000, NULL),
(202, 'Ravi Kumar',      2, '2019-08-22', 78000, 201),
(203, 'Deepa Nair',      2, '2020-04-18', 75000, 201),
(204, 'Suresh Menon',    2, '2021-09-30', 71000, 201),
(205, 'Kavita Iyer',     2, '2022-12-01', 69000, 201),
(301, 'Arjun Verma',     3, '2019-05-10', 79000, NULL),
(302, 'Pooja Desai',     3, '2020-02-28', 74000, 301),
(303, 'Manish Tiwari',   3, '2021-07-15', 70000, 301),
(304, 'Nisha Agarwal',   3, '2022-03-22', 67000, 301),
(305, 'Rohan Mehta',     3, '2023-08-05', 64000, 301),
(401, 'Sanjay Dubey',    4, '2018-06-12', 86000, NULL),
(402, 'Meena Pillai',    4, '2019-10-08', 80000, 401),
(403, 'Kiran Rao',       4, '2020-12-20', 76000, 401),
(404, 'Divya Saxena',    4, '2022-01-15', 73000, 401),
(405, 'Rajesh Pandey',   4, '2023-04-10', 65000, 401);

-- SALES TABLE (daily transactions)
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_date DATE,
    amount DECIMAL(10,2),
    product_category VARCHAR(50)
);

INSERT INTO sales VALUES
(1, 201, '2026-01-05', 15000, 'Electronics'),
(2, 202, '2026-01-05', 12000, 'Clothing'),
(3, 203, '2026-01-05', 8000, 'Electronics'),
(4, 204, '2026-01-06', 22000, 'Furniture'),
(5, 205, '2026-01-06', 9500, 'Clothing'),
(6, 201, '2026-01-07', 18000, 'Electronics'),
(7, 202, '2026-01-07', 14000, 'Furniture'),
(8, 203, '2026-01-08', 11000, 'Clothing'),
(9, 204, '2026-01-08', 25000, 'Electronics'),
(10, 205, '2026-01-09', 7500, 'Clothing'),
(11, 201, '2026-01-09', 20000, 'Furniture'),
(12, 202, '2026-01-10', 16000, 'Electronics'),
(13, 203, '2026-01-10', 13000, 'Clothing'),
(14, 204, '2026-01-11', 19000, 'Electronics'),
(15, 205, '2026-01-11', 10000, 'Furniture'),
(16, 201, '2026-01-12', 21000, 'Clothing'),
(17, 202, '2026-01-12', 17000, 'Electronics'),
(18, 203, '2026-01-13', 9000, 'Furniture'),
(19, 204, '2026-01-13', 23000, 'Electronics'),
(20, 205, '2026-01-14', 11500, 'Clothing'),
(21, 201, '2026-01-15', 24000, 'Electronics'),
(22, 202, '2026-01-15', 13500, 'Furniture'),
(23, 203, '2026-01-16', 10500, 'Clothing'),
(24, 204, '2026-01-16', 26000, 'Electronics'),
(25, 205, '2026-01-17', 8500, 'Furniture');

-- SALARIES TABLE (monthly salary history for tracking changes)
CREATE TABLE salaries (
    emp_id INT,
    salary_month DATE,
    salary_amount DECIMAL(10,2),
    bonus DECIMAL(10,2)
);

INSERT INTO salaries VALUES
(101, '2026-01-01', 95000, 5000),
(101, '2026-02-01', 95000, 3000),
(101, '2026-03-01', 98000, 4000),
(102, '2026-01-01', 88000, 4000),
(102, '2026-02-01', 88000, 2500),
(102, '2026-03-01', 90000, 3500),
(103, '2026-01-01', 75000, 3000),
(103, '2026-02-01', 75000, 2000),
(103, '2026-03-01', 77000, 2500),
(201, '2026-01-01', 82000, 6000),
(201, '2026-02-01', 82000, 8000),
(201, '2026-03-01', 85000, 7000),
(202, '2026-01-01', 78000, 5000),
(202, '2026-02-01', 78000, 4500),
(202, '2026-03-01', 80000, 5500),
(301, '2026-01-01', 79000, 3500),
(301, '2026-02-01', 79000, 4000),
(301, '2026-03-01', 81000, 3000),
(401, '2026-01-01', 86000, 4500),
(401, '2026-02-01', 86000, 5000),
(401, '2026-03-01', 89000, 4000);

-- Verify data loaded
SELECT 'employees' AS table_name, COUNT(*) AS row_count FROM employees
UNION ALL
SELECT 'departments', COUNT(*) FROM departments
UNION ALL
SELECT 'sales', COUNT(*) FROM sales
UNION ALL
SELECT 'salaries', COUNT(*) FROM salaries;

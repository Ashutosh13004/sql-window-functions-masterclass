# SQL Window Functions Masterclass 🪟

A hands-on practice repository covering SQL Window Functions from basics to advanced real-world scenarios.

## Why Window Functions?

Window functions are the #1 most asked SQL topic in Data Engineer and BIE interviews.
They let you perform calculations across rows without collapsing them (unlike GROUP BY).

## Dataset

We use a fictional **company employee + sales** dataset with 4 tables:
- `employees` — 20 employees across 4 departments
- `salaries` — monthly salary history
- `sales` — daily sales transactions
- `departments` — department details

## Problems

| # | Topic | Difficulty |
|---|-------|-----------|
| 01 | ROW_NUMBER | ⭐ Easy |
| 02 | RANK vs DENSE_RANK | ⭐ Easy |
| 03 | LEAD and LAG | ⭐⭐ Medium |
| 04 | Running Total (SUM OVER) | ⭐⭐ Medium |
| 05 | NTILE | ⭐⭐ Medium |
| 06 | FIRST_VALUE / LAST_VALUE | ⭐⭐ Medium |
| 07 | PERCENT_RANK / CUME_DIST | ⭐⭐⭐ Hard |
| 08 | Advanced PARTITION BY | ⭐⭐⭐ Hard |
| 09 | Moving Average | ⭐⭐⭐ Hard |
| 10 | Real-World Interview Scenarios | ⭐⭐⭐ Hard |

## How to Use

1. Run `data/setup.sql` to create tables and insert sample data
2. Open each problem file in `problems/` folder
3. Try to solve it yourself first
4. Check your answer against `solutions/` folder

## Tech
- SQL (compatible with PostgreSQL, Redshift, MySQL 8+)
- Can practice on: Redshift Query Editor, pgAdmin, DB Fiddle, or any SQL tool

## Author
Ashutosh Kumar 

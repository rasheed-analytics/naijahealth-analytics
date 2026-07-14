-- =====================================================================================
-- NaijaHealth System - Healthcare Analytics
-- File: 03_NaijaHealth_Advance_queries.sql
-- Author: Rasheed A. Tijani
-- Description: Advance Queries (Window Functions & CTEs) for Hospital Rank, and 
-- Revenue Analysis 
-- ====================================================================================== 

-- =========================================================================================
-- RANK hospitals by total revenue each year
-- =========================================================================================

WITH annual_revenue AS (
  SELECT hospital_name,
         SUBSTRING(month, 5, 4) AS yr,
         SUM(total_revenue_ngn)     AS total_rev
  FROM monthly_revenue
  GROUP BY hospital_name, yr
)
SELECT hospital_name, yr, total_rev,
       RANK() OVER (PARTITION BY yr ORDER BY total_rev DESC) AS revenue_rank
FROM annual_revenue
ORDER BY yr, revenue_rank;



-- =========================================================================================
-- Running total revenue (cumulative trend)
-- =========================================================================================

SELECT month, hospital_name, total_revenue_ngn,
       SUM(total_revenue_ngn) OVER (
         PARTITION BY hospital_name
         ORDER BY STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y')
         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total
FROM monthly_revenue
ORDER BY hospital_name, STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y');



-- =========================================================================================
-- Month-over-month revenue change per hospital
-- =========================================================================================

SELECT hospital_name, month, total_revenue_ngn,
       LAG(total_revenue_ngn) OVER (
         PARTITION BY hospital_name
         ORDER BY STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y')
       ) AS prev_month_rev,
       ROUND(
         (total_revenue_ngn - LAG(total_revenue_ngn) OVER (
           PARTITION BY hospital_name
           ORDER BY STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y'))
         ) * 100.0 / NULLIF(LAG(total_revenue_ngn) OVER (
           PARTITION BY hospital_name
           ORDER BY STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y')), 0),
       1) AS mom_change_pct
FROM monthly_revenue
ORDER BY hospital_name, STR_TO_DATE(CONCAT('01-', month), '%d-%b-%Y');



-- =========================================================================================
-- Window Functions & CTEs
-- CTE: High-risk patients (long stay + outstanding balance)
-- =========================================================================================

WITH high_risk AS (
  SELECT patient_id, full_name, hospital_name,
         diagnosis, length_of_stay_days,
         outstanding_balance_ngn, satisfaction_score,
         readmission_flag
FROM patient_records
  WHERE length_of_stay_days > 14
  AND outstanding_balance_ngn > 200000
    AND readmission_flag = 'Yes'
)
SELECT *,
       RANK() OVER (PARTITION BY hospital_name
                   ORDER BY outstanding_balance_ngn
				   DESC) AS risk_rank
FROM high_risk;



-- =========================================================================================
-- Staff self-join: Identify doctors with above-average salaries in same department
-- =========================================================================================

SELECT s1.staff_name, s1.role, s1.department,
       s1.monthly_salary_ngn,
       round(dept_avg.avg_salary,0) avg_salary,
       ROUND(s1.monthly_salary_ngn - dept_avg.avg_salary, 0) AS above_avg_by
FROM staff_operations s1
JOIN (
  SELECT department,
         AVG(monthly_salary_ngn) AS avg_salary
  FROM staff_operations
  GROUP BY department
) dept_avg ON s1.department = dept_avg.department
WHERE s1.monthly_salary_ngn > dept_avg.avg_salary
ORDER BY above_avg_by DESC;
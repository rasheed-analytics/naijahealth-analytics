-- =====================================================================================
-- NaijaHealth System - Healthcare Analytics
-- File: 02_NaijaHealth_intermediate_queries.sql
-- Author: Rasheed A. Tijani
-- Description: Intermediate Queries (Business Intelligence) for Monthly revenue Analysis,
-- Diagnoses bill and Readmission rate by insurance provider
-- ====================================================================================== 

select *
from monthly_revenue;

-- =========================================================================================
-- Monthly revenue trend (year-over-year comparison)
-- =========================================================================================

SELECT SUBSTRING(month, 5, 4) AS year,
       SUBSTRING(month, 1, 3) AS mon,
       SUM(Total_Revenue_NGN)     AS total_rev,
       SUM(Net_Profit_NGN)        AS total_profit
FROM monthly_revenue
 GROUP BY year, mon
 ORDER BY year, FIELD(mon,'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec');
        
        

-- =========================================================================================        
-- Top 5 diagnoses by average bill
-- =========================================================================================

SELECT diagnosis,
       COUNT(*)                         AS cases,
       ROUND(AVG(bill_amount_ngn), 0)   AS avg_bill,
       ROUND(AVG(outstanding_balance_ngn),0) AS avg_outstanding
FROM patient_records
GROUP BY diagnosis
ORDER BY avg_bill DESC
LIMIT 5;



-- =========================================================================================
-- Readmission rate by insurance provider
-- =========================================================================================

SELECT insurance_provider,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmission_flag = 'Yes' THEN 1 ELSE 0 END) AS readmissions,
       ROUND(
         SUM(CASE WHEN readmission_flag = 'Yes' THEN 1 ELSE 0 END)
         * 100.0 / COUNT(*), 1) AS readmission_rate_pct
FROM patient_records
GROUP BY insurance_provider
ORDER BY readmission_rate_pct DESC;


-- =========================================================================================
-- Revenue per patient vs bed occupancy by hospital
-- =========================================================================================

SELECT hospital_name,
       ROUND(AVG(avg_revenue_per_patient_ngn), 0) AS avg_rev_per_patient,
       ROUND(AVG(occupancy_rate_pct) * 100, 1) AS avg_occupancy_pct
FROM monthly_revenue
GROUP BY hospital_name
ORDER BY avg_rev_per_patient DESC;




-- ========================================================================================
-- Total patients per hospital
-- ========================================================================================

SELECT hospital_name,
       COUNT(*) AS total_patients
FROM patient_records
GROUP BY hospital_name
ORDER BY total_patients DESC;



-- =========================================================================================
-- Gender split across the dataset
-- =========================================================================================

SELECT gender,
       COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patient_records), 1) AS pct
FROM patient_records
GROUP BY gender;



-- =========================================================================================
-- Average length of stay by department
-- =========================================================================================

SELECT department,
       ROUND(AVG(length_of_stay_days), 1) AS avg_los,
       COUNT(*) AS patient_count
FROM patient_records
GROUP BY department
ORDER BY avg_los DESC;



-- =========================================================================================
-- Monthly revenue trend (year-over-year comparison)
-- =========================================================================================

SELECT SUBSTRING(month, 5, 4) AS year,
       SUBSTRING(month, 1, 3) AS mon,
       SUM(Total_Revenue_NGN)     AS total_rev,
       SUM(Net_Profit_NGN)        AS total_profit
FROM monthly_revenue
 GROUP BY year, mon
 ORDER BY year, FIELD(mon,'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec');
        
        

-- =========================================================================================        
-- Top 5 diagnoses by average bill
-- =========================================================================================

SELECT diagnosis,
       COUNT(*)                         AS cases,
       ROUND(AVG(bill_amount_ngn), 0)   AS avg_bill,
       ROUND(AVG(outstanding_balance_ngn),0) AS avg_outstanding
FROM patient_records
GROUP BY diagnosis
ORDER BY avg_bill DESC
LIMIT 5;



-- =========================================================================================
-- Readmission rate by insurance provider
-- =========================================================================================

SELECT insurance_provider,
       COUNT(*) AS total_patients,
       SUM(CASE WHEN readmission_flag = 'Yes' THEN 1 ELSE 0 END) AS readmissions,
       ROUND(
         SUM(CASE WHEN readmission_flag = 'Yes' THEN 1 ELSE 0 END)
         * 100.0 / COUNT(*), 1) AS readmission_rate_pct
FROM patient_records
GROUP BY insurance_provider
ORDER BY readmission_rate_pct DESC;


-- =========================================================================================
-- Revenue per patient vs bed occupancy by hospital
-- =========================================================================================

SELECT hospital_name,
       ROUND(AVG(avg_revenue_per_patient_ngn), 0) AS avg_rev_per_patient,
       ROUND(AVG(occupancy_rate_pct) * 100, 1) AS avg_occupancy_pct
FROM monthly_revenue
GROUP BY hospital_name
ORDER BY avg_rev_per_patient DESC;

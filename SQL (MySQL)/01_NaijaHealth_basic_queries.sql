-- =====================================================================================
-- NaijaHealth System - Healthcare Analytics
-- File: 01_NaijaHealth_basic_queries.sql
-- Author: Rasheed A. Tijani
-- Description: Basic Queries (Warm Up) for Patient Analysis
-- ====================================================================================== 


select *
from patient_records;

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


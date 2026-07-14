-- =====================================================================================
-- NaijaHealth System - Healthcare Analytics
-- File: 04_NaijaHealth_Store Procedure & View.sql
-- Author: Rasheed A. Tijani
-- Description: Store Procedure and View for Monthly Hospital Performance Summary 
-- ====================================================================================== 


-- =========================================================================================
-- Stored Procedure & View
-- CREATE A VIEW: Monthly hospital performance summary
-- =========================================================================================

CREATE OR REPLACE VIEW vw_hospital_performance AS
SELECT hospital_name,
       COUNT(DISTINCT month)                  AS months_tracked,
       ROUND(SUM(total_revenue_ngn), 0)           AS total_revenue,
       ROUND(AVG(profit_margin_pct) * 100, 1) AS avg_margin_pct,
       ROUND(AVG(occupancy_rate_pct) * 100, 1)    AS avg_occupancy_pct,
       SUM(patient_volume)                    AS total_patient_volume
FROM monthly_revenue
GROUP BY hospital_name;



-- =========================================================================================
-- -- Query the view (looks and behaves like a table)
-- =========================================================================================

SELECT * 
FROM vw_hospital_performance
ORDER BY total_revenue DESC;

-- =========================================================================================
-- STORED PROCEDURE: Filter patients by hospital and outcome
-- =========================================================================================

DELIMITER $$
CREATE PROCEDURE GetPatientsByHospitalOutcome(
  IN p_hospital VARCHAR(100),
  IN p_outcome  VARCHAR(30)
)
BEGIN
  SELECT patient_id, full_name, diagnosis, admission_date,
         length_of_stay_days, bill_amount_ngn
  FROM patient_records
  WHERE hospital_name = p_hospital
    AND patient_outcome = p_outcome
  ORDER BY admission_date DESC;
END $$
DELIMITER ;

-- =========================================================================================
-- Call it:
-- =========================================================================================

CALL GetPatientsByHospitalOutcome('Lagos General Hospital', 'Discharged');

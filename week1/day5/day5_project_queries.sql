-- ============================================================
-- Day 5 Project Queries: Hospital Management System
-- ============================================================

USE hospital_db;

-- ============================================================
-- SELECT QUERIES (5 with filtering, sorting, limiting)
-- ============================================================

-- Q1: All completed appointments sorted by date, limited to 5
SELECT a.appointment_id, p.first_name, p.last_name, d.first_name AS doctor,
       a.appt_date, a.reason
FROM appointment AS a
INNER JOIN patient AS p ON a.patient_id = p.patient_id
INNER JOIN doctor  AS d ON a.doctor_id  = d.doctor_id
WHERE a.status = 'Completed'
ORDER BY a.appt_date DESC
LIMIT 5;

-- Q2: Patients born after 1990 (younger patients)
SELECT patient_id, first_name, last_name, dob, gender
FROM patient
WHERE dob > '1990-01-01'
ORDER BY dob ASC;

-- Q3: Doctors in Cardiology or Neurology departments (IN filter)
SELECT d.first_name, d.last_name, d.specialization, dept.dept_name
FROM doctor AS d
INNER JOIN department AS dept ON d.department_id = dept.department_id
WHERE dept.dept_name IN ('Cardiology', 'Neurology')
ORDER BY dept.dept_name, d.last_name;

-- Q4: Appointments scheduled in March 2024 (BETWEEN date range)
SELECT a.appointment_id, p.first_name, p.last_name,
       a.appt_date, a.status
FROM appointment AS a
INNER JOIN patient AS p ON a.patient_id = p.patient_id
WHERE a.appt_date BETWEEN '2024-03-01' AND '2024-03-31'
ORDER BY a.appt_date ASC;

-- Q5: Prescriptions with duration longer than 14 days (long-term meds)
SELECT pr.prescription_id, pr.medication_name, pr.dosage,
       pr.duration_days, a.appt_date,
       CONCAT(p.first_name,' ',p.last_name) AS patient_name
FROM prescription AS pr
INNER JOIN appointment AS a ON pr.appointment_id = a.appointment_id
INNER JOIN patient     AS p ON a.patient_id      = p.patient_id
WHERE pr.duration_days > 14
ORDER BY pr.duration_days DESC;

-- ============================================================
-- JOIN QUERIES (3: INNER, LEFT, three-table)
-- ============================================================

-- J1: INNER JOIN – Patients with their appointment details
SELECT
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    a.appt_date, a.reason, a.status
FROM appointment AS a
INNER JOIN patient AS p ON a.patient_id = p.patient_id
INNER JOIN doctor  AS d ON a.doctor_id  = d.doctor_id
ORDER BY a.appt_date;

-- J2: LEFT JOIN – All patients including those with no appointments
SELECT
    p.patient_id,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    a.appointment_id,
    a.appt_date,
    a.status
FROM patient AS p
LEFT JOIN appointment AS a ON p.patient_id = a.patient_id
ORDER BY p.last_name;

-- J3: THREE-TABLE JOIN – Doctor + department + appointment count
SELECT
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    dept.dept_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments
FROM doctor AS d
INNER JOIN department AS dept ON d.department_id = dept.department_id
LEFT  JOIN appointment AS a  ON d.doctor_id      = a.doctor_id
GROUP BY d.doctor_id, doctor_name, dept.dept_name, d.specialization
ORDER BY total_appointments DESC;

-- ============================================================
-- AGGREGATE QUERIES (2 with GROUP BY + HAVING)
-- ============================================================

-- A1: Number of appointments per department
SELECT
    dept.dept_name,
    COUNT(a.appointment_id) AS total_appointments
FROM department AS dept
INNER JOIN doctor      AS d ON dept.department_id = d.department_id
LEFT  JOIN appointment AS a ON d.doctor_id        = a.doctor_id
GROUP BY dept.department_id, dept.dept_name
HAVING total_appointments > 0
ORDER BY total_appointments DESC;

-- A2: Average prescription duration per doctor (only > 10 days avg)
SELECT
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    ROUND(AVG(pr.duration_days), 1)      AS avg_prescription_days,
    COUNT(pr.prescription_id)            AS total_prescriptions
FROM prescription AS pr
INNER JOIN appointment AS a ON pr.appointment_id = a.appointment_id
INNER JOIN doctor      AS d ON a.doctor_id       = d.doctor_id
GROUP BY d.doctor_id, doctor_name
HAVING avg_prescription_days > 10
ORDER BY avg_prescription_days DESC;

-- ============================================================
-- SUBQUERY
-- Patients who have more appointments than the average patient
-- ============================================================
SELECT
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    COUNT(a.appointment_id)              AS appointment_count
FROM patient AS p
INNER JOIN appointment AS a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, patient_name
HAVING appointment_count > (
    SELECT AVG(appt_count)
    FROM (
        SELECT patient_id, COUNT(*) AS appt_count
        FROM appointment
        GROUP BY patient_id
    ) AS counts
)
ORDER BY appointment_count DESC;

-- ============================================================
-- TRANSACTION (COMMIT version)
-- Register a new patient and schedule her first appointment atomically
-- ============================================================
BEGIN;

INSERT INTO patient (first_name, last_name, dob, gender, phone, address)
VALUES ('Marie', 'Niyonzima', '1992-07-19', 'F', '+250788300001', 'KG 20 Ave, Kigali');

INSERT INTO appointment (patient_id, doctor_id, appt_date, reason, status)
VALUES (LAST_INSERT_ID(), 4, '2024-04-01 09:00:00', 'New patient consultation', 'Scheduled');

COMMIT;
-- Both inserts are now permanent. Marie exists in patient and has an appointment.

-- ROLLBACK version (undoes everything)
BEGIN;

INSERT INTO patient (first_name, last_name, dob, gender, phone, address)
VALUES ('TestPatient', 'Rollback', '2000-01-01', 'M', '+250788399999', 'Test Address');

INSERT INTO appointment (patient_id, doctor_id, appt_date, reason, status)
VALUES (LAST_INSERT_ID(), 1, '2024-04-02 10:00:00', 'Test appointment', 'Scheduled');

ROLLBACK;
-- Neither insert was saved. The database is unchanged.

-- ============================================================
-- INDEX + EXPLAIN
-- ============================================================

-- BEFORE index: MySQL scans all rows in appointment
EXPLAIN SELECT * FROM appointment WHERE patient_id = 1;

-- Create index on patient_id (heavily used in JOIN and WHERE clauses)
CREATE INDEX idx_appointment_patient ON appointment (patient_id);

-- AFTER index: MySQL uses idx_appointment_patient (type: ref)
-- The "rows" estimate is now much smaller — a targeted lookup instead of a full scan.
EXPLAIN SELECT * FROM appointment WHERE patient_id = 1;

-- ============================================================
-- VIEW: doctor_patient_summary
-- Combines doctor, patient, and appointment for an easy-access report
-- ============================================================
CREATE OR REPLACE VIEW doctor_patient_summary AS
SELECT
    a.appointment_id,
    CONCAT(d.first_name,' ',d.last_name) AS doctor_name,
    d.specialization,
    dept.dept_name,
    CONCAT(p.first_name,' ',p.last_name) AS patient_name,
    p.gender,
    a.appt_date,
    a.reason,
    a.status
FROM appointment AS a
INNER JOIN doctor     AS d    ON a.doctor_id     = d.doctor_id
INNER JOIN department AS dept ON d.department_id = dept.department_id
INNER JOIN patient    AS p    ON a.patient_id    = p.patient_id;

-- Query the view
SELECT * FROM doctor_patient_summary
WHERE status = 'Scheduled'
ORDER BY appt_date ASC;

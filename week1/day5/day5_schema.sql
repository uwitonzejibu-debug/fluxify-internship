-- ============================================================
-- Day 5 Schema: Hospital Management System
-- New Domain: Hospital (different from Day 1 school domain)
-- ============================================================

CREATE DATABASE IF NOT EXISTS hospital_db;
USE hospital_db;

-- ============================================================
-- TABLE: department
-- Represents a hospital department (e.g., Cardiology, Pediatrics)
-- ============================================================
CREATE TABLE department (
    department_id   INT          NOT NULL AUTO_INCREMENT,
    dept_name       VARCHAR(100) NOT NULL UNIQUE,
    location        VARCHAR(100) NOT NULL,
    PRIMARY KEY (department_id)
);

-- ============================================================
-- TABLE: doctor
-- Each doctor belongs to one department (1:N)
-- ============================================================
CREATE TABLE doctor (
    doctor_id       INT          NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(60)  NOT NULL,
    last_name       VARCHAR(60)  NOT NULL,
    specialization  VARCHAR(100) NOT NULL,
    phone           VARCHAR(20)  NOT NULL UNIQUE,
    email           VARCHAR(120) NOT NULL UNIQUE,
    department_id   INT          NOT NULL,
    PRIMARY KEY (doctor_id),
    FOREIGN KEY (department_id) REFERENCES department(department_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: patient
-- Represents a patient registered in the hospital
-- ============================================================
CREATE TABLE patient (
    patient_id      INT          NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(60)  NOT NULL,
    last_name       VARCHAR(60)  NOT NULL,
    dob             DATE         NOT NULL,
    gender          ENUM('M','F','Other') NOT NULL,
    phone           VARCHAR(20)  NOT NULL UNIQUE,
    address         VARCHAR(255),
    PRIMARY KEY (patient_id)
);

-- ============================================================
-- TABLE: appointment (junction table – Doctor M:N Patient)
-- Resolves the M:N relationship: a patient can see many doctors
-- and a doctor can see many patients across many appointments
-- ============================================================
CREATE TABLE appointment (
    appointment_id  INT          NOT NULL AUTO_INCREMENT,
    patient_id      INT          NOT NULL,
    doctor_id       INT          NOT NULL,
    appt_date       DATETIME     NOT NULL,
    reason          VARCHAR(255) NOT NULL,
    status          ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled',
    PRIMARY KEY (appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id)  REFERENCES doctor(doctor_id)   ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: prescription
-- A prescription is written by a doctor for a patient
-- Links back to an appointment for full traceability
-- ============================================================
CREATE TABLE prescription (
    prescription_id INT          NOT NULL AUTO_INCREMENT,
    appointment_id  INT          NOT NULL,
    medication_name VARCHAR(150) NOT NULL,
    dosage          VARCHAR(80)  NOT NULL,
    duration_days   INT          NOT NULL DEFAULT 7,
    notes           TEXT,
    PRIMARY KEY (prescription_id),
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id) ON DELETE CASCADE
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Departments
INSERT INTO department (dept_name, location) VALUES
('Cardiology',       'Block A – Floor 2'),
('Pediatrics',       'Block B – Floor 1'),
('Orthopedics',      'Block C – Floor 3'),
('General Medicine', 'Block A – Floor 1'),
('Neurology',        'Block D – Floor 2');

-- Doctors
INSERT INTO doctor (first_name, last_name, specialization, phone, email, department_id) VALUES
('Jean',    'Mugisha',    'Cardiologist',    '+250781001001', 'j.mugisha@hospital.rw',    1),
('Amina',   'Uwase',      'Pediatrician',    '+250781001002', 'a.uwase@hospital.rw',      2),
('Patrick', 'Nkurunziza', 'Orthopedic Surgeon', '+250781001003', 'p.nkuru@hospital.rw',  3),
('Grace',   'Iradukunda', 'General Practitioner', '+250781001004', 'g.ira@hospital.rw',  4),
('Eric',    'Hakizimana', 'Neurologist',     '+250781001005', 'e.haki@hospital.rw',       5),
('Diane',   'Mutoni',     'Cardiologist',    '+250781001006', 'd.mutoni@hospital.rw',     1),
('Samuel',  'Nsabimana',  'Pediatrician',    '+250781001007', 's.nsabi@hospital.rw',      2),
('Claire',  'Yankurije',  'General Practitioner', '+250781001008', 'c.yanku@hospital.rw', 4),
('Pierre',  'Habimana',   'Neurologist',     '+250781001009', 'p.habi@hospital.rw',       5),
('Solange', 'Keza',       'Orthopedic Surgeon', '+250781001010', 's.keza@hospital.rw',   3);

-- Patients
INSERT INTO patient (first_name, last_name, dob, gender, phone, address) VALUES
('Alice',   'Uwimana',   '1985-06-12', 'F', '+250788200001', 'KG 5 Ave, Kigali'),
('Bob',     'Habimana',  '1990-03-25', 'M', '+250788200002', 'KN 7 Rd, Kigali'),
('Chloe',   'Mukamana',  '1978-11-08', 'F', '+250788200003', 'KG 11 Ave, Kigali'),
('Daniel',  'Nzeyimana', '2005-09-14', 'M', '+250788200004', 'KN 3 Rd, Kigali'),
('Eva',     'Ingabire',  '1995-02-20', 'F', '+250788200005', 'KG 2 Ave, Kigali'),
('Frank',   'Bizimana',  '1960-07-30', 'M', '+250788200006', 'KG 8 Ave, Kigali'),
('Grace',   'Mutesi',    '1988-04-17', 'F', '+250788200007', 'KN 5 Rd, Kigali'),
('Henry',   'Ndayisaba', '2010-12-01', 'M', '+250788200008', 'KG 14 Ave, Kigali'),
('Isabelle','Uwineza',   '1975-08-23', 'F', '+250788200009', 'KN 9 Rd, Kigali'),
('James',   'Tuyisenge', '1999-01-05', 'M', '+250788200010', 'KG 3 Ave, Kigali');

-- Appointments
INSERT INTO appointment (patient_id, doctor_id, appt_date, reason, status) VALUES
(1,  1, '2024-03-10 09:00:00', 'Chest pain follow-up',     'Completed'),
(2,  4, '2024-03-11 10:30:00', 'General check-up',          'Completed'),
(3,  3, '2024-03-12 08:00:00', 'Knee pain assessment',      'Completed'),
(4,  2, '2024-03-12 11:00:00', 'Vaccination',               'Completed'),
(5,  5, '2024-03-13 14:00:00', 'Migraine consultation',     'Completed'),
(6,  1, '2024-03-14 09:30:00', 'Annual cardiac review',     'Completed'),
(7,  6, '2024-03-15 10:00:00', 'Heart palpitations',        'Scheduled'),
(8,  7, '2024-03-15 11:00:00', 'Flu symptoms',              'Scheduled'),
(9,  9, '2024-03-16 09:00:00', 'Headache investigation',    'Scheduled'),
(10, 4, '2024-03-16 13:00:00', 'Fever',                     'Scheduled'),
(1,  4, '2024-03-17 10:00:00', 'Blood pressure management', 'Scheduled'),
(3,  10,'2024-03-18 08:30:00', 'Post-surgery follow-up',    'Scheduled');

-- Prescriptions
INSERT INTO prescription (appointment_id, medication_name, dosage, duration_days, notes) VALUES
(1, 'Aspirin',        '100mg once daily',     30, 'Take with food'),
(1, 'Atorvastatin',   '20mg once at bedtime', 90, 'Monitor liver enzymes'),
(2, 'Paracetamol',    '500mg when needed',    7,  'Max 4 doses per day'),
(3, 'Ibuprofen',      '400mg three times daily', 10, 'Avoid on empty stomach'),
(4, 'Vitamin D',      '1000 IU daily',        30, 'After meals'),
(5, 'Sumatriptan',    '50mg at onset',        5,  'Do not exceed 2 doses/day'),
(6, 'Metoprolol',     '25mg twice daily',     60, 'Do not stop abruptly');

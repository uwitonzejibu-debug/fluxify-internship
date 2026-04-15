# Week 1 – Day 5: Full Database Project – Hospital Management System

**Name:** [Your Full Name]  
**Domain:** Hospital Management System  
**Database:** `hospital_db`

---

## System overview

This system models a hospital where doctors are organised into departments,
patients book appointments with specific doctors, and prescriptions are
issued from those appointments. The design supports multi-department
hospitals with many doctors and thousands of patient records.

---

## Schema design

### Tables

| Table | Purpose |
|---|---|
| `department` | Hospital departments (Cardiology, Neurology, …) |
| `doctor` | Doctors; each belongs to one department (1:N) |
| `patient` | Registered patients |
| `appointment` | Junction table – resolves Doctor M:N Patient |
| `prescription` | Medications issued for a specific appointment |

### Relationships

- **Department → Doctor**: 1:N — one department employs many doctors
- **Doctor ↔ Patient (via Appointment)**: M:N — a doctor sees many patients across many appointments; a patient can see many doctors
- **Appointment → Prescription**: 1:N — one appointment may generate multiple prescriptions

### Normalization (3NF)

- **1NF**: Every column holds a single atomic value; no repeating groups.
- **2NF**: Every non-key attribute depends on the full primary key. The `appointment` table stores `patient_id` and `doctor_id` as foreign keys, not repeated patient/doctor details.
- **3NF**: No transitive dependencies. Doctor specialization lives in `doctor`, not in `appointment`. Department location lives in `department`, not repeated in `doctor`.

### Key design decisions

The `appointment` table was chosen as the junction table for the M:N
relationship because a raw many-to-many link between doctor and patient
carries no useful data on its own — the appointment date, reason, and
status are what make the link meaningful. Storing `prescription` as a
child of `appointment` (rather than directly under patient or doctor)
maintains full traceability: every medication is tied to a specific
clinical visit.

---

## Advanced features

### Transaction
Registering a new patient and booking her first appointment are wrapped in
a single transaction so both succeed or neither is saved.

### Index
An index on `appointment.patient_id` is created because that column is
used in every patient-lookup JOIN and in the subquery that counts
appointments per patient.

### View
`doctor_patient_summary` joins all five tables into a ready-to-use
reporting view, returning doctor name, department, patient name, appointment
date, and status in one query.

---

## Files

| File | Description |
|---|---|
| `day5_schema.sql` | CREATE TABLE + INSERT statements |
| `day5_project_queries.sql` | 5 SELECT, 3 JOIN, 2 aggregate, 1 subquery, 1 transaction, 1 index, 1 view |
| `hospital_erd.png` | ERD diagram (Chen notation, Draw.io export) |

-- ============================================================
-- Day 2 Queries: CRUD Operations – school_db
-- ============================================================

USE school_db;

-- ============================================================
-- SELECT 1: Students ordered by last name, limited to 5 rows
-- Uses WHERE, ORDER BY, and LIMIT together
-- ============================================================
SELECT student_id, first_name, last_name, dob
FROM student
WHERE class_id IS NOT NULL
ORDER BY last_name ASC
LIMIT 5;

-- ============================================================
-- SELECT 2: LIKE – find students whose first name starts with 'A'
-- ============================================================
SELECT student_id, first_name, last_name
FROM student
WHERE first_name LIKE 'A%';

-- ============================================================
-- SELECT 3: BETWEEN – find enrollments with grades between 70 and 90
-- ============================================================
SELECT enrollment_id, student_id, course_id, grade
FROM enrollment
WHERE grade BETWEEN 70.00 AND 90.00
ORDER BY grade DESC;

-- ============================================================
-- SELECT 4: IN – find students in specific classes (class_id 1, 3, 5)
-- ============================================================
SELECT student_id, first_name, last_name, class_id
FROM student
WHERE class_id IN (1, 3, 5);

-- ============================================================
-- SELECT 5: DISTINCT – list distinct grades (grade levels) from class table
-- ============================================================
SELECT DISTINCT grade
FROM class
ORDER BY grade ASC;

-- ============================================================
-- UPDATE: Change Alice Uwimana's grade in Mathematics (course_id 1)
-- Verify by running SELECT after the update
-- ============================================================
UPDATE enrollment
SET grade = 92.00
WHERE student_id = 1 AND course_id = 1;

-- Verify the change
SELECT e.enrollment_id, s.first_name, s.last_name, c.course_name, e.grade
FROM enrollment e
JOIN student s ON e.student_id = s.student_id
JOIN course  c ON e.course_id  = c.course_id
WHERE e.student_id = 1 AND e.course_id = 1;

-- ============================================================
-- DELETE: Remove the enrollment record for student_id=10, course_id=10
-- Uses a specific WHERE condition to avoid accidental mass delete
-- ============================================================
DELETE FROM enrollment
WHERE student_id = 10 AND course_id = 10;

-- ============================================================
-- ALTER TABLE: Add an 'email' column to the student table
-- ============================================================
ALTER TABLE student
ADD COLUMN email VARCHAR(120) UNIQUE AFTER last_name;

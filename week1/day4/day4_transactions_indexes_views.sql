-- ============================================================
-- Day 4: Transactions, Indexes & Views – school_db
-- ============================================================

USE school_db;

-- ============================================================
-- TRANSACTION WITH COMMIT
-- Enrolls a new student and immediately creates her enrollment record.
-- Both operations must succeed together; if one fails, neither should
-- be saved. COMMIT makes both changes permanent.
-- ============================================================
BEGIN;

INSERT INTO student (first_name, last_name, dob, class_id)
VALUES ('Sophie', 'Kamanzi', '2009-04-10', 2);

INSERT INTO enrollment (student_id, course_id, enrolled_date)
VALUES (LAST_INSERT_ID(), 1, CURDATE());

COMMIT;
-- Result: Sophie is now in the student table AND has an enrollment.

-- ============================================================
-- SAME TRANSACTION WITH ROLLBACK
-- ROLLBACK undoes every change made since BEGIN.
-- Neither the INSERT into student nor the INSERT into enrollment
-- will be saved — the database returns to its previous state.
-- ============================================================
BEGIN;

INSERT INTO student (first_name, last_name, dob, class_id)
VALUES ('TestUser', 'ToDelete', '2010-01-01', 1);

INSERT INTO enrollment (student_id, course_id, enrolled_date)
VALUES (LAST_INSERT_ID(), 2, CURDATE());

ROLLBACK;
-- Result: No new student or enrollment was added.

-- ============================================================
-- SIMULATED FAILURE TRANSACTION
-- The second INSERT intentionally references a non-existent course_id (9999).
-- MySQL enforces the FOREIGN KEY constraint and raises an error.
-- Because we are inside a transaction, MySQL does NOT auto-commit;
-- calling ROLLBACK (or having the client roll back on error) reverts
-- the first INSERT as well, so the database stays consistent.
-- ============================================================
BEGIN;

INSERT INTO student (first_name, last_name, dob, class_id)
VALUES ('ErrorTest', 'Student', '2010-06-15', 1);

-- This line will FAIL: course_id 9999 does not exist (FK violation)
INSERT INTO enrollment (student_id, course_id, enrolled_date)
VALUES (LAST_INSERT_ID(), 9999, CURDATE());

-- Because the second statement errored, we roll back both changes:
ROLLBACK;
-- Result: MySQL caught the FK error. ROLLBACK ensures 'ErrorTest'
-- student was also removed, keeping both tables in a consistent state.

-- ============================================================
-- INDEX
-- We frequently search enrollments by student_id and filter grades.
-- Adding an index on student_id speeds up JOIN lookups and WHERE filters
-- on that column. Without an index MySQL scans every row (full table scan).
-- ============================================================

-- Before index – MySQL does a full table scan (type: ALL)
EXPLAIN SELECT * FROM enrollment WHERE student_id = 1;

CREATE INDEX idx_enrollment_student ON enrollment (student_id);

-- After index – MySQL uses the index (type: ref, key: idx_enrollment_student)
-- The "rows" estimate drops dramatically, showing the index is used.
EXPLAIN SELECT * FROM enrollment WHERE student_id = 1;

-- Second index: grade column is used in range filters and ORDER BY
CREATE INDEX idx_enrollment_grade ON enrollment (grade);

-- ============================================================
-- VIEW: student_report_card
-- Joins student, class, course, and enrollment into a single
-- readable view that shows each student's full report card.
-- Useful for reporting without re-writing the join every time.
-- ============================================================
CREATE OR REPLACE VIEW student_report_card AS
SELECT
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    cl.class_name,
    cl.grade                               AS grade_level,
    co.course_name,
    co.credits,
    e.grade                                AS score,
    e.enrolled_date,
    CASE
        WHEN e.grade >= 90 THEN 'A'
        WHEN e.grade >= 80 THEN 'B'
        WHEN e.grade >= 70 THEN 'C'
        WHEN e.grade >= 60 THEN 'D'
        ELSE                    'F'
    END                                    AS letter_grade
FROM enrollment AS e
INNER JOIN student AS s  ON e.student_id = s.student_id
INNER JOIN class   AS cl ON s.class_id   = cl.class_id
INNER JOIN course  AS co ON e.course_id  = co.course_id;

-- Query the view to confirm it works
SELECT * FROM student_report_card ORDER BY student_name, course_name;

-- Useful sub-query on the view: average score per student
SELECT student_name, ROUND(AVG(score), 2) AS gpa
FROM student_report_card
GROUP BY student_id, student_name
ORDER BY gpa DESC;

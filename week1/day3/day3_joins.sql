-- ============================================================
-- Day 3 Queries: Joins & Relationships – school_db
-- ============================================================

USE school_db;

-- ============================================================
-- INNER JOIN: Students with the courses they are enrolled in
-- Returns only students who have at least one enrollment
-- Both tables must have a matching row for a result to appear
-- ============================================================
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade,
    e.enrolled_date
FROM enrollment AS e
INNER JOIN student AS s ON e.student_id = s.student_id
INNER JOIN course  AS c ON e.course_id  = c.course_id
ORDER BY s.last_name ASC;

-- ============================================================
-- LEFT JOIN: All students including those with no enrollments
-- Students without any enrollment will show NULL in course columns
-- Useful to find students who have not signed up for anything
-- ============================================================
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    e.course_id,
    e.grade
FROM student AS s
LEFT JOIN enrollment AS e ON s.student_id = e.student_id
ORDER BY s.last_name ASC;

-- ============================================================
-- LEFT JOIN with IS NULL: Students who have NO enrollments at all
-- IS NULL on the FK column from the right table isolates unmatched rows
-- ============================================================
SELECT
    s.student_id,
    s.first_name,
    s.last_name
FROM student AS s
LEFT JOIN enrollment AS e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

-- ============================================================
-- RIGHT JOIN: All courses including those with no enrollments
-- Compare with LEFT JOIN above – here the "kept" side is course
-- RIGHT JOIN: every course appears; students side may be NULL
-- LEFT  JOIN: every student appears; course side may be NULL
-- ============================================================
SELECT
    c.course_id,
    c.course_name,
    e.student_id,
    e.grade
FROM enrollment AS e
RIGHT JOIN course AS c ON e.course_id = c.course_id
ORDER BY c.course_name ASC;

-- ============================================================
-- THREE-TABLE JOIN: Student name + class name + course name
-- Shows the complete picture of where each student sits and
-- what subjects they take, ordered by class then student name
-- ============================================================
SELECT
    s.first_name,
    s.last_name,
    cl.class_name,
    cl.grade       AS grade_level,
    co.course_name,
    e.enrolled_date,
    e.grade        AS course_grade
FROM enrollment AS e
INNER JOIN student AS s  ON e.student_id = s.student_id
INNER JOIN class   AS cl ON s.class_id   = cl.class_id
INNER JOIN course  AS co ON e.course_id  = co.course_id
ORDER BY cl.class_name ASC, s.last_name ASC;

-- ============================================================
-- JOIN ANALYSIS: Row count comparison
-- INNER JOIN returns only matched rows; LEFT JOIN returns all students
-- The difference reveals how many students have zero enrollments
-- ============================================================
-- Count from INNER JOIN
SELECT COUNT(*) AS inner_join_rows
FROM student AS s
INNER JOIN enrollment AS e ON s.student_id = e.student_id;

-- Count from LEFT JOIN
SELECT COUNT(*) AS left_join_rows
FROM student AS s
LEFT JOIN enrollment AS e ON s.student_id = e.student_id;

-- ============================================================
-- THREE-TABLE JOIN with ORDER BY: Sort by course grade descending
-- Useful to produce a leaderboard / top-performers report
-- ============================================================
SELECT
    s.first_name,
    s.last_name,
    co.course_name,
    cl.class_name,
    e.grade AS course_grade
FROM enrollment AS e
INNER JOIN student AS s  ON e.student_id = s.student_id
INNER JOIN class   AS cl ON s.class_id   = cl.class_id
INNER JOIN course  AS co ON e.course_id  = co.course_id
ORDER BY e.grade DESC;

-- ============================================================
-- JOIN with WHERE filter: Students in Senior 3A who scored above 80
-- Combines INNER JOIN with a WHERE to narrow the joined result
-- ============================================================
SELECT
    s.first_name,
    s.last_name,
    cl.class_name,
    co.course_name,
    e.grade
FROM enrollment AS e
INNER JOIN student AS s  ON e.student_id = s.student_id
INNER JOIN class   AS cl ON s.class_id   = cl.class_id
INNER JOIN course  AS co ON e.course_id  = co.course_id
WHERE cl.class_name = 'Senior 3A'
  AND e.grade > 80.00
ORDER BY e.grade DESC;

-- ============================================================
-- Day 4 Advanced Queries: Aggregates & Subqueries – school_db
-- ============================================================

USE school_db;

-- ============================================================
-- COUNT with GROUP BY: Number of students enrolled per course
-- ============================================================
SELECT
    c.course_name,
    COUNT(e.student_id) AS total_students
FROM course AS c
LEFT JOIN enrollment AS e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY total_students DESC;

-- ============================================================
-- SUM with GROUP BY: Total credits offered per class
-- Joins student → enrollment → course to sum credits per class
-- ============================================================
SELECT
    cl.class_name,
    SUM(co.credits) AS total_credits_taken
FROM class AS cl
INNER JOIN student    AS s  ON cl.class_id  = s.class_id
INNER JOIN enrollment AS e  ON s.student_id = e.student_id
INNER JOIN course     AS co ON e.course_id  = co.course_id
GROUP BY cl.class_id, cl.class_name
ORDER BY total_credits_taken DESC;

-- ============================================================
-- AVG with GROUP BY: Average grade per course
-- ============================================================
SELECT
    c.course_name,
    ROUND(AVG(e.grade), 2) AS avg_grade
FROM course AS c
INNER JOIN enrollment AS e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
ORDER BY avg_grade DESC;

-- ============================================================
-- HAVING: Only show courses where the average grade is above 80
-- HAVING filters groups AFTER aggregation (unlike WHERE which filters rows)
-- ============================================================
SELECT
    c.course_name,
    ROUND(AVG(e.grade), 2) AS avg_grade,
    COUNT(e.student_id)    AS num_students
FROM course AS c
INNER JOIN enrollment AS e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING avg_grade > 80
ORDER BY avg_grade DESC;

-- ============================================================
-- SUBQUERY in WHERE: Students whose grade is above the overall average
-- The inner query calculates the overall average grade first,
-- then the outer query uses that value to filter rows
-- ============================================================
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollment AS e
INNER JOIN student AS s ON e.student_id = s.student_id
INNER JOIN course  AS c ON e.course_id  = c.course_id
WHERE e.grade > (SELECT AVG(grade) FROM enrollment)
ORDER BY e.grade DESC;

-- ============================================================
-- SUBQUERY in FROM: Derived table of per-student average grades
-- The inner query creates a named result set (alias: avg_grades),
-- which the outer query then treats like a regular table
-- ============================================================
SELECT
    avg_grades.student_id,
    s.first_name,
    s.last_name,
    avg_grades.avg_grade
FROM (
    SELECT student_id, ROUND(AVG(grade), 2) AS avg_grade
    FROM enrollment
    GROUP BY student_id
) AS avg_grades
INNER JOIN student AS s ON avg_grades.student_id = s.student_id
ORDER BY avg_grades.avg_grade DESC;

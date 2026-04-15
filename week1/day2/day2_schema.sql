-- ============================================================
-- Day 2 Schema: School Management System
-- Domain: School (based on Day 1 ERD)
-- ============================================================

CREATE DATABASE IF NOT EXISTS school_db;
USE school_db;

-- ============================================================
-- TABLE: school
-- Represents a school institution
-- ============================================================
CREATE TABLE school (
    school_id   INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(150) NOT NULL,
    address     VARCHAR(255) NOT NULL,
    phone       VARCHAR(20)  NOT NULL UNIQUE,
    PRIMARY KEY (school_id)
);

-- ============================================================
-- TABLE: course
-- Represents a course offered by the school
-- ============================================================
CREATE TABLE course (
    course_id   INT          NOT NULL AUTO_INCREMENT,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits     INT          NOT NULL DEFAULT 3,
    school_id   INT          NOT NULL,
    PRIMARY KEY (course_id),
    FOREIGN KEY (school_id) REFERENCES school(school_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: class
-- Represents a class (grade group) within a school
-- ============================================================
CREATE TABLE class (
    class_id    INT         NOT NULL AUTO_INCREMENT,
    class_name  VARCHAR(50) NOT NULL,
    grade       VARCHAR(10) NOT NULL,
    school_id   INT         NOT NULL,
    PRIMARY KEY (class_id),
    FOREIGN KEY (school_id) REFERENCES school(school_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: student
-- Represents a student enrolled in a class
-- ============================================================
CREATE TABLE student (
    student_id  INT         NOT NULL AUTO_INCREMENT,
    first_name  VARCHAR(60) NOT NULL,
    last_name   VARCHAR(60) NOT NULL,
    dob         DATE        NOT NULL,
    class_id    INT         NOT NULL,
    PRIMARY KEY (student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id) ON DELETE RESTRICT
);

-- ============================================================
-- TABLE: enrollment (junction table for Student M:N Course)
-- Resolves the M:N relationship between Student and Course
-- ============================================================
CREATE TABLE enrollment (
    enrollment_id INT  NOT NULL AUTO_INCREMENT,
    student_id    INT  NOT NULL,
    course_id     INT  NOT NULL,
    enrolled_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    grade         DECIMAL(5,2),
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_student_course (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES course(course_id)  ON DELETE CASCADE
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Schools
INSERT INTO school (name, address, phone) VALUES
('Kigali International Academy', 'KG 7 Ave, Kigali', '+250788001001'),
('Green Hills Academy',          'KG 9 Ave, Kigali', '+250788001002'),
('Riviera High School',          'KN 3 Rd, Kigali',  '+250788001003');

-- Courses (school_id 1)
INSERT INTO course (course_name, description, credits, school_id) VALUES
('Mathematics',      'Algebra, calculus, and statistics',    4, 1),
('English Language', 'Grammar, writing, and literature',     3, 1),
('Biology',          'Cell biology, genetics, and ecology',  4, 1),
('History',          'World and African history',            3, 1),
('Computer Science', 'Programming fundamentals and logic',   4, 1),
('Physics',          'Mechanics, electricity, and optics',   4, 1),
('Chemistry',        'Organic and inorganic chemistry',      4, 1),
('Geography',        'Physical and human geography',         3, 1),
('French',           'French language and culture',          3, 1),
('Art & Design',     'Drawing, painting, and digital art',   2, 1);

-- Classes (school_id 1)
INSERT INTO class (class_name, grade, school_id) VALUES
('Senior 1A', 'S1', 1),
('Senior 1B', 'S1', 1),
('Senior 2A', 'S2', 1),
('Senior 2B', 'S2', 1),
('Senior 3A', 'S3', 1);

-- Students
INSERT INTO student (first_name, last_name, dob, class_id) VALUES
('Alice',    'Uwimana',    '2009-03-15', 1),
('Bob',      'Habimana',   '2009-07-22', 1),
('Claire',   'Mukamana',   '2009-11-01', 2),
('David',    'Nzeyimana',  '2008-05-18', 3),
('Eva',      'Ingabire',   '2008-09-30', 3),
('Frank',    'Bizimana',   '2008-02-14', 4),
('Grace',    'Mutesi',     '2007-12-05', 5),
('Henry',    'Ndayisaba',  '2007-06-20', 5),
('Isabelle', 'Uwineza',    '2009-01-09', 2),
('James',    'Tuyisenge',  '2008-08-25', 4);

-- Enrollments
INSERT INTO enrollment (student_id, course_id, enrolled_date, grade) VALUES
(1, 1, '2024-01-15', 85.50),
(1, 2, '2024-01-15', 90.00),
(1, 5, '2024-01-15', 78.00),
(2, 1, '2024-01-15', 72.00),
(2, 3, '2024-01-15', 88.50),
(3, 2, '2024-01-15', 95.00),
(3, 4, '2024-01-15', 80.00),
(4, 1, '2024-01-16', 65.00),
(4, 6, '2024-01-16', 70.00),
(5, 5, '2024-01-16', 92.00),
(5, 7, '2024-01-16', 84.00),
(6, 3, '2024-01-16', 77.00),
(7, 1, '2024-01-17', 91.00),
(7, 2, '2024-01-17', 89.00),
(8, 8, '2024-01-17', 82.00),
(9, 9, '2024-01-17', 74.00),
(10, 10, '2024-01-17', 88.00),
(2,  2, '2024-01-15', 69.00),
(6,  6, '2024-01-16', 73.00),
(8,  1, '2024-01-17', 79.00);

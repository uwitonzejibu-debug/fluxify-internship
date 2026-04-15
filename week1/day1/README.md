# Week 1 – Day 2: MySQL Fundamentals

**Name:** [Your Full Name]  
**Domain:** School Management System  
**Database:** `school_db`

## What was built

This database implements the School Management System ERD from Day 1.
It contains five tables: `school`, `course`, `class`, `student`, and `enrollment`.

The `enrollment` table acts as a junction/bridge table that resolves the
M:N relationship between `student` and `course`, storing the grade each
student receives for each course they attend.

## Files

| File | Description |
|---|---|
| `day2_schema.sql` | CREATE TABLE statements + 10+ rows of sample data per table |
| `day2_queries.sql` | CRUD queries: SELECT (WHERE/ORDER BY/LIMIT/LIKE/BETWEEN/IN/DISTINCT), UPDATE, DELETE, ALTER TABLE |

## How to run

1. Start XAMPP → Apache + MySQL
2. Open `http://localhost/phpmyadmin`
3. Run `day2_schema.sql` first (creates the database and inserts data)
4. Run `day2_queries.sql` to test CRUD operations

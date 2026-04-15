# Week 1 – Day 3: MySQL Joins & Relationships

**Database:** `school_db`

## Join types used

**INNER JOIN** returns only rows where a match exists in both tables.
Used to list students alongside the courses they are enrolled in — students
with zero enrollments do not appear.

**LEFT JOIN** returns every row from the left (first) table and matches from
the right table where available. Unmatched rows show NULL on the right side.
Used to list all students, including those with no enrollment records.

**LEFT JOIN + IS NULL** filters the LEFT JOIN result to show only the
unmatched rows — i.e. students who have never enrolled in any course.

**RIGHT JOIN** keeps every row from the right (second) table. Used to list
all courses including those no student has enrolled in. This is the mirror of
the LEFT JOIN — the "kept" side flips.

**Three-table JOIN** chains multiple INNER JOINs to cross student, class,
and course in one query, giving a full picture of who studies what in which class.

## Files

| File | Description |
|---|---|
| `day3_joins.sql` | All join queries with comments explaining each type |

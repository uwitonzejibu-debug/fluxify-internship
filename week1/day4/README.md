# Week 1 – Day 4: Advanced MySQL

**Database:** `school_db`

## Transactions

A transaction groups multiple SQL statements into a single atomic unit.
Either all statements succeed (COMMIT) or none of them are saved (ROLLBACK).

**Why this matters:** Without transactions, a failure halfway through a
two-step operation (e.g. insert student + insert enrollment) could leave
the database in an inconsistent state — a student exists with no enrollment
record, or an enrollment references a student that was never saved.

## Indexes

An index is a data structure that lets MySQL find rows without scanning the
entire table. A well-placed index on a heavily filtered or joined column
(like `student_id` in `enrollment`) can reduce query cost from O(n) full
table scan to O(log n) index lookup.

**When to add an index:** When a column appears frequently in WHERE clauses,
JOIN ON conditions, or ORDER BY clauses and the table has many rows.

**Trade-off:** Indexes speed up reads but slightly slow down writes (INSERT,
UPDATE, DELETE must also update the index). Don't index every column.

## Views

A view is a stored SELECT query that behaves like a virtual table.
The `student_report_card` view joins four tables once and can be queried
repeatedly with simple `SELECT * FROM student_report_card` calls.

## Files

| File | Description |
|---|---|
| `day4_advanced.sql` | Aggregate queries (COUNT, SUM, AVG, HAVING) and subqueries |
| `day4_transactions_indexes_views.sql` | Transactions with COMMIT and ROLLBACK, indexes, EXPLAIN, and a view |

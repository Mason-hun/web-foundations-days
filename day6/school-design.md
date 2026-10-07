# School Database Design

## Students

The `students` table stores information about students. Each student has a unique `id`, a required name, and a unique email address.

## Courses

The `courses` table stores the courses offered by the school. Each course has a unique `id` and a required name.

## Enrolments

The `enrolments` table represents the relationship between students and courses. It stores the student's ID, the course's ID, and the grade earned for that enrolment.

## Relationships

Students and courses have a many-to-many relationship because one student can enrol in many courses and one course can have many students.

The `enrolments` table is therefore a join table. It contains foreign keys to both `students` and `courses`. The combination of `student_id` and `course_id` is the composite primary key, which prevents the same student from enrolling in the same course twice.

The relationship between students and enrolments is one-to-many, and the relationship between courses and enrolments is also one-to-many.

## Index

I would add an index on `enrolments(course_id)` because the application will frequently need to find all students enrolled in a particular course. An index would make these lookups faster as the number of enrolments grows.

```sql
CREATE INDEX idx_enrolments_course_id
ON enrolments(course_id);

## SQL or NoSQL?

I would choose a relational SQL database for this system because the data is structured and has clear relationships between students, courses, and enrolments. SQL databases provide foreign keys, constraints, and joins that help maintain data integrity. A document database could work, but SQL is a better fit because the system depends heavily on relationships and accurate enrolment records.
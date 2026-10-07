-- Day 6 Assignment: School Database

-- =========================
-- 1. CREATE TABLES
-- =========================

CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE
);

CREATE TABLE courses (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE enrolments (
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    grade TEXT,

    PRIMARY KEY (student_id, course_id),

    FOREIGN KEY (student_id)
        REFERENCES students(id)
        ON DELETE CASCADE,

    FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE
);

-- =========================
-- 2. INSERT SAMPLE DATA
-- =========================

INSERT INTO students (name, email)
VALUES
    ('Amina Otieno', 'amina@example.com'),
    ('Brian Kamau', 'brian@example.com'),
    ('Carol Wanjiku', 'carol@example.com'),
    ('David Mwangi', 'david@example.com');

INSERT INTO courses (name)
VALUES
    ('Database Systems'),
    ('Web Development'),
    ('Data Structures');

INSERT INTO enrolments (student_id, course_id, grade)
VALUES
    (1, 1, 'A'),
    (1, 2, 'B'),
    (2, 1, 'B'),
    (2, 3, 'A'),
    (3, 2, 'C');

-- =========================
-- 3. REQUIRED QUERIES
-- =========================

-- All courses for one student by name
SELECT courses.name
FROM courses
JOIN enrolments
    ON enrolments.course_id = courses.id
JOIN students
    ON students.id = enrolments.student_id
WHERE students.name = 'Amina Otieno';

-- All students on one course
SELECT students.name
FROM students
JOIN enrolments
    ON enrolments.student_id = students.id
JOIN courses
    ON courses.id = enrolments.course_id
WHERE courses.name = 'Database Systems';

-- Number of students per course
SELECT
    courses.name,
    COUNT(enrolments.student_id) AS student_count
FROM courses
LEFT JOIN enrolments
    ON enrolments.course_id = courses.id
GROUP BY courses.id;

-- Students who have no enrolments
SELECT students.name
FROM students
LEFT JOIN enrolments
    ON enrolments.student_id = students.id
WHERE enrolments.student_id IS NULL;

-- Update one enrolment's grade
UPDATE enrolments
SET grade = 'A+'
WHERE student_id = 2
  AND course_id = 3;
CREATE DATABASE IF NOT EXISTS CollegeDB;
USE CollegeDB;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Student (
    roll_no INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT CHECK (age >= 17 AND age <= 30),
    email VARCHAR(50) UNIQUE,
    gender VARCHAR(10) DEFAULT 'Not Specified',
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50) NOT NULL,
    credits INT CHECK (credits BETWEEN 1 AND 6),
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Enrollment (
    roll_no INT,
    course_id INT,
    marks INT CHECK (marks BETWEEN 0 AND 100),
    PRIMARY KEY (roll_no, course_id),
    FOREIGN KEY (roll_no) REFERENCES Student(roll_no),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);

INSERT INTO Department VALUES
(1, 'Computer Science'),
(2, 'Electronics'),
(3, 'Mechanical');

INSERT INTO Student
(roll_no, name, age, email, gender, dept_id)
VALUES
(101, 'Arun', 20, 'arun@email.com', 'Male', 1),
(102, 'Priya', 21, 'priya@email.com', 'Female', 2),
(103, 'Kumar', 22, 'kumar@email.com', 'Male', 1),
(104, 'Sita', 19, 'sita@email.com', 'Female', 3),
(105, 'Meena', 23, 'meena@email.com', 'Female', 2);

INSERT INTO Course
(course_id, course_name, credits, dept_id)
VALUES
(1, 'Data Structures', 4, 1),
(2, 'Digital Circuits', 3, 2),
(3, 'Thermodynamics', 4, 3),
(4, 'DBMS', 4, 1);

INSERT INTO Enrollment VALUES
(101, 1, 85),
(101, 4, 78),
(102, 2, 60),
(102, 4, 55),
(103, 1, 90),
(103, 4, 88),
(104, 3, 70),
(105, 2, 45);

-- 1. IN
SELECT name, dept_id
FROM Student
WHERE dept_id IN (
    SELECT dept_id
    FROM Department
    WHERE dept_name IN ('Computer Science', 'Mechanical')
);

-- Students not enrolled in DBMS
SELECT name
FROM Student
WHERE roll_no NOT IN (
    SELECT roll_no
    FROM Enrollment
    WHERE course_id = 4
);

-- 2. ANY
SELECT DISTINCT s.name, e.marks
FROM Student s
JOIN Enrollment e ON s.roll_no = e.roll_no
WHERE e.marks > ANY (
    SELECT marks
    FROM Enrollment
    WHERE course_id = 2
);

-- Departments offering courses with credits matching
-- any course in department 1
SELECT DISTINCT dept_id
FROM Course
WHERE credits = ANY (
    SELECT credits
    FROM Course
    WHERE dept_id = 1
);

-- 3. ALL
SELECT DISTINCT s.name, e.marks
FROM Student s
JOIN Enrollment e ON s.roll_no = e.roll_no
WHERE e.marks > ALL (
    SELECT marks
    FROM Enrollment
    WHERE course_id = 2
);

-- Courses with credits greater than or equal to
-- all courses in the Electronics department
SELECT course_name, credits
FROM Course
WHERE credits >= ALL (
    SELECT credits
    FROM Course
    WHERE dept_id = (
        SELECT dept_id
        FROM Department
        WHERE dept_name = 'Electronics'
    )
);

-- 4. EXISTS
SELECT dept_name
FROM Department d
WHERE EXISTS (
    SELECT 1
    FROM Student s
    WHERE s.dept_id = d.dept_id
);

-- NOT EXISTS: Students not enrolled in any course
SELECT name
FROM Student s
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollment e
    WHERE e.roll_no = s.roll_no
);

-- Departments offering no courses
SELECT dept_name
FROM Department d
WHERE NOT EXISTS (
    SELECT 1
    FROM Course c
    WHERE c.dept_id = d.dept_id
);

-- 5. UNION
SELECT roll_no
FROM Enrollment
WHERE course_id = 4 AND marks > 80
UNION
SELECT roll_no
FROM Enrollment
WHERE course_id = 1 AND marks > 80;

-- UNION ALL
SELECT roll_no
FROM Enrollment
WHERE course_id = 4 AND marks > 80
UNION ALL
SELECT roll_no
FROM Enrollment
WHERE course_id = 1 AND marks > 80;

-- 6. INTERSECT
SELECT roll_no
FROM Enrollment
WHERE course_id = 1
INTERSECT
SELECT roll_no
FROM Enrollment
WHERE course_id = 4;

-- MySQL alternative for INTERSECT
SELECT roll_no
FROM Enrollment
WHERE course_id = 1
AND roll_no IN (
    SELECT roll_no
    FROM Enrollment
    WHERE course_id = 4
);

-- 7. EXCEPT: Students in course 1 but not course 4
SELECT roll_no
FROM Enrollment
WHERE course_id = 1
EXCEPT
SELECT roll_no
FROM Enrollment
WHERE course_id = 4;

-- MySQL alternative for EXCEPT
SELECT roll_no
FROM Enrollment
WHERE course_id = 1
AND roll_no NOT IN (
    SELECT roll_no
    FROM Enrollment
    WHERE course_id = 4
);

-- 8. Constraint violation demonstrations
-- Execute each statement separately; each should fail.

-- NOT NULL violation
INSERT INTO Student
(roll_no, name, age, email, dept_id)
VALUES (106, NULL, 22, 'test1@email.com', 1);

-- UNIQUE violation
INSERT INTO Student
(roll_no, name, age, email, dept_id)
VALUES (107, 'Ravi', 23, 'arun@email.com', 1);

-- CHECK violation
INSERT INTO Enrollment
(roll_no, course_id, marks)
VALUES (101, 2, 150);

-- FOREIGN KEY violation
INSERT INTO Enrollment
(roll_no, course_id, marks)
VALUES (999, 1, 70);

Result:Result
Thus, SQL queries using IN, ANY, ALL, EXISTS, NOT EXISTS, UNION, UNION ALL, INTERSECT, and EXCEPT were demonstrated, and integrity constraints were verified using related Department, Student, Course, and Enrollment tables.

1. Create Database and Tables
CREATE DATABASE CollegeDB;
USE CollegeDB;

CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50)
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50) NOT NULL,
    dept_id INT,
    cgpa DECIMAL(3,2),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Course (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(60) NOT NULL,
    dept_id INT,
    credits INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

CREATE TABLE Enrollment (
    enroll_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    semester INT,
    marks INT,
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (course_id) REFERENCES Course(course_id)
);
2. Insert Sample Records
INSERT INTO Department VALUES
(10, 'CSE', 'Block A'),
(20, 'ECE', 'Block B'),
(30, 'IT', 'Block C'),
(40, 'MECH', 'Block D');

INSERT INTO Student VALUES
(101, 'Anu', 10, 8.70),
(102, 'Bala', 10, 7.90),
(103, 'Charan', 20, 8.20),
(104, 'Divya', 30, 9.10),
(105, 'Esha', NULL, 7.50);

INSERT INTO Course VALUES
(501, 'DBMS', 10, 4),
(502, 'Data Structures', 10, 4),
(503, 'Digital Systems', 20, 3),
(504, 'Web Technology', 30, 3);

INSERT INTO Enrollment VALUES
(1, 101, 501, 5, 88),
(2, 101, 502, 5, 91),
(3, 102, 501, 5, 76),
(4, 103, 503, 5, 84),
(5, 104, 504, 5, 95);

COMMIT;
3. INNER JOIN — Students with Department Names
SELECT s.student_id, s.student_name, d.dept_name
FROM Student s
INNER JOIN Department d
    ON s.dept_id = d.dept_id;
4. LEFT JOIN — All Students Including Those Without Departments
SELECT s.student_id, s.student_name, d.dept_name
FROM Student s
LEFT JOIN Department d
    ON s.dept_id = d.dept_id;
5. LEFT JOIN — All Departments and Their Students
SELECT d.dept_id, d.dept_name, s.student_name
FROM Department d
LEFT JOIN Student s
    ON d.dept_id = s.dept_id
ORDER BY d.dept_id;
6. RIGHT JOIN — All Departments and Matching Students
SELECT d.dept_id, d.dept_name, s.student_name
FROM Student s
RIGHT JOIN Department d
    ON s.dept_id = d.dept_id
ORDER BY d.dept_id;
7. JOIN — Students and Their Enrolled Courses
SELECT s.student_name, c.course_name, e.marks
FROM Student s
INNER JOIN Enrollment e
    ON s.student_id = e.student_id
INNER JOIN Course c
    ON e.course_id = c.course_id;
8. Single-Row Sub-Query — Students Above Average CGPA
SELECT student_id, student_name, cgpa
FROM Student
WHERE cgpa > (
    SELECT AVG(cgpa)
    FROM Student
);
9. Multi-Row Sub-Query — Students in the CSE Department
SELECT student_id, student_name
FROM Student
WHERE dept_id IN (
    SELECT dept_id
    FROM Department
    WHERE dept_name = 'CSE'
);
10. Sub-Query — Courses with More Than Three Credits
SELECT course_id, course_name, credits
FROM Course
WHERE credits > 3;
11. Correlated Sub-Query — Students Scoring Above Their Course Average
SELECT s.student_name, c.course_name, e.marks
FROM Enrollment e
JOIN Student s
    ON e.student_id = s.student_id
JOIN Course c
    ON e.course_id = c.course_id
WHERE e.marks > (
    SELECT AVG(e2.marks)
    FROM Enrollment e2
    WHERE e2.course_id = e.course_id
);
12. EXISTS — Students Who Have Enrolled in Courses
SELECT s.student_id, s.student_name
FROM Student s
WHERE EXISTS (
    SELECT 1
    FROM Enrollment e
    WHERE e.student_id = s.student_id
);
13. NOT EXISTS — Students Not Enrolled in Any Course
SELECT s.student_id, s.student_name
FROM Student s
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollment e
    WHERE e.student_id = s.student_id
);

Result
Thus, related tables were created using primary and foreign keys, and different JOIN operations and sub-queries were executed successfully to retrieve related information from the database.

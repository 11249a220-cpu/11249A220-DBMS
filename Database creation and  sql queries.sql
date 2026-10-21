CREATE DATABASE CollegeDB;

USE CollegeDB;

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(30),
    Department VARCHAR(20),
    Age INT,
    CGPA DECIMAL(3,2)
);

INSERT INTO Student VALUES
(101, 'Anu', 'CSE', 20, 8.90),
(102, 'Bala', 'ECE', 21, 8.50),
(103, 'Charles', 'IT', 20, 9.10),
(104, 'Divya', 'CSE', 22, 8.70),
(105, 'Esha', 'AIDS', 21, 9.20);

SELECT * FROM Student;

SELECT * FROM Student
WHERE Department = 'CSE';

SELECT * FROM Student
WHERE CGPA > 8.8;

SELECT * FROM Student
ORDER BY CGPA DESC;

SELECT COUNT(*) AS TotalStudents
FROM Student;

SELECT AVG(CGPA) AS AverageCGPA
FROM Student;

Result:Thus, the database CollegeDB was created successfully, the Student table was created and populated with records, and SQL queries were executed successfully to retrieve, filter, sort, count, and calculate the average CGPA of students.

CREATE DATABASE CollegeDB;

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

INSERT INTO Department VALUES (1, 'Computer Science');
INSERT INTO Department VALUES (2, 'Electronics');

INSERT INTO Student (roll_no, name, age, email, gender, dept_id)
VALUES (101, 'Arun', 20, 'arun@email.com', 'Male', 1);

INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (102, 'Priya', 21, 'priya@email.com', 2);

-- NOT NULL constraint violation
INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (103, NULL, 22, 'test1@email.com', 1);

-- UNIQUE constraint violation
INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (104, 'Kumar', 23, 'arun@email.com', 1);

-- PRIMARY KEY constraint violation
INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (101, 'Ravi', 22, 'ravi@email.com', 1);

-- CHECK constraint violation
INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (105, 'Sita', 35, 'sita@email.com', 1);

-- FOREIGN KEY constraint violation
INSERT INTO Student (roll_no, name, age, email, dept_id)
VALUES (106, 'Meena', 20, 'meena@email.com', 9);

-- Adding a constraint
ALTER TABLE Student
ADD CONSTRAINT chk_name CHECK (LENGTH(name) >= 3);

-- Dropping a constraint (MySQL 8.0.16+)
ALTER TABLE Student
DROP CHECK chk_name;

-- Viewing table structure
DESC Student;

-- Displaying records
SELECT * FROM Student;

Result:
Thus, SQL constraints such as PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK, and DEFAULT were demonstrated successfully. Adding and dropping constraints using ALTER TABLE was also performed.

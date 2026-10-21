-- 1. Create Student Table
CREATE TABLE STUDENT (
    ROLLNO NUMBER(5) PRIMARY KEY,
    NAME VARCHAR2(30),
    DEPARTMENT VARCHAR2(20),
    MARKS NUMBER(3)
);

-- 2. Insert Sample Records
INSERT INTO STUDENT VALUES (101, 'ARUN', 'CSE', 85);
INSERT INTO STUDENT VALUES (102, 'PRIYA', 'ECE', 90);
INSERT INTO STUDENT VALUES (103, 'KUMAR', 'CSE', 78);
INSERT INTO STUDENT VALUES (104, 'DIVYA', 'IT', 88);
INSERT INTO STUDENT VALUES (105, 'RAHUL', 'CSE', 92);

COMMIT;

-- 3. Create a View
CREATE VIEW CSE_STUDENTS AS
SELECT ROLLNO, NAME, MARKS
FROM STUDENT
WHERE DEPARTMENT = 'CSE';

-- Display the View
SELECT * FROM CSE_STUDENTS;

-- Drop the View
DROP VIEW CSE_STUDENTS;

-- 4. Create a Sequence
CREATE SEQUENCE STUDENT_SEQ
START WITH 106
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- Generate Sequence Values
SELECT STUDENT_SEQ.NEXTVAL FROM DUAL;
SELECT STUDENT_SEQ.NEXTVAL FROM DUAL;

-- Insert a Record Using the Sequence
INSERT INTO STUDENT
VALUES (STUDENT_SEQ.NEXTVAL, 'SNEHA', 'CSE', 89);

COMMIT;

-- Display Student Records
SELECT * FROM STUDENT;

-- Drop the Sequence
DROP SEQUENCE STUDENT_SEQ;

-- 5. Create an Index
CREATE INDEX IDX_STUDENT_NAME
ON STUDENT(NAME);

-- Retrieve Records Using the Indexed Column
SELECT * FROM STUDENT
WHERE NAME = 'ARUN';

-- Drop the Index
DROP INDEX IDX_STUDENT_NAME;

-- 6. Demonstrate SAVEPOINT and ROLLBACK

-- Insert the First Record
INSERT INTO STUDENT VALUES (106, 'MOHAN', 'IT', 80);

SAVEPOINT SP1;

-- Insert the Second Record
INSERT INTO STUDENT VALUES (107, 'LATHA', 'ECE', 87);

-- Display Records
SELECT * FROM STUDENT;

-- Roll Back to the Savepoint
ROLLBACK TO SP1;

-- Commit the Remaining Changes
COMMIT;

-- Display Final Records
SELECT * FROM STUDENT;

Result
Thus, SQL commands for creating and using Views, Sequences, Indexes, and Savepoints were executed successfully. The use of ROLLBACK TO SAVEPOINT and COMMIT was demonstrated to manage database transactions.

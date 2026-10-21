CREATE TABLE Employee(
    EmpID INT PRIMARY KEY,
    Name VARCHAR(30),
    Department VARCHAR(20),
    Salary DECIMAL(10,2)
);

INSERT INTO Employee VALUES
(101,'Arun','HR',35000),
(102,'Priya','IT',45000),
(103,'Kavin','Finance',50000),
(104,'Divya','IT',55000);

GRANT SELECT ON Employee TO user1;

GRANT SELECT, INSERT ON Employee TO user1;

REVOKE INSERT ON Employee FROM user1;

REVOKE ALL ON Employee FROM user1;

SET AUTOCOMMIT=0;

UPDATE Employee
SET Salary=48000
WHERE EmpID=102;

SAVEPOINT SP1;

UPDATE Employee
SET Salary=60000
WHERE EmpID=104;

SELECT * FROM Employee;

ROLLBACK TO SP1;

COMMIT;

DELETE FROM Employee
WHERE EmpID=101;

ROLLBACK;

SELECT * FROM Employee;

Result:Thus, SQL commands for granting and revoking permissions, managing transactions using COMMIT, ROLLBACK, and SAVEPOINT, and performing operations on the Employee and Book tables were demonstrated.

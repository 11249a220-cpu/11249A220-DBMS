CREATE TABLE dept (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(20)
);

CREATE TABLE emp (
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(20) NOT NULL,
    job VARCHAR2(15),
    sal NUMBER(8,2),
    deptno NUMBER(2) REFERENCES dept(deptno)
);

CREATE TABLE emp_audit (
    audit_id NUMBER GENERATED ALWAYS AS IDENTITY,
    empno NUMBER,
    action VARCHAR2(10),
    old_sal NUMBER,
    new_sal NUMBER,
    changed_on DATE DEFAULT SYSDATE
);

INSERT INTO dept VALUES (10, 'ACCOUNTING');
INSERT INTO dept VALUES (20, 'RESEARCH');
INSERT INTO dept VALUES (30, 'SALES');

INSERT INTO emp VALUES (101, 'SMITH', 'CLERK', 8000, 20);
INSERT INTO emp VALUES (102, 'ALLEN', 'SALESMAN', 15000, 30);
INSERT INTO emp VALUES (103, 'WARD', 'SALESMAN', 12500, 30);
INSERT INTO emp VALUES (104, 'JONES', 'MANAGER', 29750, 20);
INSERT INTO emp VALUES (105, 'KING', 'PRESIDENT', 50000, 10);

COMMIT;
1. Conditional Blocks – IF-ELSIF

sql
DECLARE
    v_sal emp.sal%TYPE;
    v_name emp.ename%TYPE;
BEGIN
    SELECT ename, sal
    INTO v_name, v_sal
    FROM emp
    WHERE empno = 102;

    IF v_sal >= 30000 THEN
        DBMS_OUTPUT.PUT_LINE(v_name || ': Grade A');
    ELSIF v_sal >= 10000 THEN
        DBMS_OUTPUT.PUT_LINE(v_name || ': Grade B');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_name || ': Grade C');
    END IF;
END;
/
2. CASE Statement – Bonus Calculation

sql
DECLARE
    v_job emp.job%TYPE;
    v_sal emp.sal%TYPE;
    v_bonus NUMBER;
BEGIN
    SELECT job, sal
    INTO v_job, v_sal
    FROM emp
    WHERE empno = 103;

    v_bonus := CASE v_job
        WHEN 'SALESMAN' THEN v_sal * 0.10
        WHEN 'MANAGER' THEN v_sal * 0.15
        ELSE v_sal * 0.05
    END;

    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);
END;
/
3. Exception Handling – Predefined Exception

sql
DECLARE
    v_name emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_name
    FROM emp
    WHERE empno = 999;

    DBMS_OUTPUT.PUT_LINE(v_name);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No employee with that number.');

    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('More than one row returned.');

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error ' || SQLCODE || ': ' || SQLERRM);
END;
/
4. User-Defined Exception

sql
DECLARE
    e_low_salary EXCEPTION;
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal
    INTO v_sal
    FROM emp
    WHERE empno = 101;

    IF v_sal < 10000 THEN
        RAISE e_low_salary;
    END IF;

EXCEPTION
    WHEN e_low_salary THEN
        DBMS_OUTPUT.PUT_LINE('Salary below minimum: ' || v_sal);
END;
/
5. RAISE_APPLICATION_ERROR – Duplicate Key

sql
BEGIN
    INSERT INTO emp
    VALUES (101, 'DUP', 'CLERK', 5000, 10);

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Employee number already exists'
        );
END;
/
6. Stored Procedure – IN Parameter

sql
CREATE OR REPLACE PROCEDURE raise_salary (
    p_empno IN emp.empno%TYPE,
    p_percent IN NUMBER
) IS
BEGIN
    UPDATE emp
    SET sal = sal + sal * p_percent / 100
    WHERE empno = p_empno;

    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee not found');
    END IF;

    COMMIT;
END raise_salary;
/

EXEC raise_salary(101, 10);
7. Stored Procedure – OUT Parameters

sql
CREATE OR REPLACE PROCEDURE get_emp_info (
    p_empno IN emp.empno%TYPE,
    p_name OUT emp.ename%TYPE,
    p_sal OUT emp.sal%TYPE
) IS
BEGIN
    SELECT ename, sal
    INTO p_name, p_sal
    FROM emp
    WHERE empno = p_empno;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_name := NULL;
        p_sal := NULL;
END;
/

DECLARE
    v_name emp.ename%TYPE;
    v_sal emp.sal%TYPE;
BEGIN
    get_emp_info(104, v_name, v_sal);
    DBMS_OUTPUT.PUT_LINE(v_name || ' earns ' || v_sal);
END;
/
8. Stored Procedure – IN OUT Parameter

sql
CREATE OR REPLACE PROCEDURE square_it (
    p_num IN OUT NUMBER
) IS
BEGIN
    p_num := p_num * p_num;
END;
/

DECLARE
    n NUMBER := 7;
BEGIN
    square_it(n);
    DBMS_OUTPUT.PUT_LINE('Result: ' || n);
END;
/
9. Stored Function

sql
CREATE OR REPLACE FUNCTION annual_sal (
    p_empno IN emp.empno%TYPE
)
RETURN NUMBER IS
    v_sal emp.sal%TYPE;
BEGIN
    SELECT sal
    INTO v_sal
    FROM emp
    WHERE empno = p_empno;

    RETURN v_sal * 12;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/

SELECT ename, annual_sal(empno) AS yearly
FROM emp;
10. Trigger – Salary Validation

sql
CREATE OR REPLACE TRIGGER trg_check_sal
BEFORE INSERT OR UPDATE OF sal ON emp
FOR EACH ROW
BEGIN
    IF :NEW.sal < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'Salary cannot be negative');
    END IF;

    :NEW.ename := UPPER(:NEW.ename);
END;
/
11. Trigger – Employee Audit

sql
CREATE OR REPLACE TRIGGER trg_emp_audit
AFTER INSERT OR UPDATE OR DELETE ON emp
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO emp_audit (empno, action, new_sal)
        VALUES (:NEW.empno, 'INSERT', :NEW.sal);

    ELSIF UPDATING THEN
        INSERT INTO emp_audit (empno, action, old_sal, new_sal)
        VALUES (:OLD.empno, 'UPDATE', :OLD.sal, :NEW.sal);

    ELSIF DELETING THEN
        INSERT INTO emp_audit (empno, action, old_sal)
        VALUES (:OLD.empno, 'DELETE', :OLD.sal);
    END IF;
END;
/
12. Statement-Level Trigger – Restrict Weekend Changes

sql
CREATE OR REPLACE TRIGGER trg_no_weekend
BEFORE INSERT OR UPDATE OR DELETE ON emp
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH')
       IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(
            -20011,
            'Changes not allowed on weekends'
        );
    END IF;
END;
/
13. Implicit Cursor

sql
BEGIN
    UPDATE emp
    SET sal = sal + 500
    WHERE deptno = 30;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row(s) updated');

    ROLLBACK;
END;
/
14. Explicit Cursor

sql
DECLARE
    CURSOR c_emp IS
        SELECT ename, sal
        FROM emp
        ORDER BY sal DESC;

    v_name emp.ename%TYPE;
    v_sal emp.sal%TYPE;
BEGIN
    OPEN c_emp;

    LOOP
        FETCH c_emp INTO v_name, v_sal;

        EXIT WHEN c_emp%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(RPAD(v_name, 10) || v_sal);
    END LOOP;

    CLOSE c_emp;
END;
/
15. Managing Procedures and Triggers

sql
SHOW ERRORS;

SELECT object_name
FROM user_procedures;

SELECT trigger_name, status
FROM user_triggers;

ALTER TRIGGER trg_no_weekend DISABLE;

DROP TRIGGER trg_emp_audit;

DROP PROCEDURE raise_salary;

Result
Thus, PL/SQL conditional statements, predefined and user-defined exception handling, stored procedures, functions, triggers, and implicit and explicit cursors were implemented and demonstrated successfully in Oracle Database.

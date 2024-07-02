-----------------------------------------------------------------------------------------
--   11. View 
------------------------------------------------------------------------------
-- View : �ϳ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
--   ��� �����͵�ųʸ� ���̺� �信 ���� ���Ǹ� ����
--   ���� :   ���� 
--   ���� :   Performance(����)�� �� ����
--   �ý��� īŻ�α׿� ����Ǿ� �ִٰ� �����̺��� ��ȸ�ϰ� 
--   �� ���Ŀ� VIEW�� �Ѿ�ϱ� 2�� ��ȸ
-->  �翬�� �׷��� �ʾ�����


-- view ����
CREATE OR REPLACE VIEW VIEW_PROFESSOR AS
SELECT profno, name, userid, position, hiredate, deptno
FROM   professor 
;

-- ��ȸ�ϴ� ���� Professor�� �޾Ƽ� ��ü������ ����
SELECT * FROM VIEW_PROFESSOR
;

-- �������ǿ� �ɸ��� �ʴ´ٸ� �並 ���� �Է��� �����ϴ�
-- ��� ���������� �� ����� �Ѵ� �ֳĸ� ���� �Է��� ���� view�� �Է��ϴ� ���� �ƴ�
-- �����̺� �Է��ϴ� ���̱� �����̴�
INSERT INTO view_professor VALUES(2000, 'VIEW','USERID','POSITION',SYSDATE, 101);

-- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")
-- view�� �ƴ϶� ���� professor�� �ִ´ٴ� ��
-- name �������ǿ� not null�� �ִµ� name�� �Է����� �ʾƼ� ������ ����
INSERT INTO view_professor (profno, userid, position, hiredate, deptno)
                    VALUES (2001,'userid2','position2',sysdate,101);

-- ����work01 --> VIEW �̸� v_emp_sample  : emp(empno , ename , job, mgr,deptno)                  
CREATE OR REPLACE VIEW v_emp_sample AS
SELECT empno, ename, job, mgr, deptno
FROM   emp
;

-- ���� ���� ���� view�� ���� �Է� Ȯ���ϱ�
INSERT INTO v_emp_sample (empno, ename, job, mgr, deptno)
                    VALUES (2001,'userid2','position2',7839,10);
                 
-- ���� view / ����
-- ���� work 02
CREATE OR REPLACE VIEW v_emp_complex 
AS
SELECT *
FROM emp NATURAL JOIN dept
;

INSERT INTO v_emp_complex (empno, ename, deptno)
                    VALUES(1500,'ȫ�浿',20);
--  "cannot modify more than one base table through a join view"
INSERT INTO v_emp_complex (empno, ename, deptno, dname, loc)
                    VALUES(1500,'ȫ�浿',77, '������','������');
                    
CREATE OR REPLACE VIEW v_emp_complex3
AS
SELECT e.empno, e.ename, e.job, e.deptno, d.dname,d.loc
FROM emp E, dept D
WHERE E.DEPTNO = D.DEPTNO
;
-- join using oracle join anci join

--  Natural join �� ���� ���� ������ �� ������ �Ϲ� join�� insert ok
INSERT INTO v_emp_complex3 (empno, ename, deptno)
                    VALUES(1501,'ȫ�浿1',20);
-- insert ok
INSERT INTO v_emp_complex3 (empno, ename)
                    VALUES(1502,'ȫ�浿2');
--  "cannot modify more than one base table through a join view"
--  oracle join�� �κ������� ����Ѵ�
INSERT INTO v_emp_complex3 (empno, ename, deptno, dname, loc)
                    VALUES(1503,'ȫ�浿3',77, '������','������');

------------     View  HomeWork     ----------------------------------------------------

---��1)  �л� ���̺��� 101�� �а� �л����� �й�, �̸�, �а� ��ȣ�� ���ǵǴ� �ܼ� �並 ����
---     �� �� :  v_stud_dept101
CREATE OR REPLACE VIEW v_stud_dept101
AS SELECT STUDNO, NAME, DEPTNO
FROM STUDENT;
--��2) �л� ���̺�� �μ� ���̺��� �����Ͽ� 102�� �а� �л����� �й�, �̸�, �г�, �а� �̸����� ���ǵǴ� ���� �並 ����
--      �� �� :   v_stud_dept102
CREATE OR REPLACE VIEW v_stud_dept102 
AS
SELECT STUDNO, NAME, GRADE, DNAME
FROM STUDENT NATURAL JOIN DEPT
;
--��3)  ���� ���̺��� �а��� ��� �޿���     �Ѱ�� ���ǵǴ� �並 ����
--  �� �� :  v_prof_avg_sal       Column �� :   avg_sal      sum_sal
CREATE OR REPLACE VIEW v_prof_avg_sal
AS
SELECT AVG(sal) avg_sal, sum(sal) sum_sal
FROM professor;
-------------------------------------
---- ������ ���ǹ�
-------------------------------------
-- 1. ������ ������ ���̽� ���� ������� 2���� ���̺� ����
-- 2. ������ ������ ���̽����� �����Ͱ��� �θ� ���踦 ǥ���� �� �ִ� Į���� �����Ͽ� 
--    �������� ���踦 ǥ��
-- 3. �ϳ��� ���̺��� �������� ������ ǥ���ϴ� ���踦 ��ȯ����(recursive relationship)
-- 4. �������� �����͸� ������ Į�����κ��� �����͸� �˻��Ͽ� ���������� ��� ��� ����

-- ����
-- SELECT ��ɹ����� START WITH�� CONNECT BY ���� �̿�
-- ������ ���ǹ������� �������� ��� ���İ� ���� ��ġ ����
-- ��� ������  top-down �Ǵ� bottom-up
-- ����) CONNECT BY PRIOR �� START WITH���� ANSI SQL ǥ���� �ƴ�

-- ��1) ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �ܴ�,�к�
-- �а������� top-down ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 10�� �μ�
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college
;

-- ��2)������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �а�,�к�
-- �ܴ� ������ bottom-up ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 102�� �μ��̴�
-- bottom - up : �Ʒ����� ���� �ö󰡴� ����
SELECT     deptno,dname,college
FROM       department
START WITH DEPTNO = 102
CONNECT BY PRIOR college = deptno
;

-- --- ��3) ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �μ� �̸��� �˻��Ͽ� �ܴ�, �к�, �а�����
---         top-down �������� ����Ͽ���. ��, ���� �����ʹ� ���������С��̰�,
---        �� LEVEL(����)���� �������� 2ĭ �̵��Ͽ� ���
SELECT  LPAD(' ',(LEVEL-1)*2)||dname ������ 
FROM   department
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college
;

------------------------------------------------------
---      TableSpace  
---  ����  :�����ͺ��̽� ������Ʈ �� ���� �����͸� �����ϴ� ����
--           �̰��� �����ͺ��̽��� �������� �κ��̸�, ���׸�Ʈ�� �����Ǵ� ��� DBMS�� ���� 
--           �����(���׸�Ʈ)�� �Ҵ�
------------------------------------------------------

-- 1. TABLESPACE ����
CREATE Tablespace user1 Datafile 'C:\BACKUP\tableSpace\user1.ora' SIZE 100M;
CREATE Tablespace user2 Datafile 'C:\BACKUP\tableSpace\user2.ora' SIZE 100M;
CREATE Tablespace user3 Datafile 'C:\BACKUP\tableSpace\user3.ora' SIZE 100M;
CREATE Tablespace user4 Datafile 'C:\BACKUP\tableSpace\user4.ora' SIZE 100M;

-- 2. ���̺��� ���̺� �����̽� ����
-- 1) ���̺��� NDEX�� Table��  ���̺� �����̽� ��ȸ
SELECT INDEX_NAME, TABLE_NAME, TABLESPACE_NAME
FROM USER_INDEXES;

ALTER INDEX PK_RELIGIONNO3 REBUILD TABLESPACE USER1;

-- ��¥ table���� ��ȸ�Ǵ� ��ɾ�
SELECT TABLED_NAME, TABLESPACE_NAME
FROM   USER_Tables;

ALTER TABLE JOB3 MOVE TABLESPACE user2;

-- 3. ���̺� �����̽� size ����
ALTER DATAbase Datafile 'C:\BACKUP\tableSpace\user4.ora' Resize 200M;

-- Oracle ��ü Backup  (scott)
EXPDP scott/tiger Directory = mdBackup2 DUMPFILE = scott.dmp;
-- ���⼭ ���� x cmd�� �Ѿ�� �����ؾ� �Ѵ�

-- ORCALE ��ü RESTORE (SCOTT)
IMPDP scott/tiger Directory = mdBackup2 DUMPFILE = scott.dmp;

-- Oracle �κ� Backup��  �κ� Restore
exp scott/tiger file = ADDR_SECOND.DMP TABLES =ADDR_SECOND
exp scott/tiger file = address.dmp     TABLES =ADDRESS

imp scott/tiger file = ADDR_SECOND.DMP TABLES =ADDR_SECOND
imp scott/tiger file = address.dmp     TABLES =ADDRESS


----------------------------------------------------------------------------------------
-------                     Trigger 
--  1. ���� : � ����� �߻����� �� ���������� ����ǵ��� �����ͺ� �̽��� ����� ���ν���
--              Ʈ���Ű� ����Ǿ�� �� �̺�Ʈ �߻��� �ڵ����� ����Ǵ� ���ν��� 
--              Ʈ���Ÿ� ���(Triggering Event), �� ����Ŭ DML ���� INSERT, DELETE, UPDATE�� 
--              ����Ǹ� �ڵ����� ����
--  2. ����Ŭ Ʈ���� ��� ����
--    1) �����ͺ��̽� ���̺� �����ϴ� �������� ���� ���Ἲ�� ������ ���Ἲ ���� ������ ���� ���� �����ϴ� ��� 
--    2) �����ͺ��̽� ���̺��� �����Ϳ� ����� �۾��� ����, ���� 
--    3) �����ͺ��̽� ���̺� ����� ��ȭ�� ���� �ʿ��� �ٸ� ���α׷��� �����ϴ� ��� 
--    4) ���ʿ��� Ʈ������� �����ϱ� ���� 
--    5) �÷��� ���� �ڵ����� �����ǵ��� �ϴ� ��� 
-------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW --- OLD, NEW ����ϱ� ���ؼ�
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� ��:' || :old.dname);
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� ��:' || :new.dname);
END;

UPDATE dept
SET    dname = 'ȸ��3��'
WHERE  deptno = 72;

----------------------------------------------------------
--HW2 ) emp Table�� �޿��� ��ȭ��
--       ȭ�鿡 ����ϴ� Trigger �ۼ�( emp_sal_change)
--       emp Table ������
--      ���� : �Է½ô� empno�� 0���� Ŀ����

--��°�� ����
--     �����޿�  : 10000
--     ��  �޿�  : 15000
 --    �޿� ���� :  5000
----------------------------------------------------------
CREATE OR REPLACE TRIGGER emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
    WHEN (NEW.EMPNO > 0 )--- OLD, NEW ����ϱ� ���ؼ�
    DECLARE SAL_DIFF NUMBER;
BEGIN
-- SAL_DIFF := :new_sal - :old_sal;
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('���� �޿�:' || :old.sal);
    DBMS_OUTPUT.PUT_LINE('��   �޿�:' || :new.sal);
    DBMS_OUTPUT.PUT_LINE('�޿� ����:' || :old.sal - :new.sal);
END;

UPDATE emp
SET    sal = 1000
WHERE  empno = 7369;

--------------------------------------------------------------------------------------------------
--  EMP ���̺� INSERT,UPDATE,DELETE������ �Ϸ翡 �� ���� ROW�� �߻��Ǵ��� ����
--  ���� ������ EMP_ROW_AUDIT�� 
--  ID ,����� �̸�, �۾� ����,�۾� ���ڽð��� �����ϴ� 
--  Ʈ���Ÿ� �ۼ�
-------------------------------------------------------------------------------------------------
-- 1. sequence 
-- drop sequence emp_row_seq;
CREATE SEQUENCE emp_row_seq;

-- 2. Audit Table
--DROP  TABLE  emp_row_audit;
CREATE TABLE emp_row_audit(
    e_id    NUMBER(6) CONSTRAINT emp_row_pk PRIMARY KEY,
    e_name  VARCHAR2(30),
    e_gubun VARCHAR2(10),
    e_date  DATE
);

-- 3 TRIGGER
CREATE OR REPLACE TRIGGER emp_row_aud
    AFTER insert OR update OR delete ON emp
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL,:new.ename,'inserting',SYSDATE);
        ELSIF UPDATING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL,:old.ename,'updating',SYSDATE);
        ELSIF DELETING THEN
            INSERT INTO emp_row_audit
                VALUES(emp_row_seq.NEXTVAL,:old.ename,'deleting',SYSDATE);
        END IF;
    END;

INSERT INTO emp(empno,ename,sal,deptno)
       VALUES(3000, '������', 3500, 51);

INSERT INTO emp(empno,ename, sal,deptno)
       VALUES(3100,'Ȳ����' , 3500 , 51);
       
UPDATE emp
SET    ename = 'Ȳ����'
WHERE  empno = 1502;

DELETE emp
WHERE  empno = 1501;
    
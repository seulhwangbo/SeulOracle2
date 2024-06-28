-----------------------------------------------------------------
----- SUB Query   ***
-- �ϳ��� SQL ��ɹ��� ����� �ٸ� SQL ��ɹ��� �����ϱ� ���� 
-- �� �� �̻��� SQL ��ɹ��� �ϳ��� SQL��ɹ����� �����Ͽ�
-- ó���ϴ� ���
-- ���� 
-- 1) ������ ��������
-- 2) ������ ��������
-------------------------------------------------------------------
--  1. ��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�
-- 1-1 ���� ���̺��� ���������� ������ ���� �˻� SQL ��ɹ� ����
-- 9907	������ totoro ���Ӱ���	210	19/01/21  101
SELECT  position
FROM    professor
WHERE   name = '������'
;
-- 1-2 ���� ���̺��� ���� Į������ 1 ���� 
-- ���� ��� ���� ������ ������ ���� ���� �˻� ��ɹ� ����
SELECT  name, position
FROM    professor
WHERE   position = '���Ӱ���'
;

-- 1.��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�
-- > SUB Query
SELECT  name, position
FROM    professor
WHERE   position = (
                    SELECT  position
                    FROM    professor
                    WHERE   name = '������'
        )
;

-- ���� 
-- 1) ������ ��������
--  ������������ �� �ϳ��� �ุ�� �˻��Ͽ� ���������� ��ȯ�ϴ� ���ǹ�
--  ���������� WHERE ������ ���������� ����� ���� ��쿡�� �ݵ�� ������ �� ������ �� 
--  �ϳ��� ����ؾ���

--  ��1) ����� ���̵� ��jun123���� �л��� ���� �г��� �л��� �й�, �̸�, �г��� ����Ͽ���
SELECT studno, name, grade
FROM   student
WHERE  grade    = (
                SELECT grade
                FROM   student 
                WHERE  userid = 'jun123'
                )
;

--  ��2)  101�� �а� �л����� ��� �����Ժ��� �����԰� ���� �л��� �̸�, �г� , �а���ȣ, �����Ը�  ���
--  ���� : �а��� �ø����� ���
SELECT name, grade, deptno, weight
FROM   student
WHERE  weight < ( 
                SELECT AVG(weight)
                FROM   student
                WHERE  deptno = 101
)
ORDER BY deptno
;

--  ��3) 20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� 
-- �̸�, �г�, Ű, �а����� ����Ͽ���
--  ���� : �а��� �������� ���
SELECT s.name, s.grade, s.height, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND    s.grade = (
                    SELECT grade
                    FROM   student
                    WHERE  studno = 20101
                )
AND    s.height > (
                   SELECT height
                   FROM   student
                   WHERE  studno = 20101
                )
ORDER BY d.dname DESC
;

SELECT name, grade, height
FROM   student
WHERE  height > (
                    SELECT height
                    FROM   student
                    WHERE  studno = 20101
                )
AND     grade = (
                    SELECT grade
                    FROM   student
                    WHERE  studno = 20101
                )
ORDER BY grade DESC 
;

-- 2) ������ ��������
-- ������������ ��ȯ�Ǵ� ��� ���� �ϳ� �̻��� �� ����ϴ� ��������
-- ���������� WHERE ������ ���������� ����� ���� ��쿡�� ���� �� �� ������ �� ����Ͽ� ��
-- ���� �� �� ������ : IN, ANY, SOME, ALL, EXISTS
-- 1) IN         : ���� ������ �� ������ ���������� ����߿��� �ϳ��� ��ġ�ϸ� ��, ��=���񱳸� ����
-- 2) ANY, SOME  : ���� ������ �� ������ ���������� ����߿��� �ϳ��� ��ġ�ϸ� ��
-- 3) ALL        : ���� ������ �� ������ ���������� ����߿��� ��簪�� ��ġ�ϸ� ��, 
-- 4) EXISTS     : ���� ������ �� ������ ���������� ����߿��� �����ϴ� ���� �ϳ��� �����ϸ� ��

-- �Ϻη� ������ �� �����̴�
-- single-row subquery returns more than one row
SELECT name,grade,deptno
FROM   student
WHERE  deptno = (
                    SELECT deptno
                    FROM   department
                    WHERE  college = 100
                )
;


-- 1.  IN �����ڸ� �̿��� ���� �� ��������
-- ��Ƽ row�� �ش��ϴ� ������ ���������� �־�� in�� ������ �ȴ�
SELECT name,grade,deptno
FROM   student
WHERE  deptno IN (
                    SELECT deptno
                    FROM   department
                    WHERE  college = 100
                )
;

-- ���� �Ͱ� �Ȱ��� ����� ����
SELECT name,grade,deptno
FROM   student
WHERE  deptno IN (
              101,102
                )
;

--  2. ANY(OR) �����ڸ� �̿��� ���� �� ��������
-- ��)��� �л� �߿��� 4�г� �л� �߿��� Ű�� ���� ���� �л����� Ű�� ū �л��� �й�, �̸�, Ű�� ����Ͽ���
SELECT  studno, name, height  
FROM    student
WHERE   height> ANY(
                    SELECT height
                    FROM   student
                    WHERE  grade = '4'
)
ORDER BY studno
; 

--- 3. ALL (AND) �����ڸ� �̿��� ���� �� ��������
SELECT  studno, name, height  
FROM    student
WHERE   height> ALL(
                    SELECT height
                    FROM   student
                    WHERE  grade = '4'
)
ORDER BY studno
; 

--- 4. EXISTS �����ڸ� �̿��� ���� �� ��������
SELECT profno, name, sal, comm, position
FROM   professor
WHERE EXISTS (
                -- �����ϴ� �� �ϳ��� ������
                -- �����ϴ� �� 1 ROW�� �ִٸ�
                -- �� �˷����
              SELECT position
              FROM   professor
              WHERE  comm IS NOT NULL
            )
;

SELECT profno, name, sal, comm, position
FROM   professor
WHERE EXISTS (
              SELECT position
              FROM   professor
              -- WHERE  deptno = 202
              WHERE  deptno = 203
            )
;

-- ��1)  ���������� �޴� ������ �� ���̶� ������ 
--       ��� ������ ���� ��ȣ, �̸�, �������� �׸��� �޿��� ���������� ��(NULLó��)�� ���
SELECT profno, name, comm, (NVL(sal,0) + sal) sal_comm
FROM   professor
WHERE  EXISTS (
            SELECT profno
            FROM   professor
            WHERE  comm is not null
)
;

-- ��2) �л� �߿��� ��goodstudent���̶�� ����� ���̵� ������ 1�� ����Ͽ���
SELECT 1 userid_exist
FROM   dual
WHERE  NOT EXISTS ( 
                    SELECT userid
                    FROM   student
                    WHERE  userid = 'goodstudent'
                    )
;

-- ���� �÷� ��������
-- ������������ ���� ���� Į�� ���� �˻��Ͽ� ���������� �������� ���ϴ� ��������
-- ���������� ������������ ���������� Į�� ����ŭ ����
-- ����
-- 1) PAIRWISE : Į���� ������ ��� ���ÿ� ���ϴ� ���
-- 2) UNPAIRWISE : Į������ ����� ���� ��, AND ������ �ϴ� ���

-- 1) PAIRWISE ���� Į�� ��������
-- ��1)    PAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� 
--          �л��� �̸�, �г�, �����Ը� ����Ͽ���
SELECT name,grade,weight
FROM   student
WHERE  (grade, weight) IN (SELECT grade, MIN(weight)
                           FROM   student
                           GROUP BY grade
                           )
;

-- 2) UNPAIRWISE : Į������ ����� ���� ��, AND ������ �ϴ� ���
-- UNPAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� �л��� �̸�, �г�, �����Ը� ���
SELECT name,grade,weight
FROM   student
WHERE  grade IN (SELECT grade
                 FROM   student
                 GROUP BY grade
                )
AND    weight IN (SELECT MIN(weight)
                  FROM   student
                  GROUP BY grade
                )
;

-- ��ȣ���� ��������     ***
-- ������������ ������������ �˻� ����� ��ȯ�ϴ� ��������
-- ���������� �ϳ��ϳ� ������ ���� ���� ������ Ȯ���ϴ� ����� �����ϴ� �� ���̴�.
-- ��1)  �� �а� �л��� ��� Ű���� Ű�� ū �л��� �̸�, �а� ��ȣ, Ű�� ����Ͽ���
--                ������� 1
----              ������� 3
SELECT deptno, name, grade, height
FROM   student s1
WHERE  height >(SELECT AVG(height)
                FROM   student s2
                WHERE  s2.deptno = s1.deptno
                -- WHERE s2.deptno = 101 ���� ���� 2
                )
ORDER BY deptno
;
-- ����� ���� ���ϴ��� ���� �������� ���ؼ� �˾ƾ� �Ѵ�.
-- ���� ������ �ƴ����� ���������δ� ����� FOR���� ���ٰ� �����ϸ� ���ذ� ����������
-- 101�� ���Ű���� ū �ֵ�, 102�� ���Ű���� ū�ֵ�, 201�� ���Ű���� ū�ֵ�
-- �̷� ������ ���ư��鼭 ����� ����ȴ�
-------------  HW  -----------------------
-- 1. Blake�� ���� �μ��� �ִ� ��� ����� ���ؼ� ��� �̸��� �Ի����� ���÷����϶�
-- emp table
-- SELECT ename, hiredate, deptno
SELECT ename, hiredate, deptno 
FROM   emp
WHERE  deptno = (
                SELECT deptno
                FROM   emp
                where  ename = 'Blake'
                )
;

-- 2. ��� �޿� �̻��� �޴� ��� ����� ���ؼ� ��� ��ȣ�� �̸��� ���÷����ϴ� ���ǹ��� ����. 
--    �� ����� �޿� �������� �����϶�

SELECT EMPNO, ENAME, SAL
FROM   EMP 
WHERE  sal > (
            SELECT AVG(SAL)
            FROM EMP
);
-- 3. ���ʽ��� �޴� � ����� �μ� ��ȣ�� 
--    �޿��� ��ġ�ϴ� ����� �̸�, �μ� ��ȣ �׸��� �޿��� ���÷����϶�.
SELECT ENAME, DEPTNO, SAL
FROM   EMP 
WHERE  (sal,deptno) in (
                        select sal,deptno
                        from    emp
                        WHERE   comm is not null
);
----------------------------------------------------------------------
--  ������ ���۾� (DML:Data Manpulation Language)  **                  ----------
-- 1.���� : ���̺� ���ο� �����͸� �Է��ϰų� ���� �����͸� ���� �Ǵ� �����ϱ� ���� ��ɾ�
-- 2. ���� 
--  1) INSERT : ���ο� ������ �Է� ��ɾ�
--  2) UPDATE : ���� ������ ���� ��ɾ�
--  3) DELETE : ���� ������ ���� ��ɾ�
--  4) MERGE : �ΰ��� ���̺��� �ϳ��� ���̺�� �����ϴ� ��ɾ�

-- 1) Insert
-- "not enough values"
INSERT INTO DEPT VALUES(73,'�λ�');
-- ���๮�� �Ʒ�
INSERT INTO DEPT VALUES(73,'�λ�', '�̴�');
INSERT INTO DEPT (deptno, Dname, LOC) VALUES(74,'ȸ����','������');
INSERT INTO DEPT (deptno, LOC, DNAME) VALUES(76,'�Ŵ��','������');
INSERT INTO DEPT (deptno, LOC) VALUES(77,'ȫ��');
-- ���� �������� ���� VALUES�� null ������ �˾Ƽ� ���� �ȴ�
-- 1��ó�� �ϸ� ��� ���� �� �־�� ������ 
-- ��ó�� �ϰ� �Ǹ� ��� ���� ���� �ʿ䰡 ���� ���ϴ� ���� ���� �� �ִ�

-- INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
--                 VALUES(9910,'��̼�','���Ӱ���','sysdate',101);
-- INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
--                 VALUES(9920,'������','������',TO_DATE('2006/01/01','YYYY/MM/DD','102');

INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
                VALUES(9910,'��̼�','���Ӱ���','24/06/28','101');
INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
                VALUES(9920,'������','������','06/01/01','102');
    
DROP TABLE JOB3;
CREATE TABLE JOB3
(   jobno         NUMBER(2)      PRIMARY KEY,
	jobname       VARCHAR2(20)
) ;

INSERT INTO job3                  VALUES (10, '�б�');
INSERT INTO job3 (jobno, jobname) VALUES (11, '������');
INSERT INTO job3 (jobname, jobno) VALUES ('�����', 12);
INSERT INTO job3 (jobno, jobname) VALUES (13, '����');
INSERT INTO job3 (jobno, jobname) VALUES (14, '�߼ұ��');

CREATE TABLE Religion   
(    religion_no         NUMBER(2)     CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
	 religion_name     VARCHAR2(20)
) ;

INSERT INTO Religion                                VALUES(10,'�⵶��');
INSERT INTO Religion                                VALUES(20,'ī�縯��');
INSERT INTO Religion (religion_no, religion_name)   VALUES(30,'�ұ�');
INSERT INTO Religion (religion_name, religion_no)   VALUES('����',40);

--------------------------------------------------
-----   ���� �� �Է�                         ------
--------------------------------------------------
-- 1. ������ TBL�̿� �ű� TBL ����
CREATE Table dept_second
AS SELECT * FROM dept
;

-- TBL ���� ����
CREATE Table emp20
AS SELECT empno, ename, sal*12 annsal
   FROM   emp
   WHERE  deptno = 20
;

-- TBL ������
-- ���̺� ������
CREATE Table dept30
AS SELECT  deptno, dname
   FROM    dept
   WHERE   0=1;
   
-- Column �߰�
ALTER TABLE dept30
ADD(birth DATE);

INSERT INTO dept30 VALUES(10,'�߾��б�',sysdate);

-- 5.column ����
-- "cannot decrease column length because some value is too big"
ALTER TABLE dept30
MODIFY dname varchar2(11)
;
ALTER TABLE dept30
MODIFY dname varchar2(30)
;
--�츮�� ������ ���� 12 byte�� 11 byte�� ���� �� ����

-- 6. Column ����
ALTER TABLE dept30
DROP Column dname
;

-- 7. TBL ����
RENAME dept30 TO dept35;

--8. TBL ����
DROP TABLE DEPT35;

--9. Truncate
TRUNCATE table dept_second;

-- Inset all
-- INSERT ALL(unconditional INSERT ALL) ��ɹ�
-- ���������� ��� ������ ���Ǿ��� ���� ���̺� ���ÿ� �Է�
-- ���������� �÷� �̸��� �����Ͱ� �ԷµǴ� ���̺��� Į���� �ݵ�� �����ؾ� ��
CREATE Table height_info
( studNO  number(5),
  NAME    VARCHAR2(20),
  height  number(5,2)
);
CREATE Table weight_info
( studNO  number(5),
  NAME    VARCHAR2(20),
  weight  number(5,2)
);

INSERT ALL
INTO    height_info VALUES(studNO, name, height)
INTO    weight_info VALUES(studNO, name, weight)
SELECT  grade,studno,name,height,weight
FROM    student
WHERE   grade <= '2';

-- INSERT ALL 
-- [WHEN ������1 THEN
-- INTO [table1] VLAUES[(column1, column2,��)]
-- [WHEN ������2 THEN
-- INTO [table2] VLAUES[(column1, column2,��)]
-- [ELSE
-- INTO [table3] VLAUES[(column1, column2,��)]
-- subquery;
-- when �������� �ɾ Ȯ���ϱ�

-- �л� ���̺��� 2�г� �̻��� �л��� �˻��Ͽ� 
-- height_info ���̺��� Ű�� 170���� ū �л��� �й�, �̸�, Ű�� �Է�
-- weight_info ���̺��� �����԰� 70���� ū �л��� �й�, �̸�, �����Ը� 
-- ���� �Է��Ͽ���
DELETE height_info;
DELETE weight_info;

INSERT ALL
WHEN height > 170 THEN
INTO height_info VALUES(studNO, name, height)
WHEN weight > 75  THEN
INTO weight_info VALUES(studNO, name, weight)
SELECT  grade,studno,name,height,weight
FROM    student
WHERE   grade >= '2';

-- ������ ���� ����
-- UPDATE ��ɹ��� ���̺� ����� ������ ������ ���� ���۾�
-- WHERE ���� �����ϸ� ���̺��� ��� ���� ����
--- Update 
-- ��1) ���� ��ȣ�� 9903�� ������ ���� ������ ���α������� �����Ͽ���
UPDATE professor
SET    position = '�α���',userid = 'kkk'
WHERE  profno   = 9903;

--  ��2) ���������� �̿��Ͽ� �й��� 10201�� �л��� �г�� �а� ��ȣ��
--        10103 �й� �л��� �г�� �а� ��ȣ�� �����ϰ� �����Ͽ���
-- pair 
UPDATE student
SET    (grade,deptno)  = (
                SELECT grade,deptno 
                FROM   student
                WHERE  studno = 10103
                )
WHERE  STUDNO = 10201;

-- ������ ���� ����
-- DELETE ��ɹ��� ���̺� ����� ������ ������ ���� ���۾�
-- WHERE ���� �����ϸ� ���̺��� ��� �� ����
-- WHERE �� �������� �ʵ��� �����ϱ�

-- ��1) �л� ���̺��� �й��� 20103�� �л��� �����͸� ����
DELETE
FROM   student
WHERE  studno  = 20103;
--  ��2) �л� ���̺��� ��ǻ�Ͱ��а��� �Ҽӵ� �л��� ��� �����Ͽ���. HomeWork --> Rollback
DELETE 
FROM student 
WHERE deptno=(
            SELECT deptno
            FROM   department
            WHERE  Dname = '��ǻ�Ͱ��а�'
            )
;

ROLLBACK;

-- COMMIT �� �ϰ� ROLLBACK�� ���� �� �� �����͸� �츮��

----------------------------------------------------------------------------------
---- MERGE
--  1. MERGE ����
--     ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
--     WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ���� ���ο� ������ ����,
--     �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����
------------------------------------------------------------------------------------
--- DML�̴� ---

-- 1] MERGE �����۾� 
--  ��Ȳ 
-- 1) ������ �������� 2�� Update
-- 2) �赵�� ���� �ű� Insert

Create TABLE  professor_temp
as     SELECT * FROM professor
       WHERE  position = '����';
UPDATE professor_temp
SET    position = '������'
WHERE  position = '����';

INSERT INTO professor_temp
VALUES(9999,'�赵��','arom21','���Ӱ���',200,sysdate, 10, 101);

commit;

-- 2] professor MERGE ���� 
-- ��ǥ : professor_temp�� �ִ� ����   ������ ������ professor Table�� Update
--                         �赵�� ���� �ű� Insert ������ professor Table�� Insert
-- 1) ������ �������� 2�� Update
-- 2) �赵�� ���� �ű� Insert
-- professor table�� update

MERGE INTO professor p
USING professor_temp f
ON    (p.profno = f.profno)
WHEN MATCHED then --PK�� ������ ������ UPDATE
    update set p.position = f.position
WHEN NOT MATCHED then -- PK�� ������ �ű� INSERT
    insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    
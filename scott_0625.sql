SELECT * FROM tab;
-- ���̺� ���� ����
DESC dept;
-- ������ ���������
SELECT DEPTNO , LOC FROM DEPT;
SELECT DNAME, DEPTNO FROM DEPT;
-- �μ� ���̺��� DNAME�� DEPTNO�� ��½��Ѷ�
-- �μ� ���̺��� DEPTNO�� LOC�� ��½��Ѷ�
--�л� ���̺��� �ߺ��Ǵ� �а� ��ȣ(deptno)�� �����ϰ� ����Ͽ���
SELECT distinct deptno FROM student;

--?���� �ο� ���
--?Į�� �̸��� ���� ���̿� ������ �߰��ϴ� ���
--?Į�� �̸��� ���� ���̿� AS Ű���带 �߰��ϴ� ���
--?ū����ǥ�� ����ϴ� ���
--?Į�� �̸��� ���� ���̿� ������ �߰��ϴ� ���
--?Ư�����ڸ� �߰��ϰų� ��ҹ��ڸ� �����ϴ� ���

-- EX> �μ� ���̺��� �μ� �̸� Į���� ������ dept_name, 
--     �μ� ��ȣ Į���� ������ DN���� �ο��Ͽ� ����Ͽ���

SELECT dname dept_name, deptno AS dn 
FROM department; 

--?�ռ�(concatenation)������ (||)
--?�ϳ��� Į���� �ٸ� Į��, ��� ǥ����
-- �Ǵ� ��� ���� �����Ͽ� �ϳ��� Į��ó�� ����� ��쿡 ���

--?�л� ���̺��� �й��� �̸� Į���� �����Ͽ� 
--��StudentAli����� �������� �ϳ��� Į��ó�� �����Ͽ� ����Ͽ���

SELECT studno|| ' ' || name "StudentAli"
FROM student;

SELECT name, weight, weight * 2.2 as weight_pound 
FROM student
ORDER BY NAME;

-- DDL ���� < ���̺� ����� ���� >
-- CHAR�� VARCHAR2�� ���� ����
CREATE TABLE ex_type 
(c    CHAR(10), 
 v  VARCHAR2(10)
 ); 
 -- �� �� 3 byte�� ����־���.
 -- DML ���
 INSERT INTO ex_type 
 VALUES ( 'sql','sql');
 -- DCL 
 -- REVOKE, COMMIT
 COMMIT;
 
 SELECT *
 FROM ex_type
 WHERE c = 'sql'
 ;
 
 SELECT *
 FROM ex_type
 WHERE v = 'sql'
 ;
 
 SELECT *
 FROM ex_type
 WHERE c = v
 ;
 --?�л� ���̺��� 1�г� �л��� �˻��Ͽ� �й�, �̸�, �а� ��ȣ�� ����Ͽ���
 SELECT name,deptno,studno 
 FROM Student 
 WHERE grade = '1'
 ORDER BY name;
 
--?�л� ���̺��� �����԰� 70kg ������ �л��� �˻��Ͽ� �й�, �̸�, �г�, �а���ȣ, �����Ը� ����Ͽ���.
SELECT name, studno, grade, weight, deptno
 FROM Student
 Where weight <=70
 ORDER BY name
;
 SELECT name, studno, grade, weight, deptno
 FROM Student
 Where weight >=70
 and grade = 1
 ORDER BY name
;

 SELECT name, studno, grade, weight, deptno
 FROM Student
 Where weight >=70
 OR grade = 1
 ORDER BY STUDNO
;
-- BETWEEN �����ڸ� ����Ͽ� �����԰� 50kg���� 70kg ������ �л��� �й�, �̸�, �����Ը� ����Ͽ���
SELECT name, studno, weight
FROM Student
WHERE weight 
between 50 and 70
;
--�л����̺��� 81�⿡�� 83�⵵�� �¾ �л��� �̸��� ��������� ����ض�
SELECT name, birthdate
FROM Student
WHERE birthdate
between '81/01/01' and '83/12/31'
-- between to_date('810101') AND to_date('831231')
;
-- IN �����ڸ� ����Ͽ� 102�� �а��� 201�� �а� �л��� �̸�, �г�, �а���ȣ�� ����Ͽ���
SELECT name, grade, deptno
FROM Student
WHERE DEPTNO IN (102, 201)
-- WHERE DEPTNO = 102
-- OR DEPTNO = 201
;
-- �л� ���̺��� ���� ���衯���� �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ���
SELECT name, grade, deptno
FROM Student
Where name LIKE '��%'
;
-- �̸� �� ��: ����� ��
SELECT name, grade, deptno
FROM Student
Where name LIKE '%��%'
;
-- �̸� �� �������� ��
SELECT name, grade, deptno
FROM Student
Where name LIKE '%��'
;

-- �л� ���̺��� �̸��� 3����, ���� ���衯���� ������ ���ڰ�
-- ���������� ������ �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ���

SELECT name, grade, deptno
FROM Student
Where name LIKE '��%��' 
;

SELECT name, grade, deptno
FROM Student
Where name LIKE '��_��' 
;

-- null ��Ȯ�� ���̳� ���� ������� ���� ���� �ǹ��Ѵ�
-- emp�� comm�� Ȯ���ϱ� null���� �ִ� �κ��� �ִ�.

SELECT empno, sal, comm 
FROM emp;

SELECT empno, sal, comm, sal + comm
FROM emp;

SELECT empno, sal, comm, sal + NVL(comm, 0)
FROM emp;

-- ?���� ���̺��� �̸�, ����, ���������� ����Ͽ�
SELECT name, position, comm 
From Professor
;

-- ���� ���̺��� ���������� ���� ������ �̸�, ����, ���������� ����Ͽ���
SELECT  name, position, comm
FROM professor
WHERE comm IS null
-- where comm = null �̷��� �ϸ� �� �ȴ�
;

--���� ���̺��� �޿��� ���������� ���� ���� sal_com�̶�� �������� ����Ͽ���
SELECT name, position, sal , comm , sal +  comm sal_com
FROM professor
;
-- COM�� NULL�̸� 0�� ���

SELECT name, position, sal , comm , sal + NVL(comm,0) sal_com
FROM professor
;

--102�� �а��� �л� �߿��� 1�г� �Ǵ� 4�г� �л��� �̸�, �г�, �а� ��ȣ�� ����Ͽ���
SELECT name, grade, deptno 
FROM student 
WHERE deptno = 102
AND (grade = 1 OR grade =  4)
;

-- ���� ������
-- 
-- -- 1�г� �̸鼭 �����԰� 70kg �̻��� �л��� ���� --> Table  stud_heavy
-- select�� ����� table�� �����.
CREATE table stud_heavy 
AS
SELECT * 
FROM student
where weight >= 70
and grade = ' 1' 
;
-- 1�г� �̸鼭 101�� �а��� �Ҽӵ� �л�(stud_101)
CREATE TABLE stud_101
AS
SELECT *
FROM Student
WHERE grade = 1
AND deptno = 101
;

--UNION
SELECT studno, name, userid
FROM stud_heavy
UNION
SELECT studno, name
FROM stud_101
;

--UNION
-- Union  �ߺ� ����   (�ڵ��� , ������) + (�ڹ̰� , ������)
SELECT studno, name
FROM stud_heavy
UNION
SELECT studno, name
FROM stud_101
;

--UNIONALL
SELECT studno, name
FROM stud_heavy
UNION ALL
SELECT studno, name
FROM stud_101
;

-- INTERSECT = ����
SELECT studno, name
FROM stud_heavy
INTERSECT
SELECT studno, name
FROM stud_101
;

-- MINUS
SELECT studno, name
FROM stud_heavy
MINUS
SELECT studno, name
FROM stud_101
;
--����(sorting)
--?SQL ��ɹ����� �˻��� ����� ���̺� �����Ͱ� �Էµ� ������� ���
--?������, �������� ��� ������ Ư�� �÷��� �������� �������� �Ǵ� ������������ �����ϴ� ��찡 ���� �߻�
--?���� ���� Į���� ���� ���� ������ ���ϴ� ��쵵 �߻�
--?ORDER BY : Į���̳� ǥ������ �������� ��� ����� ������ �� ���
--?ASC : ������������ ����, �⺻ ��
--?DESC : ������������ �����ϴ� ��쿡 ���, ���� �Ұ���

--�л� ���̺��� �̸��� �����ټ����� �����Ͽ� �̸�, �г�, ��ȭ��ȣ�� ����Ͽ���
SELECT name, grade, tel 
FROM student
-- ORDER BY NAME 
-- ORDER BY name ASC
ORDER BY name desc
;

-- �л� ���̺��� �г��� ������������ �����Ͽ� �̸�, �г�, ��ȭ��ȣ�� ����Ͽ���
SELECT name, grade, tel
FROM   student
ORDER BY grade desc
;

-- �׸�� ����� �̸��� �޿� �� �μ���ȣ�� ����ϴµ�, 
-- �μ� ��ȣ�� ����� ������ ���� �޿��� ���ؼ��� ������������ �����϶�.
SELECT ENAME,JOB, SAL, DEPTNO 
FROM EMP
order by deptno, sal DESC;

-- 1. �μ� 10�� 30�� ���ϴ� ��� ����� �̸��� �μ���ȣ�� �̸��� 
-- ���ĺ� ������ ���ĵǵ��� ���ǹ��� �����϶�

SELECT ENAME, DEPTNO 
FROM EMP
ORDER BY ENAME ASC
;

---- ��2) 1982�⿡ �Ի��� ��� ����� �̸��� �Ի����� ���ϴ� ���ǹ�

SELECT ename, hiredate
FROM EMP
WHERE HIREDATE 
BETWEEN '1982/01/01' AND '1982/12/31'
;

-- 3. �׺��ʽ��� �޴� ��� ����� ���ؼ� �̸�, �޿� �׸��� ���ʽ��� ����ϴ� 
-- ���ǹ��� �����϶�. 
-- �� �޿��� ���ʽ��� ���ؼ� �������� ����

SELECT ENAME, SAL, COMM
FROM EMP
WHERE COMM IS NOT NULL
ORDER BY SAL, COMM DESC
;

-- ��4) ���ʽ��� �޿��� 20% �̻��̰� �μ���ȣ�� 30�� ��� ����� ���ؼ�
--       �̸�, �޿� �׸��� ���ʽ��� ����ϴ� ���ǹ��� �����϶�

SELECT ENAME, SAL, COMM
FROM EMP 
WHERE DEPTNO = '30'
AND COMM >= SAL / 20
;

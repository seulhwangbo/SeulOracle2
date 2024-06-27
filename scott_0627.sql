---------------------------------------------------------
---   ** 8��. �׷��Լ� 
----  ���̺��� ��ü ���� �ϳ� �̻��� �÷��� �������� �׷�ȭ�Ͽ�
---   �׷캰�� ����� ����ϴ� �Լ�
--    �׷��Լ��� ������� ����� ����ϴµ� ���� ���
-----------------------------------------------------------
-- SELECT  column, group_function(column)
-- FROM  table
-- [WHERE  condition]
-- [GROUP BY  group_by_expression]
-- [HAVING  group_condition]
-- GROUP BY : ��ü ���� group_by_expression�� �������� �׷�ȭ
-- HAVING : GROUP BY ���� ���� ������ �׷캰�� ���� �ο�
-- GROUP BY �Լ��� �� ���� HAVING���� �̿��ؼ� ������ �ο��Ѵٴ� ���� �߿��ϴ� 
-- WHERE �� �򰥸��� �ʰ� �ϱ�

--  ����           �ǹ�
--  COUNT         ���� ���� ���
--  MAX           NULL�� ������ ��� �࿡�� �ִ� ��
--  MIN           NULL�� ������ ��� �࿡�� �ּ� ��
--  SUM           NULL�� ������ ��� ���� ��
--  AVG           NULL�� ������ ��� ���� ��� ��
------------- �� �ʼ� �Ʒ��� ���۸� --------------------
--  STDDEV        NULL�� ������ ��� ���� ǥ������
--  VARIANCE      NULL�� ������ ��� ���� �л� ��
--  GROUPING      �ش� Į���� �׷쿡 ���Ǿ����� ���θ� 1 �Ǵ� 0���� ��ȯ
--  GROUPING SETS �� ���� ���Ƿ� ���� ���� �׷�ȭ ���


-- 1) COUNT �Լ�
-- ���̺��� ������ �����ϴ� ���� ������ ��ȯ�ϴ� �Լ�
-- ��1) 101�� �а� �����߿��� ���������� �޴� ������ ���� ����Ͽ���
SELECT COUNT(*), COUNT(comm)
FROM  professor
WHERE deptno = 101
;

--102�� �а� �л����� ������ ��հ� �հ踦 ����Ͽ���
SELECT AVG(weight), SUM(weight)
FROM student
WHERE deptno = 102
;

-- ���� ���̺��� �޿��� ǥ�������� �л��� ���
SELECT STDDEV(sal), VARIANCE(sal) 
FROM professor
;

-- �а���  �л����� �ο���, ������ ��հ� �հ踦 ����Ͽ���
SELECT      deptno, COUNT(*), AVG(weight), SUM(weight) 
FROM        student
GROUP BY    deptno
;

-- null���� �ڵ����� count���� ���ŵȴ�
-- ���� ���̺��� �а� ���� ������ ���� ���������� �޴� ���� ���� ����϶�
SELECT deptno, COUNT(*) professor, COUNT(COMM) commm
FROM PROFESSOR
GROUP BY deptno
;

-- ���� ���̺��� �а����� ���� ���� ���������� �޴� ���� ���� ����Ͽ���
-- �� �а����� ���� ���� 2�� �̻��� �а��� ���
-- Group by�� �������� having���� �ɾ��ְ� ������ group by �ڿ� �ؾ� �Ѵ�
-- where�� ���� ������ ������ where�� �Ϲ� �Լ��� ����ϴ� ��
SELECT deptno, COUNT(*), COUNT(comm)
FROM professor
GROUP BY deptno
having COUNT(*)>1
;
-- �л� ���� 4���̻��̰� ���Ű�� 168�̻���  �г⿡ ���ؼ� 
-- �г�, �л� ��, ��� Ű, ��� �����Ը� ���
-- ��, ��� Ű�� ��� �����Դ� �Ҽ��� �� ��° �ڸ����� �ݿø� �ϰ�, 
-- ��¼����� ��� Ű�� ���� ������ ������������ ����ϰ� 
--   �� �ȿ��� ��� �����԰� ���� ������ ������������ ���
SELECT   GRADE, COUNT(*), 
         ROUND(AVG(HEIGHT),1) avg_height, 
         ROUND(AVG(WEIGHT),1) avg_weight
FROM     STUDENT
GROUP BY GRADE
HAVING   COUNT(*) >= 4 
AND      ROUND(AVG(HEIGHT))>= 168
ORDER BY avg_height DESC, 
         avg_weight DESC
;

--  �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT max(hiredate), min(hiredate)
FROM emp
;

--  �μ��� �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT deptno, min(hiredate), max(hiredate)
FROM emp
GROUP BY deptno
ORDER BY DEPTNO
;

-- �μ��� ������ count sum
SELECT deptno,job, COUNT(*), SUM(sal)
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job
;

-- �μ��� �޿��Ѿ� 3000�̻� �μ���ȣ,�μ��� �޿��ִ�    (emp)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno
HAVING sum(sal) >= 3000
ORDER BY deptno
;

--��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, 
--   �а��� �г⺰ �ο���, ��� �����Ը� ���, 
-- (��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� )  STUDENT
SELECT deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM student
GROUP BY deptno, grade
ORDER BY deptno, grade
;
-- ROLLUP ������
-- GROUP BY ���� �׷� ���ǿ� ���� ��ü ���� �׷�ȭ�ϰ� �� �׷쿡 ���� �κ����� ���ϴ� ������
-- ��) �Ҽ� �а����� ���� �޿� �հ�� ��� �а� �������� �޿� �հ踦 ����Ͽ���
SELECT deptno, SUM(sal)
FROM professor
GROUP BY ROLLUP(deptno)
;
--ex) ROLLUP �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� ���� ����Ͽ���
SELECT deptno, position, COUNT(*)
FROM professor
GROUP BY ROLLUP(deptno, position)
;
-- CUBE ������
-- ROLLUP�� ���� �׷� ����� GROUP BY ���� ����� ���ǿ� ���� �׷� ������ ����� ������
--ex)CUBE �����ڸ� �̿��Ͽ� �а� �� ���޺� ���� ��, �а��� ���� ��, ��ü ���� ���� ����Ͽ���.
SELECT deptno, position, COUNT(*)
FROM professor
GROUP BY CUBE(deptno, position)
;
-------------------------------------------------------------------------
------------DeadLock    ---------
-- ��ȣ ��û, ���� * ��� ����, ���� -> ���� �� ������� ������ �� �� ���� �����̴�
-- deadlock�� ���°� �ƴ� ���� ? �̶�� ��� ���迡 ���� �� �ִ�. 
-------------------------------------------------------------------------
--Transaction A
--1) Smith
UPDATE emp --�ڿ� 1
SET    sal = sal*1.1
WHERE  empno=7369
;
--2 King --> LOCK ���� ���������� �� A�� �ڿ� 2 �䱸 ����
UPDATE emp
SET    sal = sal*1.1
WHERE  empno=7839
;

--Transaction B
UPDATE emp -- �ڿ� 2
SET    comm=500
WHERE  empno=7839
;
UPDATE emp -- �ڿ� 1�� �䱸�Ѵ�
SET    comm=300
WHERE  empno=7369
;

insert into dept Values(72, 'kk','kk');
commit;

----------------------------------------------------------------------
----                    9-1.     JOIN       ***              ---------
----------------------------------------------------------------------
-- 1) ������ ����
--    �ϳ��� SQL ��ɹ��� ���� ���� ���̺� ����� �����͸� �ѹ��� ��ȸ�Ҽ� �ִ� ���
-- ex1-1) �й��� 10101�� �л��� �̸��� �Ҽ� �а� �̸��� ����Ͽ���
-- ������ ����� '���� �� ����� �й��� �˰� �ִٴ� ���� �Ͽ��� ������ �� �ִ�'
SELECT studno, name, deptno
FROM   student
WHERE  studno = 10101;
-- ex1-2)�а��� ������ �а��̸�
SELECT dname
FROM department
WHERE deptno = 101;
-- ex1-3)  [ex1-1] + [ex1-2] �ѹ� ��ȸ  ---> Join
SELECT studno, name,  
       student.deptno, department.dname
FROM   student, department
WHERE  student.deptno = department.deptno;

-- �ָŸ�ȣ�� ambiguously
-- alias ���� ����ض�
-- Join �� �� ���ؾ� �� �͵�
SELECT  studno, name, deptno, dname
FROM    student s, department d 
WHERE   s.deptno = d.deptno
;
-- ���� �ذ� ���� ���� <�ؿ� �ִ� �͵��� �����̴�>
SELECT  s.studno, s.name, d.deptno, d.dname
FROM    student s, department d 
WHERE   s.deptno = d.deptno
;
-- ������ �л��� �й�, �̸�, �а� �̸� �׸��� �а� ��ġ�� ���
SELECT   s.studno, s.name, d.deptno, d.deptno
FROM     student s, department d 
WHERE    s.deptno = d.deptno 
AND      s.name = '������'
;
-- �����԰� 80kg�̻��� �л��� �й�, �̸�, ü��, �а� �̸�, �а���ġ�� ���
SELECT  s.studno, s.name, s.weight, d.dname, d.loc
FROM    student s, department d
WHERE   S.DEPTNO = D.DEPTNO 
AND     S.WEIGHT >= 80
;

-- īƼ�� �� : �� �� �̻��� ���̺� ���� ���� ������ ���� ��� ����
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s, department d
;
-- where ������ ���� table�� �ɸ� ��� �Ǵ°� 
-- ���� �͵��� ������ �ȴ�
-- student 17 * department 7 = �� ������ ���� ���� īƼ������ ������ �ȴ�
-- a ���̺��� ���� b ���̺��� ���� ũ�ν� ���� ��Ż ������ �� ���ΰ�?
-- ��� ���迡�� ������ �����̴�
-- ũ�ν� ������ �� �ִ� ������ �׷��ٸ� �����ϱ�
-- 1. ������ �Ǽ�
-- 2. �����ʱ⿡ ���� data ����
-- �������� ���ؾ� �Ѵ�. 
-- ���� ���� ����̰� �������� ���� cross join ����̴�
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s CROSS JOIN department d
;

-- EQ JOIN
-- ***
-- ���� ��� ���̺��� ���� Į���� ��=��(equal) �񱳸� ���� 
-- ���� ���� ������ ���� �����Ͽ� ����� �����ϴ� ���� ���
-- SQL ��ɹ����� ���� ���� ����ϴ� ���� ���
-- �ڿ������� �̿��� EQUI JOIN
-- ����Ŭ 9i �������� EQUI JOIN�� �ڿ������̶� ���
-- WHERE ���� ������� �ʰ�  NATURAL JOIN Ű���� ���
-- ����Ŭ���� �ڵ������� ���̺��� ��� Į���� ������� ���� Į���� ���� ��, ���������� ���ι� ����

-- ���� join example
-- ����Ŭ ���� ǥ��
SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

-- ansi ǥ���
-- nature join
-- Natural Join Convert Error �ذ� 
-- NATURAL JOIN�� ���� ��Ʈ����Ʈ�� ���̺� ������ ����ϸ� ������ �߻�
SELECT s.studno, s.name, s.weight, d.deptno, d.dname, d.loc
FROM student s
     NATURAL JOIN department d;
 -- deptno �κ� Ȯ���ϱ�     
SELECT s.studno, s.name, s.weight, deptno, d.dname, d.loc
FROM   student s
       NATURAL JOIN department d;
-- NATURAL JOIN�� �̿��Ͽ� ���� ��ȣ, �̸�, �а� ��ȣ, �а� �̸��� ����Ͽ���
SELECT p.profno, p.name, deptno,d.dname
FROM   professor p
       NATURAL JOIN department d;
-- NATURAL JOIN�� �̿��Ͽ� 4�г� �л��� �̸�, �а� ��ȣ, �а��̸��� ����Ͽ���
SELECT s.grade, s.name, deptno, d.dname
FROM   student s
       NATURAL JOIN department d
WHERE  s.grade = '4';

-- using���� �̿��� eq join
-- JOIN ~ USING ���� �̿��� EQUI JOIN
-- USING���� ���� ��� Į���� ����
-- Į�� �̸��� ���� ��� ���̺��� ������ �̸����� ���ǵǾ� �־����
-- ��1) JOIN ~ USING ���� �̿��Ͽ� �й�, �̸�, �а���ȣ, �а��̸�, �а���ġ��
--       ����Ͽ���
SELECT s.studno, s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno);
-- EQUI JOIN�� 3���� ����� �̿��Ͽ� 
-- ���� ���衯���� �л����� �̸�, �а���ȣ,�а��̸��� ���

-- 1. ORACLE join ���
SELECT s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND  s.name like '��%'
;

-- natural join 
SELECT s.name, deptno, d.dname
FROM   student s NATURAL JOIN department d
WHERE  s.name like '��%'
;

-- join using
SELECT s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno)
WHERE  s.name like '��%'
;

-- 4> ansi join
-- WHERE�� ��� ON�� ����Ѵ�
-- ORACLE JOIN �� ANSI ������ ���� ���Ǳ� ������ �� �� �˾ƾ� �Ѵ�
SELECT s.name, d.deptno, d.dname
FROM   student s INNER JOIN department d
ON     s.deptno = d.deptno
WHERE  s.name like '��%'
;
-- NON-EQUI JOIN **
-- ��<��,BETWEEN a AND b �� ���� ��=�� ������ �ƴ� ������ ���
-- ���� ���̺�� �޿� ��� ���̺��� NON-EQUI JOIN�Ͽ� 
-- �������� �޿� ����� ����Ͽ���
CREATE TABLE "SCOTT"."SALGRADE2" 
   (	"GRADE" NUMBER(2,0), 
     	"LOSAL" NUMBER(5,0), 
    	"HISAL" NUMBER(5,0)
  );

SELECT p.profno, p.name, p.sal, s.grade
FROM   professor p, salgrade2 s
WHERE  p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN  ***
-- ������ ���������� �̰� ����ϴ� ������ ���Ἲ ������ �����ϱ� ���ؼ� ����ϴ� ���̴�.
-- EQUI JOIN���� ���� Į�� ������ �ϳ��� NULL ������ ���� ����� ����� �ʿ䰡 �ִ� ���
-- OUTER JOIN ���
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno;

-- �л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, ���������� �̸�, ������ ���
-- ��, ���������� �������� ���� �л��̸��� �Բ� ����Ͽ���
-- oracle left outer join
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
ORDER BY s.grade;

-- ansi left outer join
-- spring���� ����ϴ� converting 

SELECT s.name, s.grade, p.name, p.position
FROM student s 
       LEFT OUTER JOIN professor p
       ON  s.profno = p.profno
ORDER BY s.grade;

-- right outer join 
-- ����� ��ó�� �������� ����� �ٸ��� ���´ٴ� �� Ȯ���ϱ�
--�л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, �������� �̸�, ������ ���
-- ��, �����л��� �������� ���� ���� �̸��� �Բ� ����Ͽ���
-- oracle ����� right outer join 
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno
ORDER BY p.profno;

SELECT   s.name, s.grade, p.name, p.position
FROM     student s
        RIGHT OUTER JOIN professor p
        ON               s.profno = p.profno
ORDER BY p.profno;
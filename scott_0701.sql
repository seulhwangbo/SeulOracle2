-------------------------------------------------------------
------------            ��������(Constraint)  *** ------------
--  ����  : �������� ��Ȯ���� �ϰ����� ����
-- 1. ���̺� ������ ���Ἲ ���������� ���� ����
-- 2. ���̺� ���� ����, ������ ��ųʸ��� ����ǹǷ� ���� ���α׷����� �Էµ� 
--     ��� �����Ϳ� ���� �����ϰ� ����
-- 3. ���������� Ȱ��ȭ, ��Ȱ��ȭ �� �� �ִ� ���뼺
-------------------------------------------------------------

-------------------------------------------------------------
------------  ��������(Constraint)  ����      ***  ------------
-- 1 .NOT NULL  : ���� NULL�� ������ �� ����
-- 2. �⺻Ű(primary key) : UNIQUE +  NOT NULL + �ּҼ�  ���������� ������ ����
-- 3. ����Ű(foreign key) :  ���̺� ���� �ܷ� Ű ���踦 ���� ***
-- 4. CHECK : �ش� Į���� ���� ������ ������ ���� ������ ���� ����
-------------------------------------------------------------
-- 1.  ��������(Constraint) ���� ���� ����(subject) ���̺� �ν��Ͻ�

-- rdb�� �� RDB�ΰ� ? 
-- FX **** : foreign key, �ܷ�Ű ****
-- emp => model 
-- 1. Restrict : �ڽ� ���� ���� �ȵ�  (���� ���� ����)
--    1) ����   Emp Table����  REFERENCES DEPT (DEPTNO) 
--    2) ����   integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE dept
WHERE  deptno = 50; 
-- �ڽ��� �ֱ� ������ �θ� ��ü�� ������ �� ���� ����̴� : ���� �� �۾� ����

-- 2. ���� ����
-- 2. Cascading Delete : ���� ����
-- 1)���ӻ��� ���� : Emp Table���� REFERENCES DEPT (DEPTNO) ON DELETE CASCADE
DELETE dept
WHERE  deptno = 50; 

-- 3. �� ���� 
-- 3. SET NULL   
--    1) ���� NULL ���� : Emp Table���� REFERENCES DEPT (DEPTNO)  ON DELETE SET NULL
-- �θ� ��ü�� �ڽ� ��ü���� ���踦 ���� �� �����ϴ� ���
DELETE dept
WHERE  deptno = 50; 
-- *** rdb���� Ȯ���� �� �ִ� �κ�
-- rollback ��Ű�鼭 �ϱ�

CREATE TABLE subject(
    subno     NUMBER(5)    CONSTRAINT subject_no_pk PRIMARY KEY,
    subname   VARCHAR2(20) CONSTRAINT subject_name_nn not null,
    term      VARCHAR2(1)  constraint subject_term_ck check(term IN('1','2')),
    typeGubun VARCHAR2(1)
);

COMMENT ON COLUMN subject.subno   IS '������ȣ';
COMMENT ON COLUMN subject.subname IS '��������';
COMMENT ON COLUMN subject.term    IS '�б�';

INSERT INTO subject(subno, subname, term)
            VALUES  (10000, '��ǻ�Ͱ���', '1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10001, 'DB����','2','1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10002, 'JSP����','1','1');
            
--  PK Constraint : unique constraint (SCOTT.SUBJECT_NO_PK) violated           
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10001, 'Spring����', '1','1');

--  PK Constraint : cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNO"
INSERT INTO subject(subname, term, typegubun)
            VALUES  ('Spring����2', '1','1');
            
--  PK Constraint : cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME")
INSERT INTO subject(subno, term, typegubun)
            VALUES  (10003, '1','1');
            
--  PK Constraint : CHECK Constraint
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10003, 'Spirng����3', '5','1');
            
-- Table ����� ���Ѱ��� ���� ���� ����
-- Student Table �� idnum�� unique�� ����
-- �����Ѵٰ� �ؼ� �ȿ� �ִ� �����͸� �ٲ����� �ʱ� ������ �ߺ�Ű�� ������ Ȯ���ؾ� �Ѵ�
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);

INSERT INTO student(studno, name, idnum)
            VALUES(30101, '������', '8412141254969');

-- unique constraint (SCOTT.STUD_IDNUM_UK) violated
-- UNIQUE �����߱� ������ �ߺ��� �Ұ��ϴٴ� �� Ȯ���ϱ�
INSERT INTO student(studno, name, idnum)
            VALUES(30102, '������', '8412141254969');

INSERT INTO student(studno, name)
            VALUES(30102, '����÷' );
            
-- STUDENT TABLE�� name�� nn���� ����
ALTER TABLE student 
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);
        
INSERT INTO student(studno, idnum)
            Values(30103, '8012301036614')
;
 
-- WHERE�� ������ ���� �����ϰ� ��� ���� ������ Ȯ�� �����ϴ�
SELECT CONSTRAINT_name, CONSTRAINT_TYPE
FROM user_CONSTRAINTs
WHERE table_name IN('SUBJECT','STUDENT');

------------------------------------
-----      INDEX      *** ----------
--  �ε����� SQL ��ɹ��� ó�� �ӵ��� ���(*) ��Ű�� ���� Į���� ���� �����ϴ� ��ü
--  �ε����� ����Ʈ�� �̿��Ͽ� ���̺� ����� �����͸� ���� �׼����ϱ� ���� �������� ���
--  [1]�ε����� ����
--   1)���� �ε��� : ������ ���� ������ Į���� ���� �����ϴ� �ε����� ��� �ε��� Ű��
--                  ���̺��� �ϳ��� ��� ����
CREATE UNIQUE INDEX idx_dept_name
ON     department(dname);

INSERT INTO department VALUES(300, '�̰�����',10,'KKK');
-- ORA-00001: unique constraint (SCOTT.IDX_DEPT_NAME) violated
INSERT INTO department(deptno, dname, college, loc) VALUES(301, '�̰�����',10,'KKK2');

-- ����� �ε��� birthdate --> constraint X, ���ɿ��� ������ ��ģ��
-- 2> ����� �ε���
-- ��>�л� ���̺��� birthdate Į���� ����� �ε����� �����Ͽ���
CREATE INDEX idx_stud_birthdate
ON     student(birthdate);

INSERT INTO student ( studno, name, idnum , birthdate)
            Values  ( 30102, '������', '8012301036614', '84/09/16');

SELECT * 
FROM   Student
WHERE  birthdate = '84/09/16'
;
-- �ε��� �ɷ��� ã��

--   3)���� �ε��� :  �ϳ��� �÷��� �ϳ��� �����ϴ� ���� ���� �ε����̴�
--   4)���� �ε��� :  �� �� �̻��� Į���� �����Ͽ� �����ϴ� �ε���
--     ��) �л� ���̺��� deptno, grade Į���� ���� �ε����� ����
--          ���� �ε����� �̸��� idx_stud_dno_grade �� ����
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade); 

-- Optimizer
-- RGO, CBO
-- RBO ����
ALTER SESSION SET OPTIMIZER_MODE = RULE;
-- rule based optimizer == �ε����� ���� �ϴ� �Ҽ���
-- cost based optimizer == �ε����� �ִٰ� �ϴ��� row ������ �ڽ��� �˾Ƽ� ��
-- �˾Ƽ� full scan�� �� ���� �ִ�
-- ROW�� �۴��� ���� ������ INDEX ������ �ϰ� �ȴ� =RULE�� �ɾ��� ��
SELECT *
FROM  student
WHERE deptno = 101
AND   grade  = 2
--WHERE grade =2
--AND   deptno = 101
--;
;

SELECT *
FROM  student
WHERE grade =2
AND   deptno = 101
;

-- ���� �Ʒ��� options�� ���ϸ鼭 ���� Ʃ�׿� ���� ���� ��� ���� �߿��ϴ�
-- �ϳ��� ������� �ϳ��� ������ ������ �ʰ� ���� ���̴�
-- �� �ٲ� ��쿡�� �ε����� Ÿ�� sorting �� ������ �� �� �ٸ� �ε����� �� Ÿ�� ������
-- ������� sql�� ���� ������ ���� ���̰� ũ�� ����

ALTER SESSION SET optimizer_mode = rule
ALTER SESSION SET optimizer_mode = CHOOSE
ALTER SESSION SET optimizer_mode = first_rows
ALTER SESSION SET optimizer_mode = ALL_ROWS
-- �Ʒ� 3������ CBO / �� �ϳ��� RBO
-- �� ������ ���� ���� ȭ�鿡 ���� �ִ� ���� ALL_ROWS 
-- ���� ���� �� �ִ� ������ ������ �͵� �����ִ� ���� FIRST_ROWS: ������ ���� ������
-- ��� DB�� �⺻�� CBO�� �Ǿ��ִ�

-- SQL Optimizer
SELECT /*+first rows*/ ename FROM emp;
-- ��Ʈ��
-- �ε����� ��Ʈ���� �̿��ؼ� ������ ������ ã�´�
-- CBO�� ó���� �ϴ� ��ɹ�
SELECT /*+rule*/ ename FROM emp;
-- RBO�� ó���� �ϴ� ��ɹ�

-- optimizer mode Ȯ���ϴ� ���
SELECT NAME, VALUE, ISDEFAULT, ISMODIFIED, DESCRIPTION
FROM   V$SYSTEM_PARAMETER
WHERE  NAME LIKE '%optimizer_mode%'
;

-- [2]�ε����� ȿ������ ��� : ���� ���� ���̽��� �׸�
--   1) WHERE ���̳� ���� ���������� ���� ���Ǵ� Į��
--   2) ��ü �������߿��� 10~15%�̳��� �����͸� �˻��ϴ� ���
--   3) �� �� �̻��� Į���� WHERE���̳� ���� ���ǿ��� ���� ���Ǵ� ���
--   4) ���̺� ����� �������� ������ �幮 ���
--   5) ���� �� ���� ���� ���Ե� ���, ���� �������� ���� ���Ե� ���
--------------------------------------------------------------
-- �ε����� ����ϸ� SELECT�� ���������� INSERT, DELETE, UPDATE �� ������ ��������
-- �뷮�� �����͸� �Է��ϴ� ���� ������ ������ ���̴�
-- �׷��� ������ ������ �� ���� �ε����� ��� ���δ�
-- �ε��� -> ������ ���콺 -> ��� �Ұ��� �����ؼ� ��� ���̰� �������� �̿��Ѵ�
-- �Ϲ������δ� ��ĭ�� �ϱ� ������ TRADE-OFF �� �Ͼ�ٰ� �ص� 
-- SELECT�� ������ �� �߿�������
-- ���ɿ� ������ ��ģ�ٰ� �ϴ� ���� 
-- SELECT ==> �ε����� �Ǵٴ� ���� SELECT�� ������ ����Ų�ٴ� ���̴�

-- �ε����� ���� �� �ֱ� ������ �籸�� �ϴ� ������ �ʿ��ϴ�
-- �л� ���̺� ������ PK_DEPTNO �ε����� �籸��
ALTER INDEX PK_DEPTNO REBUILD;
-- ������� �����̺� 7���� �ε��� �̻��� ���� ���ƶ�

-- 1. INDEX ��ȸ
SELECT index_name, table_name, column_name
FROM   user_ind_columns;

-- 2. INDEX ���� EMP(JOB)
CREATE INDEX idx_emp_job ON emp(job);

-- 3. ��ȸ : OK�� NO�� � �� ���̰� �ִ��� Ȯ���ϱ�
ALTER session set optimizer_mode = rule;
SELECT * FROM emp WHERE job = 'MANAGER'; -- = Index OK
-- �� �ִ� ���� ��ҹ��ڸ� �����ϰ� ��ɾ ��ҹ��ڸ� �������� �ʴ´�
SELECT * FROM emp WHERE job <> 'MANAGER'; -- = ������ INDEX NO
-- �ε����� � ��쿡�� Ÿ��, � ��쿡�� �� Ÿ���� ������ �ʿ䰡 �ִ�

SELECT * FROM emp WHERE job LIKE'%NA%'; -- = LIKE '%NA%' INDEX NO 
SELECT * FROM emp WHERE job LIKE 'MA%'; -- = LIKE 'MA%'  INDEX OK
-- ó���� %�� ������ �ε����� �ɸ��� ������ ó������ ���� �ʰ� ó������ �ܾ ������ �ε����� ź��
-- �ε����� ������ ���� �̾߱⸦ �ؾ� �ؼ� Ʃ���ϰ� �Բ� ����

SELECT * FROM emp WHERE UPPER(job) = 'MANAGER'; -- = Index NO

-- INDEX�� �����ϰ� �ϴ� ���
--   5)�Լ� ��� �ε���(FBI) function based index
--      ����Ŭ 8i �������� �����ϴ� ���ο� ������ �ε����� Į���� ���� �����̳� �Լ��� ��� ����� 
--      �ε����� ���� ����
--      UPPER(column_name) �Ǵ� LOWER(column_name) Ű����� ���ǵ�
--      �Լ� ��� �ε����� ����ϸ� ��ҹ��� ���� ���� �˻�
CREATE INDEX uppercase_idx ON emp (UPPER(job));
--      �Լ��� �����ϰ� �� �Լ��� �ε����� �� �� �ִ�
SELECT * FROM emp WHERE UPPER(job) =  'SALESMAN';
--  ��ҹ��� ������ �Է½ÿ���  �߻��� ���� �ֱ� ������ Ȯ�� �ʿ�
--  UPPER JOB�� FBI�� �ε����� �ɷ��ְ�, �� ����׿��� EXECUTE�� �ϸ� .. ?
--  �Լ��� Ÿ�� FBI�� Ÿ�°�? ������ FBI�� ź��

---------------------------------------------------------------------------------
-- Ʈ����� ����  ***
-- ������ �����ͺ��̽����� ����Ǵ� ���� ���� SQL��ɹ��� �ϳ��� ���� �۾� ������ ó���ϴ� ����
-- COMMIT : Ʈ������� �������� ����
--               Ʈ����ǳ��� ��� SQL ��ɹ��� ���� ����� �۾� ������ ��ũ�� ���������� �����ϰ� 
--               Ʈ������� ����
--               �ش� Ʈ����ǿ� �Ҵ�� CPU, �޸� ���� �ڿ��� ����
--               ���� �ٸ� Ʈ������� �����ϴ� ����
--               COMMIT ��ɹ� �����ϱ� ���� �ϳ��� Ʈ����� ������ �����
--               �ٸ� Ʈ����ǿ��� ������ �� ������ �����Ͽ� �ϰ��� ����
 
-- ROLLBACK : Ʈ������� ��ü ���
--                   Ʈ����ǳ��� ��� SQL ��ɹ��� ���� ����� �۾� ������ ���� ����ϰ� Ʈ������� ����
--                   CPU,�޸� ���� �ش� Ʈ����ǿ� �Ҵ�� �ڿ��� ����, Ʈ������� ���� ����
---------------------------------------------------------------------------------

----------------------------------
-- SEQUENCE ***
-- ������ �ĺ���
-- �⺻ Ű ���� �ڵ����� �����ϱ� ���Ͽ� �Ϸù�ȣ ���� ��ü
-- ���� ���, �� �Խ��ǿ��� ���� ��ϵǴ� ������� ��ȣ�� �ϳ��� �Ҵ��Ͽ� �⺻Ű�� �����ϰ��� �Ҷ� 
-- �������� ���ϰ� �̿�
-- ���� ���̺��� ���� ����  -- > �Ϲ������δ� ������ ��� 
----------------------------------
-- 1) SEQUENCE ����
--CREATE SEQUENCE sequence
--[INCREMENT BY n]
--[START WITH n]
--[MAXVALUE n | NOMAXVALUE]
--[MINVALUE n | NOMINVALUE]
--[CYCLE | NOCYCLE]
--[CACHE n | NOCACHE];
--INCREMENT BY n : ������ ��ȣ�� ����ġ�� �⺻�� 1,  �Ϲ������� ?1 ���
--START WITH n : ������ ���۹�ȣ, �⺻���� 1
--MAXVALUE n : ���� ������ �������� �ִ밪
--MAXVALUE n : ������ ��ȣ�� ��ȯ������ ����ϴ� cycle�� ������ ���, MAXVALUE�� ������ �� ���� �����ϴ� ��������
--CYCLE | NOCYCLE : MAXVALUE �Ǵ� MINVALUE�� ������ �� �������� ��ȯ���� ������ ��ȣ�� ���� ���� ����
--CACHE n | NOCACHE : ������ ���� �ӵ� ������ ���� �޸𸮿� ĳ���ϴ� ������ ����, �⺻���� 20

-- 2) SEQUENCE sample ����
CREATE SEQUENCE sample_seq
INCREMENT BY 1
START WITH   10000;

-- SEQUENCE ������ ���� ��
-- �Ʒ��� �������� �� ������ �ϳ��� ������Ű�� �ȴ�
SELECT sample_seq.nextval FROM dual;
SELECT sample_seq.CURRVAL FROM dual;
-- current value
-- ������Ű�� ���� ������ �������� ���� �޶�� ���̴�

-- 3) SEQUENCE sample ���� 2 ==> �ǻ�� ����
CREATE SEQUENCE dept_dno_seq
INCREMENT BY 1
START WITH  76;

-- 4) SEQUENCE dept_dno_seq�� �̿� dept_second �Է� --> �� ��� ����
-- dept second
INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, 'Accounting','NEW YORK');
SELECT dept_dno_seq.CURRVAL FROM dual;

-- 77, 'ȸ��', '�̴�'
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, 'ȸ��','�̴�');
SELECT dept_dno_seq.CURRVAL FROM dual;

-- 78, '�λ���', '���'
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, '�λ���','���');
SELECT dept_dno_seq.CURRVAL FROM dual;


-- max ��ȯ
INSERT INTO dept_second
VALUES((SELECT MAX(DEPTNO)+1 FROM dept_second)
    , '�濵��'
    , '�븲'
    );
-- ��� ���� �ȵȴ� �׷��� UNIQUE CONSTRAINT VIOLATED  
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, '�λ���','���');

-- sequence ����
DROP SEQUENCE SAMPLE_SEQ;

-- DATA �������� ���� ��ȸ
SELECT sequence_name, min_value, max_value, increment_by
FROM   user_sequences;

-- hw

------------------------------------------------------
----               Table ����                     ----
------------------------------------------------------
-- 1.Table ����
CREATE TABLE address
( id    NUMBER(3),
  Name  VARCHAR2(50),
  addr  VARCHAR2(100),
  phone VARCHAR2(30),
  email VARCHAR2(100)
);

INSERT INTO ADDRESS
VALUES(1,'HGBONG','SEOUL','123-4567','gbhong@naver.com');
---    Homework
-- ��1) address��Ű��/Data �����ϸ�     addr_second Table ���� 
CREATE UNIQUE INDEX addr_second
ON address(id, name, addr, phone,email);

-- ��2) address��Ű�� �����ϸ�  Data ���� ���� �ʰ�   addr_seven Table ����
CREATE INDEX addr_seven
ON address(addr);

-- ��3) address(�ּҷ�) ���̺��� id, name Į���� �����Ͽ� addr_third ���̺��� �����Ͽ���
CREATE INDEX addr_third
ON address(id,name);
-- ��4) addr_second ���̺� �� addr_tmp�� �̸��� ���� �Ͻÿ�
ALTER index ADDR_SECOND RENAME TO addr_tmp
;
------------------------------------------------------------------
-----     ������ ����
-- 1. ����ڿ� �����ͺ��̽� �ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ �����ϴ� �ý��� ���̺��� ����
-- 2. ���� ������ ������ ����Ŭ ������ ����
-- 3. ����Ŭ ������ ����Ÿ���̽��� ����, ����, ����� ����, ������ ���� ���� ������ �ݿ��ϱ� ����
--    ������ ���� �� ����
-- 4. ����Ÿ���̽� �����ڳ� �Ϲ� ����ڴ� �б� ���� �信 ���� ������ ������ ������ ��ȸ�� ����
-- 5. �ǹ������� ���̺�, Į��, �� ��� ���� ������ ��ȸ�ϱ� ���� ���

------------------------------------------------------------------

------------------------------------------------------------------
-----     ������ ���� ���� ����
-- 1.�����ͺ��̽��� ������ ������ ��ü�� ���� ����
-- 2. ����Ŭ ����� �̸��� ��Ű�� ��ü �̸�
-- 3. ����ڿ��� �ο��� ���� ���Ѱ� ��
-- 4. ���Ἲ �������ǿ� ���� ����
-- 5. Į������ ������ �⺻��
-- 6. ��Ű�� ��ü�� �Ҵ�� ������ ũ��� ��� ���� ������ ũ�� ����
-- 7. ��ü ���� �� ���ſ� ���� ���� ����
-- 8.�����ͺ��̽� �̸�, ����, ������¥, ���۸��, �ν��Ͻ� �̸�

------------------------------------------------------------------
--       ������ ���� ����
-- 1. USER_ : ��ü�� �����ڸ� ���� ������ ������ ���� ��
-- user_tables�� ����ڰ� ������ ���̺� ���� ������ ��ȸ�� �� �ִ� ������ ���� ��.

SELECT table_name
FROM   user_tables;

SELECT *
FROM user_catalog;

-- 2. ALL_    : �ڱ� ���� �Ǵ� ������ �ο� ���� ��ü�� ���� ������ ������ ���� ��
SELECT owner, table_name
FROM all_tables;

-- 3. DBA_   : �����ͺ��̽� �����ڸ� ���� ������ ������ ���� ��
SELECT owner, table_name
FROM   dba_tables;S
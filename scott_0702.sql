-----------------------------------------------------------------------------------------
--   11. View 
------------------------------------------------------------------------------
-- View : 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
--   뷰는 데이터딕셔너리 테이블에 뷰에 대한 정의만 저장
--   장점 :   보안 
--   단점 :   Performance(성능)은 더 저하
--   시스템 카탈로그에 저장되어 있다가 원테이블을 조회하고 
--   그 이후에 VIEW로 넘어가니까 2단 조회
-->  당연히 그래서 늦어진다


-- view 생성
CREATE OR REPLACE VIEW VIEW_PROFESSOR AS
SELECT profno, name, userid, position, hiredate, deptno
FROM   professor 
;

-- 조회하는 순간 Professor가 받아서 전체적으로 실행
SELECT * FROM VIEW_PROFESSOR
;

-- 제약조건에 걸리지 않는다면 뷰를 통한 입력이 가능하다
-- 뷰는 제약조건을 다 따라야 한다 왜냐면 실제 입력할 때는 view에 입력하는 것이 아닌
-- 원테이블에 입력하는 것이기 때문이다
INSERT INTO view_professor VALUES(2000, 'VIEW','USERID','POSITION',SYSDATE, 101);

-- cannot insert NULL into ("SCOTT"."PROFESSOR"."NAME")
-- view가 아니라 실제 professor에 넣는다는 것
-- name 제약조건에 not null이 있는데 name을 입력하지 않아서 에러가 난다
INSERT INTO view_professor (profno, userid, position, hiredate, deptno)
                    VALUES (2001,'userid2','position2',sysdate,101);

-- 현장work01 --> VIEW 이름 v_emp_sample  : emp(empno , ename , job, mgr,deptno)                  
CREATE OR REPLACE VIEW v_emp_sample AS
SELECT empno, ename, job, mgr, deptno
FROM   emp
;

-- 제약 조건 없이 view를 통한 입력 확인하기
INSERT INTO v_emp_sample (empno, ename, job, mgr, deptno)
                    VALUES (2001,'userid2','position2',7839,10);
                 
-- 복합 view / 통계뷰
-- 현장 work 02
CREATE OR REPLACE VIEW v_emp_complex 
AS
SELECT *
FROM emp NATURAL JOIN dept
;

INSERT INTO v_emp_complex (empno, ename, deptno)
                    VALUES(1500,'홍길동',20);
--  "cannot modify more than one base table through a join view"
INSERT INTO v_emp_complex (empno, ename, deptno, dname, loc)
                    VALUES(1500,'홍길동',77, '공무팀','낙성대');
                    
CREATE OR REPLACE VIEW v_emp_complex3
AS
SELECT e.empno, e.ename, e.job, e.deptno, d.dname,d.loc
FROM emp E, dept D
WHERE E.DEPTNO = D.DEPTNO
;
-- join using oracle join anci join

--  Natural join 을 했을 때는 삽입이 안 되지만 일반 join은 insert ok
INSERT INTO v_emp_complex3 (empno, ename, deptno)
                    VALUES(1501,'홍길동1',20);
-- insert ok
INSERT INTO v_emp_complex3 (empno, ename)
                    VALUES(1502,'홍길동2');
--  "cannot modify more than one base table through a join view"
--  oracle join은 부분적으로 허용한다
INSERT INTO v_emp_complex3 (empno, ename, deptno, dname, loc)
                    VALUES(1503,'홍길동3',77, '공무팀','낙성대');

------------     View  HomeWork     ----------------------------------------------------

---문1)  학생 테이블에서 101번 학과 학생들의 학번, 이름, 학과 번호로 정의되는 단순 뷰를 생성
---     뷰 명 :  v_stud_dept101
CREATE OR REPLACE VIEW v_stud_dept101
AS SELECT STUDNO, NAME, DEPTNO
FROM STUDENT;
--문2) 학생 테이블과 부서 테이블을 조인하여 102번 학과 학생들의 학번, 이름, 학년, 학과 이름으로 정의되는 복합 뷰를 생성
--      뷰 명 :   v_stud_dept102
CREATE OR REPLACE VIEW v_stud_dept102 
AS
SELECT STUDNO, NAME, GRADE, DNAME
FROM STUDENT NATURAL JOIN DEPT
;
--문3)  교수 테이블에서 학과별 평균 급여와     총계로 정의되는 뷰를 생성
--  뷰 명 :  v_prof_avg_sal       Column 명 :   avg_sal      sum_sal
CREATE OR REPLACE VIEW v_prof_avg_sal
AS
SELECT AVG(sal) avg_sal, sum(sal) sum_sal
FROM professor;
-------------------------------------
---- 계층적 질의문
-------------------------------------
-- 1. 관계형 데이터 베이스 모델은 평면적인 2차원 테이블 구조
-- 2. 관계형 데이터 베이스에서 데이터간의 부모 관계를 표현할 수 있는 칼럼을 지정하여 
--    계층적인 관계를 표현
-- 3. 하나의 테이블에서 계층적인 구조를 표현하는 관계를 순환관계(recursive relationship)
-- 4. 계층적인 데이터를 저장한 칼럼으로부터 데이터를 검색하여 계층적으로 출력 기능 제공

-- 사용법
-- SELECT 명령문에서 START WITH와 CONNECT BY 절을 이용
-- 계층적 질의문에서는 계층적인 출력 형식과 시작 위치 제어
-- 출력 형식은  top-down 또는 bottom-up
-- 참고) CONNECT BY PRIOR 및 START WITH절은 ANSI SQL 표준이 아님

-- 문1) 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 단대,학부
-- 학과순으로 top-down 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 10번 부서
SELECT     deptno, dname, college
FROM       department
START WITH deptno = 10
CONNECT BY PRIOR deptno = college
;

-- 문2)계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 학과,학부
-- 단대 순으로 bottom-up 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 102번 부서이다
-- bottom - up : 아래에서 위로 올라가는 구조
SELECT     deptno,dname,college
FROM       department
START WITH DEPTNO = 102
CONNECT BY PRIOR college = deptno
;

-- --- 문3) 계층적 질의문을 사용하여 부서 테이블에서 부서 이름을 검색하여 단대, 학부, 학과순의
---         top-down 형식으로 출력하여라. 단, 시작 데이터는 ‘공과대학’이고,
---        각 LEVEL(레벨)별로 우측으로 2칸 이동하여 출력
SELECT  LPAD(' ',(LEVEL-1)*2)||dname 조직도 
FROM   department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college
;

------------------------------------------------------
---      TableSpace  
---  정의  :데이터베이스 오브젝트 내 실제 데이터를 저장하는 공간
--           이것은 데이터베이스의 물리적인 부분이며, 세그먼트로 관리되는 모든 DBMS에 대해 
--           저장소(세그먼트)를 할당
------------------------------------------------------

-- 1. TABLESPACE 생성
CREATE Tablespace user1 Datafile 'C:\BACKUP\tableSpace\user1.ora' SIZE 100M;
CREATE Tablespace user2 Datafile 'C:\BACKUP\tableSpace\user2.ora' SIZE 100M;
CREATE Tablespace user3 Datafile 'C:\BACKUP\tableSpace\user3.ora' SIZE 100M;
CREATE Tablespace user4 Datafile 'C:\BACKUP\tableSpace\user4.ora' SIZE 100M;

-- 2. 테이블의 테이블 스페이스 변경
-- 1) 테이블의 NDEX와 Table의  테이블 스페이스 조회
SELECT INDEX_NAME, TABLE_NAME, TABLESPACE_NAME
FROM USER_INDEXES;

ALTER INDEX PK_RELIGIONNO3 REBUILD TABLESPACE USER1;

-- 진짜 table명이 조회되는 명령어
SELECT TABLED_NAME, TABLESPACE_NAME
FROM   USER_Tables;

ALTER TABLE JOB3 MOVE TABLESPACE user2;

-- 3. 테이블 스페이스 size 변경
ALTER DATAbase Datafile 'C:\BACKUP\tableSpace\user4.ora' Resize 200M;

-- Oracle 전체 Backup  (scott)
EXPDP scott/tiger Directory = mdBackup2 DUMPFILE = scott.dmp;
-- 여기서 실행 x cmd로 넘어가서 실행해야 한다

-- ORCALE 전체 RESTORE (SCOTT)
IMPDP scott/tiger Directory = mdBackup2 DUMPFILE = scott.dmp;

-- Oracle 부분 Backup후  부분 Restore
exp scott/tiger file = ADDR_SECOND.DMP TABLES =ADDR_SECOND
exp scott/tiger file = address.dmp     TABLES =ADDRESS

imp scott/tiger file = ADDR_SECOND.DMP TABLES =ADDR_SECOND
imp scott/tiger file = address.dmp     TABLES =ADDRESS


----------------------------------------------------------------------------------------
-------                     Trigger 
--  1. 정의 : 어떤 사건이 발생했을 때 내부적으로 실행되도록 데이터베 이스에 저장된 프로시저
--              트리거가 실행되어야 할 이벤트 발생시 자동으로 실행되는 프로시저 
--              트리거링 사건(Triggering Event), 즉 오라클 DML 문인 INSERT, DELETE, UPDATE이 
--              실행되면 자동으로 실행
--  2. 오라클 트리거 사용 범위
--    1) 데이터베이스 테이블 생성하는 과정에서 참조 무결성과 데이터 무결성 등의 복잡한 제약 조건 생성하는 경우 
--    2) 데이터베이스 테이블의 데이터에 생기는 작업의 감시, 보완 
--    3) 데이터베이스 테이블에 생기는 변화에 따라 필요한 다른 프로그램을 실행하는 경우 
--    4) 불필요한 트랜잭션을 금지하기 위해 
--    5) 컬럼의 값을 자동으로 생성되도록 하는 경우 
-------------------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW --- OLD, NEW 사용하기 위해서
BEGIN
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값:' || :old.dname);
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값:' || :new.dname);
END;

UPDATE dept
SET    dname = '회계3팀'
WHERE  deptno = 72;

----------------------------------------------------------
--HW2 ) emp Table의 급여가 변화시
--       화면에 출력하는 Trigger 작성( emp_sal_change)
--       emp Table 수정전
--      조건 : 입력시는 empno가 0보다 커야함

--출력결과 예시
--     이전급여  : 10000
--     신  급여  : 15000
 --    급여 차액 :  5000
----------------------------------------------------------
CREATE OR REPLACE TRIGGER emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
    WHEN (NEW.EMPNO > 0 )--- OLD, NEW 사용하기 위해서
    DECLARE SAL_DIFF NUMBER;
BEGIN
-- SAL_DIFF := :new_sal - :old_sal;
    DBMS_OUTPUT.ENABLE;
    DBMS_OUTPUT.PUT_LINE('이전 급여:' || :old.sal);
    DBMS_OUTPUT.PUT_LINE('신   급여:' || :new.sal);
    DBMS_OUTPUT.PUT_LINE('급여 차액:' || :old.sal - :new.sal);
END;

UPDATE emp
SET    sal = 1000
WHERE  empno = 7369;

--------------------------------------------------------------------------------------------------
--  EMP 테이블에 INSERT,UPDATE,DELETE문장이 하루에 몇 건의 ROW가 발생되는지 조사
--  조사 내용은 EMP_ROW_AUDIT에 
--  ID ,사용자 이름, 작업 구분,작업 일자시간을 저장하는 
--  트리거를 작성
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
       VALUES(3000, '유지원', 3500, 51);

INSERT INTO emp(empno,ename, sal,deptno)
       VALUES(3100,'황정후' , 3500 , 51);
       
UPDATE emp
SET    ename = '황보슬'
WHERE  empno = 1502;

DELETE emp
WHERE  empno = 1501;
    
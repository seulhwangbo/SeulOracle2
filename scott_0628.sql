-----------------------------------------------------------------
----- SUB Query   ***
-- 하나의 SQL 명령문의 결과를 다른 SQL 명령문에 전달하기 위해 
-- 두 개 이상의 SQL 명령문을 하나의 SQL명령문으로 연결하여
-- 처리하는 방법
-- 종류 
-- 1) 단일행 서브쿼리
-- 2) 다중행 서브쿼리
-------------------------------------------------------------------
--  1. 목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색
-- 1-1 교수 테이블에서 ‘전은지’ 교수의 직급 검색 SQL 명령문 실행
-- 9907	전은지 totoro 전임강사	210	19/01/21  101
SELECT  position
FROM    professor
WHERE   name = '전은지'
;
-- 1-2 교수 테이블의 직급 칼럼에서 1 에서 
-- 얻은 결과 값과 동일한 직급을 가진 교수 검색 명령문 실행
SELECT  name, position
FROM    professor
WHERE   position = '전임강사'
;

-- 1.목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색
-- > SUB Query
SELECT  name, position
FROM    professor
WHERE   position = (
                    SELECT  position
                    FROM    professor
                    WHERE   name = '전은지'
        )
;

-- 종류 
-- 1) 단일행 서브쿼리
--  서브쿼리에서 단 하나의 행만을 검색하여 메인쿼리에 반환하는 질의문
--  메인쿼리의 WHERE 절에서 서브쿼리의 결과와 비교할 경우에는 반드시 단일행 비교 연산자 중 
--  하나만 사용해야함

--  문1) 사용자 아이디가 ‘jun123’인 학생과 같은 학년인 학생의 학번, 이름, 학년을 출력하여라
SELECT studno, name, grade
FROM   student
WHERE  grade    = (
                SELECT grade
                FROM   student 
                WHERE  userid = 'jun123'
                )
;

--  문2)  101번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생의 이름, 학년 , 학과번호, 몸무게를  출력
--  조건 : 학과별 올림차순 출력
SELECT name, grade, deptno, weight
FROM   student
WHERE  weight < ( 
                SELECT AVG(weight)
                FROM   student
                WHERE  deptno = 101
)
ORDER BY deptno
;

--  문3) 20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생의 
-- 이름, 학년, 키, 학과명을 출력하여라
--  조건 : 학과별 내림차순 출력
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

-- 2) 다중행 서브쿼리
-- 서브쿼리에서 반환되는 결과 행이 하나 이상일 때 사용하는 서브쿼리
-- 메인쿼리의 WHERE 절에서 서브쿼리의 결과와 비교할 경우에는 다중 행 비교 연산자 를 사용하여 비교
-- 다중 행 비교 연산자 : IN, ANY, SOME, ALL, EXISTS
-- 1) IN         : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 하나라도 일치하면 참, ‘=‘비교만 가능
-- 2) ANY, SOME  : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 하나라도 일치하면 참
-- 3) ALL        : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 모든값이 일치하면 참, 
-- 4) EXISTS     : 메인 쿼리의 비교 조건이 서브쿼리의 결과중에서 만족하는 값이 하나라도 존재하면 참

-- 일부러 오류를 낸 구문이다
-- single-row subquery returns more than one row
SELECT name,grade,deptno
FROM   student
WHERE  deptno = (
                    SELECT deptno
                    FROM   department
                    WHERE  college = 100
                )
;


-- 1.  IN 연산자를 이용한 다중 행 서브쿼리
-- 멀티 row에 해당하는 다중행 서브쿼리를 넣어야 in이 실행이 된다
SELECT name,grade,deptno
FROM   student
WHERE  deptno IN (
                    SELECT deptno
                    FROM   department
                    WHERE  college = 100
                )
;

-- 위의 것과 똑같은 결과를 낸다
SELECT name,grade,deptno
FROM   student
WHERE  deptno IN (
              101,102
                )
;

--  2. ANY(OR) 연산자를 이용한 다중 행 서브쿼리
-- 문)모든 학생 중에서 4학년 학생 중에서 키가 제일 작은 학생보다 키가 큰 학생의 학번, 이름, 키를 출력하여라
SELECT  studno, name, height  
FROM    student
WHERE   height> ANY(
                    SELECT height
                    FROM   student
                    WHERE  grade = '4'
)
ORDER BY studno
; 

--- 3. ALL (AND) 연산자를 이용한 다중 행 서브쿼리
SELECT  studno, name, height  
FROM    student
WHERE   height> ALL(
                    SELECT height
                    FROM   student
                    WHERE  grade = '4'
)
ORDER BY studno
; 

--- 4. EXISTS 연산자를 이용한 다중 행 서브쿼리
SELECT profno, name, sal, comm, position
FROM   professor
WHERE EXISTS (
                -- 존재하는 게 하나라도 있으면
                -- 존재하는 게 1 ROW라도 있다면
                -- 다 알려줘라
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

-- 문1)  보직수당을 받는 교수가 한 명이라도 있으면 
--       모든 교수의 교수 번호, 이름, 보직수당 그리고 급여와 보직수당의 합(NULL처리)을 출력
SELECT profno, name, comm, (NVL(sal,0) + sal) sal_comm
FROM   professor
WHERE  EXISTS (
            SELECT profno
            FROM   professor
            WHERE  comm is not null
)
;

-- 문2) 학생 중에서 ‘goodstudent’이라는 사용자 아이디가 없으면 1을 출력하여라
SELECT 1 userid_exist
FROM   dual
WHERE  NOT EXISTS ( 
                    SELECT userid
                    FROM   student
                    WHERE  userid = 'goodstudent'
                    )
;

-- 다중 컬럼 서브쿼리
-- 서브쿼리에서 여러 개의 칼럼 값을 검색하여 메인쿼리의 조건절과 비교하는 서브쿼리
-- 메인쿼리의 조건절에서도 서브쿼리의 칼럼 수만큼 지정
-- 종류
-- 1) PAIRWISE : 칼럼을 쌍으로 묶어서 동시에 비교하는 방식
-- 2) UNPAIRWISE : 칼럼별로 나누어서 비교한 후, AND 연산을 하는 방식

-- 1) PAIRWISE 다중 칼럼 서브쿼리
-- 문1)    PAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 
--          학생의 이름, 학년, 몸무게를 출력하여라
SELECT name,grade,weight
FROM   student
WHERE  (grade, weight) IN (SELECT grade, MIN(weight)
                           FROM   student
                           GROUP BY grade
                           )
;

-- 2) UNPAIRWISE : 칼럼별로 나누어서 비교한 후, AND 연산을 하는 방식
-- UNPAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 학생의 이름, 학년, 몸무게를 출력
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

-- 상호연관 서브쿼리     ***
-- 메인쿼리절과 서브쿼리간에 검색 결과를 교환하는 서브쿼리
-- 내부적으로 하나하나 실행할 수는 없기 때문에 확인하는 방법이 이해하는 것 뿐이다.
-- 문1)  각 학과 학생의 평균 키보다 키가 큰 학생의 이름, 학과 번호, 키를 출력하여라
--                실행순서 1
----              실행순서 3
SELECT deptno, name, grade, height
FROM   student s1
WHERE  height >(SELECT AVG(height)
                FROM   student s2
                WHERE  s2.deptno = s1.deptno
                -- WHERE s2.deptno = 101 실행 순서 2
                )
ORDER BY deptno
;
-- 결과가 어디로 통하는지 어디로 가는지에 대해서 알아야 한다.
-- 같은 개념은 아니지만 내부적으로는 향상형 FOR문을 돈다고 생각하면 이해가 용이해진다
-- 101의 평균키보다 큰 애들, 102의 평균키보다 큰애들, 201의 평균키보다 큰애들
-- 이런 식으로 돌아가면서 결과가 도출된다
-------------  HW  -----------------------
-- 1. Blake와 같은 부서에 있는 모든 사원에 대해서 사원 이름과 입사일을 디스플레이하라
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

-- 2. 평균 급여 이상을 받는 모든 사원에 대해서 사원 번호와 이름을 디스플레이하는 질의문을 생성. 
--    단 출력은 급여 내림차순 정렬하라

SELECT EMPNO, ENAME, SAL
FROM   EMP 
WHERE  sal > (
            SELECT AVG(SAL)
            FROM EMP
);
-- 3. 보너스를 받는 어떤 사원의 부서 번호와 
--    급여에 일치하는 사원의 이름, 부서 번호 그리고 급여를 디스플레이하라.
SELECT ENAME, DEPTNO, SAL
FROM   EMP 
WHERE  (sal,deptno) in (
                        select sal,deptno
                        from    emp
                        WHERE   comm is not null
);
----------------------------------------------------------------------
--  데이터 조작어 (DML:Data Manpulation Language)  **                  ----------
-- 1.정의 : 테이블에 새로운 데이터를 입력하거나 기존 데이터를 수정 또는 삭제하기 위한 명령어
-- 2. 종류 
--  1) INSERT : 새로운 데이터 입력 명령어
--  2) UPDATE : 기존 데이터 수정 명령어
--  3) DELETE : 기존 데이터 삭제 명령어
--  4) MERGE : 두개의 테이블을 하나의 테이블로 병합하는 명령어

-- 1) Insert
-- "not enough values"
INSERT INTO DEPT VALUES(73,'인사');
-- 실행문은 아래
INSERT INTO DEPT VALUES(73,'인사', '이대');
INSERT INTO DEPT (deptno, Dname, LOC) VALUES(74,'회계팀','충정로');
INSERT INTO DEPT (deptno, LOC, DNAME) VALUES(76,'신대방','자재팀');
INSERT INTO DEPT (deptno, LOC) VALUES(77,'홍대');
-- 따로 삽입하지 않은 VALUES는 null 값으로 알아서 들어가게 된다
-- 1번처럼 하면 모든 것을 다 넣어야 하지만 
-- 위처럼 하게 되면 모든 값을 넣을 필요가 없이 원하는 값만 넣을 수 있다

-- INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
--                 VALUES(9910,'백미선','전임강사','sysdate',101);
-- INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
--                 VALUES(9920,'최윤식','조교수',TO_DATE('2006/01/01','YYYY/MM/DD','102');

INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
                VALUES(9910,'백미선','전임강사','24/06/28','101');
INSERT INTO PROFESSOR (PROFNO,NAME, POSITION, HIREDATE,DEPTNO) 
                VALUES(9920,'최윤식','조교수','06/01/01','102');
    
DROP TABLE JOB3;
CREATE TABLE JOB3
(   jobno         NUMBER(2)      PRIMARY KEY,
	jobname       VARCHAR2(20)
) ;

INSERT INTO job3                  VALUES (10, '학교');
INSERT INTO job3 (jobno, jobname) VALUES (11, '공무원');
INSERT INTO job3 (jobname, jobno) VALUES ('공기업', 12);
INSERT INTO job3 (jobno, jobname) VALUES (13, '대기업');
INSERT INTO job3 (jobno, jobname) VALUES (14, '중소기업');

CREATE TABLE Religion   
(    religion_no         NUMBER(2)     CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
	 religion_name     VARCHAR2(20)
) ;

INSERT INTO Religion                                VALUES(10,'기독교');
INSERT INTO Religion                                VALUES(20,'카톨릭교');
INSERT INTO Religion (religion_no, religion_name)   VALUES(30,'불교');
INSERT INTO Religion (religion_name, religion_no)   VALUES('무교',40);

--------------------------------------------------
-----   다중 행 입력                         ------
--------------------------------------------------
-- 1. 생성된 TBL이용 신규 TBL 생성
CREATE Table dept_second
AS SELECT * FROM dept
;

-- TBL 가공 생성
CREATE Table emp20
AS SELECT empno, ename, sal*12 annsal
   FROM   emp
   WHERE  deptno = 20
;

-- TBL 구조만
-- 테이블 날리기
CREATE Table dept30
AS SELECT  deptno, dname
   FROM    dept
   WHERE   0=1;
   
-- Column 추가
ALTER TABLE dept30
ADD(birth DATE);

INSERT INTO dept30 VALUES(10,'중앙학교',sysdate);

-- 5.column 변경
-- "cannot decrease column length because some value is too big"
ALTER TABLE dept30
MODIFY dname varchar2(11)
;
ALTER TABLE dept30
MODIFY dname varchar2(30)
;
--우리가 삽입한 것이 12 byte라서 11 byte로 줄일 수 없다

-- 6. Column 삭제
ALTER TABLE dept30
DROP Column dname
;

-- 7. TBL 변경
RENAME dept30 TO dept35;

--8. TBL 제거
DROP TABLE DEPT35;

--9. Truncate
TRUNCATE table dept_second;

-- Inset all
-- INSERT ALL(unconditional INSERT ALL) 명령문
-- 서브쿼리의 결과 집합을 조건없이 여러 테이블에 동시에 입력
-- 서브쿼리의 컬럼 이름과 데이터가 입력되는 테이블의 칼럼이 반드시 동일해야 함
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
-- [WHEN 조건절1 THEN
-- INTO [table1] VLAUES[(column1, column2,…)]
-- [WHEN 조건절2 THEN
-- INTO [table2] VLAUES[(column1, column2,…)]
-- [ELSE
-- INTO [table3] VLAUES[(column1, column2,…)]
-- subquery;
-- when 조건으로 걸어서 확인하기

-- 학생 테이블에서 2학년 이상의 학생을 검색하여 
-- height_info 테이블에는 키가 170보다 큰 학생의 학번, 이름, 키를 입력
-- weight_info 테이블에는 몸무게가 70보다 큰 학생의 학번, 이름, 몸무게를 
-- 각각 입력하여라
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

-- 데이터 수정 개요
-- UPDATE 명령문은 테이블에 저장된 데이터 수정을 위한 조작어
-- WHERE 절을 생략하면 테이블의 모든 행을 수정
--- Update 
-- 문1) 교수 번호가 9903인 교수의 현재 직급을 ‘부교수’로 수정하여라
UPDATE professor
SET    position = '부교수',userid = 'kkk'
WHERE  profno   = 9903;

--  문2) 서브쿼리를 이용하여 학번이 10201인 학생의 학년과 학과 번호를
--        10103 학번 학생의 학년과 학과 번호와 동일하게 수정하여라
-- pair 
UPDATE student
SET    (grade,deptno)  = (
                SELECT grade,deptno 
                FROM   student
                WHERE  studno = 10103
                )
WHERE  STUDNO = 10201;

-- 데이터 삭제 개요
-- DELETE 명령문은 테이블에 저장된 데이터 삭제를 위한 조작어
-- WHERE 절을 생략하면 테이블의 모든 행 삭제
-- WHERE 절 삭제하지 않도록 주의하기

-- 문1) 학생 테이블에서 학번이 20103인 학생의 데이터를 삭제
DELETE
FROM   student
WHERE  studno  = 20103;
--  문2) 학생 테이블에서 컴퓨터공학과에 소속된 학생을 모두 삭제하여라. HomeWork --> Rollback
DELETE 
FROM student 
WHERE deptno=(
            SELECT deptno
            FROM   department
            WHERE  Dname = '컴퓨터공학과'
            )
;

ROLLBACK;

-- COMMIT 안 하고 ROLLBACK을 통해 그 전 데이터를 살리기

----------------------------------------------------------------------------------
---- MERGE
--  1. MERGE 개요
--     구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
--     WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해 새로운 값으로 수정,
--     그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입
------------------------------------------------------------------------------------
--- DML이다 ---

-- 1] MERGE 예비작업 
--  상황 
-- 1) 교수가 명예교수로 2행 Update
-- 2) 김도경 씨가 신규 Insert

Create TABLE  professor_temp
as     SELECT * FROM professor
       WHERE  position = '교수';
UPDATE professor_temp
SET    position = '명예교수'
WHERE  position = '교수';

INSERT INTO professor_temp
VALUES(9999,'김도경','arom21','전임강사',200,sysdate, 10, 101);

commit;

-- 2] professor MERGE 수행 
-- 목표 : professor_temp에 있는 직위   수정된 내용을 professor Table에 Update
--                         김도경 씨가 신규 Insert 내용을 professor Table에 Insert
-- 1) 교수가 명예교수로 2행 Update
-- 2) 김도경 씨가 신규 Insert
-- professor table에 update

MERGE INTO professor p
USING professor_temp f
ON    (p.profno = f.profno)
WHEN MATCHED then --PK가 같으면 직위를 UPDATE
    update set p.position = f.position
WHEN NOT MATCHED then -- PK가 없으면 신규 INSERT
    insert values(f.profno, f.name, f.userid, f.position, f.sal, f.hiredate, f.comm, f.deptno);
    
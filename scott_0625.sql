SELECT * FROM tab;
-- 테이블 내용 정렬
DESC dept;
-- 내용을 묘사해줘라
SELECT DEPTNO , LOC FROM DEPT;
SELECT DNAME, DEPTNO FROM DEPT;
-- 부서 테이블에서 DNAME과 DEPTNO를 출력시켜라
-- 부서 테이블에서 DEPTNO와 LOC을 출력시켜라
--학생 테이블에서 중복되는 학과 번호(deptno)를 제외하고 출력하여라
SELECT distinct deptno FROM student;

--?별명 부여 방법
--?칼럼 이름과 별명 사이에 공백을 추가하는 방법
--?칼럼 이름과 별명 사이에 AS 키워드를 추가하는 방법
--?큰따옴표를 사용하는 방법
--?칼럼 이름과 별명 사이에 공백을 추가하는 경우
--?특수문자를 추가하거나 대소문자를 구분하는 경우

-- EX> 부서 테이블에서 부서 이름 칼럼의 별명은 dept_name, 
--     부서 번호 칼럼의 별명은 DN으로 부여하여 출력하여라

SELECT dname dept_name, deptno AS dn 
FROM department; 

--?합성(concatenation)연산자 (||)
--?하나의 칼럼과 다른 칼럼, 산술 표현식
-- 또는 상수 값과 연결하여 하나의 칼럼처럼 출력할 경우에 사용

--?학생 테이블에서 학번과 이름 칼럼을 연결하여 
--“StudentAli”라는 별명으로 하나의 칼럼처럼 연결하여 출력하여라

SELECT studno|| ' ' || name "StudentAli"
FROM student;

SELECT name, weight, weight * 2.2 as weight_pound 
FROM student
ORDER BY NAME;

-- DDL 문장 < 테이블 만드는 문장 >
-- CHAR와 VARCHAR2의 예시 문장
CREATE TABLE ex_type 
(c    CHAR(10), 
 v  VARCHAR2(10)
 ); 
 -- 둘 다 3 byte를 집어넣었다.
 -- DML 언어
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
 --?학생 테이블에서 1학년 학생만 검색하여 학번, 이름, 학과 번호를 출력하여라
 SELECT name,deptno,studno 
 FROM Student 
 WHERE grade = '1'
 ORDER BY name;
 
--?학생 테이블에서 몸무게가 70kg 이하인 학생만 검색하여 학번, 이름, 학년, 학과번호, 몸무게를 출력하여라.
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
-- BETWEEN 연산자를 사용하여 몸무게가 50kg에서 70kg 사이인 학생의 학번, 이름, 몸무게를 출력하여라
SELECT name, studno, weight
FROM Student
WHERE weight 
between 50 and 70
;
--학생테이블에서 81년에서 83년도에 태어난 학생의 이름과 생년월일을 출력해라
SELECT name, birthdate
FROM Student
WHERE birthdate
between '81/01/01' and '83/12/31'
-- between to_date('810101') AND to_date('831231')
;
-- IN 연산자를 사용하여 102번 학과와 201번 학과 학생의 이름, 학년, 학과번호를 출력하여라
SELECT name, grade, deptno
FROM Student
WHERE DEPTNO IN (102, 201)
-- WHERE DEPTNO = 102
-- OR DEPTNO = 201
;
-- 학생 테이블에서 성이 ‘김’씨인 학생의 이름, 학년, 학과 번호를 출력하여라
SELECT name, grade, deptno
FROM Student
Where name LIKE '김%'
;
-- 이름 중 진: 가운데가 진
SELECT name, grade, deptno
FROM Student
Where name LIKE '%진%'
;
-- 이름 중 마지막이 진
SELECT name, grade, deptno
FROM Student
Where name LIKE '%진'
;

-- 학생 테이블에서 이름이 3글자, 성은 ‘김’씨고 마지막 글자가
-- ‘영’으로 끝나는 학생의 이름, 학년, 학과 번호를 출력하여라

SELECT name, grade, deptno
FROM Student
Where name LIKE '김%영' 
;

SELECT name, grade, deptno
FROM Student
Where name LIKE '김_영' 
;

-- null 미확인 값이나 아직 적용되지 않은 값을 의미한다
-- emp의 comm에 확인하기 null값이 있는 부분이 있다.

SELECT empno, sal, comm 
FROM emp;

SELECT empno, sal, comm, sal + comm
FROM emp;

SELECT empno, sal, comm, sal + NVL(comm, 0)
FROM emp;

-- ?교수 테이블에서 이름, 직급, 보직수당을 출력하여
SELECT name, position, comm 
From Professor
;

-- 교수 테이블에서 보직수당이 없는 교수의 이름, 직급, 보직수당을 출력하여라
SELECT  name, position, comm
FROM professor
WHERE comm IS null
-- where comm = null 이렇게 하면 안 된다
;

--교수 테이블에서 급여에 보직수당을 더한 값은 sal_com이라는 별명으로 출력하여라
SELECT name, position, sal , comm , sal +  comm sal_com
FROM professor
;
-- COM이 NULL이면 0로 취급

SELECT name, position, sal , comm , sal + NVL(comm,0) sal_com
FROM professor
;

--102번 학과의 학생 중에서 1학년 또는 4학년 학생의 이름, 학년, 학과 번호를 출력하여라
SELECT name, grade, deptno 
FROM student 
WHERE deptno = 102
AND (grade = 1 OR grade =  4)
;

-- 집합 연산자
-- 
-- -- 1학년 이면서 몸무게가 70kg 이상인 학생의 집합 --> Table  stud_heavy
-- select의 결과를 table로 만든다.
CREATE table stud_heavy 
AS
SELECT * 
FROM student
where weight >= 70
and grade = ' 1' 
;
-- 1학년 이면서 101번 학과에 소속된 학생(stud_101)
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
-- Union  중복 제거   (박동진 , 서재진) + (박미경 , 서재진)
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

-- INTERSECT = 공통
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
--정렬(sorting)
--?SQL 명령문에서 검색된 결과는 테이블에 데이터가 입력된 순서대로 출력
--?하지만, 데이터의 출력 순서를 특정 컬럼을 기준으로 오름차순 또는 내림차순으로 정렬하는 경우가 자주 발생
--?여러 개의 칼럼에 대해 정렬 순서를 정하는 경우도 발생
--?ORDER BY : 칼럼이나 표현식을 기준으로 출력 결과를 정렬할 때 사용
--?ASC : 오른차순으로 정렬, 기본 값
--?DESC : 내림차순으로 정렬하는 경우에 사용, 생략 불가능

--학생 테이블에서 이름을 가나다순으로 정렬하여 이름, 학년, 전화번호를 출력하여라
SELECT name, grade, tel 
FROM student
-- ORDER BY NAME 
-- ORDER BY name ASC
ORDER BY name desc
;

-- 학생 테이블에서 학년을 내림차순으로 정렬하여 이름, 학년, 전화번호를 출력하여라
SELECT name, grade, tel
FROM   student
ORDER BY grade desc
;

-- §모든 사원의 이름과 급여 및 부서번호를 출력하는데, 
-- 부서 번호로 결과를 정렬한 다음 급여에 대해서는 내림차순으로 정렬하라.
SELECT ENAME,JOB, SAL, DEPTNO 
FROM EMP
order by deptno, sal DESC;

-- 1. 부서 10과 30에 속하는 모든 사원의 이름과 부서번호를 이름의 
-- 알파벳 순으로 정렬되도록 질의문을 형성하라

SELECT ENAME, DEPTNO 
FROM EMP
ORDER BY ENAME ASC
;

---- 문2) 1982년에 입사한 모든 사원의 이름과 입사일을 구하는 질의문

SELECT ename, hiredate
FROM EMP
WHERE HIREDATE 
BETWEEN '1982/01/01' AND '1982/12/31'
;

-- 3. §보너스를 받는 모든 사원에 대해서 이름, 급여 그리고 보너스를 출력하는 
-- 질의문을 형성하라. 
-- 단 급여와 보너스에 대해서 내림차순 정렬

SELECT ENAME, SAL, COMM
FROM EMP
WHERE COMM IS NOT NULL
ORDER BY SAL, COMM DESC
;

-- 문4) 보너스가 급여의 20% 이상이고 부서번호가 30인 모든 사원에 대해서
--       이름, 급여 그리고 보너스를 출력하는 질의문을 형성하라

SELECT ENAME, SAL, COMM
FROM EMP 
WHERE DEPTNO = '30'
AND COMM >= SAL / 20
;

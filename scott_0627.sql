---------------------------------------------------------
---   ** 8장. 그룹함수 
----  테이블의 전체 행을 하나 이상의 컬럼을 기준으로 그룹화하여
---   그룹별로 결과를 출력하는 함수
--    그룹함수는 통계적인 결과를 출력하는데 자주 사용
-----------------------------------------------------------
-- SELECT  column, group_function(column)
-- FROM  table
-- [WHERE  condition]
-- [GROUP BY  group_by_expression]
-- [HAVING  group_condition]
-- GROUP BY : 전체 행을 group_by_expression을 기준으로 그룹화
-- HAVING : GROUP BY 절에 의해 생성된 그룹별로 조건 부여
-- GROUP BY 함수를 쓸 때는 HAVING절을 이용해서 조건을 부여한다는 것이 중요하다 
-- WHERE 와 헷갈리지 않게 하기

--  종류           의미
--  COUNT         행의 개수 출력
--  MAX           NULL을 제외한 모든 행에서 최대 값
--  MIN           NULL을 제외한 모든 행에서 최소 값
--  SUM           NULL을 제외한 모든 행의 합
--  AVG           NULL을 제외한 모든 행의 평균 값
------------- 위 필수 아래는 구글링 --------------------
--  STDDEV        NULL을 제외한 모든 행의 표준편차
--  VARIANCE      NULL을 제외한 모든 행의 분산 값
--  GROUPING      해당 칼럼이 그룹에 사용되었는지 여부를 1 또는 0으로 반환
--  GROUPING SETS 한 번의 질의로 여러 개의 그룹화 기능


-- 1) COUNT 함수
-- 테이블에서 조건을 만족하는 행의 갯수를 반환하는 함수
-- 문1) 101번 학과 교수중에서 보직수당을 받는 교수의 수를 출력하여라
SELECT COUNT(*), COUNT(comm)
FROM  professor
WHERE deptno = 101
;

--102번 학과 학생들의 몸무게 평균과 합계를 출력하여라
SELECT AVG(weight), SUM(weight)
FROM student
WHERE deptno = 102
;

-- 교수 테이블에서 급여의 표준편차와 분산을 출력
SELECT STDDEV(sal), VARIANCE(sal) 
FROM professor
;

-- 학과별  학생들의 인원수, 몸무게 평균과 합계를 출력하여라
SELECT      deptno, COUNT(*), AVG(weight), SUM(weight) 
FROM        student
GROUP BY    deptno
;

-- null값이 자동으로 count에서 제거된다
-- 교수 테이블에서 학과 별로 교수의 수와 보직수당을 받는 교수 수를 출력하라
SELECT deptno, COUNT(*) professor, COUNT(COMM) commm
FROM PROFESSOR
GROUP BY deptno
;

-- 교수 테이블에서 학과별로 교수 수와 보직수당을 받는 교수 수를 출력하여라
-- 단 학과별로 교수 수가 2명 이상인 학과만 출력
-- Group by의 조건절은 having으로 걸어주고 무조건 group by 뒤에 해야 한다
-- where과 같은 역할을 하지만 where은 일반 함수에 사용하는 것
SELECT deptno, COUNT(*), COUNT(comm)
FROM professor
GROUP BY deptno
having COUNT(*)>1
;
-- 학생 수가 4명이상이고 평균키가 168이상인  학년에 대해서 
-- 학년, 학생 수, 평균 키, 평균 몸무게를 출력
-- 단, 평균 키와 평균 몸무게는 소수점 두 번째 자리에서 반올림 하고, 
-- 출력순서는 평균 키가 높은 순부터 내림차순으로 출력하고 
--   그 안에서 평균 몸무게가 높은 순부터 내림차순으로 출력
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

--  최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT max(hiredate), min(hiredate)
FROM emp
;

--  부서별 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT deptno, min(hiredate), max(hiredate)
FROM emp
GROUP BY deptno
ORDER BY DEPTNO
;

-- 부서별 직업별 count sum
SELECT deptno,job, COUNT(*), SUM(sal)
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job
;

-- 부서별 급여총액 3000이상 부서번호,부서별 급여최대    (emp)
SELECT deptno, MAX(sal)
FROM emp
GROUP BY deptno
HAVING sum(sal) >= 3000
ORDER BY deptno
;

--전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 
--   학과와 학년별 인원수, 평균 몸무게를 출력, 
-- (단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 )  STUDENT
SELECT deptno, grade, COUNT(*), ROUND(AVG(weight))
FROM student
GROUP BY deptno, grade
ORDER BY deptno, grade
;
-- ROLLUP 연산자
-- GROUP BY 절의 그룹 조건에 따라 전체 행을 그룹화하고 각 그룹에 대해 부분합을 구하는 연산자
-- 문) 소속 학과별로 교수 급여 합계와 모든 학과 교수들의 급여 합계를 출력하여라
SELECT deptno, SUM(sal)
FROM professor
GROUP BY ROLLUP(deptno)
;
--ex) ROLLUP 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수를 출력하여라
SELECT deptno, position, COUNT(*)
FROM professor
GROUP BY ROLLUP(deptno, position)
;
-- CUBE 연산자
-- ROLLUP에 의한 그룹 결과와 GROUP BY 절에 기술된 조건에 따라 그룹 조합을 만드는 연산자
--ex)CUBE 연산자를 이용하여 학과 및 직급별 교수 수, 학과별 교수 수, 전체 교수 수를 출력하여라.
SELECT deptno, position, COUNT(*)
FROM professor
GROUP BY CUBE(deptno, position)
;
-------------------------------------------------------------------------
------------DeadLock    ---------
-- 상호 요청, 점유 * 대기 상태, 비선점 -> 내가 내 마음대로 선점을 할 수 없는 상태이다
-- deadlock의 상태가 아닌 것은 ? 이라고 기사 시험에 나올 수 있다. 
-------------------------------------------------------------------------
--Transaction A
--1) Smith
UPDATE emp --자원 1
SET    sal = sal*1.1
WHERE  empno=7369
;
--2 King --> LOCK 으로 빠져버리는 곳 A가 자원 2 요구 상태
UPDATE emp
SET    sal = sal*1.1
WHERE  empno=7839
;

--Transaction B
UPDATE emp -- 자원 2
SET    comm=500
WHERE  empno=7839
;
UPDATE emp -- 자원 1을 요구한다
SET    comm=300
WHERE  empno=7369
;

insert into dept Values(72, 'kk','kk');
commit;

----------------------------------------------------------------------
----                    9-1.     JOIN       ***              ---------
----------------------------------------------------------------------
-- 1) 조인의 개념
--    하나의 SQL 명령문에 의해 여러 테이블에 저장된 데이터를 한번에 조회할수 있는 기능
-- ex1-1) 학번이 10101인 학생의 이름과 소속 학과 이름을 출력하여라
-- 원래의 방식은 '내가 그 사람의 학번을 알고 있다는 전제 하에서 실행할 수 있다'
SELECT studno, name, deptno
FROM   student
WHERE  studno = 10101;
-- ex1-2)학과를 가지고 학과이름
SELECT dname
FROM department
WHERE deptno = 101;
-- ex1-3)  [ex1-1] + [ex1-2] 한방 조회  ---> Join
SELECT studno, name,  
       student.deptno, department.dname
FROM   student, department
WHERE  student.deptno = department.deptno;

-- 애매모호성 ambiguously
-- alias 명을 사용해라
-- Join 할 때 피해야 할 것들
SELECT  studno, name, deptno, dname
FROM    student s, department d 
WHERE   s.deptno = d.deptno
;
-- 밑이 해결 위가 오류 <밑에 있는 것들이 권장이다>
SELECT  s.studno, s.name, d.deptno, d.dname
FROM    student s, department d 
WHERE   s.deptno = d.deptno
;
-- 전인하 학생의 학번, 이름, 학과 이름 그리고 학과 위치를 출력
SELECT   s.studno, s.name, d.deptno, d.deptno
FROM     student s, department d 
WHERE    s.deptno = d.deptno 
AND      s.name = '전인하'
;
-- 몸무게가 80kg이상인 학생의 학번, 이름, 체중, 학과 이름, 학과위치를 출력
SELECT  s.studno, s.name, s.weight, d.dname, d.loc
FROM    student s, department d
WHERE   S.DEPTNO = D.DEPTNO 
AND     S.WEIGHT >= 80
;

-- 카티션 곱 : 두 개 이상의 테이블에 대해 연결 가능한 행을 모두 결합
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM   student s, department d
;
-- where 조건이 없고 table을 걸면 어떻게 되는가 
-- 많은 것들이 나오게 된다
-- student 17 * department 7 = 두 가지를 곱한 것이 카티션으로 나오게 된다
-- a 테이블의 갯수 b 테이블의 갯수 크로스 조인 토탈 갯수는 몇 개인가?
-- 기사 시험에도 나오는 개념이다
-- 크로스 조인을 해 주는 이유는 그렇다면 무엇일까
-- 1. 개발자 실수
-- 2. 개발초기에 많은 data 생성
-- 면접에서 말해야 한다. 
-- 위와 같은 결론이가 나오지만 밑은 cross join 방식이다
SELECT s.studno, s.name, d.dname, d.loc, s.weight, d.deptno
FROM student s CROSS JOIN department d
;

-- EQ JOIN
-- ***
-- 조인 대상 테이블에서 공통 칼럼을 ‘=‘(equal) 비교를 통해 
-- 같은 값을 가지는 행을 연결하여 결과를 생성하는 조인 방법
-- SQL 명령문에서 가장 많이 사용하는 조인 방법
-- 자연조인을 이용한 EQUI JOIN
-- 오라클 9i 버전부터 EQUI JOIN을 자연조인이라 명명
-- WHERE 절을 사용하지 않고  NATURAL JOIN 키워드 사용
-- 오라클에서 자동적으로 테이블의 모든 칼럼을 대상으로 공통 칼럼을 조사 후, 내부적으로 조인문 생성

-- 원래 join example
-- 오라클 조인 표기
SELECT s.studno, s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno;

-- ansi 표기법
-- nature join
-- Natural Join Convert Error 해결 
-- NATURAL JOIN시 조인 애트리뷰트에 테이블 별명을 사용하면 오류가 발생
SELECT s.studno, s.name, s.weight, d.deptno, d.dname, d.loc
FROM student s
     NATURAL JOIN department d;
 -- deptno 부분 확인하기     
SELECT s.studno, s.name, s.weight, deptno, d.dname, d.loc
FROM   student s
       NATURAL JOIN department d;
-- NATURAL JOIN을 이용하여 교수 번호, 이름, 학과 번호, 학과 이름을 출력하여라
SELECT p.profno, p.name, deptno,d.dname
FROM   professor p
       NATURAL JOIN department d;
-- NATURAL JOIN을 이용하여 4학년 학생의 이름, 학과 번호, 학과이름을 출력하여라
SELECT s.grade, s.name, deptno, d.dname
FROM   student s
       NATURAL JOIN department d
WHERE  s.grade = '4';

-- using절을 이용한 eq join
-- JOIN ~ USING 절을 이용한 EQUI JOIN
-- USING절에 조인 대상 칼럼을 지정
-- 칼럼 이름은 조인 대상 테이블에서 동일한 이름으로 정의되어 있어야함
-- 문1) JOIN ~ USING 절을 이용하여 학번, 이름, 학과번호, 학과이름, 학과위치를
--       출력하여라
SELECT s.studno, s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno);
-- EQUI JOIN의 3가지 방법을 이용하여 
-- 성이 ‘김’씨인 학생들의 이름, 학과번호,학과이름을 출력

-- 1. ORACLE join 기법
SELECT s.name, d.deptno, d.dname
FROM   student s, department d
WHERE  s.deptno = d.deptno
AND  s.name like '김%'
;

-- natural join 
SELECT s.name, deptno, d.dname
FROM   student s NATURAL JOIN department d
WHERE  s.name like '김%'
;

-- join using
SELECT s.name, deptno, dname
FROM   student s JOIN department
       USING(deptno)
WHERE  s.name like '김%'
;

-- 4> ansi join
-- WHERE절 대신 ON을 사용한다
-- ORACLE JOIN 과 ANSI 조인이 많이 사용되기 때문에 둘 다 알아야 한다
SELECT s.name, d.deptno, d.dname
FROM   student s INNER JOIN department d
ON     s.deptno = d.deptno
WHERE  s.name like '김%'
;
-- NON-EQUI JOIN **
-- ‘<‘,BETWEEN a AND b 와 같이 ‘=‘ 조건이 아닌 연산자 사용
-- 교수 테이블과 급여 등급 테이블을 NON-EQUI JOIN하여 
-- 교수별로 급여 등급을 출력하여라
CREATE TABLE "SCOTT"."SALGRADE2" 
   (	"GRADE" NUMBER(2,0), 
     	"LOSAL" NUMBER(5,0), 
    	"HISAL" NUMBER(5,0)
  );

SELECT p.profno, p.name, p.sal, s.grade
FROM   professor p, salgrade2 s
WHERE  p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN  ***
-- 성능이 떨어짐에도 이걸 사용하는 이유는 무결성 문제를 방지하기 위해서 사용하는 것이다.
-- EQUI JOIN에서 양측 칼럼 값중의 하나가 NULL 이지만 조인 결과로 출력할 필요가 있는 경우
-- OUTER JOIN 사용
SELECT s.name, s.grade, p.name, p.position
FROM   student s, professor p
WHERE  s.profno = p.profno;

-- 학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수의 이름, 직급을 출력
-- 단, 지도교수가 배정되지 않은 학생이름도 함께 출력하여라
-- oracle left outer join
SELECT s.name, s.grade, p.name, p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
ORDER BY s.grade;

-- ansi left outer join
-- spring에서 사용하는 converting 

SELECT s.name, s.grade, p.name, p.position
FROM student s 
       LEFT OUTER JOIN professor p
       ON  s.profno = p.profno
ORDER BY s.grade;

-- right outer join 
-- 비슷한 것처럼 보이지만 결과가 다르게 나온다는 점 확인하기
--학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수 이름, 직급을 출력
-- 단, 지도학생을 배정받지 않은 교수 이름도 함께 출력하여라
-- oracle 방식의 right outer join 
SELECT   s.name, s.grade, p.name, p.position
FROM     student s, professor p
WHERE    s.profno(+) = p.profno
ORDER BY p.profno;

SELECT   s.name, s.grade, p.name, p.position
FROM     student s
        RIGHT OUTER JOIN professor p
        ON               s.profno = p.profno
ORDER BY p.profno;
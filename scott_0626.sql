--SQL 함수의 유형
--1) 단일 행 함수 : 테이블에 저장되어 있는 개별 행을 대상으로 함수를 적용하여
--                하나의 결과를 반환하는 함수
--  [1] 데이터 값을 조작하는데 주로 사용
--  [2] 행별로 함수를 적용하여 하나의 결과를 반환하는 함수
--2) 복수 행 함수: 조건에 따라 여러 행을 그룹화하여
--                그룹별로 결과를 하나씩 반환하는 함수
-- -----------------------------------------------------------------
--1. 문자 함수
--   문자 데이터를 입력하여 문자나 숫자를 결과로 반환하는 함수
--INITCAP
--문자열의 철 번째 문자만 대문자로 변환
--INITCAP(‘student’) → Student
--ex)학생 테이블에서 ‘김영균’ 학생의 이름, 사용자 아이디를 출력하여라.
--   그리고 사용자 아이디의 첫 문자를 대문자로 변환하여 출력하여라
SELECT name, userid, INITCAP(userid)
FROM student
WHERE name = '김영균'
;
--LOWER
--문자열 전체를 소문자로 변환
--LOWER(‘STUDENT’) →student
--UPPER
--문자열 전체를 대문자로 변환
--UPPER(‘student’)→STUDENT
--ex)학생 테이블에서 학번이 ‘20101’인 학생의 사용자 아이디를 
--   (소문자와 대문자로 변환하여 출력)
SELECT userid , LOWER(userid), UPPER(userid)
FROM student
WHERE studno = 20101
;

--문자열 길이 반환 함수
-- 1)LENGTH 함수는 인수로 입력되는 칼럼이나 표현식의 문자열의 길이를 반환하는 함수이고,
-- 2)LENGTHB 함수는 문자열의 바이트 수를 반환하는 함수이다.
--ex) 부서 테이블에서 부서 이름의 길이를 문자 수와 바이트 수로 각각 출력하여라
SELECT dname, LENGTH(dname), LENGTHB(dname)
FROM dept
;
--한글 문자열 길이  Test --> Insert 안 된 표준 utf-8
INSERT INTO dept VALUES(59,'경영지원팀','충정로');

--문자 조작 함수의 종류
--CONCAT :두 문자열을 결합, ‘||’와 동일
SELECT name ||'의 직책은 '
FROM professor
;
SELECT CONCAT(name,'의 직책은 ')
FROM professor
;
SELECT CONCAT(CONCAT(name,'의 직책은 '), position)
FROM professor
;
--SUBSTR :특정 문자 또는 문자열 일부를 추출
--ex) 학생 테이블에서 1학년 학생의 주민등록 번호에서 생년월일과 태어난 달을 추출하여
--    이름, 주민번호, 생년월일, 태어난 달, 성별을 출력하여라
SELECT name, idnum, SUBSTR(idnum,1,6) birth_date, SUBSTR(idnum,3,2) birth_mon, SUBSTR(idnum,7,1) gender
FROM student
WHERE grade=1
;
--INSTR :특정 문자가 출현하는 첫 번째 위치를 반환
--문자열중에서 사용자가 지정한 특정 문자가 포함된 위치를 반환하는 함수
--ex) 학과  테이블의 부서 이름 칼럼에서 ‘과’ 글자의 위치를 출력하여라
SELECT dname, INSTR(dname,'과')
FROM department
;

--LPAD :오른쪽 정렬후 왼쪽으로 지정문자를 삽입
--RPAD :왼쪽 정렬후 오른쪽으로 지정 문자를 삽입
-- LPAD와 RPAD 함수는 문자열이 일정한 크기가 되도록 왼쪽 또는 오른쪽에 지정한 문자를 삽입하는 함수
-- 교수테이블에서 직급 칼럼의 왼쪽에 ‘*’ 문자를 삽입하여 10바이트로 출력하고 
-- 교수 아이디 칼럼은 오른쪽에 ‘+’문자를 삽입하여 12바이트로 출력 
SELECT position, LPAD(position,10, '*') lpad_position,
       userid,  RPAD(userid,12,'+') lpad_userid
FROM   professor;

--LTRIM :왼쪽 지정 문자를 삭제
--RTRIM :오른쪽 지정 문자를 삭제
--LTRIM와 RTRIM 함수는 문자열에서 특정 문자를 삭제하기 위해 사용
--함수의 인수에서 삭제할 문자를 지정하지 않으면 문자열의 앞뒤 부분에 있는 공백 문자를 삭제

SELECT ' abcdefg ', LTRIM(' abcdefg ',' ') 
FROM dual;
SELECT ' abcdefg ', LTRIM(' abcdefg ',' '), RTRIM(' abcdefg ', ' ') 
FROM dual;
--  학과 테이블에서 부서 이름의 마지막 글자인 ‘과’를 삭제하여 출력하여라
SELECT dname, RTRIM(dname,'과')
FROM department;

-- 숫자 함수 : 숫자 데이터를 처리하기 위한 함수
-- 1. ROUND : 지정한 소수점 자리로 값을 반올림
--  지정한 자리 이하에서 반올림한 결과 값을 반환하는 함수
-- 교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여 소수점 첫째 자리와 
-- 셋째 자리에서 반올림 한 값과 소숫점 왼쪽 첫째 자리에서 반올림한 값을 출력하여라
SELECT name, sal, sal/22, ROUND(sal/22), ROUND(sal/22,2),ROUND(sal/22,-1)
FROM professor
WHERE deptno = 101
;

-- 2. TRUNC : 지정한 소수점 자리까지 남기고 값을 버림
-- 교수 테이블에서 101학과 교수의 일급을 계산(월 근무일은 22일)하여
-- 소수점 첫째 자리와 셋째 자리에서 절삭 한 값과 
-- 소숫점 왼쪽 첫째 자리에서 절삭한 값을 출력
SELECT name, sal, sal/22, TRUNC(sal/22), TRUNC(sal/22,2),TRUNC(sal/22,-1)
FROM professor
WHERE deptno = 101
;

-- 3. MOD   : m을 n으로 나눈 나머지
-- MODULE
-- MOD 함수는 나누기 연산후에 나머지를 출력하는 함수 
-- 교수 테이블에서 101번 학과 교수의 급여를 보직수당으로 나눈 나머지를 계산하여 출력하여라
SELECT name, sal, comm, MOD(sal, comm)
FROM professor
WHERE deptno = 101
;

-- 4. CEIL  : 지정한 값보다 큰수 중에서 가장 작은 정수
-- 5. FLOOR : 지정한 값보다 작은수 중에서 가장 큰 정수
-- CEIL 함수는 지정한 숫자보다 크거나 같은 정수 중에서 최소 값을 출력하는 함수
-- FLOOR함수는 지정한 숫자보다 작거나 같은 정수 중에서 최대 값을 출력하는 함수
-- 19.7보다 큰 정수 중에서 가장 작은 정수와 12.345보다 작은 정수 중에서 가장 큰 정수를 출력하여라
SELECT CEIL(19.7), FLOOR(12.345)
FROM dual
;

-----------------------------------------------------------
-------- 날자 함수 *** ------------------------------------
---------------------------------------------------------
-- 1) 날짜 + 숫자 = 날짜 (날짜에 일수를 가산)
-- 교수 번호가 9908인 교수의 입사일을 기준으로 입사 30일 후와 60일 후의 날짜를 출력
SELECT name,hiredate, hiredate + 30, hiredate + 60
FROM professor
WHERE profno = 9908
;

-- SYSDATE 함수
-- SYSDATE 함수는 시스템에 저장된 현재 날짜를 반환하는 함수로서, 초 단위까지 반환
SELECT sysdate
FROM dual
;

-- 3) 날짜 - 숫자 = 날짜 (날짜에 일수를 감산)
SELECT name,hiredate, hiredate - 30, hiredate - 60
FROM professor
WHERE profno = 9908
;

-- 4) 날짜 - 날짜 = 일수 (날짜에 날짜를 감산)
SELECT name,hiredate, sysdate - hiredate
FROM professor
WHERE profno = 9908
;

-- 5) MONTHS_BETWEEN : date1과 date2 사이의 개월 수를 계산
--    ADD_MONTHS     : date에 개월 수를 더한 날짜 계산
-- MONTHS_BETWEEN과 ADD_MONTHS 함수는 월 단위로 날짜 연산을 하는 함수 
-- 입사한지 120개월 미만인 교수의 교수번호, 입사일, 입사일로 부터 현재일까지의 개월 수,
-- 입사일에서 6개월 후의 날짜를 출력하여라
SELECT profno, hiredate,
       MONTHS_BETWEEN(SYSDATE,hiredate) working_day,
       ADD_MONTHS(hiredate, 6) hire_6after
FROM   professor
WHERE  MONTHS_BETWEEN(SYSDATE, hiredate) < 120
;

-- TO_CHAR 함수
-- TO_CHAR 함수는 날짜나 숫자를 문자로 변환하기 위해 사용
-- 학생 테이블에서 전인하 학생의 학번과 생년월일 중에서 년월만 출력하여라
-- mm/month/mon/yyyy/yy/dd/dy/day
SELECT studno
            , TO_CHAR(birthdate,'YY/MM')     birthdate1
            , TO_CHAR(birthdate,'YY-MM')     birthdate2
            , TO_CHAR(birthdate,'YYMM')      birthdate3
            , TO_CHAR(birthdate,'YYMMDD')    birthdate4
            , TO_CHAR(birthdate,'YYYYMMDD')  birthdate5
FROM student
WHERE name = '전인하'
;

SELECT TO_CHAR(SYSDATE, 'MONTH') monthDATE
FROM dual
;

-- LAST_DAY, NEXT_DAY
-- LAST_DAY 함수는 해당 날짜가 속한 달의 마지막 날짜를 반환하는 함수
-- NEXT_DAY 함수는 해당 일을 기준으로 명시된 요일의 다음 날짜를 변환하는 함수
-- 오늘이 속한 달의 마지막 날짜와 다가오는 일요일의 날짜를 출력하여라
SELECT SYSDATE, Last_DAY(SYSDATE), Next_day(sysdate,'토')
FROM dual
;

-- TOCAHR, ROUND, TRUNC 함수
-- MM / MM 확인하기
SELECT TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') NORMAL,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') TRUNC,
       TO_CHAR(sysdate, 'YY/MM/DD HH24:MI:SS') ROUND
FROM dual
;

SELECT name,
       TO_CHAR(hiredate, 'YY/MM/DD HH24:MI:SS' ) hiredate,
       TO_CHAR(ROUND(hiredate,'dd'), 'YY/MM/DD') round_dd,
       TO_CHAR(ROUND(hiredate,'mm'), 'YY/MM/DD') round_mm,
       TO_CHAR(ROUND(hiredate,'yy'), 'YY/MM/DD') round_yy
FROM professor
;

-- TO_CHAR 함수는 날짜나 숫자를 문자로 변환하기 위해 사용   ***
-- 학생 테이블에서 전인하 학생의 학번과 생년월일 중에서 년월만 출력하여라
SELECT studno, TO_CHAR(birthdate,'YY/MM') birthdate
FROM STUDENT
WHERE name = '전인하'
;

-- TO_CHAR 함수를 이용한 숫자 출력 형식 변환 --> 9 사용 
-- 예시, (1234, ’99999’) 1234를 숫자로 표현하고 싶어 
-- 숫자를 문자 형식으로 변환
-- 보직수당을 받는 교수들의 이름, 급여, 보직수당, 
-- 그리고 급여와 보직수당을 더한 값에 12를 곱한 결과를 연봉으로 출력
SELECT name, sal, comm, TO_CHAR((COMM + SAL)*12, '9,999') anual_sal
FROM professor
WHERE comm is NOT NULL
;

SELECT TO_NUMBER('123')
FROM dual
;

--CW 03 student Table에서 주민등록번호에서 
-- 생년월일을 추출하여 ‘YY/MM/DD’ 형태로 출력하여라

SELECT TO_CHAR(TO_DATE(SUBSTR(IDNUM,1,6),'YY/MM/DD')) Birthdate
FROM student
;

-- 문 CW04 NVL 함수는 NULL을 0 또는 다른 값으로 변환하기 위한 함수
-- 101번 학과 교수의 이름, 직급, 급여, 보직수당, 급여와 보직수당의 합계를 출력하여라. 
-- 단, 보직수당이 NULL인 경우에는 보직수당을 0으로 계산한다

SELECT name, position, sal, comm, NVL(comm,0) + sal TOTAL
-- NVL(Sal+comm, sal)
FROM professor
WHERE DEPTNO = 101
;

--- QUESTION ---

-- 1.salgrade 데이터 전체 보기
SELECT * 
FROM SALGRADE;

-- 2. SCOTT에서 사용가능한 테이블 보기
SELECT * 
From tab;

-- 3. emp Table에서 사번 , 이름, 급여, 업무, 입사일
SELECT ename, sal, empno, hiredate, job 
from emp;

-- 4. emp Table에서 급여가 2000미만인 사람 에 대한 사번, 이름, 급여 항목 조회
select empno, ename, sal 
from emp
WHERE sal < 2000;


-- 5. emp Table에서 80/02이후에 입사한 사람에 대한  사번,이름,업무,입사일 
SElECT empno, ename, hiredate, job 
FROM   EMP
WHERE  hiredate >'80/02/01'
;
-- 6. emp Table에서 급여가 1500이상이고 3000이하 사번, 이름, 급여  조회(2가지)

SELECT empno, ename, sal
FROM emp
where sal >= 1500 
AND sal<= 3000
-- WHERE sal between 1500 and 3000 
;
-- 7. emp Table에서 사번, 이름, 업무, 급여 출력 [ 급여가 2500이상이고  업무가 MANAGER인 사람]
SELECT ENAME, JOB, SAL, EMPNO 
from emp
where sal >= 2500
and job = 'MANAGER'
;
-- 8. emp Table에서 이름, 급여, 연봉 조회 
--    [단 조건은  연봉 = (급여+상여) * 12  , null을 0으로 변경]
SELECT ename, sal, (sal + nvl(comm,0))*12 total
FROM emp
;
--9. emp Table에서  81/02 이후에 입사자들중 xxx는 입사일이 xxX
--[ 전체 Row 출력 ] --> 2가지 방법 다
--select ename||'는 입사일이'||hiredate||'이다'
--FROM emp
--where hiredate >= '81/02/01'
--SELECT CONCAT(CONCAT(ename, '는 입사일이 ', hiredate)
--FROM EMP
--WHERE hiredate >= '81/02/01
--;
--10.emp Table에서 이름속에 T가 있는 사번,이름 출력
SELECT ENAME, EMPNO
FROM emp
WHERE ename like '%T%'
;

-- NVL2 함수
-- NVL2 함수는 첫 번째 인수 값이 NULL이 아니면 두 번째 인수 값을 출력하고, 
-- 첫 번째 인수 값이 NULL이면 세 번째 인수 값을 출력하는 함수
-- if else if와 비슷한 구문
-- 102번 학과 교수중에서 보직수당을 받는 사람은 급여와 보직수당을 더한 값을 급여 총액으로 출력하여라. 
-- 단, 보직수당을 받지 않는 교수는 급여만 급여 총액으로 출력하여라
SELECT name, position, sal, comm, 
       NVL2(comm,sal+comm,sal) total
FROM professor
WHERE deptno = 102;

-- NULLIF 함수
-- NULLIF 함수는 두 개의 표현식을 비교하여 값이 동일하면 NULL을 반환하고,일치하지 않으면 첫 번째 표현식의 값을 반환
-- 문) 교수 테이블에서 이름의 바이트 수와 사용자 아이디의 바이트 수를 비교해서
--      같으면 NULL을 반환하고 
--      같지 않으면 이름의 바이트 수를 반환
SELECT name, userid, LENGTHB(name), LENGTHB(userid),
       NULLIF(LENGTHB(name), LENGTHB(userid)) nullif_result
FROM professor;

--?DECODE 함수
--DECODE 함수는 기존 프로그래밍 언어에서 IF문이나 CASE 문으로 표현되는 
--복잡한 알고리즘을 하나의 SQL 명령문으로 간단하게 표현할 수 있는 유용한 기능
--DECODE 함수에서 비교 연산자는 ‘=‘만 가능
--교수 테이블에서 교수의 소속 학과 번호를 학과 이름으로 변환하여 출력하여라. 
--학과 번호가 101이면 ‘컴퓨터공학과’, 102이면 ‘멀티미디어학과’, 201이면 ‘전자공학과’, 
--나머지 학과 번호는 ‘기계공학과’(default)로 변환

SELECT name, deptno, DECODE(deptno, 101, '컴퓨터공학과',
                                    102,'멀티미디어학과', 
                                    201, '전자공학과',
                                         '기계공학과')
FROM professor;

-- CASE 함수
-- CASE 함수는 DECODE 함수의 기능을 확장한 함수 
-- DECODE 함수는 표현식 또는 칼럼 값이 ‘=‘ 비교를 통해 조건과 일치하는 경우에만 다른 값으로 대치할 수 있지만
-- , CASE 함수에서는 산술 연산, 관계 연산, 논리 연산과 같은 다양한 비교가 가능
-- 또한 WHEN 절에서 표현식을 다양하게 정의
-- 8.1.7에서부터 지원되었으며, 9i에서 SQL, PL/SQL에서 완벽히 지원 
-- DECODE 함수에 비해 직관적인 문법체계와 다양한 비교 표현식 사용
Select name, deptno,
      CASE WHEN deptno = 101 Then '컴퓨터공학과'
           WHEN deptno = 102 Then '멀티미디어과'
           WHEN deptno = 201 Then '전자공학과'
           else '기계공학과'
    END deptname
from professor
;

-- 교수 테이블에서 소속 학과에 따라 보너스를 다르게 계산하여 출력하여라. (별명 --> bonus)
-- 학과 번호별로 보너스는 다음과 같이 계산한다.
-- 학과 번호가 101이면 보너스는 급여의 10%, 102이면 20%, 201이면 30%, 나머지 학과는 0%

Select name,deptno,
        CASE WHEN deptno = 101 THEN sal * 0.1
            when deptno = 102 THEN sal * 0.2
            when deptno = 201 THEN sal * 0.3
            else 0
        end bonus
from professor;

Select name,deptno, decode(deptno, '101', sal*0.1
                         , '102', sal*0.2
                         , '201', sal*0.3,
                                    0) bonus
from professor;

-- hw -- 
---------------         Home Work           --------------------
--1. emp Table 의 이름을 대문자, 소문자, 첫글자만 대문자로 출력
SELECT ename,  UPPER (ename),LOWER(ename), INITCAP(ename)
from emp;
--2. emp Table 의  이름, 업무, 업무를 2-5사이 문자 출력
SELECT ename, job, SUBSTR(job,2,5)
from emp;
--3. emp Table 의 이름, 이름을 10자리로 하고 왼쪽에 #으로 채우기
SELECT ename, LPAD(ename, 10, '#')
from emp;
--4. emp Table 의  이름, 업무, 업무가 MANAGER면 관리자로 출력
SELECT ename, job, decode(job,'MANAGER','관리자')
from emp
;
--5. emp Table 의  이름, 급여/7을 각각 정수, 소숫점 1자리. 10단위로   반올림하여 출력
SELECT ename, (sal/7) as sal2, Round(sal/7, 1),Round(sal/7,-1),Round(sal/7, 10)
FROM EMP;
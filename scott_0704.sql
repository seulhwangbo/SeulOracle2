------------------------------------------------------------
--  EMP 테이블에서 사번을 입력받아 해당 사원의 급여에 따른 세금을 구함.
-- 급여가 2000 미만이면 급여의 6%, 
-- 급여가 3000 미만이면 8%, 
-- 5000 미만이면 10%, 
-- 그 이상은 15%로 세금
--- FUNCTION  emp_tax3
-- 1) Parameter : 사번 p_empno
--      변수     :   v_sal(급여)
--                     v_pct(세율)
-- 2) 사번을 가지고 급여를 구함
-- 3) 급여를 가지고 세율 계산 
-- 4) 계산 된 값 Return   number
-------------------------------------------------------------

create or replace FUNCTION emp_tax3
(p_empno in emp.empno%Type)
RETURN number
is
    v_pct number(5,2);
    v_sal emp.sal%type;
-- emp table에 sal 과 같은 타입
BEGIN
    SELECT sal
    INTO   v_sal
    FROM   emp
    WHERE  empno = P_empno;
    if v_sal< 2000 then
    v_pct := (v_sal * 0.06);
    elsif
    v_sal < 3000   then
    v_pct := (v_sal * 0.08);
    elsif
    v_sal < 5000   then
    v_pct := (v_sal *0.1);
    else
    v_pct := (v_sal * 0.15);
    end if;
    return(v_pct);
END emp_tax3;
-- end만 적어도 문제 x

SELECT ename, sal, EMP_TAX3(empno) emp_rate
FROM   emp;

-----------------------------------------------------
--  Procedure up_emp 실행 결과
-- SQL> EXECUTE up_emp(1200);  -- 사번 
-- 결과       : 급여 인상 저장
--               시작문자
--   변수     :   v_job(업무)
--                  v_up세율)

-- 조건 1) job = SALE포함         v_up : 10
--           IF              v_job LIKE 'SALE%' THEN
--     2)            MAN              v_up : 7  
--     3)                                v_up : 5
--   job에 따른 급여 인상을 수행  sal = sal+sal*v_up/100
-- 확인 : DB -> TBL
-----------------------------------------------------
create or replace Procedure up_emp
(
 p_empno in emp.empno%type 
 )
 Is 
  v_up NUMBER(3);
  v_job  emp.job%type;
 BEGIN
    SELECT job 
    INTO  v_job
    FROM emp
    where empno = p_empno;
    
    if v_job like 'SALE%' then
    v_up := 10;
    elsif v_job like 'MAN%' then
    v_up := 7;
    else v_up := 5;
    end if;

    UPDATE emp
    set   sal = sal + sal*v_up/100
    where empno = p_empno;
END;

----------------------------------------------------------
-- HW 01 -- 
-- PROCEDURE Delete_emp
-- SQL> EXECUTE Delete_emp(5555);
-- 사원번호 : 5555
-- 사원이름 : 55
-- 입 사 일 : 81/12/03
-- 데이터 삭제 성공
--  1. Parameter : 사번 입력
--  2. 사번 이용해 사원번호 ,사원이름 , 입 사 일 출력
--  3. 사번 해당하는 데이터 삭제 
----------------------------------------------------------
---------------------------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(40);
--  조회화면 :    사번    : 5555
--              이름    : 홍길동

create or replace PROCEDURE DEPTEMPSEARCH1
(
 p_deptno in emp.deptno%type
)
is
v_empno emp.empno%type;
v_ename emp.ename%type;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT empno,ename
    INTO  v_empno,v_ename
    FROM emp
    where deptno = p_deptno;
    dbms_output.put_line('사번: '||v_empno);
    dbms_output.put_line('이름: '||v_ename);

end
; 

create or replace PROCEDURE DEPTEMPSEARCH2
-- rowtype을 이용하는 방법
(
 p_deptno in emp.deptno%type
)
is
--v_empno emp.empno%type;
--v_ename emp.ename%type;
  v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT *
    INTO   v_emp
    FROM   emp
    where deptno = p_deptno;
    dbms_output.put_line('사번: '||v_emp.empno);
    dbms_output.put_line('이름: '||v_emp.ename);

end DEPTEMPSEARCH2;

create or replace PROCEDURE DEPTEMPSEARCH3
(
 p_deptno in emp.deptno%type
)
is
--v_empno emp.empno%type;
--v_ename emp.ename%type;
  v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT *
    INTO   v_emp
    FROM   emp
    where deptno = p_deptno;
    dbms_output.put_line('사번: '||v_emp.empno);
    dbms_output.put_line('이름: '||v_emp.ename);
    
-- Multi Row Error --> 실제 인출은 요구된 것보다 많은 수의 행을 추출
    EXCEPTION 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : ' || TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
    
end DEPTEMPSEARCH3;



--------------------------------------------------------------------------------
----  ***    cursor    ***
--- 1.정의 : Oracle Server는 SQL문을 실행하고 처리한 정보를 저장하기 위해 
--        "Private SQL Area" 이라고 하는 작업영역을 이용
--       이 영역에 이름을 부여하고 저장된 정보를 처리할 수 있게 해주는데 이를 CURSOR
-- 2. 종류  :   Implicit(묵시적인) CURSOR -> DML문과 SELECT문에 의해 내부적으로 선언 
--              Explicit(명시적인) CURSOR -> 사용자가 선언하고 이름을 정의해서 사용 
-- 3.attribute
--   1) SQL%ROWCOUNT : 가장 최근의 SQL문에 의해 처리된 Row 수
--   2) SQL%FOUND    : 가장 최근의 SQL문에 의해 처리된 Row의 개수가 한 개이상이면 True
--   3) SQL%NOTFOUND : 가장 최근의 SQL문에 의해 처리된 Row의 개수가 없으면True
-- 4. 4단계 ** : fc서울
--     1) DECLARE 단계 : 커서에 이름을 부여하고 커서내에서 수행할 SELECT문을 정의함으로써 CURSOR를 선언
--     2) OPEN 단계 : OPEN문은 참조되는 변수를 연결하고, SELECT문을 실행
--     3) FETCH 단계 : CURSOR로부터 Pointer가 존재하는 Record의 값을 변수에 전달
--     4) CLOSE 단계 : Record의 Active Set을 닫아 주고, 
--                    다시 새로운 Active Set을만들어 OPEN할 수 있게 해줌
--------------------------------------------------------------------------------
-- 커서문 전체를 하나의 변수로 선언해서 사용한다 이것을 DECLARE라고 한다
-- 커서가 발견되지 않으면 이제 LOOP문을 빠져나간다

---------------------------------------------------------
-- EXECUTE 문을 이용해 함수를 실행합니다.
-- SQL>EXECUTE show_emp3(7900);
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE show_emp3
(p_empno IN emp.empno%TYPE)
IS
-- DECLARE 단계
CURSOR emp_cursor IS
SELECT ename,job,sal
FROM   emp
WHERE  empno LIKE p_empno||'%';

v_ename emp.ename%TYPE;
v_sal   emp.sal%TYPE;
v_job   emp.job%TYPE;

BEGIN
-- open 단계
OPEN EMP_CURSOR;
    DBMS_OUTPUT.PUT_LINE('이름 ' || '업무  ' ||'급여');
    DBMS_OUTPUT.PUT_LINE('----------------------');
loop
-- fetch 단계 > 하나씩 꺼낸다
FETCH emp_cursor INTO v_ename, v_job, v_sal;
EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_ename||' '||v_job ||'  ' ||v_sal);
END LOOP;
DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT||'개의 행 선택.');
-- CLOSE 단계
close emp_cursor;
END;

-----------------------------------------------------
-- Fetch 문    ***
-- SQL> EXECUTE  Cur_sal_Hap (5);
-- CURSOR 문 이용 구현 
-- 부서만큼 반복 
-- 	부서명 : 인사팀
-- 	인원수 : 5
-- 	급여합 : 5000
--  
-----------------------------------------------------

create or replace PROCEDURE Cur_sal_Hap
(p_deptno in emp.deptno%type)
IS
CURSOR dept_sum 
IS
    SELECT dname,count(*) cnt ,sum(sal) sumsal
    FROM   dept d, emp e
    WHERE  d.deptno = e.deptno
    and    e.deptno like p_deptno||'%'
    group by dname;

vdname   dept.dname%TYPE;
vcnt      number;
vsumSal   number;
-- DECLARE 단계
BEGIN
-- open 단계
OPEN dept_sum;
loop
-- fetch 단계 > 하나씩 꺼낸다
FETCH dept_sum INTO vdname, vcnt, vsumSal;
EXIT WHEN dept_sum%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('부서명 ' || vdname);
    DBMS_OUTPUT.PUT_LINE('인원수 '|| vcnt);
    DBMS_OUTPUT.PUT_LINE('급여합 '||vsumSal);
    DBMS_OUTPUT.PUT_LINE('----------------------');
END LOOP;
DBMS_OUTPUT.PUT_LINE(dept_sum%ROWCOUNT||'개의 행 선택.');
-- CLOSE 단계
close dept_sum;
END;


------------------------------------------------------------------------
-- FOR문을 사용하면 커서의 OPEN, FETCH, CLOSE가 자동 발생하므로 
-- 따로 기술할 필요가 없고, 레코드 이름도 자동
-- 선언되므로 따로 선언할 필요가 없다.
----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE ForCursor_sal_Hap
IS
-- DECLARE 단계 ==> CURSOR 선언
CURSOR dept_sum IS
       SELECT b.dname, COUNT(a.empno) cnt, SUM(a.sal) salary
       FROM   emp a, dept b
       WHERE  a.deptno = b.deptno
       GROUP BY b.dname;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- Cursor를 FOR문에 실행시킨다 --> open,fetch,close 자동 발생
    FOR emp_list IN dept_sum LOOP
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || emp_list.dname);
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || emp_list.cnt);
        DBMS_OUTPUT.PUT_LINE('부서명 : ' || emp_list.salary);
    END LOOP;
    
    EXCEPTION
    WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생 ');
END;

-----------------------------------------------------------
--오라클 PL/SQL은 자주 일어나는 몇가지 예외를 미리 정의해 놓았으며, 
--이러한 예외는 개발자가 따로 선언할 필요가 없다.
--미리 정의된 예외의 종류
-- NO_DATA_FOUND : SELECT문이 아무런 데이터 행을 반환하지 못할 때
-- DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터 INSERT 될 때
-- ZERO_DIVIDE : 0으로 나눌 때
-- INVALID_CURSOR : 잘못된 커서 연산
-----------------------------------------------------------

CREATE OR REPLACE PROCEDURE PreException
(v_deptno IN emp.deptno%TYPE)
IS
 v_emp emp%ROWTYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    
    SELECT empno,  ename,  deptno
    INTO   v_emp.empno, v_emp.ename, v_emp.deptno
    FROM   emp
    WHERE  deptno = v_deptno;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('부서번호 : ' || v_emp.deptno);
    
    EXCEPTION 
     WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('중복 데이터가 존재합니다.');
        DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생.');
     WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS 에러 발생');
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' NO_DATA_FOUND 에러 발생.');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('기타 에러 발생.');
END;


-----------------------------------------------------------
----   Procedure :  in_emp
----   Action    : emp Insert
----   1. Error 유형
---      1) DUP_VAL_ON_INDEX  :  PreDefined --> Oracle 선언 Error
---      2) User Defind Error :  lowsal_err (최저급여 ->1500)  
-----------------------------------------------------------


CREATE OR REPLACE PROCEDURE in_emp
(p_name   IN emp.ename %type, -- 1> DUP_VAL_ON_INDEX
 p_sal    IN emp.sal   %type, -- 2> 개발자 DEFINED ERROR : LOWSAL_ERR<최저급여 > 1500>
 p_job    IN emp.job   %type,
 p_deptno IN emp.deptno%type
)
IS
 v_empno  emp.empno%TYPE;
 -- 개발자 Defined Error
 lowsal_err EXCEPTION;
BEGIN
 DBMS_OUTPUT.ENABLE;
 SELECT MAX(empno)+1
 INTO   v_empno
 FROM   emp;

 IF p_sal >= 1500 THEN
  INSERT INTO emp(empno,ename,sal,job,deptno,hiredate)
  VALUES (v_empno,p_name, p_sal,p_job,p_deptno,sysdate);
 ELSE 
  RAISE lowsal_err;
 END IF;
 
 EXCEPTION
 -- Oracle PreDefined Error
  WHEN DUP_VAL_ON_INDEX THEN
     DBMS_OUTPUT.PUT_LINE('중복 데이터 ENAME 존재합니다');
     DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생');
    -- 개발자 Defined ERROR
  WHEN lowsal_err THEN
     DBMS_OUTPUT.PUT_LINE('ERROR!!! - 지정한 급여가 너무 적습니다. 1500 이상으로 다시 입력하세요.');

END in_emp;

-----------------------------------------------------------
----   Procedure :  in_emp3
----   Action    : emp Insert
----   1. Error 유형
---      1) DUP_VAL_ON_INDEX  :  PreDefined --> Oracle 선언 Error
---      2) User Defind Error :  highsal_err (최고급여 ->9000 이상 오류 발생)  
---   2. 기타조건
---      1) emp.ename은 Unique 제약조건이 걸려 있다고 가정 
---      2) parameter : p_name, p_sal, p_job
---      3) PK(empno) : Max 번호 입력 
---      3) hiredate     : 시스템 날짜 입력 
---      4) emp(empno,ename,sal,job,hiredate)  --> 5 Column입력한다 가정 
-----------------------------------------------------------
create or replace PROCEDURE in_emp3
(p_name   IN emp.ename %type, -- 1> DUP_VAL_ON_INDEX
 p_sal    IN emp.sal   %type,
 p_job    IN emp.job   %type
)
IS
 v_empno  emp.empno%TYPE;
 -- 개발자 Defined Error
 highsal_err EXCEPTION;
BEGIN
 DBMS_OUTPUT.ENABLE;
 SELECT MAX(empno)+1
 INTO   v_empno
 FROM   emp;

 IF p_sal < 9000 THEN
  INSERT INTO emp(empno,ename,sal,job,hiredate)
  VALUES (v_empno,p_name, p_sal,p_job,sysdate);
 ELSE 
  RAISE highsal_err;
 END IF;

 EXCEPTION
 -- Oracle PreDefined Error
  WHEN DUP_VAL_ON_INDEX THEN
     DBMS_OUTPUT.PUT_LINE('중복 데이터 ENAME 존재합니다');
     DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생');
    -- 개발자 Defined ERROR
  WHEN highsal_err THEN
     DBMS_OUTPUT.PUT_LINE('ERROR!!! - 지정한 급여가 큽니다. 9000 이하로 다시 입력하세요.');

END in_emp3;
    
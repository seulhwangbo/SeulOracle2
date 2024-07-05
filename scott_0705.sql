--------------------------------------------------------------
--  20240705 현장Work01
-- 1.  PROCEDURE update_empno
-- 2.  parameter -> p_empno, p_job
-- 3.  해당 empno에 관련되는 사원들을(Like) job을 사람의 직업을 p_job으로 업데이트
-- 4. Update -> emp 직업
-- 5.              입사일은 현재일자
-- 6.  기본적  EXCEPTION  처리 
-------------------------------------------------------------
CREATE OR REPLACE PROCEDURE update_empno
 (p_empno IN emp.empno%TYPE,
  p_job   IN emp.job%TYPE)
IS
    CURSOR emp_cursor IS
        SELECT empno
        FROM emp
        WHERE empno LIKE p_empno||'%';
    
   
BEGIN
    DBMS_OUTPUT.ENABLE;
    FOR emp_list IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('사원 : '||emp_list.empno);
        UPDATE emp
        SET job = p_job, hiredate = SYSDATE
        WHERE empno = emp_list.empno;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('수정 성공');
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');
END;

---------------------------------------------------------------------------------------
-----    Package
--  자주 사용하는 프로그램과 로직을 모듈화
--  응용 프로그램을 쉽게 개발 할 수 있음
--  프로그램의 처리 흐름을 노출하지 않아 보안 기능이 좋음
--  프로그램에 대한 유지보수 작업이 편리
--  같은 이름의 프로시저와 함수를 여러 개 생성

----------------------------------------------------------------------------------------
--- 1.Header -->  역할 : 선언 (Interface 역할)
--     여러 PROCEDURE 선언 가능
CREATE OR REPLACE PACKAGE emp_info AS
    PROCEDURE all_emp_info;
    PROCEDURE all_sal_info;
    PROCEDURE dept_emp_info(p_deptno IN NUMBER);

END emp_info;

--  2 body 역할: 실제 구현
CREATE OR REPLACE PACKAGE BODY emp_info AS
    -----------------------------------------------------------------
    -- 모든 사원의 사원 정보(사번, 이름, 입사일)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 사번,이름,입사일 
    ----------------------------------------------------------------
    PROCEDURE all_emp_info
    is
    CURSOR emp_cursor IS
        SELECT empno, ename, to_char(hiredate, 'yyyy/mm/dd') hiredate
        FROM emp
        ORDER BY hiredate;
     begin
     DBMS_OUTPUT.ENABLE;
        FOR emp IN emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('사번 : '||emp.empno);
        DBMS_OUTPUT.PUT_LINE('사원 : '||emp.ename);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||emp.hiredate);
     END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');

    END all_emp_info;
    -----------------------------------------------------------------------
    -- 모든 사원의 부서별 급여 정보
    -- 1. CURSOR  : empdept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 부서명 ,전체급여평균 , 최대급여금액 , 최소급여금액
   -----------------------------------------------------------------------
    PROCEDURE all_sal_info
    is
    CURSOR empdept_cursor is
    select d.dname dname, round(avg(e.sal),3) averg, min(e.sal) mini,max(e.sal) maxi
    FROM   emp e, dept d
    where  e.deptno = d.deptno
    GROUP BY d.dname
    ;
    
    BEGIN
    DBMS_OUTPUT.ENABLE;
        FOR empdept IN empdept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('부서명: '||empdept.dname);
        DBMS_OUTPUT.PUT_LINE('전체급여평균 : '||empdept.averg);
        DBMS_OUTPUT.PUT_LINE('최소급여금액 : '||empdept.mini);
        DBMS_OUTPUT.PUT_LINE('최대급여금액 : '||empdept.maxi);
    END LOOP;
    
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');

    END all_sal_info;
    -- 특정 부서의 사원 정보
    -- 사번, 성명, 입사일 
    PROCEDURE dept_emp_info
    (p_deptno IN NUMBER)
    
    IS
    CURSOR emp_cursor IS
    select empno, ename, to_char (hiredate,'yyyy/mm/dd') hiredate
    FROM   emp
    where  deptno = p_deptno
    ORDER BY HIREDATE
    ;
    
    BEGIN
     DBMS_OUTPUT.ENABLE;
        FOR AA in emp_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('사번: '||aa.empno);
        DBMS_OUTPUT.PUT_LINE('성명 : '||aa.ename);
        DBMS_OUTPUT.PUT_LINE('입사일 : '||aa.hiredate);
        END LOOP;
    
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');

    END dept_emp_info;
end emp_info;
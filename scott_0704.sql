------------------------------------------------------------
--  EMP ���̺��� ����� �Է¹޾� �ش� ����� �޿��� ���� ������ ����.
-- �޿��� 2000 �̸��̸� �޿��� 6%, 
-- �޿��� 3000 �̸��̸� 8%, 
-- 5000 �̸��̸� 10%, 
-- �� �̻��� 15%�� ����
--- FUNCTION  emp_tax3
-- 1) Parameter : ��� p_empno
--      ����     :   v_sal(�޿�)
--                     v_pct(����)
-- 2) ����� ������ �޿��� ����
-- 3) �޿��� ������ ���� ��� 
-- 4) ��� �� �� Return   number
-------------------------------------------------------------

create or replace FUNCTION emp_tax3
(p_empno in emp.empno%Type)
RETURN number
is
    v_pct number(5,2);
    v_sal emp.sal%type;
-- emp table�� sal �� ���� Ÿ��
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
-- end�� ��� ���� x

SELECT ename, sal, EMP_TAX3(empno) emp_rate
FROM   emp;

-----------------------------------------------------
--  Procedure up_emp ���� ���
-- SQL> EXECUTE up_emp(1200);  -- ��� 
-- ���       : �޿� �λ� ����
--               ���۹���
--   ����     :   v_job(����)
--                  v_up����)

-- ���� 1) job = SALE����         v_up : 10
--           IF              v_job LIKE 'SALE%' THEN
--     2)            MAN              v_up : 7  
--     3)                                v_up : 5
--   job�� ���� �޿� �λ��� ����  sal = sal+sal*v_up/100
-- Ȯ�� : DB -> TBL
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
-- �����ȣ : 5555
-- ����̸� : 55
-- �� �� �� : 81/12/03
-- ������ ���� ����
--  1. Parameter : ��� �Է�
--  2. ��� �̿��� �����ȣ ,����̸� , �� �� �� ���
--  3. ��� �ش��ϴ� ������ ���� 
----------------------------------------------------------
---------------------------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����  PROCEDURE 
-- SQL> EXECUTE DeptEmpSearch(40);
--  ��ȸȭ�� :    ���    : 5555
--              �̸�    : ȫ�浿

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
    dbms_output.put_line('���: '||v_empno);
    dbms_output.put_line('�̸�: '||v_ename);

end
; 

create or replace PROCEDURE DEPTEMPSEARCH2
-- rowtype�� �̿��ϴ� ���
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
    dbms_output.put_line('���: '||v_emp.empno);
    dbms_output.put_line('�̸�: '||v_emp.ename);

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
    dbms_output.put_line('���: '||v_emp.empno);
    dbms_output.put_line('�̸�: '||v_emp.ename);
    
-- Multi Row Error --> ���� ������ �䱸�� �ͺ��� ���� ���� ���� ����
    EXCEPTION 
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : ' || TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
    
end DEPTEMPSEARCH3;



--------------------------------------------------------------------------------
----  ***    cursor    ***
--- 1.���� : Oracle Server�� SQL���� �����ϰ� ó���� ������ �����ϱ� ���� 
--        "Private SQL Area" �̶�� �ϴ� �۾������� �̿�
--       �� ������ �̸��� �ο��ϰ� ����� ������ ó���� �� �ְ� ���ִµ� �̸� CURSOR
-- 2. ����  :   Implicit(��������) CURSOR -> DML���� SELECT���� ���� ���������� ���� 
--              Explicit(�������) CURSOR -> ����ڰ� �����ϰ� �̸��� �����ؼ� ��� 
-- 3.attribute
--   1) SQL%ROWCOUNT : ���� �ֱ��� SQL���� ���� ó���� Row ��
--   2) SQL%FOUND    : ���� �ֱ��� SQL���� ���� ó���� Row�� ������ �� ���̻��̸� True
--   3) SQL%NOTFOUND : ���� �ֱ��� SQL���� ���� ó���� Row�� ������ ������True
-- 4. 4�ܰ� ** : fc����
--     1) DECLARE �ܰ� : Ŀ���� �̸��� �ο��ϰ� Ŀ�������� ������ SELECT���� ���������ν� CURSOR�� ����
--     2) OPEN �ܰ� : OPEN���� �����Ǵ� ������ �����ϰ�, SELECT���� ����
--     3) FETCH �ܰ� : CURSOR�κ��� Pointer�� �����ϴ� Record�� ���� ������ ����
--     4) CLOSE �ܰ� : Record�� Active Set�� �ݾ� �ְ�, 
--                    �ٽ� ���ο� Active Set������� OPEN�� �� �ְ� ����
--------------------------------------------------------------------------------
-- Ŀ���� ��ü�� �ϳ��� ������ �����ؼ� ����Ѵ� �̰��� DECLARE��� �Ѵ�
-- Ŀ���� �߰ߵ��� ������ ���� LOOP���� ����������

---------------------------------------------------------
-- EXECUTE ���� �̿��� �Լ��� �����մϴ�.
-- SQL>EXECUTE show_emp3(7900);
--------------------------------------------------------
CREATE OR REPLACE PROCEDURE show_emp3
(p_empno IN emp.empno%TYPE)
IS
-- DECLARE �ܰ�
CURSOR emp_cursor IS
SELECT ename,job,sal
FROM   emp
WHERE  empno LIKE p_empno||'%';

v_ename emp.ename%TYPE;
v_sal   emp.sal%TYPE;
v_job   emp.job%TYPE;

BEGIN
-- open �ܰ�
OPEN EMP_CURSOR;
    DBMS_OUTPUT.PUT_LINE('�̸� ' || '����  ' ||'�޿�');
    DBMS_OUTPUT.PUT_LINE('----------------------');
loop
-- fetch �ܰ� > �ϳ��� ������
FETCH emp_cursor INTO v_ename, v_job, v_sal;
EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_ename||' '||v_job ||'  ' ||v_sal);
END LOOP;
DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT||'���� �� ����.');
-- CLOSE �ܰ�
close emp_cursor;
END;

-----------------------------------------------------
-- Fetch ��    ***
-- SQL> EXECUTE  Cur_sal_Hap (5);
-- CURSOR �� �̿� ���� 
-- �μ���ŭ �ݺ� 
-- 	�μ��� : �λ���
-- 	�ο��� : 5
-- 	�޿��� : 5000
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
-- DECLARE �ܰ�
BEGIN
-- open �ܰ�
OPEN dept_sum;
loop
-- fetch �ܰ� > �ϳ��� ������
FETCH dept_sum INTO vdname, vcnt, vsumSal;
EXIT WHEN dept_sum%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('�μ��� ' || vdname);
    DBMS_OUTPUT.PUT_LINE('�ο��� '|| vcnt);
    DBMS_OUTPUT.PUT_LINE('�޿��� '||vsumSal);
    DBMS_OUTPUT.PUT_LINE('----------------------');
END LOOP;
DBMS_OUTPUT.PUT_LINE(dept_sum%ROWCOUNT||'���� �� ����.');
-- CLOSE �ܰ�
close dept_sum;
END;


------------------------------------------------------------------------
-- FOR���� ����ϸ� Ŀ���� OPEN, FETCH, CLOSE�� �ڵ� �߻��ϹǷ� 
-- ���� ����� �ʿ䰡 ����, ���ڵ� �̸��� �ڵ�
-- ����ǹǷ� ���� ������ �ʿ䰡 ����.
----------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE ForCursor_sal_Hap
IS
-- DECLARE �ܰ� ==> CURSOR ����
CURSOR dept_sum IS
       SELECT b.dname, COUNT(a.empno) cnt, SUM(a.sal) salary
       FROM   emp a, dept b
       WHERE  a.deptno = b.deptno
       GROUP BY b.dname;
BEGIN
    DBMS_OUTPUT.ENABLE;
    -- Cursor�� FOR���� �����Ų�� --> open,fetch,close �ڵ� �߻�
    FOR emp_list IN dept_sum LOOP
        DBMS_OUTPUT.PUT_LINE('�μ��� : ' || emp_list.dname);
        DBMS_OUTPUT.PUT_LINE('�μ��� : ' || emp_list.cnt);
        DBMS_OUTPUT.PUT_LINE('�μ��� : ' || emp_list.salary);
    END LOOP;
    
    EXCEPTION
    WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻� ');
END;

-----------------------------------------------------------
--����Ŭ PL/SQL�� ���� �Ͼ�� ��� ���ܸ� �̸� ������ ��������, 
--�̷��� ���ܴ� �����ڰ� ���� ������ �ʿ䰡 ����.
--�̸� ���ǵ� ������ ����
-- NO_DATA_FOUND : SELECT���� �ƹ��� ������ ���� ��ȯ���� ���� ��
-- DUP_VAL_ON_INDEX : UNIQUE ������ ���� �÷��� �ߺ��Ǵ� ������ INSERT �� ��
-- ZERO_DIVIDE : 0���� ���� ��
-- INVALID_CURSOR : �߸��� Ŀ�� ����
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
    
    DBMS_OUTPUT.PUT_LINE('��� : ' || v_emp.empno);
    DBMS_OUTPUT.PUT_LINE('�̸� : ' || v_emp.ename);
    DBMS_OUTPUT.PUT_LINE('�μ���ȣ : ' || v_emp.deptno);
    
    EXCEPTION 
     WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('�ߺ� �����Ͱ� �����մϴ�.');
        DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�.');
     WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS ���� �߻�');
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE(' NO_DATA_FOUND ���� �߻�.');
     WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�.');
END;


-----------------------------------------------------------
----   Procedure :  in_emp
----   Action    : emp Insert
----   1. Error ����
---      1) DUP_VAL_ON_INDEX  :  PreDefined --> Oracle ���� Error
---      2) User Defind Error :  lowsal_err (�����޿� ->1500)  
-----------------------------------------------------------


CREATE OR REPLACE PROCEDURE in_emp
(p_name   IN emp.ename %type, -- 1> DUP_VAL_ON_INDEX
 p_sal    IN emp.sal   %type, -- 2> ������ DEFINED ERROR : LOWSAL_ERR<�����޿� > 1500>
 p_job    IN emp.job   %type,
 p_deptno IN emp.deptno%type
)
IS
 v_empno  emp.empno%TYPE;
 -- ������ Defined Error
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
     DBMS_OUTPUT.PUT_LINE('�ߺ� ������ ENAME �����մϴ�');
     DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�');
    -- ������ Defined ERROR
  WHEN lowsal_err THEN
     DBMS_OUTPUT.PUT_LINE('ERROR!!! - ������ �޿��� �ʹ� �����ϴ�. 1500 �̻����� �ٽ� �Է��ϼ���.');

END in_emp;

-----------------------------------------------------------
----   Procedure :  in_emp3
----   Action    : emp Insert
----   1. Error ����
---      1) DUP_VAL_ON_INDEX  :  PreDefined --> Oracle ���� Error
---      2) User Defind Error :  highsal_err (�ְ�޿� ->9000 �̻� ���� �߻�)  
---   2. ��Ÿ����
---      1) emp.ename�� Unique ���������� �ɷ� �ִٰ� ���� 
---      2) parameter : p_name, p_sal, p_job
---      3) PK(empno) : Max ��ȣ �Է� 
---      3) hiredate     : �ý��� ��¥ �Է� 
---      4) emp(empno,ename,sal,job,hiredate)  --> 5 Column�Է��Ѵ� ���� 
-----------------------------------------------------------
create or replace PROCEDURE in_emp3
(p_name   IN emp.ename %type, -- 1> DUP_VAL_ON_INDEX
 p_sal    IN emp.sal   %type,
 p_job    IN emp.job   %type
)
IS
 v_empno  emp.empno%TYPE;
 -- ������ Defined Error
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
     DBMS_OUTPUT.PUT_LINE('�ߺ� ������ ENAME �����մϴ�');
     DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�');
    -- ������ Defined ERROR
  WHEN highsal_err THEN
     DBMS_OUTPUT.PUT_LINE('ERROR!!! - ������ �޿��� Ů�ϴ�. 9000 ���Ϸ� �ٽ� �Է��ϼ���.');

END in_emp3;
    
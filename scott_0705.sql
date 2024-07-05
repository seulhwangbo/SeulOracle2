--------------------------------------------------------------
--  20240705 ����Work01
-- 1.  PROCEDURE update_empno
-- 2.  parameter -> p_empno, p_job
-- 3.  �ش� empno�� ���õǴ� �������(Like) job�� ����� ������ p_job���� ������Ʈ
-- 4. Update -> emp ����
-- 5.              �Ի����� ��������
-- 6.  �⺻��  EXCEPTION  ó�� 
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
        DBMS_OUTPUT.PUT_LINE('��� : '||emp_list.empno);
        UPDATE emp
        SET job = p_job, hiredate = SYSDATE
        WHERE empno = emp_list.empno;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('���� ����');
    
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');
END;

---------------------------------------------------------------------------------------
-----    Package
--  ���� ����ϴ� ���α׷��� ������ ���ȭ
--  ���� ���α׷��� ���� ���� �� �� ����
--  ���α׷��� ó�� �帧�� �������� �ʾ� ���� ����� ����
--  ���α׷��� ���� �������� �۾��� ��
--  ���� �̸��� ���ν����� �Լ��� ���� �� ����

----------------------------------------------------------------------------------------
--- 1.Header -->  ���� : ���� (Interface ����)
--     ���� PROCEDURE ���� ����
CREATE OR REPLACE PACKAGE emp_info AS
    PROCEDURE all_emp_info;
    PROCEDURE all_sal_info;
    PROCEDURE dept_emp_info(p_deptno IN NUMBER);

END emp_info;

--  2 body ����: ���� ����
CREATE OR REPLACE PACKAGE BODY emp_info AS
    -----------------------------------------------------------------
    -- ��� ����� ��� ����(���, �̸�, �Ի���)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� ���,�̸�,�Ի��� 
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
        DBMS_OUTPUT.PUT_LINE('��� : '||emp.empno);
        DBMS_OUTPUT.PUT_LINE('��� : '||emp.ename);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||emp.hiredate);
     END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');

    END all_emp_info;
    -----------------------------------------------------------------------
    -- ��� ����� �μ��� �޿� ����
    -- 1. CURSOR  : empdept_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� �μ��� ,��ü�޿���� , �ִ�޿��ݾ� , �ּұ޿��ݾ�
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
        DBMS_OUTPUT.PUT_LINE('�μ���: '||empdept.dname);
        DBMS_OUTPUT.PUT_LINE('��ü�޿���� : '||empdept.averg);
        DBMS_OUTPUT.PUT_LINE('�ּұ޿��ݾ� : '||empdept.mini);
        DBMS_OUTPUT.PUT_LINE('�ִ�޿��ݾ� : '||empdept.maxi);
    END LOOP;
    
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');

    END all_sal_info;
    -- Ư�� �μ��� ��� ����
    -- ���, ����, �Ի��� 
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
        DBMS_OUTPUT.PUT_LINE('���: '||aa.empno);
        DBMS_OUTPUT.PUT_LINE('���� : '||aa.ename);
        DBMS_OUTPUT.PUT_LINE('�Ի��� : '||aa.hiredate);
        END LOOP;
    
        EXCEPTION
        WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');

    END dept_emp_info;
end emp_info;
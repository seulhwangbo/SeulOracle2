  CREATE TABLE sampleTBL(
   memo varchar2(50)
  );
  
----ORA-00942: table or view does not exist
--00942. 00000 -  "table or view does not exist"
-- SELECT * FROM scott.emp;
-- SCOTT���� ���� �ο� ���Ŀ��� ��� �����ϴ�   
SELECT * FROM scott.emp;

-- ���� �ο����� ������ �ٸ� USER���� ���Ҵ�
GRANT SELECT on scott.emp TO usertest04 WITH GRANT OPTION;
--01031. 00000 -  "insufficient privileges"
GRANT SELECT ON scott.stud_101 TO usertest04;
-- �װ��� with grant option �̰� ���ٸ� ���Ҵ� ������ ����
-- select�� ������ ������ ������ ���Ҵ��ϱ⿡�� ������ ����ϰ� �������� �ʴ´�
SELECT * FROM scott.stud_101;

SELECT * FROM scott.job3;
GRANT SELECT on scott.job3 TO usertest04 WITH GRANT OPTION;





  CREATE TABLE sampleTBL(
   memo varchar2(50)
  );
  
INSERT INTO sampleTBL values('7�� ����');
INSERT INTO sampleTBL values('����� ����');

COMMIT;

SELECT * FROM sampleTBL;
--  "table or view does not exist"
-- �Ұ��ϴ�
SELECT * FROM scott.emp;
-- CONNECT RESOURCE �� �� ������ ����
-- ������ �Ҵ��� �����ϴ�
SELECT * FROM scott.emp;
GRANT SELECT on scott.emp TO usertest03;

-- 04���� ������ ȸ�� �� �� ��ȸ / ȸ���� �Ŀ��� ������ ���� �ʴ´�
SELECT * FROM scott.emp;

-- ok usertest04�� ������ �Ҵ�
SELECT * FROM scott.job3;





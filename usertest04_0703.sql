  CREATE TABLE sampleTBL4(
   memo varchar2(50)
  );
  
INSERT INTO sampleTBL4 values('7�� ����4');
INSERT INTO sampleTBL4 values('����� ����4');

COMMIT;
--
-- �����ϴ�
SELECT * FROM sampleTBL4;
--ORA-00942: table or view does not exist
--00942. 00000 -  "table or view does not exist"
--*Cause:    
--*Action:
--12��, 24������ ���� �߻�
--USERTEST02 ���� ���Ҵ� ���� ���ķ� ���� �� �ִ� ������ �ο��޾Ҵ�.
SELECT * FROM scott.emp;
-- ���Ҵ��� ���Ҵ�
GRANT SELECT on scott.emp TO usertest03;
-- OK SCOTT�̰� ������ �Ҵ��� �־��� �����̴�
SELECT * FROM scott.student;

-- ���� ȸ��
REVOKE SELECT on scott.emp FROM usertest03;

SELECT * FROM scott.job3;
GRANT SELECT on scott.job3 TO usertest03;

--01031. 00000 -  "insufficient privileges"
-- ��ȸ�� ����߱� ������ ������ ������ �������� �ʴ�
UPDATE SCOTT.STUDENT
SET    name   = '������'
WHERE  studno = 30102;

-- �̰͵� �����Ƽ� ������ �� ���� ���Ǿ��̴�.
SELECT * FROM system.systemTBL;
-- ���Ӱ� ���� ���� ���̺� ���� ��ȸ�� �� �� �ִ�
-- ����ڰ� �ý��� ������ ���� �ʾƵ� ���ϰ� ��ȸ�� �� �ִ� 
-- ���� �Ʒ��� ���� ����� ���´ٴ� ���� ����ϱ�
SELECT * FROM systemTBL;
-- ���� ���̺� �̸��� ���� �̸��� ���� �ؼ� �ǹ������� �򰥸��� �ʵ��� �Ѵ�

SELECT * FROM system.privateTBL;
-- connect �� resource ���Ѹ� �ִ�
create synonym privateTBL for system.privateTBL;
--  "table or view does not exist"
-- scott���� ���� ���Ǿ ���� usertest������ �ҷ��� �� ���� scott�� ����ؾ� �Ѵ�
SELECT * FROM privateTBL;

-- ��ȣȭ bit���� ������ ���ȭ ��� 
-- ��ȣȭ ��� seed 
-- ����Ű, �����Ű, �ؽ� ���
-- ������ �����ϴ� ��� ��������, ��ȣȭ ��� �� ������ ���ؼ� ������ ������ �� �ִ�.
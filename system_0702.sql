-- backup dir ����
CREATE OR Replace Directory mdBackup2 as 'C:\BACKUP\oraBackup';
GRANT READ,WRITE On Directory mdBackup2 TO scott;
-- ���翡�� �������� ������ �ǹ������� �߿��� �۾��� backup�̴�

-- backup dir 생성
CREATE OR Replace Directory mdBackup2 as 'C:\BACKUP\oraBackup';
GRANT READ,WRITE On Directory mdBackup2 TO scott;
-- 교재에는 나와있지 않지만 실무에서는 중요한 작업이 backup이다

  CREATE TABLE sampleTBL(
   memo varchar2(50)
  );
  
INSERT INTO sampleTBL values('7월 더움');
INSERT INTO sampleTBL values('결실을 맺자');

COMMIT;

SELECT * FROM sampleTBL;
--  "table or view does not exist"
-- 불가하다
SELECT * FROM scott.emp;
-- CONNECT RESOURCE 둘 다 권한이 없다
-- 연속적 할당이 가능하다
SELECT * FROM scott.emp;
GRANT SELECT on scott.emp TO usertest03;

-- 04에서 권한을 회수 한 후 조회 / 회수한 후에는 실행이 되지 않는다
SELECT * FROM scott.emp;

-- ok usertest04가 권한을 할당
SELECT * FROM scott.job3;





  CREATE TABLE sampleTBL(
   memo varchar2(50)
  );
  
----ORA-00942: table or view does not exist
--00942. 00000 -  "table or view does not exist"
-- SELECT * FROM scott.emp;
-- SCOTT에서 권한 부여 이후에는 허용 가능하다   
SELECT * FROM scott.emp;

-- 내가 부여받은 권한을 다른 USER에게 재할당
GRANT SELECT on scott.emp TO usertest04 WITH GRANT OPTION;
--01031. 00000 -  "insufficient privileges"
GRANT SELECT ON scott.stud_101 TO usertest04;
-- 그것이 with grant option 이게 없다면 재할당 권한이 없다
-- select는 문제가 없지만 권한을 재할당하기에는 권한이 충분하게 존재하지 않는다
SELECT * FROM scott.stud_101;

SELECT * FROM scott.job3;
GRANT SELECT on scott.job3 TO usertest04 WITH GRANT OPTION;





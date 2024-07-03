  CREATE TABLE sampleTBL4(
   memo varchar2(50)
  );
  
INSERT INTO sampleTBL4 values('7월 더움4');
INSERT INTO sampleTBL4 values('결실을 맺자4');

COMMIT;
--
-- 가능하다
SELECT * FROM sampleTBL4;
--ORA-00942: table or view does not exist
--00942. 00000 -  "table or view does not exist"
--*Cause:    
--*Action:
--12행, 24열에서 오류 발생
--USERTEST02 에게 재할당 받은 이후로 읽을 수 있는 권한을 부여받았다.
SELECT * FROM scott.emp;
-- 재할당의 재할당
GRANT SELECT on scott.emp TO usertest03;
-- OK SCOTT이가 권한을 할당해 주었기 때문이다
SELECT * FROM scott.student;

-- 권한 회수
REVOKE SELECT on scott.emp FROM usertest03;

SELECT * FROM scott.job3;
GRANT SELECT on scott.job3 TO usertest03;

--01031. 00000 -  "insufficient privileges"
-- 조회만 허용했기 때문에 나머지 조건은 가능하지 않다
UPDATE SCOTT.STUDENT
SET    name   = '김춘추'
WHERE  studno = 30102;

-- 이것도 귀찮아서 나오게 된 것이 동의어이다.
SELECT * FROM system.systemTBL;
-- 새롭게 만든 공용 테이블 언어로 조회를 할 수 있다
-- 사용자가 시스템 계정을 주지 않아도 편하게 조회할 수 있다 
-- 위와 아래가 같은 결과를 나온다는 것을 기억하기
SELECT * FROM systemTBL;
-- 실제 테이블 이름과 별명 이름을 같게 해서 실무에서는 헷갈리지 않도록 한다

SELECT * FROM system.privateTBL;
-- connect 와 resource 권한만 있다
create synonym privateTBL for system.privateTBL;
--  "table or view does not exist"
-- scott에서 전용 동의어를 만들어서 usertest에서는 불러올 수 없다 scott만 사용해야 한다
SELECT * FROM privateTBL;

-- 암호화 bit별로 나누기 대수화 기법 
-- 암호화 방식 seed 
-- 공개키, 비공개키, 해시 방식
-- 보안을 유지하는 방식 접근제어, 암호화 방식 두 가지를 통해서 보안을 유지할 수 있다.
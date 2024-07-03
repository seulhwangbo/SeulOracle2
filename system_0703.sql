-----------------------------------------------
---   데이터베이스 보안
---  1. 다중 사용자 환경(multi-user environment)
---     1) 사용자는 자신이 생성한 객체에 대해 소유권을 가지고 데이터에 대한 조작이나 조회 가능
---     2) 다른 사용자가 소유한 객체는 소유자로부터 접근 권한을 부여받지 않는 접근 불가
---     3) 다중 사용자 환경에서는 데이터베이스 관리자의 암호를 철저하게 관리
---  2. 중앙 집중적인 데이터 관리
---  3. 시스템 보안
---     1) 데이터베이스 관리자는 사용자 계정, 암호 관리, 사용자별 허용 가능한 디스크공간 할당
---     2) 시스템 관리 차원에서 데이터베이스 자체에 대한 접근 권한을 관리
---  4. 데이터 보안
---     1) 사용자별로 객체를 조작하기 위한 동작 관리
---     2) 데이터베이스 객체에 대한 접근 권한을 관리
-----------------------------------------------
----------------------------------------------------------------------
---  권한(Privilege) 부여
---    1. 정의 : 사용자가 데이터베이스 시스템을 관리하거나 객체를 이용할 수 있는 권리
---    2. 유형 
---         1) 시스템 권한 : 시스템 차원의 자원 관리나 사용자 스키마 객체 관리 등과 같은 
---                               데이터베이스 관리 작업을 할 수 있는 권한
---             [1]  데이터베이스 관리자가 가지는 시스템 권한
---                   CREATE USER    :  사용자를 생성할 수 있는 권한
---                   DROP   USER   : 사용자를 삭제할 수 있는 권한
---                   DROP ANY TABLE : 임의의 테이블을 삭제할 수 있는 권한
---                   QUERY REWRITE  : 함수 기반 인덱스를 생성하기 위한 권한
---             [2]  일반사용자가 가지는 시스템 권한
---                   CREATE SESSION : DB에 접속할 수 있는 권한
---                   CREATE TABLE   : 사용자 스키마에서 테이블을 생성할 수 있는 권한
---                   CREATE SEQUENCE: 사용자 스키마에서 시퀀스를 생성할 수 있는 권한
---                   CREATE VIEW    : 사용자 스키마에서 뷰를 생성할 수 있는 권한
---                 CREATE PROCEDURE : 사용자 스키마에서 프로시저, 함수, 패키지를 생성할 수 있는 권한
---         2) 객체 권한 : 테이블, 뷰, 시퀀스, 함수 등과 같은 객체를 조작할 수 있는 권한
----------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---  롤(role)
---  1. 개념 : 다수 사용자와 다양한 권한을 효과적으로 관리하기 위하여 
---           서로 관련된 권한을 그룹화한 개념
---           일반 사용자가 데이터베이스를 이용하기 위한 공통적인 권한(데이터베이스 접속권한, 테이블 생성, 수정, 삭제, 조회 권한, 뷰 생성 권한)을 그룹화
--  사전에 정의된 롤
--     1. CONNECT 롤
--     1) 사용자가 데이터베이스에 접속하여 세션을 생성할 수 있는 권한
--     2) 테이블 또는 뷰와 같은 객체를 생성할 수 있는 권한
--     2. RESOURCE 롤
--     1) 사용자에게 자신의 테이블, 시퀀스, 프로시져, 트리거 객체 생성 할 수 있는 권한
--     2) 사용자 생성시 : CONNECT 롤과 RESOURCE 롤을 부여
--     3. DBA 롤
--     1) 시스템 자원의 무제한적인 사용이나 시스템 관리에 필요한 모든 권한
--     2) DBA 권한을 다른 사람에게 부여할 수 있음
--     3) 모든 사용자 소유의 CONNECT, RESOURCE, DBA 권한을 포함한 모든 권한을 부여 및 철회 가능

---------------------------------------------------------------------------------------------

-----------------------------------------------
---   Admin 사용자 생성 /권한 부여
------------------------------------------------
-- 1-1. USER 생성
CREATE USER usertest01 IDENTIFIED BY tiger;
-- 1-2. USER 생성
CREATE USER usertest02 IDENTIFIED BY tiger;
-- 1-3. USER 생성
CREATE USER usertest03 IDENTIFIED BY tiger;
-- 1-4. USER 생성
CREATE USER usertest04 IDENTIFIED BY tiger;

-- 2-1. session 권한 부여 -- 접속 권한만 주어짐
GRANT CREATE session to usertest01;
-- 2-2. session 권한 부여 -- 접속 권한,           만 주어짐
GRANT CREATE session, CREATE table, CREATE VIEW to usertest02;

-- 2-3. 현장에서 dba가 개발자 권한 부여
GRANT CONNECT, RESOURCE to usertest03;

-- 2-4. 권한을 줬다가 뺐기
GRANT DBA to usertest04;
-- 나중에 synonym 권한 주기 위해
-- DBA 권한 회수
REVOKE DBA FROM usertest04;
GRANT CONNECT, RESOURCE to usertest04;

-- system에서 스캇에 접속
-- 조회가 가능하다
-- system은 admin이기 때문이다
SELECT * FROM scott.emp;

----------------------------------------------------------------------------------------------------
-- 동의어(synonym)
-- 1. 정의 : 하나의 객체에 대해 다른 이름을 정의하는 방법
--      동의어와 별명(Alias) 차이점
--      동의어는 데이터베이스 전체에서 사용
--      별명은 해당 SQL 명령문에서만 사용
-- 2. 동의어의 종류
--   1) 전용 동의어(private synonym) 
--      객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로 해당 사용자만 사용
--
--   2) 공용 동의어(public sysnonym)
--      권한을 주는 사용자가 정의한 동의어로 누구나 사용
--      DBA 권한을 가진 사용자만 생성 (예 : 데이터 딕셔너리)
 
------------------------------------------------------------------------------------------------
-- 공용 동의어

CREATE TABLE systemTBL(
     memo varchar2(50)
     );
INSERT INTO systemTBL values('7월 푸름');
INSERT INTO systemTBL values('결실 맺으리라');

-- 스스로 조회 가능
SELECT * FROM systemTBL;

--systemt에 있는 systemTBL에 Read 권한 usertest04 주세요
GRANT SELECT ON system.systemTBL TO usertest04 WITH GRANT OPTION;
-- 권한 부여 했지만 번거로움
-- PUBLIC 이 공용
CREATE PUBLIC SYNONYM pub_system FOR systemTBL;
-- SYNONYM 삭제하는 것
DROP PUBLIC SYNONYM pub_system;

--실제로는 테이블명과 별명을 똑같이 만들어서 헷갈리지 않도록 한다
CREATE PUBLIC SYNONYM systemTBL FOR systemTBL;

-- 전용 동의어 

CREATE TABLE privateTBL(
     memo varchar2(50)
     );
INSERT INTO privateTBL values('나는 로우늬');
INSERT INTO privateTBL values('난 혜선이랑 민소매를 사랑해');

--systemt에 있는 privateTBL Read 권한 usertest04 주세요
GRANT SELECT ON system.privateTBL TO usertest04 WITH GRANT OPTION;
GRANT SELECT ON system.privateTBL TO scott WITH GRANT OPTION;

-- CREATE SYNONYM privateTBL FOR privateTBL;
create synonym privateTBL for system.privateTBL;
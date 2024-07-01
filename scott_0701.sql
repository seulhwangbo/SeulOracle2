-------------------------------------------------------------
------------            제약조건(Constraint)  *** ------------
--  정의  : 데이터의 정확성과 일관성을 보장
-- 1. 테이블 생성시 무결성 제약조건을 정의 가능
-- 2. 테이블에 대해 정의, 데이터 딕셔너리에 저장되므로 응용 프로그램에서 입력된 
--     모든 데이터에 대해 동일하게 적용
-- 3. 제약조건을 활성화, 비활성화 할 수 있는 융통성
-------------------------------------------------------------

-------------------------------------------------------------
------------  제약조건(Constraint)  종류      ***  ------------
-- 1 .NOT NULL  : 열이 NULL을 포함할 수 없음
-- 2. 기본키(primary key) : UNIQUE +  NOT NULL + 최소성  제약조건을 결합한 형태
-- 3. 참조키(foreign key) :  테이블 간에 외래 키 관계를 설정 ***
-- 4. CHECK : 해당 칼럼에 저장 가능한 데이터 값의 범위나 조건 지정
-------------------------------------------------------------
-- 1.  제약조건(Constraint) 적용 위한 강좌(subject) 테이블 인스턴스

-- rdb가 왜 RDB인가 ? 
-- FX **** : foreign key, 외래키 ****
-- emp => model 
-- 1. Restrict : 자식 존재 삭제 안됨  (연관 관계 때문)
--    1) 선언   Emp Table에서  REFERENCES DEPT (DEPTNO) 
--    2) 예시   integrity constraint (SCOTT.FK_DEPTNO) violated - child record found
DELETE dept
WHERE  deptno = 50; 
-- 자식이 있기 때문에 부모 객체를 삭제할 수 없는 경우이다 : 삭제 시 작업 없음

-- 2. 종속 삭제
-- 2. Cascading Delete : 같이 죽자
-- 1)종속삭제 선언 : Emp Table에서 REFERENCES DEPT (DEPTNO) ON DELETE CASCADE
DELETE dept
WHERE  deptno = 50; 

-- 3. 널 설정 
-- 3. SET NULL   
--    1) 종속 NULL 선언 : Emp Table에서 REFERENCES DEPT (DEPTNO)  ON DELETE SET NULL
-- 부모 객체가 자식 객체와의 관계를 끊은 후 삭제하는 경우
DELETE dept
WHERE  deptno = 50; 
-- *** rdb인지 확인할 수 있는 부분
-- rollback 시키면서 하기

CREATE TABLE subject(
    subno     NUMBER(5)    CONSTRAINT subject_no_pk PRIMARY KEY,
    subname   VARCHAR2(20) CONSTRAINT subject_name_nn not null,
    term      VARCHAR2(1)  constraint subject_term_ck check(term IN('1','2')),
    typeGubun VARCHAR2(1)
);

COMMENT ON COLUMN subject.subno   IS '수강번호';
COMMENT ON COLUMN subject.subname IS '수강과목';
COMMENT ON COLUMN subject.term    IS '학기';

INSERT INTO subject(subno, subname, term)
            VALUES  (10000, '컴퓨터개론', '1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10001, 'DB개론','2','1');
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10002, 'JSP개론','1','1');
            
--  PK Constraint : unique constraint (SCOTT.SUBJECT_NO_PK) violated           
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10001, 'Spring개론', '1','1');

--  PK Constraint : cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNO"
INSERT INTO subject(subname, term, typegubun)
            VALUES  ('Spring개론2', '1','1');
            
--  PK Constraint : cannot insert NULL into ("SCOTT"."SUBJECT"."SUBNAME")
INSERT INTO subject(subno, term, typegubun)
            VALUES  (10003, '1','1');
            
--  PK Constraint : CHECK Constraint
INSERT INTO subject(subno, subname, term, typegubun)
            VALUES  (10003, 'Spirng개론3', '5','1');
            
-- Table 선언시 못한것을 추후 정의 가능
-- Student Table 의 idnum을 unique로 선언
-- 선언한다고 해서 안에 있는 데이터를 바꾸지는 않기 때문에 중복키가 있으면 확인해야 한다
ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);

INSERT INTO student(studno, name, idnum)
            VALUES(30101, '대조영', '8412141254969');

-- unique constraint (SCOTT.STUD_IDNUM_UK) violated
-- UNIQUE 지정했기 때문에 중복이 불가하다는 점 확인하기
INSERT INTO student(studno, name, idnum)
            VALUES(30102, '강감찬', '8412141254969');

INSERT INTO student(studno, name)
            VALUES(30102, '강민첨' );
            
-- STUDENT TABLE의 name을 nn으로 선언
ALTER TABLE student 
MODIFY (name CONSTRAINT stud_name_nn NOT NULL);
        
INSERT INTO student(studno, idnum)
            Values(30103, '8012301036614')
;
 
-- WHERE이 없더라도 실행 가능하고 모든 제약 조건을 확인 가능하다
SELECT CONSTRAINT_name, CONSTRAINT_TYPE
FROM user_CONSTRAINTs
WHERE table_name IN('SUBJECT','STUDENT');

------------------------------------
-----      INDEX      *** ----------
--  인덱스는 SQL 명령문의 처리 속도를 향상(*) 시키기 위해 칼럼에 대해 생성하는 객체
--  인덱스는 포인트를 이용하여 테이블에 저장된 데이터를 랜덤 액세스하기 위한 목적으로 사용
--  [1]인덱스의 종류
--   1)고유 인덱스 : 유일한 값을 가지는 칼럼에 대해 생성하는 인덱스로 모든 인덱스 키는
--                  테이블의 하나의 행과 연결
CREATE UNIQUE INDEX idx_dept_name
ON     department(dname);

INSERT INTO department VALUES(300, '이과대학',10,'KKK');
-- ORA-00001: unique constraint (SCOTT.IDX_DEPT_NAME) violated
INSERT INTO department(deptno, dname, college, loc) VALUES(301, '이과대학',10,'KKK2');

-- 비고유 인덱스 birthdate --> constraint X, 성능에만 영향을 미친다
-- 2> 비고유 인덱스
-- 문>학생 테이블의 birthdate 칼럼을 비고유 인덱스로 생성하여라
CREATE INDEX idx_stud_birthdate
ON     student(birthdate);

INSERT INTO student ( studno, name, idnum , birthdate)
            Values  ( 30102, '김유신', '8012301036614', '84/09/16');

SELECT * 
FROM   Student
WHERE  birthdate = '84/09/16'
;
-- 인덱스 걸려서 찾음

--   3)단일 인덱스 :  하나의 컬럼에 하나를 생성하는 것이 단일 인덱스이다
--   4)결합 인덱스 :  두 개 이상의 칼럼을 결합하여 생성하는 인덱스
--     문) 학생 테이블의 deptno, grade 칼럼을 결합 인덱스로 생성
--          결합 인덱스의 이름은 idx_stud_dno_grade 로 정의
CREATE INDEX idx_stud_dno_grade
ON student(deptno, grade); 

-- Optimizer
-- RGO, CBO
-- RBO 변경
ALTER SESSION SET OPTIMIZER_MODE = RULE;
-- rule based optimizer == 인덱스에 따라서 하는 소세지
-- cost based optimizer == 인덱스가 있다고 하더라도 row 갯수를 자신이 알아서 평가
-- 알아서 full scan을 뜰 때도 있다
-- ROW가 작더라도 이젠 무조건 INDEX 참조를 하게 된다 =RULE로 걸었을 때
SELECT *
FROM  student
WHERE deptno = 101
AND   grade  = 2
--WHERE grade =2
--AND   deptno = 101
--;
;

SELECT *
FROM  student
WHERE grade =2
AND   deptno = 101
;

-- 위와 아래의 options를 비교하면서 성능 튜닝에 대한 감을 잡는 것이 중요하다
-- 하나는 순서대로 하나는 순서에 맞추지 않고 돌린 것이다
-- 뒤 바꾼 경우에는 인덱스를 타고 sorting 후 가지고 온 후 다른 인덱스를 또 타기 때문에
-- 순서대로 sql을 하지 않으면 성능 차이가 크게 난다

ALTER SESSION SET optimizer_mode = rule
ALTER SESSION SET optimizer_mode = CHOOSE
ALTER SESSION SET optimizer_mode = first_rows
ALTER SESSION SET optimizer_mode = ALL_ROWS
-- 아래 3가지는 CBO / 위 하나만 RBO
-- 다 가지고 왔을 때만 화면에 보여 주는 것이 ALL_ROWS 
-- 눈에 보일 수 있는 정도만 가지고 와도 보여주는 것이 FIRST_ROWS: 성능이 제일 빠르다
-- 요새 DB는 기본이 CBO로 되어있다

-- SQL Optimizer
SELECT /*+first rows*/ ename FROM emp;
-- 힌트문
-- 인덱스와 힌트문을 이용해서 최적의 방향을 찾는다
-- CBO로 처리를 하는 명령문
SELECT /*+rule*/ ename FROM emp;
-- RBO로 처리를 하는 명령문

-- optimizer mode 확인하는 방법
SELECT NAME, VALUE, ISDEFAULT, ISMODIFIED, DESCRIPTION
FROM   V$SYSTEM_PARAMETER
WHERE  NAME LIKE '%optimizer_mode%'
;

-- [2]인덱스가 효율적인 경우 : 제일 좋은 케이스의 항목
--   1) WHERE 절이나 조인 조건절에서 자주 사용되는 칼럼
--   2) 전체 데이터중에서 10~15%이내의 데이터를 검색하는 경우
--   3) 두 개 이상의 칼럼이 WHERE절이나 조인 조건에서 자주 사용되는 경우
--   4) 테이블에 저장된 데이터의 변경이 드문 경우
--   5) 열에 널 값이 많이 포함된 경우, 열에 광범위한 값이 포함된 경우
--------------------------------------------------------------
-- 인덱스를 사용하면 SELECT는 빨라지지만 INSERT, DELETE, UPDATE 는 성능이 느려진다
-- 대량의 데이터를 입력하는 것은 데이터 컨버젼 뿐이다
-- 그래서 데이터 컨버젼 할 때는 인덱스를 잠시 죽인다
-- 인덱스 -> 오른쪽 마우스 -> 사용 불가로 설정해서 잠시 죽이고 컨버전을 이용한다
-- 일반적으로는 한칸씩 하기 때문에 TRADE-OFF 가 일어난다고 해도 
-- SELECT의 성능이 더 중요해진다
-- 성능에 영향을 미친다고 하는 것은 
-- SELECT ==> 인덱스를 건다는 것은 SELECT의 성능을 향상시킨다는 뜻이다

-- 인덱스가 깨질 수 있기 때문에 재구성 하는 과정이 필요하다
-- 학생 테이블에 생성된 PK_DEPTNO 인덱스를 재구성
ALTER INDEX PK_DEPTNO REBUILD;
-- 권장사항 한테이블에 7개의 인덱스 이상을 걸지 말아라

-- 1. INDEX 조회
SELECT index_name, table_name, column_name
FROM   user_ind_columns;

-- 2. INDEX 생성 EMP(JOB)
CREATE INDEX idx_emp_job ON emp(job);

-- 3. 조회 : OK와 NO가 어떨 때 차이가 있는지 확인하기
ALTER session set optimizer_mode = rule;
SELECT * FROM emp WHERE job = 'MANAGER'; -- = Index OK
-- 들어가 있는 값은 대소문자를 구별하고 명령어만 대소문자를 구별하지 않는다
SELECT * FROM emp WHERE job <> 'MANAGER'; -- = 부정형 INDEX NO
-- 인덱스가 어떤 경우에는 타고, 어떤 경우에는 안 타는지 구분할 필요가 있다

SELECT * FROM emp WHERE job LIKE'%NA%'; -- = LIKE '%NA%' INDEX NO 
SELECT * FROM emp WHERE job LIKE 'MA%'; -- = LIKE 'MA%'  INDEX OK
-- 처음에 %가 있으면 인덱스가 걸리지 않지만 처음에는 걸지 않고 처음에는 단어를 넣으면 인덱스를 탄다
-- 인덱스는 무조건 성능 이야기를 해야 해서 튜닝하고 함께 간다

SELECT * FROM emp WHERE UPPER(job) = 'MANAGER'; -- = Index NO

-- INDEX를 가능하게 하는 방법
--   5)함수 기반 인덱스(FBI) function based index
--      오라클 8i 버전부터 지원하는 새로운 형태의 인덱스로 칼럼에 대한 연산이나 함수의 계산 결과를 
--      인덱스로 생성 가능
--      UPPER(column_name) 또는 LOWER(column_name) 키워드로 정의된
--      함수 기반 인덱스를 사용하면 대소문자 구분 없이 검색
CREATE INDEX uppercase_idx ON emp (UPPER(job));
--      함수를 생성하고 그 함수를 인덱스를 걸 수 있다
SELECT * FROM emp WHERE UPPER(job) =  'SALESMAN';
--  대소문자 구별이 입력시에는  발생할 수도 있기 때문에 확인 필요
--  UPPER JOB이 FBI로 인덱스가 걸려있고, 그 사오항에서 EXECUTE를 하면 .. ?
--  함수만 타고 FBI를 타는가? 보통은 FBI를 탄다

---------------------------------------------------------------------------------
-- 트랜잭션 개요  ***
-- 관계형 데이터베이스에서 실행되는 여러 개의 SQL명령문을 하나의 논리적 작업 단위로 처리하는 개념
-- COMMIT : 트랜잭션의 정상적인 종료
--               트랜잭션내의 모든 SQL 명령문에 의해 변경된 작업 내용을 디스크에 영구적으로 저장하고 
--               트랜잭션을 종료
--               해당 트랜잭션에 할당된 CPU, 메모리 같은 자원이 해제
--               서로 다른 트랜잭션을 구분하는 기준
--               COMMIT 명령문 실행하기 전에 하나의 트랜잭션 변경한 결과를
--               다른 트랜잭션에서 접근할 수 없도록 방지하여 일관성 유지
 
-- ROLLBACK : 트랜잭션의 전체 취소
--                   트랜잭션내의 모든 SQL 명령문에 의해 변경된 작업 내용을 전부 취소하고 트랜잭션을 종료
--                   CPU,메모리 같은 해당 트랜잭션에 할당된 자원을 해제, 트랜잭션을 강제 종료
---------------------------------------------------------------------------------

----------------------------------
-- SEQUENCE ***
-- 유일한 식별자
-- 기본 키 값을 자동으로 생성하기 위하여 일련번호 생성 객체
-- 예를 들면, 웹 게시판에서 글이 등록되는 순서대로 번호를 하나씩 할당하여 기본키로 지정하고자 할때 
-- 시퀀스를 편리하게 이용
-- 여러 테이블에서 공유 가능  -- > 일반적으로는 개별적 사용 
----------------------------------
-- 1) SEQUENCE 형식
--CREATE SEQUENCE sequence
--[INCREMENT BY n]
--[START WITH n]
--[MAXVALUE n | NOMAXVALUE]
--[MINVALUE n | NOMINVALUE]
--[CYCLE | NOCYCLE]
--[CACHE n | NOCACHE];
--INCREMENT BY n : 시퀀스 번호의 증가치로 기본은 1,  일반적으로 ?1 사용
--START WITH n : 시퀀스 시작번호, 기본값은 1
--MAXVALUE n : 생성 가능한 시퀀스의 최대값
--MAXVALUE n : 시퀀스 번호를 순환적으로 사용하는 cycle로 지정한 경우, MAXVALUE에 도달한 후 새로 시작하는 시퀀스값
--CYCLE | NOCYCLE : MAXVALUE 또는 MINVALUE에 도달한 후 시퀀스의 순환적인 시퀀스 번호의 생성 여부 지정
--CACHE n | NOCACHE : 시퀀스 생성 속도 개선을 위해 메모리에 캐쉬하는 시퀀스 개수, 기본값은 20

-- 2) SEQUENCE sample 예시
CREATE SEQUENCE sample_seq
INCREMENT BY 1
START WITH   10000;

-- SEQUENCE 가지고 오는 법
-- 아래는 시퀀스를 볼 때마다 하나씩 증가시키게 된다
SELECT sample_seq.nextval FROM dual;
SELECT sample_seq.CURRVAL FROM dual;
-- current value
-- 증가시키지 말고 현재의 시퀀스를 돌려 달라는 뜻이다

-- 3) SEQUENCE sample 예시 2 ==> 실사용 예시
CREATE SEQUENCE dept_dno_seq
INCREMENT BY 1
START WITH  76;

-- 4) SEQUENCE dept_dno_seq를 이용 dept_second 입력 --> 실 사용 예시
-- dept second
INSERT INTO dept_second
VALUES(dept_dno_seq.NEXTVAL, 'Accounting','NEW YORK');
SELECT dept_dno_seq.CURRVAL FROM dual;

-- 77, '회계', '이대'
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, '회계','이대');
SELECT dept_dno_seq.CURRVAL FROM dual;

-- 78, '인사팀', '당산'
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, '인사팀','당산');
SELECT dept_dno_seq.CURRVAL FROM dual;


-- max 전환
INSERT INTO dept_second
VALUES((SELECT MAX(DEPTNO)+1 FROM dept_second)
    , '경영팀'
    , '대림'
    );
-- 섞어서 쓰면 안된다 그러면 UNIQUE CONSTRAINT VIOLATED  
INSERT INTO dept_second
VALUES (dept_dno_seq.NEXTVAL, '인사팀','당산');

-- sequence 삭제
DROP SEQUENCE SAMPLE_SEQ;

-- DATA 사전에서 정보 조회
SELECT sequence_name, min_value, max_value, increment_by
FROM   user_sequences;

-- hw

------------------------------------------------------
----               Table 조작                     ----
------------------------------------------------------
-- 1.Table 생성
CREATE TABLE address
( id    NUMBER(3),
  Name  VARCHAR2(50),
  addr  VARCHAR2(100),
  phone VARCHAR2(30),
  email VARCHAR2(100)
);

INSERT INTO ADDRESS
VALUES(1,'HGBONG','SEOUL','123-4567','gbhong@naver.com');
---    Homework
-- 문1) address스키마/Data 유지하며     addr_second Table 생성 
CREATE UNIQUE INDEX addr_second
ON address(id, name, addr, phone,email);

-- 문2) address스키마 유지하며  Data 복제 하지 않고   addr_seven Table 생성
CREATE INDEX addr_seven
ON address(addr);

-- 문3) address(주소록) 테이블에서 id, name 칼럼만 복사하여 addr_third 테이블을 생성하여라
CREATE INDEX addr_third
ON address(id,name);
-- 문4) addr_second 테이블 을 addr_tmp로 이름을 변경 하시요
ALTER index ADDR_SECOND RENAME TO addr_tmp
;
------------------------------------------------------------------
-----     데이터 사전
-- 1. 사용자와 데이터베이스 자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블의 집합
-- 2. 사전 내용의 수정은 오라클 서버만 가능
-- 3. 오라클 서버는 데이타베이스의 구조, 감사, 사용자 권한, 데이터 등의 변경 사항을 반영하기 위해
--    지속적 수정 및 관리
-- 4. 데이타베이스 관리자나 일반 사용자는 읽기 전용 뷰에 의해 데이터 사전의 내용을 조회만 가능
-- 5. 실무에서는 테이블, 칼럼, 뷰 등과 같은 정보를 조회하기 위해 사용

------------------------------------------------------------------

------------------------------------------------------------------
-----     데이터 사전 관리 정보
-- 1.데이터베이스의 물리적 구조와 객체의 논리적 구조
-- 2. 오라클 사용자 이름과 스키마 객체 이름
-- 3. 사용자에게 부여된 접근 권한과 롤
-- 4. 무결성 제약조건에 대한 정보
-- 5. 칼럼별로 지정된 기본값
-- 6. 스키마 객체에 할당된 공간의 크기와 사용 중인 공간의 크기 정보
-- 7. 객체 접근 및 갱신에 대한 감사 정보
-- 8.데이터베이스 이름, 버전, 생성날짜, 시작모드, 인스턴스 이름

------------------------------------------------------------------
--       데이터 사전 종류
-- 1. USER_ : 객체의 소유자만 접근 가능한 데이터 사전 뷰
-- user_tables는 사용자가 소유한 테이블에 대한 정보를 조회할 수 있는 데이터 사전 뷰.

SELECT table_name
FROM   user_tables;

SELECT *
FROM user_catalog;

-- 2. ALL_    : 자기 소유 또는 권한을 부여 받은 객체만 접근 가능한 데이터 사전 뷰
SELECT owner, table_name
FROM all_tables;

-- 3. DBA_   : 데이터베이스 관리자만 접근 가능한 데이터 사전 뷰
SELECT owner, table_name
FROM   dba_tables;S
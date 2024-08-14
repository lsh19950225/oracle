-- SCOTT
-- 1) 게시판 테이블 생성 : tbl_board
-- 2) 컬럼 : 글번호, 작성자, 비밀번호, 제목, 내용, 작성일, 조회수 x 등등..
-- [GLOBAL TEMPORARY] 임시 테이블 : 로그아웃시 삭제됨.
CREATE TABLE scott.tbl_board -- scott. : 생략 가능.
(
 seq NUMBER(38) NOT NULL PRIMARY KEY
 , writer VARCHAR2(20) NOT NULL
 , password VARCHAR2(15) NOT NULL -- 작성자 판가름에 필요. 따라서 NOT NULL
 , title VARCHAR2(100) NOT NULL
 , content CLOB
 , regdate DATE DEFAULT SYSDATE -- 자동으로 오늘날짜로 저장.
);
-- Table SCOTT.TBL_BOARD이(가) 생성되었습니다.

-- 시퀀스(SEQUENCE) : 번호표 같은 의미 / 시퀀스란 기존의 테이블에 대해 기본키나 유니크 키를 사용하여 부가하는
-- 일종의 새로운 컬럼처럼 사용할 수 있는 일련번호를 매김하기 위한 하나의 컬럼으로 구성된 테이블과 같다.
-- seq 글 번호에 사용할 시퀀스 생성.
CREATE SEQUENCE seq_tblboard
--    INCREMENT BY 1 -- 1씩 증가하겠다.
--    START WITH 1 -- 1부터 시작
    -- [ MAXVALUE n ? NOMAXVALUE]
	-- [ MINVALUE n ? NOMINVALUE] START 후 맥스값으로 사이클 돌고 미니값으로 돌아감.
    -- [ CYCLE ? NOCYCLE]
    NOCACHE;
-- Sequence SEQ_TBLBOARD이(가) 생성되었습니다.
SELECT *
FROM user_sequences; -- 시퀀스 확인.
--
SELECT *
FROM tabs
WHERE table_name LIKE 'TBL_B%';
-- DDL
CREATE TABLE
ALTER TABLE
DROP TABLE tbl_board CASCADE;

-- 게시글 쓰기(작성) 쿼리 작성.
-- ORA-08002: sequence SEQ_TBLBOARD.CURRVAL is not yet defined in this session
-- ㄴ NEXTVAL이 시작돼야 조회가 가능하다.
SELECT seq_tblboard.CURRVAL
FROM dual;

-- ORA-01400: cannot insert NULL into ("SCOTT"."TBL_BOARD"."SEQ") : NOT NULL 값은 다 줘야됨.
INSERT INTO tbl_board (seq,writer,password,title,content) VALUES (seq_tblboard.NEXTVAL,'이시훈','1234','TEST-1','TEST-1');

INSERT INTO tbl_board (seq,writer,password,title,content) VALUES (seq_tblboard.NEXTVAL,'홍길동','1234','TEST-2','TEST-2');

INSERT INTO tbl_board VALUES (seq_tblboard.NEXTVAL,'송세호','1234','TEST-3','TEST-3',SYSDATE);

INSERT INTO tbl_board (seq,writer,password,title) VALUES (seq_tblboard.NEXTVAL,'원충희','1234','TEST-4');
COMMIT;

SELECT *
FROM tbl_board;

SELECT seq, subject, writer, TO_CHAR(regdate,'YYYY-MM-DD') regdate, readed
FROM tbl_board
ORDER BY seq DESC;

-- seq NOT NULL, PRIMARY KEY
-- NN
SELECT *
FROM user_constraints -- 제약조건 조회.
WHERE table_name = UPPER('tbl_board');
-- 제약조건 이름을 주지 않으면 SYS_XXXXXXX 이름으로 자동 부여.
-- P : PRIMARY KEY / C : NOT NULL 로 표시.

-- 조회수 컬럼 추가.
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0;

-- 1 : 1	TEST-1	이시훈	2024-08-14	0 게시글의 제목을 클릭. (상세보기)
-- 1) 조회수 1증가
-- 2) 게시글(seq)의 정보를 조회.

UPDATE tbl_myboard
SET readed = readed + 1 -- ***
WHERE seq = 1;

ROLLBACK;

SELECT *
FROM tbl_myboard
WHERE seq = 1;

-- 게시판의 작성자 writer 컬럼 20 -> 40 size 확장
-- 컬럼의 자료형의 크기를 수정

-- 제약조건 수정할 수 없다. / 수정필요할 시 : (삭제 -> 생성)
ALTER TABLE tbl_board
MODIFY (writer VARCHAR2(40));
--
DESC tbl_board;

-- 컬럼명을 수정 title -> subject
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- 수정할 때의 날짜 정보를 저장할 컬럼을 추가. lastRegdate
ALTER TABLE tbl_board
ADD (
 lastRegdate DATE
);

SELECT seq, subject, writer, TO_CHAR(regdate,'YYYY-MM-DD') regdate, readed, lastRegdate
FROM tbl_board
ORDER BY seq DESC;
--
UPDATE tbl_board
SET subject = '제목수정-3',content = '내용수정-3',lastRegdate = SYSDATE
WHERE seq = 3;

COMMIT;

SELECT *
FROM tbl_board;

-- lastregdate 컬럼 삭제
ALTER TABLE tbl_board
DROP COLUMN lastRegdate;

-- tbl_board -> tbl_myboard 테이블명 수정
RENAME tbl_board TO tbl_myboard;

SELECT *
FROM tbl_myboard;

-- [테이블 생성하는 방법]
1. CREATE TABLE 생성
2. subquery 를 이용한 테이블 생성.
    - 기존 이미 존재하는 테이블을 이용해서 새로운 테이블 생성 (+ 레코드 추가)
    - CREATE TABLE 테이블명 [컬럼명,..]
    AS (서브쿼리); -- 컬럼명의 수 = 서브쿼리 컬럼명의 수 / 컬럼명 생략 시 서브쿼리의 컬럼명으로 테이블 생성.
    
-- 예) emp 테이블로 부터 30번 사원들만 새로운 테이블 생성.
CREATE TABLE tbl_emp30 (eno,ename,hiredate,job,pay)
AS (
SELECT empno, ename, hiredate, job, sal+NVL(comm,0) pay
FROM emp
WHERE deptno = 30
);
-- Table TBL_EMP30이(가) 생성되었습니다.
DESC tbl_emp30; -- pay 시스템이 자동으로 넘버로 잡음.

-- TBL_EMP30 : 제약조건은 복사되지 않는다.
SELECT *
FROM user_constraints -- 제약조건 조회.
WHERE table_name IN ('EMP','TBL_EMP30'); -- 제약조건 R : 참조키(포링키)

-- emp -> 새로운 테이블 생성할 때 / 데이터 복사 안하고
CREATE TABLE tbl_empcopy
AS(
SELECT *
FROM emp
WHERE 1 = 0 -- 항상 거짓. -- 테이블 구조는 그대로 복사하되 데이터(레코드)는 필요없을 시.
);

DROP TABLE tbl_emp30;

SELECT *
FROM tbl_empcopy;

DROP TABLE tbl_empcopy;

DROP TABLE tbl_char;
DROP TABLE tbl_example;
DROP TABLE tbl_myboard;
DROP TABLE tbl_nchar;
DROP TABLE tbl_number;
DROP TABLE tbl_pivot;
DROP TABLE tbl_tel;
-- SQL 확장 => PL/SQL

-- [문제] emp, dept, salgrade 테이블을 이용해서 deptno, dname, empno, ename, hiredate, pay, grade 컬럼을
-- 가진 새로운 테이블 생성 (tbl_empgrade)
-- 3개 테이블 조인.
--SELECT t.deptno, t.dname, t.empno, t.hiredate, t.pay, s.grade
--FROM (
--SELECT d.deptno, dname, empno, hiredate, sal+NVL(comm,0) pay, sal
--FROM dept d, emp e
--WHERE d.deptno = e.deptno
--) t, salgrade s
--WHERE t.sal BETWEEN s.losal AND s.hisal; -- 좋지않음.
CREATE TABLE tbl_empgrade
AS
(
SELECT d.deptno, d.dname, e.empno, e.hiredate, sal+NVL(comm,0) pay, s.grade
FROM emp e, dept d, salgrade s -- .., .., ..
WHERE d.deptno = e.deptno AND e.sal BETWEEN s.losal AND s.hisal
);
-- 조인 3개 후 서브쿼리로 테이블 생성.
SELECT *
FROM tbl_empgrade;

-- 유료는 휴지통으로가서 비우기 안하면 복원 가능하다.
DROP TABLE tbl_empgrade; -- 휴지통 이동.
PURGE RECYCLEBIN; -- 휴지통 비우기.
DROP TABLE tbl_empgrade PURGE; -- 휴지통으로 이동하지 않고 완전히 삭제.

-- JOIN ~ ON 구문 수정.
CREATE TABLE tbl_empgrade
AS
(
SELECT d.deptno, d.dname, e.empno, e.hiredate, sal+NVL(comm,0) pay
    , s.losal || '~' || s.hisal sal_range, s.grade
FROM emp e JOIN dept d ON d.deptno = e.deptno
    JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
);

SELECT *
FROM tbl_empgrade;

-- emp 테이블의 구조만 복사해서 새로운 tbl_emp 테이블 생성.
CREATE TABLE tbl_emp
AS
(
SELECT *
FROM emp
WHERE 1 = 0
);
--
SELECT *
FROM tbl_emp;
-- emp 테이블의 10번 부서원들을 tbl_emp 테이블에 INSERT 작업..
-- DIRECT LOAD INSERT에 의한 ROW 삽입
INSERT INTO tbl_emp SELECT * FROM emp WHERE deptno = 10;
COMMIT;

INSERT INTO tbl_emp (empno, ename)SELECT empno, ename FROM emp WHERE deptno = 20;
COMMIT;

DROP TABLE tbl_emp;

-- [다중 INSERT 문 4가지]
-- 1) Unconditional INSERT ALL 문 - 조건이 없는 INSERT ALL
CREATE TABLE tbl_emp10 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp20 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp30 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp40 AS (SELECT * FROM emp WHERE 1 = 0);
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
--
SELECT * FROM tbl_emp30;

ROLLBACK;
-- 위의 쿼리 4개를 한 번에 처리
-- Unconditional INSERT ALL 문 - 조건이 없는 INSERT ALL
INSERT ALL
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- SQL 오류: ORA-00947: not enough values : 값이 충분하지않다.
INSERT ALL 
INTO tbl_emp10 (컬럼명,컬럼명..) VALUES (empno,ename,job,mgr)
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate)
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm)
SELECT *
FROM emp;
--
-- 2. Conditional INSERT ALL 문 - 조건이 있는 INSERT ALL 문
INSERT ALL
WHEN deptno = 10 THEN
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 20 THEN
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
ELSE
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- 3. conditional first insert 문 - 조건이 있는 first
INSERT FIRST -- = ELSE IF 문
WHEN deptno = 10 THEN
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN sal >= 2500 THEN
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
ELSE
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- 4. Pivoting insert 문
CREATE TABLE tbl_sales(
    employee_id        number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2)
);

insert into tbl_sales values(1101,4,100,150,80,60,120);
insert into tbl_sales values(1102,5,300,300,230,120,150);
COMMIT;
--
SELECT *
FROM tbl_sales;
--
create table tbl_salesdata(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2)
);
-- Pivoting insert 문
insert all
  into tbl_salesdata values(employee_id, week_id, sales_mon)
  into tbl_salesdata values(employee_id, week_id, sales_tue)
  into tbl_salesdata values(employee_id, week_id, sales_wed)
  into tbl_salesdata values(employee_id, week_id, sales_thu)
  into tbl_salesdata values(employee_id, week_id, sales_fri)
select employee_id, week_id, sales_mon, sales_tue, sales_wed,
    sales_thu, sales_fri
from tbl_sales;

SELECT *
FROM tbl_salesdata;
--
DROP TABLE TBL_EMP10;
DROP TABLE TBL_EMP20;
DROP TABLE TBL_EMP30;
DROP TABLE TBL_EMP40;
DROP TABLE tbl_sales;
DROP TABLE tbl_salesdata;

-- DELECT 문,   DROP TABLE 문,   TRUNCATE 문 차이점.
-- 레코드 삭제    테이블 삭제       레코드 모두 삭제
-- DML 문        DDL 문          DML 문

-- TRUNCATE TABLE 테이블명; -- 자동 커밋 : 롤백이 불가.

-- DELECT FROM 테이블명; -- 커밋/롤백을 해야 완벽히 처리됨.
-- WHERE 조건절이 없으면 모든 레코드 삭제.

-- [문제] insa 테이블에서 num, name 데이터 컬럼만을 복사해서 새로운 테이블 tbl_score 테이블 생성
CREATE TABLE tbl_score
AS (
SELECT num, name
FROM insa
WHERE num <= 1005
);

SELECT *
FROM tbl_score;
-- [문제] tbl_score 테이블에 kor,eng,mat,tot,avg,grade,rank 컬럼 추가.
ALTER TABLE tbl_score
ADD
(
    kor NUMBER(3) DEFAULT 0
    , eng NUMBER(3) DEFAULT 0
    , mat NUMBER(3) DEFAULT 0
    , tot NUMBER(3) DEFAULT 0
    , avg NUMBER(5,2) DEFAULT 0 -- 소수점도 자릿수로 포함.
    , grade CHAR(3)
    , rank NUMBER(3)
);

DESC tbl_score;

-- [문제] 100~1005 모든 학생의 국,영,수 점수를 임의의 정수를 발생시켜서 수정
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET tbl_score IN (kor,eng,mat) AND FLOOR(dbms_random.values(0,101))
WHERE num BETWEEN 1000 AND 1005;

UPDATE tbl_score
SET kor = FLOOR(dbms_random.value(0,101))
    , eng = FLOOR(dbms_random.value(0,101))
    , mat = FLOOR(dbms_random.value(0,101));

COMMIT;

-- 1001번 국영수 1005번
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;
-- [문제] 모든 학생의 총점, 평균 UPDATE
UPDATE tbl_score
SET tot = kor+eng+mat
    , avg = (kor+eng+mat)/3;
-- [문제] 모든 학생의 등수 UPDATE
UPDATE tbl_score m
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > m.tot);

SELECT num, tot
    , (SELECT COUNT(*) FROM tbl_score WHERE tot > m.tot) rank
FROM tbl_score m;
-- 순위 함수에 의해서 등수 처리..
SELECT num, tot
    , RANK() OVER(ORDER BY tot DESC) rank
FROM tbl_score;
--
UPDATE tbl_score p
-- SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot );
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );
--
SELECT *
FROM tbl_score;
-- [문제] 등급 수정(처리) avg 90 이상 '수'
UPDATE tbl_score
SET grade = CASE
        WHEN avg >= 90 THEN '수'
        WHEN avg >= 80 THEN '우'
        WHEN avg >= 70 THEN '미'
        WHEN avg >= 60 THEN '양'
        ELSE '가'
    END;

UPDATE tbl_score
SET grade = DECODE(FLOOR(avg/10),10,'수',9,'수',8,'우',7,'미',6,'양','가');

ROLLBACK;
COMMIT;
--
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ;
-- [문제] 모든 학생의 영어 점수를 40점 +
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET eng = CASE
            WHEN eng + 40 > 100 THEN 100
            ELSE eng + 40
        END;
-- 남학생의 국어 점수를 -5 감소
UPDATE tbl_score
SET kor = CASE
        WHEN kor - 5 < 0 THEN 0
        ELSE kor - 5
    END
WHERE num = ANY (SELECT num
    FROM insa
    WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2) = 1);
--
WHERE num IN (SELECT num
    FROM insa
    WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2) = 1);
--
COMMIT;

-- [문제] result 컬럼 추가 국영수 40 안되면 과락 평균 60 합격 외 불합격
ALTER TABLE tbl_score
ADD (
    result VARCHAR2(10)
);

UPDATE tbl_score
SET result = CASE
            WHEN kor <= 40 OR eng <= 40 OR mat <= 40 THEN '과락'
            WHEN avg >= 60 THEN '합격'
            ELSE '불합격'
END;

SELECT *
FROM tbl_score;

--------------------------------------------------------------------------------
DROP TABLE TBL_SCORE PURGE;
--
create table tbl_emp(
  id        number primary key
  , name    varchar2(10) not null
  , salary  number
  , bonus   number default 100
);

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);

COMMIT;

select * from tbl_emp;

create table tbl_bonus (id number, bonus number default 100);

insert into tbl_bonus(id)
    (select e.id from tbl_emp e);
    
COMMIT;

SELECT *
FROM tbl_bonus;

INSERT INTO tbl_bonus VALUES (1004,50);
1001	100
1002	100
1003	100
1004	50
-- MERGE : 병합.
MERGE INTO tbl_bonus b
USING (SELECT id,salary FROM tbl_emp) e -- tbl_emp 와도 상관 없음.
ON (b.id = e.id)
WHEN MATCHED THEN
UPDATE SET b.bonus = b.bonus + e.salary * 0.01
-- WHERE : 하나라 필요없음.
WHEN NOT MATCHED THEN
INSERT (b.id,b.bonus) VALUES (e.id,e.salary * 0.01);
--
-- 제약조건
-- 조인
-- 뷰
-- 계층적 질의

-- DB모델링(정규화) 1~2일. ERD
-- PL/SQL 2일.




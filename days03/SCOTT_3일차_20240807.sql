-- SCOTT
-- 날짜 다루는 : DATE     TIMESTAMP
-- 오름차순 정렬 (가나다 순)
SELECT DISTINCT buseo
FROM insa
ORDER BY buseo; -- 생략하면 오름차순이 기본.
ORDER BY buseo DESC; -- 내림차순
ORDER BY buseo ASC; -- 오름차순

 -- emp 급여 많이 받는 순 정렬
SELECT deptno, ename, sal + NVL(comm,0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC; -- 칼럼 명을 줘도 되고, 칼럼 순서도 가능.
ORDER BY deptno ASC, pay DESC; -- 2차 정렬 : 부서 오름차순, pay로 내림차순
ORDER BY pay DESC;

-- 8 ㄱ.
SELECT deptno, ename, sal + NVL(comm,0) pay
FROM emp
WHERE (sal + NVL(comm,0) BETWEEN 1000 AND 3000) AND deptno != 30;
ORDER BY emame;
-- 8 ㄴ.
SELECT *
FROM (
    SELECT deptno, ename, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno != 30
    ) e
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename;
-- 8 ㄷ.
WITH temp AS (
    SELECT deptno, ename, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno != 30
            )
SELECT *
FROM temp
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename;

-- 9.
SELECT *
FROM emp
WHERE mgr IS NULL;
-- 10.
DESC emp;
-- MGR               NUMBER(4) : 정수형 숫자
SELECT e.*
    , NVL(TO_CHAR(mgr),'CEO')
FROM emp e
WHERE mgr IS NULL;
-- 19.
SELECT ssn
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'MM') month
    , EXTRACT(DAY FROM TO_DATE(SUBSTR(ssn,0,6))) "DATE"
FROM insa;
-- 20.
SELECT name, ssn
FROM insa
-- WHERE ssn LIKE '7_12%'
WHERE REGEXP_LIKE(ssn,'^7\d12')
ORDER BY ssn ASC;
-- 21 ㄱ.
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_____-1%';
WHERE ssn LIKE '7%' AND SUBSTR(ssn,8,1) = 1;
-- 21 ㄴ.
SELECT name, ssn
FROM insa
-- 1 3 5 7 9 남자
-- WHERE SUBSTR(ssn,8,1) = 1 OR SUBSTR(ssn,8,1) = 3 OR SUBSTR(ssn,8,1) = 5
        -- OR SUBSTR(ssn,8,1) = 7 OR SUBSTR(ssn,8,1) = 9;
-- WHERE ssn LIKE '______-1%' OR ssn LIKE '______-3%' OR ssn LIKE '______-5%'
        -- OR ssn LIKE '______-7%' OR ssn LIKE '______-9%';
WHERE REGEXP_LIKE(ssn,'^7\d{5}-1'); -- {5}개가 온다.
WHERE REGEXP_LIKE(ssn,'^7') AND SUBSTR(ssn,8,1) = 1;
-- 1 3 5 7 9 남자
SELECT e.*
    , SUBSTR(ssn,-7,1) GENDER
    -- , SUBSTR(ssn,-7,1) % 2 -- ORA-00911: invalid character
    , MOD(SUBSTR(ssn,-7,1),2) -- MOD : 나머지 값 구하는 함수
FROM insa e
WHERE REGEXP_LIKE( ssn , '^7\d{5}-[13579]' );
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1),2) = 1;
-- 22.
SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- i : 대소문자 구분하지 않는다.,g,m
WHERE ename LIKE '%' || UPPER('la') || '%';
WHERE ename LIKE '%%'; -- 이것도 다 나옴 : 오류 나지 않는다. - 의미 파악
WHERE LOWER(ename) LIKE '%la%';
-- 23.
-- PL/SQL(DQL) : SELECT
-- NULLIF : 첫번째 값과 두번째 값을 비교하여 두 값이 같으면 NULL을 출력하고, 
--          같지 않으면 첫번째 값을 출력한다.
SELECT name, ssn
    , NVL2(NULLIF(MOD(SUBSTR(ssn,8,1),2),1),'O','X') GENDER
FROM insa;
-- DECODE() 함수 안배움
-- CASE() 함수 안배움
-- 24.
DESC insa;
-- ibsadate : DATE 날짜형
SELECT name, ibsadate
    -- 날짜형 -> 년도
    , TO_CHAR(SYSDATE, 'YYYY') y
    , TO_CHAR(SYSDATE, 'MM') m
    , TO_CHAR(SYSDATE, 'DD') d
    , TO_CHAR(SYSDATE, 'HH') h
    , TO_CHAR(SYSDATE, 'MI') m
    , TO_CHAR(SYSDATE, 'SS') s
FROM insa;
-- WHERE 입사년도가 2000년 이후;
-- 현재 시스템의 날짜로 부터 년, 월, 일, 시, 분, 초 출력
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'YYYY') y
    , TO_CHAR(SYSDATE, 'MM') m
    , TO_CHAR(SYSDATE, 'DD') d
    , TO_CHAR(SYSDATE, 'HH') h
    , TO_CHAR(SYSDATE, 'MI') m
    , TO_CHAR(SYSDATE, 'SS') s
FROM dual;
--
SELECT SYSDATE
    , EXTRACT(YEAR FROM SYSDATE) y
    , EXTRACT(MONTH FROM SYSDATE) m
    , EXTRACT(DAY FROM SYSDATE) d
    , EXTRACT(HOUR FROM CURRENT_TIMESTAMP) h
    -- cast()
    , EXTRACT(HOUR FROM CAST(SYSDATE AS TIMESTAMP)) h -- ORA-30076: invalid extract field for extract source
    , EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) m
    , EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) s
FROM dual;

SELECT name, ibsadate
FROM insa
WHERE ibsadate >= '2000.01.01';
WHERE EXTRACT(year FROM ibsadate) >= 2000;
WHERE TO_CHAR(ibsadate, 'YYYY') >= 2000;

-- dual ? : 테이블이다. 1개에 칼럼에 1개의 행만 가지고 있음.
-- FROM dual;
DESC dual;
-- DUMMY    VARCHAR2(1)
SELECT dummy
FROM dual;
-- 레코드(행) 1개 뿐 : X
SELECT SYSDATE
FROM emp;
-- DUAL이라는 테이블은 SYS 사용자가 소유하는 오라클의 표준 테이블로서 오직 한 행(row)에 한 컬럼만 담고 있는 dummy 테이블로서 일시적인 산술연산이나 날짜 연산을 위하여 주로 쓰인다.
-- 다시 말해서 이 가상 테이블은 SYS의 소유이다. 우리가 SYS로 로그인하지 않거나 SYS.DUAL로 쓰지 않아도 사용할 수 있는 이유는 SYS 사용자가 모든 사용자들에게 사용할 수 있도록 이 테이블에 PUBLIC synonym을 주었기 때문이다.
-- synonym : 별칭을 준거다.
-- 26.
SELECT *
FROM insa
WHERE REGEXP_LIKE(name,'^[김이]')
ORDER BY name;
-- 27.
SELECT COUNT(*)
FROM insa;
-- LIKE 연산자의 ESCAPE 옵션 설명
-- ㄴ wildcard(% _)를 일반 문자처럼 쓰고 싶은 경우에는 ESCAPE 옵션을 사용
SELECT deptno, dname, loc
FROM dept;
-- dept 테이블에 새로운 부서정보를 추가.. - 커밋이나 롤백을 해야 반영됨.
-- SQL -> DML : INSERT 문
-- INSERT INTO 테이블명
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated : 유일성 제약 조건에 위배된다.
-- PK = NN + UK : 낫널이랑 유일성 제약 조건이 같이 걸림. 유니크인 이유
INSERT INTO dept (deptno, dname, loc) VALUES (60,'한글_나라','KOREA');
INSERT INTO dept VALUES (60,'한글_나라','KOREA'); -- 생략 가능. 위와 동일
COMMIT;
ROLLBACK;
-- [문제] 부서명에 % 문자가 포함된 부서 정보를 조회
SELECT *
FROM dept;

-- wildcard를 일반 문자처럼 쓰고 싶은 경우에는 ESCAPE 옵션을 사용
WHERE dname LIKE '%\%%' ESCAPE '\'; -- 일반문자가 된다.

-- DML(DELETE)
-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found : 무결성 제약 조건에 위배 : 포링키
DELETE FROM dept;
DELETE FROM dept -- 테이블에는 프라머키? 무조건 있어야 된다.(구별 쉽게) 2개 이상 있으면 복합키?
WHERE deptno = 60;
DELETE FROM emp; -- WHERE 조건절이 없으면 모든 레코드 삭제
SELECT *
FROM emp;
-- DNL(UPDATE)
-- 50 부서명 QC 지역명 COREA
-- UPDATE 테이블명
-- SET 컬럼명=컬럼값,컬럼명=컬럼값,컬럼명=컬럼값;

UPDATE dept
SET dname = 'QC'; -- WHERE 조건절이 없으면 모든 레코드 수정.
ROLLBACK;

SELECT *
FROM dept;

UPDATE dept
--SET dname = dname || 'XX' -- XX 연결해서 할당.
SET dname = SUBSTR(dname,0,2), loc = 'COREA'
WHERE deptno = 50;
ROLLBACK;
-- [문제] 40번 부서의 부서명, 지역명을 얻어와서 50번 부서의 부서명으로, 지역명으로 수정하는 쿼리 작성
SELECT *
FROM dept;

SELECT dname
FROM dept
WHERE deptno = 40;

UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 40)
    , loc = (SELECT loc FROM dept WHERE deptno = 40)
-- SET dname = 'OPERATIONS', loc = 'BOSTON'
WHERE deptno = 50;

-- SELECT dname, loc FROM dept WHERE deptno = 40
UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;

-- [문제] dept 50, 60, 70 부서번호를 삭제..
DELETE FROM dept
WHERE deptno = 50 OR deptno = 60 OR deptno = 70;
WHERE deptno IN(50,60,70);
WHERE deptno BETWEEN 50 AND 70;
COMMIT;

SELECT *
FROM dept;

-- [문제] emp 테이블에 모든 사원의 sal 기본급을 pay급여의 10% 인상하는 UPDATE문 작성
SELECT *
FROM emp;

SELECT e.*
    , (sal + NVL(comm,0))/10 pay -- 인상율
    , sal + (sal + NVL(comm,0))/10 -- 인상액
FROM emp e;

UPDATE emp
SET sal = sal + (sal + NVL(comm,0))/10;

ROLLBACK;

-- dual 테이블 == 시노님
-- 스키마.객체명
-- 시노님 : 하나의 객체에 대해 다른 이름을 정의하는 방법이다.

-- PUBLIC 시노님 생성 - PUBLIC 주석 풀면 private
-- CREATE [PUBLIC] SYNONYM [schema.]synonym명
-- FOR [schema.]object명;

-- ORA-01031: insufficient privileges : 권한이 충분하지 않다.
-- CREATE PUBLIC SYNONYM arirang
-- FOR scott.emp;

-- 권한 부여
GRANT SELECT ON emp TO hr; -- scott emp 테이블을 hr에서 SELECT 권한을 주는 것.
-- 권한 회수
-- REVOKE 객체권한명
	-- ON 객체명
	-- FROM 사용자명, 롤명, PUBLIC
	-- [CASCADE CONSTRAINTS;
    
REVOKE SELECT
	ON emp
	FROM hr;
	[CASCADE CONSTRAINTS;
    
--------------------------------------------------------------------------------
-- 오라클 연산자(operator) 정리
--1) 비교연산자 : = != > < >= <=
--            WHERE 절에 숫자,문자,날짜를 비교할 때 사용
--            ANT, SOME, ALL 비교연산자, SQL연산자에도 포함.

--2) 논리연산자 : AND OR NOT
--            WHERE 절에서 조건을 결합할 때..

--3) SQL연산자 : SQL언어에만 있는 연산자
--    [NOT] IN (list)
--    [NOT] BETWEEN a AND b
--    [NOT] LIKE
--    IS [NOT] NULL
--    ANY, SOME, ALL          WHERE 절 + (서브쿼리)
--    (TRUE/FALSE)  EXISTS      WHERE 절 + (서브쿼리)

--4) NULL연산자

--5) 산술연산자 : 덧셈, 뺄셈, 곱셈, 나눗셈 (우선 순위)
SELECT 5+3, 5-3, 5*3, 5/3
    , FLOOR(5/3) -- 몫 구하기
    , MOD(5,3) -- 나머지 구하기
FROM dual;






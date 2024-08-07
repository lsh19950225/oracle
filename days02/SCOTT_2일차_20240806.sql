-- SCOTT
-- 1) SCOTT 소유한 테이블 목록 조회.
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;
FROM tabs;
-- 차이점

-- INSA 테이블 구조 파악
DESCRIBE insa;
DESC insa;
-- NUL : 필수입력사항
--
-- NUMBER(5) == NUMBER(5, 0) == 정수
-- 한글 3바이트 20경우 6글자
-- INSA 모든 사원 정보를 조회.
SELECT *
FROM insa;
-- IBSADATE 입사일자
-- '98/10/11' 날짜 '' 'RR/MM/DD'  'YY/MM/DD' 차이점
SELECT *
FROM v$nls_parameters;
-- emp 테이블에서 사원 정보 조회(사원번호, 사원명, 입사일자) 조회
[WITH] 1
SELECT 6 *
FROM 2 *
[WHERE] 3
[GROUP BY] 4
[HAVING] 5
[ORDER BY] 7
;
-- 월급(pay) = 기본급(sal) + 수당(comm) 컬럼을 추가해서 조회.
SELECT empno, ename, hiredate
--        , sal, comm
--        -- , NVL(comm, 대체할 값)
--        , NVL(comm, 0)
--        , NVL2(comm,comm,0) -- 널값이 아니면 2번째, 널값이면 3번째 값 출력
--        , sal + comm
        , sal + NVL(comm, 0) PAY -- 소문자로 써도 대문자로 출력
FROM emp;
-- 1) 오라클 NULL 의미? 미확인 값. ex) 800 + NULL = NULL
-- 2) 월급 x 
-- NVL 함수는 NULL을 0 또는 다른 값으로 변환하기 위한 함수이다.
-- 문제) emp 테이블에서 사원번호, 사원명, 직속상사 조회.
-- 직속상사가 널일 경우 'CEO' 라고 출력
SELECT empno, ename, mgr
        -- , NVL2(mgr,mgr,'CEO') -- ORA-01722: invalid number
        -- , NVL(mgr,0) -- ORA-01722: invalid number
        -- , TO_CHAR(mgr) -- 우측정렬 : 숫자, 좌측정렬 : 문자, 문자로 바꾸는 형변환
        -- , mgr || '' -- 문자열로 형변환
        , NVL(TO_CHAR(mgr), 'CEO')
        , NVL(mgr || '', 'CEO')
FROM emp;

DESC emp;

-- emp 테이블에서
-- 이름은 'SMITH'이고, 직업은 CLERK 이다.
-- 출력(조회)
-- 자바 \" == "로 출력
SELECT '이름은 ''' || ename || '''이고, 직업은 ' || job || '이다.'
FROM emp; -- '' == '로 출력
-- 65 -> A CHR()
-- SELECT '이름은 ' || CHR(39) ||ename || CHR(39) || '이고, 직업은 ' || job || '이다.'
-- FROM emp;

-- SYS 모든 사용자 정보 조회.
-- emp 테이블에서 부서번호가 10번인 사원들만 조회.
SELECT *
FROM dept;
-- emp 테이블에서 각 사원이 속해 있는 부서번호만 조회.
SELECT DISTINCT deptno
;
SELECT *
FROM emp
WHERE deptno = 10;
-- 문제) emp 테이블에서 10번 부서원만 제외한 나머지 사원들 정보 조회.
-- 오라클 논리연산자 : AND OR NOT
SELECT *
FROM emp
WHERE NOT(deptno = 10);
WHERE deptno ^= 10;
WHERE deptno != 10;
WHERE deptno <> 10;
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
--
SELECT *
FROM emp
WHERE deptno IN (20,30,40); -- 밑과 동일
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
-- [NOT] IN (list) SQL 연산자

-- [문제] emp 테이블에서 사원명이 ford인 사원의 모든 사원정보를 출력(조회)
SELECT *
FROM emp
WHERE ename = UPPER('foRd'); -- UPPER : 대문자 바꾸는 함수
WHERE ename = 'FORD'; -- ORA-00904: "FORD": invalid identifier(식별자)
-- 값을 가지고 비교할때는 대소문자 구별.
--
SELECT LOWER(ename), INITCAP(job) -- LOWER : 소문자 바꾸는 함수 / INITCAP : 앞글자만 대문자
FROM emp;

-- [문제] emp 테이블에서 커미션이 NULL인 사원의 정보 출력(조회)
SELECT *
FROM emp
WHERE comm IS NULL; -- NULL 비교할때는 IS NULL, IS NOT NULL
WHERE comm IS NOT NULL;

-- [문제] emp 테이블에서 2000 이상 월급(pay) 4000 이하 받는 사원의 정보를 출력(조회)
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 2000 AND 4000;
WHERE 2000 <= sal + NVL(comm, 0) AND sal + NVL(comm, 0) <= 4000;

SELECT e.*, sal + NVL(comm, 0) pay -- 6
FROM emp e -- == AS e
WHERE pay >= 2000 AND pay <= 4000; -- ORA-00904: "PAY": invalid identifier 처리 순서 오류
--
SELECT e.*, sal + NVL(comm, 0) pay
FROM emp e -- == AS e
WHERE sal + NVL(comm, 0) >= 2000 AND sal + NVL(comm, 0) <= 4000;
-- WITH 절 사용 : WITH AS 서브쿼리
-- 서브쿼리 : 쿼리 안에 쿼리 == 하위 쿼리
WITH temp AS (
            SELECT emp.*, sal + NVL(comm, 0) pay
            FROM emp
            )
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000;
-- 인라인 뷰(inline view) 사용 : FROM 뒤에 오는 서브쿼리, 반드시 AS 별칭 선언
-- 서브쿼리가 WHERE 절에 있으면 이를 Nested subquery라 하며
-- (중첩서브쿼리)Nested subquery중에서 참조하는 테이블이 parent, child관계를 가지면 이를 (상관서브쿼리)correlated subquery라 한다.
SELECT *
FROM (
        SELECT emp.*, sal + NVL(comm, 0) pay
        FROM emp
    ) e
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;
-- 인라인 뷰(inline view) 사용
-- NOT BETWEEN A AND B SQL 연산자 사용 수정..
SELECT *
FROM (
        SELECT emp.*, sal + NVL(comm, 0) pay
        FROM emp
    ) e
WHERE pay BETWEEN 2000 AND 4000; -- 밑과 동일
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;

-- [문제] insa 테이블에서 70년대생인 사원 정보를 조회
-- (이름, 주민등록번호)
-- REGEXP_XXX() 정규표현식을 사용하는 함수
-- LIKE()
SELECT name, ssn
    , SUBSTR(ssn,0,1)
    , SUBSTR(ssn,1,1)
    , SUBSTR(ssn,1,2) -- '77' 문자
    , INSTR(ssn,7) -- 7이 들어간 위치 찾기
FROM insa
WHERE INSTR(ssn,7) = 1; -- 7이 들어간 위치가 1번째면
WHERE TO_NUMBER(SUBSTR(ssn,0,2)) BETWEEN 70 AND 79; -- TO_NUMBER : 문자를 숫자로 변환
WHERE SUBSTR(ssn,0,2) BETWEEN 70 AND 79; -- 문자 상태에서 비교한 것.
WHERE SUBSTR(ssn,0,1) = 7;
-- SURSTR()
-- REGEXP_REPLACE()
-- REPLACE() : a1: 전제문자열
            -- a2: 전체 문자열 a1중에서 바꾸기를 원하는 문자열
            -- a3: 바꾸고자 하는 새로운 문자열
SELECT name, ssn
--    , SUBSTR(ssn,1,8)||'******' RRN
--    , CONCAT(SUBSTR(ssn,1,8), '******') RRN
--    , RPAD(SUBSTR(ssn,1,8),14,'*') RRN -- 14공간에 왼쪽에 채우고 오른쪽에 *로 다 채운다.
--    , REPLACE(ssn, SUBSTR(ssn,-6), '******') RRN -- -6은 뒤에서부터
    , REGEXP_REPLACE(ssn, '(\d{6}-\d)\d{6}', '\1******')
FROM insa;
--
SELECT name, ssn
    , SUBSTR(ssn,0,6)
    , SUBSTR(ssn,0,2) YEAR
    , SUBSTR(ssn,3,2) MONTH
    , SUBSTR(ssn,5,2) "DATE" -- ORA-00923: FROM keyword not found where expected : DATE 불가능
    , TO_DATE(SUBSTR(ssn,0,6)) BIRTH -- '771212' 문자 -> 날짜 형 변환
    -- '77/12/12' DATE -> 년,월,일,시간,분,초
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') y -- 'yy' : 2자리, 'yyyy' : 4자리
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') BETWEEN 70 AND 79;
WHERE TO_DATE(SUBSTR(ssn,0,6)) BETWEEN '70/01/01' AND '79/12/31'; -- BETWEEN : 날짜에도 사용가능.
--
SELECT ename, hiredate -- '80/12/17' DATE
--    , SUBSTR(hiredate,1,2) YEAR
--    , SUBSTR(hiredate,4,2) MONTH
--    , SUBSTR(hiredate,-2,2) "DATE"
    -- TO_NUMBER()
    -- TO_DATE()
    -- TO_CHAR() : 문자로
--    , TO_CHAR(hiredate,'YEAR')
--    , TO_CHAR(hiredate,'YYYY') -- '1980'
--    , TO_CHAR(hiredate,'MM') -- '12'
--    , TO_CHAR(hiredate,'DD') -- '17'
--    , TO_CHAR(hiredate,'DAY') -- '금요일'
--    , TO_CHAR(hiredate,'DY') -- '금'

    -- EXTRACT() 추출하다. -- 숫자
    , EXTRACT(YEAR FROM hiredate)
    , EXTRACT(MONTH FROM hiredate)
    , EXTRACT(DAY FROM hiredate)
FROM emp;

-- 오늘 날짜에서 년도/월/일/시간/분/초 얻어오고자 해용.
SELECT SYSDATE -- SYSDATE : 함수, 오늘 날짜 출력. , 초까지
    , TO_CHAR(SYSDATE, 'DS TS')
    , CURRENT_TIMESTAMP -- 함수 : 현재 시스템 시간의 나노세컨드까지
FROM dept;
-- insa 테이블에서 70년대 출생 사원 정보 조회.
-- LIKE SQL 연산자
-- REGEXP_LIKE 함수
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn,'^7.12'); -- 70년대 12월
WHERE REGEXP_LIKE(ssn,'^7[0-9]12'); -- 70년대 12월
WHERE REGEXP_LIKE(ssn,'^7\d12'); -- 70년대 12월

WHERE REGEXP_LIKE(ssn,'^[78]'); -- ^[78] : 70년대, 80년대
WHERE REGEXP_LIKE(ssn,'^7'); -- ^7 : 7로 시작하는.
WHERE ssn LIKE '7_12%'; -- 70년대 12월생
WHERE ssn LIKE '7%'; -- 70년대 생
WHERE ssn LIKE '______-1______'; -- 남자, _ : 한칸
WHERE ssn LIKE '______-1%'; -- 남자
WHERE ssn LIKE '_______1%'; -- 남자
WHERE ssn LIKE '%-1%'; -- 남자
WHERE SUBSTR(ssn,8,1) = 1;
WHERE name LIKE '%자'; -- 앞에는 아무거나 와도 상관없음. 뒤에는 '자'로 끝나야됨.
WHERE name LIKE '%말%'; -- 어디든 상관없이 '말' 포함.
WHERE name LIKE '김%'; -- % : '김' 뒤에 아무거나 와도 상관없다. 안와도 좋고 여러개와도 상관없음.

-- [문제] insa 테이블에서 김씨 성을 제외한 모든 사원 출력
SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^[^김이홍]');
WHERE NOT REGEXP_LIKE(name, '^김');
WHERE REGEXP_LIKE(name, '^김');
WHERE NOT (name NOT LIKE '김%');
WHERE name NOT LIKE '김%';
-- [문제]출신도가 서울, 부산, 대구 이면서 전화번호에 5 또는 7이 포함된 자료 출력하되
--      부서명의 마지막 부는 출력되지 않도록함. 
--      (이름, 출신도, 부서명, 전화번호)
SELECT name, city, buseo, tel
    , LENGTH(buseo)
    , SUBSTR(buseo,0,LENGTH(buseo)-1)
FROM insa
WHERE 
    -- city IN('서울','부산','대구')
    REGEXP_LIKE(city,'서울|부산|대구')
    AND
    -- REGEXP_LIKE(tel,'[57]');
    tel LIKE '%5%' OR tel LIKE '%7%';

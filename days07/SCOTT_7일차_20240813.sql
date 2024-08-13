-- SCOTT
-- [문제] emp, dept
--   사원이 존재하지 않는 부서의 부서번호, 부서명을 출력
SELECT d.deptno, dname, COUNT(empno)
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno, dname
HAVING COUNT(empno) = 0
ORDER BY d.deptno ASC;
--
WITH t AS (
SELECT deptno
FROM dept
MINUS
SELECT DISTINCT deptno
FROM emp
)
SELECT t.deptno, d.dname
FROM t JOIN dept d ON t.deptno = d.deptno;
--
SELECT t.deptno, d.dname
FROM (
SELECT deptno
FROM dept
MINUS
SELECT DISTINCT deptno
FROM emp
)
t JOIN dept d ON t.deptno = d.deptno;
-- SQL 연산자 ALL, ANY, SOME, (NOT EXITS)
SELECT m.deptno, m.dname
FROM dept m
WHERE NOT EXISTS ( SELECT empno FROM emp WHERE deptno = m.deptno ); -- NOT EXISTS : 존재하지 않는다면, EXISTS : 존재한다면

-- 상관서브쿼리
SELECT m.deptno, m.dname
FROM dept m
WHERE ( SELECT COUNT(*) FROM emp WHERE deptno = m.deptno ) = 0; -- emp 테이블에 존재하지 않는 부서정보;

-- 문제 insa 테이블에서 각 부서별 여자사원수를 파악해서 5명 이상인 부서 정보 출력.
SELECT *
FROM (
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) 여
FROM insa
GROUP BY buseo
) t
WHERE 여 >= 5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;
-- [문제] insa 테이블
--     [총사원수]      [남자사원수]      [여자사원수] [남사원들의 총급여합]  [여사원들의 총급여합] [남자-max(급여)] [여자-max(급여)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000
SELECT COUNT(*) 총사원수
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자')) 남자사원수
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) 여자사원수
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "남사원들의 총급여합"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "여사원들의 총급여합"
    , MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "남자-max(급여)"
    , MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "여자-max(급여)"
FROM insa;
-- ㄴ.
SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자',0,'여자','전체') || '사원수'
    , COUNT(*) 사원수
    , SUM(basicpay) 급여합
    , MAX(basicpay) 최고
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));
-- [문제] emp 테이블에서~
--      각 부서의 사원수, 부서 총급여합, 부서 평균급여
결과)
    DEPTNO       부서원수       총급여합            평균
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0
SELECT d.deptno, COUNT(empno) 부서원수
    , NVL(SUM(sal + NVL(comm,0)),0) 총급여합
    , NVL(ROUND(AVG(sal + NVL(comm,0)),2),0) 평균
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno -- OUTER 생략가능.
GROUP BY d.deptno
ORDER BY d.deptno;
--
FROM e.deptno(+) = d.deptno -- 라이트 아우터 조인

-- ROLLUP절과 CUBE절
-- ㄴ GROUP BY절에서 사용되어 그룹별 소계를 추가로 보여주는 역할
-- ㄴ 즉, 추가적인 집계 정보를 보여준다.
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2)
        WHEN 1 THEN '남자'
        WHEN 0 THEN '여자'
    END 성별
    , COUNT(*) 사원수
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2)
UNION ALL
SELECT '전체', COUNT(*)
FROM insa;
-- GROUP BY + ROLLUP/CUBE 사용
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2)
        WHEN 1 THEN '남자'
        WHEN 0 THEN '여자'
        ELSE '전체'
    END 성별
    , COUNT(*) 사원수
FROM insa
GROUP BY CUBE(MOD(SUBSTR(ssn,8,1),2));
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));

-- ROLLUP / CUBE 의 차이점..
-- 1차 부서별로 그룹핑, 2차 직위별로 그룹핑.
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY buseo, jikwi
-- ORDER BY buseo, jikwi;
UNION ALL
SELECT buseo, NULL, COUNT(*)
FROM insa
GROUP BY buseo
ORDER BY buseo, jikwi;
-- ROLLUP
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;
-- 2. CUBE
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi;
--ORDER BY buseo, jikwi;
UNION ALL
SELECT buseo, NULL, COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT NULL, jikwi, COUNT(*)
FROM insa
GROUP BY jikwi
ORDER BY buseo, jikwi;

-- 분할 ROLLUP
SELECT buseo, jikwi, COUNT(*) 사원수
FROM insa
GROUP BY ROLLUP(buseo), jikwi -- 직위에 대한 부분 집계, 전체집계 x
-- GROUP BY buseo, ROLLUP(jikwi) -- 부서에 대한 부분 집계, 전체집계 x
-- GROUP BY ROLLUP(buseo, jikwi)
-- GROUP BY CUBE(buseo, jikwi) -- + 과장,대리,부장,사원
ORDER BY buseo, jikwi;

-- [GROUPING SETS 함수]
SELECT buseo, '', COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT jikwi, '', COUNT(*)
FROM insa
GROUP BY jikwi;
--
SELECT buseo, jikwi, COUNT(*)
FROM insa
GROUP BY GROUPING SETS(buseo, jikwi) -- 그룹핑한 집계만 나온다.
ORDER BY buseo, jikwi;

-- 피봇(pivot)
-- 1. 테이블 설계가 잘못됨. 프로젝트가 진행
tbl_pivot 테이블 생성
번호, 이름, 국, 영, 수 관리 테이블
-- DDL문 : CREATE
CREATE TABLE tbl_pivot -- 테이블명
(
    -- 컬럼명 자료형(크기) 제약조건..
    no NUMBER PRIMARY KEY -- 고유한키(PK) : 제약조건 -- 그 사람을 찾을 수 있는 키 중복안되게
    , name VARCHAR2(20 BYTE) NOT NULL -- NN : 제약조건(== 필수입력사항)
    , jumsu NUMBER(3) -- NULL 허용 : NOT NULL 안붙치면
);
-- Table TBL_PIVOT이(가) 생성되었습니다.
SELECT *
FROM tbl_pivot;
-----
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 
-----
ROLLBACK;

COMMIT;

-- 질문) 피봇
--번호 이름   국,  영,  수
--1   박예린  90 89 99
--2   안시은  56 45 12
--3   김민    99 85 100
--
SELECT *
FROM (
SELECT TRUNC((no-1)/3)+1 no
    , name
    , jumsu
    , DECODE(MOD(no,3),1,'국어',2,'영어',0,'수학') subject
FROM tbl_pivot
)
PIVOT ( SUM(jumsu) FOR subject IN ('국어','영어','수학') )
ORDER BY no ASC;
--
SELECT *
FROM (
SELECT TRUNC((no-1)/3)+1 no
    , name
    , jumsu
    , ROW_NUMBER() OVER(PARTITION BY name ORDER BY no) subject
FROM tbl_pivot
)
PIVOT ( SUM(jumsu) FOR subject IN (1 AS "국어",2 AS "영어",3 AS "수학") )
ORDER BY no ASC;

-- [풀이] 각년도별 월별 입사한사원수 파악(조회).
YEAR      MONTH          N
---- ---------- ----------
1980          1          0
1980          2          0
1980          3          0
1980          4          0
1980          5          0
1980          6          0
1980          7          0
1980          8          0
1980          9          0
1980         10          0
1980         11          0

YEAR      MONTH          N
---- ---------- ----------
1980         12          1
1981          1          0
1981          2          2
1981          3          0
1981          4          1
1981          5          1
1981          6          1
1981          7          0
1981          8          0
1981          9          2
1981         10          0
SELECT TO_CHAR(hiredate,'YYYY') h_year
    , COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

-- ORA-01788: CONNECT BY clause required in this query block : CONNECT BY 같이 써야됨.
SELECT LEVEL month -- 순번(단계)를 나타내는 함수
FROM dual
CONNECT BY LEVEL <= 12;
--
SELECT empno, TO_CHAR(hiredate,'YYYY') year
    , TO_CHAR(hiredate,'MM') month
FROM emp;
--
SELECT year, m.month, NVL(COUNT(empno),0) n
FROM (
    SELECT empno, TO_CHAR(hiredate,'YYYY') year
    , TO_CHAR(hiredate,'MM') month
    FROM emp
) e PARTITION BY(e.year) RIGHT OUTER JOIN (
    SELECT LEVEL month
    FROM dual
    CONNECT BY LEVEL <= 12
) m
ON e.month = m.month
GROUP BY year, m.month
ORDER BY year, m.month;
-- [풀이] insa 테이블에서 부서별, 직위별 사원수
SELECT buseo, jikwi, COUNT(*)
FROM insa
GROUP BY buseo, jikwi
ORDER BY buseo, jikwi;
-- [문제] 각 부서별, 직위별 최소사원수, 최대사원수 조회.
WITH t1 AS (
SELECT buseo, jikwi, COUNT(*) tot_count
FROM insa
GROUP BY buseo, jikwi
), t2 AS (
    SELECT buseo
    , MIN(tot_count) buseo_min_count
    , MAX(tot_count) buseo_max_count
    FROM t1
    GROUP BY buseo
)
SELECT a.buseo
    , b.jikwi 최소직위
    , b.tot_count 최소사원수
FROM t2 a, t1 b
WHERE a.buseo = b.buseo AND a.buseo_min_count = b.tot_count;

-- FIRST/LAST 분석함수 사용해서 풀이..
WITH t AS (
SELECT buseo, jikwi, COUNT(*) tot_count
FROM insa
GROUP BY buseo, jikwi
)
SELECT t.buseo
    , MIN(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count ASC) 최소직위
    , MIN(t.tot_count) 최소사원수
    , MAX(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count ASC) 최대직위
    , MAX(t.tot_count) 최대사원수
FROM t
GROUP BY t.buseo
ORDER BY 1; -- 1 : t.buseo

-- 2가지
-- 1) 분석함수 FIRST, LAST
--          집계함수(COUNT,SUM,AVG,MAX,MIN)와 같이 사용하여
--          주어진 그룹에 대해 내부적으로 순위를 매겨 결과를 산출하는 함수
SELECT MAX(sal)
    , MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    , MAX(empno) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    , MIN(sal)
    , MAX(ename) KEEP(DENSE_RANK LAST ORDER BY sal DESC) min_ename
    , MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal ASC) min_ename
FROM emp;
--
WITH a AS
(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt DESC) min_dname
    , MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) max_dname
FROM a;
-- 2) SELF JOIN : 자기 자신과 조인
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON a.mgr = b.empno;

-- NON EQUAL JOIN

-- [EQUAL JOIN] == [INNER]
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno 

-- [NON EQUAL JOIN]
SELECT *
FROM salgrade;
-- [NON EQUAL JOIN]
SELECT empno, ename, sal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal; -- = 를 안쓰는 조인
-- 크로스조인
SELECT empno, ename, sal, grade
FROM emp e,salgrade s;
-- 안할시..
SELECT ename, sal
   ,  CASE
        WHEN  sal BETWEEN 700 AND 1200 THEN  1
        WHEN  sal BETWEEN 1201 AND 1400 THEN  2
        WHEN  sal BETWEEN 1401 AND 2000 THEN  3
        WHEN  sal BETWEEN 2001 AND 3000 THEN  4
        WHEN  sal BETWEEN 3001 AND 9999 THEN  5
      END grade
FROM emp;

-- [문제] emp 테이블에서 가장 입사일자가 빠른 사원과
--                    가장 입사일자가 늦은 사원과의 입사 차이 일 수 ?
SELECT MAX(hiredate) - MIN(hiredate) -- 날짜에서 MAX, MIN 쓸 수 있다.
FROM emp;

-- 분석함수 : CUME_DIST() -- 중요하진않다.
--  ㄴ 주어진 그룹에 대한 상대적인 누적 분포도 값을 반환
--  ㄴ 분포도값(비율) 0 <   <= 1
SELECT deptno, ename, sal
    , CUME_DIST() OVER(ORDER BY sal ASC) dept_list
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) dept_list
FROM emp;

-- 분석함수 : PERCENT_RANK()
-- ㄴ 해당 그룹 내의 백분위 순위
-- 0 <= 사이의 값 <= 1
-- 백분위 순위 ? 그룹 안에서 해당 행의 값보다 작은 값의 비율

-- NTILE() N타일 : 전체그룹을 일정한 갯수로 나눈다. 분석함수
-- ㄴ 파티션 별로 expr에 명시된 만큼 분할한 결과를 반환하는 함수
-- 분할하는 수를 버킷(bucket)이라고 한다.
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal ASC) ntiles -- 4그룹으로 나눈다.
FROM emp;
--
SELECT deptno, ename, sal
    , NTILE(2) OVER(PARTITION BY deptno ORDER BY sal ASC) ntiles
FROM emp;
--
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) nitles
    , WIDTH_BUCKET(sal,1000,4000,4) widthbuckets -- WIDTH_BUCKET : 1000~4000을 4단계로 나눔. 750씩 / 1000 아래 : 0, 4000 위 : 5
FROM emp;

-- LAG(expr,offset,default_value) 분석
-- ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
-- ㄴ 선행(앞) 행
-- LEAD(expr,offset,default_value) 분석
-- ㄴ 주어진 그룹과 순서에 따라 다른 행에 있는 값을 참조할 때 사용하는 함수
-- ㄴ 후행(뒤) 행
SELECT deptno, ename, hiredate, sal
    , LAG(sal,3,100) OVER(ORDER BY hiredate) pre_sal -- 이전행의(offset:n)값 : 3을 출력 / 없으면 기본(디폴트:n)값 : 100
    , LEAD(sal,1,-1) OVER(ORDER BY hiredate) next_sal -- 이후행의 값을 출력 / 없으면 기본값 : -1 - 위와 동일
FROM emp
WHERE deptno = 30;

--------------------------------------------------------------------------------
-- [오라클 자료형(Data Type)]
1. CHAR[(SIZE [BYTE|CHAR])] -- 문자열 저장 자료형
    CHAR = CHAR(1 BYTE) = CHAR(1)
    CHAR(3 BYTE) = CHAR(3) -- 'ABC', '한' : 알파벳 1바이트, 한글 3바이트
    CHAR(3 CHAR) -- ex) 'ABC', '한두셋' 문자를 3개 저장할 수 있는 자료형
    고정 길이의 문자열 자료형
    name CHAR(10 BYTE) [a][b][c][][][][][][][] 'abc' -- 고정길이로 할당됨. 나머지는 그대로 할당되어있음.
    2000 BYTE 까지 크기 할당할 수 있다.
    예) 주민등록번호(14), 학번, 전화번호 -- 고정길이인 문자열 값 : CHAR 사용.
    -- 테스트
    CREATE TABLE tbl_char
    (
    aa char -- char(1) == char(1 byte)
    , bb char(3) -- char(3 byte)
    , cc char(3 char)
    );
    
    DESC tbl_char;
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','aaa','aaa');
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('b','한','한우리');
    -- SQL 오류: ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 9, maximum: 3)
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('c','한우리','한우리'); -- bb : '한우리' 값이 안맞음.
    -- 부모 테이블 먼저 작성하고 자식 테이블 채워넣기.
    
    SELECT *
    FROM tbl_char;
    
    ROLLBACK;

2. NCHAR
    N == UNICODE(유니코드) : 유니코드 : 모든 문자 2바이트로
    NCHAR[(SIZE)]
    NCHAR(1) == NCHAR
    NCHAR(10) == 알파벳 10문자, 한글 10문자
    고정길이 문자열 자료형
    최대 2000 BYTE 저장 가능.

    CREATE TABLE tbl_nchar
    (
    aa char(3) -- char
    , bb char(3 char) -- char
    , cc nchar(3) -- nchar
    );
    
    SELECT *
    FROM tbl_nchar;
    
    INSERT INTO tbl_nchar (aa,bb,cc) VALUES('홍','길동','홍길동');
    INSERT INTO tbl_nchar (aa,bb,cc) VALUES('홍길동','홍길동','홍길동'); -- aa에서 걸림.
    
    COMMIT;
    
고정 문자열 - CHAR/NCHAR 최대 2000 BYTE

3. VARCHAR2 ==> 별칭 VARCHAR
    VAR : 가변 길이
    가변 길이 문자열 자료형
    최대 4000 BYTE
    VARCHAR2(SIZE BYTE|CHAR)
    VARCHAR2(1) = VARCHAR(1 BYTE) == VARCHAR2
    name VARCHAR2(10) [a][d][m][i][n] 제거 : [][][][][] 'admin'

4. NVARCHAR2
    유니코드 문자를 저장하는 가변 길이 문자열 자료형
    NVARCHAR2(SIZE)
    NVARCHAR2(1) = NVARCHAR2
    최대 4000 BYTE

5.  NUMBER[(p[,s])]
    p : precision 정확도 / s : scale 규모
        전체자릿수           소수점이하자릿수
        1~38                -84~127
    NUMBER = NUMBER(38,127) -- 둘다 최대값으로
    NUMBER(p) = NUMBER(p,0) -- 안주면 소수점 0 자릿수
    
    예)
    CREATE TABLE tbl_number
    (
    no NUMBER(2) NOT NULL PRIMARY KEY -- NN + UK
    , name VARCHAR2(30) NOT NULL
    -- , name CLOB -- 2GB 이상 더 큰 자료형
    , kor NUMBER(3) -- -999 ~ 999 / 실수를 집어 넣어도 소수점 반올림해서 정수로 넣음.
    , eng NUMBER(3) -- 0 <= <= 100 : 제약조건 : 체크드제약조건 - 나중에 알려줌
    , mat NUMBER(3) DEFAULT 0 -- 입력안할시 0 출력
    );

SELECT *
FROM tbl_number;

INSERT INTO tbl_number (no,name,kor,eng,mat) VALUES (1,'홍길동',90,88,98);
COMMIT;
-- SQL 오류: ORA-00947: not enough values : 벨류값이 충분하지 않다.
-- INSERT INTO tbl_number (no,name,kor,eng,mat) VALUES (2,'이시훈',100,100); -- 컬럼명도 지워줘야됨.
INSERT INTO tbl_number (no,name,kor,eng) VALUES (2,'이시훈',100,100);
COMMIT;
-- SQL 오류: ORA-00947: not enough values
-- INSERT INTO tbl_number VALUES (3,'송세호',50,50); -- 컬럼명을 지웠을 경우 순서대로.
INSERT INTO tbl_number VALUES (3,'송세호',50,50,100); -- 수학 넣어야됨.
COMMIT;
INSERT INTO tbl_number (name,no,kor,eng,mat) VALUES ('김재민',4,50,50,100); -- 컬럼 위치만 맞추면 위치 변경 가능.
COMMIT;
--
SELECT *
FROM tbl_number;
--
-- ORA-00001: unique constraint (SCOTT.SYS_C007028) violated : 유일성 제약조건 : 같은게 있으면 안된다. 4가 있음.
-- INSERT INTO tbl_number VALUES (4,'김선우',110,56.234,-999); -- 실수 : 반올림
INSERT INTO tbl_number VALUES (5,'김선우',110,56.934,-999); -- 실수 : 반올림
ROLLBACK;

-- NUMBER(4,5)처럼 scale이 precision보다 크다면, 이는 첫자리에 0이 놓이게 된다.
-- 0 을 제외한
.01234 NUMBER(4,5) .01234 
.00012 NUMBER(4,5) .00012 
.000127 NUMBER(4,5) .00013 
.0000012 NUMBER(2,7) .0000012 
.00000123 NUMBER(2,7) .0000012 

6. FLOAT[(p)] == 내부적으로 NUMBER 처럼 나타낸다. -- 거의 안씀.

7. LONG 가변 길이(VAR 안붙음.) 문자열 자료형, 2GB

8. DATE 날짜, 시간(초까지) 나타냄. (고정길이 7 BYTE 안중요함)
    TIMESTAMP

9. RAW(SIZE) - 2000 BYTE 이진데이터 0, 1값 저장
    LONG RAW - 2GB       이진데이터 0, 1값 저장

LOB : 라지 오브젝트

10. LOB : CLOB, NCLOB, BLOB, BFILE

-- FIRST_VALUE 분석함수 : 정렬된 값 중에 첫 번째 값.
SELECT FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) -- basicpay 제일 큰 값
FROM insa;

SELECT FIRST_VALUE(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay DESC) -- 해당 부서의 제일 큰 값
FROM insa;
-- 가장 많은 급여 각 사원의 basicpay의 차이
SELECT buseo, name, basicpay
    , FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) max_basicpay -- FIRST_VALUE : 분석된 값의 첫번째 값.
    , FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) - basicpay 차이
FROM insa;

-- COUNT ~ OVER : 질의한 행의 누적된 결과 반환.
SELECT name, basicpay
    , COUNT(*) OVER(ORDER BY basicpay ASC)
FROM insa;

SELECT name, basicpay, buseo
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
FROM insa;
-- SUM ~ OVER : 질의한 행의 누적된 합 결과 반환.
SELECT name, basicpay, buseo
    -- , COUNT(*) OVER(ORDER BY basicpay ASC)
    , SUM(basicpay) OVER(ORDER BY buseo ASC)
FROM insa;

SELECT name, basicpay, buseo
    -- , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY buseo ASC)
FROM insa;
--
SELECT buseo, SUM(basicpay)
FROM insa
GROUP BY buseo
ORDER BY buseo;
-- AVG ~ OVER : 질의한 행의 누적된 평균 결과 반환.
SELECT name, basicpay, buseo
    , AVG(basicpay) OVER(ORDER BY buseo ASC)
FROM insa;

-- 테이블 생성, 수정, 삭제 DDL : CREATE, ALTER, DROP TABLE
-- 테이블(table) ? 데이터 저장소
-- 아이디 문자 10바이트
-- 이름   문자 20바이트
-- 나이   숫자 30바이트
-- 전화번호 문자 20바이트
-- 생일   날짜
-- 비고   문자 255바이트
CREATE TABLE tbl_sample
(
 id VARCHAR2(10)
 , name VARCHAR2(20)
 , age NUMBER(3)
 , birth DATE
);
SELECT *
FROM tabs
WHERE REGEXP_LIKE(table_name,'^TBL_','i'); -- i : 대소문자 상관없다.
WHERE table_name LIKE 'TBL\_%' ESCAPE '\';
--
DESC tbl_sample;
-- 전화번호, 비고 칼럼 빼고 만듦. -> 테이블 수정 : ALTER
ALTER TABLE tbl_sample
ADD ( -- 컬럼 한개 만들시 괄호 생략 가능.
tel VARCHAR2(20) -- DEFAULT '000-0000-0000' : 줘도됨.
, bigo VARCHAR2(255)
);

SELECT *
FROM tbl_sample;
-- 비고 컬럼의 크기 수정, 자료형 수정. ALTER
--           (255 -> 100)

? 데이터의 type, size, default 값을 변경할 수 있다.
? 변경 대상 컬럼에 데이터가 없거나 null 값만 존재할 경우에는 size를 줄일 수 있다.
? 데이터 타입의 변경은 CHAR와 VARCHAR2 상호간의 변경만 가능하다.
? 컬럼 크기의 변경은 저장된 데이터의 크기보다 같거나 클 경우에만 가능하다.
? NOT NULL 컬럼인 경우에는 size의 확대만 가능하다.
? 컬럼의 기본값 변경은 그 이후에 삽입되는 행부터 영향을 준다.
? 컬럼이름의 직접적인 변경은 불가능하다.
? 컬럼이름의 변경은 서브쿼리를 통한 테이블 생성시 alias를 이용하여 변경이 가능하다.
? alter table ... modify를 이용하여 constraint를 수정할 수 없다.

 데이터 타입 변경 가능사항 SIZE 
NULL 컬럼 문자 ↔ 숫자 ↔ 날짜 확대, 축소가능 
NOT NULL 컬럼 CHAR ↔ VARCHAR2 확대만 가능 


ALTER TABLE tbl_sample
MODIFY (bigo VARCHAR2(100));

DESC tbl_example;

-- bigo 컬럼명 -> memo 컬럼명 변경
ALTER TABLE tbl_sample
    RENAME COLUMN bigo TO memo;

-- 테이블 삭제
DROP TABLE 테이블명 CASCADE;

-- memo 컬럼 제거
? 컬럼을 삭제하면 해당 컬럼에 저장된 데이터도 함께 삭제된다.
? 한번에 하나의 컬럼만 삭제할 수 있다.
? 삭제 후 테이블에는 적어도 하나의 컬럼은 존재해야 한다.
? DDL문으로 삭제된 컬럼은 복구할 수 없다.
ALTER TABLE tbl_sample
DROP COLUMN memo;

-- 테이블명을 변경 tbl_sample -> tbl_example 수정.
RENAME tbl_sample TO tbl_example;
-- 테이블 이름이 변경되었습니다.
DESC tbl_example;

-- update set, insert 등도 시험.
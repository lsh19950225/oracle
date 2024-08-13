-- SCOTT
-- [문제] emp 테이블에서 ename, pay, 평균급여, 절상, 반올림, 절삭 함수(소수점 3자리)
SELECT ename, sal + NVL(comm,0) pay
    , (SELECT AVG(sal + NVL(comm,0)) FROM emp) AVG_PAY
    , CEIL((sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp))*100)/100 "차 올림" -- CEIL(n)
    , ROUND(sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp),2) "차 반올림"
    , TRUNC(sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp),2) "차 내림"
FROM emp;

-- [문제] emp 테이블에서
--      pay, avg_pay
--                  많다, 적다, 같다 출력
-- ename, pay, avg_pay, (많, 적, 같)
--      ㄱ. SET 집합 연산자(U UA M I)
SELECT t.*
    , CASE        WHEN t.pay > t.avg_pay THEN '많다'
                  WHEN t.pay < t.avg_pay THEN '적다'
                  ELSE '같다'
    END 비교
FROM(
SELECT ename, sal + NVL(comm,0) pay, (SELECT AVG(sal + NVL(comm,0)) FROM emp) avg_pay
FROM emp
) t;

-- [문제] insa 테이블에서 ssn 주민등록번호, 오늘이 생일이 지났다. 지나지 않았는지 출력.
UPDATE insa
SET ssn = SUBSTR(ssn,0,2) || TO_CHAR(SYSDATE,'MMDD') || SUBSTR(ssn,7)
WHERE NUM = 1002;

SELECT *
FROM insa;

ROLLBACK;

COMMIT;

SELECT num, name , ssn
     , SUBSTR(ssn,3,4) 월일
     , TO_DATE(SUBSTR(ssn,3,4),'MMDD') a -- 24/12/12
     -- 날짜 - 날짜 = 차이일수
     , TO_DATE(SUBSTR(ssn,3,4),'MMDD') - TRUNC(SYSDATE) b -- TRUNC 절삭 필요.
     , CASE         WHEN TO_CHAR(SYSDATE,'MMDD') > SUBSTR(ssn,3,4) THEN '지났다' -- 일수로 계산 후 SIGN : 사용해서 풀기 가능.
                    WHEN TO_CHAR(SYSDATE,'MMDD') < SUBSTR(ssn,3,4) THEN '안지났다'
                    ELSE '같다'
        END 비교
FROM insa;
-- 1) 1002 이순신 주민등록번호 월/일 -> 오늘날짜의 월/일로 수정(UPDATE)
-- 2)

-- [문제] insa 테이블의 주민등록번호(ssn) 만나이를 계산해서 출력
-- 성별(1,2) 1900     3,4 2000    0,9 1800    5,6 외 1900    7,8 외 2000
-- 만나이 : 생일년도 2024-1998 -1(생일 지남 여부)
-- name, ssn, 출생년도, 올해년도, 만나이
SELECT t.name, t.ssn, 출생년도, 올해년도
    , 올해년도 - 출생년도  + CASE bs
                               WHEN -1 THEN  -1                               
                               ELSE 0
                          END  만나이
FROM (
        SELECT name, ssn
         , TO_CHAR( SYSDATE , 'YYYY' ) 올해년도
         , SUBSTR( ssn, -7, 1) 성별
         , SUBSTR( ssn, 0, 2) 출생2자리년도
         , CASE 
             WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6) THEN 1900
             WHEN SUBSTR( ssn, -7, 1) IN ( 3,4,7,8) THEN 2000
             ELSE 1800
           END +  SUBSTR( ssn, 0, 2) 출생년도
           -- 0, -1 생일지난거..
           -- 1      나이 계산에서    -1
         , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ) , 'MMDD' )  - TRUNC( SYSDATE ) )  bs 
        FROM insa
) t;
-- Math.random() 임의의 수
-- Random 클래스 nextInt() 임의의 수
-- DBMS_RANDOM 패키지
-- 자바 패키지 - 서로 관련된 클래스들의 묶음
-- 오라클 패키지 - 서로 관련된 타입, 프로그램 객체, 서브프로그램(procedure, function)들의 묶음 : 유지 보수, 관리
-- package : PL/SQL의 패키지는 관계되는 타입, 프로그램 객체, 서브프로그램(procedure, function)을 논리적으로 묶어 놓은 것
-- 0.0 <= SYS.dbms_random.value < 1.0 : 실수
SELECT
    SYS.dbms_random.value -- 함수
--    , SYS.dbms_random.value(0,100) -- 0.0 <= 실수 < 100.0
--    , SYS.dbms_random.string('U',5) -- 랜덤하게 대문자 5글자 : 어퍼 -- 함수
--    , SYS.dbms_random.string('L',5) -- 소문자 : 로우
--    , SYS.dbms_random.string('X',5) -- 랜덤하게 대문자+숫자
    , SYS.dbms_random.string('P',5) -- 대문자+소문자+숫자+특수문자
    , SYS.dbms_random.string('A',5) -- A : 알파벳 대소문자
FROM dual;

-- [문제] 임의의 국어 점수 1개 출력
-- 0.0 <= 실수 < 101.0
SELECT ROUND(SYS.dbms_random.value(0,100)) a
    , TRUNC(SYS.dbms_random.value(0,101)) b
    , CEIL(SYS.dbms_random.value(0,100)) c
FROM dual;
-- [문제] 임의의 로또 번호 1개 출력
SELECT FLOOR(SYS.dbms_random.value(1,45))
FROM dual;
-- [문제] 임의의 숫자 6자리를 발생시켜서 출력
SELECT FLOOR(SYS.dbms_random.value(100000,999999)) a
    , TRUNC(SYS.dbms_random.value(100000,1000000)) c
    , FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9))
    || FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9))
    || FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9)) b
FROM dual;

-- [문제] insa 테이블에서 남자 사원수, 여자 사원수 출력
SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자','여자') 성별
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자','여자')) 수
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2);
-- [문제] insa 테이블에서 부서별  남자 사원수, 여자 사원수 출력
SELECT buseo
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2);
-- emp 테이블에서 최고 급여자, 최저 급여자 사원정보 조회
SELECT MAX(sal) FROM emp;
-- 순위 함수
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(ORDER BY sal DESC) r
    , RANK() OVER(ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 or t.r2 = 1;
--
SELECT *
FROM emp a, (SELECT MAX(sal) max, MIN(sal) min FROM emp) b
WHERE a.sal = b.max OR a.sal = b.min;

SELECT *
FROM emp
WHERE -- (SELECT MAX(sal) FROM emp) = sal OR (SELECT MIN(sal) FROM emp) = sal
    sal IN ((SELECT MAX(sal) FROM emp), (SELECT MIN(sal) FROM emp))
ORDER BY sal DESC;

-- 각 부서별
SELECT *
FROM emp m
WHERE sal IN ((SELECT MAX(sal) FROM emp WHERE deptno = m.deptno)
            , (SELECT MIN(sal) FROM emp WHERE deptno = m.deptno))
ORDER BY deptno, sal DESC;
--
-- 12 x 3 = 36 크로스 조인
SELECT a.*
FROM emp a, (SELECT MAX(sal) max, MIN(sal) min FROM emp GROUP BY deptno) b
WHERE a.sal = b.max OR a.sal = b.min AND a.deptno = b.deptno
ORDER BY deptno, sal DESC;
--
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) r
    , RANK() OVER(PARTITION BY deptno ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 OR t.r2 = 1
ORDER BY deptno;
-- emp 테이블에서 comm이 400 이하인 사원의 정보 조회(조건 comm이 null인 사원도 포함)
SELECT emp.*
FROM emp
-- LNNVL() 함수 : Where 절의 조건이 true이거나 UNKNOWN이면 FALSE를 반환하고 
-- 조건이 false이면 TRUE를 반환한다.
-- 참/UNKNOWN -> False
WHERE LNNVL(comm > 400); -- NULL comm <= 400 OR comm IS NULL
WHERE NVL(comm,0) <= 400;
WHERE comm <= 400 OR comm IS NULL;

-- 문제 이번 달의 마지막 날짜가 몇 일 까지 있는지 확인
SELECT LAST_DAY(SYSDATE)
    , TO_CHAR(LAST_DAY(SYSDATE),'DD')
    , TRUNC(SYSDATE, 'MONTH')
    
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) -1
    , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) -1,'DD')
FROM dual;

-- emp 테이블에서 sal가 상위 20%에 해당되는 사원의 정보 조회.
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(ORDER BY sal DESC) r
FROM emp
) t
WHERE t.r <= FLOOR((SELECT COUNT(*) FROM emp)*0.2);

SELECT *
FROM(
SELECT emp.*
    , PERCENT_RANK() OVER(ORDER BY sal DESC) pr
FROM emp
) t
WHERE t.pr <= 0.2;

-- 다음 주 월요일은 휴강입니다. 날짜 조회.
SELECT TO_CHAR(SYSDATE,'DS TS(DY)')
    , NEXT_DAY(SYSDATE,'월')
FROM dual;
-- emp 테이블에서 각 사원들의 입사일자를 기준으로 10년 5개월 20일째 되는
-- 날짜를 조회.
SELECT ename, hiredate
    , ADD_MONTHS(hiredate,125)+20
FROM emp;
--
insa 테이블에서 
[실행결과]
                                           부서사원수/전체사원수 == 부/전 비율
                                           부서의 해당성별사원수/전체사원수 == 부성/전%
                                           부서의 해당성별사원수/부서사원수 == 성/부%
                                           
부서명     총사원수 부서사원수 성별  성별사원수  부/전%   부성/전%   성/부%
개발부       60       14         F       8       23.3%     13.3%       57.1%
개발부       60       14         M       6       23.3%     10%       42.9%
기획부       60       7         F       3       11.7%       5%       42.9%
기획부       60       7         M       4       11.7%   6.7%       57.1%
영업부       60       16         F       8       26.7%   13.3%       50%
영업부       60       16         M       8       26.7%   13.3%       50%
인사부       60       4         M       4       6.7%   6.7%       100%
자재부       60       6         F       4       10%       6.7%       66.7%
자재부       60       6         M       2       10%       3.3%       33.3%
총무부       60       7         F       3       11.7%   5%           42.9%
총무부       60       7         M    4       11.7%   6.7%       57.1%
홍보부       60       6         F       3       10%       5%           50%
홍보부       60       6         M       

SELECT buseo 부서명, (SELECT COUNT(*) FROM insa) 총사원수 -- 참고
    , DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F') 성별
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F')) 성별사원수
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2)
ORDER BY buseo;

SELECT s.*
    , ROUND(s.부서사원수/t.총사원수) || '%'
--    , ROUND(,2) || '%'
--    , ROUND(,2) || '%'
FROM(
SELECT buseo
    , (SELECT COUNT(*) FROM insa) 총사원수
    , (SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) 부서사원수
    , gender 성별
    , COUNT(*) 성별사원수
FROM(
SELECT buseo, name, ssn
    , DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F') gender
FROM insa
) t
GROUP BY buseo, gender
ORDER BY buseo, gender
) s;

-- LISTAGG() *** (암기) : 함수
-- https://blog.naver.com/doittall/223307658631
-- 특정 컬럼의 내용들을 1개 셀 안에 나열하고 싶을 때 사용하는 함수
-- LISTAGG 함수는 개별 컬럼에 대해 사용할 수도 있고, GROUP BY 후 각 그룹별로도 사용할 수 있다.
-- SELECT LISTAGG(대상컬럼, '구분문자') WITHIN GROUP (ORDER BY 정렬기준컬럼)
-- FROM TABLE명;

[실행결과]
10   CLARK/MILLER/KING
20   FORD/JONES/SMITH
30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
40   사원없음
--
SELECT LISTAGG(ename,'/') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp;
--
SELECT deptno, LISTAGG(ename,',') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- 문제 insa 테이블에서 TOP_N 분석방식으로
-- 급여 많이 받는 TOP-10 조회(출력)
-- 1. 급여 순으로 ORDER BY 정렬
-- 2. ROWNUM 의사 컬럼 - 순번
-- 3. 순번의 1~10명 SELECT
SELECT ROWNUM, t.*
FROM(
SELECT *
FROM insa
ORDER BY basicpay DESC
) t
WHERE ROWNUM BETWEEN 1 AND 10; -- 중간 뽑기 불가능.
-- [문제]
SELECT TRUNC(SYSDATE,'YEAR') -- 24/01/01
    , TRUNC(SYSDATE,'MONTH') -- 24/08/01
    , TRUNC(SYSDATE,'DD') -- 24/08/11 -- DAY 요일 : 11
    , TRUNC(SYSDATE) -- 24/08/12 : 시간,분,초 절삭
FROM dual;
-- 문제 RPAD LPAD 막대그래프 그리기
[실행결과]
DEPTNO ENAME PAY BAR_LENGTH
---------- ---------- ---------- ----------
30   BLAKE   2850   29    #############################
30   MARTIN   2650   27    ###########################
30   ALLEN   1900   19    ###################
30   WARD   1750   18    ##################
30   TURNER   1500   15    ###############
30   JAMES   950       10    ##########
--
SELECT deptno, ename, sal + NVL(comm,0) pay, CEIL((sal + NVL(comm,0))/100) BAR_LENGTH
    , RPAD(' ',CEIL((sal + NVL(comm,0))/100),'#')
FROM emp
WHERE deptno = 30
ORDER BY pay DESC;

-- ww / iw / w 차이점 파악.
SELECT hiredate
    , TO_CHAR(hiredate,'WW') ww -- 년중 몇 번째 주 1~7 1주
    , TO_CHAR(hiredate,'IW') iw -- 년중 몇 번째 주 월~일 1주
    , TO_CHAR(hiredate,'W') w -- 월중 몇 번째 주
FROM emp;


SELECT hiredate
    , TO_CHAR(TO_DATE('2022.01.01'),'WW')
    , TO_CHAR(TO_DATE('2022.01.02'),'WW')
    , TO_CHAR(TO_DATE('2022.01.03'),'WW')
    , TO_CHAR(TO_DATE('2022.01.04'),'WW')
    , TO_CHAR(TO_DATE('2022.01.05'),'WW')
    , TO_CHAR(TO_DATE('2022.01.06'),'WW')
    , TO_CHAR(TO_DATE('2022.01.07'),'WW')
    , TO_CHAR(TO_DATE('2022.01.08'),'WW')
    , TO_CHAR(TO_DATE('2022.01.14'),'WW')
    , TO_CHAR(TO_DATE('2022.01.15'),'WW')
FROM emp;
-- 문제 emp 테이블에서
-- 사원수가 가장 많은 부서명dname, 사원수
-- 사원수가 가장 적은 부서명, 사원수
-- 출력 join
-- SET 집합연산자 : U, UA
SELECT d.deptno, dname, COUNT(empno) cnt -- 널처리
-- FROM emp e INNER JOIN dept d ON e.deptno = d.deptno -- INNER 생략된거였음. : 양쪽 공통된것만 -- 없이하면 INNER
--FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno -- 공통안된것도 추가
FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno , dname
ORDER BY d.deptno;

SELECT *
FROM (
SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno , dname
ORDER BY cnt_rank ASC
) t
WHERE t.cnt_rank IN (1,4);
--
WITH temp AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
    FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
    GROUP BY d.deptno , dname
    ORDER BY cnt_rank ASC
)
SELECT *
FROM temp
WHERE temp.cnt_rank IN ((SELECT MAX(cnt_rank) FROM temp)
                        , (SELECT MIN(cnt_rank) FROM temp));
-- WITH절 이해(암기)                        
WITH a AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
    FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
    GROUP BY d.deptno , dname
    )
    , b AS (
    SELECT MAX(cnt) maxcnt, MIN(cnt) mincnt
    FROM a
    )
SELECT a.deptno, a.dname, a.cnt, a.cnt_rank
FROM a, b
WHERE a.cnt IN (b.maxcnt, b.mincnt);
-- 피봇(pivot) / 언피봇(unpivot) (암기)
-- 행과 열을 뒤집는 함수
-- https://blog.naver.com/gurrms95/222697767118
-- job별 사원수를 출력
SELECT
    COUNT(DECODE(job, 'CLERK','O')) CLERK
    , COUNT(DECODE(job, 'SALESMAN','O')) SALESMAN
    , COUNT(DECODE(job, 'PRESIDENT','O')) PRESIDENT
    , COUNT(DECODE(job, 'MANAGER','O')) MANAGER
    , COUNT(DECODE(job, 'ANALYST','O')) ANALYST
FROM emp;
--
SELECT job
FROM emp;
--
SELECT *
FROM (SELECT job FROM emp)
PIVOT ( (COUNT(job)) FOR job IN ('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST') );
-- 축을 중심으로 회전시키다. == pivot
SELECT
FROM (피봇 대상 쿼리문)
PIVOT (그룹합수(집계컬럼)) FOR 피벗컬럼 IN (피벗컬럼 AS 별칭..);
-- 2. emp 테이블에서
-- 각 월별 입사한 사원 수 조회.
-- 1월 2월 3월 .. 12월
-- 2   0   5      3
SELECT *
FROM (TO_CHAR(hiredate,'MM') month FROM emp)
PIVOT ( COUNT(month) FOR month IN ('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12'))
ORDER BY year;
-- 문제 emp 테이블에서 job별 사원수 조회.
-- CLERK P
--   3   1
SELECT *
FROM ( SELECT job
FROM emp )
PIVOT ( COUNT(job) FOR job IN ('CLERK','SALESMAN','MANAGER','PRESIDENT','ANALYST') );
-- 문제 emp 테이블에서 부서별/job별 사원수 조회.
--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0
-- 문제 emp 테이블에서 부서별/job별 사원수 조회.
SELECT *
FROM (SELECT d.deptno, dname
    , job
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno) -- RIGHT OUTER JOIN
PIVOT( COUNT(job) FOR job IN ('CLERK','SALESMAN','MANAGER','PRESIDENT','ANALYST') );
-- 피봇 실습문제 각 부서별 총 급여합을 조회.
SELECT *
FROM (SELECT deptno, sal+NVL(comm,0) pay
FROM emp)
PIVOT ( SUM(pay) FOR deptno IN ('10','20','30','40'));
-- 실습문제 : 건너뛰기
SELECT *
FROM (SELECT job, deptno, sal, ename
FROM emp)
PIVOT ( SUM(sal) AS 합계, MAX(sal) AS 최고액, MAX(ename) AS 최고연봉
FOR deptno IN ('10','20','30','40') );

-- 피봇 문제)
-- 생일지남 O   X   오늘
--        20  30    1
SELECT *
FROM (
    SELECT
    CASE SIGN(TO_DATE(SUBSTR(ssn,3,4),'MMDD') - TRUNC(SYSDATE))
                  WHEN 1 THEN 'X'
                  WHEN -1 THEN 'O'
                  ELSE '오늘'
    END s
    FROM insa
)
PIVOT ( COUNT(s) FOR s IN ('X','O','오늘') );
-- 부서번호 4자리로 출력
SELECT '00' || deptno -- 별로 안좋다.
    , TO_CHAR(deptno,'0999')
    , LPAD(deptno,4,'0')
FROM dept;
-- (암기) insa 테이블에서 각 부서별/출신지역별/사원수 몇명인지 출력(조회).
SELECT DISTINCT city
FROM insa;
--
SELECT buseo, city, COUNT(*) 사원수
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;
-- 오라클 10G 새로 추가된 기능 : PARTITION BY OUTER JOIN 구문 사용
WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c ON i.city = c.city -- PARTITION BY 부서로 나눈 후에 city는 다 나와야됨.
GROUP BY buseo, c.city
ORDER BY buseo, c.city;








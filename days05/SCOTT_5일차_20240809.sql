-- SCOTT
-- 문제1) emp 테이블에서 job에 갯수 조회 ?
SELECT COUNT(DISTINCT job)
FROM emp;
--
SELECT COUNT(*)
FROM (
SELECT DISTINCT job
FROM emp
) e;
-- 문제2) emp 테이블의 부서별 사원수 조회 ?
SELECT 10 deptno ,COUNT(*) 사원수
FROM emp
WHERE deptno = 10
UNION ALL
SELECT 20,COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT 30,COUNT(*)
FROM emp
WHERE deptno = 30
UNION ALL
SELECT 40,COUNT(*)
FROM emp
WHERE deptno = 40
UNION ALL
SELECT null,COUNT(*)
FROM emp;
--
SELECT (SELECT COUNT(*) count FROM emp WHERE deptno = 10)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 20)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 30)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 40)
    ,(SELECT COUNT(*) count FROM emp)
FROM dual;
--
SELECT deptno, count(*) -- 그룹화 시킨 후에는 단일행을 같이 쓸 수 있다.
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
-- 문제 제시) emp 테이블에 존재하지 않는 부서도 조회. 40 0
SELECT COUNT(*)
    , COUNT(DECODE(deptno,10,sal)) "10"
    , COUNT(DECODE(deptno,20,sal)) "20"
    , COUNT(DECODE(deptno,30,sal)) "30" -- DECODE : 같지 않으면 null 값을 돌린다. 따라서 COUNT로 null 값을 제외한 수를 가지고 온다.
    , COUNT(DECODE(deptno,40,sal)) "40" -- 컬림이 null 값만 없으면 됨.
FROM emp;
-- 문제) insa 테이블에서 총 사원수, 남자 사원수, 여자 사원수 조회.
SELECT COUNT(*) "총"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자')) "남"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) "여"
FROM insa;
--
SELECT COUNT(*), '전체' gender
FROM insa
UNION ALL
SELECT COUNT(*) cnt
    , CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '남자'
                                  WHEN 0 THEN '여자'
    END gender
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2);
--
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '남자'
                                WHEN 0 THEN '여자'
                                ELSE '전수'
        END gender
    , COUNT(*) cnt
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2)); -- ROLLUP : GROUP BY를 더한 값
-- [문제] emp 테이블에서 가장 급여(pay)를 많이 받는 사원의 정보를 조회.
SELECT MAX(sal+NVL(comm,0)) max_pay
FROM emp;
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (
                        SELECT MAX(sal+NVL(comm,0)) max_pay
                        FROM emp
                        );
-- WHERE sal+NVL(comm,0) = 5000;

-- sql 연산자 : ALL, SOME, ANY, EXISTS (서브쿼리)
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= ALL(SELECT sal+NVL(comm,0) FROM emp); -- 가장 큰 값
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= ALL(SELECT sal+NVL(comm,0) FROM emp); -- 가장 적은 값
-- 문제) emp 테이블에서 각 부서별 최고 급여를 받는 사원의 정보를 조회.      
SELECT deptno, MAX(sal+NVL(comm,0)) -- , MIN(sal+NVL(comm,0))
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
--
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = ANY(
                            SELECT MAX (sal + NVL(comm,0))
                            FROM emp
                            GROUP BY deptno
                                );
--
SELECT *
FROM emp m
-- WHERE sal + NVL(comm,0) = (그 해당 부서의 가장 큰 값 pay);
WHERE sal + NVL(comm,0) = (
                            SELECT MAX (sal + NVL(comm,0))
                            FROM emp s
                            WHERE deptno = m.deptno -- 상호 연관(Correlated) 서브 쿼리
                           )
ORDER BY deptno;
-- 순위, 부서별 순위 1등 - 순위함수
--
SELECT MAX (sal + NVL(comm,0))
FROM emp
WHERE deptno = 10;
-- 문제) emp 테이블의 pay 순위 등수..
SELECT m.*
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal) rank
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
FROM emp m
ORDER BY deptno, dept_rank;
--
SELECT *
FROM (
    SELECT m.*
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal) rank
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
    FROM emp m
      ) t
-- WHERE t.dept_rank = 1;
WHERE t.dept_rank <= 2
ORDER BY deptno, dept_rank;

-- [문제] insa 테이블에서 부서별 인원수가 10명 이상인 부서 조회.
SELECT *
FROM (
SELECT buseo, COUNT(*) cnt
FROM insa
GROUP BY buseo
) t
WHERE cnt >= 10;
--
SELECT buseo, COUNT(*)
FROM insa
GROUP BY buseo
HAVING COUNT(*) >= 10; -- HAVING : GROUP BY한 것에 대한 조건절.

-- [문제] insa 테이블에서 여자 사원수가 5명 이상인 부서 정보 조회.
SELECT buseo, COUNT(*)
FROM insa
GROUP BY buseo
HAVING COUNT(*) >= 5;
--
SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) "여수"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) >= 5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;
-- [문제] emp 테이블에서 사원 전체 평균급여를 계산한 후 각 사원들의 급여가 평균급여보다 많을 경우 "많다" 출력
--                                                                          적을 경우 "적다" 출력
-- 2260.416666666666666666666666666666666667
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '많다'
          WHEN pay < avg_pay THEN '적다'
          ELSE '같다'
       END
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;
-- [문제] emp 테이블에서
--       사원 전체 평균급여(pay)를 계산한 후
--       각 사원들의 급여가 평균급여보다 많을 경우 "많다" 출력
--                                "   적을 경우 "적다" 출력.
-- 2260.416666666666666666666666666666666667
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '많다'
          WHEN pay < avg_pay THEN '적다'
          ELSE '같다'
       END
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;
--
SELECT s.*,  '많다'
FROM emp s
WHERE sal + NVL(comm,0 ) > (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp)
UNION                            
SELECT s.*,  '적다'
FROM emp s
WHERE sal + NVL(comm,0 ) < (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp);
--
SELECT ename, pay, avg_pay
     , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '적다' , '많다') 
FROM (
        SELECT ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
      );
-- [문제] emp 테이블에서 급여 max, min 사원의 정보를 조회.
SELECT MAX(sal + NVL(comm,0))
FROM emp;

SELECT MIN(sal + NVL(comm,0))
FROM emp;

SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (SELECT MAX(sal + NVL(comm,0)) FROM emp)
UNION
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (SELECT MIN(sal + NVL(comm,0)) FROM emp);

SELECT *
    , CASE (sal + NVL(comm,0)
        WHEN (SELECT MAX(sal + NVL(comm,0)) THEN 'MAX'
        WHEN (SELECT MIN(sal + NVL(comm,0)) THEN 'MIN'
    END a
FROM emp
WHERE sal + NVL(comm,0) IN ((SELECT MAX(sal + NVL(comm,0)) FROM emp),
                            (SELECT MIN(sal + NVL(comm,0)) FROM emp));
                            
-- [문제] insa
--      서울 사람 중 부서별 남자,여자 사원 수
--                       남자 급여합, 여자 급여총합 조회.

-- 1) 부서별 남자사원수, 여자사원수
-- 부서별로 집계함수
SELECT buseo
    , COUNT(*) "총"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'남자')) "남수"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) "여수"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "남자 총 급여합"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "여자 총 급여합"
FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo ASC;
-- 풀이2
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi) -- 2차 그룹, ROLLUP : NULL 제외 부분 합.
ORDER BY buseo, jikwi ASC;
--
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자','남자') gender
    , COUNT(*) "사원수"
    , SUM(basicpay) "총급여합"
FROM insa
WHERE city = '서울'
-- GROUP BY buseo, 성별 로 2차 그룹
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2)
ORDER BY buseo, MOD(SUBSTR(ssn,8,1),2);

-- ROWNUM 의사컬럼
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job -- 내부적으로 처리 되는 가짜 컬럼 ROWNUM : 행의 순번을 나타낸다.
FROM emp;

-- TOP_N 분석
    SELECT 컬럼명,..., ROWNUM
	FROM (
          SELECT 컬럼명,... from 테이블명
	      ORDER BY top_n_컬럼명
          )
    WHERE ROWNUM <= n;
--
SELECT ROWNUM, e.*
FROM( -- WITH절도 가능.
SELECT *
FROM emp
ORDER BY sal DESC
) e
-- WHERE ROWNUM BETWEEN 3 AND 5; -- 불가능 : 중간 순위는 찾을 수 없다.
WHERE ROWNUM <= 3; -- 1~3등
WHERE ROWNUM <= 1; -- 1등 하지만, 3~5등까지는 찾을 수 없다.
-- ORDER BY절과 함께 ROWNUM 사용하지말자.
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC; -- 뒤죽박죽
--
SELECT *
FROM(
SELECT ROWNUM seq, e.*
FROM( -- WITH절도 가능.
SELECT *
FROM emp
ORDER BY sal DESC
) e
)
WHERE seq BETWEEN 3 AND 5; -- 인라인뷰 또는 위드절로 한번 더 가공하면 3~5등 값 구할 수 있다.
-- ROLLUP/CUBE 설명
-- ROLLUP과 CUBE는 GROUP BY 절 뒤에 기술한 컬럼 개수에 따라 출력되는 결과 셋이 달라진다.
-- GROUP BY 뒤에 기술한 컬럼이 2개일 경우 ROLLUP은 n+1에서 3개의 그룹별 결과가 출력되고, CUBE는 2*n에서 2*2=4개의 결과 셋이 출력된다.
-- 1) ROLLUP : 그룹화하고 그룹에 대한 부분합
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY dname, job
GROUP BY ROLLUP(dname,job) -- 2차 정렬.
ORDER BY dname ASC;
-- GROUP BY d.deptno, dname -- dname 필요.
-- ORDER BY d.deptno ASC;
-- 2) CUBE : ROLLUP 결과에 GROUP BY절의 조건에 따라 모든 가능한 그룹핑 조합에 대한 결과 출력. 2*N=4
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY dname, job
GROUP BY CUBE(dname,job) -- 2차 정렬. -- CUBE : job별로도 집계가 나온다.
ORDER BY dname ASC;

-- 순위(RANK) 함수.
-- 이 함수는 그룹 내에서 위치를 계산하여 반환한다.
-- 해당 값에 대한 우선순위를 결정(중복 순위 계산함)
-- 반환되는 데이터타입은 숫자이다.
SELECT ename, sal, sal+NVL(comm,0) pay
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK 순번" -- 반드시 OVER(ORDER BY절) 온다. 필수 : 정렬이 필요함. / 동일한 값은 3등에서 건너뛰고 5등이 된다.
    , DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK 순번" -- 동일한 값 다음에 4등
    , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER 순번" -- 똑같은 값이여도 순번을 매겨서 출력함.
FROM emp;
-- JONES 2975 -> 2850 수정
UPDATE emp
SET sal = 2850
WHERE empno = 7566;
-- WHERE ename = X 중복때문에 사용하면 안됨.
COMMIT;

-- 순위 함수 사용 예제.
-- emp 테이블에서 부서별로 급여 순위를 매기자.
SELECT *
FROM(
SELECT emp.*
    -- PARTITION BY deptno : 부서별로 그룹 지어서 순위매겨짐.
    , RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) 순위
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) 전체순위
FROM emp
)
WHERE 순위 BETWEEN 2 AND 3; -- 2~3등 찾을 수 있다.
WHERE 순위 = 1;

-- insa 테이블 사원들을 부서 상관없이 14명씩 팀.. 몇 팀?
SELECT CEIL(COUNT(*)/14) 팀
FROM insa;
-- [문제] insa 테이블에서 사원수가 가장 많은 부서의 부서명,사원수를 조회.
SELECT *
FROM(
SELECT buseo, COUNT(*) 사원수
    , RANK() OVER(ORDER BY COUNT(*) DESC) 부서순위
FROM insa
GROUP BY buseo
-- HAVING RANK() OVER(ORDER BY COUNT(*) DESC) = 1 : 못쓴다.
) e
WHERE 부서순위 = 1;
-- [문제] insa 테이블에서 여자 사원수가 가장 많은 부서 및 사원수 출력
SELECT *
FROM(
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자')) 여자
    , RANK() OVER(ORDER BY COUNT(*) DESC) 부서여자순위
FROM insa
GROUP BY buseo
) e
WHERE 부서여자순위 = 1;
--
SELECT *
FROM(
SELECT buseo, COUNT(*) 사원수
    , RANK() OVER(ORDER BY COUNT(*) DESC) 부서순위
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
-- HAVING RANK() OVER(ORDER BY COUNT(*) DESC) = 1 : 못쓴다.
) e
WHERE 부서순위 = 1;
-- [문제] insa 테이블에서 basicpay(기본급)이 상위 10%만 출력.. 이름, 기본급
SELECT *
FROM(
SELECT name, basicpay
    , RANK() OVER(ORDER BY basicpay DESC) 순위
FROM insa
) e
WHERE 순위 <= (SELECT COUNT(*) FROM insa) * 0.1;
--
SELECT *
FROM(
SELECT name, basicpay
    , PERCENT_RANK() OVER(ORDER BY basicpay DESC) pr
FROM insa
) e
WHERE pr <= 0.1;







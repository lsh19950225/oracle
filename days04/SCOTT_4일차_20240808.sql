-- SCOTT
-- 몫 : 절삭 함수 : FLOOR()

-- 6. SET(집합) 연산자
--    1) UNION        : 합집합
--    2) UNION ALL    : 합집합
SELECT COUNT(*)
FROM (SELECT name, city, buseo
-- ORA-00937: not a single-group group function
    -- , COUNT(*)
FROM insa
WHERE buseo = '개발부') i;

SELECT COUNT(*)
FROM (
SELECT name, city, buseo
FROM insa
WHERE city = '인천') i;

SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부' AND city = '인천';
-- 개발부 + 인천 사원들의 합집합 UNION 17명
-- 14    + 9 = 23 중복 제거된 상태 : UNION 17명, 중복 제거 안함 : UNION ALL 23명
-- ORA-01789: query block has incorrect number of result columns : 컬럼 수가 같아야 함
-- ORA-01790: expression must have same datatype as corresponding expression : 타입도 같아야 함
-- 시험 ***
-- SQL 문에서 집합 연산자를 사용하기 위해서는 집합 연산의 대상이 되는 두 테이블의 컬럼 수가 같고, 대응되는 컬럼끼리 데이터 타입이 동일해야 한다.
-- 컬럼이름은 달라도 상관 없으며, 집합 연산의 결과로 출력되는 컬럼의 이름은 첫 번째 select 절의 컬럼 이름을 따른다.

SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
-- ORDER BY 절은 첫 번째와 두 번째 SELECT 문이 끝난 제일 후미에 넣어야 한다.
-- ORDER BY buseo -- ORA-00933: SQL command not properly ended : 종결이 없다. 오더바이 : 쓸 수 없다.
-- UNION -- 합집합
UNION ALL -- 합집합 위랑 차이.
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

SELECT deptno, dname, loc
FROM dept;

--
-- ORA-01790: expression must have same datatype as corresponding expression : 타입이 다르다.
-- SELECT ename, hiredate, TO_CHAR(deptno) deptno -- 첫번째 컬럼명에 따른다. , 갯수, 타입만 같으면 컬럼명이 달라도 가능.
SELECT ename, hiredate, dname
FROM emp, dept -- 조인
WHERE emp.deptno = dept.deptno
UNION
SELECT name, ibsadate, buseo
FROM insa;

-- 조인(join)
-- 사원이름, 사원명, 입사일자, 부서명 조회
-- emp : 사원이름, 사원명, 입사일자
-- dept : 부서명

-- ORA-00918: column ambiguously defined : 컬럼이 애매하게 선언됨. : dept.deptno 또는 emp.deptno : 결과는 똑같음.
SELECT empno, ename, hiredate, dname, dept.deptno
FROM emp, dept -- 조인했다.
WHERE emp.deptno = dept.deptno; -- 조인조건 - 없을 경우 : 크로스 조인 다 나옴.
-- 위랑 똑같음.
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- 위랑 똑같음.
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e JOIN dept d ON e.deptno = d.deptno;

-- 사원테이블 - 후에 만듦 : 자식 테이블 부서번호(포링키?) 참조
-- 사원번호/사원명/입사일자/잡/기본급/수당/부서번호/부서명/부서장/부서내선번호
-- 관계를 맺어줌.
-- 부서테이블 - 먼저 만듦 : 부모 테이블
-- PK(프라머리키?)고유키 : 부서번호
-- 부서번호/부서명/부서장/부서내선번호

--    3) INTERSECT    : 교집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
INTERSECT -- 교집합
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

--    4) MINUS        : 차집합
SELECT name, city, buseo
FROM insa
WHERE buseo = '개발부'
MINUS -- 차집합
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;

-- 프로젝트시
SELECT name, NULL city, buseo -- 없을 경우 : 맞춰주면됨.
FROM insa
WHERE buseo = '개발부'
UNION
SELECT name, city, buseo
FROM insa
WHERE city = '인천'
ORDER BY buseo;
-- SET 연산자 주의할 점 4가지 숙지 + ORDER BY

-- 계층적 질의 연산자 PRIOR, CONNECT_BY_ROOT 연산자 : 나중에 설명.

-- IS [NOT] NAN : Not A Number : 숫자 이니 아니니
-- IS [NOT] INFINITE : 무한대 이니 아니니

-- [오라클 함수(function)]
-- 1) 단일행 함수
--    ㄱ. 문자 함수
-- [UPPER][LOWER][INITCAP]
SELECT UPPER(dname), LOWER(dname), INITCAP(dname)
FROM dept;
-- [LENGTH] 문자열 길이
SELECT dname
    , LENGTH(dname)
FROM dept;
-- [CONCAT]
-- [SUBSTR]
SELECT ssn, SUBSTR(ssn,8)
FROM insa;
-- [INSTR] 'S' 위치
SELECT dname
    , INSTR(dname,'S') -- 첫번째부터, 없으면 : 0
    , INSTR(dname,'S',2) -- 2번째부터
    , INSTR(dname,'S',-1) -- 뒤 첫번째부터
    , INSTR(dname,'S',-1, 2) -- 뒤부터 첫번째부터 2번째꺼 찾는다.
FROM dept;

SELECT *
FROM tbl_tel;
-- 문제 1) 지역번호만 추출해서 출력
-- 문제 2) 전화번호의 앞자리(3,4자리)만 출력
SELECT seq, tel
    , INSTR(tel,')') -- 괄호 위치값.
    , INSTR(tel,'-') -- - 위치값.
    , SUBSTR(tel,0,INSTR(tel,')')-1) 지역번호 -- 지역번호
    , SUBSTR(tel,INSTR(tel,')')+1) -- 123-1234
    , SUBSTR(tel,INSTR(tel,')')+1, INSTR(tel,'-') - INSTR(tel,')')-1) -- 123
    , SUBSTR(tel, INSTR(tel,'-')+1) -- 1234
FROM tbl_tel;

-- [RPAD/LPAD]
select RPAD('Corea',12,'*')
from dual;

SELECT ename, sal + NVL(comm,0) pay
    , LPAD(sal + NVL(comm,0),10,'*')
FROM emp;

-- [RTRIM/LTRIM] : 특정문자와 일치하는 문자를 제거하고 출력
select RTRIM('BROWINGyxXxy','xy') "RTRIM example"
    , LTRIM('****8978', '*') -- 연속된것만 다 지움.
    , LTRIM('    test    ',' ') -- test    
    , '[' || RTRIM(LTRIM('    test    ',' '),' ') || ']'
    , '[' || TRIM('    test    ') || ']'
from dual;
--
SELECT ASCII('A'), CHR(65) -- 아스키코드 바꾸는 법.
FROM dual;

SELECT ename
    , SUBSTR(ename,1,1)
    , ASCII(SUBSTR(ename,1,1))
FROM emp;
-- [GREATEST/LEAST] : 나열된 숫자 또는 문자 중에 가장 큰, 작은 값을 반환하는 함수
SELECT GREATEST(3,5,2,4,1) max -- 5
    , LEAST(3,5,2,4,1) min -- 1
    , GREATEST('R','A','Z','X')
    , LEAST('R','A','Z','X')
FROM dual;

-- [VSIZE]
SELECT VSIZE(1), VSIZE('A'), VSIZE('한') -- 바이트 사이즈 : 숫자:2, 알파벳:1, 한글:3
FROM dual;

--    ㄴ. 숫자 함수 : 리턴값이 숫자
--    [ROUND(a[,b : 양수, 음수])] - 반올림 함수
SELECT 3.141592
    , ROUND(3.141592) ㄱ -- b x : 3
    , ROUND(3.141592, 0) ㄴ -- b+1 자리에서 반올림. 소수점 1번째 자리. 위랑 같음x : 3
    , ROUND(3.141592, 3) ㄷ
    , ROUND(12345.6789, -2) ㄹ -- 음수이면 소수점 왼쪽 b자리에서 반올림하여 출력한다.
FROM dual;

-- *** ROUND(), TRUNC() : 숫자, 날짜에 씀.

-- [절삭함수 TRUNC(), FLOOR() 차이점]
SELECT FLOOR(3.141592) ㄱ -- 무조건 소수점 1번째 자리에서 절삭
    , FLOOR(3.941592) ㄴ
    , TRUNC(3.141592) ㄷ -- 안주면 FLOOR과 똑같음.
    , TRUNC(3.941592) ㄹ
    , TRUNC(3.941592, 3) ㅁ -- b+1 절삭
    , TRUNC(12345.6789, -2) ㅂ -- ROUND랑 같음.
FROM dual;

-- [올림(절상)함수 CEIL()]
SELECT CEIL(3.14), CEIL(3.94) -- 절상
FROM dual;

-- 게시판 : 총 페이지 수 계산할 때 CEIL() 사용.
SELECT CEIL(161/10) -- 예시) 페이지
    , ABS(10), ABS(-10) -- 절대값
FROM dual;

-- SIGN
SELECT SIGN(100) -- 1
    , SIGN(0) -- 0
    , SIGN(-111) -- -1
    -- , SIGN('A') -- 숫자가 와야됨.
    , SIGN(3.14) -- 1 : 실수도 가능.
FROM dual;

SELECT POWER(2,3) -- 2의 3승
    , SQRT(3) -- 3의 제곱근
FROM dual;

--    ㄷ. 날짜 함수
SELECT SYSDATE a -- 현재의 날짜+시간(초)까지를 리턴하는 함수 : DATE 타입
    -- , ROUND(SYSDATE) -- 오후 12:31 : 24/08/09 정오를 기준으로 날짜가 반올림.
    -- , ROUND(SYSDATE, 'DD') -- 24/08/09
    , ROUND(SYSDATE, 'MONTH') b -- 15일 : 기준 달의 반이 지났는지
    , ROUND(SYSDATE, 'YEAR') c -- 해의 반 기준
FROM dual;

SELECT SYSDATE a
--    , TO_CHAR(SYSDATE, 'DS TS')
--    , TRUNC(SYSDATE)
--    , TO_CHAR(TRUNC(SYSDATE), 'DS TS')
--    , TRUNC(SYSDATE, 'DD') -- 시간/분/초 절삭
--    , TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS') -- 시간/분/초 절삭
    , TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DS TS')
    , TO_CHAR(TRUNC(SYSDATE, 'YEAR'), 'DS TS')
    , TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS')
FROM dual;

-- 날짜에 산술연산을 사용하는 경우.
SELECT SYSDATE
    , SYSDATE + 7 -- 7 : 일수에 해당.
    , SYSDATE - 7
    , SYSDATE + 2/24 -- 2시간 후 날짜.
    -- , SYSDATE - 날짜 = 두 날짜 사이의 간격(일수로 나온다.)
FROM dual;
-- 회사를 입사한 후~ 현재 날짜까지 몇일?
SELECT ename, hiredate
    , CEIL(SYSDATE - hiredate)+1 근무일수 -- 절상 CEIL
FROM emp;
-- 문제) 우리가 개강일로 부터 현재 몇일이 지났는가?
-- 날짜 - 날짜 = 일수
SELECT
    CEIL(SYSDATE - TO_DATE('2024/07/01')) a -- '2024/07/01' : 문자라 날짜로 형변환 필요함.
    , TRUNC(SYSDATE) - TRUNC(TO_DATE('2024/07/01'))+1 b
FROM dual;

SELECT ename, hiredate, SYSDATE
    , MONTHS_BETWEEN(SYSDATE,hiredate) -- 근무개월수
    , MONTHS_BETWEEN(SYSDATE,hiredate)/12 -- 근무년수
FROM emp;

SELECT SYSDATE
    , SYSDATE + 1 -- 하루 증가
    , ADD_MONTHS(SYSDATE,1) -- 1개월 더한다.
    , ADD_MONTHS(SYSDATE,12) -- 1년 더한다.
    , ADD_MONTHS(SYSDATE,-1) -- 1개월 뺀다.
    , ADD_MONTHS(SYSDATE,-12) -- 1년 뺀다.
FROM dual;
--
SELECT SYSDATE a
--    , LAST_DAY(SYSDATE) -- 24/08/31 마지막 날짜가 나온다.
--    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 31일만.
--    , TRUNC(SYSDATE, 'MONTH') -- 24/08/01
--    , TO_CHAR(TRUNC(SYSDATE, 'MONTH'),'DAY') -- 목요일
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)-1 -- 24/08/31
FROM dual;

SELECT SYSDATE
    , NEXT_DAY(SYSDATE,'일') -- 돌아오는 일요일 날짜
    , NEXT_DAY(SYSDATE,'목') -- 돌아오는 목요일 날짜
    , NEXT_DAY(SYSDATE,'목') + 7*2
FROM dual;
-- 문제) 10월 첫 번째 월요일날 휴강..
SELECT SYSDATE
    , NEXT_DAY((ADD_MONTHS(LAST_DAY(SYSDATE),1)+1),'월') a
    , NEXT_DAY(TO_DATE('24/10/01'),'월') b
FROM dual;

SELECT SYSDATE
    , CURRENT_DATE -- session의 날짜 정보를 일/월/년 24시:분:초 형식으로 반환한다.
    , CURRENT_TIMESTAMP -- 나노세컨드까지
FROM dual;

--    ㄹ. 변환 함수

SELECT '1234'
    , TO_NUMBER('1234') -- 문자 : 좌측정렬, 숫자 : 우측정렬
FROM dual;

-- TO_CHAR(NUMBER)/TO_CHAR(CHAR)/TO_CHAR(DATE) : 문자로 변환 함수.
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9G999G999D00') pay -- '9,999,999'도 가능, L : ￦, D : .
FROM insa;

SELECT
    TO_CHAR(100,'S9999') -- S : 부호
    , TO_CHAR(-100,'S9999')
    , TO_CHAR(100,'9999MI') -- 양수일때는 공백
    , TO_CHAR(-100,'9999MI') -- 음수일때는 -
    , TO_CHAR(-100,'9999PR') -- 음수를 <>로 묶는다.  <100>
    , TO_CHAR(100,'9999PR') -- 100
FROM dual;

SELECT ename, sal, comm
    , TO_CHAR((sal + NVL(comm,0))*12,'L9,999,999') pay
    , TO_CHAR((sal + NVL(comm,0))*12,'L9,999') pay -- 자리가 부족하면 ## 처리 됨.
FROM emp;
--  DATE -> 내가 원하는 문자열 형식으로 출력 : TO_CHAR()
SELECT name, ibsadate
    , TO_CHAR(ibsadate,'YYYY.MM.DD DAY')
    -- , TO_CHAR(ibsadate,'YYYY년 MM월 DD일 DAY') -- ORA-01821: date format not recognized : 형식에 알수없는게 있음.
    , TO_CHAR(ibsadate,'YYYY"년" MM"월" DD"일" DAY') -- "" : 기호 제외하고 문자를 인용하고 싶으면 "" 사용.
FROM insa;
-- 홍길동 1998년 10월 11일 일요일

-- *** RR YY 차이점 확인

--    ㅁ. 외 일반 함수

SELECT ename, sal, comm
    , sal + NVL(comm,0) pay
    , sal + NVL2(comm,comm,0) pay
    -- 나열해 놓은 값을 순차적으로 체크하여 null이 아닌 값을 리턴하는 함수
    , COALESCE(sal+comm,sal)
FROM emp;
-- DECODE 함수 *****
SELECT name, ssn
--    , MOD(SUBSTR(ssn,8,1),2)
--    , NULLIF(MOD(SUBSTR(ssn,8,1),2),1)
    , NVL2(NULLIF(MOD(SUBSTR(ssn,8,1),2),1),'여자','남자')
FROM insa;
-- DECODE 함수
-- ㄴ 프로그래밍 언어의 if 문을 sql, pl/sql 안으로 끌어오기 위해서 만들어진 오라클 함수
-- ㄴ FROM 절 외에 사용 가능.
-- ㄴ 비교 연산은 = 만 가능하다.
-- ㄴ DECODE 함수의 확장 함수 : CASE 함수

if(A = B){
    return C;
}
= DECODE(A,B,C);

if(A = B){
    return C;
} else {
    return D;
}
= DECODE(A,B,C,D);

if(A = B){
    return ㄱ;
} else if(A = C){
    return ㄴ;
} else if(A = D){
    return ㄷ;
} else if(A = E){
    return ㄹ;
} else {
    return ㅁ;
}
= DECODE(A,B,ㄱ,C,ㄴ,D,ㄷ,E,ㄹ,ㅁ);

SELECT name, ssn
    , MOD(SUBSTR(ssn,8,1),2)
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자','남자') gender -- if else 구문
FROM insa;

-- 문제) emp 테이블에서 sal의 10% 인상을 하자.
SELECT ename, sal, comm
    , sal + sal/10
FROM emp;
-- 문제) emp 테이블에서 10번 부서원 pay 15% 인상
--                   20번 부서원 pay 10% 인상
--                   그 외 부서원 pay 20% 인상
SELECT ename
    , sal + NVL(comm,0) pay
    , DECODE(deptno,10,(sal + NVL(comm,0))*1.15
    ,20,(sal + NVL(comm,0))*1.1
    ,(sal + NVL(comm,0))*1.2) a
    , (sal + NVL(comm,0)) * DECODE(deptno,10,1.15,20,1.1,1.2) b
FROM emp;

-- CASE 함수 *****
SELECT name, ssn
    , MOD(SUBSTR(ssn,8,1),2)
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'여자','남자') gender
    , CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '남자'
                                  -- WHEN 0 THEN '여자'
                                  ELSE '여자'
        END gender
FROM insa;

--
SELECT ename
    , sal + NVL(comm,0) pay
    
    , DECODE(deptno,10,(sal + NVL(comm,0))*1.15
    ,20,(sal + NVL(comm,0))*1.1
    ,(sal + NVL(comm,0))*1.2) a
    
    , (sal + NVL(comm,0)) * DECODE(deptno,10,1.15,20,1.1,1.2) b
    
    , CASE deptno       WHEN 10 THEN (sal + NVL(comm,0))*1.15
                        WHEN 20 THEN (sal + NVL(comm,0))*1.1
                        ELSE (sal + NVL(comm,0))*1.2
        END c
        
    , (sal + NVL(comm,0)) * CASE deptno
                                WHEN 10 THEN 1.15
                                WHEN 20 THEN 1.1
                                ELSE 1.2
        END d
FROM emp;

-- 2) 복수행 함수(그룹함수)
SELECT COUNT(*), COUNT(ename), COUNT(sal), COUNT(comm) -- 복수함수 : NULL을 무시한다.
    -- , sal -- 복수함수는 단일함수랑 같이 못쓴다.
    , sum(sal) -- 샐러리 총합.
    , sum(comm)/count(*) "AVG_COMM" -- 평균 샐러리 : NULL 포함.
    , AVG(comm) -- 위와 동일. 평균 구하기, AVG : NULL 값은 빼고 카운팅함.
    , MAX(sal) -- 최고값
    , MIN(sal) -- 최저값
FROM emp;

-- 총 사원수 조회.
-- 각 부서별 사원수 조회.
WITH temp AS (
    SELECT deptno
    FROM emp
)
SELECT *
        , CASE deptno   WHEN 10 THEN 1
                        WHEN 20 THEN 1
                        ELSE 1
        END a
FROM temp;



-- 내일 문제풀이 후 오라클 자료형






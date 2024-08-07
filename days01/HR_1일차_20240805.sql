-- HR 계정이 소유하고 있는 테이블 정보 조회.
SELECT *
FROM tabs;
-- first_name last_name    name 조회
-- 오라클 : 문자열 연결 연산자 ||
-- 오라클 : 문자열 '문자열', 날짜도 '날짜형'
SELECT first_name fname
        , first_name || ' ' || last_name AS "N A M E" -- AS "별칭", "" : 공백이 있을 경우.
    -- , CONCAT(first_name, ' ', last_name)
        , CONCAT(CONCAT(first_name, ' '), last_name) AS NAME -- "" 생략 가능.
        , CONCAT(CONCAT(first_name, ' '), last_name) NAME -- AS 생략 가능.
FROM employees;
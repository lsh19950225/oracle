-- SYS
SELECT *
FROM all_tables
WHERE table_name = 'DUAL';
--
SELECT *
FROM scott.emp;
-- FROM 스키마.emp; : sys는 최고 관리자라 다 쓸 수 있지만 쓸려면 이렇게 써야된다.
-- 시노님 생성 - DBA 가능 : SYS
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

SELECT *
FROM arirang;

-- 시노님 삭제
DROP PUBLIC SYNONYM arirang;

-- 시노님 조회
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL'; -- 듀얼 조회.

-- 테이블 조회
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;
FROM tabs;



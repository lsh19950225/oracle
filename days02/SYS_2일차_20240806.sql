-- SYS
SELECT *
FROM dba_users;
FROM all_users;
-- 모든 테이블 정보를 조회. + (OWNER가 SCOTT인 테이블정보만 조회)
SELECT *
FROM all_tables
-- WHERE 조건절;
WHERE owner = 'SCOTT'; -- ORA-00936: missing expression
-- LOB : 큰 자료형
조건 OWNER 가 SCOTT 인 ;
FROM dba_tables;
--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';









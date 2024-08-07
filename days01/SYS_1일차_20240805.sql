-- 모든 사용자 정보를 조회하는 질의(쿼리)
SELECT *
FROM all_users;
-- F5, Ctrl+Enter
-- SCOTT/tiger 계정 생성
CREATE USER SCOTT IDENTIFIED BY tiger;
-- 
SELECT *
FROM dba_users;
-- SYS가 CREATE SESSION 권한 부여
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT, RESOURCE TO SCOTT;
-- Grant을(를) 성공했습니다.
SELECT *
FROM dba_tables;
FROM all_tables; -- 모든 테이블
FROM user_tables; -- 뷰(View)
FROM tabs; -- 위와 동일하다.

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT'
DROP USER scott CASCADE; -- 모든 데이터 삭제.

CREATE USER SCOTT IDENTIFIED BY tiger; -- 계정 생성.

-- 모든 사용자 정보 조회.
-- hr 계정 확인(샘플 계정)
SELECT *
FROM all_users;
-- hr 계정의 비밀번호 lion 수정을 한 후 오라클 접속(녹색)
ALTER USER hr IDENTIFIED BY lion;

ALTER USER hr ACCOUNT UNLOCK;

CREATE USER madang IDENTIFIED BY madang;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO madang;

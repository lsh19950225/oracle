-- ��� ����� ������ ��ȸ�ϴ� ����(����)
SELECT *
FROM all_users;
-- F5, Ctrl+Enter
-- SCOTT/tiger ���� ����
CREATE USER SCOTT IDENTIFIED BY tiger;
-- 
SELECT *
FROM dba_users;
-- SYS�� CREATE SESSION ���� �ο�
-- GRANT CREATE SESSION TO SCOTT;
GRANT CONNECT, RESOURCE TO SCOTT;
-- Grant��(��) �����߽��ϴ�.
SELECT *
FROM dba_tables;
FROM all_tables; -- ��� ���̺�
FROM user_tables; -- ��(View)
FROM tabs; -- ���� �����ϴ�.

-- ORA-01940: cannot drop a user that is currently connected
-- ORA-01922: CASCADE must be specified to drop 'SCOTT'
DROP USER scott CASCADE; -- ��� ������ ����.

CREATE USER SCOTT IDENTIFIED BY tiger; -- ���� ����.

-- ��� ����� ���� ��ȸ.
-- hr ���� Ȯ��(���� ����)
SELECT *
FROM all_users;
-- hr ������ ��й�ȣ lion ������ �� �� ����Ŭ ����(���)
ALTER USER hr IDENTIFIED BY lion;

ALTER USER hr ACCOUNT UNLOCK;

CREATE USER madang IDENTIFIED BY madang;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO madang;

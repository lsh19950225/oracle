-- SYS
SELECT *
FROM all_tables
WHERE table_name = 'DUAL';
--
SELECT *
FROM scott.emp;
-- FROM ��Ű��.emp; : sys�� �ְ� �����ڶ� �� �� �� ������ ������ �̷��� ��ߵȴ�.
-- �ó�� ���� - DBA ���� : SYS
CREATE PUBLIC SYNONYM arirang
FOR scott.emp;

SELECT *
FROM arirang;

-- �ó�� ����
DROP PUBLIC SYNONYM arirang;

-- �ó�� ��ȸ
SELECT *
FROM all_synonyms
WHERE synonym_name = 'DUAL'; -- ��� ��ȸ.

-- ���̺� ��ȸ
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;
FROM tabs;



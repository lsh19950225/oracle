-- SYS
SELECT *
FROM dba_users;
FROM all_users;
-- ��� ���̺� ������ ��ȸ. + (OWNER�� SCOTT�� ���̺������� ��ȸ)
SELECT *
FROM all_tables
-- WHERE ������;
WHERE owner = 'SCOTT'; -- ORA-00936: missing expression
-- LOB : ū �ڷ���
���� OWNER �� SCOTT �� ;
FROM dba_tables;
--
SELECT *
FROM V$RESERVED_WORDS
WHERE keyword = 'DATE';









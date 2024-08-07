-- SCOTT
-- ��¥ �ٷ�� : DATE     TIMESTAMP
-- �������� ���� (������ ��)
SELECT DISTINCT buseo
FROM insa
ORDER BY buseo; -- �����ϸ� ���������� �⺻.
ORDER BY buseo DESC; -- ��������
ORDER BY buseo ASC; -- ��������

 -- emp �޿� ���� �޴� �� ����
SELECT deptno, ename, sal + NVL(comm,0) pay
FROM emp
ORDER BY 1 ASC, 3 DESC; -- Į�� ���� �൵ �ǰ�, Į�� ������ ����.
ORDER BY deptno ASC, pay DESC; -- 2�� ���� : �μ� ��������, pay�� ��������
ORDER BY pay DESC;

-- 8 ��.
SELECT deptno, ename, sal + NVL(comm,0) pay
FROM emp
WHERE (sal + NVL(comm,0) BETWEEN 1000 AND 3000) AND deptno != 30;
ORDER BY emame;
-- 8 ��.
SELECT *
FROM (
    SELECT deptno, ename, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno != 30
    ) e
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename;
-- 8 ��.
WITH temp AS (
    SELECT deptno, ename, sal + NVL(comm,0) pay
    FROM emp
    WHERE deptno != 30
            )
SELECT *
FROM temp
WHERE pay BETWEEN 1000 AND 3000
ORDER BY ename;

-- 9.
SELECT *
FROM emp
WHERE mgr IS NULL;
-- 10.
DESC emp;
-- MGR               NUMBER(4) : ������ ����
SELECT e.*
    , NVL(TO_CHAR(mgr),'CEO')
FROM emp e
WHERE mgr IS NULL;
-- 19.
SELECT ssn
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'MM') month
    , EXTRACT(DAY FROM TO_DATE(SUBSTR(ssn,0,6))) "DATE"
FROM insa;
-- 20.
SELECT name, ssn
FROM insa
-- WHERE ssn LIKE '7_12%'
WHERE REGEXP_LIKE(ssn,'^7\d12')
ORDER BY ssn ASC;
-- 21 ��.
SELECT name, ssn
FROM insa
WHERE ssn LIKE '7_____-1%';
WHERE ssn LIKE '7%' AND SUBSTR(ssn,8,1) = 1;
-- 21 ��.
SELECT name, ssn
FROM insa
-- 1 3 5 7 9 ����
-- WHERE SUBSTR(ssn,8,1) = 1 OR SUBSTR(ssn,8,1) = 3 OR SUBSTR(ssn,8,1) = 5
        -- OR SUBSTR(ssn,8,1) = 7 OR SUBSTR(ssn,8,1) = 9;
-- WHERE ssn LIKE '______-1%' OR ssn LIKE '______-3%' OR ssn LIKE '______-5%'
        -- OR ssn LIKE '______-7%' OR ssn LIKE '______-9%';
WHERE REGEXP_LIKE(ssn,'^7\d{5}-1'); -- {5}���� �´�.
WHERE REGEXP_LIKE(ssn,'^7') AND SUBSTR(ssn,8,1) = 1;
-- 1 3 5 7 9 ����
SELECT e.*
    , SUBSTR(ssn,-7,1) GENDER
    -- , SUBSTR(ssn,-7,1) % 2 -- ORA-00911: invalid character
    , MOD(SUBSTR(ssn,-7,1),2) -- MOD : ������ �� ���ϴ� �Լ�
FROM insa e
WHERE REGEXP_LIKE( ssn , '^7\d{5}-[13579]' );
WHERE ssn LIKE '7%' AND MOD(SUBSTR(ssn,-7,1),2) = 1;
-- 22.
SELECT *
FROM emp
WHERE REGEXP_LIKE(ename, 'la', 'i'); -- i : ��ҹ��� �������� �ʴ´�.,g,m
WHERE ename LIKE '%' || UPPER('la') || '%';
WHERE ename LIKE '%%'; -- �̰͵� �� ���� : ���� ���� �ʴ´�. - �ǹ� �ľ�
WHERE LOWER(ename) LIKE '%la%';
-- 23.
-- PL/SQL(DQL) : SELECT
-- NULLIF : ù��° ���� �ι�° ���� ���Ͽ� �� ���� ������ NULL�� ����ϰ�, 
--          ���� ������ ù��° ���� ����Ѵ�.
SELECT name, ssn
    , NVL2(NULLIF(MOD(SUBSTR(ssn,8,1),2),1),'O','X') GENDER
FROM insa;
-- DECODE() �Լ� �ȹ��
-- CASE() �Լ� �ȹ��
-- 24.
DESC insa;
-- ibsadate : DATE ��¥��
SELECT name, ibsadate
    -- ��¥�� -> �⵵
    , TO_CHAR(SYSDATE, 'YYYY') y
    , TO_CHAR(SYSDATE, 'MM') m
    , TO_CHAR(SYSDATE, 'DD') d
    , TO_CHAR(SYSDATE, 'HH') h
    , TO_CHAR(SYSDATE, 'MI') m
    , TO_CHAR(SYSDATE, 'SS') s
FROM insa;
-- WHERE �Ի�⵵�� 2000�� ����;
-- ���� �ý����� ��¥�� ���� ��, ��, ��, ��, ��, �� ���
SELECT SYSDATE
    , TO_CHAR(SYSDATE, 'YYYY') y
    , TO_CHAR(SYSDATE, 'MM') m
    , TO_CHAR(SYSDATE, 'DD') d
    , TO_CHAR(SYSDATE, 'HH') h
    , TO_CHAR(SYSDATE, 'MI') m
    , TO_CHAR(SYSDATE, 'SS') s
FROM dual;
--
SELECT SYSDATE
    , EXTRACT(YEAR FROM SYSDATE) y
    , EXTRACT(MONTH FROM SYSDATE) m
    , EXTRACT(DAY FROM SYSDATE) d
    , EXTRACT(HOUR FROM CURRENT_TIMESTAMP) h
    -- cast()
    , EXTRACT(HOUR FROM CAST(SYSDATE AS TIMESTAMP)) h -- ORA-30076: invalid extract field for extract source
    , EXTRACT(MINUTE FROM CAST(SYSDATE AS TIMESTAMP)) m
    , EXTRACT(SECOND FROM CAST(SYSDATE AS TIMESTAMP)) s
FROM dual;

SELECT name, ibsadate
FROM insa
WHERE ibsadate >= '2000.01.01';
WHERE EXTRACT(year FROM ibsadate) >= 2000;
WHERE TO_CHAR(ibsadate, 'YYYY') >= 2000;

-- dual ? : ���̺��̴�. 1���� Į���� 1���� �ุ ������ ����.
-- FROM dual;
DESC dual;
-- DUMMY    VARCHAR2(1)
SELECT dummy
FROM dual;
-- ���ڵ�(��) 1�� �� : X
SELECT SYSDATE
FROM emp;
-- DUAL�̶�� ���̺��� SYS ����ڰ� �����ϴ� ����Ŭ�� ǥ�� ���̺�μ� ���� �� ��(row)�� �� �÷��� ��� �ִ� dummy ���̺�μ� �Ͻ����� ��������̳� ��¥ ������ ���Ͽ� �ַ� ���δ�.
-- �ٽ� ���ؼ� �� ���� ���̺��� SYS�� �����̴�. �츮�� SYS�� �α������� �ʰų� SYS.DUAL�� ���� �ʾƵ� ����� �� �ִ� ������ SYS ����ڰ� ��� ����ڵ鿡�� ����� �� �ֵ��� �� ���̺� PUBLIC synonym�� �־��� �����̴�.
-- synonym : ��Ī�� �ذŴ�.
-- 26.
SELECT *
FROM insa
WHERE REGEXP_LIKE(name,'^[����]')
ORDER BY name;
-- 27.
SELECT COUNT(*)
FROM insa;
-- LIKE �������� ESCAPE �ɼ� ����
-- �� wildcard(% _)�� �Ϲ� ����ó�� ���� ���� ��쿡�� ESCAPE �ɼ��� ���
SELECT deptno, dname, loc
FROM dept;
-- dept ���̺� ���ο� �μ������� �߰�.. - Ŀ���̳� �ѹ��� �ؾ� �ݿ���.
-- SQL -> DML : INSERT ��
-- INSERT INTO ���̺��
-- ORA-00001: unique constraint (SCOTT.PK_DEPT) violated : ���ϼ� ���� ���ǿ� ����ȴ�.
-- PK = NN + UK : �����̶� ���ϼ� ���� ������ ���� �ɸ�. ����ũ�� ����
INSERT INTO dept (deptno, dname, loc) VALUES (60,'�ѱ�_����','KOREA');
INSERT INTO dept VALUES (60,'�ѱ�_����','KOREA'); -- ���� ����. ���� ����
COMMIT;
ROLLBACK;
-- [����] �μ��� % ���ڰ� ���Ե� �μ� ������ ��ȸ
SELECT *
FROM dept;

-- wildcard�� �Ϲ� ����ó�� ���� ���� ��쿡�� ESCAPE �ɼ��� ���
WHERE dname LIKE '%\%%' ESCAPE '\'; -- �Ϲݹ��ڰ� �ȴ�.

-- DML(DELETE)
-- ORA-02292: integrity constraint (SCOTT.FK_DEPTNO) violated - child record found : ���Ἲ ���� ���ǿ� ���� : ����Ű
DELETE FROM dept;
DELETE FROM dept -- ���̺��� �����Ű? ������ �־�� �ȴ�.(���� ����) 2�� �̻� ������ ����Ű?
WHERE deptno = 60;
DELETE FROM emp; -- WHERE �������� ������ ��� ���ڵ� ����
SELECT *
FROM emp;
-- DNL(UPDATE)
-- 50 �μ��� QC ������ COREA
-- UPDATE ���̺��
-- SET �÷���=�÷���,�÷���=�÷���,�÷���=�÷���;

UPDATE dept
SET dname = 'QC'; -- WHERE �������� ������ ��� ���ڵ� ����.
ROLLBACK;

SELECT *
FROM dept;

UPDATE dept
--SET dname = dname || 'XX' -- XX �����ؼ� �Ҵ�.
SET dname = SUBSTR(dname,0,2), loc = 'COREA'
WHERE deptno = 50;
ROLLBACK;
-- [����] 40�� �μ��� �μ���, �������� ���ͼ� 50�� �μ��� �μ�������, ���������� �����ϴ� ���� �ۼ�
SELECT *
FROM dept;

SELECT dname
FROM dept
WHERE deptno = 40;

UPDATE dept
SET dname = (SELECT dname FROM dept WHERE deptno = 40)
    , loc = (SELECT loc FROM dept WHERE deptno = 40)
-- SET dname = 'OPERATIONS', loc = 'BOSTON'
WHERE deptno = 50;

-- SELECT dname, loc FROM dept WHERE deptno = 40
UPDATE dept
SET (dname, loc) = (SELECT dname, loc FROM dept WHERE deptno = 40)
WHERE deptno = 50;

-- [����] dept 50, 60, 70 �μ���ȣ�� ����..
DELETE FROM dept
WHERE deptno = 50 OR deptno = 60 OR deptno = 70;
WHERE deptno IN(50,60,70);
WHERE deptno BETWEEN 50 AND 70;
COMMIT;

SELECT *
FROM dept;

-- [����] emp ���̺� ��� ����� sal �⺻���� pay�޿��� 10% �λ��ϴ� UPDATE�� �ۼ�
SELECT *
FROM emp;

SELECT e.*
    , (sal + NVL(comm,0))/10 pay -- �λ���
    , sal + (sal + NVL(comm,0))/10 -- �λ��
FROM emp e;

UPDATE emp
SET sal = sal + (sal + NVL(comm,0))/10;

ROLLBACK;

-- dual ���̺� == �ó��
-- ��Ű��.��ü��
-- �ó�� : �ϳ��� ��ü�� ���� �ٸ� �̸��� �����ϴ� ����̴�.

-- PUBLIC �ó�� ���� - PUBLIC �ּ� Ǯ�� private
-- CREATE [PUBLIC] SYNONYM [schema.]synonym��
-- FOR [schema.]object��;

-- ORA-01031: insufficient privileges : ������ ������� �ʴ�.
-- CREATE PUBLIC SYNONYM arirang
-- FOR scott.emp;

-- ���� �ο�
GRANT SELECT ON emp TO hr; -- scott emp ���̺��� hr���� SELECT ������ �ִ� ��.
-- ���� ȸ��
-- REVOKE ��ü���Ѹ�
	-- ON ��ü��
	-- FROM ����ڸ�, �Ѹ�, PUBLIC
	-- [CASCADE CONSTRAINTS;
    
REVOKE SELECT
	ON emp
	FROM hr;
	[CASCADE CONSTRAINTS;
    
--------------------------------------------------------------------------------
-- ����Ŭ ������(operator) ����
--1) �񱳿����� : = != > < >= <=
--            WHERE ���� ����,����,��¥�� ���� �� ���
--            ANT, SOME, ALL �񱳿�����, SQL�����ڿ��� ����.

--2) �������� : AND OR NOT
--            WHERE ������ ������ ������ ��..

--3) SQL������ : SQL���� �ִ� ������
--    [NOT] IN (list)
--    [NOT] BETWEEN a AND b
--    [NOT] LIKE
--    IS [NOT] NULL
--    ANY, SOME, ALL          WHERE �� + (��������)
--    (TRUE/FALSE)  EXISTS      WHERE �� + (��������)

--4) NULL������

--5) ��������� : ����, ����, ����, ������ (�켱 ����)
SELECT 5+3, 5-3, 5*3, 5/3
    , FLOOR(5/3) -- �� ���ϱ�
    , MOD(5,3) -- ������ ���ϱ�
FROM dual;






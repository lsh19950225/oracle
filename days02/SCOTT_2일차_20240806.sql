-- SCOTT
-- 1) SCOTT ������ ���̺� ��� ��ȸ.
SELECT *
FROM dba_tables;
FROM all_tables;
FROM user_tables;
FROM tabs;
-- ������

-- INSA ���̺� ���� �ľ�
DESCRIBE insa;
DESC insa;
-- NUL : �ʼ��Է»���
--
-- NUMBER(5) == NUMBER(5, 0) == ����
-- �ѱ� 3����Ʈ 20��� 6����
-- INSA ��� ��� ������ ��ȸ.
SELECT *
FROM insa;
-- IBSADATE �Ի�����
-- '98/10/11' ��¥ '' 'RR/MM/DD'  'YY/MM/DD' ������
SELECT *
FROM v$nls_parameters;
-- emp ���̺��� ��� ���� ��ȸ(�����ȣ, �����, �Ի�����) ��ȸ
[WITH] 1
SELECT 6 *
FROM 2 *
[WHERE] 3
[GROUP BY] 4
[HAVING] 5
[ORDER BY] 7
;
-- ����(pay) = �⺻��(sal) + ����(comm) �÷��� �߰��ؼ� ��ȸ.
SELECT empno, ename, hiredate
--        , sal, comm
--        -- , NVL(comm, ��ü�� ��)
--        , NVL(comm, 0)
--        , NVL2(comm,comm,0) -- �ΰ��� �ƴϸ� 2��°, �ΰ��̸� 3��° �� ���
--        , sal + comm
        , sal + NVL(comm, 0) PAY -- �ҹ��ڷ� �ᵵ �빮�ڷ� ���
FROM emp;
-- 1) ����Ŭ NULL �ǹ�? ��Ȯ�� ��. ex) 800 + NULL = NULL
-- 2) ���� x 
-- NVL �Լ��� NULL�� 0 �Ǵ� �ٸ� ������ ��ȯ�ϱ� ���� �Լ��̴�.
-- ����) emp ���̺��� �����ȣ, �����, ���ӻ�� ��ȸ.
-- ���ӻ�簡 ���� ��� 'CEO' ��� ���
SELECT empno, ename, mgr
        -- , NVL2(mgr,mgr,'CEO') -- ORA-01722: invalid number
        -- , NVL(mgr,0) -- ORA-01722: invalid number
        -- , TO_CHAR(mgr) -- �������� : ����, �������� : ����, ���ڷ� �ٲٴ� ����ȯ
        -- , mgr || '' -- ���ڿ��� ����ȯ
        , NVL(TO_CHAR(mgr), 'CEO')
        , NVL(mgr || '', 'CEO')
FROM emp;

DESC emp;

-- emp ���̺���
-- �̸��� 'SMITH'�̰�, ������ CLERK �̴�.
-- ���(��ȸ)
-- �ڹ� \" == "�� ���
SELECT '�̸��� ''' || ename || '''�̰�, ������ ' || job || '�̴�.'
FROM emp; -- '' == '�� ���
-- 65 -> A CHR()
-- SELECT '�̸��� ' || CHR(39) ||ename || CHR(39) || '�̰�, ������ ' || job || '�̴�.'
-- FROM emp;

-- SYS ��� ����� ���� ��ȸ.
-- emp ���̺��� �μ���ȣ�� 10���� ����鸸 ��ȸ.
SELECT *
FROM dept;
-- emp ���̺��� �� ����� ���� �ִ� �μ���ȣ�� ��ȸ.
SELECT DISTINCT deptno
;
SELECT *
FROM emp
WHERE deptno = 10;
-- ����) emp ���̺��� 10�� �μ����� ������ ������ ����� ���� ��ȸ.
-- ����Ŭ �������� : AND OR NOT
SELECT *
FROM emp
WHERE NOT(deptno = 10);
WHERE deptno ^= 10;
WHERE deptno != 10;
WHERE deptno <> 10;
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
--
SELECT *
FROM emp
WHERE deptno IN (20,30,40); -- �ذ� ����
WHERE deptno = 20 OR deptno = 30 OR deptno = 40;
-- [NOT] IN (list) SQL ������

-- [����] emp ���̺��� ������� ford�� ����� ��� ��������� ���(��ȸ)
SELECT *
FROM emp
WHERE ename = UPPER('foRd'); -- UPPER : �빮�� �ٲٴ� �Լ�
WHERE ename = 'FORD'; -- ORA-00904: "FORD": invalid identifier(�ĺ���)
-- ���� ������ ���Ҷ��� ��ҹ��� ����.
--
SELECT LOWER(ename), INITCAP(job) -- LOWER : �ҹ��� �ٲٴ� �Լ� / INITCAP : �ձ��ڸ� �빮��
FROM emp;

-- [����] emp ���̺��� Ŀ�̼��� NULL�� ����� ���� ���(��ȸ)
SELECT *
FROM emp
WHERE comm IS NULL; -- NULL ���Ҷ��� IS NULL, IS NOT NULL
WHERE comm IS NOT NULL;

-- [����] emp ���̺��� 2000 �̻� ����(pay) 4000 ���� �޴� ����� ������ ���(��ȸ)
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) BETWEEN 2000 AND 4000;
WHERE 2000 <= sal + NVL(comm, 0) AND sal + NVL(comm, 0) <= 4000;

SELECT e.*, sal + NVL(comm, 0) pay -- 6
FROM emp e -- == AS e
WHERE pay >= 2000 AND pay <= 4000; -- ORA-00904: "PAY": invalid identifier ó�� ���� ����
--
SELECT e.*, sal + NVL(comm, 0) pay
FROM emp e -- == AS e
WHERE sal + NVL(comm, 0) >= 2000 AND sal + NVL(comm, 0) <= 4000;
-- WITH �� ��� : WITH AS ��������
-- �������� : ���� �ȿ� ���� == ���� ����
WITH temp AS (
            SELECT emp.*, sal + NVL(comm, 0) pay
            FROM emp
            )
SELECT *
FROM temp
WHERE pay >= 2000 AND pay <= 4000;
-- �ζ��� ��(inline view) ��� : FROM �ڿ� ���� ��������, �ݵ�� AS ��Ī ����
-- ���������� WHERE ���� ������ �̸� Nested subquery�� �ϸ�
-- (��ø��������)Nested subquery�߿��� �����ϴ� ���̺��� parent, child���踦 ������ �̸� (�����������)correlated subquery�� �Ѵ�.
SELECT *
FROM (
        SELECT emp.*, sal + NVL(comm, 0) pay
        FROM emp
    ) e
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;
-- �ζ��� ��(inline view) ���
-- NOT BETWEEN A AND B SQL ������ ��� ����..
SELECT *
FROM (
        SELECT emp.*, sal + NVL(comm, 0) pay
        FROM emp
    ) e
WHERE pay BETWEEN 2000 AND 4000; -- �ذ� ����
WHERE pay >= 2000 AND pay <= 4000;
WHERE e.pay >= 2000 AND e.pay <= 4000;

-- [����] insa ���̺��� 70������ ��� ������ ��ȸ
-- (�̸�, �ֹε�Ϲ�ȣ)
-- REGEXP_XXX() ����ǥ������ ����ϴ� �Լ�
-- LIKE()
SELECT name, ssn
    , SUBSTR(ssn,0,1)
    , SUBSTR(ssn,1,1)
    , SUBSTR(ssn,1,2) -- '77' ����
    , INSTR(ssn,7) -- 7�� �� ��ġ ã��
FROM insa
WHERE INSTR(ssn,7) = 1; -- 7�� �� ��ġ�� 1��°��
WHERE TO_NUMBER(SUBSTR(ssn,0,2)) BETWEEN 70 AND 79; -- TO_NUMBER : ���ڸ� ���ڷ� ��ȯ
WHERE SUBSTR(ssn,0,2) BETWEEN 70 AND 79; -- ���� ���¿��� ���� ��.
WHERE SUBSTR(ssn,0,1) = 7;
-- SURSTR()
-- REGEXP_REPLACE()
-- REPLACE() : a1: �������ڿ�
            -- a2: ��ü ���ڿ� a1�߿��� �ٲٱ⸦ ���ϴ� ���ڿ�
            -- a3: �ٲٰ��� �ϴ� ���ο� ���ڿ�
SELECT name, ssn
--    , SUBSTR(ssn,1,8)||'******' RRN
--    , CONCAT(SUBSTR(ssn,1,8), '******') RRN
--    , RPAD(SUBSTR(ssn,1,8),14,'*') RRN -- 14������ ���ʿ� ä��� �����ʿ� *�� �� ä���.
--    , REPLACE(ssn, SUBSTR(ssn,-6), '******') RRN -- -6�� �ڿ�������
    , REGEXP_REPLACE(ssn, '(\d{6}-\d)\d{6}', '\1******')
FROM insa;
--
SELECT name, ssn
    , SUBSTR(ssn,0,6)
    , SUBSTR(ssn,0,2) YEAR
    , SUBSTR(ssn,3,2) MONTH
    , SUBSTR(ssn,5,2) "DATE" -- ORA-00923: FROM keyword not found where expected : DATE �Ұ���
    , TO_DATE(SUBSTR(ssn,0,6)) BIRTH -- '771212' ���� -> ��¥ �� ��ȯ
    -- '77/12/12' DATE -> ��,��,��,�ð�,��,��
    , TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') y -- 'yy' : 2�ڸ�, 'yyyy' : 4�ڸ�
FROM insa
WHERE TO_CHAR(TO_DATE(SUBSTR(ssn,0,6)),'YY') BETWEEN 70 AND 79;
WHERE TO_DATE(SUBSTR(ssn,0,6)) BETWEEN '70/01/01' AND '79/12/31'; -- BETWEEN : ��¥���� ��밡��.
--
SELECT ename, hiredate -- '80/12/17' DATE
--    , SUBSTR(hiredate,1,2) YEAR
--    , SUBSTR(hiredate,4,2) MONTH
--    , SUBSTR(hiredate,-2,2) "DATE"
    -- TO_NUMBER()
    -- TO_DATE()
    -- TO_CHAR() : ���ڷ�
--    , TO_CHAR(hiredate,'YEAR')
--    , TO_CHAR(hiredate,'YYYY') -- '1980'
--    , TO_CHAR(hiredate,'MM') -- '12'
--    , TO_CHAR(hiredate,'DD') -- '17'
--    , TO_CHAR(hiredate,'DAY') -- '�ݿ���'
--    , TO_CHAR(hiredate,'DY') -- '��'

    -- EXTRACT() �����ϴ�. -- ����
    , EXTRACT(YEAR FROM hiredate)
    , EXTRACT(MONTH FROM hiredate)
    , EXTRACT(DAY FROM hiredate)
FROM emp;

-- ���� ��¥���� �⵵/��/��/�ð�/��/�� �������� �ؿ�.
SELECT SYSDATE -- SYSDATE : �Լ�, ���� ��¥ ���. , �ʱ���
    , TO_CHAR(SYSDATE, 'DS TS')
    , CURRENT_TIMESTAMP -- �Լ� : ���� �ý��� �ð��� ���뼼�������
FROM dept;
-- insa ���̺��� 70��� ��� ��� ���� ��ȸ.
-- LIKE SQL ������
-- REGEXP_LIKE �Լ�
SELECT *
FROM insa
WHERE REGEXP_LIKE(ssn,'^7.12'); -- 70��� 12��
WHERE REGEXP_LIKE(ssn,'^7[0-9]12'); -- 70��� 12��
WHERE REGEXP_LIKE(ssn,'^7\d12'); -- 70��� 12��

WHERE REGEXP_LIKE(ssn,'^[78]'); -- ^[78] : 70���, 80���
WHERE REGEXP_LIKE(ssn,'^7'); -- ^7 : 7�� �����ϴ�.
WHERE ssn LIKE '7_12%'; -- 70��� 12����
WHERE ssn LIKE '7%'; -- 70��� ��
WHERE ssn LIKE '______-1______'; -- ����, _ : ��ĭ
WHERE ssn LIKE '______-1%'; -- ����
WHERE ssn LIKE '_______1%'; -- ����
WHERE ssn LIKE '%-1%'; -- ����
WHERE SUBSTR(ssn,8,1) = 1;
WHERE name LIKE '%��'; -- �տ��� �ƹ��ų� �͵� �������. �ڿ��� '��'�� �����ߵ�.
WHERE name LIKE '%��%'; -- ���� ������� '��' ����.
WHERE name LIKE '��%'; -- % : '��' �ڿ� �ƹ��ų� �͵� �������. �ȿ͵� ���� �������͵� �������.

-- [����] insa ���̺��� �达 ���� ������ ��� ��� ���
SELECT name
FROM insa
WHERE REGEXP_LIKE(name, '^[^����ȫ]');
WHERE NOT REGEXP_LIKE(name, '^��');
WHERE REGEXP_LIKE(name, '^��');
WHERE NOT (name NOT LIKE '��%');
WHERE name NOT LIKE '��%';
-- [����]��ŵ��� ����, �λ�, �뱸 �̸鼭 ��ȭ��ȣ�� 5 �Ǵ� 7�� ���Ե� �ڷ� ����ϵ�
--      �μ����� ������ �δ� ��µ��� �ʵ�����. 
--      (�̸�, ��ŵ�, �μ���, ��ȭ��ȣ)
SELECT name, city, buseo, tel
    , LENGTH(buseo)
    , SUBSTR(buseo,0,LENGTH(buseo)-1)
FROM insa
WHERE 
    -- city IN('����','�λ�','�뱸')
    REGEXP_LIKE(city,'����|�λ�|�뱸')
    AND
    -- REGEXP_LIKE(tel,'[57]');
    tel LIKE '%5%' OR tel LIKE '%7%';

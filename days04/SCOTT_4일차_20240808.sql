-- SCOTT
-- �� : ���� �Լ� : FLOOR()

-- 6. SET(����) ������
--    1) UNION        : ������
--    2) UNION ALL    : ������
SELECT COUNT(*)
FROM (SELECT name, city, buseo
-- ORA-00937: not a single-group group function
    -- , COUNT(*)
FROM insa
WHERE buseo = '���ߺ�') i;

SELECT COUNT(*)
FROM (
SELECT name, city, buseo
FROM insa
WHERE city = '��õ') i;

SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�' AND city = '��õ';
-- ���ߺ� + ��õ ������� ������ UNION 17��
-- 14    + 9 = 23 �ߺ� ���ŵ� ���� : UNION 17��, �ߺ� ���� ���� : UNION ALL 23��
-- ORA-01789: query block has incorrect number of result columns : �÷� ���� ���ƾ� ��
-- ORA-01790: expression must have same datatype as corresponding expression : Ÿ�Ե� ���ƾ� ��
-- ���� ***
-- SQL ������ ���� �����ڸ� ����ϱ� ���ؼ��� ���� ������ ����� �Ǵ� �� ���̺��� �÷� ���� ����, �����Ǵ� �÷����� ������ Ÿ���� �����ؾ� �Ѵ�.
-- �÷��̸��� �޶� ��� ������, ���� ������ ����� ��µǴ� �÷��� �̸��� ù ��° select ���� �÷� �̸��� ������.

SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
-- ORDER BY ���� ù ��°�� �� ��° SELECT ���� ���� ���� �Ĺ̿� �־�� �Ѵ�.
-- ORDER BY buseo -- ORA-00933: SQL command not properly ended : ������ ����. �������� : �� �� ����.
-- UNION -- ������
UNION ALL -- ������ ���� ����.
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

SELECT deptno, dname, loc
FROM dept;

--
-- ORA-01790: expression must have same datatype as corresponding expression : Ÿ���� �ٸ���.
-- SELECT ename, hiredate, TO_CHAR(deptno) deptno -- ù��° �÷��� ������. , ����, Ÿ�Ը� ������ �÷����� �޶� ����.
SELECT ename, hiredate, dname
FROM emp, dept -- ����
WHERE emp.deptno = dept.deptno
UNION
SELECT name, ibsadate, buseo
FROM insa;

-- ����(join)
-- ����̸�, �����, �Ի�����, �μ��� ��ȸ
-- emp : ����̸�, �����, �Ի�����
-- dept : �μ���

-- ORA-00918: column ambiguously defined : �÷��� �ָ��ϰ� �����. : dept.deptno �Ǵ� emp.deptno : ����� �Ȱ���.
SELECT empno, ename, hiredate, dname, dept.deptno
FROM emp, dept -- �����ߴ�.
WHERE emp.deptno = dept.deptno; -- �������� - ���� ��� : ũ�ν� ���� �� ����.
-- ���� �Ȱ���.
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- ���� �Ȱ���.
SELECT empno, ename, hiredate, dname, d.deptno
FROM emp e JOIN dept d ON e.deptno = d.deptno;

-- ������̺� - �Ŀ� ���� : �ڽ� ���̺� �μ���ȣ(����Ű?) ����
-- �����ȣ/�����/�Ի�����/��/�⺻��/����/�μ���ȣ/�μ���/�μ���/�μ�������ȣ
-- ���踦 �ξ���.
-- �μ����̺� - ���� ���� : �θ� ���̺�
-- PK(����Ӹ�Ű?)����Ű : �μ���ȣ
-- �μ���ȣ/�μ���/�μ���/�μ�������ȣ

--    3) INTERSECT    : ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
INTERSECT -- ������
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

--    4) MINUS        : ������
SELECT name, city, buseo
FROM insa
WHERE buseo = '���ߺ�'
MINUS -- ������
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;

-- ������Ʈ��
SELECT name, NULL city, buseo -- ���� ��� : �����ָ��.
FROM insa
WHERE buseo = '���ߺ�'
UNION
SELECT name, city, buseo
FROM insa
WHERE city = '��õ'
ORDER BY buseo;
-- SET ������ ������ �� 4���� ���� + ORDER BY

-- ������ ���� ������ PRIOR, CONNECT_BY_ROOT ������ : ���߿� ����.

-- IS [NOT] NAN : Not A Number : ���� �̴� �ƴϴ�
-- IS [NOT] INFINITE : ���Ѵ� �̴� �ƴϴ�

-- [����Ŭ �Լ�(function)]
-- 1) ������ �Լ�
--    ��. ���� �Լ�
-- [UPPER][LOWER][INITCAP]
SELECT UPPER(dname), LOWER(dname), INITCAP(dname)
FROM dept;
-- [LENGTH] ���ڿ� ����
SELECT dname
    , LENGTH(dname)
FROM dept;
-- [CONCAT]
-- [SUBSTR]
SELECT ssn, SUBSTR(ssn,8)
FROM insa;
-- [INSTR] 'S' ��ġ
SELECT dname
    , INSTR(dname,'S') -- ù��°����, ������ : 0
    , INSTR(dname,'S',2) -- 2��°����
    , INSTR(dname,'S',-1) -- �� ù��°����
    , INSTR(dname,'S',-1, 2) -- �ں��� ù��°���� 2��°�� ã�´�.
FROM dept;

SELECT *
FROM tbl_tel;
-- ���� 1) ������ȣ�� �����ؼ� ���
-- ���� 2) ��ȭ��ȣ�� ���ڸ�(3,4�ڸ�)�� ���
SELECT seq, tel
    , INSTR(tel,')') -- ��ȣ ��ġ��.
    , INSTR(tel,'-') -- - ��ġ��.
    , SUBSTR(tel,0,INSTR(tel,')')-1) ������ȣ -- ������ȣ
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

-- [RTRIM/LTRIM] : Ư�����ڿ� ��ġ�ϴ� ���ڸ� �����ϰ� ���
select RTRIM('BROWINGyxXxy','xy') "RTRIM example"
    , LTRIM('****8978', '*') -- ���ӵȰ͸� �� ����.
    , LTRIM('    test    ',' ') -- test    
    , '[' || RTRIM(LTRIM('    test    ',' '),' ') || ']'
    , '[' || TRIM('    test    ') || ']'
from dual;
--
SELECT ASCII('A'), CHR(65) -- �ƽ�Ű�ڵ� �ٲٴ� ��.
FROM dual;

SELECT ename
    , SUBSTR(ename,1,1)
    , ASCII(SUBSTR(ename,1,1))
FROM emp;
-- [GREATEST/LEAST] : ������ ���� �Ǵ� ���� �߿� ���� ū, ���� ���� ��ȯ�ϴ� �Լ�
SELECT GREATEST(3,5,2,4,1) max -- 5
    , LEAST(3,5,2,4,1) min -- 1
    , GREATEST('R','A','Z','X')
    , LEAST('R','A','Z','X')
FROM dual;

-- [VSIZE]
SELECT VSIZE(1), VSIZE('A'), VSIZE('��') -- ����Ʈ ������ : ����:2, ���ĺ�:1, �ѱ�:3
FROM dual;

--    ��. ���� �Լ� : ���ϰ��� ����
--    [ROUND(a[,b : ���, ����])] - �ݿø� �Լ�
SELECT 3.141592
    , ROUND(3.141592) �� -- b x : 3
    , ROUND(3.141592, 0) �� -- b+1 �ڸ����� �ݿø�. �Ҽ��� 1��° �ڸ�. ���� ����x : 3
    , ROUND(3.141592, 3) ��
    , ROUND(12345.6789, -2) �� -- �����̸� �Ҽ��� ���� b�ڸ����� �ݿø��Ͽ� ����Ѵ�.
FROM dual;

-- *** ROUND(), TRUNC() : ����, ��¥�� ��.

-- [�����Լ� TRUNC(), FLOOR() ������]
SELECT FLOOR(3.141592) �� -- ������ �Ҽ��� 1��° �ڸ����� ����
    , FLOOR(3.941592) ��
    , TRUNC(3.141592) �� -- ���ָ� FLOOR�� �Ȱ���.
    , TRUNC(3.941592) ��
    , TRUNC(3.941592, 3) �� -- b+1 ����
    , TRUNC(12345.6789, -2) �� -- ROUND�� ����.
FROM dual;

-- [�ø�(����)�Լ� CEIL()]
SELECT CEIL(3.14), CEIL(3.94) -- ����
FROM dual;

-- �Խ��� : �� ������ �� ����� �� CEIL() ���.
SELECT CEIL(161/10) -- ����) ������
    , ABS(10), ABS(-10) -- ���밪
FROM dual;

-- SIGN
SELECT SIGN(100) -- 1
    , SIGN(0) -- 0
    , SIGN(-111) -- -1
    -- , SIGN('A') -- ���ڰ� �;ߵ�.
    , SIGN(3.14) -- 1 : �Ǽ��� ����.
FROM dual;

SELECT POWER(2,3) -- 2�� 3��
    , SQRT(3) -- 3�� ������
FROM dual;

--    ��. ��¥ �Լ�
SELECT SYSDATE a -- ������ ��¥+�ð�(��)������ �����ϴ� �Լ� : DATE Ÿ��
    -- , ROUND(SYSDATE) -- ���� 12:31 : 24/08/09 ������ �������� ��¥�� �ݿø�.
    -- , ROUND(SYSDATE, 'DD') -- 24/08/09
    , ROUND(SYSDATE, 'MONTH') b -- 15�� : ���� ���� ���� ��������
    , ROUND(SYSDATE, 'YEAR') c -- ���� �� ����
FROM dual;

SELECT SYSDATE a
--    , TO_CHAR(SYSDATE, 'DS TS')
--    , TRUNC(SYSDATE)
--    , TO_CHAR(TRUNC(SYSDATE), 'DS TS')
--    , TRUNC(SYSDATE, 'DD') -- �ð�/��/�� ����
--    , TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS') -- �ð�/��/�� ����
    , TO_CHAR(TRUNC(SYSDATE, 'MONTH'), 'DS TS')
    , TO_CHAR(TRUNC(SYSDATE, 'YEAR'), 'DS TS')
    , TO_CHAR(TRUNC(SYSDATE, 'DD'), 'DS TS')
FROM dual;

-- ��¥�� ��������� ����ϴ� ���.
SELECT SYSDATE
    , SYSDATE + 7 -- 7 : �ϼ��� �ش�.
    , SYSDATE - 7
    , SYSDATE + 2/24 -- 2�ð� �� ��¥.
    -- , SYSDATE - ��¥ = �� ��¥ ������ ����(�ϼ��� ���´�.)
FROM dual;
-- ȸ�縦 �Ի��� ��~ ���� ��¥���� ����?
SELECT ename, hiredate
    , CEIL(SYSDATE - hiredate)+1 �ٹ��ϼ� -- ���� CEIL
FROM emp;
-- ����) �츮�� �����Ϸ� ���� ���� ������ �����°�?
-- ��¥ - ��¥ = �ϼ�
SELECT
    CEIL(SYSDATE - TO_DATE('2024/07/01')) a -- '2024/07/01' : ���ڶ� ��¥�� ����ȯ �ʿ���.
    , TRUNC(SYSDATE) - TRUNC(TO_DATE('2024/07/01'))+1 b
FROM dual;

SELECT ename, hiredate, SYSDATE
    , MONTHS_BETWEEN(SYSDATE,hiredate) -- �ٹ�������
    , MONTHS_BETWEEN(SYSDATE,hiredate)/12 -- �ٹ����
FROM emp;

SELECT SYSDATE
    , SYSDATE + 1 -- �Ϸ� ����
    , ADD_MONTHS(SYSDATE,1) -- 1���� ���Ѵ�.
    , ADD_MONTHS(SYSDATE,12) -- 1�� ���Ѵ�.
    , ADD_MONTHS(SYSDATE,-1) -- 1���� ����.
    , ADD_MONTHS(SYSDATE,-12) -- 1�� ����.
FROM dual;
--
SELECT SYSDATE a
--    , LAST_DAY(SYSDATE) -- 24/08/31 ������ ��¥�� ���´�.
--    , TO_CHAR(LAST_DAY(SYSDATE), 'DD') -- 31�ϸ�.
--    , TRUNC(SYSDATE, 'MONTH') -- 24/08/01
--    , TO_CHAR(TRUNC(SYSDATE, 'MONTH'),'DAY') -- �����
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)-1 -- 24/08/31
FROM dual;

SELECT SYSDATE
    , NEXT_DAY(SYSDATE,'��') -- ���ƿ��� �Ͽ��� ��¥
    , NEXT_DAY(SYSDATE,'��') -- ���ƿ��� ����� ��¥
    , NEXT_DAY(SYSDATE,'��') + 7*2
FROM dual;
-- ����) 10�� ù ��° �����ϳ� �ް�..
SELECT SYSDATE
    , NEXT_DAY((ADD_MONTHS(LAST_DAY(SYSDATE),1)+1),'��') a
    , NEXT_DAY(TO_DATE('24/10/01'),'��') b
FROM dual;

SELECT SYSDATE
    , CURRENT_DATE -- session�� ��¥ ������ ��/��/�� 24��:��:�� �������� ��ȯ�Ѵ�.
    , CURRENT_TIMESTAMP -- ���뼼�������
FROM dual;

--    ��. ��ȯ �Լ�

SELECT '1234'
    , TO_NUMBER('1234') -- ���� : ��������, ���� : ��������
FROM dual;

-- TO_CHAR(NUMBER)/TO_CHAR(CHAR)/TO_CHAR(DATE) : ���ڷ� ��ȯ �Լ�.
SELECT num, name
    , basicpay, sudang
    , basicpay + sudang pay
    , TO_CHAR(basicpay + sudang, 'L9G999G999D00') pay -- '9,999,999'�� ����, L : ��, D : .
FROM insa;

SELECT
    TO_CHAR(100,'S9999') -- S : ��ȣ
    , TO_CHAR(-100,'S9999')
    , TO_CHAR(100,'9999MI') -- ����϶��� ����
    , TO_CHAR(-100,'9999MI') -- �����϶��� -
    , TO_CHAR(-100,'9999PR') -- ������ <>�� ���´�.  <100>
    , TO_CHAR(100,'9999PR') -- 100
FROM dual;

SELECT ename, sal, comm
    , TO_CHAR((sal + NVL(comm,0))*12,'L9,999,999') pay
    , TO_CHAR((sal + NVL(comm,0))*12,'L9,999') pay -- �ڸ��� �����ϸ� ## ó�� ��.
FROM emp;
--  DATE -> ���� ���ϴ� ���ڿ� �������� ��� : TO_CHAR()
SELECT name, ibsadate
    , TO_CHAR(ibsadate,'YYYY.MM.DD DAY')
    -- , TO_CHAR(ibsadate,'YYYY�� MM�� DD�� DAY') -- ORA-01821: date format not recognized : ���Ŀ� �˼����°� ����.
    , TO_CHAR(ibsadate,'YYYY"��" MM"��" DD"��" DAY') -- "" : ��ȣ �����ϰ� ���ڸ� �ο��ϰ� ������ "" ���.
FROM insa;
-- ȫ�浿 1998�� 10�� 11�� �Ͽ���

-- *** RR YY ������ Ȯ��

--    ��. �� �Ϲ� �Լ�

SELECT ename, sal, comm
    , sal + NVL(comm,0) pay
    , sal + NVL2(comm,comm,0) pay
    -- ������ ���� ���� ���������� üũ�Ͽ� null�� �ƴ� ���� �����ϴ� �Լ�
    , COALESCE(sal+comm,sal)
FROM emp;
-- DECODE �Լ� *****
SELECT name, ssn
--    , MOD(SUBSTR(ssn,8,1),2)
--    , NULLIF(MOD(SUBSTR(ssn,8,1),2),1)
    , NVL2(NULLIF(MOD(SUBSTR(ssn,8,1),2),1),'����','����')
FROM insa;
-- DECODE �Լ�
-- �� ���α׷��� ����� if ���� sql, pl/sql ������ ������� ���ؼ� ������� ����Ŭ �Լ�
-- �� FROM �� �ܿ� ��� ����.
-- �� �� ������ = �� �����ϴ�.
-- �� DECODE �Լ��� Ȯ�� �Լ� : CASE �Լ�

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
    return ��;
} else if(A = C){
    return ��;
} else if(A = D){
    return ��;
} else if(A = E){
    return ��;
} else {
    return ��;
}
= DECODE(A,B,��,C,��,D,��,E,��,��);

SELECT name, ssn
    , MOD(SUBSTR(ssn,8,1),2)
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����','����') gender -- if else ����
FROM insa;

-- ����) emp ���̺��� sal�� 10% �λ��� ����.
SELECT ename, sal, comm
    , sal + sal/10
FROM emp;
-- ����) emp ���̺��� 10�� �μ��� pay 15% �λ�
--                   20�� �μ��� pay 10% �λ�
--                   �� �� �μ��� pay 20% �λ�
SELECT ename
    , sal + NVL(comm,0) pay
    , DECODE(deptno,10,(sal + NVL(comm,0))*1.15
    ,20,(sal + NVL(comm,0))*1.1
    ,(sal + NVL(comm,0))*1.2) a
    , (sal + NVL(comm,0)) * DECODE(deptno,10,1.15,20,1.1,1.2) b
FROM emp;

-- CASE �Լ� *****
SELECT name, ssn
    , MOD(SUBSTR(ssn,8,1),2)
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����','����') gender
    , CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '����'
                                  -- WHEN 0 THEN '����'
                                  ELSE '����'
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

-- 2) ������ �Լ�(�׷��Լ�)
SELECT COUNT(*), COUNT(ename), COUNT(sal), COUNT(comm) -- �����Լ� : NULL�� �����Ѵ�.
    -- , sal -- �����Լ��� �����Լ��� ���� ������.
    , sum(sal) -- ������ ����.
    , sum(comm)/count(*) "AVG_COMM" -- ��� ������ : NULL ����.
    , AVG(comm) -- ���� ����. ��� ���ϱ�, AVG : NULL ���� ���� ī������.
    , MAX(sal) -- �ְ�
    , MIN(sal) -- ������
FROM emp;

-- �� ����� ��ȸ.
-- �� �μ��� ����� ��ȸ.
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



-- ���� ����Ǯ�� �� ����Ŭ �ڷ���






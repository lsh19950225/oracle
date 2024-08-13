-- SCOTT
-- [����] emp, dept
--   ����� �������� �ʴ� �μ��� �μ���ȣ, �μ����� ���
SELECT d.deptno, dname, COUNT(empno)
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno, dname
HAVING COUNT(empno) = 0
ORDER BY d.deptno ASC;
--
WITH t AS (
SELECT deptno
FROM dept
MINUS
SELECT DISTINCT deptno
FROM emp
)
SELECT t.deptno, d.dname
FROM t JOIN dept d ON t.deptno = d.deptno;
--
SELECT t.deptno, d.dname
FROM (
SELECT deptno
FROM dept
MINUS
SELECT DISTINCT deptno
FROM emp
)
t JOIN dept d ON t.deptno = d.deptno;
-- SQL ������ ALL, ANY, SOME, (NOT EXITS)
SELECT m.deptno, m.dname
FROM dept m
WHERE NOT EXISTS ( SELECT empno FROM emp WHERE deptno = m.deptno ); -- NOT EXISTS : �������� �ʴ´ٸ�, EXISTS : �����Ѵٸ�

-- �����������
SELECT m.deptno, m.dname
FROM dept m
WHERE ( SELECT COUNT(*) FROM emp WHERE deptno = m.deptno ) = 0; -- emp ���̺� �������� �ʴ� �μ�����;

-- ���� insa ���̺��� �� �μ��� ���ڻ������ �ľ��ؼ� 5�� �̻��� �μ� ���� ���.
SELECT *
FROM (
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) ��
FROM insa
GROUP BY buseo
) t
WHERE �� >= 5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;
-- [����] insa ���̺�
--     [�ѻ����]      [���ڻ����]      [���ڻ����] [��������� �ѱ޿���]  [��������� �ѱ޿���] [����-max(�޿�)] [����-max(�޿�)]
------------ ---------- ---------- ---------- ---------- ---------- ----------
--        60                31              29           51961200                41430400                  2650000          2550000
SELECT COUNT(*) �ѻ����
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����')) ���ڻ����
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) ���ڻ����
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "��������� �ѱ޿���"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "��������� �ѱ޿���"
    , MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "����-max(�޿�)"
    , MAX(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "����-max(�޿�)"
FROM insa;
-- ��.
SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����',0,'����','��ü') || '�����'
    , COUNT(*) �����
    , SUM(basicpay) �޿���
    , MAX(basicpay) �ְ�
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));
-- [����] emp ���̺���~
--      �� �μ��� �����, �μ� �ѱ޿���, �μ� ��ձ޿�
���)
    DEPTNO       �μ�����       �ѱ޿���            ���
---------- ----------       ----------    ----------
        10          3          8750       2916.67
        20          3          6775       2258.33
        30          6         11600       1933.33 
        40          0         0             0
SELECT d.deptno, COUNT(empno) �μ�����
    , NVL(SUM(sal + NVL(comm,0)),0) �ѱ޿���
    , NVL(ROUND(AVG(sal + NVL(comm,0)),2),0) ���
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno -- OUTER ��������.
GROUP BY d.deptno
ORDER BY d.deptno;
--
FROM e.deptno(+) = d.deptno -- ����Ʈ �ƿ��� ����

-- ROLLUP���� CUBE��
-- �� GROUP BY������ ���Ǿ� �׷캰 �Ұ踦 �߰��� �����ִ� ����
-- �� ��, �߰����� ���� ������ �����ش�.
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2)
        WHEN 1 THEN '����'
        WHEN 0 THEN '����'
    END ����
    , COUNT(*) �����
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2)
UNION ALL
SELECT '��ü', COUNT(*)
FROM insa;
-- GROUP BY + ROLLUP/CUBE ���
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2)
        WHEN 1 THEN '����'
        WHEN 0 THEN '����'
        ELSE '��ü'
    END ����
    , COUNT(*) �����
FROM insa
GROUP BY CUBE(MOD(SUBSTR(ssn,8,1),2));
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2));

-- ROLLUP / CUBE �� ������..
-- 1�� �μ����� �׷���, 2�� �������� �׷���.
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY buseo, jikwi
-- ORDER BY buseo, jikwi;
UNION ALL
SELECT buseo, NULL, COUNT(*)
FROM insa
GROUP BY buseo
ORDER BY buseo, jikwi;
-- ROLLUP
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY ROLLUP(buseo, jikwi)
ORDER BY buseo, jikwi;
-- 2. CUBE
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY CUBE(buseo, jikwi)
ORDER BY buseo, jikwi;
--ORDER BY buseo, jikwi;
UNION ALL
SELECT buseo, NULL, COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT NULL, jikwi, COUNT(*)
FROM insa
GROUP BY jikwi
ORDER BY buseo, jikwi;

-- ���� ROLLUP
SELECT buseo, jikwi, COUNT(*) �����
FROM insa
GROUP BY ROLLUP(buseo), jikwi -- ������ ���� �κ� ����, ��ü���� x
-- GROUP BY buseo, ROLLUP(jikwi) -- �μ��� ���� �κ� ����, ��ü���� x
-- GROUP BY ROLLUP(buseo, jikwi)
-- GROUP BY CUBE(buseo, jikwi) -- + ����,�븮,����,���
ORDER BY buseo, jikwi;

-- [GROUPING SETS �Լ�]
SELECT buseo, '', COUNT(*)
FROM insa
GROUP BY buseo
UNION ALL
SELECT jikwi, '', COUNT(*)
FROM insa
GROUP BY jikwi;
--
SELECT buseo, jikwi, COUNT(*)
FROM insa
GROUP BY GROUPING SETS(buseo, jikwi) -- �׷����� ���踸 ���´�.
ORDER BY buseo, jikwi;

-- �Ǻ�(pivot)
-- 1. ���̺� ���谡 �߸���. ������Ʈ�� ����
tbl_pivot ���̺� ����
��ȣ, �̸�, ��, ��, �� ���� ���̺�
-- DDL�� : CREATE
CREATE TABLE tbl_pivot -- ���̺��
(
    -- �÷��� �ڷ���(ũ��) ��������..
    no NUMBER PRIMARY KEY -- ������Ű(PK) : �������� -- �� ����� ã�� �� �ִ� Ű �ߺ��ȵǰ�
    , name VARCHAR2(20 BYTE) NOT NULL -- NN : ��������(== �ʼ��Է»���)
    , jumsu NUMBER(3) -- NULL ��� : NOT NULL �Ⱥ�ġ��
);
-- Table TBL_PIVOT��(��) �����Ǿ����ϴ�.
SELECT *
FROM tbl_pivot;
-----
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '�ڿ���', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '�ڿ���', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '�ڿ���', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '�Ƚ���', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '�Ƚ���', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '�Ƚ���', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '���', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '���', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '���', 100 );  -- mat 
-----
ROLLBACK;

COMMIT;

-- ����) �Ǻ�
--��ȣ �̸�   ��,  ��,  ��
--1   �ڿ���  90 89 99
--2   �Ƚ���  56 45 12
--3   ���    99 85 100
--
SELECT *
FROM (
SELECT TRUNC((no-1)/3)+1 no
    , name
    , jumsu
    , DECODE(MOD(no,3),1,'����',2,'����',0,'����') subject
FROM tbl_pivot
)
PIVOT ( SUM(jumsu) FOR subject IN ('����','����','����') )
ORDER BY no ASC;
--
SELECT *
FROM (
SELECT TRUNC((no-1)/3)+1 no
    , name
    , jumsu
    , ROW_NUMBER() OVER(PARTITION BY name ORDER BY no) subject
FROM tbl_pivot
)
PIVOT ( SUM(jumsu) FOR subject IN (1 AS "����",2 AS "����",3 AS "����") )
ORDER BY no ASC;

-- [Ǯ��] ���⵵�� ���� �Ի��ѻ���� �ľ�(��ȸ).
YEAR      MONTH          N
---- ---------- ----------
1980          1          0
1980          2          0
1980          3          0
1980          4          0
1980          5          0
1980          6          0
1980          7          0
1980          8          0
1980          9          0
1980         10          0
1980         11          0

YEAR      MONTH          N
---- ---------- ----------
1980         12          1
1981          1          0
1981          2          2
1981          3          0
1981          4          1
1981          5          1
1981          6          1
1981          7          0
1981          8          0
1981          9          2
1981         10          0
SELECT TO_CHAR(hiredate,'YYYY') h_year
    , COUNT(*)
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

-- ORA-01788: CONNECT BY clause required in this query block : CONNECT BY ���� ��ߵ�.
SELECT LEVEL month -- ����(�ܰ�)�� ��Ÿ���� �Լ�
FROM dual
CONNECT BY LEVEL <= 12;
--
SELECT empno, TO_CHAR(hiredate,'YYYY') year
    , TO_CHAR(hiredate,'MM') month
FROM emp;
--
SELECT year, m.month, NVL(COUNT(empno),0) n
FROM (
    SELECT empno, TO_CHAR(hiredate,'YYYY') year
    , TO_CHAR(hiredate,'MM') month
    FROM emp
) e PARTITION BY(e.year) RIGHT OUTER JOIN (
    SELECT LEVEL month
    FROM dual
    CONNECT BY LEVEL <= 12
) m
ON e.month = m.month
GROUP BY year, m.month
ORDER BY year, m.month;
-- [Ǯ��] insa ���̺��� �μ���, ������ �����
SELECT buseo, jikwi, COUNT(*)
FROM insa
GROUP BY buseo, jikwi
ORDER BY buseo, jikwi;
-- [����] �� �μ���, ������ �ּһ����, �ִ����� ��ȸ.
WITH t1 AS (
SELECT buseo, jikwi, COUNT(*) tot_count
FROM insa
GROUP BY buseo, jikwi
), t2 AS (
    SELECT buseo
    , MIN(tot_count) buseo_min_count
    , MAX(tot_count) buseo_max_count
    FROM t1
    GROUP BY buseo
)
SELECT a.buseo
    , b.jikwi �ּ�����
    , b.tot_count �ּһ����
FROM t2 a, t1 b
WHERE a.buseo = b.buseo AND a.buseo_min_count = b.tot_count;

-- FIRST/LAST �м��Լ� ����ؼ� Ǯ��..
WITH t AS (
SELECT buseo, jikwi, COUNT(*) tot_count
FROM insa
GROUP BY buseo, jikwi
)
SELECT t.buseo
    , MIN(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count ASC) �ּ�����
    , MIN(t.tot_count) �ּһ����
    , MAX(t.jikwi) KEEP(DENSE_RANK FIRST ORDER BY t.tot_count ASC) �ִ�����
    , MAX(t.tot_count) �ִ�����
FROM t
GROUP BY t.buseo
ORDER BY 1; -- 1 : t.buseo

-- 2����
-- 1) �м��Լ� FIRST, LAST
--          �����Լ�(COUNT,SUM,AVG,MAX,MIN)�� ���� ����Ͽ�
--          �־��� �׷쿡 ���� ���������� ������ �Ű� ����� �����ϴ� �Լ�
SELECT MAX(sal)
    , MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    , MAX(empno) KEEP(DENSE_RANK FIRST ORDER BY sal DESC) max_ename
    , MIN(sal)
    , MAX(ename) KEEP(DENSE_RANK LAST ORDER BY sal DESC) min_ename
    , MAX(ename) KEEP(DENSE_RANK FIRST ORDER BY sal ASC) min_ename
FROM emp;
--
WITH a AS
(
    SELECT d.deptno, dname, COUNT(empno) cnt
    FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
    GROUP BY d.deptno, dname
)
SELECT MIN(cnt)
    , MAX(dname) KEEP(DENSE_RANK LAST ORDER BY cnt DESC) min_dname
    , MAX(cnt)
    , MAX(dname) KEEP(DENSE_RANK FIRST ORDER BY cnt DESC) max_dname
FROM a;
-- 2) SELF JOIN : �ڱ� �ڽŰ� ����
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON a.mgr = b.empno;

-- NON EQUAL JOIN

-- [EQUAL JOIN] == [INNER]
FROM emp e INNER JOIN dept d ON e.deptno = d.deptno 

-- [NON EQUAL JOIN]
SELECT *
FROM salgrade;
-- [NON EQUAL JOIN]
SELECT empno, ename, sal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal; -- = �� �Ⱦ��� ����
-- ũ�ν�����
SELECT empno, ename, sal, grade
FROM emp e,salgrade s;
-- ���ҽ�..
SELECT ename, sal
   ,  CASE
        WHEN  sal BETWEEN 700 AND 1200 THEN  1
        WHEN  sal BETWEEN 1201 AND 1400 THEN  2
        WHEN  sal BETWEEN 1401 AND 2000 THEN  3
        WHEN  sal BETWEEN 2001 AND 3000 THEN  4
        WHEN  sal BETWEEN 3001 AND 9999 THEN  5
      END grade
FROM emp;

-- [����] emp ���̺��� ���� �Ի����ڰ� ���� �����
--                    ���� �Ի����ڰ� ���� ������� �Ի� ���� �� �� ?
SELECT MAX(hiredate) - MIN(hiredate) -- ��¥���� MAX, MIN �� �� �ִ�.
FROM emp;

-- �м��Լ� : CUME_DIST() -- �߿������ʴ�.
--  �� �־��� �׷쿡 ���� ������� ���� ������ ���� ��ȯ
--  �� ��������(����) 0 <   <= 1
SELECT deptno, ename, sal
    , CUME_DIST() OVER(ORDER BY sal ASC) dept_list
    , CUME_DIST() OVER(PARTITION BY deptno ORDER BY sal ASC) dept_list
FROM emp;

-- �м��Լ� : PERCENT_RANK()
-- �� �ش� �׷� ���� ����� ����
-- 0 <= ������ �� <= 1
-- ����� ���� ? �׷� �ȿ��� �ش� ���� ������ ���� ���� ����

-- NTILE() NŸ�� : ��ü�׷��� ������ ������ ������. �м��Լ�
-- �� ��Ƽ�� ���� expr�� ��õ� ��ŭ ������ ����� ��ȯ�ϴ� �Լ�
-- �����ϴ� ���� ��Ŷ(bucket)�̶�� �Ѵ�.
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal ASC) ntiles -- 4�׷����� ������.
FROM emp;
--
SELECT deptno, ename, sal
    , NTILE(2) OVER(PARTITION BY deptno ORDER BY sal ASC) ntiles
FROM emp;
--
SELECT deptno, ename, sal
    , NTILE(4) OVER(ORDER BY sal) nitles
    , WIDTH_BUCKET(sal,1000,4000,4) widthbuckets -- WIDTH_BUCKET : 1000~4000�� 4�ܰ�� ����. 750�� / 1000 �Ʒ� : 0, 4000 �� : 5
FROM emp;

-- LAG(expr,offset,default_value) �м�
-- �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
-- �� ����(��) ��
-- LEAD(expr,offset,default_value) �м�
-- �� �־��� �׷�� ������ ���� �ٸ� �࿡ �ִ� ���� ������ �� ����ϴ� �Լ�
-- �� ����(��) ��
SELECT deptno, ename, hiredate, sal
    , LAG(sal,3,100) OVER(ORDER BY hiredate) pre_sal -- ��������(offset:n)�� : 3�� ��� / ������ �⺻(����Ʈ:n)�� : 100
    , LEAD(sal,1,-1) OVER(ORDER BY hiredate) next_sal -- �������� ���� ��� / ������ �⺻�� : -1 - ���� ����
FROM emp
WHERE deptno = 30;

--------------------------------------------------------------------------------
-- [����Ŭ �ڷ���(Data Type)]
1. CHAR[(SIZE [BYTE|CHAR])] -- ���ڿ� ���� �ڷ���
    CHAR = CHAR(1 BYTE) = CHAR(1)
    CHAR(3 BYTE) = CHAR(3) -- 'ABC', '��' : ���ĺ� 1����Ʈ, �ѱ� 3����Ʈ
    CHAR(3 CHAR) -- ex) 'ABC', '�ѵμ�' ���ڸ� 3�� ������ �� �ִ� �ڷ���
    ���� ������ ���ڿ� �ڷ���
    name CHAR(10 BYTE) [a][b][c][][][][][][][] 'abc' -- �������̷� �Ҵ��. �������� �״�� �Ҵ�Ǿ�����.
    2000 BYTE ���� ũ�� �Ҵ��� �� �ִ�.
    ��) �ֹε�Ϲ�ȣ(14), �й�, ��ȭ��ȣ -- ���������� ���ڿ� �� : CHAR ���.
    -- �׽�Ʈ
    CREATE TABLE tbl_char
    (
    aa char -- char(1) == char(1 byte)
    , bb char(3) -- char(3 byte)
    , cc char(3 char)
    );
    
    DESC tbl_char;
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('a','aaa','aaa');
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('b','��','�ѿ츮');
    -- SQL ����: ORA-12899: value too large for column "SCOTT"."TBL_CHAR"."BB" (actual: 9, maximum: 3)
    INSERT INTO tbl_char (aa,bb,cc) VALUES ('c','�ѿ츮','�ѿ츮'); -- bb : '�ѿ츮' ���� �ȸ���.
    -- �θ� ���̺� ���� �ۼ��ϰ� �ڽ� ���̺� ä���ֱ�.
    
    SELECT *
    FROM tbl_char;
    
    ROLLBACK;

2. NCHAR
    N == UNICODE(�����ڵ�) : �����ڵ� : ��� ���� 2����Ʈ��
    NCHAR[(SIZE)]
    NCHAR(1) == NCHAR
    NCHAR(10) == ���ĺ� 10����, �ѱ� 10����
    �������� ���ڿ� �ڷ���
    �ִ� 2000 BYTE ���� ����.

    CREATE TABLE tbl_nchar
    (
    aa char(3) -- char
    , bb char(3 char) -- char
    , cc nchar(3) -- nchar
    );
    
    SELECT *
    FROM tbl_nchar;
    
    INSERT INTO tbl_nchar (aa,bb,cc) VALUES('ȫ','�浿','ȫ�浿');
    INSERT INTO tbl_nchar (aa,bb,cc) VALUES('ȫ�浿','ȫ�浿','ȫ�浿'); -- aa���� �ɸ�.
    
    COMMIT;
    
���� ���ڿ� - CHAR/NCHAR �ִ� 2000 BYTE

3. VARCHAR2 ==> ��Ī VARCHAR
    VAR : ���� ����
    ���� ���� ���ڿ� �ڷ���
    �ִ� 4000 BYTE
    VARCHAR2(SIZE BYTE|CHAR)
    VARCHAR2(1) = VARCHAR(1 BYTE) == VARCHAR2
    name VARCHAR2(10) [a][d][m][i][n] ���� : [][][][][] 'admin'

4. NVARCHAR2
    �����ڵ� ���ڸ� �����ϴ� ���� ���� ���ڿ� �ڷ���
    NVARCHAR2(SIZE)
    NVARCHAR2(1) = NVARCHAR2
    �ִ� 4000 BYTE

5.  NUMBER[(p[,s])]
    p : precision ��Ȯ�� / s : scale �Ը�
        ��ü�ڸ���           �Ҽ��������ڸ���
        1~38                -84~127
    NUMBER = NUMBER(38,127) -- �Ѵ� �ִ밪����
    NUMBER(p) = NUMBER(p,0) -- ���ָ� �Ҽ��� 0 �ڸ���
    
    ��)
    CREATE TABLE tbl_number
    (
    no NUMBER(2) NOT NULL PRIMARY KEY -- NN + UK
    , name VARCHAR2(30) NOT NULL
    -- , name CLOB -- 2GB �̻� �� ū �ڷ���
    , kor NUMBER(3) -- -999 ~ 999 / �Ǽ��� ���� �־ �Ҽ��� �ݿø��ؼ� ������ ����.
    , eng NUMBER(3) -- 0 <= <= 100 : �������� : üũ���������� - ���߿� �˷���
    , mat NUMBER(3) DEFAULT 0 -- �Է¾��ҽ� 0 ���
    );

SELECT *
FROM tbl_number;

INSERT INTO tbl_number (no,name,kor,eng,mat) VALUES (1,'ȫ�浿',90,88,98);
COMMIT;
-- SQL ����: ORA-00947: not enough values : �������� ������� �ʴ�.
-- INSERT INTO tbl_number (no,name,kor,eng,mat) VALUES (2,'�̽���',100,100); -- �÷��� ������ߵ�.
INSERT INTO tbl_number (no,name,kor,eng) VALUES (2,'�̽���',100,100);
COMMIT;
-- SQL ����: ORA-00947: not enough values
-- INSERT INTO tbl_number VALUES (3,'�ۼ�ȣ',50,50); -- �÷����� ������ ��� �������.
INSERT INTO tbl_number VALUES (3,'�ۼ�ȣ',50,50,100); -- ���� �־�ߵ�.
COMMIT;
INSERT INTO tbl_number (name,no,kor,eng,mat) VALUES ('�����',4,50,50,100); -- �÷� ��ġ�� ���߸� ��ġ ���� ����.
COMMIT;
--
SELECT *
FROM tbl_number;
--
-- ORA-00001: unique constraint (SCOTT.SYS_C007028) violated : ���ϼ� �������� : ������ ������ �ȵȴ�. 4�� ����.
-- INSERT INTO tbl_number VALUES (4,'�輱��',110,56.234,-999); -- �Ǽ� : �ݿø�
INSERT INTO tbl_number VALUES (5,'�輱��',110,56.934,-999); -- �Ǽ� : �ݿø�
ROLLBACK;

-- NUMBER(4,5)ó�� scale�� precision���� ũ�ٸ�, �̴� ù�ڸ��� 0�� ���̰� �ȴ�.
-- 0 �� ������
.01234 NUMBER(4,5) .01234 
.00012 NUMBER(4,5) .00012 
.000127 NUMBER(4,5) .00013 
.0000012 NUMBER(2,7) .0000012 
.00000123 NUMBER(2,7) .0000012 

6. FLOAT[(p)] == ���������� NUMBER ó�� ��Ÿ����. -- ���� �Ⱦ�.

7. LONG ���� ����(VAR �Ⱥ���.) ���ڿ� �ڷ���, 2GB

8. DATE ��¥, �ð�(�ʱ���) ��Ÿ��. (�������� 7 BYTE ���߿���)
    TIMESTAMP

9. RAW(SIZE) - 2000 BYTE ���������� 0, 1�� ����
    LONG RAW - 2GB       ���������� 0, 1�� ����

LOB : ���� ������Ʈ

10. LOB : CLOB, NCLOB, BLOB, BFILE

-- FIRST_VALUE �м��Լ� : ���ĵ� �� �߿� ù ��° ��.
SELECT FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) -- basicpay ���� ū ��
FROM insa;

SELECT FIRST_VALUE(basicpay) OVER(PARTITION BY buseo ORDER BY basicpay DESC) -- �ش� �μ��� ���� ū ��
FROM insa;
-- ���� ���� �޿� �� ����� basicpay�� ����
SELECT buseo, name, basicpay
    , FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) max_basicpay -- FIRST_VALUE : �м��� ���� ù��° ��.
    , FIRST_VALUE(basicpay) OVER(ORDER BY basicpay DESC) - basicpay ����
FROM insa;

-- COUNT ~ OVER : ������ ���� ������ ��� ��ȯ.
SELECT name, basicpay
    , COUNT(*) OVER(ORDER BY basicpay ASC)
FROM insa;

SELECT name, basicpay, buseo
    , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
FROM insa;
-- SUM ~ OVER : ������ ���� ������ �� ��� ��ȯ.
SELECT name, basicpay, buseo
    -- , COUNT(*) OVER(ORDER BY basicpay ASC)
    , SUM(basicpay) OVER(ORDER BY buseo ASC)
FROM insa;

SELECT name, basicpay, buseo
    -- , COUNT(*) OVER(PARTITION BY buseo ORDER BY basicpay ASC)
    , SUM(basicpay) OVER(PARTITION BY buseo ORDER BY buseo ASC)
FROM insa;
--
SELECT buseo, SUM(basicpay)
FROM insa
GROUP BY buseo
ORDER BY buseo;
-- AVG ~ OVER : ������ ���� ������ ��� ��� ��ȯ.
SELECT name, basicpay, buseo
    , AVG(basicpay) OVER(ORDER BY buseo ASC)
FROM insa;

-- ���̺� ����, ����, ���� DDL : CREATE, ALTER, DROP TABLE
-- ���̺�(table) ? ������ �����
-- ���̵� ���� 10����Ʈ
-- �̸�   ���� 20����Ʈ
-- ����   ���� 30����Ʈ
-- ��ȭ��ȣ ���� 20����Ʈ
-- ����   ��¥
-- ���   ���� 255����Ʈ
CREATE TABLE tbl_sample
(
 id VARCHAR2(10)
 , name VARCHAR2(20)
 , age NUMBER(3)
 , birth DATE
);
SELECT *
FROM tabs
WHERE REGEXP_LIKE(table_name,'^TBL_','i'); -- i : ��ҹ��� �������.
WHERE table_name LIKE 'TBL\_%' ESCAPE '\';
--
DESC tbl_sample;
-- ��ȭ��ȣ, ��� Į�� ���� ����. -> ���̺� ���� : ALTER
ALTER TABLE tbl_sample
ADD ( -- �÷� �Ѱ� ����� ��ȣ ���� ����.
tel VARCHAR2(20) -- DEFAULT '000-0000-0000' : �൵��.
, bigo VARCHAR2(255)
);

SELECT *
FROM tbl_sample;
-- ��� �÷��� ũ�� ����, �ڷ��� ����. ALTER
--           (255 -> 100)

? �������� type, size, default ���� ������ �� �ִ�.
? ���� ��� �÷��� �����Ͱ� ���ų� null ���� ������ ��쿡�� size�� ���� �� �ִ�.
? ������ Ÿ���� ������ CHAR�� VARCHAR2 ��ȣ���� ���游 �����ϴ�.
? �÷� ũ���� ������ ����� �������� ũ�⺸�� ���ų� Ŭ ��쿡�� �����ϴ�.
? NOT NULL �÷��� ��쿡�� size�� Ȯ�븸 �����ϴ�.
? �÷��� �⺻�� ������ �� ���Ŀ� ���ԵǴ� ����� ������ �ش�.
? �÷��̸��� �������� ������ �Ұ����ϴ�.
? �÷��̸��� ������ ���������� ���� ���̺� ������ alias�� �̿��Ͽ� ������ �����ϴ�.
? alter table ... modify�� �̿��Ͽ� constraint�� ������ �� ����.

 ������ Ÿ�� ���� ���ɻ��� SIZE 
NULL �÷� ���� �� ���� �� ��¥ Ȯ��, ��Ұ��� 
NOT NULL �÷� CHAR �� VARCHAR2 Ȯ�븸 ���� 


ALTER TABLE tbl_sample
MODIFY (bigo VARCHAR2(100));

DESC tbl_example;

-- bigo �÷��� -> memo �÷��� ����
ALTER TABLE tbl_sample
    RENAME COLUMN bigo TO memo;

-- ���̺� ����
DROP TABLE ���̺�� CASCADE;

-- memo �÷� ����
? �÷��� �����ϸ� �ش� �÷��� ����� �����͵� �Բ� �����ȴ�.
? �ѹ��� �ϳ��� �÷��� ������ �� �ִ�.
? ���� �� ���̺��� ��� �ϳ��� �÷��� �����ؾ� �Ѵ�.
? DDL������ ������ �÷��� ������ �� ����.
ALTER TABLE tbl_sample
DROP COLUMN memo;

-- ���̺���� ���� tbl_sample -> tbl_example ����.
RENAME tbl_sample TO tbl_example;
-- ���̺� �̸��� ����Ǿ����ϴ�.
DESC tbl_example;

-- update set, insert � ����.
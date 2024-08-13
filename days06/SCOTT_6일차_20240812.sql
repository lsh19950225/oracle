-- SCOTT
-- [����] emp ���̺��� ename, pay, ��ձ޿�, ����, �ݿø�, ���� �Լ�(�Ҽ��� 3�ڸ�)
SELECT ename, sal + NVL(comm,0) pay
    , (SELECT AVG(sal + NVL(comm,0)) FROM emp) AVG_PAY
    , CEIL((sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp))*100)/100 "�� �ø�" -- CEIL(n)
    , ROUND(sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp),2) "�� �ݿø�"
    , TRUNC(sal + NVL(comm,0) - (SELECT (AVG(sal + NVL(comm,0))) FROM emp),2) "�� ����"
FROM emp;

-- [����] emp ���̺���
--      pay, avg_pay
--                  ����, ����, ���� ���
-- ename, pay, avg_pay, (��, ��, ��)
--      ��. SET ���� ������(U UA M I)
SELECT t.*
    , CASE        WHEN t.pay > t.avg_pay THEN '����'
                  WHEN t.pay < t.avg_pay THEN '����'
                  ELSE '����'
    END ��
FROM(
SELECT ename, sal + NVL(comm,0) pay, (SELECT AVG(sal + NVL(comm,0)) FROM emp) avg_pay
FROM emp
) t;

-- [����] insa ���̺��� ssn �ֹε�Ϲ�ȣ, ������ ������ ������. ������ �ʾҴ��� ���.
UPDATE insa
SET ssn = SUBSTR(ssn,0,2) || TO_CHAR(SYSDATE,'MMDD') || SUBSTR(ssn,7)
WHERE NUM = 1002;

SELECT *
FROM insa;

ROLLBACK;

COMMIT;

SELECT num, name , ssn
     , SUBSTR(ssn,3,4) ����
     , TO_DATE(SUBSTR(ssn,3,4),'MMDD') a -- 24/12/12
     -- ��¥ - ��¥ = �����ϼ�
     , TO_DATE(SUBSTR(ssn,3,4),'MMDD') - TRUNC(SYSDATE) b -- TRUNC ���� �ʿ�.
     , CASE         WHEN TO_CHAR(SYSDATE,'MMDD') > SUBSTR(ssn,3,4) THEN '������' -- �ϼ��� ��� �� SIGN : ����ؼ� Ǯ�� ����.
                    WHEN TO_CHAR(SYSDATE,'MMDD') < SUBSTR(ssn,3,4) THEN '��������'
                    ELSE '����'
        END ��
FROM insa;
-- 1) 1002 �̼��� �ֹε�Ϲ�ȣ ��/�� -> ���ó�¥�� ��/�Ϸ� ����(UPDATE)
-- 2)

-- [����] insa ���̺��� �ֹε�Ϲ�ȣ(ssn) �����̸� ����ؼ� ���
-- ����(1,2) 1900     3,4 2000    0,9 1800    5,6 �� 1900    7,8 �� 2000
-- ������ : ���ϳ⵵ 2024-1998 -1(���� ���� ����)
-- name, ssn, ����⵵, ���س⵵, ������
SELECT t.name, t.ssn, ����⵵, ���س⵵
    , ���س⵵ - ����⵵  + CASE bs
                               WHEN -1 THEN  -1                               
                               ELSE 0
                          END  ������
FROM (
        SELECT name, ssn
         , TO_CHAR( SYSDATE , 'YYYY' ) ���س⵵
         , SUBSTR( ssn, -7, 1) ����
         , SUBSTR( ssn, 0, 2) ���2�ڸ��⵵
         , CASE 
             WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6) THEN 1900
             WHEN SUBSTR( ssn, -7, 1) IN ( 3,4,7,8) THEN 2000
             ELSE 1800
           END +  SUBSTR( ssn, 0, 2) ����⵵
           -- 0, -1 ����������..
           -- 1      ���� ��꿡��    -1
         , SIGN( TO_DATE( SUBSTR( ssn, 3, 4 ) , 'MMDD' )  - TRUNC( SYSDATE ) )  bs 
        FROM insa
) t;
-- Math.random() ������ ��
-- Random Ŭ���� nextInt() ������ ��
-- DBMS_RANDOM ��Ű��
-- �ڹ� ��Ű�� - ���� ���õ� Ŭ�������� ����
-- ����Ŭ ��Ű�� - ���� ���õ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)���� ���� : ���� ����, ����
-- package : PL/SQL�� ��Ű���� ����Ǵ� Ÿ��, ���α׷� ��ü, �������α׷�(procedure, function)�� �������� ���� ���� ��
-- 0.0 <= SYS.dbms_random.value < 1.0 : �Ǽ�
SELECT
    SYS.dbms_random.value -- �Լ�
--    , SYS.dbms_random.value(0,100) -- 0.0 <= �Ǽ� < 100.0
--    , SYS.dbms_random.string('U',5) -- �����ϰ� �빮�� 5���� : ���� -- �Լ�
--    , SYS.dbms_random.string('L',5) -- �ҹ��� : �ο�
--    , SYS.dbms_random.string('X',5) -- �����ϰ� �빮��+����
    , SYS.dbms_random.string('P',5) -- �빮��+�ҹ���+����+Ư������
    , SYS.dbms_random.string('A',5) -- A : ���ĺ� ��ҹ���
FROM dual;

-- [����] ������ ���� ���� 1�� ���
-- 0.0 <= �Ǽ� < 101.0
SELECT ROUND(SYS.dbms_random.value(0,100)) a
    , TRUNC(SYS.dbms_random.value(0,101)) b
    , CEIL(SYS.dbms_random.value(0,100)) c
FROM dual;
-- [����] ������ �ζ� ��ȣ 1�� ���
SELECT FLOOR(SYS.dbms_random.value(1,45))
FROM dual;
-- [����] ������ ���� 6�ڸ��� �߻����Ѽ� ���
SELECT FLOOR(SYS.dbms_random.value(100000,999999)) a
    , TRUNC(SYS.dbms_random.value(100000,1000000)) c
    , FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9))
    || FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9))
    || FLOOR(SYS.dbms_random.value(0,9)) || FLOOR(SYS.dbms_random.value(0,9)) b
FROM dual;

-- [����] insa ���̺��� ���� �����, ���� ����� ���
SELECT DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����','����') ����
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����','����')) ��
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2);
-- [����] insa ���̺��� �μ���  ���� �����, ���� ����� ���
SELECT buseo
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2);
-- emp ���̺��� �ְ� �޿���, ���� �޿��� ������� ��ȸ
SELECT MAX(sal) FROM emp;
-- ���� �Լ�
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(ORDER BY sal DESC) r
    , RANK() OVER(ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 or t.r2 = 1;
--
SELECT *
FROM emp a, (SELECT MAX(sal) max, MIN(sal) min FROM emp) b
WHERE a.sal = b.max OR a.sal = b.min;

SELECT *
FROM emp
WHERE -- (SELECT MAX(sal) FROM emp) = sal OR (SELECT MIN(sal) FROM emp) = sal
    sal IN ((SELECT MAX(sal) FROM emp), (SELECT MIN(sal) FROM emp))
ORDER BY sal DESC;

-- �� �μ���
SELECT *
FROM emp m
WHERE sal IN ((SELECT MAX(sal) FROM emp WHERE deptno = m.deptno)
            , (SELECT MIN(sal) FROM emp WHERE deptno = m.deptno))
ORDER BY deptno, sal DESC;
--
-- 12 x 3 = 36 ũ�ν� ����
SELECT a.*
FROM emp a, (SELECT MAX(sal) max, MIN(sal) min FROM emp GROUP BY deptno) b
WHERE a.sal = b.max OR a.sal = b.min AND a.deptno = b.deptno
ORDER BY deptno, sal DESC;
--
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) r
    , RANK() OVER(PARTITION BY deptno ORDER BY sal ASC) r2
FROM emp
) t
WHERE t.r = 1 OR t.r2 = 1
ORDER BY deptno;
-- emp ���̺��� comm�� 400 ������ ����� ���� ��ȸ(���� comm�� null�� ����� ����)
SELECT emp.*
FROM emp
-- LNNVL() �Լ� : Where ���� ������ true�̰ų� UNKNOWN�̸� FALSE�� ��ȯ�ϰ� 
-- ������ false�̸� TRUE�� ��ȯ�Ѵ�.
-- ��/UNKNOWN -> False
WHERE LNNVL(comm > 400); -- NULL comm <= 400 OR comm IS NULL
WHERE NVL(comm,0) <= 400;
WHERE comm <= 400 OR comm IS NULL;

-- ���� �̹� ���� ������ ��¥�� �� �� ���� �ִ��� Ȯ��
SELECT LAST_DAY(SYSDATE)
    , TO_CHAR(LAST_DAY(SYSDATE),'DD')
    , TRUNC(SYSDATE, 'MONTH')
    
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1)
    , ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) -1
    , TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE, 'MONTH'),1) -1,'DD')
FROM dual;

-- emp ���̺��� sal�� ���� 20%�� �ش�Ǵ� ����� ���� ��ȸ.
SELECT *
FROM(
SELECT emp.*
    , RANK() OVER(ORDER BY sal DESC) r
FROM emp
) t
WHERE t.r <= FLOOR((SELECT COUNT(*) FROM emp)*0.2);

SELECT *
FROM(
SELECT emp.*
    , PERCENT_RANK() OVER(ORDER BY sal DESC) pr
FROM emp
) t
WHERE t.pr <= 0.2;

-- ���� �� �������� �ް��Դϴ�. ��¥ ��ȸ.
SELECT TO_CHAR(SYSDATE,'DS TS(DY)')
    , NEXT_DAY(SYSDATE,'��')
FROM dual;
-- emp ���̺��� �� ������� �Ի����ڸ� �������� 10�� 5���� 20��° �Ǵ�
-- ��¥�� ��ȸ.
SELECT ename, hiredate
    , ADD_MONTHS(hiredate,125)+20
FROM emp;
--
insa ���̺��� 
[������]
                                           �μ������/��ü����� == ��/�� ����
                                           �μ��� �ش缺�������/��ü����� == �μ�/��%
                                           �μ��� �ش缺�������/�μ������ == ��/��%
                                           
�μ���     �ѻ���� �μ������ ����  ���������  ��/��%   �μ�/��%   ��/��%
���ߺ�       60       14         F       8       23.3%     13.3%       57.1%
���ߺ�       60       14         M       6       23.3%     10%       42.9%
��ȹ��       60       7         F       3       11.7%       5%       42.9%
��ȹ��       60       7         M       4       11.7%   6.7%       57.1%
������       60       16         F       8       26.7%   13.3%       50%
������       60       16         M       8       26.7%   13.3%       50%
�λ��       60       4         M       4       6.7%   6.7%       100%
�����       60       6         F       4       10%       6.7%       66.7%
�����       60       6         M       2       10%       3.3%       33.3%
�ѹ���       60       7         F       3       11.7%   5%           42.9%
�ѹ���       60       7         M    4       11.7%   6.7%       57.1%
ȫ����       60       6         F       3       10%       5%           50%
ȫ����       60       6         M       

SELECT buseo �μ���, (SELECT COUNT(*) FROM insa) �ѻ���� -- ����
    , DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F') ����
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F')) ���������
FROM insa
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2)
ORDER BY buseo;

SELECT s.*
    , ROUND(s.�μ������/t.�ѻ����) || '%'
--    , ROUND(,2) || '%'
--    , ROUND(,2) || '%'
FROM(
SELECT buseo
    , (SELECT COUNT(*) FROM insa) �ѻ����
    , (SELECT COUNT(*) FROM insa WHERE buseo = t.buseo) �μ������
    , gender ����
    , COUNT(*) ���������
FROM(
SELECT buseo, name, ssn
    , DECODE(MOD(SUBSTR(ssn,8,1),2),1,'M','F') gender
FROM insa
) t
GROUP BY buseo, gender
ORDER BY buseo, gender
) s;

-- LISTAGG() *** (�ϱ�) : �Լ�
-- https://blog.naver.com/doittall/223307658631
-- Ư�� �÷��� ������� 1�� �� �ȿ� �����ϰ� ���� �� ����ϴ� �Լ�
-- LISTAGG �Լ��� ���� �÷��� ���� ����� ���� �ְ�, GROUP BY �� �� �׷캰�ε� ����� �� �ִ�.
-- SELECT LISTAGG(����÷�, '���й���') WITHIN GROUP (ORDER BY ���ı����÷�)
-- FROM TABLE��;

[������]
10   CLARK/MILLER/KING
20   FORD/JONES/SMITH
30   ALLEN/BLAKE/JAMES/MARTIN/TURNER/WARD
40   �������
--
SELECT LISTAGG(ename,'/') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp;
--
SELECT deptno, LISTAGG(ename,',') WITHIN GROUP(ORDER BY ename ASC) ename
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;

-- ���� insa ���̺��� TOP_N �м��������
-- �޿� ���� �޴� TOP-10 ��ȸ(���)
-- 1. �޿� ������ ORDER BY ����
-- 2. ROWNUM �ǻ� �÷� - ����
-- 3. ������ 1~10�� SELECT
SELECT ROWNUM, t.*
FROM(
SELECT *
FROM insa
ORDER BY basicpay DESC
) t
WHERE ROWNUM BETWEEN 1 AND 10; -- �߰� �̱� �Ұ���.
-- [����]
SELECT TRUNC(SYSDATE,'YEAR') -- 24/01/01
    , TRUNC(SYSDATE,'MONTH') -- 24/08/01
    , TRUNC(SYSDATE,'DD') -- 24/08/11 -- DAY ���� : 11
    , TRUNC(SYSDATE) -- 24/08/12 : �ð�,��,�� ����
FROM dual;
-- ���� RPAD LPAD ����׷��� �׸���
[������]
DEPTNO ENAME PAY BAR_LENGTH
---------- ---------- ---------- ----------
30   BLAKE   2850   29    #############################
30   MARTIN   2650   27    ###########################
30   ALLEN   1900   19    ###################
30   WARD   1750   18    ##################
30   TURNER   1500   15    ###############
30   JAMES   950       10    ##########
--
SELECT deptno, ename, sal + NVL(comm,0) pay, CEIL((sal + NVL(comm,0))/100) BAR_LENGTH
    , RPAD(' ',CEIL((sal + NVL(comm,0))/100),'#')
FROM emp
WHERE deptno = 30
ORDER BY pay DESC;

-- ww / iw / w ������ �ľ�.
SELECT hiredate
    , TO_CHAR(hiredate,'WW') ww -- ���� �� ��° �� 1~7 1��
    , TO_CHAR(hiredate,'IW') iw -- ���� �� ��° �� ��~�� 1��
    , TO_CHAR(hiredate,'W') w -- ���� �� ��° ��
FROM emp;


SELECT hiredate
    , TO_CHAR(TO_DATE('2022.01.01'),'WW')
    , TO_CHAR(TO_DATE('2022.01.02'),'WW')
    , TO_CHAR(TO_DATE('2022.01.03'),'WW')
    , TO_CHAR(TO_DATE('2022.01.04'),'WW')
    , TO_CHAR(TO_DATE('2022.01.05'),'WW')
    , TO_CHAR(TO_DATE('2022.01.06'),'WW')
    , TO_CHAR(TO_DATE('2022.01.07'),'WW')
    , TO_CHAR(TO_DATE('2022.01.08'),'WW')
    , TO_CHAR(TO_DATE('2022.01.14'),'WW')
    , TO_CHAR(TO_DATE('2022.01.15'),'WW')
FROM emp;
-- ���� emp ���̺���
-- ������� ���� ���� �μ���dname, �����
-- ������� ���� ���� �μ���, �����
-- ��� join
-- SET ���տ����� : U, UA
SELECT d.deptno, dname, COUNT(empno) cnt -- ��ó��
-- FROM emp e INNER JOIN dept d ON e.deptno = d.deptno -- INNER �����Ȱſ���. : ���� ����Ȱ͸� -- �����ϸ� INNER
--FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno -- ����ȵȰ͵� �߰�
FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno , dname
ORDER BY d.deptno;

SELECT *
FROM (
SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
GROUP BY d.deptno , dname
ORDER BY cnt_rank ASC
) t
WHERE t.cnt_rank IN (1,4);
--
WITH temp AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
    FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
    GROUP BY d.deptno , dname
    ORDER BY cnt_rank ASC
)
SELECT *
FROM temp
WHERE temp.cnt_rank IN ((SELECT MAX(cnt_rank) FROM temp)
                        , (SELECT MIN(cnt_rank) FROM temp));
-- WITH�� ����(�ϱ�)                        
WITH a AS (
    SELECT d.deptno, dname, COUNT(empno) cnt
    , RANK() OVER(ORDER BY COUNT(empno) DESC) cnt_rank
    FROM dept d LEFT OUTER JOIN emp e ON e.deptno = d.deptno
    GROUP BY d.deptno , dname
    )
    , b AS (
    SELECT MAX(cnt) maxcnt, MIN(cnt) mincnt
    FROM a
    )
SELECT a.deptno, a.dname, a.cnt, a.cnt_rank
FROM a, b
WHERE a.cnt IN (b.maxcnt, b.mincnt);
-- �Ǻ�(pivot) / ���Ǻ�(unpivot) (�ϱ�)
-- ��� ���� ������ �Լ�
-- https://blog.naver.com/gurrms95/222697767118
-- job�� ������� ���
SELECT
    COUNT(DECODE(job, 'CLERK','O')) CLERK
    , COUNT(DECODE(job, 'SALESMAN','O')) SALESMAN
    , COUNT(DECODE(job, 'PRESIDENT','O')) PRESIDENT
    , COUNT(DECODE(job, 'MANAGER','O')) MANAGER
    , COUNT(DECODE(job, 'ANALYST','O')) ANALYST
FROM emp;
--
SELECT job
FROM emp;
--
SELECT *
FROM (SELECT job FROM emp)
PIVOT ( (COUNT(job)) FOR job IN ('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST') );
-- ���� �߽����� ȸ����Ű��. == pivot
SELECT
FROM (�Ǻ� ��� ������)
PIVOT (�׷��ռ�(�����÷�)) FOR �ǹ��÷� IN (�ǹ��÷� AS ��Ī..);
-- 2. emp ���̺���
-- �� ���� �Ի��� ��� �� ��ȸ.
-- 1�� 2�� 3�� .. 12��
-- 2   0   5      3
SELECT *
FROM (TO_CHAR(hiredate,'MM') month FROM emp)
PIVOT ( COUNT(month) FOR month IN ('01' AS "1��",'02','03','04','05','06','07','08','09','10','11','12'))
ORDER BY year;
-- ���� emp ���̺��� job�� ����� ��ȸ.
-- CLERK P
--   3   1
SELECT *
FROM ( SELECT job
FROM emp )
PIVOT ( COUNT(job) FOR job IN ('CLERK','SALESMAN','MANAGER','PRESIDENT','ANALYST') );
-- ���� emp ���̺��� �μ���/job�� ����� ��ȸ.
--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0--    DEPTNO DNAME             'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
------------ -------------- ---------- ---------- ----------- ---------- ----------
--        10 ACCOUNTING              1          0           1          1          0
--        20 RESEARCH                1          0           0          1          1
--        30 SALES                   1          4           0          1          0
--        40 OPERATIONS              0          0           0          0          0
-- ���� emp ���̺��� �μ���/job�� ����� ��ȸ.
SELECT *
FROM (SELECT d.deptno, dname
    , job
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno) -- RIGHT OUTER JOIN
PIVOT( COUNT(job) FOR job IN ('CLERK','SALESMAN','MANAGER','PRESIDENT','ANALYST') );
-- �Ǻ� �ǽ����� �� �μ��� �� �޿����� ��ȸ.
SELECT *
FROM (SELECT deptno, sal+NVL(comm,0) pay
FROM emp)
PIVOT ( SUM(pay) FOR deptno IN ('10','20','30','40'));
-- �ǽ����� : �ǳʶٱ�
SELECT *
FROM (SELECT job, deptno, sal, ename
FROM emp)
PIVOT ( SUM(sal) AS �հ�, MAX(sal) AS �ְ��, MAX(ename) AS �ְ���
FOR deptno IN ('10','20','30','40') );

-- �Ǻ� ����)
-- �������� O   X   ����
--        20  30    1
SELECT *
FROM (
    SELECT
    CASE SIGN(TO_DATE(SUBSTR(ssn,3,4),'MMDD') - TRUNC(SYSDATE))
                  WHEN 1 THEN 'X'
                  WHEN -1 THEN 'O'
                  ELSE '����'
    END s
    FROM insa
)
PIVOT ( COUNT(s) FOR s IN ('X','O','����') );
-- �μ���ȣ 4�ڸ��� ���
SELECT '00' || deptno -- ���� ������.
    , TO_CHAR(deptno,'0999')
    , LPAD(deptno,4,'0')
FROM dept;
-- (�ϱ�) insa ���̺��� �� �μ���/���������/����� ������� ���(��ȸ).
SELECT DISTINCT city
FROM insa;
--
SELECT buseo, city, COUNT(*) �����
FROM insa
GROUP BY buseo, city
ORDER BY buseo, city;
-- ����Ŭ 10G ���� �߰��� ��� : PARTITION BY OUTER JOIN ���� ���
WITH c AS (
    SELECT DISTINCT city
    FROM insa
)
SELECT buseo, c.city, COUNT(num)
FROM insa i PARTITION BY(buseo) RIGHT OUTER JOIN c ON i.city = c.city -- PARTITION BY �μ��� ���� �Ŀ� city�� �� ���;ߵ�.
GROUP BY buseo, c.city
ORDER BY buseo, c.city;








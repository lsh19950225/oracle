-- SCOTT
-- ����1) emp ���̺��� job�� ���� ��ȸ ?
SELECT COUNT(DISTINCT job)
FROM emp;
--
SELECT COUNT(*)
FROM (
SELECT DISTINCT job
FROM emp
) e;
-- ����2) emp ���̺��� �μ��� ����� ��ȸ ?
SELECT 10 deptno ,COUNT(*) �����
FROM emp
WHERE deptno = 10
UNION ALL
SELECT 20,COUNT(*)
FROM emp
WHERE deptno = 20
UNION ALL
SELECT 30,COUNT(*)
FROM emp
WHERE deptno = 30
UNION ALL
SELECT 40,COUNT(*)
FROM emp
WHERE deptno = 40
UNION ALL
SELECT null,COUNT(*)
FROM emp;
--
SELECT (SELECT COUNT(*) count FROM emp WHERE deptno = 10)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 20)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 30)
    ,(SELECT COUNT(*) count FROM emp WHERE deptno = 40)
    ,(SELECT COUNT(*) count FROM emp)
FROM dual;
--
SELECT deptno, count(*) -- �׷�ȭ ��Ų �Ŀ��� �������� ���� �� �� �ִ�.
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
-- ���� ����) emp ���̺� �������� �ʴ� �μ��� ��ȸ. 40 0
SELECT COUNT(*)
    , COUNT(DECODE(deptno,10,sal)) "10"
    , COUNT(DECODE(deptno,20,sal)) "20"
    , COUNT(DECODE(deptno,30,sal)) "30" -- DECODE : ���� ������ null ���� ������. ���� COUNT�� null ���� ������ ���� ������ �´�.
    , COUNT(DECODE(deptno,40,sal)) "40" -- �ø��� null ���� ������ ��.
FROM emp;
-- ����) insa ���̺��� �� �����, ���� �����, ���� ����� ��ȸ.
SELECT COUNT(*) "��"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����')) "��"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) "��"
FROM insa;
--
SELECT COUNT(*), '��ü' gender
FROM insa
UNION ALL
SELECT COUNT(*) cnt
    , CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '����'
                                  WHEN 0 THEN '����'
    END gender
FROM insa
GROUP BY MOD(SUBSTR(ssn,8,1),2);
--
SELECT
    CASE MOD(SUBSTR(ssn,8,1),2) WHEN 1 THEN '����'
                                WHEN 0 THEN '����'
                                ELSE '����'
        END gender
    , COUNT(*) cnt
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn,8,1),2)); -- ROLLUP : GROUP BY�� ���� ��
-- [����] emp ���̺��� ���� �޿�(pay)�� ���� �޴� ����� ������ ��ȸ.
SELECT MAX(sal+NVL(comm,0)) max_pay
FROM emp;
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) = (
                        SELECT MAX(sal+NVL(comm,0)) max_pay
                        FROM emp
                        );
-- WHERE sal+NVL(comm,0) = 5000;

-- sql ������ : ALL, SOME, ANY, EXISTS (��������)
SELECT *
FROM emp
WHERE sal+NVL(comm,0) >= ALL(SELECT sal+NVL(comm,0) FROM emp); -- ���� ū ��
--
SELECT *
FROM emp
WHERE sal+NVL(comm,0) <= ALL(SELECT sal+NVL(comm,0) FROM emp); -- ���� ���� ��
-- ����) emp ���̺��� �� �μ��� �ְ� �޿��� �޴� ����� ������ ��ȸ.      
SELECT deptno, MAX(sal+NVL(comm,0)) -- , MIN(sal+NVL(comm,0))
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
--
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = ANY(
                            SELECT MAX (sal + NVL(comm,0))
                            FROM emp
                            GROUP BY deptno
                                );
--
SELECT *
FROM emp m
-- WHERE sal + NVL(comm,0) = (�� �ش� �μ��� ���� ū �� pay);
WHERE sal + NVL(comm,0) = (
                            SELECT MAX (sal + NVL(comm,0))
                            FROM emp s
                            WHERE deptno = m.deptno -- ��ȣ ����(Correlated) ���� ����
                           )
ORDER BY deptno;
-- ����, �μ��� ���� 1�� - �����Լ�
--
SELECT MAX (sal + NVL(comm,0))
FROM emp
WHERE deptno = 10;
-- ����) emp ���̺��� pay ���� ���..
SELECT m.*
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal) rank
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
FROM emp m
ORDER BY deptno, dept_rank;
--
SELECT *
FROM (
    SELECT m.*
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal) rank
    , (SELECT COUNT(*)+1 FROM emp WHERE sal > m.sal AND deptno = m.deptno) dept_rank
    FROM emp m
      ) t
-- WHERE t.dept_rank = 1;
WHERE t.dept_rank <= 2
ORDER BY deptno, dept_rank;

-- [����] insa ���̺��� �μ��� �ο����� 10�� �̻��� �μ� ��ȸ.
SELECT *
FROM (
SELECT buseo, COUNT(*) cnt
FROM insa
GROUP BY buseo
) t
WHERE cnt >= 10;
--
SELECT buseo, COUNT(*)
FROM insa
GROUP BY buseo
HAVING COUNT(*) >= 10; -- HAVING : GROUP BY�� �Ϳ� ���� ������.

-- [����] insa ���̺��� ���� ������� 5�� �̻��� �μ� ���� ��ȸ.
SELECT buseo, COUNT(*)
FROM insa
GROUP BY buseo
HAVING COUNT(*) >= 5;
--
SELECT buseo, COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) "����"
FROM insa
GROUP BY buseo
HAVING COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) >= 5;
--
SELECT buseo, COUNT(*)
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
HAVING COUNT(*) >= 5;
-- [����] emp ���̺��� ��� ��ü ��ձ޿��� ����� �� �� ������� �޿��� ��ձ޿����� ���� ��� "����" ���
--                                                                          ���� ��� "����" ���
-- 2260.416666666666666666666666666666666667
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '����'
          WHEN pay < avg_pay THEN '����'
          ELSE '����'
       END
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;
-- [����] emp ���̺���
--       ��� ��ü ��ձ޿�(pay)�� ����� ��
--       �� ������� �޿��� ��ձ޿����� ���� ��� "����" ���
--                                "   ���� ��� "����" ���.
-- 2260.416666666666666666666666666666666667
SELECT AVG( sal + NVL(comm, 0) )  avg_pay
FROM emp;
--
SELECT empno, ename, pay , ROUND( avg_pay, 2) avg_pay
     , CASE 
          WHEN pay > avg_pay   THEN '����'
          WHEN pay < avg_pay THEN '����'
          ELSE '����'
       END
FROM (
        SELECT emp.*
              , sal + NVL(comm,0) pay
              , (SELECT AVG( sal + NVL(comm, 0) )  FROM emp) avg_pay
        FROM emp
    ) e;
--
SELECT s.*,  '����'
FROM emp s
WHERE sal + NVL(comm,0 ) > (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp)
UNION                            
SELECT s.*,  '����'
FROM emp s
WHERE sal + NVL(comm,0 ) < (SELECT AVG( sal + NVL(comm,0 )) avg_pay
                            FROM emp);
--
SELECT ename, pay, avg_pay
     , NVL2( NULLIF( SIGN( pay - avg_pay ), 1 ), '����' , '����') 
FROM (
        SELECT ename, sal+NVL(comm,0) pay 
            , (SELECT AVG( sal + NVL(comm,0 )) avg_pay FROM emp) avg_pay
        FROM emp
      );
-- [����] emp ���̺��� �޿� max, min ����� ������ ��ȸ.
SELECT MAX(sal + NVL(comm,0))
FROM emp;

SELECT MIN(sal + NVL(comm,0))
FROM emp;

SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (SELECT MAX(sal + NVL(comm,0)) FROM emp)
UNION
SELECT *
FROM emp
WHERE sal + NVL(comm,0) = (SELECT MIN(sal + NVL(comm,0)) FROM emp);

SELECT *
    , CASE (sal + NVL(comm,0)
        WHEN (SELECT MAX(sal + NVL(comm,0)) THEN 'MAX'
        WHEN (SELECT MIN(sal + NVL(comm,0)) THEN 'MIN'
    END a
FROM emp
WHERE sal + NVL(comm,0) IN ((SELECT MAX(sal + NVL(comm,0)) FROM emp),
                            (SELECT MIN(sal + NVL(comm,0)) FROM emp));
                            
-- [����] insa
--      ���� ��� �� �μ��� ����,���� ��� ��
--                       ���� �޿���, ���� �޿����� ��ȸ.

-- 1) �μ��� ���ڻ����, ���ڻ����
-- �μ����� �����Լ�
SELECT buseo
    , COUNT(*) "��"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),1,'����')) "����"
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) "����"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),1,basicpay)) "���� �� �޿���"
    , SUM(DECODE(MOD(SUBSTR(ssn,8,1),2),0,basicpay)) "���� �� �޿���"
FROM insa
WHERE city = '����'
GROUP BY buseo
ORDER BY buseo ASC;
-- Ǯ��2
SELECT buseo, jikwi, COUNT(*), SUM(basicpay), AVG(basicpay)
FROM insa
GROUP BY ROLLUP(buseo, jikwi) -- 2�� �׷�, ROLLUP : NULL ���� �κ� ��.
ORDER BY buseo, jikwi ASC;
--
SELECT buseo
    , DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����','����') gender
    , COUNT(*) "�����"
    , SUM(basicpay) "�ѱ޿���"
FROM insa
WHERE city = '����'
-- GROUP BY buseo, ���� �� 2�� �׷�
GROUP BY buseo, MOD(SUBSTR(ssn,8,1),2)
ORDER BY buseo, MOD(SUBSTR(ssn,8,1),2);

-- ROWNUM �ǻ��÷�
DESC emp;
SELECT ROWNUM, ROWID, ename, hiredate, job -- ���������� ó�� �Ǵ� ��¥ �÷� ROWNUM : ���� ������ ��Ÿ����.
FROM emp;

-- TOP_N �м�
    SELECT �÷���,..., ROWNUM
	FROM (
          SELECT �÷���,... from ���̺��
	      ORDER BY top_n_�÷���
          )
    WHERE ROWNUM <= n;
--
SELECT ROWNUM, e.*
FROM( -- WITH���� ����.
SELECT *
FROM emp
ORDER BY sal DESC
) e
-- WHERE ROWNUM BETWEEN 3 AND 5; -- �Ұ��� : �߰� ������ ã�� �� ����.
WHERE ROWNUM <= 3; -- 1~3��
WHERE ROWNUM <= 1; -- 1�� ������, 3~5������� ã�� �� ����.
-- ORDER BY���� �Բ� ROWNUM �����������.
SELECT ROWNUM, emp.*
FROM emp
ORDER BY sal DESC; -- ���׹���
--
SELECT *
FROM(
SELECT ROWNUM seq, e.*
FROM( -- WITH���� ����.
SELECT *
FROM emp
ORDER BY sal DESC
) e
)
WHERE seq BETWEEN 3 AND 5; -- �ζ��κ� �Ǵ� �������� �ѹ� �� �����ϸ� 3~5�� �� ���� �� �ִ�.
-- ROLLUP/CUBE ����
-- ROLLUP�� CUBE�� GROUP BY �� �ڿ� ����� �÷� ������ ���� ��µǴ� ��� ���� �޶�����.
-- GROUP BY �ڿ� ����� �÷��� 2���� ��� ROLLUP�� n+1���� 3���� �׷캰 ����� ��µǰ�, CUBE�� 2*n���� 2*2=4���� ��� ���� ��µȴ�.
-- 1) ROLLUP : �׷�ȭ�ϰ� �׷쿡 ���� �κ���
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY dname, job
GROUP BY ROLLUP(dname,job) -- 2�� ����.
ORDER BY dname ASC;
-- GROUP BY d.deptno, dname -- dname �ʿ�.
-- ORDER BY d.deptno ASC;
-- 2) CUBE : ROLLUP ����� GROUP BY���� ���ǿ� ���� ��� ������ �׷��� ���տ� ���� ��� ���. 2*N=4
SELECT dname, job, COUNT(*)
FROM emp e, dept d
WHERE e.deptno = d.deptno
-- GROUP BY dname, job
GROUP BY CUBE(dname,job) -- 2�� ����. -- CUBE : job���ε� ���谡 ���´�.
ORDER BY dname ASC;

-- ����(RANK) �Լ�.
-- �� �Լ��� �׷� ������ ��ġ�� ����Ͽ� ��ȯ�Ѵ�.
-- �ش� ���� ���� �켱������ ����(�ߺ� ���� �����)
-- ��ȯ�Ǵ� ������Ÿ���� �����̴�.
SELECT ename, sal, sal+NVL(comm,0) pay
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "RANK ����" -- �ݵ�� OVER(ORDER BY��) �´�. �ʼ� : ������ �ʿ���. / ������ ���� 3��� �ǳʶٰ� 5���� �ȴ�.
    , DENSE_RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) "DENSE_RANK ����" -- ������ �� ������ 4��
    , ROW_NUMBER() OVER(ORDER BY sal+NVL(comm,0) DESC) "ROW_NUMBER ����" -- �Ȱ��� ���̿��� ������ �Űܼ� �����.
FROM emp;
-- JONES 2975 -> 2850 ����
UPDATE emp
SET sal = 2850
WHERE empno = 7566;
-- WHERE ename = X �ߺ������� ����ϸ� �ȵ�.
COMMIT;

-- ���� �Լ� ��� ����.
-- emp ���̺��� �μ����� �޿� ������ �ű���.
SELECT *
FROM(
SELECT emp.*
    -- PARTITION BY deptno : �μ����� �׷� ��� �����Ű���.
    , RANK() OVER(PARTITION BY deptno ORDER BY sal+NVL(comm,0) DESC) ����
    , RANK() OVER(ORDER BY sal+NVL(comm,0) DESC) ��ü����
FROM emp
)
WHERE ���� BETWEEN 2 AND 3; -- 2~3�� ã�� �� �ִ�.
WHERE ���� = 1;

-- insa ���̺� ������� �μ� ������� 14�� ��.. �� ��?
SELECT CEIL(COUNT(*)/14) ��
FROM insa;
-- [����] insa ���̺��� ������� ���� ���� �μ��� �μ���,������� ��ȸ.
SELECT *
FROM(
SELECT buseo, COUNT(*) �����
    , RANK() OVER(ORDER BY COUNT(*) DESC) �μ�����
FROM insa
GROUP BY buseo
-- HAVING RANK() OVER(ORDER BY COUNT(*) DESC) = 1 : ������.
) e
WHERE �μ����� = 1;
-- [����] insa ���̺��� ���� ������� ���� ���� �μ� �� ����� ���
SELECT *
FROM(
SELECT buseo
    , COUNT(DECODE(MOD(SUBSTR(ssn,8,1),2),0,'����')) ����
    , RANK() OVER(ORDER BY COUNT(*) DESC) �μ����ڼ���
FROM insa
GROUP BY buseo
) e
WHERE �μ����ڼ��� = 1;
--
SELECT *
FROM(
SELECT buseo, COUNT(*) �����
    , RANK() OVER(ORDER BY COUNT(*) DESC) �μ�����
FROM insa
WHERE MOD(SUBSTR(ssn,8,1),2) = 0
GROUP BY buseo
-- HAVING RANK() OVER(ORDER BY COUNT(*) DESC) = 1 : ������.
) e
WHERE �μ����� = 1;
-- [����] insa ���̺��� basicpay(�⺻��)�� ���� 10%�� ���.. �̸�, �⺻��
SELECT *
FROM(
SELECT name, basicpay
    , RANK() OVER(ORDER BY basicpay DESC) ����
FROM insa
) e
WHERE ���� <= (SELECT COUNT(*) FROM insa) * 0.1;
--
SELECT *
FROM(
SELECT name, basicpay
    , PERCENT_RANK() OVER(ORDER BY basicpay DESC) pr
FROM insa
) e
WHERE pr <= 0.1;







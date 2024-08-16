-- SCOTT
-- ��������(Constraint) --
SELECT *
FROM user_constraints -- ��(View)
WHERE table_name = 'EMP';
-- �������� ��� ���� ?
-- 1) ���������� data integrity(������ ���Ἲ)�� ���Ͽ� �ַ� ���̺� ��(row)�� �Է�, ����, ������ �� ����Ǵ� ��Ģ���� ���Ǹ�
-- 2) ���̺� ���� �����ǰ� �ִ� ��� [���̺��� ���� ����]�� ���ؼ��� ���ȴ�.

-- ����) ���Ἲ(integrity)
-- �������� ��Ȯ���� �ϰ����� �����ϰ�, �����Ϳ� ��հ� �������� ������ �����ϴ� ��

-- 2) �������� ���� ���
-- 1. ���̺��� ������ ���ÿ� ���������� ����.
    -- ��. IN-LINE �������� ���� ��� (�÷� ����)
        -- ��) seq NUMBER PRIMARY KEY
    -- ��. OUT-OF_LINE �������� ���� ��� (���̺� ����)
        -- CREATE TABLE XX
        (
            �÷�1 -- �÷� ���� (NOT NULL ���������� �÷������θ� ����.)
            , �÷�2
        
        :
        , �������� ���� -- ���̺� ���� (����Ű ������ ���� ���̺� ������)
        , �������� ����
        , �������� ����
        )
        
        ��) ����Ű ���� ���� ?
        [��� �޿� ���� ���̺�]
����(������ȭ) �޿����޳�¥  �����ȣ    �޿��� -- �̷� ���� (�޿����޳�¥ + �����ȣ) ���ļ� PK : ����Ű         -> [������ȭ]
1            2024.7.15   1111    3,000,000
2            2024.7.15   1112    3,000,000
3            2024.7.15   1113    3,000,000
:            :
4            2024.8.15   1111    3,000,000
5            2024.8.15   1112    3,000,000
6            2024.8.15   1113    3,000,000
:            :

-- PRIMARY KEY(PK) �ش� �÷� ���� �ݵ�� �����ؾ� �ϸ�, �����ؾ� ��
--    �� (NOT NULL�� UNIQUE ���������� ������ ����) 
-- FOREIGN KEY(FK) �ش� �÷� ���� �����Ǵ� ���̺��� �÷� �� ���� �ϳ��� ��ġ�ϰų� NULL�� ���� 
-- UNIQUE KEY(UK) ���̺����� �ش� �÷� ���� �׻� �����ؾ� �� 
-- NOT NULL �÷��� NULL ���� ������ �� ����. 
-- (CK) �ش� �÷��� ���� ������ ������ ���� ������ ���� ���� 


-- ��) �÷� ���� ������� �������� ���� + ���̺� ������ ���ÿ� �������� ����.
;
DROP TABLE tbl_constraint1;
DROP TABLE tbl_bonus;
DROP TABLE tbl_emp;

CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY : SYS_CXXXX
    empno NUMBER(4) NOT NULL CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2) CONSTRAINT fk_tblconstraint1_deptno REFERENCES dept (deptno)
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE -- �ߺ� �Ұ�.
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- WHERE �������� ������ �ָ��.
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK(city IN ('����','�λ�','�뱸'))
);
-- ��) ���̺� ���� ������� �������� ���� + ���̺� ������ ���ÿ� �������� ����.
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY : SYS_CXXXX
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2)
    , email VARCHAR2(150)
    , kor NUMBER(3)
    , city VARCHAR2(20)
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno, ename) -- , ename, .., .. : ����Ű
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_email UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- �Ȱ��ĵ���.
    , CONSTRAINT ck_tblconstraint1_city CHECK(city IN ('����','�λ�','�뱸')) -- �Ȱ��ĵ���.
);
-- 1) PK �������� ����
ALTER TABLE tbl_constraint1
-- DROP PRIMARY KEY
DROP CONSTRAINT pk_tblconstraint1_empno;
-- 2) CK ����
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor); : �Ұ���. ������ ����.
DROP CONSTRAINT ck_tblconstraint1_kor;
-- 3) UK ����
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
-- DROP CONSTRAINT uk_tblconstraint1_email;
--
SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_C%';

-- ck_tblconstraint1_city üũ�������� ��Ȱ��ȭ. disable ��Ȱ��ȭ / enable Ȱ��ȭ
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city [CASCADE]; -- ��Ȱ��ȭ CASCADE : ���� �� �����ϴ� ��� ���� ��Ȱ��ȭ.

ALTER TABLE tbl_constraint1
ENABLE CONSTRAINT ck_tblconstraint1_city; -- Ȱ��ȭ

-- 2. ���̺��� ������ �� ���������� ����(�߰�), ����.
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
--

--
1) empno �÷��� PK �������� �߰�.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
2) deptno �÷��� FK �������� �߰�.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT fk_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;

-- emp -> tbl_emp ����
-- dept -> tbl_dept ����
CREATE TABLE tbl_emp
AS
(
SELECT *
FROM emp
);
--
CREATE TABLE tbl_dept
AS
(
SELECT *
FROM dept
);
--
SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_%';
--
DESC tbl_emp;
-- �������� �߰�.
-- PK
ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);
--
ALTER TABLE tbl_emp
ADD CONSTRAINT pk_tblemp_empno PRIMARY KEY(empno);
-- FK
ALTER TABLE tbl_emp
-- DROP PRIMARY KEY
DROP CONSTRAINT pk_tbldept_empno;
--
ALTER TABLE tbl_emp
ADD CONSTRAINT fk_tbldept_deptno FOREIGN KEY(deptno)
    REFERENCES tbl_dept(deptno)
    -- ON DELETE CASCADE;
    ON DELETE SET NULL;
--
SELECT *
FROM tbl_dept;
--
SELECT *
FROM tbl_emp;
--
DELETE FROM tbl_dept -- ON DELETE CASCADE : dept 30 ����, emp 30 ���� : �θ� �ڽ� �� ����.
WHERE deptno = 30;
--
ROLLBACK;

-- ���Ἲ Data Integrity Ȯ��



-- ����
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- åID
      ,title      VARCHAR2(100) NOT NULL  -- å ����
      ,c_name  VARCHAR2(100)    NOT NULL     -- c �̸�
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK��(��) �����Ǿ����ϴ�.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '�����ͺ��̽�', '����');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '�����ͺ��̽�', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '�ü��', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '�ü��', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '����', '���');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '����', '�뱸');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '�Ŀ�����Ʈ', '�λ�');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '������', '��õ');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '������', '����');

COMMIT;

SELECT *
FROM book;

-- �ܰ����̺�( å�� ���� )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (�ĺ����� ***) : �θ����̺��� PK�� �ڽ����̺� PK�� ���.
      ,price  NUMBER(7) NOT NULL    -- å ����
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA��(��) �����Ǿ����ϴ�.
-- book  - b_id(PK), title, c_name
-- danga - b_id(PK,FK), price 
 
INSERT INTO danga (b_id, price) VALUES ('a-1', 300);
INSERT INTO danga (b_id, price) VALUES ('a-2', 500);
INSERT INTO danga (b_id, price) VALUES ('b-1', 450);
INSERT INTO danga (b_id, price) VALUES ('b-2', 440);
INSERT INTO danga (b_id, price) VALUES ('c-1', 320);
INSERT INTO danga (b_id, price) VALUES ('d-1', 321);
INSERT INTO danga (b_id, price) VALUES ('e-1', 250);
INSERT INTO danga (b_id, price) VALUES ('f-1', 510);
INSERT INTO danga (b_id, price) VALUES ('f-2', 400);

COMMIT; 

SELECT *
FROM danga; 

-- å�� ���� �������̺�
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '���Ȱ�');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '�տ���');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '�����');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '���ϴ�');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '�ɽ���');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '��÷');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '���ѳ�');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '������');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '�̿���');

COMMIT;

SELECT * 
FROM au_book;

-- ��            
-- �Ǹ�            ���ǻ� <-> ����
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '�츮����', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '���ü���', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '��������', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '���Ｍ��', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '��������', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '��������', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '���ϼ���', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- �Ǹ�
 CREATE TABLE panmai(
       id         NUMBER(5) NOT NULL PRIMARY KEY
      ,g_id       NUMBER(5) NOT NULL CONSTRAINT FK_PANMAI_GID
                     REFERENCES gogaek(g_id) ON DELETE CASCADE
      ,b_id       VARCHAR2(10)  NOT NULL CONSTRAINT FK_PANMAI_BID
                     REFERENCES book(b_id) ON DELETE CASCADE
      ,p_date     DATE DEFAULT SYSDATE
      ,p_su       NUMBER(5)  NOT NULL
);

INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (1, 1, 'a-1', '2000-10-10', 10);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (2, 2, 'a-1', '2000-03-04', 20);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (3, 1, 'b-1', DEFAULT, 13);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (4, 4, 'c-1', '2000-07-07', 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (5, 4, 'd-1', DEFAULT, 31);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (6, 6, 'f-1', DEFAULT, 21);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (7, 7, 'a-1', DEFAULT, 26);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (8, 6, 'a-1', DEFAULT, 17);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (9, 6, 'b-1', DEFAULT, 5);
INSERT INTO panmai (id, g_id, b_id, p_date, p_su) VALUES (10, 7, 'a-2', '2000-10-10', 15);

COMMIT;

SELECT *
FROM panmai;   
--
-- EQUI JOIN : = ���������� ���, NATURAL JOIN(����Ŭ) ����, PK = FK
-- [����] åID, å����, ���ǻ�(c_name), �ܰ�  �÷� ���..
-- book : b_id(P), title, c_name
-- danga : b_id(P,F), price -- �ĺ�����
-- ��.
SELECT b.b_id, title, c_name, price
FROM book b, danga d
WHERE b.b_id = d.b_id; -- WHERE ������, ���������� '=' ������
-- ��. JOIN ON ����
SELECT b.b_id, title, c_name, price
FROM book b INNER JOIN danga d ON b.b_id = d.b_id;
-- ��. USING �� ���(��ü��. ��Ī��.���� ��� ����.).
SELECT b_id, title, c_name, price
FROM book JOIN danga USING(b_id); -- USING ���� ����� ����.
-- ��. NATURAL JOIN
SELECT b_id, title, c_name, price
FROM book NATURAL JOIN danga;

-- [����]  åID, å����, �Ǹż���, �ܰ�, ������, �Ǹűݾ�(=�Ǹż���*�ܰ�) ���
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name, p.p_su * d.price "�Ǹűݾ�"
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;
--
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name, p.p_su * d.price "�Ǹűݾ�"
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;
-- USING �� ���.
SELECT b_id, title, p_su, price, g_name, p_su * price "�Ǹűݾ�"
FROM book JOIN panmai USING(b_id)
            JOIN gogaek USING(g_id)
            JOIN danga USING(b_id);
-- NON-EQUI JOIN : ���������� '=' ������� ����.
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
-- OUTER JOIN : JOIN ������ �������� �ʴ� ���� ���� ���� �߰����� join�� �����̴�.
-- (+) ������ ���
-- (LEFT, RIGHT, FULL) OUTER ����
KING ����� �μ���ȣ�� Ȯ���ϰ� -> NULL�� ������Ʈ
SELECT *
FROM emp
WHERE ename = UPPER('king');

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;

-- [��� emp ��������� ����ϵ� �μ���ȣ ��ſ� �μ������� ���]
-- ���� ��� emp ���̺��� ��� ������ dept ���̺�� �����ؼ�
-- dname, ename, hiredate �÷� ���
SELECT dname, ename, hiredate
FROM emp e LEFT OUTER JOIN dept d ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate -- ���� ����.
FROM emp e, dept d 
WHERE d.deptno(+) = e.deptno;
-- �� �μ��� ��� �� ��ȸ.
-- �μ���, �����
SELECT d.dname, COUNT(e.empno)
FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;
-- ���� ����
SELECT d.dname, COUNT(e.empno)
FROM emp e, dept d
WHERE d.deptno = e.deptno(+)
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;
--
SELECT d.dname, dname, ename, hiredate -- ���� �� ������ ���ϸ� FULL OUTER JOIN
FROM emp e FULL OUTER JOIN dept d ON d.deptno = e.deptno;

-- SELF JOIN
�����ȣ, �����, �Ի�����, ���ӻ���� �̸�
SELECT e.empno, e.ename, e.hiredate, t.ename "���ӻ��"
FROM emp e JOIN emp t ON e.mgr = t.empno;

-- CROSS JOIN : ��ī��Ʈ ��
--      12 * 4 = 48
SELECT e.*, d.*
FROM emp e, dept d;
--
-- ����) ���ǵ� å���� ���� �� ����� �ǸŵǾ����� ��ȸ     
--      (    åID, å����, ���ǸűǼ�, �ܰ� �÷� ���   )
SELECT b.b_id, b.title, SUM(p.p_su) "���ǸűǼ�", d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price;

-- ���� �ǸűǼ��� ���� ���� å ���� ��ȸ.
SELECT t.*
FROM
(
SELECT b.b_id, b.title, SUM(p.p_su) "���ǸűǼ�", d.price
    , RANK() OVER(ORDER BY SUM(p.p_su) DESC) r
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price
) t
WHERE r = 1;
-- TOP-N ���
SELECT ROWNUM, t.*
FROM
(
SELECT b.b_id, b.title, SUM(p.p_su) ���ǸűǼ�, d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price
ORDER BY ���ǸűǼ� DESC
) t
WHERE ROWNUM = 1;
-- ���� �ǸűǼ��� ���� ���� å ���� ��ȸ.
-- åid ���� ����
SELECT t.*
FROM
(
SELECT b.b_id, b.title, p.p_su
    , RANK() OVER(ORDER BY p.p_su DESC) r
FROM book b, panmai p
WHERE b.b_id = p.b_id AND TO_CHAR(p.p_date, 'YYYY') = 2024
GROUP BY b.b_id, b.title
) t
WHERE t.r = 1;
-- ���� book ���̺��� �ǸŰ� �� ���� ���� å�� ���� ��ȸ.
-- å���̵� ���� ����
SELECT b.b_id, title, price
FROM book b LEFT OUTER JOIN panmai p ON b.b_id = p.b_id JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL;
-- MINUS ��ü å - �Ǹŵ��� å
-- ANTI JOIN (NOT IN)
SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN (
SELECT DISTINCT(b_id)
FROM panmai
);
-- ���� �ǸŰ� ���� �ִ� ����
SELECT DISTINCT(b.b_id), title, price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id;
--
SELECT b_id
FROM book
INTERSECT
SELECT b_id
FROM panmai;
--
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_bid IN (
SELECT DISTINCT b_id
FROM panmai
);
-- = ANY
-- EXISTS
  SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE EXISTS ( SELECT  b_id
    FROM panmai
    WHERE b_id = b.b_id);
WHERE b.b_id IN (
    SELECT DISTINCT b_id
    FROM panmai
);
WHERE b.b_id = ANY(
    SELECT DISTINCT b_id
    FROM panmai
);

SELECT DISTINCT(b_id)
FROM panmai;

--  ����) ���� �Ǹ� �ݾ� ��� (���ڵ�, ����, �Ǹűݾ�)
SELECT g.g_id, g.g_name, SUM(p.p_su * d.price) "���Ǹűݾ�"
FROM book b, panmai p, gogaek g, danga d
WHERE b.b_id = p.b_id AND p.g_id = g.g_id AND b.b_id = d.b_id
GROUP BY g.g_id, g.g_name;
--
SELECT g.g_id, g_name, SUM(p_su*price) "���Ǹűݾ�" 
FROM panmai p JOIN danga d ON p.b_id = d.b_id
    JOIN gogaek g ON p.g_id = g.g_id
GROUP BY g.g_id, g_name;
-- ���� �⵵, ���� �Ǹ� ��Ȳ ���ϱ�
SELECT TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM'), SUM(p_su) "�Ǹż���"
FROM panmai
GROUP BY TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM')
ORDER BY TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM');
-- ���� ������ �⵵�� �Ǹ� ��Ȳ ���ϱ�
SELECT TO_CHAR(p_date,'YY') �⵵��, g_name ������, SUM(p_su) �Ǹż���
FROM panmai p, gogaek g
WHERE p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YY'), g_name
ORDER BY TO_CHAR(p_date,'YY'), g_name;
-- å�� ���Ǹűݾ��� 15000�� �̻� �ȸ� å�� ������ ��ȸ
--      ( åID, ����, �ܰ�, ���ǸűǼ�, ���Ǹűݾ� )
SELECT b.b_id, b.title, price
    , SUM(p_su) ���ǸűǼ�, SUM(p_su * price) ���Ǹűݾ�
FROM book b, panmai p, danga d
WHERE b.b_id = p.b_id AND b.b_id = d.b_id
GROUP BY b.b_id, b.title, price
HAVING SUM(p_su * price) >= 15000;





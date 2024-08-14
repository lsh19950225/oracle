-- SCOTT
-- 1) �Խ��� ���̺� ���� : tbl_board
-- 2) �÷� : �۹�ȣ, �ۼ���, ��й�ȣ, ����, ����, �ۼ���, ��ȸ�� x ���..
-- [GLOBAL TEMPORARY] �ӽ� ���̺� : �α׾ƿ��� ������.
CREATE TABLE scott.tbl_board -- scott. : ���� ����.
(
 seq NUMBER(38) NOT NULL PRIMARY KEY
 , writer VARCHAR2(20) NOT NULL
 , password VARCHAR2(15) NOT NULL -- �ۼ��� �ǰ����� �ʿ�. ���� NOT NULL
 , title VARCHAR2(100) NOT NULL
 , content CLOB
 , regdate DATE DEFAULT SYSDATE -- �ڵ����� ���ó�¥�� ����.
);
-- Table SCOTT.TBL_BOARD��(��) �����Ǿ����ϴ�.

-- ������(SEQUENCE) : ��ȣǥ ���� �ǹ� / �������� ������ ���̺� ���� �⺻Ű�� ����ũ Ű�� ����Ͽ� �ΰ��ϴ�
-- ������ ���ο� �÷�ó�� ����� �� �ִ� �Ϸù�ȣ�� �ű��ϱ� ���� �ϳ��� �÷����� ������ ���̺�� ����.
-- seq �� ��ȣ�� ����� ������ ����.
CREATE SEQUENCE seq_tblboard
--    INCREMENT BY 1 -- 1�� �����ϰڴ�.
--    START WITH 1 -- 1���� ����
    -- [ MAXVALUE n ? NOMAXVALUE]
	-- [ MINVALUE n ? NOMINVALUE] START �� �ƽ������� ����Ŭ ���� �̴ϰ����� ���ư�.
    -- [ CYCLE ? NOCYCLE]
    NOCACHE;
-- Sequence SEQ_TBLBOARD��(��) �����Ǿ����ϴ�.
SELECT *
FROM user_sequences; -- ������ Ȯ��.
--
SELECT *
FROM tabs
WHERE table_name LIKE 'TBL_B%';
-- DDL
CREATE TABLE
ALTER TABLE
DROP TABLE tbl_board CASCADE;

-- �Խñ� ����(�ۼ�) ���� �ۼ�.
-- ORA-08002: sequence SEQ_TBLBOARD.CURRVAL is not yet defined in this session
-- �� NEXTVAL�� ���۵ž� ��ȸ�� �����ϴ�.
SELECT seq_tblboard.CURRVAL
FROM dual;

-- ORA-01400: cannot insert NULL into ("SCOTT"."TBL_BOARD"."SEQ") : NOT NULL ���� �� ��ߵ�.
INSERT INTO tbl_board (seq,writer,password,title,content) VALUES (seq_tblboard.NEXTVAL,'�̽���','1234','TEST-1','TEST-1');

INSERT INTO tbl_board (seq,writer,password,title,content) VALUES (seq_tblboard.NEXTVAL,'ȫ�浿','1234','TEST-2','TEST-2');

INSERT INTO tbl_board VALUES (seq_tblboard.NEXTVAL,'�ۼ�ȣ','1234','TEST-3','TEST-3',SYSDATE);

INSERT INTO tbl_board (seq,writer,password,title) VALUES (seq_tblboard.NEXTVAL,'������','1234','TEST-4');
COMMIT;

SELECT *
FROM tbl_board;

SELECT seq, subject, writer, TO_CHAR(regdate,'YYYY-MM-DD') regdate, readed
FROM tbl_board
ORDER BY seq DESC;

-- seq NOT NULL, PRIMARY KEY
-- NN
SELECT *
FROM user_constraints -- �������� ��ȸ.
WHERE table_name = UPPER('tbl_board');
-- �������� �̸��� ���� ������ SYS_XXXXXXX �̸����� �ڵ� �ο�.
-- P : PRIMARY KEY / C : NOT NULL �� ǥ��.

-- ��ȸ�� �÷� �߰�.
ALTER TABLE tbl_board
ADD readed NUMBER DEFAULT 0;

-- 1 : 1	TEST-1	�̽���	2024-08-14	0 �Խñ��� ������ Ŭ��. (�󼼺���)
-- 1) ��ȸ�� 1����
-- 2) �Խñ�(seq)�� ������ ��ȸ.

UPDATE tbl_myboard
SET readed = readed + 1 -- ***
WHERE seq = 1;

ROLLBACK;

SELECT *
FROM tbl_myboard
WHERE seq = 1;

-- �Խ����� �ۼ��� writer �÷� 20 -> 40 size Ȯ��
-- �÷��� �ڷ����� ũ�⸦ ����

-- �������� ������ �� ����. / �����ʿ��� �� : (���� -> ����)
ALTER TABLE tbl_board
MODIFY (writer VARCHAR2(40));
--
DESC tbl_board;

-- �÷����� ���� title -> subject
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;

-- ������ ���� ��¥ ������ ������ �÷��� �߰�. lastRegdate
ALTER TABLE tbl_board
ADD (
 lastRegdate DATE
);

SELECT seq, subject, writer, TO_CHAR(regdate,'YYYY-MM-DD') regdate, readed, lastRegdate
FROM tbl_board
ORDER BY seq DESC;
--
UPDATE tbl_board
SET subject = '�������-3',content = '�������-3',lastRegdate = SYSDATE
WHERE seq = 3;

COMMIT;

SELECT *
FROM tbl_board;

-- lastregdate �÷� ����
ALTER TABLE tbl_board
DROP COLUMN lastRegdate;

-- tbl_board -> tbl_myboard ���̺�� ����
RENAME tbl_board TO tbl_myboard;

SELECT *
FROM tbl_myboard;

-- [���̺� �����ϴ� ���]
1. CREATE TABLE ����
2. subquery �� �̿��� ���̺� ����.
    - ���� �̹� �����ϴ� ���̺��� �̿��ؼ� ���ο� ���̺� ���� (+ ���ڵ� �߰�)
    - CREATE TABLE ���̺�� [�÷���,..]
    AS (��������); -- �÷����� �� = �������� �÷����� �� / �÷��� ���� �� ���������� �÷������� ���̺� ����.
    
-- ��) emp ���̺�� ���� 30�� ����鸸 ���ο� ���̺� ����.
CREATE TABLE tbl_emp30 (eno,ename,hiredate,job,pay)
AS (
SELECT empno, ename, hiredate, job, sal+NVL(comm,0) pay
FROM emp
WHERE deptno = 30
);
-- Table TBL_EMP30��(��) �����Ǿ����ϴ�.
DESC tbl_emp30; -- pay �ý����� �ڵ����� �ѹ��� ����.

-- TBL_EMP30 : ���������� ������� �ʴ´�.
SELECT *
FROM user_constraints -- �������� ��ȸ.
WHERE table_name IN ('EMP','TBL_EMP30'); -- �������� R : ����Ű(����Ű)

-- emp -> ���ο� ���̺� ������ �� / ������ ���� ���ϰ�
CREATE TABLE tbl_empcopy
AS(
SELECT *
FROM emp
WHERE 1 = 0 -- �׻� ����. -- ���̺� ������ �״�� �����ϵ� ������(���ڵ�)�� �ʿ���� ��.
);

DROP TABLE tbl_emp30;

SELECT *
FROM tbl_empcopy;

DROP TABLE tbl_empcopy;

DROP TABLE tbl_char;
DROP TABLE tbl_example;
DROP TABLE tbl_myboard;
DROP TABLE tbl_nchar;
DROP TABLE tbl_number;
DROP TABLE tbl_pivot;
DROP TABLE tbl_tel;
-- SQL Ȯ�� => PL/SQL

-- [����] emp, dept, salgrade ���̺��� �̿��ؼ� deptno, dname, empno, ename, hiredate, pay, grade �÷���
-- ���� ���ο� ���̺� ���� (tbl_empgrade)
-- 3�� ���̺� ����.
--SELECT t.deptno, t.dname, t.empno, t.hiredate, t.pay, s.grade
--FROM (
--SELECT d.deptno, dname, empno, hiredate, sal+NVL(comm,0) pay, sal
--FROM dept d, emp e
--WHERE d.deptno = e.deptno
--) t, salgrade s
--WHERE t.sal BETWEEN s.losal AND s.hisal; -- ��������.
CREATE TABLE tbl_empgrade
AS
(
SELECT d.deptno, d.dname, e.empno, e.hiredate, sal+NVL(comm,0) pay, s.grade
FROM emp e, dept d, salgrade s -- .., .., ..
WHERE d.deptno = e.deptno AND e.sal BETWEEN s.losal AND s.hisal
);
-- ���� 3�� �� ���������� ���̺� ����.
SELECT *
FROM tbl_empgrade;

-- ����� ���������ΰ��� ���� ���ϸ� ���� �����ϴ�.
DROP TABLE tbl_empgrade; -- ������ �̵�.
PURGE RECYCLEBIN; -- ������ ����.
DROP TABLE tbl_empgrade PURGE; -- ���������� �̵����� �ʰ� ������ ����.

-- JOIN ~ ON ���� ����.
CREATE TABLE tbl_empgrade
AS
(
SELECT d.deptno, d.dname, e.empno, e.hiredate, sal+NVL(comm,0) pay
    , s.losal || '~' || s.hisal sal_range, s.grade
FROM emp e JOIN dept d ON d.deptno = e.deptno
    JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal
);

SELECT *
FROM tbl_empgrade;

-- emp ���̺��� ������ �����ؼ� ���ο� tbl_emp ���̺� ����.
CREATE TABLE tbl_emp
AS
(
SELECT *
FROM emp
WHERE 1 = 0
);
--
SELECT *
FROM tbl_emp;
-- emp ���̺��� 10�� �μ������� tbl_emp ���̺� INSERT �۾�..
-- DIRECT LOAD INSERT�� ���� ROW ����
INSERT INTO tbl_emp SELECT * FROM emp WHERE deptno = 10;
COMMIT;

INSERT INTO tbl_emp (empno, ename)SELECT empno, ename FROM emp WHERE deptno = 20;
COMMIT;

DROP TABLE tbl_emp;

-- [���� INSERT �� 4����]
-- 1) Unconditional INSERT ALL �� - ������ ���� INSERT ALL
CREATE TABLE tbl_emp10 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp20 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp30 AS (SELECT * FROM emp WHERE 1 = 0);
CREATE TABLE tbl_emp40 AS (SELECT * FROM emp WHERE 1 = 0);
--
INSERT INTO tbl_emp10 SELECT * FROM emp;
INSERT INTO tbl_emp20 SELECT * FROM emp;
INSERT INTO tbl_emp30 SELECT * FROM emp;
INSERT INTO tbl_emp40 SELECT * FROM emp;
--
SELECT * FROM tbl_emp30;

ROLLBACK;
-- ���� ���� 4���� �� ���� ó��
-- Unconditional INSERT ALL �� - ������ ���� INSERT ALL
INSERT ALL
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- SQL ����: ORA-00947: not enough values : ���� ��������ʴ�.
INSERT ALL 
INTO tbl_emp10 (�÷���,�÷���..) VALUES (empno,ename,job,mgr)
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate)
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm)
SELECT *
FROM emp;
--
-- 2. Conditional INSERT ALL �� - ������ �ִ� INSERT ALL ��
INSERT ALL
WHEN deptno = 10 THEN
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 20 THEN
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
ELSE
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- 3. conditional first insert �� - ������ �ִ� first
INSERT FIRST -- = ELSE IF ��
WHEN deptno = 10 THEN
INTO tbl_emp10 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN sal >= 2500 THEN
INTO tbl_emp20 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
WHEN deptno = 30 THEN
INTO tbl_emp30 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
ELSE
INTO tbl_emp40 VALUES (empno,ename,job,mgr,hiredate,sal,comm,deptno)
SELECT *
FROM emp;
--
-- 4. Pivoting insert ��
CREATE TABLE tbl_sales(
    employee_id        number(6),
    week_id            number(2),
    sales_mon          number(8,2),
    sales_tue          number(8,2),
    sales_wed          number(8,2),
    sales_thu          number(8,2),
    sales_fri          number(8,2)
);

insert into tbl_sales values(1101,4,100,150,80,60,120);
insert into tbl_sales values(1102,5,300,300,230,120,150);
COMMIT;
--
SELECT *
FROM tbl_sales;
--
create table tbl_salesdata(
  employee_id        number(6),
  week_id            number(2),
  sales              number(8,2)
);
-- Pivoting insert ��
insert all
  into tbl_salesdata values(employee_id, week_id, sales_mon)
  into tbl_salesdata values(employee_id, week_id, sales_tue)
  into tbl_salesdata values(employee_id, week_id, sales_wed)
  into tbl_salesdata values(employee_id, week_id, sales_thu)
  into tbl_salesdata values(employee_id, week_id, sales_fri)
select employee_id, week_id, sales_mon, sales_tue, sales_wed,
    sales_thu, sales_fri
from tbl_sales;

SELECT *
FROM tbl_salesdata;
--
DROP TABLE TBL_EMP10;
DROP TABLE TBL_EMP20;
DROP TABLE TBL_EMP30;
DROP TABLE TBL_EMP40;
DROP TABLE tbl_sales;
DROP TABLE tbl_salesdata;

-- DELECT ��,   DROP TABLE ��,   TRUNCATE �� ������.
-- ���ڵ� ����    ���̺� ����       ���ڵ� ��� ����
-- DML ��        DDL ��          DML ��

-- TRUNCATE TABLE ���̺��; -- �ڵ� Ŀ�� : �ѹ��� �Ұ�.

-- DELECT FROM ���̺��; -- Ŀ��/�ѹ��� �ؾ� �Ϻ��� ó����.
-- WHERE �������� ������ ��� ���ڵ� ����.

-- [����] insa ���̺��� num, name ������ �÷����� �����ؼ� ���ο� ���̺� tbl_score ���̺� ����
CREATE TABLE tbl_score
AS (
SELECT num, name
FROM insa
WHERE num <= 1005
);

SELECT *
FROM tbl_score;
-- [����] tbl_score ���̺� kor,eng,mat,tot,avg,grade,rank �÷� �߰�.
ALTER TABLE tbl_score
ADD
(
    kor NUMBER(3) DEFAULT 0
    , eng NUMBER(3) DEFAULT 0
    , mat NUMBER(3) DEFAULT 0
    , tot NUMBER(3) DEFAULT 0
    , avg NUMBER(5,2) DEFAULT 0 -- �Ҽ����� �ڸ����� ����.
    , grade CHAR(3)
    , rank NUMBER(3)
);

DESC tbl_score;

-- [����] 100~1005 ��� �л��� ��,��,�� ������ ������ ������ �߻����Ѽ� ����
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET tbl_score IN (kor,eng,mat) AND FLOOR(dbms_random.values(0,101))
WHERE num BETWEEN 1000 AND 1005;

UPDATE tbl_score
SET kor = FLOOR(dbms_random.value(0,101))
    , eng = FLOOR(dbms_random.value(0,101))
    , mat = FLOOR(dbms_random.value(0,101));

COMMIT;

-- 1001�� ������ 1005��
UPDATE tbl_score
SET (kor,eng,mat) = (SELECT kor,eng,mat FROM tbl_score WHERE num = 1001)
WHERE num = 1005;
-- [����] ��� �л��� ����, ��� UPDATE
UPDATE tbl_score
SET tot = kor+eng+mat
    , avg = (kor+eng+mat)/3;
-- [����] ��� �л��� ��� UPDATE
UPDATE tbl_score m
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > m.tot);

SELECT num, tot
    , (SELECT COUNT(*) FROM tbl_score WHERE tot > m.tot) rank
FROM tbl_score m;
-- ���� �Լ��� ���ؼ� ��� ó��..
SELECT num, tot
    , RANK() OVER(ORDER BY tot DESC) rank
FROM tbl_score;
--
UPDATE tbl_score p
-- SET  rank = ( SELECT COUNT(*)+1 FROM tbl_score c WHERE c.tot > p.tot );
SET rank = (
               SELECT t.r
               FROM (
                   SELECT num, tot, RANK() OVER(ORDER BY tot DESC ) r
                   FROM tbl_score
               ) t
               WHERE t.num =p.num
           );
--
SELECT *
FROM tbl_score;
-- [����] ��� ����(ó��) avg 90 �̻� '��'
UPDATE tbl_score
SET grade = CASE
        WHEN avg >= 90 THEN '��'
        WHEN avg >= 80 THEN '��'
        WHEN avg >= 70 THEN '��'
        WHEN avg >= 60 THEN '��'
        ELSE '��'
    END;

UPDATE tbl_score
SET grade = DECODE(FLOOR(avg/10),10,'��',9,'��',8,'��',7,'��',6,'��','��');

ROLLBACK;
COMMIT;
--
INSERT ALL
    WHEN avg >= 90 THEN
         INTO tbl_score (grade) VALUES( 'A' )
    WHEN avg >= 80 THEN
         INTO tbl_score (grade) VALUES( 'B' )
    WHEN avg >= 70 THEN
         INTO tbl_score (grade) VALUES( 'C' )
    WHEN avg >= 60 THEN
         INTO tbl_score (grade) VALUES( 'D' )
    ELSE
         INTO tbl_score (grade) VALUES( 'F' )
SELECT avg FROM tbl_score ;
-- [����] ��� �л��� ���� ������ 40�� +
SELECT *
FROM tbl_score;

UPDATE tbl_score
SET eng = CASE
            WHEN eng + 40 > 100 THEN 100
            ELSE eng + 40
        END;
-- ���л��� ���� ������ -5 ����
UPDATE tbl_score
SET kor = CASE
        WHEN kor - 5 < 0 THEN 0
        ELSE kor - 5
    END
WHERE num = ANY (SELECT num
    FROM insa
    WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2) = 1);
--
WHERE num IN (SELECT num
    FROM insa
    WHERE num <= 1005 AND MOD(SUBSTR(ssn,8,1),2) = 1);
--
COMMIT;

-- [����] result �÷� �߰� ������ 40 �ȵǸ� ���� ��� 60 �հ� �� ���հ�
ALTER TABLE tbl_score
ADD (
    result VARCHAR2(10)
);

UPDATE tbl_score
SET result = CASE
            WHEN kor <= 40 OR eng <= 40 OR mat <= 40 THEN '����'
            WHEN avg >= 60 THEN '�հ�'
            ELSE '���հ�'
END;

SELECT *
FROM tbl_score;

--------------------------------------------------------------------------------
DROP TABLE TBL_SCORE PURGE;
--
create table tbl_emp(
  id        number primary key
  , name    varchar2(10) not null
  , salary  number
  , bonus   number default 100
);

insert into tbl_emp(id,name,salary) values(1001,'jijoe',150);
insert into tbl_emp(id,name,salary) values(1002,'cho',130);
insert into tbl_emp(id,name,salary) values(1003,'kim',140);

COMMIT;

select * from tbl_emp;

create table tbl_bonus (id number, bonus number default 100);

insert into tbl_bonus(id)
    (select e.id from tbl_emp e);
    
COMMIT;

SELECT *
FROM tbl_bonus;

INSERT INTO tbl_bonus VALUES (1004,50);
1001	100
1002	100
1003	100
1004	50
-- MERGE : ����.
MERGE INTO tbl_bonus b
USING (SELECT id,salary FROM tbl_emp) e -- tbl_emp �͵� ��� ����.
ON (b.id = e.id)
WHEN MATCHED THEN
UPDATE SET b.bonus = b.bonus + e.salary * 0.01
-- WHERE : �ϳ��� �ʿ����.
WHEN NOT MATCHED THEN
INSERT (b.id,b.bonus) VALUES (e.id,e.salary * 0.01);
--
-- ��������
-- ����
-- ��
-- ������ ����

-- DB�𵨸�(����ȭ) 1~2��. ERD
-- PL/SQL 2��.




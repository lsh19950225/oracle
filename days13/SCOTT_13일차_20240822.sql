-- SCOTT
-- [���� ���ν���(stored)] ����
CREATE OR REPLACE PROCEDURE ���ν����� -- OR REPLACE : ������ ����, ������ ����.
(
    -- �Ű�����(argument, parameter) ���� - �Ű����� ������ , �� ����.
    --  �� Ÿ���� ũ�� ���� x
    p�Ű�����   [mode] �ڷ���
                IN �Է¿� �Ķ���� (���� �� �⺻���)
                OUT ��¿� �Ķ����
                IN OUT ��/��¿� �Ķ����
)
IS -- ���� DECLARE
    -- ���� ��� ����;
    v
BEGIN
EXCEPTION
END;
-- ���� ���ν����� �����ϴ� ���(3����)
-- 1) EXECUTE ������ ����
-- 2) �͸� ���ν������� ȣ���ؼ� ����
-- 3) �� �ٸ� ���� ���ν������� ȣ���ؼ� ����

-- ���������� ����ؼ� ���̺� ����
CREATE TABLE tbl_emp
AS
(
SELECT *
FROM emp
);
-- Table TBL_EMP��(��) �����Ǿ����ϴ�.
SELECT *
FROM tbl_emp;
-- tbl_emp ���̺��� �����ȣ�� �Է� �޾Ƽ� ����� �����ϴ� ���� - ���� ���ν���
DELETE FROM tbl_emp
WHERE empno = 7499;
--
-- up_ / uf_ / ut_ ���ξ�
CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno NUMBER(4); : x
    -- pempno NUMBER : o
    -- pempno IN tblemp.empno%TYPE �ذ� ����
    pempno tbl_emp.empno%TYPE
)
IS
-- ����, ��� ���� : �Ұ� ����.
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
-- EXCEPTION
    -- ROLLBACK;
END;
--
-- ���� ���ν����� �����ϴ� ���(3����)
-- 1) EXECUTE ������ ����
EXECUTE UP_DELTBLEMP; -- �Ű����� ��, Ÿ�� �߸���.
EXECUTE UP_DELTBLEMP(7566);
-- EXECUTE UP_DELTBLEMP('SMITH'); -- ���� �Ǵ� Ÿ���� �;ߵ�.
EXECUTE UP_DELTBLEMP(pempno=>7369); -- ���� ����.
SELECT *
FROM tbl_emp;

-- 2) �͸� ���ν������� ȣ���ؼ� ����
-- DECLARE : ���� ���� �� ���� ����.
BEGIN
    UP_DELTBLEMP(7499);
-- EXCEPTION
END;

-- 3) �� �ٸ� ���� ���ν������� ȣ���ؼ� ����
CREATE OR REPLACE PROCEDURE up_DELTBLEMP_test
(
    pempno tbl_emp.empno%TYPE
)
IS
BEGIN
    UP_DELTBLEMP(pempno);
-- EXCEPTION
END;
--
EXECUTE up_DELTBLEMP_test(7521);

SELECT *
FROM tbl_emp;
-- CRUD == C(INSERT) R(SELECT) U(UPDATE) D(DELETE)
-- ���� dept -> tbl_dept ���̺� ����.
CREATE TABLE tbl_dept
AS
(
SELECT *
FROM dept
);

SELECT *
FROM tbl_dept

-- ���� tbl_dept ���������� Ȯ���� �� deptno �÷��� pk �������� ����.
DESC tbl_dept;

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_D%';

ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);

-- ���� tbl_dept ���̺� SELECT�� DBMS ����ϴ� �������ν��� ����
-- up_seltbldept
SELECT *
FROM tbl_dept;

-- 1�� ����� Ŀ��
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
    -- 1. Ŀ�� ����
    CURSOR vdcursor IS
    (
    SELECT deptno,dname,loc
    FROM tbl_dept
    );
    -- �ϳ��� �μ� ������ ���� �� ���� ����
    vdrow tbl_dept%ROWTYPE;
BEGIN
    -- 2. OPEN Ŀ��
    OPEN vdcursor; -- SQL ����
    -- 3. FETCH
    LOOP
        FETCH vdcursor INTO vdrow;
        EXIT WHEN vdcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vdrow.deptno||', '||vdrow.dname||', '||vdrow.loc);
    END LOOP;
    -- 4. CLOSE Ŀ��
    CLOSE vdcursor;
-- EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- 2�� �Ͻ��� Ŀ�� for�� ���
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
BEGIN
    FOR vdrow IN (SELECT deptno,dname,loc FROM tbl_dept)
    LOOP
    DBMS_OUTPUT.PUT_LINE(vdrow.deptno||', '||vdrow.dname||', '||vdrow.loc);
    END LOOP;
-- EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- ���� ���ο� �μ��� �߰��ϴ� ���� ���ν��� up_INStbldept
-- 10/20/30/40      50/60/70
-- ������ ����   ���۰� 50  ������ 10
SELECT *
FROM user_sequences;
-- seq_tbldept
CREATE SEQUENCE seq_tbldept INCREMENT BY 10 START WITH 50 NOCACHE  NOORDER  NOCYCLE ;
--
DESC tbl_dept;
-- dname, loc NULL �����.
--
CREATE OR REPLACE PROCEDURE up_INStbldept
(
    pdname IN tbl_dept.dname%TYPE DEFAULT NULL -- �ذ� ����.
    , ploc IN tbl_dept.loc%TYPE := NULL
)
IS
BEGIN
    INSERT INTO tbl_dept (deptno, dname, loc)
    VALUES (seq_tbldept.NEXTVAL, pdname, ploc);
    COMMIT;
-- EXCEPTION
    -- ROLLBACK;
END;
-- Procedure UP_INSTBLDEPT��(��) �����ϵǾ����ϴ�.
SELECT * FROM tbl_dept;

EXEC up_INStbldept;
EXEC up_INStbldept('QC','SEOUL');
EXEC up_INStbldept(pdname=>'QC',ploc=>'SEOUL');
EXEC up_INStbldept(pdname=>'QC2'); -- �ϳ��� ���� �� ���� ����ؾߵ�.
EXEC up_INStbldept(ploc=>'SEOUL');
--
-- ���� �μ� ��ȣ�� �Է� �޾Ƽ� �����ϴ� up_deltbldept
CREATE OR REPLACE PROCEDURE up_deltbldept
(
    pdeptno tbl_dept.deptno%TYPE
)
IS
BEGIN
    DELETE
    FROM tbl_dept
    WHERE deptno = pdeptno;
-- EXCEPTION
END;

EXEC up_deltbldept(50);
EXEC up_deltbldept(70); -- ���� ó��

SELECT * FROM tbl_dept;

-- ����
EXEC up_updtbldept( 60, 'X', 'Y' );  -- dname, loc
EXEC up_updtbldept( pdeptno=>60,  pdname=>'QC3' );  -- loc
EXEC up_updtbldept( pdeptno=>60,  ploc=>'SEOUL' );  -- 

CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE := NULL
    , ploc tbl_dept.loc%TYPE := NULL
)
IS
    vdname tbl_dept.dname%TYPE; -- ���� �� ���� �μ���
    vloc tbl_dept.loc%TYPE; -- ���� �� ���� ������
BEGIN
    -- 1) ���� ���� ���� �μ���, �������� vdname,vloc ������ ����
    SELECT dname, loc INTO vdname, dloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    -- 2) UPDATE
    IF pdname IS NULL AND ploc IS NULL THEN
    -- ���� ��
    ELSIF pdname IS NULL THEN
        UPDATE tbl_dept
        SET loc = ploc
        WHERE deptno = pdeptno;
    ELSIF ploc IS NULL THEN
        UPDATE tbl_dept
        SET loc = ploc, dname = pdname
        WHERE deptno = pdeptno;
    ELSE
    END IF;
-- EXCEPTION
END;
--
-- 2)
CREATE OR REPLACE PROCEDURE up_updtbldept
(
    pdeptno tbl_dept.deptno%TYPE
    , pdname tbl_dept.dname%TYPE := NULL
    , ploc tbl_dept.loc%TYPE := NULL
)
IS
    vdname tbl_dept.dname%TYPE; -- ���� �� ���� �μ���
    vloc tbl_dept.loc%TYPE; -- ���� �� ���� ������
BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname)
        , loc = CASE
                WHEN ploc IS NULL THEN loc
                ELSE ploc
            END
    WHERE deptno = pdeptno;
    COMMIT;
-- EXCEPTION
END;
--
EXEC up_updtbldept( 60, 'X', 'Y' );  -- dname, loc
EXEC up_updtbldept( pdeptno=>60,  pdname=>'QC3' );  -- loc
EXEC up_updtbldept( pdeptno=>60,  ploc=>'SEOUL' );  -- 
--
SELECT * FROM tbl_dept;
--
EXEC up_deltbldept(60);
-- seq_tbldept ������ ����
DROP SEQUENCE seq_tbls;
--
-- ���� ����� Ŀ���� ����ؼ� ��� �μ��� ��ȸ.
-- �μ���ȣ�� �Ķ���ͷ� �޾Ƽ� �ش� �μ����� ��ȸ
-- up_seltblemp
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
    CURSOR vecursor IS
    (
    SELECT *
    FROM tbl_emp
    WHERE deptno = NVL(pdeptno, 10)
    );
    verow tbl_emp%ROWTYPE;
BEGIN
    OPEN vecursor;
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(verow.deptno||', '||verow.ename||', '||verow.hiredate);
    END LOOP;
    CLOSE vecursor;
-- EXCEPTION
END;
--
-- up_seltblemp [Ŀ���� �Ķ���͸� �̿��ϴ� ���]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
    CURSOR vecursor( cdeptno tbl_emp.deptno%TYPE ) IS
    (
    SELECT *
    FROM tbl_emp
    WHERE deptno = NVL(cdeptno, 10)
    );
    verow tbl_emp%ROWTYPE;
BEGIN
    OPEN vecursor(pdeptno);
    LOOP
        FETCH vecursor INTO verow;
        EXIT WHEN vecursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(verow.deptno||', '||verow.ename||', '||verow.hiredate);
    END LOOP;
    CLOSE vecursor;
-- EXCEPTION
END;
--
-- up_seltblemp [FOR�� �̿��ϴ� ���]
CREATE OR REPLACE PROCEDURE up_seltblemp
(
    pdeptno tbl_emp.deptno%TYPE := NULL
)
IS
BEGIN
    FOR verow IN
    (
    SELECT *
    FROM tbl_emp
    WHERE deptno = NVL(pdeptno, 10)
    )
    LOOP
    DBMS_OUTPUT.PUT_LINE(verow.deptno||', '||verow.ename||', '||verow.hiredate);
    END LOOP;
-- EXCEPTION
END;
--
EXEC UP_SELTBLEMP;
EXEC UP_SELTBLEMP(20);
EXEC UP_SELTBLEMP(30);
--
SELECT * FROM tbl_emp;

-- ���� ���ν���
-- �Ķ���� IN ���, [OUT ���], IN OUT ���

-- �����ȣ(IN) -> �����,�ֹι�ȣ ��¿� �Ű������� ���� ���� ���ν��� ����.
CREATE OR REPLACE PROCEDURE up_selinsa
(
    pnum IN insa.num%TYPE
    , pname OUT insa.name%TYPE
    , pssn OUT insa.ssn%TYPE
)
IS
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    SELECT name, ssn INTO vname, vssn
    FROM insa
    WHERE num = pnum;
    
    pname := vname;
    pssn := CONCAT(SUBSTR(vssn,0,8),'******'); -- 770221-1******

-- EXCEPTION
END;
-- Procedure UP_SELINSA��(��) �����ϵǾ����ϴ�.

-- VARIABLE vname : ��� ������ ����ϴ� ����.
DECLARE
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    UP_SELINSA(1001,vname,vssn); -- VARIABLE - :������
    DBMS_OUTPUT.PUT_LINE(vname||', '||vssn);
-- EXCEPTION
END;

-- ���� �Լ� : ���߿�

-- IN/OUT ����¿� �Ķ���� ���� ���ν���
-- ��)
-- IN + OUT �Ȱ��� ������ ���
-- �ֹε�Ϲ�ȣ(14)�� �Ķ���� IN �Ķ����
-- �������(�ֹι�ȣ6)�ڸ��� OUT �Ķ����
CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS
BEGIN
    pssn := SUBSTR(pssn,0,6);
-- EXCEPTION
END;
-- Procedure UP_SSN��(��) �����ϵǾ����ϴ�.

DECLARE
    vssn VARCHAR2(14) := '761230-1700001';
BEGIN
    up_ssn(vssn); -- �Է¹ް�
    DBMS_OUTPUT.PUT_LINE(vssn); -- ��� : IN OUT
-- EXCEPTION
END;

-- ���� �Լ� ��) �ֹε�Ϲ�ȣ -> ���� üũ
--        �����ڷ��� VARCHAR2 / ���ϰ� '����' '����'
CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2 -- ũ��� �Ⱦ�
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN vgender := '����';
    ELSE vgender := '����';
    END IF;
    RETURN (vgender);
-- EXCEPTION
END;
-- Function UF_GENDER��(��) �����ϵǾ����ϴ�.
SELECT num, name, ssn, uf_gender(ssn) gender -- Function Ȯ�ι�.
    , uf_age(ssn,0) a_age
    , uf_age(ssn,1) c_age
FROM insa;
--
CREATE OR REPLACE FUNCTION uf_age
(
    pssn IN VARCHAR2
    , ptype IN NUMBER -- ������ 0, ���� ���� 1
)
RETURN NUMBER
IS
    �� NUMBER(4); -- ���س⵵
    �� NUMBER(4); -- ���ϳ⵵
    �� NUMBER(1); -- �������� ���� -1/0/1
    vcounting_age NUMBER(3); -- ���³���
    vamerican_age NUMBER(3); -- ������
BEGIN
    -- ������ = ���س⵵ - ���ϳ⵵    ������������x : -1
    --  = ���³��� - 1              ������������x : -1
    -- ���³��� = ���س⵵ - ���ϳ⵵ + 1
    �� := TO_CHAR(SYSDATE,'YYYY');
    �� := CASE 
            WHEN SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN 2000
            ELSE 1800
        END + SUBSTR(pssn,0,2);
    �� := SIGN(TO_DATE(SUBSTR(pssn,3,4),'MMDD') - TRUNC(SYSDATE));
    vcounting_age := ��-��+1;
    vamerican_age := vcounting_age-1 + CASE ��
                                        WHEN 1 THEN -1
                                        ELSE 0
                                        END;
    IF ptype = 1 THEN RETURN vcounting_age;
    ELSE RETURN vamerican_age;
    END IF;
-- EXCEPTION
END;
--
-- ��) �ֹε�Ϲ�ȣ -> 1998.01.20(ȭ) ������ ���ڿ��� ��ȯ�ϴ� �����Լ� �ۼ�
-- uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2
IS
    vbirth insa.ssn%TYPE;
    vcentry NUMBER(2);
BEGIN
    vbirth := TO_CHAR(TO_DATE(19||SUBSTR(pssn,0,6)),'YYYY.DD.MM');
    vcentry := CASE 
                WHEN SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN 19
                WHEN SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN 20
                ELSE 18
                END;
    vbirth := vcentry || vbirth; -- '19771212'
    vbirth := TO_CHAR(TO_DATE(vbirth),'YYYY.MM.DD(DY)');
    RETURN (vbirth);
-- EXCEPTION
END;
--
SELECT ssn, uf_birth(ssn)
FROM insa;
--------------------------------------------------------------------------------
-- �͸����ν���
-- �������ν���
-- �����Լ�
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);
-- Table TBL_SCORE��(��) �����Ǿ����ϴ�.
-- 1 / 1�� ����
CREATE SEQUENCE seq_tblscore;
-- Sequence SEQ_TBLSCORE��(��) �����Ǿ����ϴ�.
SELECT *
FROM user_sequences;
-- ���� �л� �߰��ϴ� ���� ���ν��� ����/�׽�Ʈ
EXEC up_insertscore('ȫ�浿', 89,44,55 );
EXEC up_insertscore('�����', 49,55,95 );
EXEC up_insertscore('�赵��', 90,94,95 );

EXEC up_insertscore('�̽���', 89,75,15 );
EXEC up_insertscore('�ۼ�ȣ', 67,44,75 );

SELECT *
FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_insertscore
(
    pname VARCHAR2
    , pkor NUMBER
    , peng NUMBER
    , pmat NUMBER
)
IS
    vtot NUMBER(3) := 0;
    vavg NUMBER(5,2);
    vgrade tbl_score.grade%TYPE;
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot / 3;
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    INSERT INTO tbl_score (num, name, kor, eng, mat, tot, avg, rank, grade)
    VALUES (seq_tblscore.NEXTVAL, pname, pkor, peng, pmat, vtot, vavg, 1, vgrade);
    -- ��� �л��� ��� ���� ó���ϴ� UPDATE
    up_rankScore;
    
    COMMIT;
-- EXCEPTION
END;
--
-- ����2 up_updateScore ���� ���ν���
EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );

SELECT *
FROM tbl_score;

CREATE OR REPLACE PROCEDURE up_updateScore
(
    pnum NUMBER
    , pkor NUMBER := NULL
    , peng NUMBER := NULL
    , pmat NUMBER := NULL
)
IS  
    vkor NUMBER(3);
    veng NUMBER(3);
    vmat NUMBER(3);
    
    vtot NUMBER(3) := 0;
    vavg NUMBER(5,2);
    vgrade tbl_score.grade%TYPE;
BEGIN
    SELECT kor,eng,mat INTO vkor,veng,vmat
    FROM tbl_score
    WHERE num = pnum;
    
    vtot := NVL(pkor,vkor) + NVL(peng,veng) + NVL(pmat,vmat);
    vavg := vtot/3;
    
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;
    
    UPDATE tbl_score
    SET kor = NVL(pkor, kor)
        , eng = NVL(peng, eng)
        , mat = NVL(pmat, mat)
        , tot = vtot
        , avg = vavg
        , rank = 1
        , grade = vgrade
    WHERE num = pnum;
    
    up_rankScore;
    COMMIT;
-- EXCEPTION
END;
--
--
CREATE OR REPLACE PROCEDURE up_updateScore
(
    pnum tbl_score.num%TYPE
    , pkor tbl_score.kor%TYPE := NULL
    , peng tbl_score.eng%TYPE := NULL
    , pmat tbl_score.mat%TYPE := NULL
)
IS
BEGIN
    UPDATE tbl_score
    SET kor = NVL(pkor, kor), eng = NVL(peng, eng), mat = NVL(pmat, mat)
        , tot = NVL(pkor, kor) + NVL(peng, eng) + NVL(pmat, mat)
        , avg = (NVL(pkor, kor) + NVL(peng, eng) + NVL(pmat, mat)) / 3
    WHERE num = pnum;
    
    UPDATE tbl_score
    SET grade = CASE
                WHEN avg >= 90 THEN 'A'
                WHEN avg >= 80 THEN 'B'
                WHEN avg >= 70 THEN 'C'
                WHEN avg >= 60 THEN 'D'
                ELSE 'F'
                END
    WHERE num = pnum;
--EXCEPTION
END;

-- [����] tbl_score ���̺��� ��� �л��� ����� ó���ϴ� ���ν��� ����
-- up_rankScore
CREATE OR REPLACE PROCEDURE up_rankScore
IS
BEGIN
    UPDATE tbl_score p
    SET rank = (SELECT COUNT(*)+1 FROM tbl_score c WHERE p.tot < c.tot);
-- EXCEPTION
END;
--
EXEC up_rankScore;
--
SELECT *
FROM tbl_score;

-- up_deleteScore �л� 1�� �й����� ����
CREATE OR REPLACE PROCEDURE up_deleteScore
( pnum NUMBER )
IS
BEGIN
    DELETE
    FROM tbl_score
    WHERE num = pnum;
    up_rankScore;
    COMMIT;
-- EXCEPTION
END;

EXEC up_deleteScore(2);

SELECT *
FROM tbl_score;

-- [����] up_selectScore ��� �л� ������ ��ȸ + ����� Ŀ��/�Ͻ���Ŀ��
CREATE OR REPLACE PROCEDURE up_selectScore
IS
BEGIN
FOR vrow IN (SELECT * FROM tbl_score)
LOOP
DBMS_OUTPUT.PUT_LINE(vrow.num||', '||vrow.name);
END LOOP;
END;
--
-- ����� Ŀ��
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) Ŀ�� ����
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  Ŀ�� ���� ����..
  OPEN vcursor;
  --3) FETCH  Ŀ�� INTO 
  LOOP  
    FETCH vcursor INTO vrow;
    EXIT WHEN vcursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(  
           vrow.num || ', ' || vrow.name || ', ' || vrow.kor
           || vrow.eng || ', ' || vrow.mat || ', ' || vrow.tot
           || vrow.avg || ', ' || vrow.grade || ', ' || vrow.rank
        );
  END LOOP;
  --4) CLOSE
  CLOSE vcursor;
--EXCEPTION
  -- ROLLBACK;
END;
--
-- (�ϱ�, ���)
CREATE OR REPLACE PROCEDURE up_selectinsa
(
    -- Ŀ���� �Ķ���ͷ� ����.
    pinsacursor SYS_REFCURSOR -- ����Ŭ 9i ���� REF CURSORS
)
IS
    vname insa.name%TYPE;
    vcity insa.city%TYPE;
    vbasicpay insa.basicpay%TYPE;
BEGIN
    LOOP
        FETCH pinsacursor INTO vname, vcity, vbasicpay;
        EXIT WHEN pinsacursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vname||vcity||vbasicpay);
    END LOOP;
    CLOSE pinsacursor;
-- EXCEPTION
END;
-- Procedure UP_SELECTINSA��(��) �����ϵǾ����ϴ�.
CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
    vinsacursor SYS_REFCURSOR;
BEGIN
    -- OPEN ~ FOR��
    OPEN vinsacursor FOR SELECT name,city,basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
END;
-- Procedure UP_SELECTINSA_TEST��(��) �����ϵǾ����ϴ�.

EXEC UP_SELECTINSA_TEST;

-- [Ʈ����]
CREATE TABLE tbl_exam1
(
   id NUMBER PRIMARY KEY
   , name VARCHAR2(20)
);
--
CREATE TABLE tbl_exam2
(
   memo VARCHAR2(100)
   , ilja DATE DEFAULT SYSDATE
);

-- tbl_exam1 ���̺� INSERT, UPDATE, DELETE �̺�Ʈ�� �߻��ϸ�
-- �ڵ����� tbl_exam2 ���̺� tbl_exam1 ���̺��� � �۾� �Ͼ ����
-- �α׷� ����ϴ� Ʈ���Ÿ� �ۼ��ϰ� Ȯ��.
CREATE OR REPLACE TRIGGER ut_log -- Ʈ���Ŵ� �ȿ��� Ŀ�� �ѹ����� ����.
AFTER
INSERT OR DELETE OR UPDATE ON tbl_exam1
FOR EACH ROW -- �� Ʈ���� : :NEW.name ��밡��. / ������ : table level triggers
-- DECLARE
BEGIN
    IF INSERTING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:NEW.name||'�߰� �α� ���');
    ELSIF DELETING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'���� �α� ���');
    ELSIF UPDATING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'->'||:NEW.name||'���� �α� ���');
    END IF;
-- EXCEPTION
END;
-- Trigger UT_LOG��(��) �����ϵǾ����ϴ�.
CREATE OR REPLACE TRIGGER ut_deletelog -- Ʈ���Ŵ� �ȿ��� Ŀ�� �ѹ����� ����.
AFTER
DELETE ON tbl_exam1
FOR EACH ROW -- �� Ʈ���� : :NEW.name ��밡��. / ������ : table level triggers
-- DECLARE
BEGIN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'���� �α� ���');
-- EXCEPTION
END;
--
UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 1;
COMMIT;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2; -- Ʈ����

INSERT INTO tbl_exam1 VALUES (1, 'hong');

DELETE FROM tbl_exam1
WHERE id = 1;

ROLLBACK;

-- tbl_exam1 ��� ���̺�� DML���� �ٹ��ð�(9~17��) �� �Ǵ� �ָ����� ó�� �ȵǵ��� Ʈ����
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
-- FOR EACH ROW
-- DECLARE
BEGIN
    IF TO_CHAR(SYSDATE,'DY') IN ('��','��')
    OR
    TO_CHAR(SYSDATE,'hh24') < 9
    OR
    TO_CHAR(SYSDATE,'hh24') > 16
    THEN
    -- ������ ���ܸ� �߻� throw new IOException();
    RAISE_APPLICATION_ERROR(-20001,'�ٹ��ð��� �ƴϱ⿡ DML �۾� ó���� �� ����.');
    END IF;
-- EXCEPTION
END;

-- SQL ����: ORA-20001: �ٹ��ð��� �ƴϱ⿡ DML �۾� ó���� �� ����.
INSERT INTO tbl_exam1 VALUES (3,'kim');

DROP TABLE TBL_score;

-- ���� Ʈ���� ������.




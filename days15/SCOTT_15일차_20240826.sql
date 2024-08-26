-- SCOTT
-- Ʈ�����(Transaction)
-- ������ü A -> B
-- 1) UPDATE�� (A ���¿��� �ݾ� ���)
-- 2) UPDATE�� (B ���¿� ������ �ݾ׸�ŭ �Ա�)
-- 1) + 2) ���� �Ϸ�(Ŀ��) / ���� ���(�ѹ�)

COMMIT;

create table tbl_dept
as select * from dept;
-- Table TBL_DEPT��(��) �����Ǿ����ϴ�.
SELECT *
FROM tbl_dept;

-- 1) INSERT
insert into tbl_dept values(50,'development','COREA');

SAVEPOINT a; -- Ư������ ����.

-- 2) UPDATE
update tbl_dept
set loc='ROK'
where deptno=50;

-- ROLLBACK; -- INSERT �������� �ѹ�.
ROLLBACK TO SAVEPOINT a;
ROLLBACK TO a; -- UPDATE�� �ѹ�
ROLLBACK;

-- SESSION A
SELECT *
FROM tbl_dept;

--
DELETE FROM tbl_dept
WHERE deptno = 40;
--
COMMIT;

-- [��Ű��]
CREATE OR REPLACE PACKAGE employee_pkg
as
    -- �������α׷�(�������ν���, �����Լ� ��)
    procedure print_ename(p_empno number);
    procedure print_sal(p_empno number);
    -- ������, ����..
    FUNCTION uf_age
    (
        pssn IN VARCHAR2
        , ptype IN NUMBER
    )
    RETURN NUMBER;
end employee_pkg;
-- Package EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.
-- ��Ű���� ���� �κ�
-- ��Ű�� ��ü �κ�
CREATE OR REPLACE PACKAGE BODY employee_pkg 
AS 
   
      procedure print_ename(p_empno number) is 
         l_ename emp.ename%type; 
       begin 
         select ename 
           into l_ename 
           from emp 
           where empno = p_empno; 
       dbms_output.put_line(l_ename); 
      exception 
        when NO_DATA_FOUND then 
         dbms_output.put_line('Invalid employee number'); 
     end print_ename; 
   
   procedure print_sal(p_empno number) is 
      l_sal emp.sal%type; 
    begin 
      select sal 
       into l_sal 
        from emp 
        where empno = p_empno; 
     dbms_output.put_line(l_sal); 
    exception 
      when NO_DATA_FOUND then 
        dbms_output.put_line('Invalid employee number'); 
   end print_sal;  
   
   FUNCTION uf_age
(
   pssn IN VARCHAR2 
  ,ptype IN NUMBER --  1(���� ����)  0(������)
)
RETURN NUMBER
IS
   �� NUMBER(4);  -- ���س⵵
   �� NUMBER(4);  -- ���ϳ⵵
   �� NUMBER(1);  -- ���� ���� ����    -1 , 0 , 1
   vcounting_age NUMBER(3); -- ���� ���� 
   vamerican_age NUMBER(3); -- �� ���� 
BEGIN
   -- ������ = ���س⵵ - ���ϳ⵵    ������������X  -1 ����.
   --       =  ���³��� -1  
   -- ���³��� = ���س⵵ - ���ϳ⵵ +1 ;
   �� := TO_CHAR(SYSDATE, 'YYYY');
   �� := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   �� :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (����X)

   vcounting_age := �� - �� +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ��, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ��
                                         WHEN 1 THEN -1
                                         ELSE 0
                                        END;

   IF ptype = 1 THEN
      RETURN vcounting_age;
   ELSE 
      RETURN (vamerican_age);
   END IF;
--EXCEPTION
END uf_age;
  
END employee_pkg; 
-- Package Body EMPLOYEE_PKG��(��) �����ϵǾ����ϴ�.

SELECT name, ssn, EMPLOYEE_PKG.UF_AGE(ssn, 1) age
FROM insa;

--------------------------------------------------------------------------------
DROP TABLE O_USER;
DROP TABLE O_ADDRESS;
DROP TABLE O_CART;
DROP TABLE O_CARTLIST;
DROP TABLE O_CATEGORY;
DROP TABLE O_COLOR;
DROP TABLE O_COMMENT;
DROP TABLE O_COUPON;
DROP TABLE O_DELIVERY;
DROP TABLE O_DESIGN;
DROP TABLE O_EVENT;
DROP TABLE O_ISSUEDCOUPON;
DROP TABLE O_LINEUP;
DROP TABLE O_MEMBERSHIP;
DROP TABLE O_ORDER;
DROP TABLE O_PAYMENT;
DROP TABLE O_PDTOPTION;
DROP TABLE O_PRODUCT;
DROP TABLE O_REVIEW;
DROP TABLE O_SUBCATEGORY;
DROP TABLE O_PDTCOLOR;
DROP TABLE O_PDTDESIGN;
DROP TABLE O_PDTLINEUP;
--
SELECT *
FROM O_REVIEW; -- ����
--
SELECT *
FROM O_COMMENT; -- ���
--
CREATE OR REPLACE PROCEDURE insert_o_review
(
    prev_id o_review.rev_id%TYPE
    , ppdt_id o_review.pdt_id%TYPE
    , puser_id o_review.user_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_writedate o_review.rev_writedate%TYPE
    , prev_starpoint o_review.rev_starpoint%TYPE
)
IS
BEGIN
-- EXCEPTION
END;



















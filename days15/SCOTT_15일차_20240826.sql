-- SCOTT
-- 트랜잭션(Transaction)
-- 계좌이체 A -> B
-- 1) UPDATE문 (A 계좌에서 금액 출금)
-- 2) UPDATE문 (B 계좌에 인출한 금액만큼 입금)
-- 1) + 2) 전부 완료(커밋) / 전부 취소(롤백)

COMMIT;

create table tbl_dept
as select * from dept;
-- Table TBL_DEPT이(가) 생성되었습니다.
SELECT *
FROM tbl_dept;

-- 1) INSERT
insert into tbl_dept values(50,'development','COREA');

SAVEPOINT a; -- 특정지점 설정.

-- 2) UPDATE
update tbl_dept
set loc='ROK'
where deptno=50;

-- ROLLBACK; -- INSERT 이전으로 롤백.
ROLLBACK TO SAVEPOINT a;
ROLLBACK TO a; -- UPDATE만 롤백
ROLLBACK;

-- SESSION A
SELECT *
FROM tbl_dept;

--
DELETE FROM tbl_dept
WHERE deptno = 40;
--
COMMIT;

-- [패키지]
CREATE OR REPLACE PACKAGE employee_pkg
as
    -- 서브프로그램(저장프로시저, 저장함수 만)
    procedure print_ename(p_empno number);
    procedure print_sal(p_empno number);
    -- 만나이, 나이..
    FUNCTION uf_age
    (
        pssn IN VARCHAR2
        , ptype IN NUMBER
    )
    RETURN NUMBER;
end employee_pkg;
-- Package EMPLOYEE_PKG이(가) 컴파일되었습니다.
-- 패키지의 명세서 부분
-- 패키지 몸체 부분
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
  ,ptype IN NUMBER --  1(세는 나이)  0(만나이)
)
RETURN NUMBER
IS
   ㄱ NUMBER(4);  -- 올해년도
   ㄴ NUMBER(4);  -- 생일년도
   ㄷ NUMBER(1);  -- 생일 지남 여부    -1 , 0 , 1
   vcounting_age NUMBER(3); -- 세는 나이 
   vamerican_age NUMBER(3); -- 만 나이 
BEGIN
   -- 만나이 = 올해년도 - 생일년도    생일지남여부X  -1 결정.
   --       =  세는나이 -1  
   -- 세는나이 = 올해년도 - 생일년도 +1 ;
   ㄱ := TO_CHAR(SYSDATE, 'YYYY');
   ㄴ := CASE 
          WHEN SUBSTR(pssn,8,1) IN (1,2,5,6) THEN 1900
          WHEN SUBSTR(pssn,8,1) IN (3,4,7,8) THEN 2000
          ELSE 1800
        END + SUBSTR(pssn,1,2);
   ㄷ :=  SIGN(TO_DATE(SUBSTR(pssn,3,4), 'MMDD') - TRUNC(SYSDATE));  -- 1 (생일X)

   vcounting_age := ㄱ - ㄴ +1 ;
   -- PLS-00204: function or pseudo-column 'DECODE' may be used inside a SQL statement only
   -- vamerican_age := vcounting_age - 1 + DECODE( ㄷ, 1, -1, 0 );
   vamerican_age := vcounting_age - 1 + CASE ㄷ
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
-- Package Body EMPLOYEE_PKG이(가) 컴파일되었습니다.

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
FROM O_REVIEW; -- 리뷰
--
SELECT *
FROM O_COMMENT; -- 댓글
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



















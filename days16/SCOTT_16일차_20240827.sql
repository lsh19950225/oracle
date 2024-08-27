-- SCOTT
-- 동적쿼리
-- ? 쿼리가 실행되는 시점에 SQL가 미 결정 상태다.
-- 동적쿼리(SQL)을 사용하는 경우 3가지
-- ㄱ. 컴파일 시에 SQL문장이 확정되지 않은 경우( 가장 많이 사용되는 경우 )
--  예) WHERE 조건절이 정확하게 정해지지 않음.
--  다나와 사이트     노트북 검색 v v v v v v v v v v v v
-- ㄴ. PL/SQL 블럭 안에서 DDL문을 사용하는 경우.
--  CREATE, DROP, ALTER문
-- ㄷ. PL/SQL 블럭 안에서 ALTER SYSTEM/SESSION 명령어를 사용하는 경우

-- [PL/SQL 동적 쿼리를 사용하는 방법 2가지]
--    ㄱ. DMBS_SQL 패키지 사용
--    *** ㄴ. EXECUTE IMMEDIATE문

    -- SELECT, FETCH문 INTO 변수에 값을 할당
    --                  :=
--    형식)
--    EXEC[UTE] IMMEDIATE 동적쿼리문
--                [INTO 변수명, 변수명, ..]
--                [USING [IN/OUT/IN OUT] 파라미터, 파라미터..]

-- 실습예제) 익명 프로시저..
DECLARE
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno = 7369'; -- 띄어쓰기 중요.
    DBMS_OUTPUT.PUT_LINE(vsql);
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;
    DBMS_OUTPUT.PUT_LINE(vdeptno||','||vempno||','||vename||','||vjob);
-- EXCEPTION
END;
--
-- 실습예제) 저장 프로시저
-- 파라미터 : 사원번호 입력..
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno = ' || pempno; -- 띄어쓰기 중요.
    DBMS_OUTPUT.PUT_LINE(vsql);
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob;
    DBMS_OUTPUT.PUT_LINE(vdeptno||','||vempno||','||vename||','||vjob);
-- EXCEPTION
END;

EXEC UP_NDSEMP(7369);
--
-- 실습예제) 저장 프로시저
-- 파라미터 : 사원번호 입력.. USING 이용.
CREATE OR REPLACE PROCEDURE up_ndsemp
(
    pempno emp.empno%TYPE
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
BEGIN
    vsql := 'SELECT deptno, empno, ename, job ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE empno = :pempno'; -- 띄어쓰기 중요.
    DBMS_OUTPUT.PUT_LINE(vsql);
    EXECUTE IMMEDIATE vsql
            INTO vdeptno, vempno, vename, vjob
            USING IN pempno; -- 안쓰면 in put
    DBMS_OUTPUT.PUT_LINE(vdeptno||','||vempno||','||vename||','||vjob);
-- EXCEPTION
END;

EXEC UP_NDSEMP(7369);
--
-- 실습예제) dept 테이블에 새로운 부서를 추가하는 동적쿼리
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdname dept.dname%TYPE := NULL
    , ploc dept.loc%TYPE := NULL
)
IS
    vsql VARCHAR2(1000);
    vdeptno emp.deptno%TYPE;
BEGIN
    SELECT NVL(MAX(deptno),0)+10 INTO vdeptno FROM dept;
    
    vsql := 'INSERT INTO dept (deptno, dname, loc) ';
    vsql := vsql || ' VALUES (:vdeptno, :pdname, :ploc) ';
    DBMS_OUTPUT.PUT_LINE(vsql);
    EXECUTE IMMEDIATE vsql
            USING IN vdeptno, pdname, ploc; -- 안쓰면 in put
    COMMIT;
    DBMS_OUTPUT.PUT_LINE( 'INSERT 성공' );
-- EXCEPTION
END;

EXEC UP_NDSINSDEPT('QC','COREA');

SELECT * FROM dept;

-- 실습) 동적 SQL - DDL문 사용 (테이블 생성)
-- 테이블명, 컬럼명 입력.
DECLARE
    vsql VARCHAR2(1000);
    vtableName VARCHAR2(20);
BEGIN
    vtableName := 'tbl_test';

    vsql := 'CREATE TABLE ' || vtableName;
    vsql := vsql || ' ( ';
    vsql := vsql || ' id NUMBER PRIMARY KEY '; -- 띄어쓰기 중요.
    vsql := vsql || ' , name VARCHAR2(20) ';
    vsql := vsql || ' ) ';
    DBMS_OUTPUT.PUT_LINE(vsql);
    EXECUTE IMMEDIATE vsql;
-- EXCEPTION
END;

SELECT * FROM user_tables
WHERE table_name LIKE 'TBL_T%';

-- OPEN ~ FOR문 : 동적쿼리 실행 + 여러개의 레코드(커서 처리)
-- 부서번호를 파라미터로 입력
CREATE OR REPLACE PROCEDURE up_ndsInsDept
(
    pdeptno emp.deptno%TYPE := 10
)
IS
    vsql VARCHAR2(1000);
    vcur SYS_REFCURSOR; -- 커서를 자료형으로 선언 타입, 9i때는 REF CRSOR
    vrow emp%ROWTYPE;
BEGIN
    vsql := 'SELECT * ';
    vsql := vsql || ' FROM emp ';
    vsql := vsql || ' WHERE deptno = :pdeptno ';
    DBMS_OUTPUT.PUT_LINE(vsql);
    -- EXECUTE IMMEDIATE vsql USING IN vdeptno, pdname, ploc; -- 안쓰면 in put
    -- OPEN ~ FOR문 사용
    -- OPEN 커서 FOR 동적쿼리
    OPEN vcur FOR vsql USING pdeptno;
    LOOP
        FETCH vcur INTO vrow;
        EXIT WHEN vcur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vrow.empno||', '||vrow.ename);
    END LOOP;
    CLOSE vcur;
-- EXCEPTION
END;

EXEC up_ndsInsDept(30);
--
--
-- emp 테이블에서 검색 기능 구현
-- 1) 검색조건    : 1 부서번호, 2 사원명, 3 잡
-- 2) 검색어      :
CREATE OR REPLACE PROCEDURE up_ndsSearchEmp
(
  psearchCondition NUMBER -- 1. 부서번호, 2.사원명, 3. 잡
  , psearchWord VARCHAR2
)
IS
  vsql  VARCHAR2(2000);
  vcur  SYS_REFCURSOR;   -- 커서 타입으로 변수 선언  9i  REF CURSOR
  vrow emp%ROWTYPE;
BEGIN
  vsql := 'SELECT * ';
  vsql := vsql || ' FROM emp ';
  
  IF psearchCondition = 1 THEN -- 부서번호로 검색
    vsql := vsql || ' WHERE  deptno = :psearchWord ';
  ELSIF psearchCondition = 2 THEN -- 사원명
    vsql := vsql || ' WHERE  REGEXP_LIKE( ename , :psearchWord )';
  ELSIF psearchCondition = 3  THEN -- job
    vsql := vsql || ' WHERE  REGEXP_LIKE( job , :psearchWord , ''i'')';
  END IF; 
   
  OPEN vcur  FOR vsql USING psearchWord;
  LOOP  
    FETCH vcur INTO vrow;
    EXIT WHEN vcur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vrow.empno || ' '  || vrow.ename || ' ' || vrow.job );
  END LOOP;   
  CLOSE vcur; 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, '>EMP DATA NOT FOUND...');
  WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20004, '>OTHER ERROR...');
END;

EXEC UP_NDSSEARCHEMP(1, '20'); 
EXEC UP_NDSSEARCHEMP(2, 'L'); 
EXEC UP_NDSSEARCHEMP(3, 's'); 
--------------------------------------------------------------------------------






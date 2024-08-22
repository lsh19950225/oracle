-- SCOTT
-- [저장 프로시저(stored)] 형식
CREATE OR REPLACE PROCEDURE 프로시저명 -- OR REPLACE : 있으면 수정, 없으면 생성.
(
    -- 매개변수(argument, parameter) 선언 - 매개변수 나열은 , 로 선언.
    --  ㄴ 타입의 크기 설정 x
    p매개변수   [mode] 자료형
                IN 입력용 파라미터 (생략 시 기본모드)
                OUT 출력용 파라미터
                IN OUT 입/출력용 파라미터
)
IS -- 원래 DECLARE
    -- 변수 상수 선언;
    v
BEGIN
EXCEPTION
END;
-- 저장 프로시저를 실행하는 방법(3가지)
-- 1) EXECUTE 문으로 실행
-- 2) 익명 프로시저에서 호출해서 실행
-- 3) 또 다른 저장 프로시저에서 호출해서 실행

-- 서브쿼리를 사용해서 테이블 생성
CREATE TABLE tbl_emp
AS
(
SELECT *
FROM emp
);
-- Table TBL_EMP이(가) 생성되었습니다.
SELECT *
FROM tbl_emp;
-- tbl_emp 테이블에서 사원번호를 입력 받아서 사원을 삭제하는 쿼리 - 저장 프로시저
DELETE FROM tbl_emp
WHERE empno = 7499;
--
-- up_ / uf_ / ut_ 접두어
CREATE OR REPLACE PROCEDURE up_deltblemp
(
    -- pempno NUMBER(4); : x
    -- pempno NUMBER : o
    -- pempno IN tblemp.empno%TYPE 밑과 동일
    pempno tbl_emp.empno%TYPE
)
IS
-- 변수, 상수 선언 : 할게 없음.
BEGIN
    DELETE FROM tbl_emp
    WHERE empno = pempno;
    COMMIT;
-- EXCEPTION
    -- ROLLBACK;
END;
--
-- 저장 프로시저를 실행하는 방법(3가지)
-- 1) EXECUTE 문으로 실행
EXECUTE UP_DELTBLEMP; -- 매개변수 수, 타입 잘못됨.
EXECUTE UP_DELTBLEMP(7566);
-- EXECUTE UP_DELTBLEMP('SMITH'); -- 숫자 또는 타입이 와야됨.
EXECUTE UP_DELTBLEMP(pempno=>7369); -- 선언 가능.
SELECT *
FROM tbl_emp;

-- 2) 익명 프로시저에서 호출해서 실행
-- DECLARE : 변수 없을 시 생략 가능.
BEGIN
    UP_DELTBLEMP(7499);
-- EXCEPTION
END;

-- 3) 또 다른 저장 프로시저에서 호출해서 실행
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
-- 문제 dept -> tbl_dept 테이블 생성.
CREATE TABLE tbl_dept
AS
(
SELECT *
FROM dept
);

SELECT *
FROM tbl_dept

-- 문제 tbl_dept 제약조건을 확인한 후 deptno 컬럼에 pk 제약조건 설정.
DESC tbl_dept;

SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_D%';

ALTER TABLE tbl_dept
ADD CONSTRAINT pk_tbldept_deptno PRIMARY KEY(deptno);

-- 문제 tbl_dept 테이블 SELECT문 DBMS 출력하는 저장프로시저 생성
-- up_seltbldept
SELECT *
FROM tbl_dept;

-- 1조 명시적 커서
CREATE OR REPLACE PROCEDURE up_seltbldept
IS
    -- 1. 커서 선언
    CURSOR vdcursor IS
    (
    SELECT deptno,dname,loc
    FROM tbl_dept
    );
    -- 하나의 부서 정보를 저장 할 변수 선언
    vdrow tbl_dept%ROWTYPE;
BEGIN
    -- 2. OPEN 커서
    OPEN vdcursor; -- SQL 실행
    -- 3. FETCH
    LOOP
        FETCH vdcursor INTO vdrow;
        EXIT WHEN vdcursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vdrow.deptno||', '||vdrow.dname||', '||vdrow.loc);
    END LOOP;
    -- 4. CLOSE 커서
    CLOSE vdcursor;
-- EXCEPTION
END;

EXEC UP_SELTBLDEPT;

-- 2조 암시적 커서 for문 사용
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

-- 문제 새로운 부서를 추가하는 저장 프로시저 up_INStbldept
-- 10/20/30/40      50/60/70
-- 시퀀스 생성   시작값 50  증가값 10
SELECT *
FROM user_sequences;
-- seq_tbldept
CREATE SEQUENCE seq_tbldept INCREMENT BY 10 START WITH 50 NOCACHE  NOORDER  NOCYCLE ;
--
DESC tbl_dept;
-- dname, loc NULL 허용함.
--
CREATE OR REPLACE PROCEDURE up_INStbldept
(
    pdname IN tbl_dept.dname%TYPE DEFAULT NULL -- 밑과 동일.
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
-- Procedure UP_INSTBLDEPT이(가) 컴파일되었습니다.
SELECT * FROM tbl_dept;

EXEC up_INStbldept;
EXEC up_INStbldept('QC','SEOUL');
EXEC up_INStbldept(pdname=>'QC',ploc=>'SEOUL');
EXEC up_INStbldept(pdname=>'QC2'); -- 하나만 넣을 시 값은 명시해야됨.
EXEC up_INStbldept(ploc=>'SEOUL');
--
-- 문제 부서 번호를 입력 받아서 삭제하는 up_deltbldept
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
EXEC up_deltbldept(70); -- 예외 처리

SELECT * FROM tbl_dept;

-- 문제
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
    vdname tbl_dept.dname%TYPE; -- 수정 전 원래 부서명
    vloc tbl_dept.loc%TYPE; -- 수정 전 원래 지역명
BEGIN
    -- 1) 수정 전의 원래 부서명, 지역명을 vdname,vloc 변수에 저장
    SELECT dname, loc INTO vdname, dloc
    FROM tbl_dept
    WHERE deptno = pdeptno;
    -- 2) UPDATE
    IF pdname IS NULL AND ploc IS NULL THEN
    -- 수정 끝
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
    vdname tbl_dept.dname%TYPE; -- 수정 전 원래 부서명
    vloc tbl_dept.loc%TYPE; -- 수정 전 원래 지역명
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
-- seq_tbldept 시퀀스 삭제
DROP SEQUENCE seq_tbls;
--
-- 문제 명시적 커서를 사용해서 모든 부서원 조회.
-- 부서번호를 파라미터로 받아서 해당 부서원만 조회
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
-- up_seltblemp [커서에 파라미터를 이용하는 방법]
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
-- up_seltblemp [FOR문 이용하는 방법]
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

-- 저장 프로시저
-- 파라미터 IN 모드, [OUT 모드], IN OUT 모드

-- 사원번호(IN) -> 사원명,주민번호 출력용 매개변수로 받은 저장 프로시저 생성.
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
-- Procedure UP_SELINSA이(가) 컴파일되었습니다.

-- VARIABLE vname : 모든 곳에서 사용하는 변수.
DECLARE
    vname insa.name%TYPE;
    vssn insa.ssn%TYPE;
BEGIN
    UP_SELINSA(1001,vname,vssn); -- VARIABLE - :변수명
    DBMS_OUTPUT.PUT_LINE(vname||', '||vssn);
-- EXCEPTION
END;

-- 저장 함수 : 나중에

-- IN/OUT 입출력용 파라미터 저장 프로시저
-- 예)
-- IN + OUT 똑같은 변수를 사용
-- 주민등록번호(14)를 파라미터 IN 파라미터
-- 생년월일(주민번호6)자리를 OUT 파라미터
CREATE OR REPLACE PROCEDURE up_ssn
(
    pssn IN OUT VARCHAR2
)
IS
BEGIN
    pssn := SUBSTR(pssn,0,6);
-- EXCEPTION
END;
-- Procedure UP_SSN이(가) 컴파일되었습니다.

DECLARE
    vssn VARCHAR2(14) := '761230-1700001';
BEGIN
    up_ssn(vssn); -- 입력받고
    DBMS_OUTPUT.PUT_LINE(vssn); -- 출력 : IN OUT
-- EXCEPTION
END;

-- 저장 함수 예) 주민등록번호 -> 성별 체크
--        리턴자료형 VARCHAR2 / 리턴값 '남자' '여자'
CREATE OR REPLACE FUNCTION uf_gender
(
    pssn insa.ssn%TYPE
)
RETURN VARCHAR2 -- 크기는 안씀
IS
    vgender VARCHAR2(6);
BEGIN
    IF MOD(SUBSTR(pssn,-7,1),2) = 1 THEN vgender := '남자';
    ELSE vgender := '여자';
    END IF;
    RETURN (vgender);
-- EXCEPTION
END;
-- Function UF_GENDER이(가) 컴파일되었습니다.
SELECT num, name, ssn, uf_gender(ssn) gender -- Function 확인법.
    , uf_age(ssn,0) a_age
    , uf_age(ssn,1) c_age
FROM insa;
--
CREATE OR REPLACE FUNCTION uf_age
(
    pssn IN VARCHAR2
    , ptype IN NUMBER -- 만나이 0, 세는 나이 1
)
RETURN NUMBER
IS
    ㄱ NUMBER(4); -- 올해년도
    ㄴ NUMBER(4); -- 생일년도
    ㄷ NUMBER(1); -- 생일지남 여부 -1/0/1
    vcounting_age NUMBER(3); -- 세는나이
    vamerican_age NUMBER(3); -- 만나이
BEGIN
    -- 만나이 = 올해년도 - 생일년도    생일지났여부x : -1
    --  = 세는나이 - 1              생일지났여부x : -1
    -- 세는나이 = 올해년도 - 생일년도 + 1
    ㄱ := TO_CHAR(SYSDATE,'YYYY');
    ㄴ := CASE 
            WHEN SUBSTR(pssn,-7,1) IN (1,2,5,6) THEN 1900
            WHEN SUBSTR(pssn,-7,1) IN (3,4,7,8) THEN 2000
            ELSE 1800
        END + SUBSTR(pssn,0,2);
    ㄷ := SIGN(TO_DATE(SUBSTR(pssn,3,4),'MMDD') - TRUNC(SYSDATE));
    vcounting_age := ㄱ-ㄴ+1;
    vamerican_age := vcounting_age-1 + CASE ㄷ
                                        WHEN 1 THEN -1
                                        ELSE 0
                                        END;
    IF ptype = 1 THEN RETURN vcounting_age;
    ELSE RETURN vamerican_age;
    END IF;
-- EXCEPTION
END;
--
-- 예) 주민등록번호 -> 1998.01.20(화) 형식의 문자열로 반환하는 저장함수 작성
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
-- 익명프로시저
-- 저장프로시저
-- 저장함수
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
-- Table TBL_SCORE이(가) 생성되었습니다.
-- 1 / 1씩 증가
CREATE SEQUENCE seq_tblscore;
-- Sequence SEQ_TBLSCORE이(가) 생성되었습니다.
SELECT *
FROM user_sequences;
-- 문제 학생 추가하는 저장 프로시저 생성/테스트
EXEC up_insertscore('홍길동', 89,44,55 );
EXEC up_insertscore('윤재민', 49,55,95 );
EXEC up_insertscore('김도균', 90,94,95 );

EXEC up_insertscore('이시훈', 89,75,15 );
EXEC up_insertscore('송세호', 67,44,75 );

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
    -- 모든 학생들 등수 새로 처리하는 UPDATE
    up_rankScore;
    
    COMMIT;
-- EXCEPTION
END;
--
-- 문제2 up_updateScore 저장 프로시저
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

-- [문제] tbl_score 테이블의 모든 학생의 등수를 처리하는 프로시저 생성
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

-- up_deleteScore 학생 1명 학번으로 삭제
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

-- [문제] up_selectScore 모든 학생 정보를 조회 + 명시적 커서/암시적커서
CREATE OR REPLACE PROCEDURE up_selectScore
IS
BEGIN
FOR vrow IN (SELECT * FROM tbl_score)
LOOP
DBMS_OUTPUT.PUT_LINE(vrow.num||', '||vrow.name);
END LOOP;
END;
--
-- 명시적 커서
CREATE OR REPLACE PROCEDURE up_selectScore
IS
  --1) 커서 선언
  CURSOR vcursor IS (SELECT * FROM tbl_score);
  vrow tbl_score%ROWTYPE;
BEGIN
  --2) OPEN  커서 실제 실행..
  OPEN vcursor;
  --3) FETCH  커서 INTO 
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
-- (암기, 기억)
CREATE OR REPLACE PROCEDURE up_selectinsa
(
    -- 커서를 파라미터로 전달.
    pinsacursor SYS_REFCURSOR -- 오라클 9i 이전 REF CURSORS
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
-- Procedure UP_SELECTINSA이(가) 컴파일되었습니다.
CREATE OR REPLACE PROCEDURE up_selectinsa_test
IS
    vinsacursor SYS_REFCURSOR;
BEGIN
    -- OPEN ~ FOR문
    OPEN vinsacursor FOR SELECT name,city,basicpay FROM insa;
    UP_SELECTINSA(vinsacursor);
END;
-- Procedure UP_SELECTINSA_TEST이(가) 컴파일되었습니다.

EXEC UP_SELECTINSA_TEST;

-- [트리거]
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

-- tbl_exam1 테이블에 INSERT, UPDATE, DELETE 이벤트가 발생하면
-- 자동으로 tbl_exam2 테이블에 tbl_exam1 테이블에서 어떤 작업 일어난 것을
-- 로그로 기록하는 트리거를 작성하고 확인.
CREATE OR REPLACE TRIGGER ut_log -- 트리거는 안에서 커밋 롤백하지 않음.
AFTER
INSERT OR DELETE OR UPDATE ON tbl_exam1
FOR EACH ROW -- 행 트리거 : :NEW.name 사용가능. / 없으면 : table level triggers
-- DECLARE
BEGIN
    IF INSERTING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:NEW.name||'추가 로그 기록');
    ELSIF DELETING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'삭제 로그 기록');
    ELSIF UPDATING THEN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'->'||:NEW.name||'수정 로그 기록');
    END IF;
-- EXCEPTION
END;
-- Trigger UT_LOG이(가) 컴파일되었습니다.
CREATE OR REPLACE TRIGGER ut_deletelog -- 트리거는 안에서 커밋 롤백하지 않음.
AFTER
DELETE ON tbl_exam1
FOR EACH ROW -- 행 트리거 : :NEW.name 사용가능. / 없으면 : table level triggers
-- DECLARE
BEGIN
    INSERT INTO tbl_exam2 (memo) VALUES (:OLD.name||'삭제 로그 기록');
-- EXCEPTION
END;
--
UPDATE tbl_exam1
SET name = 'admin'
WHERE id = 1;
COMMIT;

SELECT * FROM tbl_exam1;
SELECT * FROM tbl_exam2; -- 트리거

INSERT INTO tbl_exam1 VALUES (1, 'hong');

DELETE FROM tbl_exam1
WHERE id = 1;

ROLLBACK;

-- tbl_exam1 대상 테이블로 DML문이 근무시간(9~17시) 외 또는 주말에는 처리 안되도록 트리거
CREATE OR REPLACE TRIGGER ut_log_before
BEFORE
INSERT OR UPDATE OR DELETE ON tbl_exam1
-- FOR EACH ROW
-- DECLARE
BEGIN
    IF TO_CHAR(SYSDATE,'DY') IN ('토','일')
    OR
    TO_CHAR(SYSDATE,'hh24') < 9
    OR
    TO_CHAR(SYSDATE,'hh24') > 16
    THEN
    -- 강제로 예외를 발생 throw new IOException();
    RAISE_APPLICATION_ERROR(-20001,'근무시간이 아니기에 DML 작업 처리할 수 없다.');
    END IF;
-- EXCEPTION
END;

-- SQL 오류: ORA-20001: 근무시간이 아니기에 DML 작업 처리할 수 없다.
INSERT INTO tbl_exam1 VALUES (3,'kim');

DROP TABLE TBL_score;

-- 내일 트리거 마무리.




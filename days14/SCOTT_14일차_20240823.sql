-- SCOTT
-- TRIGGER(트리거) - 요새 잘 안쓴다.
상품테이블
PK          재고수량
1   냉장고     10
2   TV        5 -> 35 -> 20
3   자전거     20

입고테이블
입고번호PK  입고날짜    입고상품번호(FK)  입고수량
1000        ?           2(TV)          30

판매테이블
판번      판매날짜    판매상품번호(FK)  판매수량
1000        ?           2(TV)         15
--
-- 상품 테이블 작성
CREATE TABLE 상품 (
   상품코드      VARCHAR2(6) NOT NULL PRIMARY KEY
  ,상품명        VARCHAR2(30)  NOT NULL
  ,제조사        VARCHAR2(30)  NOT NULL
  ,소비자가격     NUMBER
  ,재고수량       NUMBER DEFAULT 0
);
-- Table 상품이(가) 생성되었습니다.

-- 입고 테이블 작성
CREATE TABLE 입고 (
   입고번호      NUMBER PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_ibgo_no
                 REFERENCES 상품(상품코드)
  ,입고일자     DATE
  ,입고수량      NUMBER
  ,입고단가      NUMBER
);
-- Table 입고이(가) 생성되었습니다.

-- 판매 테이블 작성
CREATE TABLE 판매 (
   판매번호      NUMBER  PRIMARY KEY
  ,상품코드      VARCHAR2(6) NOT NULL CONSTRAINT FK_pan_no
                 REFERENCES 상품(상품코드)
  ,판매일자      DATE
  ,판매수량      NUMBER
  ,판매단가      NUMBER
);
-- Table 판매이(가) 생성되었습니다.
--
-- 상품 테이블에 자료 추가
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('AAAAAA', '디카', '삼싱', 100000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('BBBBBB', '컴퓨터', '엘디', 1500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('CCCCCC', '모니터', '삼싱', 600000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
        ('DDDDDD', '핸드폰', '다우', 500000);
INSERT INTO 상품(상품코드, 상품명, 제조사, 소비자가격) VALUES
         ('EEEEEE', '프린터', '삼싱', 200000);
COMMIT;

SELECT * FROM 상품;
--
--
-- 문제1) 입고 테이블에 상품이 입고가 되면 자동으로 상품 테이블의 재고수량이  update 되는 트리거 생성 + 확인
-- 입고 테이블에 데이터 입력  
--  ut_insIpgo
CREATE OR REPLACE TRIGGER ut_insIpgo
AFTER
INSERT ON 입고
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    -- :NEW.상품코드   :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = 재고수량 + :NEW.입고수량
    WHERE 상품코드 = :NEW.상품코드;
    -- 커밋 안함.
-- EXCEPTION
END;
--
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (1, 'AAAAAA', '2023-10-10', 5,   50000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (2, 'BBBBBB', '2023-10-10', 15, 700000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (3, 'AAAAAA', '2023-10-11', 15, 52000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (4, 'CCCCCC', '2023-10-14', 15,  250000);
INSERT INTO 입고 (입고번호, 상품코드, 입고일자, 입고수량, 입고단가)
              VALUES (5, 'BBBBBB', '2023-10-16', 25, 700000);
COMMIT;

SELECT * FROM 입고;
SELECT * FROM 상품;
--
--
-- 문제2) 입고 테이블에서 입고가 수정되는 경우    상품테이블의 재고수량 수정. 
CREATE OR REPLACE TRIGGER ut_updIpgo
AFTER
UPDATE ON 입고
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    -- :NEW.상품코드   :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = :NEW.입고수량 - :OLD.입고수량
    WHERE 상품코드 = :NEW.상품코드;
    -- 커밋 안함.
-- EXCEPTION
END;
--
UPDATE 입고 
SET 입고수량 = 30 
WHERE 입고번호 = 5;
COMMIT;
--
-- 문제3) 입고 테이블에서 입고가 취소되어서 입고 삭제.    상품테이블의 재고수량 수정. 
CREATE OR REPLACE TRIGGER ut_delIpgo
AFTER
DELETE ON 입고
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    -- :NEW.상품코드   :NEW.입고수량
    UPDATE 상품
    SET 재고수량 = 재고수량 - :OLD.입고수량
    WHERE 상품코드 = :OLD.상품코드;
    -- 커밋 안함.
-- EXCEPTION
END;
--
DELETE FROM 입고 
WHERE 입고번호 = 5;
COMMIT;

SELECT * FROM 입고;
SELECT * FROM 상품;

-- 문제4) 판매테이블에 판매가 되면 (INSERT) 
--       상품테이블의 재고수량이 수정
-- ut_insPan
CREATE OR REPLACE TRIGGER ut_insPan
BEFORE
INSERT ON 판매
FOR EACH ROW -- 행 레벨 트리거
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    SELECT 재고수량 INTO vqty
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    -- :NEW.상품코드   :NEW.입고수량
    -- 커밋 안함.
    IF vqty < :NEW.판매수량 THEN
    RAISE_APPLICATION_ERROR(-20001,'재고수량이 부족해 판매할 수 없다.');
    ELSE
    UPDATE 상품
    SET 재고수량 = 재고수량 - :NEW.판매수량
    WHERE 상품코드 = :NEW.상품코드;
    END IF;
-- EXCEPTION
END;
--
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (1, 'AAAAAA', '2023-11-10', 5, 1000000);

-- SQL 오류: ORA-20001: 재고수량이 부족해 판매할 수 없다.
INSERT INTO 판매 (판매번호, 상품코드, 판매일자, 판매수량, 판매단가) VALUES
               (2, 'AAAAAA', '2023-11-12', 50, 1000000);
COMMIT;

SELECT * FROM 판매;
SELECT * FROM 입고;
SELECT * FROM 상품;
--
-- 문제5) 판매번호 1  20     판매수량 5 -> 10 
-- ut_updPan
CREATE OR REPLACE TRIGGER ut_updPan
BEFORE
UPDATE ON 판매
FOR EACH ROW -- 행 레벨 트리거
DECLARE
    vqty 상품.재고수량%TYPE;
BEGIN
    SELECT 재고수량 INTO vqty -- 15
    FROM 상품
    WHERE 상품코드 = :NEW.상품코드;
    
    IF (vqty + :OLD.판매수량) < :NEW.판매수량 THEN
    RAISE_APPLICATION_ERROR(-20001,'업데이트 불가');
    ELSE
    UPDATE 상품
    SET 재고수량 = (재고수량 + :OLD.판매수량) - :NEW.판매수량
    WHERE 상품코드 = :NEW.상품코드;
    END IF;
-- EXCEPTION
END;
--
UPDATE 판매 
SET 판매수량 = 10
WHERE 판매번호 = 1;
--
SELECT * FROM 판매;
SELECT * FROM 입고;
SELECT * FROM 상품;
--
COMMIT;
-- 문제 6)판매번호 1   (AAAAA  10)   판매 취소 (DELETE)
--      상품테이블에 재고수량 수정
-- ut_delPan
CREATE OR REPLACE TRIGGER ut_delPan
AFTER
DELETE ON 판매
FOR EACH ROW -- 행 레벨 트리거
BEGIN
    
    UPDATE 상품
    SET 재고수량 = 재고수량 + :OLD.판매수량
    WHERE 상품코드 = :OLD.상품코드;
-- EXCEPTION
END;
--
DELETE FROM 판매 
WHERE 판매번호=1;
--
SELECT * FROM 판매;
SELECT * FROM 입고;
SELECT * FROM 상품;

COMMIT;

-- [예외처리 블럭 설명]
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found : 제약조건에 위배
INSERT INTO emp (empno,ename,deptno)
VALUES (9999,'admin',90);
--
CREATE OR REPLACE PROCEDURE up_exceptiontest
(
    psal IN emp.sal%TYPE
)
IS
    vename emp.ename%TYPE;
BEGIN
    SELECT ename INTO vename
    FROM emp
    WHERE sal = psal;
    
    DBMS_OUTPUT.PUT_LINE('> vename = ' || vename);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20001,'QUERY NO_DATA_FOUND'); -- DATA로 수정.
    WHEN TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR(-20002,'QUERY TOO_MANY_ROWS');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20009,'QUERY OTHERS EXCEPTION FOUND');
END;

EXEC up_exceptiontest(800);

-- ORA-01403: no data found
EXEC up_exceptiontest(9000); -- 9000 받는 사람없음.

-- ORA-01422: exact fetch returns more than requested number of rows
EXEC up_exceptiontest(2850);

SELECT *
FROM emp;

-- 미리 정의 되지 않은 에러 처리 방법
-- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found : 제약조건에 위배
INSERT INTO emp (empno,ename,deptno)
VALUES (9999,'admin',90);
--
CREATE OR REPLACE PROCEDURE up_insertemp
(
    pempno emp.empno%TYPE
    , pename emp.ename%TYPE
    , pdeptno emp.deptno%TYPE
)
IS
    PARENT_KEY_NOT_FOUND EXCEPTION;
    PRAGMA EXCEPTION_INIT (PARENT_KEY_NOT_FOUND, -02291); -- 코드번호랑 예외랑 일치시키는 코딩.
BEGIN
    INSERT INTO emp (empno,ename,deptno)
    VALUES (pempno,pename,pdeptno);
    COMMIT;
EXCEPTION
    -- ORA-02291: integrity constraint (SCOTT.FK_DEPTNO) violated - parent key not found : 제약조건에 위배
    WHEN PARENT_KEY_NOT_FOUND THEN RAISE_APPLICATION_ERROR(-20011,'QUERY FK 위배..');
    
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20001,'QUERY NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR(-20002,'QUERY TOO_MANY_ROWS');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20009,'QUERY OTHERS EXCEPTION FOUND');
END;

-- ORA-20011: QUERY FK 위배.. : 만든것.
EXEC up_insertemp(9999,'admin',90);

-- [사용자가 정의한 에러 처리 방법]
--자바 수업
--    필드 선언
--    private int kor;
--    setter
--    0~100   this.kor = kor;
--    x       throw new ScoreOutOfRangeException(1004,"점수 범위 벗어났다.")
--    class ScoreOutOfRangeException extends Exception {
--    }
--
-- sal 범위가 A~B 사원수 카운팅
--                       0 내가 선언한 예외 강제로 발생..
EXEC up_myexception(800,1200);

-- ORA-20022: QUERY 사원수가 0이다. -- 사용자 정의 예외.
EXEC up_myexception(6000,7200); -- 카운트 값 : 0

CREATE OR REPLACE PROCEDURE up_myexception
(
    plosal NUMBER
    , phisal NUMBER
)
IS
    vcount NUMBER;
    
    -- 1. 사용자 정의 예외 객체(변수) 선언
    ZERO_ENP_COUNT EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO vcount
    FROM emp
    WHERE sal BETWEEN plosal AND phisal;
    
    IF vcount = 0 THEN
        -- 2) 강제로 사용자 정의한 에러 발생
        RAISE ZERO_ENP_COUNT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('사원수 : '|| vcount);
    END IF;
    
EXCEPTION
    WHEN ZERO_ENP_COUNT THEN RAISE_APPLICATION_ERROR(-20022,'QUERY 사원수가 0이다.');

    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20001,'QUERY NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN RAISE_APPLICATION_ERROR(-20002,'QUERY TOO_MANY_ROWS');
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20009,'QUERY OTHERS EXCEPTION FOUND');
END;





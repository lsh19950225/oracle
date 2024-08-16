-- SCOTT
-- 제약조건(Constraint) --
SELECT *
FROM user_constraints -- 뷰(View)
WHERE table_name = 'EMP';
-- 제약조건 사용 이유 ?
-- 1) 제약조건은 data integrity(데이터 무결성)을 위하여 주로 테이블에 행(row)을 입력, 수정, 삭제할 때 적용되는 규칙으로 사용되며
-- 2) 테이블에 의해 참조되고 있는 경우 [테이블의 삭제 방지]를 위해서도 사용된다.

-- 참고) 무결성(integrity)
-- 데이터의 정확성과 일관성을 유지하고, 데이터에 결손과 부정합이 없음을 보증하는 것

-- 2) 제약조건 생성 방법
-- 1. 테이블을 생성과 동시에 제약조건을 생성.
    -- ㄱ. IN-LINE 제약조건 설정 방법 (컬럼 레벨)
        -- 예) seq NUMBER PRIMARY KEY
    -- ㄴ. OUT-OF_LINE 제약조건 설정 방법 (테이블 레벨)
        -- CREATE TABLE XX
        (
            컬럼1 -- 컬럼 레벨 (NOT NULL 제약조건은 컬럼레벨로만 가능.)
            , 컬럼2
        
        :
        , 제약조건 설정 -- 테이블 레벨 (복합키 설정할 때는 테이블 레벨로)
        , 제약조건 설정
        , 제약조건 설정
        )
        
        예) 복합키 설정 이유 ?
        [사원 급여 지급 테이블]
순번(역정규화) 급여지급날짜  사원번호    급여액 -- 이럴 경우는 (급여지급날짜 + 사원번호) 합쳐서 PK : 복합키         -> [역정규화]
1            2024.7.15   1111    3,000,000
2            2024.7.15   1112    3,000,000
3            2024.7.15   1113    3,000,000
:            :
4            2024.8.15   1111    3,000,000
5            2024.8.15   1112    3,000,000
6            2024.8.15   1113    3,000,000
:            :

-- PRIMARY KEY(PK) 해당 컬럼 값은 반드시 존재해야 하며, 유일해야 함
--    ㄴ (NOT NULL과 UNIQUE 제약조건을 결합한 형태) 
-- FOREIGN KEY(FK) 해당 컬럼 값은 참조되는 테이블의 컬럼 값 중의 하나와 일치하거나 NULL을 가짐 
-- UNIQUE KEY(UK) 테이블내에서 해당 컬럼 값은 항상 유일해야 함 
-- NOT NULL 컬럼은 NULL 값을 포함할 수 없다. 
-- (CK) 해당 컬럼에 저장 가능한 데이터 값의 범위나 조건 지정 


-- 예) 컬럼 레벨 방식으로 제약조건 설정 + 테이블 생성과 동시에 제약조건 설정.
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
    , email VARCHAR2(150) CONSTRAINT uk_tblconstraint1_email UNIQUE -- 중복 불가.
    , kor NUMBER(3) CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- WHERE 조건절에 조건을 주면됨.
    , city VARCHAR2(20) CONSTRAINT ck_tblconstraint1_city CHECK(city IN ('서울','부산','대구'))
);
-- 예) 테이블 레벨 방식으로 제약조건 설정 + 테이블 생성과 동시에 제약조건 설정.
CREATE TABLE tbl_constraint1
(
    -- empno NUMBER(4) NOT NULL PRIMARY KEY : SYS_CXXXX
    empno NUMBER(4) NOT NULL
    , ename VARCHAR2(20) NOT NULL
    , deptno NUMBER(2)
    , email VARCHAR2(150)
    , kor NUMBER(3)
    , city VARCHAR2(20)
    
    , CONSTRAINT pk_tblconstraint1_empno PRIMARY KEY(empno, ename) -- , ename, .., .. : 복합키
    , CONSTRAINT fk_tblconstraint1_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
    , CONSTRAINT uk_tblconstraint1_email UNIQUE(email)
    , CONSTRAINT ck_tblconstraint1_kor CHECK(kor BETWEEN 0 AND 100) -- 안고쳐도됨.
    , CONSTRAINT ck_tblconstraint1_city CHECK(city IN ('서울','부산','대구')) -- 안고쳐도됨.
);
-- 1) PK 제약조건 제거
ALTER TABLE tbl_constraint1
-- DROP PRIMARY KEY
DROP CONSTRAINT pk_tblconstraint1_empno;
-- 2) CK 제거
ALTER TABLE tbl_constraint1
-- DROP CHECK(kor); : 불가능. 형식이 없다.
DROP CONSTRAINT ck_tblconstraint1_kor;
-- 3) UK 제거
ALTER TABLE tbl_constraint1
DROP UNIQUE(email);
-- DROP CONSTRAINT uk_tblconstraint1_email;
--
SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_C%';

-- ck_tblconstraint1_city 체크제약조건 비활성화. disable 비활성화 / enable 활성화
ALTER TABLE tbl_constraint1
DISABLE CONSTRAINT ck_tblconstraint1_city [CASCADE]; -- 비활성화 CASCADE : 있을 시 참조하는 모든 것을 비활성화.

ALTER TABLE tbl_constraint1
ENABLE CONSTRAINT ck_tblconstraint1_city; -- 활성화

-- 2. 테이블을 수정할 때 제약조건을 생성(추가), 삭제.
CREATE TABLE tbl_constraint3
(
    empno NUMBER(4)
    , ename VARCHAR2(20)
    , deptno NUMBER(2)
);
--

--
1) empno 컬럼에 PK 제약조건 추가.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT pk_tblconstraint3_empno PRIMARY KEY(empno);
2) deptno 컬럼에 FK 제약조건 추가.
ALTER TABLE tbl_constraint3
ADD CONSTRAINT fk_tblconstraint3_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);

DROP TABLE tbl_constraint3;

DELETE FROM dept
WHERE deptno = 10;

-- emp -> tbl_emp 생성
-- dept -> tbl_dept 생성
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
-- 제약조건 추가.
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
DELETE FROM tbl_dept -- ON DELETE CASCADE : dept 30 삭제, emp 30 삭제 : 부모 자식 다 삭제.
WHERE deptno = 30;
--
ROLLBACK;

-- 무결성 Data Integrity 확인



-- 조인
CREATE TABLE book(
       b_id     VARCHAR2(10)    NOT NULL PRIMARY KEY   -- 책ID
      ,title      VARCHAR2(100) NOT NULL  -- 책 제목
      ,c_name  VARCHAR2(100)    NOT NULL     -- c 이름
     -- ,  price  NUMBER(7) NOT NULL
 );
-- Table BOOK이(가) 생성되었습니다.
INSERT INTO book (b_id, title, c_name) VALUES ('a-1', '데이터베이스', '서울');
INSERT INTO book (b_id, title, c_name) VALUES ('a-2', '데이터베이스', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('b-1', '운영체제', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('b-2', '운영체제', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('c-1', '워드', '경기');
INSERT INTO book (b_id, title, c_name) VALUES ('d-1', '엑셀', '대구');
INSERT INTO book (b_id, title, c_name) VALUES ('e-1', '파워포인트', '부산');
INSERT INTO book (b_id, title, c_name) VALUES ('f-1', '엑세스', '인천');
INSERT INTO book (b_id, title, c_name) VALUES ('f-2', '엑세스', '서울');

COMMIT;

SELECT *
FROM book;

-- 단가테이블( 책의 가격 )
CREATE TABLE danga(
       b_id  VARCHAR2(10)  NOT NULL  -- PK , FK   (식별관계 ***) : 부모테이블의 PK가 자식테이블에 PK인 경우.
      ,price  NUMBER(7) NOT NULL    -- 책 가격
      
      ,CONSTRAINT PK_dangga_id PRIMARY KEY(b_id)
      ,CONSTRAINT FK_dangga_id FOREIGN KEY (b_id)
              REFERENCES book(b_id)
              ON DELETE CASCADE
);
-- Table DANGA이(가) 생성되었습니다.
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

-- 책을 지은 저자테이블
 CREATE TABLE au_book(
       id   number(5)  NOT NULL PRIMARY KEY
      ,b_id VARCHAR2(10)  NOT NULL  CONSTRAINT FK_AUBOOK_BID
            REFERENCES book(b_id) ON DELETE CASCADE
      ,name VARCHAR2(20)  NOT NULL
);

INSERT INTO au_book (id, b_id, name) VALUES (1, 'a-1', '저팔개');
INSERT INTO au_book (id, b_id, name) VALUES (2, 'b-1', '손오공');
INSERT INTO au_book (id, b_id, name) VALUES (3, 'a-1', '사오정');
INSERT INTO au_book (id, b_id, name) VALUES (4, 'b-1', '김유신');
INSERT INTO au_book (id, b_id, name) VALUES (5, 'c-1', '유관순');
INSERT INTO au_book (id, b_id, name) VALUES (6, 'd-1', '김하늘');
INSERT INTO au_book (id, b_id, name) VALUES (7, 'a-1', '심심해');
INSERT INTO au_book (id, b_id, name) VALUES (8, 'd-1', '허첨');
INSERT INTO au_book (id, b_id, name) VALUES (9, 'e-1', '이한나');
INSERT INTO au_book (id, b_id, name) VALUES (10, 'f-1', '정말자');
INSERT INTO au_book (id, b_id, name) VALUES (11, 'f-2', '이영애');

COMMIT;

SELECT * 
FROM au_book;

-- 고객            
-- 판매            출판사 <-> 서점
 CREATE TABLE gogaek(
      g_id       NUMBER(5) NOT NULL PRIMARY KEY 
      ,g_name   VARCHAR2(20) NOT NULL
      ,g_tel      VARCHAR2(20)
);

 INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (1, '우리서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (2, '도시서점', '111-1111');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (3, '지구서점', '333-3333');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (4, '서울서점', '444-4444');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (5, '수도서점', '555-5555');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (6, '강남서점', '666-6666');
INSERT INTO gogaek (g_id, g_name, g_tel) VALUES (7, '강북서점', '777-7777');

COMMIT;

SELECT *
FROM gogaek;

-- 판매
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
-- EQUI JOIN : = 조인조건절 사용, NATURAL JOIN(오라클) 동일, PK = FK
-- [문제] 책ID, 책제목, 출판사(c_name), 단가  컬럼 출력..
-- book : b_id(P), title, c_name
-- danga : b_id(P,F), price -- 식별관계
-- ㄱ.
SELECT b.b_id, title, c_name, price
FROM book b, danga d
WHERE b.b_id = d.b_id; -- WHERE 조건절, 조인조건절 '=' 연산자
-- ㄴ. JOIN ON 구문
SELECT b.b_id, title, c_name, price
FROM book b INNER JOIN danga d ON b.b_id = d.b_id;
-- ㄷ. USING 절 사용(객체명. 별칭명.으로 사용 안함.).
SELECT b_id, title, c_name, price
FROM book JOIN danga USING(b_id); -- USING 문을 사용한 조인.
-- ㄹ. NATURAL JOIN
SELECT b_id, title, c_name, price
FROM book NATURAL JOIN danga;

-- [문제]  책ID, 책제목, 판매수량, 단가, 서점명, 판매금액(=판매수량*단가) 출력
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name, p.p_su * d.price "판매금액"
FROM book b, danga d, panmai p, gogaek g
WHERE b.b_id = d.b_id AND b.b_id = p.b_id AND p.g_id = g.g_id;
--
SELECT b.b_id, b.title, p.p_su, d.price, g.g_name, p.p_su * d.price "판매금액"
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;
-- USING 절 사용.
SELECT b_id, title, p_su, price, g_name, p_su * price "판매금액"
FROM book JOIN panmai USING(b_id)
            JOIN gogaek USING(g_id)
            JOIN danga USING(b_id);
-- NON-EQUI JOIN : 조인조건절 '=' 사용하지 않음.
SELECT empno, ename, sal, losal || '~' || hisal, grade
FROM emp e JOIN salgrade s ON e.sal BETWEEN s.losal AND s.hisal;
-- OUTER JOIN : JOIN 조건을 만족하지 않는 행을 보기 위한 추가적인 join의 형태이다.
-- (+) 연산자 사용
-- (LEFT, RIGHT, FULL) OUTER 조인
KING 사원의 부서번호를 확인하고 -> NULL로 업데이트
SELECT *
FROM emp
WHERE ename = UPPER('king');

UPDATE emp
SET deptno = NULL
WHERE ename = UPPER('king');
COMMIT;

-- [모든 emp 사원정보를 출력하되 부서번호 대신에 부서명으로 출력]
-- 조인 모든 emp 테이블의 사원 정보를 dept 테이블과 조인해서
-- dname, ename, hiredate 컬럼 출력
SELECT dname, ename, hiredate
FROM emp e LEFT OUTER JOIN dept d ON d.deptno = e.deptno;
--
SELECT dname, ename, hiredate -- 위와 동일.
FROM emp e, dept d 
WHERE d.deptno(+) = e.deptno;
-- 각 부서의 사원 수 조회.
-- 부서명, 사원수
SELECT d.dname, COUNT(e.empno)
FROM emp e RIGHT OUTER JOIN dept d ON d.deptno = e.deptno
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;
-- 위와 동일
SELECT d.dname, COUNT(e.empno)
FROM emp e, dept d
WHERE d.deptno = e.deptno(+)
GROUP BY d.deptno, dname
ORDER BY d.deptno, dname;
--
SELECT d.dname, dname, ename, hiredate -- 양쪽 다 나오길 원하면 FULL OUTER JOIN
FROM emp e FULL OUTER JOIN dept d ON d.deptno = e.deptno;

-- SELF JOIN
사원번호, 사원명, 입사일자, 직속상사의 이름
SELECT e.empno, e.ename, e.hiredate, t.ename "직속상사"
FROM emp e JOIN emp t ON e.mgr = t.empno;

-- CROSS JOIN : 데카르트 곱
--      12 * 4 = 48
SELECT e.*, d.*
FROM emp e, dept d;
--
-- 문제) 출판된 책들이 각각 총 몇권이 판매되었는지 조회     
--      (    책ID, 책제목, 총판매권수, 단가 컬럼 출력   )
SELECT b.b_id, b.title, SUM(p.p_su) "총판매권수", d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price;

-- 문제 판매권수가 가장 많은 책 정보 조회.
SELECT t.*
FROM
(
SELECT b.b_id, b.title, SUM(p.p_su) "총판매권수", d.price
    , RANK() OVER(ORDER BY SUM(p.p_su) DESC) r
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price
) t
WHERE r = 1;
-- TOP-N 방식
SELECT ROWNUM, t.*
FROM
(
SELECT b.b_id, b.title, SUM(p.p_su) 총판매권수, d.price
FROM book b, danga d, panmai p
WHERE b.b_id = d.b_id AND b.b_id = p.b_id
GROUP BY b.b_id, b.title, d.price
ORDER BY 총판매권수 DESC
) t
WHERE ROWNUM = 1;
-- 올해 판매권수가 가장 많은 책 정보 조회.
-- 책id 제목 수량
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
-- 문제 book 테이블에서 판매가 된 적이 없는 책의 정보 조회.
-- 책아이디 제목 가격
SELECT b.b_id, title, price
FROM book b LEFT OUTER JOIN panmai p ON b.b_id = p.b_id JOIN danga d ON b.b_id = d.b_id
WHERE p_su IS NULL;
-- MINUS 전체 책 - 판매된적 책
-- ANTI JOIN (NOT IN)
SELECT b.b_id, title, price
FROM book b JOIN danga d ON b.b_id = d.b_id
WHERE b.b_id NOT IN (
SELECT DISTINCT(b_id)
FROM panmai
);
-- 문제 판매가 된적 있는 정보
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

--  문제) 고객별 판매 금액 출력 (고객코드, 고객명, 판매금액)
SELECT g.g_id, g.g_name, SUM(p.p_su * d.price) "총판매금액"
FROM book b, panmai p, gogaek g, danga d
WHERE b.b_id = p.b_id AND p.g_id = g.g_id AND b.b_id = d.b_id
GROUP BY g.g_id, g.g_name;
--
SELECT g.g_id, g_name, SUM(p_su*price) "총판매금액" 
FROM panmai p JOIN danga d ON p.b_id = d.b_id
    JOIN gogaek g ON p.g_id = g.g_id
GROUP BY g.g_id, g_name;
-- 문제 년도, 월별 판매 현황 구하기
SELECT TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM'), SUM(p_su) "판매수량"
FROM panmai
GROUP BY TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM')
ORDER BY TO_CHAR(p_date,'YYYY'), TO_CHAR(p_date,'MM');
-- 문제 서점별 년도별 판매 현황 구하기
SELECT TO_CHAR(p_date,'YY') 년도별, g_name 서점별, SUM(p_su) 판매수량
FROM panmai p, gogaek g
WHERE p.g_id = g.g_id
GROUP BY TO_CHAR(p_date,'YY'), g_name
ORDER BY TO_CHAR(p_date,'YY'), g_name;
-- 책의 총판매금액이 15000원 이상 팔린 책의 정보를 조회
--      ( 책ID, 제목, 단가, 총판매권수, 총판매금액 )
SELECT b.b_id, b.title, price
    , SUM(p_su) 총판매권수, SUM(p_su * price) 총판매금액
FROM book b, panmai p, danga d
WHERE b.b_id = p.b_id AND b.b_id = d.b_id
GROUP BY b.b_id, b.title, price
HAVING SUM(p_su * price) >= 15000;





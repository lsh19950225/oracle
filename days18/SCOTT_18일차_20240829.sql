-- SCOTT
-- 암호화
-- https://technet.tmaxsoft.com/upload/download/online/tibero/pver-20150504-000001/tibero_pkg/chap_dbms_obfuscation.html
-- [DBMS_OBFUSCATION_TOOLKIT 암호화 패키지]
CREATE TABLE tbl_member
(
    id VARCHAR2(20) PRIMARY KEY
    , passwd VARCHAR2(20)
);

INSERT INTO tbl_member ( id, passwd ) VALUES (  'hong',  cryptit.encrypt( '1234', 'test') ); -- cryptit : 만들 패키지
INSERT INTO tbl_member ( id, passwd ) VALUES (  'kenik',  cryptit.encrypt( 'kenik', 'test') );

SELECT *
FROM tbl_member;
--
-- 선언
-- 패키지 명세서 부분
CREATE OR REPLACE PACKAGE CryptIT
IS
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2;
END CryptIT;

-- 패키지 몸체
CREATE OR REPLACE PACKAGE BODY CryptIT
IS
   s VARCHAR2(2000);
    
   FUNCTION encrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
            p NUMBER := ((FLOOR(LENGTH(str)/8+0.9))*8);
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESEncrypt(
               input_string => RPAD(str,p)
                ,key_string => RPAD(HASH,8,'#')
                ,encrypted_string => s
            );
            RETURN s;
        END;
   FUNCTION decrypt(str VARCHAR2, HASH VARCHAR2)
       RETURN VARCHAR2
        IS
        BEGIN
            DBMS_OBFUSCATION_TOOLKIT.DESDecrypt(
               input_string => str
                ,key_string => RPAD(HASH,8,'#')
                ,decrypted_string => s
            );
            RETURN TRIM(s);
        END;    

END CryptIT;
--
ROLLBACK;
--------------------------------------------------------------------------------
DROP TABLE o_address;
DROP TABLE o_ask;
DROP TABLE o_auth;
DROP TABLE o_cart;
DROP TABLE o_cartlist;
DROP TABLE o_category;
DROP TABLE o_color;
DROP TABLE o_comment;
DROP TABLE o_coupon;
DROP TABLE o_cpnrange;
DROP TABLE o_design;
DROP TABLE o_event;
DROP TABLE o_faq;
DROP TABLE o_faqcategory;
DROP TABLE o_issuedcoupon;
DROP TABLE o_lineup;
DROP TABLE o_membership;
DROP TABLE o_notice;
DROP TABLE o_order;
DROP TABLE o_orderstate;
DROP TABLE o_ordproduct;
DROP TABLE o_payment;
DROP TABLE o_pdtcolor;
DROP TABLE o_pdtdesign;
DROP TABLE o_pdtlineup;
DROP TABLE o_pdtoption;
DROP TABLE o_product;
DROP TABLE o_review;
DROP TABLE o_subcategory;
DROP TABLE o_user;
DROP TABLE o_revurl;
--
SELECT *
FROM o_user;
--
SELECT *
FROM o_order;
--
SELECT *
FROM o_ordproduct;
--
SELECT *
FROM o_review;
--
SELECT *
FROM o_product;
--
SELECT *
FROM o_comment;
--
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000001', 1001);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000002', 1002);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000003', 1003);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000004', 1004);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000005', 1005);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000006', 1006);
--
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000001', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000002', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000003', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000004', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000005', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000006', 1, 'Y');
--
DROP SEQUENCE seq_o_review;
DROP SEQUENCE seq_o_comment;
--
-- 리뷰 시퀀스 생성.
CREATE SEQUENCE seq_o_review
START WITH 1
NOCACHE;

-- 리뷰 INSERT 저장프로시저 생성.
CREATE OR REPLACE PROCEDURE ins_o_review
(
    ppdt_id o_review.pdt_id%TYPE
    , pord_id o_review.ord_id%TYPE
    , puser_id o_review.user_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_writedate o_review.rev_writedate%TYPE
    , prev_rating o_review.rev_rating%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , prev_age_group o_review.rev_age_group%TYPE
    , prev_option o_review.rev_option%TYPE
)
IS
BEGIN
    INSERT INTO o_review
    (rev_id, pdt_id, ord_id, user_id, rev_content, rev_writedate, rev_rating
    , rev_isphoto, rev_age_group, rev_option)
    VALUES
    (seq_o_review.NEXTVAL, ppdt_id, pord_id, puser_id, prev_content, prev_writedate
    , prev_rating, prev_isphoto, prev_age_group, prev_option);
-- COMMIT;
-- EXCEPTION
END;
--
EXEC ins_o_review (1, '20240828-000001', 1001, '레드가 어울리는 계절이 왔어요. 레드 풀컬러에 작은 꽃송이가 올라간 핑크가 더해져 어떤 손도 화사하게 만들어 줍니다. 배치에 따라 다양한 무드로 표현할 수 있는 티니를 만나보세요!', SYSDATE, 5, 'Y', 'Y', '20대', '롱');

EXEC ins_o_review (1, '20240828-000002', 1002, '빨간색이 의외로 잘어울려서 구매했습니다.', SYSDATE, 5, 'Y', 'N', '20대', '롱');

EXEC ins_o_review (1, '20240828-000003', 1003, '가을 신상이 나왔길래 몇개 구매했는데 정말 네일 맛집답게 색상이 가을가을하니 진짜 예쁘네요. 여러 디자인중 티니 네일 제일 눈에 들어와 맨먼저 붙였어요.', SYSDATE, 3, 'N', 'N', '30대', '숏');

EXEC ins_o_review (1, '20240828-000004', 1004, '너무 좋아요.', SYSDATE, 4, 'N', 'N', '10대', '미디엄');

EXEC ins_o_review (1, '20240828-000006', 1006, 'test', SYSDATE, 1, 'N', '40대 이상', '미디엄');
--
--
select *
from o_review;
-- 리뷰 UPDATE 저장프로시저 : 수정
CREATE OR REPLACE PROCEDURE update_o_review
(
    prev_id o_review.rev_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_rating o_review.rev_rating%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , prev_isrecord o_review.rev_isrecord%TYPE
    , prev_age_group o_review.rev_age_group%TYPE
    , prev_option o_review.rev_option%TYPE
)
IS
BEGIN
    UPDATE o_review
    SET rev_content = prev_content, rev_rating = prev_rating
    , rev_isphoto = prev_isphoto, rev_isrecord = prev_isrecord
    , rev_age_group = prev_age_group, rev_option = prev_option
    WHERE rev_id = prev_id;
-- COMMIT;
-- EXCEPTION
END;
--
EXEC update_o_review (1, '블루가 어울리는 계절이 왔어요. 레드 풀컬러에 작은 꽃송이가 올라간 핑크가 더해져 어떤 손도 화사하게 만들어 줍니다. 배치에 따라 다양한 무드로 표현할 수 있는 티니를 만나보세요!', 5, 'Y', 'Y', '20대', '롱');


--
create or replace procedure up_rev_good_count
(
prev_id o_review.rev_id%type
, puser_id o_review.user_id%type
, prev_good_count o_review.rev_good_count%type
)
Is
begin
update o_review
set rev_good_count = prev_good_count + 1
where rev_id = prev_id AND user_id = puser_id;
-- commit;
-- exception
end;
--
exec up_rev_good_count (1, 1002, 1);
--
SELECT *
FROM o_review;
--
--
--
create or replace procedure down_rev_good_count
(
prev_id o_review.rev_id%type
)
Is
vrev_good_count o_review.rev_good_count%type;
begin
select rev_good_count into vrev_good_count
from o_review
where rev_id = prev_id;

update o_review
set rev_good_count = rev_good_count - 1
where rev_id = prev_id;
-- commit;
-- exception
end;
--
exec down_rev_good_count (1);
--
SELECT *
FROM o_review;
--
--
create or replace procedure up_rev_bad_count
(
prev_id o_review.rev_id%type
)
Is
vrev_bad_count o_review.rev_bad_count%type;
begin
select rev_bad_count into vrev_bad_count
from o_review
where rev_id = prev_id;

update o_review
set rev_bad_count = rev_bad_count + 1
where rev_id = prev_id;
commit;
-- exception
end;
--
exec up_rev_bad_count (1);
--
SELECT *
FROM o_review;
--
--
--
create or replace procedure down_rev_bad_count
(
prev_id o_review.rev_id%type
)
Is
vrev_bad_count o_review.rev_bad_count%type;
begin
select rev_bad_count into vrev_bad_count
from o_review
where rev_id = prev_id;

update o_review
set rev_bad_count = rev_bad_count - 1
where rev_id = prev_id;
-- commit;
-- exception
end;
--
exec down_rev_bad_count (1);
--
SELECT *
FROM o_review;
--
--
--
--
UPDATE o_user
SET user_name = '양'
WHERE user_id = 1003;
--
UPDATE o_user
SET user_name = '민식'
WHERE user_id = 1004;
--
UPDATE o_user
SET user_name = '윤발'
WHERE user_id = 1005;
--
SELECT *
FROM o_user;
--
--
SELECT *
FROM o_review;
--
--
-- 오호라 추천 리뷰 선택 UPDATE 저장 프로시저
CREATE OR REPLACE PROCEDURE update_rev_isrecommend
(
    prev_id o_review.rev_id%TYPE
)
IS
    vrev_isrecommend o_review.rev_isrecommend%TYPE;
BEGIN
    SELECT rev_isrecommend INTO vrev_isrecommend
    FROM o_review
    WHERE rev_id = prev_id;
    
    IF vrev_isrecommend = 'N' THEN
    UPDATE o_review
    SET rev_isrecommend = 'Y'
    WHERE rev_id = prev_id;
    ELSE
    UPDATE o_review
    SET rev_isrecommend = 'N'
    WHERE rev_id = prev_id;
    END IF;
-- COMMIT;
-- EXCEPTION
END;
--
EXEC update_rev_isrecommend (1);
--
SELECT *
FROM o_review;
--
--
--
--
WITH temp AS
    (
    SELECT LEVEL 별점
    FROM dual
    CONNECT BY LEVEL <= 5
    )
SELECT temp.별점, COUNT(a.rev_rating)
    , ROUND(RATIO_TO_REPORT(COUNT(a.rev_rating)) OVER(), 2) * 100 || '%'  AS "비율"
    , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') || 
    LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') AS "그래프"
FROM o_review a RIGHT OUTER JOIN temp ON temp.별점 = a.rev_rating
GROUP BY a.rev_rating, temp.별점
ORDER BY temp.별점 DESC;
--
--
SELECT AVG(rev_rating) "별점평균"
FROM o_review;
--
SELECT *
FROM o_review;
--
--
CREATE OR REPLACE PROCEDURE select_o_review
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
    SELECT CASE WHEN rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                ELSE ''
                END AS aa
        , rev_rating
        , rev_content
        , rev_isphoto
        , rev_isrecord
        , CASE WHEN a.user_id = 1001 THEN '이 리뷰는 오호라 관리자가 등록한 리뷰입니다.'
                ELSE ''
                END AS bb
        , rev_good_count
        , rev_bad_count
        , rev_comment_count
        ,
        CASE
             -- WHEN a.user_id = 1001 THEN '오호라 크루님의 리뷰입니다.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'님의 리뷰입니다.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'님의 리뷰입니다.'
        END AS cc
    FROM o_review a, o_user b
    WHERE a.user_id = b.user_id
    AND a.pdt_id = ppdt_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_rating);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_content);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_isphoto);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_isrecord);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
    END LOOP;
    -- COMMIT;
-- EXCEPTION
END;
--
EXEC SELECT_O_REVIEW(1);
--
--
CREATE OR REPLACE PROCEDURE select_rev_rating
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
    vavg_rev_rating NUMBER(2,1);
    vavg_percent NUMBER(3);
--    vstarpoint NUMBER(1);
--    vstargraph VARCHAR2(500);
BEGIN
    SELECT AVG(rev_rating) "별점평균"
        , ROUND((AVG(rev_rating) / 5) * 100, 2) avg_percent INTO vavg_rev_rating, vavg_percent
    FROM o_review;
    
    DBMS_OUTPUT.PUT_LINE('★' || vavg_rev_rating);
    DBMS_OUTPUT.PUT_LINE(vavg_percent || '%의 구매자가 이 상품을 좋아합니다.');
    
    FOR vo_review IN
    (
    WITH temp AS
    (
    SELECT LEVEL 별점
    FROM dual
    CONNECT BY LEVEL <= 5
    )
    SELECT
        CASE 
        WHEN temp.별점 = 5 THEN '아주 좋아요  '
        WHEN temp.별점 = 4 THEN '맘에 들어요  '
        WHEN temp.별점 = 3 THEN '보통이에요   '
        WHEN temp.별점 = 2 THEN '그냥 그래요  '
        WHEN temp.별점 = 1 THEN '별로예요     '
        END starpoint
        -- , COUNT(a.rev_rating)
        -- , ROUND(RATIO_TO_REPORT(COUNT(a.rev_rating)) OVER(), 2) * 100 || '%'  AS "비율"
        , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') || 
        LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') stargraph
        -- INTO vstarpoint, vstargraph
    FROM o_review a RIGHT OUTER JOIN temp ON temp.별점 = a.rev_rating
    GROUP BY a.rev_rating, temp.별점
    ORDER BY temp.별점 DESC
    )
    LOOP
        DBMS_OUTPUT.PUT(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.stargraph);
    END LOOP;
    -- COMMIT;
-- EXCEPTION
END;

EXEC select_rev_rating (1);

SELECT AVG(rev_rating) "별점평균" INTO vavg_rev_rating
    FROM o_review;
    
    
    WITH temp AS
    (
    SELECT LEVEL 별점
    FROM dual
    CONNECT BY LEVEL <= 5
    )
SELECT temp.별점, COUNT(a.rev_rating)
    , ROUND(RATIO_TO_REPORT(COUNT(a.rev_rating)) OVER(), 2) * 100 || '%'  AS "비율"
    , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') || 
    LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') AS "그래프"
FROM o_review a RIGHT OUTER JOIN temp ON temp.별점 = a.rev_rating
GROUP BY a.rev_rating, temp.별점
ORDER BY temp.별점 DESC;

--
SELECT *
FROM o_review;
포토 리뷰 아이디 1,2,5
영상 리뷰 아이디 1,5
--
--
WITH temp AS
    (
    SELECT LEVEL 별점
    FROM dual
    CONNECT BY LEVEL <= 5
    )
SELECT -- temp.별점 , 
    COUNT(a.rev_rating)
    -- , ROUND(RATIO_TO_REPORT(COUNT(a.rev_rating)) OVER(), 2) * 100 || '%'  AS "비율"
    , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') || 
    LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') AS "그래프"
    INTO vstarpoint, vstargraph
FROM o_review a RIGHT OUTER JOIN temp ON temp.별점 = a.rev_rating
GROUP BY a.rev_rating, temp.별점
ORDER BY temp.별점 DESC;
    
    
    DBMS_OUTPUT.PUT_LINE('★' || vavg_rev_rating);
    DBMS_OUTPUT.PUT_LINE(vavg_percent || '%의 구매자가 이 상품을 좋아합니다.');
    DBMS_OUTPUT.PUT_LINE(vstarpoint);
    DBMS_OUTPUT.PUT_LINE(vstargraph);
--
--
--
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (1, 1, 'path1/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (2, 1, 'path2/(영상)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (3, 1, 'path3/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (4, 2, 'path4/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (5, 3, 'path5/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (6, 4, 'path6/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (7, 5, 'path7/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, RURL_URL) VALUES (8, 5, 'path8/(사진)');
--
SELECT *
FROM o_revurl;
--
--
CREATE OR REPLACE PROCEDURE select_photorecord
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
    vcount NUMBER;
BEGIN
    SELECT COUNT(rurl_id) INTO vcount
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id AND pdt_id = ppdt_id;
    DBMS_OUTPUT.PUT_LINE('포토'||'&'||'동영상'||'('||vcount||')');
    
    FOR vo_review IN
    (
    SELECT rurl_url
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id
    ORDER BY a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_url);
    END LOOP;
    -- COMMIT;
-- EXCEPTION
END;

EXEC select_photorecord (1);
--
--
--
-- 리뷰 SELECT 저장 프로시저
CREATE OR REPLACE PROCEDURE select_o_review
(
    ppdt_id o_review.pdt_id%TYPE
    prev_isphoto o_review.rev_isphoto%TYPE
    prev_isrecord o_review.rev_isrecord%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
    SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '한달 사용 리뷰'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '★★★★★ '||'아주 좋아요'
                WHEN a.rev_rating = 4 THEN '★★★★ '||'맘에 들어요'
                WHEN a.rev_rating = 3 THEN '★★★ '||'보통이에요'
                WHEN a.rev_rating = 2 THEN '★★ '||'그냥 그래요'
                ELSE '★ '||'별로예요'
            END starpoint
            , rev_content content
            , CASE WHEN a.user_id = 1001 THEN '이 리뷰는 오호라 관리자가 등록한 리뷰입니다.'
                ELSE ''
                END AS manager
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            , CASE
             WHEN c.mem_name = 'crew' THEN N'오호라 크루님의 리뷰입니다.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'님의 리뷰입니다.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'님의 리뷰입니다.'
                END AS name
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id AND pdt_id = ppdt_id
    ORDER BY a.rev_isphoto DESC, a.rev_isrecord DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('도움돼요 '||vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('도움안돼요 '||vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('댓글 '||vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    -- COMMIT;
-- EXCEPTION
END;
--
EXEC select_o_review (1);
--
UPDATE o_review
SET rev_writedate = TO_DATE('2024-06-26', 'YYYY-MM-DD')
WHERE rev_id = 3;
--
UPDATE o_review
SET rev_isrecommend = 'Y'
WHERE rev_id = 4;
--
SELECT *
FROM o_review;
--
--
--
SELECT *
FROM o_review;
--
--
CREATE OR REPLACE PROCEDURE update_rev_isrecommend
(
    prev_isphoto o_review.rev_isphoto%TYPE
    , prev_isrecord o_review.rev_isrecord%TYPE
)
IS
BEGIN
    IF prev_isphoto = 'N' THEN
    UPDATE o_review
    SET rev_isphoto = 'Y'
    WHERE rev_id = prev_id;
    ELSE
    UPDATE o_review
    SET rev_isrecommend = 'N'
    WHERE rev_id = prev_id;
    END IF;
-- COMMIT;
-- EXCEPTION
END;
--
--
CREATE OR REPLACE PROCEDURE update_rev_isrecommend
(
    prev_id o_review.rev_id%TYPE
    , puser_id o_review.user_id%TYPE
)
IS
    vrev_isrecommend o_review.rev_isrecommend%TYPE;
BEGIN
    SELECT rev_isrecommend INTO vrev_isrecommend
    FROM o_review
    WHERE rev_id = prev_id AND user_id = puser_id;
    
    IF vrev_isrecommend = 'N' AND puser_id = 1001 THEN
    UPDATE o_review
    SET rev_isrecommend = 'Y'
    WHERE rev_id = prev_id AND user_id = puser_id;
    
    ELSIF vrev_isrecommend = 'Y' AND puser_id = 1001 THEN
    UPDATE o_review
    SET rev_isrecommend = 'N'
    WHERE rev_id = prev_id AND user_id = puser_id;
    
    END IF;
-- COMMIT;
-- EXCEPTION
END;
--
EXEC update_rev_isrecommend (1, 1001);
--
SELECT *
FROM o_review;
--
--
CREATE OR REPLACE PROCEDURE update_o_review
(   
    puser_id o_review.user_id%TYPE
    , prev_id o_review.rev_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_rating o_review.rev_rating%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , prev_isrecord o_review.rev_isrecord%TYPE
    , prev_age_group o_review.rev_age_group%TYPE
    , prev_option o_review.rev_option%TYPE
)
IS
BEGIN
    UPDATE o_review
    SET rev_content = prev_content, rev_rating = prev_rating
    , rev_isphoto = prev_isphoto, rev_isrecord = prev_isrecord
    , rev_age_group = prev_age_group, rev_option = prev_option
    WHERE rev_id = prev_id AND user_id = puser_id;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
END;
--
EXEC update_o_review (1001, 1, '레드가 어울리는 계절이 왔어요. 레드 풀컬러에 작은 꽃송이가 올라간 핑크가 더해져 어떤 손도 화사하게 만들어 줍니다. 배치에 따라 다양한 무드로 표현할 수 있는 티니를 만나보세요!', 5, 'Y', 'Y', '20대', '롱');
--
SELECT *
FROM o_review;
--
create or replace procedure up_rev_good_count
(
puser_id o_review.user_id%type
, prev_id o_review.rev_id%type
, prev_good_count o_review.rev_good_count%type
)
Is
vrev_good_count o_review.rev_good_count%type;
begin
select rev_good_count into vrev_good_count
from o_review
where rev_id = prev_id;

update o_review
set rev_good_count = prev_good_count + 1
where rev_id = prev_id AND user_id = puser_id
AND rev_good_count = prev_good_count;
-- commit;
-- exception
end;
--
exec up_rev_good_count (1001, 1, 1);
--
SELECT *
FROM o_review;
--
--
--
create or replace procedure up_rev_bad_count
(
puser_id o_review.user_id%type
, prev_id o_review.rev_id%type
)
Is
vrev_bad_count o_review.rev_bad_count%type;
begin
select rev_bad_count into vrev_bad_count
from o_review
where rev_id = prev_id;

update o_review
set rev_bad_count = rev_bad_count + 1
where rev_id = prev_id AND user_id = puser_id;
commit;
-- exception
end;
--
exec up_rev_bad_count (1001, 1);
--
SELECT *
FROM o_review;
--
--
--
CREATE OR REPLACE PROCEDURE select_photorecord
(
)
IS
    vcount NUMBER;
BEGIN
    

    SELECT COUNT(rurl_url) INTO vcount
    FROM o_revurl;
    DBMS_OUTPUT.PUT_LINE('포토'||'&'||'동영상'||'('||vcount||')');
    
    IF THEN
    FOR vo_revurl IN
    (
    SELECT rurl_url url
    FROM o_revurl a, o_review b
    WHERE a.rev_id = b.rev_id AND pdt_id = ppdt_id
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_revurl.url);
    END LOOP;
-- EXCEPTION
END;

EXEC select_photorecord(2);

--
--
CREATE OR REPLACE PROCEDURE select_o_review
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
    SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '한달 사용 리뷰'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '★★★★★ '||'아주 좋아요'
                WHEN a.rev_rating = 4 THEN '★★★★ '||'맘에 들어요'
                WHEN a.rev_rating = 3 THEN '★★★ '||'보통이에요'
                WHEN a.rev_rating = 2 THEN '★★ '||'그냥 그래요'
                ELSE '★ '||'별로예요'
            END starpoint
            , rev_content content
            , CASE WHEN a.user_id = 1001 THEN '이 리뷰는 오호라 관리자가 등록한 리뷰입니다.'
                ELSE ''
                END AS manager
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            , CASE
             WHEN c.mem_name = 'crew' THEN N'오호라 크루님의 리뷰입니다.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'님의 리뷰입니다.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'님의 리뷰입니다.'
                END AS name
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id AND pdt_id = ppdt_id
    ORDER BY a.rev_isrecommend DESC, rev_good_count DESC, a.rev_writedate DESC
        , rev_good_count DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('도움돼요 '||vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('도움안돼요 '||vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('댓글 '||vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
EXEC select_o_review (1);




CREATE OR REPLACE PROCEDURE select_o_review2
(
    ppdt_id o_review.pdt_id%TYPE,
    puser_id o_review.user_id%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
        SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                    ELSE ''
                    END AS aa
               , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                    ELSE ''
                    END AS bb
               , CASE WHEN a.rev_writedate <= SYSDATE - INTERVAL '30' DAY THEN '한달 사용 리뷰'
                    ELSE ''
                    END AS cc
               , CASE 
                    WHEN a.rev_rating = 5 THEN '★★★★★ ' || '아주 좋아요'
                    WHEN a.rev_rating = 4 THEN '★★★★ ' || '맘에 들어요'
                    WHEN a.rev_rating = 3 THEN '★★★ ' || '보통이에요'
                    WHEN a.rev_rating = 2 THEN '★★ ' || '그냥 그래요'
                    ELSE '★ ' || '별로예요'
                END AS starpoint
               , a.rev_content AS content
               , CASE WHEN a.user_id = 1001 THEN '이 리뷰는 오호라 관리자가 등록한 리뷰입니다.'
                    ELSE ''
                    END AS manager
               , a.rev_good_count
               , a.rev_bad_count
               , a.rev_comment_count
               , CASE
                    WHEN c.mem_name = 'crew' THEN N'오호라 크루님의 리뷰입니다.'
                    WHEN LENGTH(b.user_name) = 1 THEN N'*' || '님의 리뷰입니다.'
                    ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**') || '님의 리뷰입니다.'
                END AS name
        FROM o_review a
        JOIN o_user b ON a.user_id = b.user_id
        JOIN o_membership c ON b.mem_id = c.mem_id
        WHERE a.pdt_id = ppdt_id AND a.user_id = puser_id
        ORDER BY a.rev_isrecommend DESC, a.rev_good_count DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('도움돼요 ' || vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('도움안돼요 ' || vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('댓글 ' || vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    COMMIT;
-- EXCEPTION
END;













CREATE OR REPLACE PROCEDURE select_photorecord
(
    ppdt_id o_review.pdt_id%TYPE
  
)
IS
    vcount NUMBER;
BEGIN
    SELECT COUNT(rurl_id) INTO vcount
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id AND pdt_id = ppdt_id;
    DBMS_OUTPUT.PUT_LINE('포토'||'&'||'동영상'||'('||vcount||')');
    
    FOR vo_review IN
    (
    SELECT rurl_url
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id
    ORDER BY a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_url);
    END LOOP;
    -- COMMIT;
-- EXCEPTION
select_o_review2(1,1001);
END;

EXEC select_photorecord (1);

EXEC select_photorecord (2);

EXEC select_photorecord (3);
--
--
SELECT *
FROM o_revurl;
--
ALTER TABLE o_revurl
ADD rurl_record VARCHAR2(100) NULL;
--
ALTER TABLE o_revurl
DROP COLUMN rurl_record;
--
ALTER TABLE o_revurl
ADD rurl_record VARCHAR2(100) NULL;
--
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (9, 1, 'path1/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_record) VALUES(10, 1, 'path2/(영상)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (11, 1, 'path3/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (12, 2, 'path4/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (13, 3, 'path5/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (14, 4, 'path6/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (15, 5, 'path7/(사진)');
INSERT INTO O_REVURL (RURL_ID, REV_ID, rurl_photo) VALUES (16, 5, 'path8/(사진)');
--
SELECT *
FROM o_review;
--
ALTER TABLE o_review
DROP COLUMN rev_isrecord;
--
create or replace procedure select_isurl
(
    ppdt_id o_review.pdt_id%type
)
is
begin
    FOR vo_review IN
    (
    SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '한달 사용 리뷰'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '★★★★★ '||'아주 좋아요'
                WHEN a.rev_rating = 4 THEN '★★★★ '||'맘에 들어요'
                WHEN a.rev_rating = 3 THEN '★★★ '||'보통이에요'
                WHEN a.rev_rating = 2 THEN '★★ '||'그냥 그래요'
                ELSE '★ '||'별로예요'
            END starpoint
            , rev_content content
            , CASE WHEN a.user_id = 1001 THEN '이 리뷰는 오호라 관리자가 등록한 리뷰입니다.'
                ELSE ''
                END AS manager
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            , CASE
             WHEN c.mem_name = 'crew' THEN N'오호라 크루님의 리뷰입니다.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'님의 리뷰입니다.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'님의 리뷰입니다.'
                END AS name
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id AND pdt_id = ppdt_id
    ORDER BY a.rev_isphoto DESC, a.rev_isrecommend DESC, rev_good_count DESC, a.rev_writedate DESC
        , rev_good_count DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('도움돼요 '||vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('도움안돼요 '||vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('댓글 '||vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    COMMIT;
exception
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다.' || SQLERRM);
        RAISE;
end;
--
exec select_isurl (1);
--
select *
from o_review;
--
--
-- 리뷰수 증가 트리거 생성
CREATE OR REPLACE TRIGGER trg_review_count
AFTER INSERT ON o_review
FOR EACH ROW
BEGIN
    UPDATE o_product
    SET pdt_review_count = pdt_review_count + 1
    WHERE pdt_id = :NEW.pdt_id;
END;
--
select *
from o_product;
-- 도움돼요 업데이트
CREATE OR REPLACE PROCEDURE up_rev_good_count
(
    puser_id o_review.user_id%TYPE,
    prev_id o_review.rev_id%TYPE
)
IS
    vrev_good_count o_review.rev_good_count%TYPE;
    vcount_likes NUMBER;
BEGIN
    -- 좋아요를 누른 사용자의 수를 확인
    SELECT COUNT(*)
    INTO vcount_likes
    FROM o_review
    WHERE rev_id = prev_id AND user_id = puser_id AND rev_good_count > 0;

    IF vcount_likes = 0 THEN
        -- 사용자가 좋아요를 누르지 않은 경우, 증가시키기
        UPDATE o_review
        SET rev_good_count = rev_good_count + 1
        WHERE rev_id = prev_id;

        DBMS_OUTPUT.PUT_LINE('좋아요가 증가했습니다.');

    ELSIF vcount_likes > 0 THEN
        -- 사용자가 이미 좋아요를 누른 경우, 감소시키기
        UPDATE o_review
        SET rev_good_count = rev_good_count - 1
        WHERE rev_id = prev_id;

        DBMS_OUTPUT.PUT_LINE('좋아요가 감소했습니다.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('상태를 확인할 수 없습니다.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error' || SQLERRM);
        ROLLBACK;
END;
--
exec up_rev_good_count (1006, 1);
--
select *
from o_review;
--
desc o_review;
--
ALTER TABLE o_review
ADD rev_bad_count number DEFAULT 0 NOT NULL;
--
ALTER TABLE o_review
DROP COLUMN rev_god_isrecommended;
--
ALTER TABLE o_review
ADD rev_god_isrecommended char(1) DEFAULT 'N' NOT NULL;
--
CREATE OR REPLACE PROCEDURE up_rev_good_count
(
    puser_id o_review.user_id%TYPE,
    prev_id  o_review.rev_id%TYPE
)
IS
    v_rev_good_count o_review.rev_good_count%TYPE;
    v_current_status CHAR(1);
BEGIN
    -- 현재 추천 상태 확인
    SELECT rev_god_isrecommended
    INTO v_current_status
    FROM o_review
    WHERE rev_id = prev_id AND user_id = puser_id;
    
    IF v_current_status IS NULL THEN
        -- 사용자가 추천하지 않은 경우, 추천수 증가
        UPDATE o_review
        SET rev_good_count = rev_good_count + 1
        WHERE rev_id = prev_id;
        
        -- 추천 상태 업데이트 (여기서는 추천 상태를 'Y'로 설정)
        UPDATE o_review
        SET rev_god_isrecommended = 'Y'
        WHERE rev_id = prev_id AND user_id = puser_id;
        
        DBMS_OUTPUT.PUT_LINE('추천수가 증가했습니다.');
        
    ELSIF v_current_status = 'Y' THEN
        -- 사용자가 이미 추천한 경우, 추천수 감소
        UPDATE o_review
        SET rev_good_count = rev_good_count - 1
        WHERE rev_id = prev_id;
        
        -- 추천 상태 업데이트 (여기서는 추천 상태를 NULL로 설정)
        UPDATE o_review
        SET rev_god_isrecommended = NULL
        WHERE rev_id = prev_id AND user_id = puser_id;
        
        DBMS_OUTPUT.PUT_LINE('추천수가 감소했습니다.');
        
    ELSE
        DBMS_OUTPUT.PUT_LINE('상태를 확인할 수 없습니다.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
--
exec up_rev_good_count (1008, 1);
--
select *
from o_review;
--
--
CREATE OR REPLACE PROCEDURE select_allisphoto
(
    ppdt_id o_review.pdt_id%type
    , prev_isphoto o_review.rev_isphoto%type
)
is
begin
    for visphoto in
    (
    select rurl_photo, rurl_record
    from o_review a, o_revurl b
    where a.rev_id = b.rev_id and rev_isphoto = prev_isphoto
    and pdt_id = ppdt_id
    )
    loop
    DBMS_OUTPUT.PUT_LINE(visphoto);
    end loop;
-- exception
end;
--
--
CREATE OR REPLACE PROCEDURE select_allisphoto
(
    ppdt_id o_review.pdt_id%TYPE,
    prev_isphoto o_review.rev_isphoto%TYPE
)
IS
BEGIN
    FOR visphoto IN
    (
        SELECT rurl_photo, rurl_record
        FROM o_review a
        JOIN o_revurl b ON a.rev_id = b.rev_id
        WHERE a.rev_isphoto = prev_isphoto
        AND a.pdt_id = ppdt_id
    )
    LOOP
        -- 레코드의 각 필드를 문자열로 변환하여 출력
        DBMS_OUTPUT.PUT_LINE('Photo URL: ' || visphoto.rurl_photo);
        DBMS_OUTPUT.PUT_LINE('Record URL: ' || visphoto.rurl_record);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
    
    FOR visrecord IN
    (
        SELECT rurl_record
        FROM o_review a
        JOIN o_revurl b ON a.rev_id = b.rev_id
        WHERE a.rev_isphoto = prev_isphoto
        AND a.pdt_id = ppdt_id
    )
    LOOP
        -- 레코드의 각 필드를 문자열로 변환하여 출력
        DBMS_OUTPUT.PUT_LINE('Record URL: ' || visrecord.rurl_record);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
    -- COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error' || SQLERRM);
END;
--
exec SELECT_ALLISPHOTO (1,'Y');

CREATE OR REPLACE PROCEDURE select_isphoto_one
(
    prev_id o_review.rev_id%type
    , prev_isphoto o_review.rev_isphoto%type
)
is
    vaa varchar2(30);
    vbb varchar2(30);
    vcc varchar2(30);
    vstarpoint varchar2(100);
    vname varchar2(100);
    vrev_content o_review.rev_content%type;
    vrev_good_count number;
    vrev_bad_count number;
    vrev_comment_count number;
    vpdt_name o_product.pdt_name%type;
    vrating number;
    vreview_count number;
begin
    select b.pdt_name 
        , a.rev_rating
        , b.pdt_review_count
        into vpdt_name, vrating, vreview_count
    from o_review a, o_product b
    where a.pdt_id = b.pdt_id
        and rev_id = prev_id
        and rev_isphoto = prev_isphoto;
    
    select
    CASE WHEN a.rev_isrecommend = 'Y' THEN '오호라 추천 리뷰'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '한달 사용 리뷰'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '★★★★★ '||'아주 좋아요'
                WHEN a.rev_rating = 4 THEN '★★★★ '||'맘에 들어요'
                WHEN a.rev_rating = 3 THEN '★★★ '||'보통이에요'
                WHEN a.rev_rating = 2 THEN '★★ '||'그냥 그래요'
                ELSE '★ '||'별로예요'
            END starpoint
            , CASE
             WHEN c.mem_name = 'crew' THEN N'오호라 크루님의 리뷰입니다.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'님의 리뷰입니다.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'님의 리뷰입니다.'
                END AS name
            , rev_content
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            into vaa, vbb, vcc, vstarpoint, vname, vrev_content
                , vrev_good_count, vrev_bad_count, vrev_comment_count
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id
        and rev_id = prev_id and rev_isphoto = prev_isphoto
    order by a.rev_writedate;
        
        DBMS_OUTPUT.PUT_LINE(vpdt_name);
        DBMS_OUTPUT.PUT_LINE(vrating);
        DBMS_OUTPUT.PUT_LINE(vreview_count);
        DBMS_OUTPUT.PUT_LINE('---------------------');
        DBMS_OUTPUT.PUT_LINE(vaa);
        DBMS_OUTPUT.PUT_LINE(vbb);
        DBMS_OUTPUT.PUT_LINE(vcc);
        DBMS_OUTPUT.PUT_LINE(vstarpoint);
        DBMS_OUTPUT.PUT_LINE(vname);
        DBMS_OUTPUT.PUT_LINE(vrev_content);
        DBMS_OUTPUT.PUT_LINE(vrev_good_count);
        DBMS_OUTPUT.PUT_LINE(vrev_bad_count);
        DBMS_OUTPUT.PUT_LINE(vrev_comment_count);
        commit;
-- exception
end;
--
exec SELECT_ISPHOTO_ONE (1,'Y');
--
-- 리뷰 INSERT 저장프로시저 생성
CREATE OR REPLACE PROCEDURE ins_o_review
(
    ppdt_id o_review.pdt_id%TYPE,
    pord_id o_review.ord_id%TYPE,
    puser_id o_review.user_id%TYPE,
    prev_content o_review.rev_content%TYPE,
    prev_writedate o_review.rev_writedate%TYPE,
    prev_rating o_review.rev_rating%TYPE,
    prev_isphoto o_review.rev_isphoto%TYPE,
    prev_isrecord o_review.rev_isrecord%TYPE,
    prev_age_group o_review.rev_age_group%TYPE,
    prev_option o_review.rev_option%TYPE
)
IS
    vopdt_confirm char(1);
BEGIN
    SELECT opdt_confirm INTO vopdt_confirm
    FROM o_review a, o_ordproduct b
    WHERE a.ord_id = b.ord_id;
    
    -- 구매확정 여부가 'Y'일 때만 INSERT 수행
    IF vopdt_confirm = 'Y' THEN
        INSERT INTO o_review
        (rev_id, pdt_id, ord_id, user_id, rev_content, rev_writedate, rev_rating,
         rev_isphoto, rev_isrecord, rev_age_group, rev_option)
        VALUES
        (seq_o_review.NEXTVAL, ppdt_id, pord_id, puser_id, prev_content, prev_writedate,
         prev_rating, prev_isphoto, prev_isrecord, prev_age_group, prev_option);
        COMMIT;
    ELSE
        -- 구매확정이 'Y'가 아닌 경우 ROLLBACK 수행
        ROLLBACK;
    END IF;
EXCEPTION
    -- 예외가 발생하면 ROLLBACK 수행
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
--
--
CREATE OR REPLACE PROCEDURE ins_o_review
(
    ppdt_id o_review.pdt_id%TYPE,
    pord_id o_review.ord_id%TYPE,
    puser_id o_review.user_id%TYPE,
    prev_content o_review.rev_content%TYPE,
    prev_writedate o_review.rev_writedate%TYPE,
    prev_rating o_review.rev_rating%TYPE,
    prev_isphoto o_review.rev_isphoto%TYPE,
    prev_age_group o_review.rev_age_group%TYPE,
    prev_option o_review.rev_option%TYPE
)
IS
    vopdt_confirm VARCHAR2(1);
BEGIN
    -- 구매확정 여부를 가져오기 위한 쿼리
    SELECT b.opdt_confirm
    INTO vopdt_confirm
    FROM o_ordproduct b
    WHERE b.ord_id = pord_id;

    -- 구매확정 여부가 'Y'일 때만 INSERT 수행
    IF vopdt_confirm = 'Y' THEN
        INSERT INTO o_review
        (rev_id, pdt_id, ord_id, user_id, rev_content, rev_writedate, rev_rating,
         rev_isphoto, rev_age_group, rev_option)
        VALUES
        (seq_o_review.NEXTVAL, ppdt_id, pord_id, puser_id, prev_content, prev_writedate,
         prev_rating, prev_isphoto, prev_age_group, prev_option);
        COMMIT;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error' || SQLERRM);
        RAISE;
END;
--
--
CREATE OR REPLACE PROCEDURE update_o_review
(   
    puser_id o_review.user_id%TYPE
    , prev_id o_review.rev_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_rating o_review.rev_rating%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , prev_age_group o_review.rev_age_group%TYPE
    , prev_option o_review.rev_option%TYPE
)
IS
BEGIN
    UPDATE o_review
    SET rev_content = prev_content, rev_rating = prev_rating
    , rev_isphoto = prev_isphoto, rev_age_group = prev_age_group
    , rev_option = prev_option
    WHERE rev_id = prev_id AND user_id = puser_id;
COMMIT;
EXCEPTION
WHEN OTHERS THEN
ROLLBACK;
END;
--
EXEC update_o_review (1001, 1, 'test4', 5, 'Y', '20대', '롱');
--
select *
from o_review;







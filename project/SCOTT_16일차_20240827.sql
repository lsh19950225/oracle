-- SCOTT
--
DESC o_lineup;

ALTER TABLE O_COLOR
DROP COLUMN COLOR_OPTION;
ALTER TABLE O_COLOR
ADD COLOR_OPTION NVARCHAR2(20) NOT NULL;

ALTER TABLE O_DESIGN
DROP COLUMN DESIGN_OPTION;
ALTER TABLE O_DESIGN
ADD DESIGN_OPTION NVARCHAR2(20) NOT NULL;

ALTER TABLE O_LINEUP
DROP COLUMN LINEUP_OPTION;
ALTER TABLE O_LINEUP
ADD LINEUP_OPTION NVARCHAR2(20) NOT NULL;
----------------------------------------------------------------------------
SELECT *
FROM o_review;

DESC o_review;
--
-- 리뷰 시퀀스 생성.
CREATE SEQUENCE seq_o_review
START WITH 1
NOCACHE;
--
-- 리뷰 INSERT 저장프로시저 생성.
CREATE OR REPLACE PROCEDURE ins_o_review
(
    pPDT_ID o_review.PDT_ID%TYPE
    , puser_id o_review.USER_ID%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_writedate o_review.rev_writedate%TYPE
    , prev_starpoint o_review.rev_starpoint%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , pREV_ISRECORD o_review.REV_ISRECORD%TYPE
    , pREV_AGE_GROUP o_review.REV_AGE_GROUP%TYPE
    , pREV_OPTION o_review.REV_OPTION%TYPE
)
IS
BEGIN
    INSERT INTO o_review
    (rev_id, pdt_id, user_id, rev_content, rev_writedate, rev_starpoint
    , rev_isphoto, rev_isrecord, rev_age_group, rev_option)
    VALUES
    (seq_o_review.NEXTVAL, ppdt_id, puser_id, prev_content, prev_writedate
    , prev_starpoint, prev_isphoto, prev_isrecord, prev_age_group
    , prev_option);
-- COMMIT;
-- EXCEPTION
END;
--
ALTER TABLE O_MEMBERSHIP
DROP COLUMN mem_benefit;
ALTER TABLE O_MEMBERSHIP
ADD mem_benefit NUMBER(2);

DESC O_MEMBERSHIP;
--
DESC O_COUPON;

ALTER TABLE O_COUPON
RENAME COLUMN CPN_DISOUNT_RATE TO CPN_DICOUNT_RATE;
--
-- INSERT 내용 쿼리.
SELECT *
FROM o_review;

DESC o_review;

EXEC INS_O_REVIEW (1, 1001, '레드가 어울리는 계절이 왔어요. 레드 풀컬러에 작은 꽃송이가 올라간 핑크가 더해져 어떤 손도 화사하게 만들어 줍니다. 배치에 따라 다양한 무드로 표현할 수 있는 티니를 만나보세요!', SYSDATE, 5, 'Y', 'Y', '20대','롱');

EXEC INS_O_REVIEW (1, 1002, '빨간색이 의외로 잘어울려서 구매했습니다.', SYSDATE, 5, 'Y', 'N', '20대','롱');

EXEC INS_O_REVIEW (1, 1003, '가을 신상이 나왔길래 몇개 구매했는데 정말 네일 맛집답게 색상이 가을가을하니 진짜 예쁘네요. 여러 디자인중 티니 네일 제일 눈에 들어와 맨먼저 붙였어요.', SYSDATE, 3, 'N', 'N', '30대','숏');

EXEC INS_O_REVIEW (1, 1004, '가을 신상이 나왔길래 몇개 구매했는데 정말 네일 맛집답게 색상이 가을가을하니 진짜 예쁘네요. 여러 디자인중 티니 네일 제일 눈에 들어와 맨먼저 붙였어요.', SYSDATE, 4, 'N', 'N', '10대','미디엄');

EXEC INS_O_REVIEW (1, 1005, '잘 받았지만 오픈 아직 안해요ㅎㅎ', SYSDATE, 1, 'N', 'Y', '40대 이상','미디엄');
--
--
DESC o_comment;
-- 댓글 시퀀스 생성.
CREATE SEQUENCE seq_o_comment
START WITH 1
NOCACHE;
-- 댓글 INSERT 저장프로시저 생성.
CREATE OR REPLACE PROCEDURE ins_o_comment
(
    prev_id o_comment.rev_id%TYPE
    , puser_id o_comment.user_id%TYPE
    , pcmt_writedate o_comment.cmt_writedate%TYPE
    , pcmt_content o_comment.cmt_content%TYPE
)
IS
BEGIN
    INSERT INTO o_comment
    (cmt_id, rev_id, user_id, cmt_writedate, cmt_content)
    VALUES
    (seq_o_comment.NEXTVAL, prev_id, puser_id, pcmt_writedate, pcmt_content);
-- COMMIT;
-- EXCEPTION
END;
-- 
-- INSERT 댓글 쿼리.
EXEC ins_o_comment (1, 1002, SYSDATE, '할머님 손톱 모양이 고우셔서 더 잘 어울리네요. 저희 친정엄마도 해드려야겠어요^^');

EXEC ins_o_comment (1, 1003, SYSDATE, '할머님 손도 손녀님 마음도 너무 예뻐요!');

EXEC ins_o_comment (1, 1001, SYSDATE, '감사합니다.'); -- 본인도 뒤에 두글자 **

EXEC ins_o_comment (1, 1004, SYSDATE, '너무 예쁘네요');

EXEC ins_o_comment (1, 1005, SYSDATE, '저도 구입추가요^^');

EXEC ins_o_comment (1, 1006, SYSDATE, '이 리뷰로 이 스타일 구매하고 싶어졌어요');
--
--
DROP TABLE o_address;
DROP TABLE o_cart;
DROP TABLE o_cartlist;
DROP TABLE o_category;
DROP TABLE o_color;
DROP TABLE o_comment;
DROP TABLE o_coupon;
DROP TABLE o_delivery;
DROP TABLE o_design;
DROP TABLE o_event;
DROP TABLE o_issuedcoupon;
DROP TABLE o_lineup;
DROP TABLE o_membership;
DROP TABLE o_order;
DROP TABLE o_payment;
DROP TABLE o_pdtcolor;
DROP TABLE o_pdtdesign;
DROP TABLE o_pdtlineup;
DROP TABLE o_pdtoption;
DROP TABLE o_product;
DROP TABLE o_review;
DROP TABLE o_subcategory;
DROP TABLE o_user;
--
--
SELECT *
FROM o_product;
--
--
SELECT *
FROM o_review;
--
DROP SEQUENCE seq_o_review;
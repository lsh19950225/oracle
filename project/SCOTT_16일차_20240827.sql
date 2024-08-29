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
-- ���� ������ ����.
CREATE SEQUENCE seq_o_review
START WITH 1
NOCACHE;
--
-- ���� INSERT �������ν��� ����.
CREATE OR REPLACE PROCEDURE ins_o_review
(
    ppdt_id o_review.pdt_id%TYPE
    , pord_id o_review.ord_id%TYPE
    , puser_id o_review.user_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_writedate o_review.rev_writedate%TYPE
    , pREV_RATING o_review.REV_RATING%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , pREV_ISRECORD o_review.REV_ISRECORD%TYPE
    , pREV_AGE_GROUP o_review.REV_AGE_GROUP%TYPE
    , pREV_OPTION o_review.REV_OPTION%TYPE
)
IS
BEGIN
    INSERT INTO o_review
    (rev_id, pdt_id, ord_id, user_id, rev_content, rev_writedate, REV_RATING
    , rev_isphoto, rev_isrecord, rev_age_group, rev_option)
    VALUES
    (seq_o_review.NEXTVAL, ppdt_id, pord_id, puser_id, prev_content, prev_writedate
    , PREV_RATING, prev_isphoto, prev_isrecord, prev_age_group
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
-- INSERT ���� ����.
SELECT *
FROM o_comment;
--
DELETE
FROM o_comment
WHERE cmt_id = 6;
--
DESC o_review;
--
EXEC INS_O_REVIEW (1, '20240828-000001', 1001, '���尡 ��︮�� ������ �Ծ��. ���� Ǯ�÷��� ���� �ɼ��̰� �ö� ��ũ�� ������ � �յ� ȭ���ϰ� ����� �ݴϴ�. ��ġ�� ���� �پ��� ����� ǥ���� �� �ִ� Ƽ�ϸ� ����������!', SYSDATE, 5, 'Y', 'Y', '20��','��');

EXEC INS_O_REVIEW (1, '20240828-000002', 1002, '�������� �ǿܷ� �߾����� �����߽��ϴ�.', SYSDATE, 5, 'Y', 'N', '20��','��');

EXEC INS_O_REVIEW (1, '20240828-000003', 1003, '���� �Ż��� ���Ա淡 � �����ߴµ� ���� ���� ������� ������ ���������ϴ� ��¥ ���ڳ׿�. ���� �������� Ƽ�� ���� ���� ���� ���� �Ǹ��� �ٿ����.', SYSDATE, 3, 'N', 'N', '30��','��');

EXEC INS_O_REVIEW (1, '20240828-000004', 1004, '���� �Ż��� ���Ա淡 � �����ߴµ� ���� ���� ������� ������ ���������ϴ� ��¥ ���ڳ׿�. ���� �������� Ƽ�� ���� ���� ���� ���� �Ǹ��� �ٿ����.', SYSDATE, 4, 'N', 'N', '10��','�̵��');

EXEC INS_O_REVIEW (1, '20240828-000005', 1005, '�� �޾����� ���� ���� ���ؿ䤾��', SYSDATE, 1, 'N', 'Y', '40�� �̻�','�̵��');
--
--
DESC o_comment;
-- ��� ������ ����.
CREATE SEQUENCE seq_o_comment
START WITH 1
NOCACHE;
-- ��� INSERT �������ν��� ����.
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
SELECT *
FROM o_comment;
-- INSERT ��� ����.
EXEC ins_o_comment (2, 1001, SYSDATE, '�ҸӴ� ���� ����� ���ż� �� �� ��︮�׿�. ���� ģ�������� �ص���߰ھ��^^');

EXEC ins_o_comment (2, 1002, SYSDATE, '�����մϴ�.'); -- ���ε� �ڿ� �α��� **

EXEC ins_o_comment (2, 1003, SYSDATE, '�ҸӴ� �յ� �ճ�� ������ �ʹ� ������!');

EXEC ins_o_comment (2, 1004, SYSDATE, '�ʹ� ���ڳ׿�');

EXEC ins_o_comment (2, 1005, SYSDATE, '���� �����߰���^^');

EXEC ins_o_comment (2, 1007, SYSDATE, '�� ����� �� ��Ÿ��');
--
--
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
--
--
SELECT *
FROM o_product;
--
SELECT *
FROM o_user;
--
SELECT *
FROM o_review;
--
DROP SEQUENCE seq_o_review;
--
UPDATE o_user
SET user_name = '��'
WHERE user_id = 1003;
--
UPDATE o_user
SET user_name = '�ν�'
WHERE user_id = 1004;
--
UPDATE o_user
SET user_name = '����'
WHERE user_id = 1005;
--
SELECT *
FROM o_order;
-- �ֹ� INSERT
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000001', 1001);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000002', 1002);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000003', 1003);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000004', 1004);
INSERT INTO o_order (ord_id, user_id) VALUES ('20240828-000005', 1005);
-- 
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000001', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000002', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000003', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000004', 1, 'Y');
INSERT INTO o_ordproduct (ord_id, pdt_id, opdt_confirm) VALUES ('20240828-000005', 1, 'Y');
--
SELECT *
FROM o_ordproduct;
--
COMMIT;
--
UPDATE o_ordproduct
SET opdt_confirm = 'Y'
WHERE ord_id = '20240828-000001';
--
ALTER TABLE o_review
ADD REV_BAD_COUNT NUMBER;
--
ALTER TABLE o_review
RENAME COLUMN REV_RECOMMEND_COUNT TO REV_GOOD_COUNT;
--
--
SELECT *
FROM o_review;
--
UPDATE o_review
SET REV_ISRECOMMEND = 'Y'
WHERE rev_id = 1;
--
-- ���� SELECT Ŀ�� ���� ���ν���
CREATE OR REPLACE PROCEDURE select_o_review
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
    SELECT CASE WHEN rev_isrecommend = 'Y' THEN '��ȣ�� ��õ ����'
                ELSE ''
                END AS aa
        , rev_rating
        , rev_content
        , rev_isphoto
        , rev_isrecord
        , CASE WHEN a.user_id = 1001 THEN '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
                ELSE ''
                END AS bb
        , rev_good_count
        , rev_bad_count
        , rev_comment_count
        ,
        CASE
             -- WHEN a.user_id = 1001 THEN '��ȣ�� ũ����� �����Դϴ�.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'���� �����Դϴ�.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'���� �����Դϴ�.'
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
--
EXEC SELECT_O_REVIEW(1);
--
--
SELECT *
FROM o_order;
--
SELECT *
FROM o_review;
--
--
SELECT user_name
FROM o_user;
--
SELECT LENGTH(user_name)
FROM o_review, o_user
WHERE user_id = 1001;
--
--
SELECT rev_rating "���� ���ƿ�"
FROM o_review
WHERE rev_id = 1;

SELECT rev_content
FROM o_review
WHERE rev_id = 1;

SELECT rev_isphoto, rev_isrecord
FROM o_review
WHERE rev_id = 1;

SELECT '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
FROM o_review
WHERE user_id = 1001;

SELECT rev_good_count -- Ʈ����
FROM o_review
WHERE rev_id = 1;

SELECT rev_bad_count -- Ʈ����
FROM o_review
WHERE rev_id = 1;

SELECT rev_comment_count -- Ʈ���� : ��ۼ�
FROM o_review
WHERE rev_id = 1;
--
--
UPDATE O_PRODUCT
SET SCAT_ID = 1
WHERE SCAT_ID = 3;

ALTER TABLE O_SUBCATEGORY
DROP COLUMN CAT_ID;

DELETE FROM O_SUBCATEGORY
WHERE SCAT_ID = 3;
--
SELECT *
FROM o_review
WHERE pdt_id = 1;
--
UPDATE o_user
SET user_name = '����'
WHERE user_id = 1005;
--
UPDATE o_user
SET user_name = '��'
WHERE user_id = 1003;
--
UPDATE o_user
SET user_name = '�ְ��ν�'
WHERE user_id = 1004;
SELECT *
FROM o_user;
--
COMMIT;
-- ����ſ� ������Ʈ��
CREATE OR REPLACE PROCEDURE up_good_count
(
    prev_id o_review.rev_id%TYPE
    , puser_id o_review.user_id%TYPE
)
IS
    vgood_count NUMBER;
BEGIN
    UPDATE o_review
    SET rev_good_count = rev_good_count + 1
    WHERE rev_id = prev_id AND user_id = puser_id;
    
    SELECT rev_good_count INTO vgood_count
    FROM o_review
    WHERE rev_id = prev_id AND user_id = puser_id;
    
--    IF vgood_count = 1 THEN
--    UPDATE o_review
--    SET rev_good_count = rev_good_count + 1
--    WHERE rev_id = prev_id AND user_id = puser_id;
--    
--    ELSIF vgood_count = 2 THEN
--    UPDATE o_review
--    SET rev_good_count = rev_good_count -1
--    WHERE rev_id = prev_id AND user_id = puser_id;
--    END IF;
END;

EXEC UP_GOOD_COUNT(1,1001);

ROLLBACK;

SELECT *
FROM o_review;
--
CREATE OR REPLACE PROCEDURE select_o_review
(
    prev_id o_review.rev_id%TYPE
    , prev_rating o_review.rev_rating%TYPE
)
IS
BEGIN
    WITH temp AS
    (
    SELECT LEVEL ����
    FROM DUAL
    CONNECT BY LEVEL <= 5
    )
    SELECT temp.���� ,COUNT(rev_rating)
    FROM o_review RIGHT OUTER JOIN temp ON temp.���� = o_review.rev_rating 
    GROUP BY rev_rating, temp.����, o_review.rev_avg_rating
    ORDER BY temp.���� DESC;
    
    FOR vo_review IN
    (
    SELECT CASE WHEN rev_isrecommend = 'Y' THEN '��ȣ�� ��õ ����'
                ELSE ''
                END AS aa
        , rev_rating
        , rev_content
        , rev_isphoto
        , rev_isrecord
        , CASE WHEN a.user_id = 1001 THEN '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
                ELSE ''
                END AS bb
        , rev_good_count
        , rev_bad_count
        , rev_comment_count
        ,
        CASE
             -- WHEN a.user_id = 1001 THEN '��ȣ�� ũ����� �����Դϴ�.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'���� �����Դϴ�.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'���� �����Դϴ�.'
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
CREATE OR REPLACE PROCEDURE up_rev_rating
(
--    ppdt_id o_review.pdt_id%TYPE
--    , puser_id o_review.user_id%TYPE
    prev_id o_review.rev_id%TYPE
    , prev_avg_rating o_review.rev_avg_rating%TYPE
)
IS
BEGIN
    UPDATE o_review
    SET rev_avg_rating = prev_avg_rating
    WHERE rev_rating IN(1,2,3,4,5) AND rev_id = prev_id;
-- EXCEPTION
END;
--
EXEC UP_REV_RATING(1,5);
--
SELECT rev_id, rev_avg_rating, rev_rating
FROM o_review;
--
ROLLBACK;












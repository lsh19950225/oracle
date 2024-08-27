-- SCOTT
--
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
-- ���� INSERT �������ν��� ����.
CREATE OR REPLACE PROCEDURE ins_o_review
(
    ppdt_id o_review.pdt_id%TYPE
    , puser_id o_review.user_id%TYPE
    , prev_content o_review.rev_content%TYPE
    , prev_writedate o_review.rev_writedate%TYPE
    , prev_starpoint o_review.rev_starpoint%TYPE
    , prev_isphoto o_review.rev_isphoto%TYPE
    , prev_isrecord o_review.rev_isrecord%TYPE
    , prev_age_group o_review.rev_age_group%TYPE
    , prev_option o_review.rev_option%TYPE
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
-- INSERT ���� ����.
EXEC INS_O_REVIEW (1, 1001, '���尡 ��︮�� ������ �Ծ��.
���� Ǯ�÷��� ���� �ɼ��̰� �ö� ��ũ�� ������ � �յ� ȭ���ϰ� ����� �ݴϴ�.
��ġ�� ���� �پ��� ����� ǥ���� �� �ִ� Ƽ�ϸ� ����������!'
, SYSDATE, 5, 'Y', 'Y', '20��','���ϸ�');

EXEC INS_O_REVIEW (1, 1002, '�������� �ǿܷ� �߾����� �����߽��ϴ�.'
, SYSDATE, 5, 'Y', 'N', '20��','���ϸ�');

EXEC INS_O_REVIEW (1, 1003, '���� �Ż��� ���Ա淡 � �����ߴµ� ���� ���� ������� ������ ���������ϴ� ��¥ ���ڳ׿�.
���� �������� Ƽ�� ���� ���� ���� ���� �Ǹ��� �ٿ����.'
, SYSDATE, 3, 'N', 'N', '30��','�ڼ�');

EXEC INS_O_REVIEW (1, 1004, '���� �Ż��� ���Ա淡 � �����ߴµ� ���� ���� ������� ������ ���������ϴ� ��¥ ���ڳ׿�.
���� �������� Ƽ�� ���� ���� ���� ���� �Ǹ��� �ٿ����.'
, SYSDATE, 4, 'N', 'N', '10��','�����');

EXEC INS_O_REVIEW (1, 1005, '�� �޾����� ���� ���� ���ؿ䤾��'
, SYSDATE, 1, 'N', 'Y', '40�� �̻�','Űġ');
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
-- INSERT ��� ����.
EXEC ins_o_comment (1, 1, SYSDATE, '�ҸӴ� ���� ����� ���ż� �� �� ��︮�׿�. ���� ģ�������� �ص���߰ھ��^^');

EXEC ins_o_comment (1, 2, SYSDATE, '�ҸӴ� �յ� �ճ�� ������ �ʹ� ������!');

EXEC ins_o_comment (1, 3, SYSDATE, '�ʹ� ���ڳ׿�');

EXEC ins_o_comment (1, 4, SYSDATE, '���� �����߰���^^');

EXEC ins_o_comment (1, 5, SYSDATE, '�� ����� �� ��Ÿ�� �����ϰ� �;������');
--










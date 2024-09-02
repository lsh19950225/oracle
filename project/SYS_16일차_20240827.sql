-- ���� ������ ����
CREATE SEQUENCE seq_o_review
START WITH 1
NOCACHE;
-- ���� �μ�Ʈ ���� ���ν���
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
    -- ����Ȯ�� ���θ� �������� ���� ����
    SELECT b.opdt_confirm
    INTO vopdt_confirm
    FROM o_ordproduct b
    WHERE b.ord_id = pord_id;

    -- ����Ȯ�� ���ΰ� 'Y'�� ���� INSERT ����
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
select *
from o_review;
--
--
CREATE OR REPLACE PROCEDURE select_o_review
(
    ppdt_id IN o_review.pdt_id%TYPE
)
IS
BEGIN
    FOR vo_review IN
    (
        SELECT *
        FROM
        (
            SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '��ȣ�� ��õ ����'
                        ELSE ''
                        END AS aa
                   , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                        ELSE ''
                        END AS bb
                   , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '�Ѵ� ��� ����'
                        ELSE ''
                        END AS cc
                   , CASE 
                        WHEN a.rev_rating = 5 THEN '�ڡڡڡڡ� ' || '���� ���ƿ�'
                        WHEN a.rev_rating = 4 THEN '�ڡڡڡ� ' || '���� ����'
                        WHEN a.rev_rating = 3 THEN '�ڡڡ� ' || '�����̿���'
                        WHEN a.rev_rating = 2 THEN '�ڡ� ' || '�׳� �׷���'
                        ELSE '�� ' || '���ο���'
                    END starpoint
                   , a.rev_content content
                   , CASE WHEN a.user_id = 1001 THEN '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
                        ELSE ''
                        END AS manager
                   , a.rev_good_count
                   , a.rev_bad_count
                   , a.rev_comment_count
                   , CASE
                        WHEN c.mem_name = 'crew' THEN N'��ȣ�� ũ����� �����Դϴ�.'
                        WHEN LENGTH(b.user_name) = 1 THEN N'*' || '���� �����Դϴ�.'
                        ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**') || '���� �����Դϴ�.'
                    END AS name
            FROM o_review a
            JOIN o_user b ON a.user_id = b.user_id
            JOIN o_membership c ON b.mem_id = c.mem_id
            WHERE a.pdt_id = ppdt_id
              AND a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '7' DAY
            ORDER BY a.rev_rating DESC
        )
        WHERE ROWNUM <= 3
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('����ſ� ' || vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('����ȵſ� ' || vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('��� ' || vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
exec select_o_review (1);
--
select *
from o_review;


-- ���� ������ ����
CREATE SEQUENCE seq_o_review
START WITH 1
NOCACHE;
-- ���� �μ�Ʈ ���� ���ν���
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
    -- ����Ȯ�� ���θ� �������� ���� ����
    SELECT b.opdt_confirm
    INTO vopdt_confirm
    FROM o_ordproduct b
    WHERE b.ord_id = pord_id;

    -- ����Ȯ�� ���ΰ� 'Y'�� ���� INSERT ����
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
EXEC update_o_review (1002, 1, 'test5', 5, 'Y', '20��', '��');
--
select *
from o_review;
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
    COMMIT;
-- EXCEPTION
END;
--
EXEC update_rev_isrecommend (1, 1001);
--
select *
from o_review;
--
CREATE OR REPLACE PROCEDURE select_rev_rating
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
    vavg_rev_rating NUMBER(2,1);
    vavg_percent NUMBER(3);
BEGIN
    SELECT AVG(rev_rating) "�������"
        , ROUND((AVG(rev_rating) / 5) * 100, 2) avg_percent INTO vavg_rev_rating, vavg_percent
    FROM o_review
    WHERE pdt_id = ppdt_id;
    
    DBMS_OUTPUT.PUT_LINE('��' || vavg_rev_rating);
    DBMS_OUTPUT.PUT_LINE(vavg_percent || '%�� �����ڰ� �� ��ǰ�� �����մϴ�.');
    
    FOR vo_review IN
    (
    WITH temp AS
    (
    SELECT LEVEL ����
    FROM dual
    CONNECT BY LEVEL <= 5
    )
    SELECT
        CASE
        WHEN temp.���� = 5 THEN '���� ���ƿ�  '
        WHEN temp.���� = 4 THEN '���� ����  '
        WHEN temp.���� = 3 THEN '�����̿���   '
        WHEN temp.���� = 2 THEN '�׳� �׷���  '
        WHEN temp.���� = 1 THEN '���ο���     '
        END starpoint
        , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') || 
        LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') stargraph
    FROM o_review a RIGHT OUTER JOIN temp ON temp.���� = a.rev_rating
    WHERE pdt_id = ppdt_id
    GROUP BY a.rev_rating, temp.����
    ORDER BY temp.���� DESC
    )
    LOOP
        DBMS_OUTPUT.PUT(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.stargraph);
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
EXEC select_rev_rating (1);
--
select *
from o_review;
--
update o_review
set rev_rating = 3
where rev_id = 6;
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
    DBMS_OUTPUT.PUT_LINE('����'||'&'||'������'||'('||vcount||')');
    
    FOR vo_review IN
    (
    SELECT rurl_photo, rurl_record
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id AND pdt_id = ppdt_id
    ORDER BY a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_photo);
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_record);
    END LOOP;
    COMMIT;
-- EXCEPTION
END;

EXEC select_photorecord (2);
--
SELECT *
FROM o_revurl;
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
    SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '��ȣ�� ��õ ����'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '�Ѵ� ��� ����'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '�ڡڡڡڡ� '||'���� ���ƿ�'
                WHEN a.rev_rating = 4 THEN '�ڡڡڡ� '||'���� ����'
                WHEN a.rev_rating = 3 THEN '�ڡڡ� '||'�����̿���'
                WHEN a.rev_rating = 2 THEN '�ڡ� '||'�׳� �׷���'
                ELSE '�� '||'���ο���'
            END starpoint
            , rev_content content
            , CASE WHEN a.user_id = 1001 THEN '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
                ELSE ''
                END AS manager
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            , CASE
             WHEN c.mem_name = 'crew' THEN N'��ȣ�� ũ����� �����Դϴ�.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'���� �����Դϴ�.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'���� �����Դϴ�.'
                END AS name
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id AND pdt_id = ppdt_id
    ORDER BY a.rev_isrecommend DESC, rev_good_count DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('����ſ� '||vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('����ȵſ� '||vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('��� '||vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------');
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
EXEC select_o_review (1);
--
select *
from o_review;
--
update o_review
set rev_good_count = 1
where rev_id = 6;
--
-- ��� ������ ����
CREATE SEQUENCE seq_o_comment
START WITH 1
NOCACHE;
-- ��� INSERT �������ν��� ����
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
    COMMIT;
-- EXCEPTION
END;
-- INSERT ��� ����
select *
from o_comment;
--
EXEC ins_o_comment (11, 1008, SYSDATE, '�ҸӴ� ���� ����� ���ż� �� �� ��︮�׿�.');
--
-- ��ۼ� ���� Ʈ���� ����
CREATE OR REPLACE TRIGGER trg_rev_comment_count
AFTER INSERT ON o_comment
FOR EACH ROW
BEGIN
    UPDATE o_review
    SET rev_comment_count = rev_comment_count + 1
    WHERE rev_id = :NEW.rev_id;
END;
--
select *
from o_review;
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
        -- ���ڵ��� �� �ʵ带 ���ڿ��� ��ȯ�Ͽ� ���
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
        -- ���ڵ��� �� �ʵ带 ���ڿ��� ��ȯ�Ͽ� ���
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
--
select *
from o_revurl;
--
--

CREATE OR REPLACE PROCEDURE select_rev_rating
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
    vavg_rev_rating NUMBER(2,1);
    vavg_percent NUMBER(3);
BEGIN
    SELECT AVG(rev_rating) "�������"
        , ROUND((AVG(rev_rating) / 5) * 100, 2) avg_percent INTO vavg_rev_rating, vavg_percent
    FROM o_review
    WHERE pdt_id = ppdt_id;
    
    DBMS_OUTPUT.PUT_LINE('��' || vavg_rev_rating);
    DBMS_OUTPUT.PUT_LINE(vavg_percent || '%�� �����ڰ� �� ��ǰ�� �����մϴ�.');
    
    FOR vo_review IN
    (
    WITH temp AS
    (
    SELECT LEVEL ����
    FROM dual
    CONNECT BY LEVEL <= 5
    )
    SELECT
        CASE
        WHEN temp.���� = 5 THEN '���� ���ƿ�'
        WHEN temp.���� = 4 THEN '���� ����'
        WHEN temp.���� = 3 THEN '�����̿���'
        WHEN temp.���� = 2 THEN '�׳� �׷���'
        WHEN temp.���� = 1 THEN '���ο���'
        END starpoint
        , RPAD('#', ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), '#') ||
        LPAD(' ', 50 - ROUND(RATIO_TO_REPORT(NVL(COUNT(a.rev_rating), 0)) OVER() * 50), ' ') stargraph
    FROM o_review a RIGHT OUTER JOIN temp ON temp.���� = a.rev_rating
    WHERE pdt_id = ppdt_id
    GROUP BY a.rev_rating , temp.����
    ORDER BY temp.���� DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.stargraph);
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
EXEC select_rev_rating (2);
--
--
CREATE OR REPLACE PROCEDURE select_photorecord
(
    ppdt_id o_review.pdt_id%TYPE
)
IS
    vcount NUMBER;
BEGIN
    -- ����� �������� ���� ���
    SELECT COUNT(b.rurl_id) INTO vcount
    FROM o_review a, o_revurl b
    WHERE a.rev_id = b.rev_id AND a.pdt_id = ppdt_id;
    -- ��� ���
    DBMS_OUTPUT.PUT_LINE('����' || '&' || '������' || '(' || vcount || ')');
    -- ������ ������ �������� �ֽż����� ���� 8���� ���
    FOR vo_review IN
    (
        SELECT rurl_photo, rurl_record
        FROM 
        (
            SELECT b.rurl_photo, b.rurl_record
            FROM o_review a, o_revurl b
            WHERE a.rev_id = b.rev_id AND a.pdt_id = ppdt_id
            ORDER BY a.rev_writedate DESC
        )
        WHERE ROWNUM <= 8
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_photo);
        DBMS_OUTPUT.PUT_LINE(vo_review.rurl_record);
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
exec SELECT_PHOTORECORD (1);
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
        -- ���ڵ��� �� �ʵ带 ���ڿ��� ��ȯ�Ͽ� ���
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
        -- ���ڵ��� �� �ʵ带 ���ڿ��� ��ȯ�Ͽ� ���
        DBMS_OUTPUT.PUT_LINE('Record URL: ' || visrecord.rurl_record);
        DBMS_OUTPUT.PUT_LINE('---------------------------');
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error' || SQLERRM);
END;
--
exec SELECT_ALLISPHOTO (1,'Y');
--
SELECT *
FROM o_review;
--
update o_review
set rev_isphoto = 'Y'
where rev_id = 5;
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
    SELECT CASE WHEN a.rev_isrecommend = 'Y' THEN '��ȣ�� ��õ ����'
                ELSE ''
                END AS aa
            , CASE WHEN a.rev_writedate >= TRUNC(SYSDATE) - INTERVAL '1' DAY THEN 'NEW'
                ELSE ''
                END AS bb
            , CASE WHEN a.rev_writedate <= SYSDATE - 30 THEN '�Ѵ� ��� ����'
                ELSE ''
                END AS cc
            , CASE 
                WHEN a.rev_rating = 5 THEN '�ڡڡڡڡ� '||'���� ���ƿ�'
                WHEN a.rev_rating = 4 THEN '�ڡڡڡ� '||'���� ����'
                WHEN a.rev_rating = 3 THEN '�ڡڡ� '||'�����̿���'
                WHEN a.rev_rating = 2 THEN '�ڡ� '||'�׳� �׷���'
                ELSE '�� '||'���ο���'
            END starpoint
            , rev_content content
            , CASE WHEN a.user_id = 1001 THEN '�� ����� ��ȣ�� �����ڰ� ����� �����Դϴ�.'
                END AS manager
            , rev_good_count
            , rev_bad_count
            , rev_comment_count
            , CASE
             WHEN c.mem_name = 'crew' THEN N'��ȣ�� ũ����� �����Դϴ�.'
             WHEN LENGTH(b.user_name) = 1 THEN N'*'||'���� �����Դϴ�.'
             ELSE REPLACE(b.user_name, SUBSTR(b.user_name, -2, 2), '**')||'���� �����Դϴ�.'
                END AS name
    FROM o_review a, o_user b, o_membership c
    WHERE a.user_id = b.user_id AND b.mem_id = c.mem_id AND pdt_id = ppdt_id
    ORDER BY a.rev_isrecommend DESC, rev_good_count DESC, a.rev_writedate DESC
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE(vo_review.aa);
        DBMS_OUTPUT.PUT_LINE(vo_review.bb);
        DBMS_OUTPUT.PUT_LINE(vo_review.cc);
        DBMS_OUTPUT.PUT_LINE(vo_review.starpoint);
        DBMS_OUTPUT.PUT_LINE(vo_review.content);
        DBMS_OUTPUT.PUT_LINE(vo_review.manager);
        DBMS_OUTPUT.PUT_LINE('����ſ� '||vo_review.rev_good_count);
        DBMS_OUTPUT.PUT_LINE('����ȵſ� '||vo_review.rev_bad_count);
        DBMS_OUTPUT.PUT_LINE('��� '||vo_review.rev_comment_count);
        DBMS_OUTPUT.PUT_LINE(vo_review.name);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
    END LOOP;
    COMMIT;
-- EXCEPTION
END;
--
EXEC select_o_review (1);
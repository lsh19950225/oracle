-- SCOTT
-- ������ DB �𵨸�
-- �������� DB �𵨸� ( �� )
-- PL/SQL
-- ��/���� ����Ŭ ������Ʈ ����
[����]
0001 ȫ�浿 �ֹ�, ����, �����..
0002 ȫ�浿 �ֹ�, ����, �����..
0003 ȫ�浿 �ֹ�, ����, �����..
0004 ȫ�浿 �ֹ�, ����, �����..
:
0010 ȫ�浿 �ֹ�, ����, �����..
--
ALTER TABLE tbl_survey
DROP COLUMN s_hangcount;

SELECT *
FROM TBL_SURVEY;

SELECT *
FROM tbl_quest;

DROP TABLE tbl_survey;

CREATE SEQUENCE seq_tblsurvey
NOCACHE;

--
UPDATE tbl_survey -- ������ ����.
SET s_lastdate = TO_DATE('24/08/26')
WHERE s_no = 3;
--
UPDATE tbl_quest -- �׸� ����.
SET q_item = '����'
WHERE s_no = 1 AND q_no = 1;
--
INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL, '���� ���� ���̵���?', '������', '2023-05-01', '2023-06-01', SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '���̸�');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'���� �߻��� ���̵���?','������','2023-05-12','2023-06-12',5);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '������ȣ');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '�ְ�â��');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'���� �߻��� ����?','������','2024-07-28','2023-08-28',10);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '�����');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '�̺���');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '���޼�');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '������');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'���� ���� ����?','������','2024-08-19','2024-09-19',1);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '������');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '������');
COMMIT;
--
UPDATE tbl_quest
SET q_no = 4
WHERE s_no = 2 AND q_count = '�ְ�â��';

UPDATE tbl_quest
SET q_no = 4
WHERE s_no = 3 AND q_count = '���޼�';

UPDATE tbl_quest
SET q_no = 5
WHERE s_no = 3 AND q_count = '������';
--
ALTER TABLE TBL_QUEST
RENAME COLUMN Q_COUNT TO Q_ITEM;
--
SELECT *
FROM user_sequences;
--
SELECT s_no, s_quest, s_name, s_startdate, s_lastdate
FROM tbl_survey
ORDER BY s_no DESC;
--
DELETE
FROM tbl_survey
WHERE s_no = 1;
--
DROP TABLE tbl_emp

-- SCOTT
-- 비디오샵 DB 모델링
-- 설문조사 DB 모델링 ( 팀 )
-- PL/SQL
-- 목/오후 오라클 프로젝트 진행
[비디오]
0001 홍길동 주배, 감독, 출시일..
0002 홍길동 주배, 감독, 출시일..
0003 홍길동 주배, 감독, 출시일..
0004 홍길동 주배, 감독, 출시일..
:
0010 홍길동 주배, 감독, 출시일..
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
UPDATE tbl_survey -- 종료일 수정.
SET s_lastdate = TO_DATE('24/08/26')
WHERE s_no = 3;
--
UPDATE tbl_quest -- 항목 수정.
SET q_item = '윤아'
WHERE s_no = 1 AND q_no = 1;
--
INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL, '가장 예쁜 아이돌은?', '관리자', '2023-05-01', '2023-06-01', SYSDATE);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '슬기');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '예나');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '아이린');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'가장 잘생긴 아이돌은?','관리자','2023-05-12','2023-06-12',5);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '차은우');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '육성재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '유노윤호');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '최강창민');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'가장 잘생긴 배우는?','관리자','2024-07-28','2023-08-28',10);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김수현');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '이정재');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 3, '이병헌');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 4, '오달수');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 5, '마동석');
COMMIT;

INSERT INTO tbl_survey VALUES(seq_tbls.NEXTVAL,'가장 예쁜 배우는?','관리자','2024-08-19','2024-09-19',1);
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 1, '김태희');
INSERT INTO tbl_quest VALUES((SELECT MAX(s_no) FROM tbl_survey), 2, '김지원');
COMMIT;
--
UPDATE tbl_quest
SET q_no = 4
WHERE s_no = 2 AND q_count = '최강창민';

UPDATE tbl_quest
SET q_no = 4
WHERE s_no = 3 AND q_count = '오달수';

UPDATE tbl_quest
SET q_no = 5
WHERE s_no = 3 AND q_count = '마동석';
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

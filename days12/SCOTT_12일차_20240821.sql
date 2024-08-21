-- SCOTT
-- PL/SQL
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P'; -- PK 확인.
--
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '관리자', '010-1111-1111', '서울 강남구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  '홍길동', '010-1111-1112', '서울 동작구' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '김준석', '010-1111-1341', '경기 남양주시' );
    COMMIT;
--
SELECT * FROM t_member;
--
ㄹ. 회원 정보 수정
  로그인 -> (홍길동) -> [내 정보] -> 내 정보 보기 -> [수정] -> [이름][][][][][][] -> [저장]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ㅁ. 회원 탈퇴
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
  INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'좋아하는 여배우?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5 -- 항목수
                          , 0 -- 참여자수
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS') -- 작성일
                          , 1 -- 설문 작성한 사람 : 1 : 관리자
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'배슬기', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'김옥빈', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'아이유', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'김선아', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'홍길동', 0, 1 );      
   COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'좋아하는 과목?'
                          , TO_DATE( '2024-08-12 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-08-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'자바', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'오라클', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'좋아하는 색?'
                          , TO_DATE( '2024-09-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-09-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'빨강', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'녹색', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'파랑', 0, 3 ); 
   
   COMMIT;
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *
FROM (
    SELECT  pollseq 번호, question 질문, membername 작성자
         , sdate 시작일, edate 종료일, itemcount 항목수, polltotal 참여자수
         , CASE 
              WHEN  SYSDATE > edate THEN  '종료'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
              ELSE '시작 전'
           END 상태 -- 추출속성   종료, 진행 중, 시작 전
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY 번호 DESC
) t 
WHERE 상태 != '시작 전';  
-- 설문상세보기
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '종료'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '진행 중'
                  ELSE '시작 전'
               END 상태
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
-- 항목
SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
-- 총 참여자수
SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
-- 그래프
SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  막대그래프
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
-- 투표함.
INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      1   ,  '김기수'      , SYSDATE,   2  ,     7 ,        3 );
    COMMIT;
--
  -- 1)         2/3 자동 UPDATE  [트리거]
    -- (2) t_poll   totalCount = 1증가
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1증가
    UPDATE   t_pollsub
    SET acount = acount + 1
    WHERE  pollsubseq = 6;
    
    commit;
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
-- PL/SQL
DECLARE -- 선언 블럭 : 생략가능, /* */ : 주석가능.
BEGIN -- 실행 블럭 : 반드시 있어야됨.
EXCEPTION -- 예외 처리 블럭 : 생략가능.
END; -- : 반드시 있어야됨.
--
-- 1) Anonymous Procedure (익명 프로시저)
DECLARE
    -- 변수, 상수 선언 블럭
    vename VARCHAR2(10); -- 변수 선언 시 세미콜론 필수(주의할 점)
    vpay NUMBER;
    -- 자바 상수 선언 : final double PI = 3.141592;
    -- vpi CONSTRAINT NUMBER = 3.141592; -- 상수 선언.
    vpi CONSTANT NUMBER := 3.14; -- PL/SQL : 대입 연산자 :=
BEGIN
    -- ORA-01422: exact fetch returns more than requested number of rows : 정확하게 가져오는 것이 요청되는 행의 수보다 많이 리턴됨.
    -- ORA-06512: at line 9
    -- 01422. 00000 -  "exact fetch returns more than requested number of rows"
    -- *Cause:    The number specified in exact fetch is less than the rows returned.
    -- *Action:   Rewrite the query or change number of rows requested
    SELECT ename, sal + NVL(comm,0) pay
            INTO vename, vpay -- SELECT, FETCH문에 INTO문을 사용해서 변수에다 값을 할당.
    FROM emp; -- INTO 구문으로는 1개의 변수에 하나만 담을 수 있다. : 커서(CURSOR) 사용. : 2개 이상 담기 가능.
    -- WHERE empno = 7369;
    -- 출력 System.out.printf("%s %d\n",vename,vpay);
    DBMS_OUTPUT.PUT_LINE( vename || ', ' || vpay );
-- EXCEPTION
END;
--
-- 문제) dept 테이블에서 
-- 30번 부서의 부서명을 얻어와서 출력하는  익명프로시저를 작성,테스트
-- 변수선언 : v
-- 매개변수선언 : p
--
DECLARE
    -- vdname VARCHAR2(14);
    vdname dept.dname%TYPE; -- 참조 : 유지보수 좋음.
BEGIN
    SELECT dname INTO vdname
    FROM dept
    WHERE deptno = 30;

    DBMS_OUTPUT.PUT_LINE( vdname );
-- EXCEPTION
END;

DESC dept; -- DNAME VARCHAR2(14)
-- 문제 30번 부서의 지역명을 얻어와서
-- 10번 부서의 지역명으로 설정하는 익명프로시저를 작성,테스트
DECLARE
    vloc dept.loc%TYPE;
BEGIN
    SELECT loc INTO vloc
    FROM dept
    WHERE deptno = 30;
    
    UPDATE dept
    SET loc = vloc
    WHERE deptno = 10;
    
    -- COMMIT;
EXCEPTION
    -- ROLLBACK;
END;

ROLLBACK;

SELECT * FROM dept;

--
-- [문제] 10번 부서원 중에 최고급여(sal)를 받는 사원의 정보를 출력.(조회)
SELECT ROWNUM, e.*
FROM
(
SELECT *
FROM emp
WHERE deptno = 10
ORDER BY sal DESC
) e
WHERE ROWNUM = 1;
--
SELECT *
FROM ( 
    SELECT 
       RANK() OVER(ORDER BY sal DESC ) sal_rank
       , emp.*
    FROM emp
    WHERE deptno = 10
) 
WHERE sal_Rank = 1;
-- PL/SQL
DECLARE
    vmax_sal_10 emp.sal%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vjob emp.job%TYPE;
    vhiredate emp.hiredate%TYPE;
    vdeptno emp.deptno%TYPE;
    vsal emp.sal%TYPE;
BEGIN
    -- 1.
    SELECT MAX(sal) INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vempno, vename, vjob, vsal, vhiredate, vdeptno
    FROM emp
    WHERE sal = vmax_sal_10 AND deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || vempno);
    DBMS_OUTPUT.PUT_LINE('사원명 :' || vename);
    DBMS_OUTPUT.PUT_LINE('입사일자 :' || vhiredate);
-- EXCEPTION
END;
-- 5) PL/SQL
DECLARE
    vmax_sal_10 emp.sal%TYPE;
--    vempno emp.empno%TYPE;
--    vename emp.ename%TYPE;
--    vjob emp.job%TYPE;
--    vhiredate emp.hiredate%TYPE;
--    vdeptno emp.deptno%TYPE;
--    vsal emp.sal%TYPE;
    vemprow emp%ROWTYPE; -- 한 레코드 전체 저장하는 변수.
BEGIN
    -- 1.
    SELECT MAX(sal) INTO vmax_sal_10
    FROM emp
    WHERE deptno = 10;
    -- 2.
    SELECT empno, ename, job, sal, hiredate, deptno
        INTO vemprow.empno, vemprow.ename, vemprow.job, vemprow.sal, vemprow.hiredate, vemprow.deptno
    FROM emp
    WHERE sal = vmax_sal_10 AND deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('사원번호 :' || vemprow.empno);
    DBMS_OUTPUT.PUT_LINE('사원명 :' || vemprow.ename);
    DBMS_OUTPUT.PUT_LINE('입사일자 :' || vemprow.hiredate);
-- EXCEPTION
END;

-- := 대입연산자
DECLARE
    va NUMBER := 1;
    vb NUMBER;
    vc NUMBER := 0;
BEGIN
    vb := 100;
    vc := va + vb;
    
    DBMS_OUTPUT.PUT_LINE(vc);
-- EXCEPTION
END;

-- PL/SQL 제어문
if(조건식){
    //
    //
} -- 자바
--
IF (조건식) : 생략가능. THEN -- : {

END IF; -- : }
--
--
if(조건식){
}else if(조건식){
}
--
IF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSIF 조건식 THEN
ELSE
END IF;
-- 문제 하나의 정수를 입력 받아서 홀수/짝수  라고 출력 익명프로시저
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := '홀수';
BEGIN
    vnum := :bindNumber; -- 바인드변수.
    IF MOD(vnum,2)=0 THEN
        vresult := '짝수';
    ELSE
        vresult := '홀수';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
-- EXCEPTION
END;
--
-- 문제 국어점수 입력받아서 수우미양가 등급 출력.. 익명프로시저
DECLARE
    vkorscore NUMBER(3) := 100;
    vgrade VARCHAR2(3) := '수';
BEGIN
    vkorscore := :bindNumber;
    IF vkorscore >= 90 THEN vgrade := '수';
    ELSIF vkorscore >= 80 THEN vgrade := '우';
    ELSIF vkorscore >= 70 THEN vgrade := '미';
    ELSIF vkorscore >= 60 THEN vgrade := '양';
    ELSE vgrade := '가';
    END IF;
    -- 강제 예외 발생. 아직 안배움.
    DBMS_OUTPUT.PUT_LINE(vgrade);
-- EXCEPTION
END;
--
DECLARE
    vkorscore NUMBER(3) := 100;
    vgrade VARCHAR2(3) := '수';
BEGIN
    vkorscore := :bindNumber;
    IF (vkorscore BETWEEN 90 AND 100) THEN
    -- 수~가
        vgrade := CASE TRUNC(vkor/10)
                WHEN 10 THEN '수'
                WHEN 9 THEN '수'
                WHEN 8 THEN '우'
                WHEN 7 THEN '미'
                WHEN 6 THEN '양'
                ELSE '가'
                END;
        DBMS_OUTPUT.PUT_LINE(vgrade);
    ELSE
        DBMS_OUTPUT.PUT_LINE('국어 0 ~ 100');
    END IF;
-- EXCEPTION
END;

--------------------------------------------------------------------------------
WHILE (조건식)
LOOP -- {
END LOOP; -- }

LOOP
--
--
EXIT WHEN (조건식); -- 자바 while의 break
END LOOP;
--
-- 문제 1~10 까지의 합 WHILE 익명프로시저
DECLARE
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  WHILE (vi <= 10) LOOP
    -- vsum += vi;   += 
    IF vi = 10 THEN
      DBMS_OUTPUT.PUT( vi );
    ELSE
      DBMS_OUTPUT.PUT( vi || '+');
    END IF;
    
    vsum := vsum + vi;
    vi := vi + 1;  -- ++/-- +=
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;
--
DECLARE -- 참고
  vi NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  WHILE (vi <= 10) LOOP
    EXIT WHEN vi = 11;
    IF vi = 10 THEN
      DBMS_OUTPUT.PUT( vi );
    ELSE
      DBMS_OUTPUT.PUT( vi || '+');
    END IF;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(  '=' || vsum );
--EXCEPTION  
END;
--
-- 1 ~ 10 합 출력 : FOR문
DECLARE
    -- vi NUMBER; -- FOR문에 반복변수는 선언하지 않아도 됨.
    vsum NUMBER := 0;
BEGIN
    FOR vi IN 1..10 -- REVERSE : 거꾸로 / 여기서 자동으로 선언됨.
    LOOP
        DBMS_OUTPUT.PUT(vi || '+');
        vsum := vsum+vi;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('=' || vsum);
-- EXCEPTION
END;
--
declare
chk number := 0;
begin
<<restart>>
-- dbms_output.enable;
chk := chk +1;
dbms_output.put_line(to_char(chk));
if chk <> 5 then
goto restart; -- 지정한 곳으로 이동 : 안쓰는게 좋다. goto문
end if;
end;
--
-- DECLARE -- 선언할 변수가 없으면 생략가능.
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 처리 ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 처리 ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 처리 '); 
--EXCEPTION
END;
-- 문제 1조 : WHILE 2~9단 세로/가로 출력
DECLARE
  vi NUMBER := 2;
  vj NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  WHILE (vi <= 9) LOOP
    vj := 1;  
    WHILE (vj <= 9) LOOP
    DBMS_OUTPUT.PUT_LINE(vi||'*'||vj||'='||(vi*vj));
    vj := vj + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');
    vi := vi + 1;
  END LOOP;
--EXCEPTION  
END;
--
DECLARE
  vi NUMBER := 2;
  vj NUMBER := 1;
  vsum NUMBER := 0;
BEGIN
  WHILE (vi <= 9) LOOP
    vj := 1;  
    WHILE (vj <= 9) LOOP
    DBMS_OUTPUT.PUT(vi||'*'||vj||'='||(vi*vj));
    vj := vj + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
    vi := vi + 1;
  END LOOP;
--EXCEPTION  
END;
--
DECLARE
  vi NUMBER := 2;
  vj NUMBER := 1;
BEGIN
    FOR vi IN 2..9 LOOP
        FOR vj IN 1..9 LOOP
        DBMS_OUTPUT.PUT(vi||'*'||vj||'='||(vi*vj));
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
END;
--
-- FOR문 사용한 SELECT (기억)
DECLARE
BEGIN
    -- FOR 반복변수i IN [REVERSE] 시작값..끝값 LOOP
    FOR verow IN (SELECT ename, hiredate, job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(verow.ename || '/' || verow.hiredate || '/' || verow.job);
    END LOOP;
-- EXCEPTION
END;
--
-- %TYPE변수, %ROWTYPE변수, [RECORD]변수
SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369;
-- [%TYPE 변수]
DECLARE
    vdeptno dept.deptno%TYPE;
    vdname dept.dname%TYPE;
    vempno emp.empno%TYPE;
    vename emp.ename%TYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
        INTO vdeptno, vdname, vempno, vename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE(vdeptno||', '||vdname||', '||vempno||', '||vename||', '||vpay);
-- EXCEPTION
END;

-- [%ROWTYPE 변수]
DECLARE
    verow emp%ROWTYPE;
    vdrow dept%ROWTYPE;
    vpay NUMBER;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
        INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE(vdrow.deptno||', '||vdrow.dname||', '||verow.empno||', '||verow.ename||', '||vpay);
-- EXCEPTION
END;
--
--
-- d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
-- 위의 컬럼값들을 저장할 레코드(행) 타입 선언.
-- (사용자 정의 구조체 타입 선언)
DECLARE
    TYPE EmpDeptTYPE IS RECORD
    (
        deptno dept.deptno%TYPE
        , dname dept.dname%TYPE
        , empno emp.empno%TYPE
        , ename emp.ename%TYPE
        , pay NUMBER
    );
    vedrow EmpDeptTYPE;
BEGIN
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
        INTO vedrow.deptno, vedrow.dname, vedrow.empno, vedrow.ename, vedrow.pay -- INTO vedrow 가능.
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE(vedrow.deptno||', '||vedrow.dname||', '||vedrow.empno||', '||vedrow.ename||', '||vedrow.pay);
-- EXCEPTION
END;
--
-- INSA b+s pay / 0.025 250 이상 / 0.02 200 이상
DECLARE
    vname insa.name%TYPE;
    vpay NUMBER;
    vtax NUMBER;
    vsil NUMBER;
BEGIN
    SELECT name, basicpay + sudang INTO vname, vpay
    FROM insa
    WHERE num = 1001;
    IF vpay >= 2500000 THEN vtax := vpay * 0.025;
    ELSIF vpay >= 2000000 THEN vtax := vpay * 0.02;
    ELSE
    vtax := 0;
    END IF;
    vsil := vpay - vtax;
    DBMS_OUTPUT.PUT_LINE(vname || '   ' || vpay || '   ' || vtax || '   ' || vsil);
-- EXCEPTION
END;

-- 커서(CURSOR)
DECLARE
    TYPE EmpDeptTYPE IS RECORD
    (
        deptno dept.deptno%TYPE
        , dname dept.dname%TYPE
        , empno emp.empno%TYPE
        , ename emp.ename%TYPE
        , pay NUMBER
    );
    vedrow EmpDeptTYPE;
    -- 1) 커서 선언
    CURSOR vdecursor IS ( -- SELECT문
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- 2) 커서 OPEN = SELECT문 실행.
    OPEN vdecursor; -- ctrl + F11
    
    -- 3) FETCH = 가져오다.
    LOOP
        FETCH vdecursor INTO vedrow;
        EXIT WHEN vdecursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vedrow.deptno||', '||vedrow.dname||', '||vedrow.empno||', '||vedrow.ename||', '||vedrow.pay);
    END LOOP;
    -- 4) 커서 CLOSE
    CLOSE vdecursor;
-- EXCEPTION
END;
--
-- FOR문 암시적 커서(CURSOR) 이해.
DECLARE
BEGIN
    FOR vedrow IN (
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    ORDER BY e.deptno ASC
    ) LOOP
    DBMS_OUTPUT.PUT_LINE(vedrow.deptno||', '||vedrow.dname||', '||vedrow.empno||', '||vedrow.ename||', '||vedrow.pay);
    END LOOP;
-- EXCEPTION
END;












-- SCOTT
-- PL/SQL
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *  
FROM user_constraints  
WHERE table_name LIKE 'T_M%'  AND constraint_type = 'P'; -- PK Ȯ��.
--
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  1,         'admin', '1234',  '������', '010-1111-1111', '���� ������' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  2,         'hong', '1234',  'ȫ�浿', '010-1111-1112', '���� ���۱�' );
INSERT INTO   T_MEMBER (  MEMBERSEQ,MEMBERID,MEMBERPASSWD,MEMBERNAME,MEMBERPHONE,MEMBERADDRESS )
VALUES                 (  3,         'kim', '1234',  '���ؼ�', '010-1111-1341', '��� �����ֽ�' );
    COMMIT;
--
SELECT * FROM t_member;
--
��. ȸ�� ���� ����
  �α��� -> (ȫ�浿) -> [�� ����] -> �� ���� ���� -> [����] -> [�̸�][][][][][][] -> [����]
  PL/SQL
  UPDATE T_MEMBER
  SET    MEMBERNAME = , MEMBERPHONE = 
  WHERE MEMBERSEQ = 2;
  ��. ȸ�� Ż��
  DELETE FROM T_MEMBER 
  WHERE MEMBERSEQ = 2;
--
  INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 1  ,'�����ϴ� �����?'
                          , TO_DATE( '2024-02-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-02-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 5 -- �׸��
                          , 0 -- �����ڼ�
                          , TO_DATE( '2023-01-15 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS') -- �ۼ���
                          , 1 -- ���� �ۼ��� ��� : 1 : ������
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (1 ,'�载��', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (2 ,'�����', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (3 ,'������', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (4 ,'�輱��', 0, 1 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (5 ,'ȫ�浿', 0, 1 );      
   COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 2  ,'�����ϴ� ����?'
                          , TO_DATE( '2024-08-12 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-08-28 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 4
                          , 0
                          , TO_DATE( '2024-02-20 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (6 ,'�ڹ�', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (7 ,'����Ŭ', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (8 ,'HTML5', 0, 2 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (9 ,'JSP', 0, 2 );
   
   COMMIT;
--
INSERT INTO T_POLL (PollSeq,Question,SDate, EDAte , ItemCount,PollTotal, RegDate, MemberSEQ )
   VALUES             ( 3  ,'�����ϴ� ��?'
                          , TO_DATE( '2024-09-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , TO_DATE( '2024-09-15 18:00:00'   ,'YYYY-MM-DD HH24:MI:SS') 
                          , 3
                          , 0
                          , TO_DATE( '2024-03-01 00:00:00'   ,'YYYY-MM-DD HH24:MI:SS')
                          , 1
                    );
--
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (10 ,'����', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (11 ,'���', 0, 3 );
INSERT INTO T_PollSub (PollSubSeq          , Answer , ACount , PollSeq  ) 
VALUES                (12 ,'�Ķ�', 0, 3 ); 
   
   COMMIT;
--
SELECT * FROM t_member;
SELECT * FROM t_poll;
SELECT * FROM t_pollsub;
SELECT * FROM t_voter;
--
SELECT *
FROM (
    SELECT  pollseq ��ȣ, question ����, membername �ۼ���
         , sdate ������, edate ������, itemcount �׸��, polltotal �����ڼ�
         , CASE 
              WHEN  SYSDATE > edate THEN  '����'
              WHEN  SYSDATE BETWEEN  sdate AND edate THEN '���� ��'
              ELSE '���� ��'
           END ���� -- ����Ӽ�   ����, ���� ��, ���� ��
    FROM t_poll p JOIN  t_member m ON m.memberseq = p.memberseq
    ORDER BY ��ȣ DESC
) t 
WHERE ���� != '���� ��';  
-- �����󼼺���
SELECT question, membername
               , TO_CHAR(regdate, 'YYYY-MM-DD AM hh:mi:ss')
               , TO_CHAR(sdate, 'YYYY-MM-DD')
               , TO_CHAR(edate, 'YYYY-MM-DD')
               , CASE 
                  WHEN  SYSDATE > edate THEN  '����'
                  WHEN  SYSDATE BETWEEN  sdate AND edate THEN '���� ��'
                  ELSE '���� ��'
               END ����
               , itemcount
           FROM t_poll p JOIN t_member m ON p.memberseq = m.memberseq
           WHERE pollseq = 2;
-- �׸�
SELECT answer
           FROM t_pollsub
           WHERE pollseq = 2;
-- �� �����ڼ�
SELECT  polltotal  
    FROM t_poll
    WHERE pollseq = 2;
-- �׷���
SELECT answer, acount
        , ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) totalCount
        -- ,  ����׷���
        , ROUND (acount /  ( SELECT  polltotal      FROM t_poll    WHERE pollseq = 2 ) * 100) || '%'
     FROM t_pollsub
    WHERE pollseq = 2;
-- ��ǥ��.
INSERT INTO t_voter 
    ( vectorseq, username, regdate, pollseq, pollsubseq, memberseq )
    VALUES
    (      1   ,  '����'      , SYSDATE,   2  ,     7 ,        3 );
    COMMIT;
--
  -- 1)         2/3 �ڵ� UPDATE  [Ʈ����]
    -- (2) t_poll   totalCount = 1����
    UPDATE   t_poll
    SET polltotal = polltotal + 1
    WHERE pollseq = 2;
    
    -- (3)t_pollsub   account = 1����
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
DECLARE -- ���� �� : ��������, /* */ : �ּ�����.
BEGIN -- ���� �� : �ݵ�� �־�ߵ�.
EXCEPTION -- ���� ó�� �� : ��������.
END; -- : �ݵ�� �־�ߵ�.
--
-- 1) Anonymous Procedure (�͸� ���ν���)
DECLARE
    -- ����, ��� ���� ��
    vename VARCHAR2(10); -- ���� ���� �� �����ݷ� �ʼ�(������ ��)
    vpay NUMBER;
    -- �ڹ� ��� ���� : final double PI = 3.141592;
    -- vpi CONSTRAINT NUMBER = 3.141592; -- ��� ����.
    vpi CONSTANT NUMBER := 3.14; -- PL/SQL : ���� ������ :=
BEGIN
    -- ORA-01422: exact fetch returns more than requested number of rows : ��Ȯ�ϰ� �������� ���� ��û�Ǵ� ���� ������ ���� ���ϵ�.
    -- ORA-06512: at line 9
    -- 01422. 00000 -  "exact fetch returns more than requested number of rows"
    -- *Cause:    The number specified in exact fetch is less than the rows returned.
    -- *Action:   Rewrite the query or change number of rows requested
    SELECT ename, sal + NVL(comm,0) pay
            INTO vename, vpay -- SELECT, FETCH���� INTO���� ����ؼ� �������� ���� �Ҵ�.
    FROM emp; -- INTO �������δ� 1���� ������ �ϳ��� ���� �� �ִ�. : Ŀ��(CURSOR) ���. : 2�� �̻� ��� ����.
    -- WHERE empno = 7369;
    -- ��� System.out.printf("%s %d\n",vename,vpay);
    DBMS_OUTPUT.PUT_LINE( vename || ', ' || vpay );
-- EXCEPTION
END;
--
-- ����) dept ���̺��� 
-- 30�� �μ��� �μ����� ���ͼ� ����ϴ�  �͸����ν����� �ۼ�,�׽�Ʈ
-- �������� : v
-- �Ű��������� : p
--
DECLARE
    -- vdname VARCHAR2(14);
    vdname dept.dname%TYPE; -- ���� : �������� ����.
BEGIN
    SELECT dname INTO vdname
    FROM dept
    WHERE deptno = 30;

    DBMS_OUTPUT.PUT_LINE( vdname );
-- EXCEPTION
END;

DESC dept; -- DNAME VARCHAR2(14)
-- ���� 30�� �μ��� �������� ���ͼ�
-- 10�� �μ��� ���������� �����ϴ� �͸����ν����� �ۼ�,�׽�Ʈ
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
-- [����] 10�� �μ��� �߿� �ְ�޿�(sal)�� �޴� ����� ������ ���.(��ȸ)
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
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || vempno);
    DBMS_OUTPUT.PUT_LINE('����� :' || vename);
    DBMS_OUTPUT.PUT_LINE('�Ի����� :' || vhiredate);
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
    vemprow emp%ROWTYPE; -- �� ���ڵ� ��ü �����ϴ� ����.
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
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ :' || vemprow.empno);
    DBMS_OUTPUT.PUT_LINE('����� :' || vemprow.ename);
    DBMS_OUTPUT.PUT_LINE('�Ի����� :' || vemprow.hiredate);
-- EXCEPTION
END;

-- := ���Կ�����
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

-- PL/SQL ���
if(���ǽ�){
    //
    //
} -- �ڹ�
--
IF (���ǽ�) : ��������. THEN -- : {

END IF; -- : }
--
--
if(���ǽ�){
}else if(���ǽ�){
}
--
IF ���ǽ� THEN
ELSIF ���ǽ� THEN
ELSIF ���ǽ� THEN
ELSIF ���ǽ� THEN
ELSE
END IF;
-- ���� �ϳ��� ������ �Է� �޾Ƽ� Ȧ��/¦��  ��� ��� �͸����ν���
DECLARE
    vnum NUMBER(4) := 0;
    vresult VARCHAR2(6) := 'Ȧ��';
BEGIN
    vnum := :bindNumber; -- ���ε庯��.
    IF MOD(vnum,2)=0 THEN
        vresult := '¦��';
    ELSE
        vresult := 'Ȧ��';
    END IF;
    DBMS_OUTPUT.PUT_LINE(vresult);
-- EXCEPTION
END;
--
-- ���� �������� �Է¹޾Ƽ� ����̾簡 ��� ���.. �͸����ν���
DECLARE
    vkorscore NUMBER(3) := 100;
    vgrade VARCHAR2(3) := '��';
BEGIN
    vkorscore := :bindNumber;
    IF vkorscore >= 90 THEN vgrade := '��';
    ELSIF vkorscore >= 80 THEN vgrade := '��';
    ELSIF vkorscore >= 70 THEN vgrade := '��';
    ELSIF vkorscore >= 60 THEN vgrade := '��';
    ELSE vgrade := '��';
    END IF;
    -- ���� ���� �߻�. ���� �ȹ��.
    DBMS_OUTPUT.PUT_LINE(vgrade);
-- EXCEPTION
END;
--
DECLARE
    vkorscore NUMBER(3) := 100;
    vgrade VARCHAR2(3) := '��';
BEGIN
    vkorscore := :bindNumber;
    IF (vkorscore BETWEEN 90 AND 100) THEN
    -- ��~��
        vgrade := CASE TRUNC(vkor/10)
                WHEN 10 THEN '��'
                WHEN 9 THEN '��'
                WHEN 8 THEN '��'
                WHEN 7 THEN '��'
                WHEN 6 THEN '��'
                ELSE '��'
                END;
        DBMS_OUTPUT.PUT_LINE(vgrade);
    ELSE
        DBMS_OUTPUT.PUT_LINE('���� 0 ~ 100');
    END IF;
-- EXCEPTION
END;

--------------------------------------------------------------------------------
WHILE (���ǽ�)
LOOP -- {
END LOOP; -- }

LOOP
--
--
EXIT WHEN (���ǽ�); -- �ڹ� while�� break
END LOOP;
--
-- ���� 1~10 ������ �� WHILE �͸����ν���
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
DECLARE -- ����
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
-- 1 ~ 10 �� ��� : FOR��
DECLARE
    -- vi NUMBER; -- FOR���� �ݺ������� �������� �ʾƵ� ��.
    vsum NUMBER := 0;
BEGIN
    FOR vi IN 1..10 -- REVERSE : �Ųٷ� / ���⼭ �ڵ����� �����.
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
goto restart; -- ������ ������ �̵� : �Ⱦ��°� ����. goto��
end if;
end;
--
-- DECLARE -- ������ ������ ������ ��������.
BEGIN
  --
  GOTO first_proc;
  --
  <<second_proc>>
  DBMS_OUTPUT.PUT_LINE('> 2 ó�� ');
  GOTO third_proc; 
  -- 
  --
  <<first_proc>>
  DBMS_OUTPUT.PUT_LINE('> 1 ó�� ');
  GOTO second_proc; 
  -- 
  --
  --
  <<third_proc>>
  DBMS_OUTPUT.PUT_LINE('> 3 ó�� '); 
--EXCEPTION
END;
-- ���� 1�� : WHILE 2~9�� ����/���� ���
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
-- FOR�� ����� SELECT (���)
DECLARE
BEGIN
    -- FOR �ݺ�����i IN [REVERSE] ���۰�..���� LOOP
    FOR verow IN (SELECT ename, hiredate, job FROM emp) LOOP
        DBMS_OUTPUT.PUT_LINE(verow.ename || '/' || verow.hiredate || '/' || verow.job);
    END LOOP;
-- EXCEPTION
END;
--
-- %TYPE����, %ROWTYPE����, [RECORD]����
SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
FROM dept d JOIN emp e ON d.deptno = e.deptno
WHERE empno = 7369;
-- [%TYPE ����]
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

-- [%ROWTYPE ����]
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
-- ���� �÷������� ������ ���ڵ�(��) Ÿ�� ����.
-- (����� ���� ����ü Ÿ�� ����)
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
        INTO vedrow.deptno, vedrow.dname, vedrow.empno, vedrow.ename, vedrow.pay -- INTO vedrow ����.
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    WHERE empno = 7369;
    DBMS_OUTPUT.PUT_LINE(vedrow.deptno||', '||vedrow.dname||', '||vedrow.empno||', '||vedrow.ename||', '||vedrow.pay);
-- EXCEPTION
END;
--
-- INSA b+s pay / 0.025 250 �̻� / 0.02 200 �̻�
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

-- Ŀ��(CURSOR)
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
    -- 1) Ŀ�� ����
    CURSOR vdecursor IS ( -- SELECT��
    SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
    FROM dept d JOIN emp e ON d.deptno = e.deptno
    );
BEGIN
    -- 2) Ŀ�� OPEN = SELECT�� ����.
    OPEN vdecursor; -- ctrl + F11
    
    -- 3) FETCH = ��������.
    LOOP
        FETCH vdecursor INTO vedrow;
        EXIT WHEN vdecursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(vedrow.deptno||', '||vedrow.dname||', '||vedrow.empno||', '||vedrow.ename||', '||vedrow.pay);
    END LOOP;
    -- 4) Ŀ�� CLOSE
    CLOSE vdecursor;
-- EXCEPTION
END;
--
-- FOR�� �Ͻ��� Ŀ��(CURSOR) ����.
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












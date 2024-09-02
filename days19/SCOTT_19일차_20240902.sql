-- SCOTT
-- emp 테이블에 pk(empno) / 인덱스
select *
from emp
where substr(empno,0,2) = 76; -- 풀 스캔 : where조건에 가공하면 index는 의미 없어진다. / 0.006초
where empno = 7369; -- 0.006초 index(unique scan)


where deptno = 30 AND sal > 1300; -- 풀 스캔 : 0.004초
create index ds_emp on emp(deptno,sal); -- index(range scan) : 0.008초
alter
drop index ds_emp;

where deptno = 10; -- 풀 스캔
where empno > 7600; -- range scan
where ename = 'SMITH'; -- 풀 스캔
where empno = 7369; -- 인덱스 스캔
-- 인덱스 검색
select *
from user_indexes
where table_name = 'EMP';
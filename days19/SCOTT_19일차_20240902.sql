-- SCOTT
-- emp ���̺� pk(empno) / �ε���
select *
from emp
where substr(empno,0,2) = 76; -- Ǯ ��ĵ : where���ǿ� �����ϸ� index�� �ǹ� ��������. / 0.006��
where empno = 7369; -- 0.006�� index(unique scan)


where deptno = 30 AND sal > 1300; -- Ǯ ��ĵ : 0.004��
create index ds_emp on emp(deptno,sal); -- index(range scan) : 0.008��
alter
drop index ds_emp;

where deptno = 10; -- Ǯ ��ĵ
where empno > 7600; -- range scan
where ename = 'SMITH'; -- Ǯ ��ĵ
where empno = 7369; -- �ε��� ��ĵ
-- �ε��� �˻�
select *
from user_indexes
where table_name = 'EMP';
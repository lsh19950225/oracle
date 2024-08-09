-- SYS
SELECT *
FROM emp
WHERE sal + NVL(comm, 0) IN (
    SELECT MIN(sal + NVL(comm, 0)) FROM emp
    UNION ALL
    SELECT MAX(sal + NVL(comm, 0)) FROM emp
);
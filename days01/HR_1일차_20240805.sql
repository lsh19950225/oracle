-- HR ������ �����ϰ� �ִ� ���̺� ���� ��ȸ.
SELECT *
FROM tabs;
-- first_name last_name    name ��ȸ
-- ����Ŭ : ���ڿ� ���� ������ ||
-- ����Ŭ : ���ڿ� '���ڿ�', ��¥�� '��¥��'
SELECT first_name fname
        , first_name || ' ' || last_name AS "N A M E" -- AS "��Ī", "" : ������ ���� ���.
    -- , CONCAT(first_name, ' ', last_name)
        , CONCAT(CONCAT(first_name, ' '), last_name) AS NAME -- "" ���� ����.
        , CONCAT(CONCAT(first_name, ' '), last_name) NAME -- AS ���� ����.
FROM employees;
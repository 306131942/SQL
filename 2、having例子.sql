--��sql������having�Ӿ��ԭ����,where�ؼ����޷���ϼƺ���һ��ʹ��


--HAVING �Ӿ�ʹ���ܹ�ָ�������������Ӷ����Ʋ�ѯ�������Щ����Գ��������ս�����档
--WHERE �Ӿ�Ա�ѡ�����ʩ���������� HAVING �Ӿ���� GROUP BY �Ӿ�����������ʩ��������
--�� SELECT ��ѯ�У�HAVING �Ӿ������� GROUP BY �Ӿ䣬�������� ORDER BY �Ӿ䣨����еĻ���֮ǰ��


--SELECT column_name, aggregate_function(column_name)
--FROM table_name
--WHERE column_name operator value
--GROUP BY column_name
--HAVING aggregate_function(column_name) operator VALUE

--���Ҷ����ܽ������ 2000 �Ŀͻ���
SELECT Customer,SUM(OrderPrice)
 FROM Orders
GROUP BY Customer
HAVING SUM(OrderPrice)<2000

--���ҿͻ� "Bush" �� "Adams" ӵ�г��� 1500 �Ķ����ܽ�
--������ SQL �����������һ����ͨ�� WHERE �Ӿ䣺
SELECT Customer,SUM(OrderPrice) 
FROM Orders
WHERE Customer='Bush' OR Customer='Adams'
GROUP BY Customer
HAVING SUM(OrderPrice)>1500


--������һ���й� HAVING �Ӿ�ʹ�õ�ʵ������ʵ������ɸѡ�����ִ������ڻ���� 2 �����м�¼��
SELECT ID, NAME, AGE, ADDRESS, SALARY
FROM CUSTOMERS
GROUP BY NAME
HAVING COUNT(NAME) >= 2;



SELECT* FROM fidb.dbo.tfi_pay_m
WHERE addtime>'20181217' AND paym_nbr LIKE 'AP%'


SELECT paym_typd_id,d.typd_wfm_code, SUM(paym_flag)
FROM fidb.dbo.tfi_pay_m m
LEFT JOIN fidb.dbo.tfi_type_d d ON d.typd_id=m.paym_typd_id
WHERE m.addtime>'20181217' AND paym_nbr LIKE 'AP%'--27
GROUP BY paym_typd_id ,typd_wfm_code

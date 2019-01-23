--在sql中增加having子句的原因是,where关键字无法与合计函数一起使用


--HAVING 子句使你能够指定过滤条件，从而控制查询结果中哪些组可以出现在最终结果里面。
--WHERE 子句对被选择的列施加条件，而 HAVING 子句则对 GROUP BY 子句所产生的组施加条件。
--在 SELECT 查询中，HAVING 子句必须紧随 GROUP BY 子句，并出现在 ORDER BY 子句（如果有的话）之前。


--SELECT column_name, aggregate_function(column_name)
--FROM table_name
--WHERE column_name operator value
--GROUP BY column_name
--HAVING aggregate_function(column_name) operator VALUE

--查找订单总金额少于 2000 的客户。
SELECT Customer,SUM(OrderPrice)
 FROM Orders
GROUP BY Customer
HAVING SUM(OrderPrice)<2000

--查找客户 "Bush" 或 "Adams" 拥有超过 1500 的订单总金额。
--我们在 SQL 语句中增加了一个普通的 WHERE 子句：
SELECT Customer,SUM(OrderPrice) 
FROM Orders
WHERE Customer='Bush' OR Customer='Adams'
GROUP BY Customer
HAVING SUM(OrderPrice)>1500


--下面是一个有关 HAVING 子句使用的实例，该实例将会筛选出出现次数大于或等于 2 的所有记录。
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

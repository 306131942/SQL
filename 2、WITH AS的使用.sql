
http://www.cnblogs.com/fightLonely/archive/2011/02/24/1963907.html

1、with as 含义：
	WITH AS短语，也叫做子查询部分（subquery factoring），可以让你做很多事情，定义一个SQL片断，该SQL片断会被整个SQL语句所用到。有的时候，是为了让SQL语句的可读性更高些，也有可能是在UNION ALL的不同部分，作为提供数据的部分。 
特别对于UNION ALL比较有用。因为UNION ALL的每个部分可能相同，但是如果每个部分都去执行一遍的话，则成本太高，所以可以使用WITH AS短语，则只要执行一遍即可。

2、这就是公用表表达式（CTE）

3、在使用CTE时应注意如下几点：
	A、CTE后面必须直接跟使用CTE的SQL语句（如select、insert、update等），否则，CTE将失效。
	B、CTE后面也可以跟其他的CTE，但只能使用一个with，多个CTE中间用逗号（,）分隔，
	C、如果CTE的表达式名称与某个数据表或视图重名，则紧跟在该CTE后面的SQL语句使用的仍然是CTE，当然，后面的SQL语句使用的就是数据表或视图了
  table1是一个实际存在的表

with
table1 as
(
    select * from persons where age < 30
)
select * from table1  --  使用了名为table1的公共表表达式
select * from table1  --  使用了名为table1的数据表
	
	
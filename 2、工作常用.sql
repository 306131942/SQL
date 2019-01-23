1,设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO
SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

2,SQL SERVER数据库性能优化_执行计划篇
	选中语句-》查询-》显示估计的执行计划（包括实际的执行计划、包括客户端统计信息）
	set statistics profile on
	set statistic io on
	set statistic time on
	go
	select ......
	
3,SQL SERVER -数据库作业与游标
	作业：是一系列由SQL Server代理按顺序执行的指定操作，定时执行需要运行的脚本代码
	游标：
	
4,视图
建立：看规范
使用：和表的使用一样
更改：和sp一样
删除：DROP VIEW view_name

5，索引
建立：CREATE 【UNIQUE】 INDEX index_name
ON table_name (column_name)

CREATE INDEX PersonIndex
ON Person (LastName) 

CREATE INDEX PersonIndex
ON Person (LastName DESC) 

CREATE INDEX PersonIndex
ON Person (LastName, FirstName)


使用：
更改：
删除：DROP INDEX table_name.index_name

6，！！！！！！！！！！！！
DROP TABLE 语句用于删除表（表的结构、属性以及索引也会被删除）：
DROP TABLE 表名称


7，
%替代一个或多个字符
_一个字符
like"%%"
not like"%%"
居住的城市以 "A" 或 "L" 或 "N" 开头的人：WHERE City LIKE '[ALN]%'
不以 "A" 或 "L" 或 "N" 开头的人：where city like '![ALN]%'

8，
DECLARE @rate DECIMAL(19, 4)
带固定精度和小数位数的数值数据类型。
decimal [ (p [ , s ] ) ]
numeric [ (p [, s ] ) ]
p为最多存储的十进制的总位数，包括小数点左右的位数，1到38，默认为18
小数点右边可以存储的十进制数字的最大位数。小数位数必须是从 0 到 p 之间的值。
仅在指定精度后才可以指定小数位数。默认的小数位数为 0；因此，0 <= s <= p。

SET  @effdate=CAST(CONVERT(VARCHAR(20),@effdate,23) AS DATETIME)
CAST ( expression AS data_type )
convert ( data_type, expression [, style ] ) 
返回转换为 data_type 的 expression。


9，
当 SET NOCOUNT 为 ON 时，不返回计数。
当 SET NOCOUNT 为 OFF 时，返回计数。
 结论：我们应该在存储过程的头部加上SET NOCOUNT ON 这样的话，在退出存储过程的时候加上SET NOCOUNT OFF这样的话，以达到优化

即使当 SET NOCOUNT 为 ON 时，也更新 @@ROWCOUNT 函数。（@@ROWCOUNT 返回受上一语句影响的行数。）
当 SET NOCOUNT 为 ON 时，将不向客户端发送存储过程中每个语句的 DONE_IN_PROC 消息。
如果存储过程中包含一些并不返回许多实际数据的语句，或者如果过程包含 Transact-SQL 循环，网络通信流量便会大量减少，因此，将 SET NOCOUNT 设置为 ON 可显著提高性能。
SET NOCOUNT 指定的设置是在执行或运行时生效，而不是在分析时生效。


BEGIN TRY
    -- Generate a divide-by-zero error.
    SELECT 1/0;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
 
TRY...CATCH 使用下列错误函数来捕获错误信息：
ERROR_NUMBER() 返回错误号。
ERROR_MESSAGE() 返回错误消息的完整文本。此文本包括为任何可替换参数（如长度、对象名或时间）提供的值。
ERROR_SEVERITY() 返回错误严重性。
ERROR_STATE() 返回错误状态号。
ERROR_LINE() 返回导致错误的例程中的行号。
ERROR_PROCEDURE() 返回出现错误的存储过程或触发器的名称。

可以使用这些函数从 TRY...CATCH 构造的 CATCH 块的作用域中的任何位置检索错误信息。如果在 CATCH 块的作用域之外调用错误函数，
错误函数将返回 NULL。在 CATCH 块中执行存储过程时，可以在存储过程中引用错误函数并将其用于检索错误信息。
如果这样做，则不必在每个 CATCH 块中重复错误处理代码。

10，
go
向 SQL Server 实用工具发出一批 Transact-SQL 语句结束的信号。结束批！！！！！！

USE AdventureWorks2008R2;
GO
DECLARE @MyMsg VARCHAR(50)
SELECT @MyMsg = 'Hello, World.'
GO -- @MyMsg is not valid after this GO ends the batch.
-- Yields an error because @MyMsg not declared in this batch.
PRINT @MyMsg
GO
SELECT @@VERSION;--version, 返回当前的 SQL Server 安装的版本、处理器体系结构、生成日期和操作系统。
-- Yields an error: Must be EXEC sp_who if not first statement in  batch.
sp_who
GO

11， try...catch
TRY…CATCH 构造包括两部分：一个 TRY 块和一个 CATCH 块。如果在 TRY 块内的 Transact-SQL 语句中检测到错误条件，则控制将被传递到 CATCH 块（可在此块中处理此错误）。
每个 TRY...CATCH 构造都必须位于一个批处理、存储过程或触发器中。例如，不能将 TRY 块放置在一个批处理中而将关联的 CATCH 块放置在另一个批处理中。

12,
select：显示在结果中
print:显示在消息中


13，
raiserror==>RAISERROR：生成错误消息并启动会话的错误处理。该消息作为服务器错误消息返回到调用应用程序，或返回到TRY...CATCH构造的关联catch中



14、SQL注入
如果你从网页中获取用户输入，并将获取到的字符串拼接成sql，执行的话，就可能会发生安全风险，
得到的很可能是会在你不知情的情况下运行的 SQL 语句。
用户提供的数据，使用这些数据之前，必须进行验证；
通常，验证工作由模式匹配来完成；

如:校验名字昵称，仅限由字母、数字和下划线组成，并且长度在 8 到 20 之间

15、模式匹配
是数据结构中字符串的一种基本运算，给定一个子串，要求在某个字符串中找出与该子串相同的所有子串，这就是模式匹配。









--学习整理后上传到github的
--E:\SCEO2.0\web\My-github

--SQL:
--E:\lcg\sql学习整理

--VUE简单的项目，把这个一个模块完成，包括接口
--E:\SCEO2.0\IT10



--VSS搜索: tools==> find in files  用*关键字*



--立项和合同：一个立项可能多个合同
SELECT cntm_code, cntm_proj_id, * FROM fidb.dbo.tfi_contract_m
SELECT proj_code, * FROM fidb.dbo.tfi_proj


本地vs路径
C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe


--类型转换
select Convert(VARCHAR(10),0.2) +'kkk'
select Convert(decimal(18,2),0.2)
SELECT CAST(0.22 AS VARCHAR(10))


--写sql，做判断时，考虑null的情况
DECLARE @t1 MONEY=NULL
SET  @t1 = @t1 + 2  
IF(@t1>0)--@t1=null
BEGIN 
 SELECT 1 --不进来
END 



IF OBJECT_ID('tempdb..#bill') IS NOT NULL DROP TABLE #bill;

USE fidb
GO

SELECT * FROM fidb.dbo.tfi_

DROP TABLE xxxx

UPDATE D
SET D.abhd_id = 1
FROM fidb.dbo.tfi_billhead_d d
LEFT JOIN  fidb.dbo.tfi_pay_m pm ON pm.paym_id
WHERE 

UPDATE fidb.dbo.tfi_collect_proj_m
SET tcpm_accumulate_way = 3
WHERE tcpm_id

DELETE 
FROM  fidb.dbo.tfi_account_tx 
WHERE actx_id = actx_id


SELECT TOP 20 rn = row_number() over (partition by wfna_m_id order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a --WHERE a.wfna_emp_id = '00000001' AND a.wfna_state = 0
--使用row_number（）函数进行编号
SELECT TOP 20 rn = row_number() over (order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a

--http://www.studyofnet.com/news/180.html(有时间看看)


SELECT  rn = row_number() over (partition by splr_name_cn order by splr_id asc),splr_code,splr_name_cn, * FROM HSRP.dbo.tfi_suppliers




小数点处理--------------------------------------------------------------
--	1、numeric 在功能上等价于 decimal；有四舍五入的功能
--	decimal[ (p[ , s] )] 和 numeric[ (p[ , s] )]
--	默认decimal(18,0)
--	p（精度）
--	最多可以存储的十进制数字的总位数，包括小数点左边和右边的位数。该精度必须是从 1 到最大精度 38 之间的值。默认精度为 18。
--	s（小数位数）
--	小数点右边可以存储的十进制数字的最大位数。小数位数必须是从 0 到 p 之间的值。
--	仅在指定精度后才可以指定小数位数。默认的小数位数为 0；因此，0 <= s <= p。最大存储大小基于精度而变化。
SELECT
select Convert(decimal(18,2),0.125) 
select Convert(numeric(18,2),123123123.211555) 
select Convert(numeric,1123123.255555) 

--2、ROUND ( numeric_expression , length [ ,function ] )，四舍五入；原来的小数点位数不变，第三个参数有截断的功能
--	length 
--		numeric_expression 的舍入精度。length 必须是 tinyint、smallint 或 int 类型的表达式。
--		如果 length 为正数，则将 numeric_expression 舍入到 length 指定的小数位数。如果 length 为负数，则将 numeric_expression 小数点左边部分舍入到 length 指定的长度。
--	function(两种情况,0默认,不截断,其他值截断,不四舍五入)
--		要执行的操作的类型。function 必须为 tinyint、smallint 或 int。
--		如果省略 function 或其值为 0（默认值），则将舍入 numeric_expression。如果指定了 0 以外的值，则将截断 numeric_expression。
SELECT ROUND(12.55555,2),ROUND(12.55555,1), ROUND(12.55555,0), ROUND(12.55555,-1), ROUND(12.55555,-2)
SELECT ROUND(123.5555555,-2, 0),ROUND(123.55555555555,2, 0)
SELECT ROUND(123.123456789,-3, 2), ROUND(123.123456789,-1, 2), ROUND(123.123456789,0, 2), ROUND(123.123456789,1, 2)



DELETE HPORTAL.dbo.twf_a WHERE wfna_m_id = @tdmm_id ANd wfna_table='fidb.dbo.tfi_dealing_match_a'
DELETE fidb.dbo.tfi_dealing_match_a WHERE wfna_m_id =@tdmm_id
DELETE fidb.dbo.tfi_dealing_match_d WHERE tdmd_tdmm_id=@tdmm_id
DELETE fidb.dbo.tfi_dealing_match_m WHERE tdmm_id=@tdmm_id


IF OBJECT_ID('tempdb..#temp_pay') IS NOT NULL DROP TABLE #temp_pay;		
SELECT * INTO #temp_pay  FROM

WHILE EXISTS (SELECT 1 FROM #temp_pay)
BEGIN
	--循环删除
	DELETE FROM #temp_pay WHERE 
END

DROP TABLE #temp_pay



select * into #pay_m1 from (
SELECT a=null,b=1
UNION ALL
SELECT a=null,b=2
UNION ALL
SELECT a=1,b=3	
)a
SELECT * FROM #pay_m1

SELECT sum(b-a) FROM #pay_m1


                                                                     
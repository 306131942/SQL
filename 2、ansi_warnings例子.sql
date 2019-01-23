
--指定几种错误情况下的 SQL-92 标准行为。
--当设置为 ON 时，如果聚合函数（如 SUM、AVG、MAX、MIN、STDEV、STDEVP、VAR、VARP 或 COUNT）中出现空值，将生成警告信息。当设置为 OFF 时，不发出警告。
--当设置为 ON 时，被零除错误和算术溢出错误将导致回滚语句并生成错误信息。当设置为 OFF 时，被零除错误和算术溢出错误将导致返回空值。-----这句话不正确
--				如果在 character、Unicode 或 binary 列上尝试执行 INSERT 或 UPDATE 操作，而这些列中的新值长度超出最大列大小，则被零除错误和算术溢出错误将导致返回空值。
--				如果 SET ANSI_WARNINGS 为 ON，则按 SQL-92 标准的指定将取消 INSERT 或 UPDATE。将忽略字符列的尾随空格，忽略二进制列的尾随零。
--				当设置为 OFF 时，数据将剪裁为列的大小，并且语句执行成功。
--说明  在 binary 或 varbinary 数据转换中发生截断时，不管 SET 选项的设置是什么，都不发出警告或错误信息。

USE test_db
GO

CREATE TABLE T11 ( a int, b int NULL, c varchar(20) ) 
GO

SELECT * FROM T11 

SET NOCOUNT ON
GO

INSERT INTO T11 VALUES (1, NULL, '')
INSERT INTO T11 VALUES (1, 0, '')
INSERT INTO T11 VALUES (2, 1, '')
INSERT INTO T11 VALUES (2, 2, '')
GO

------------------------------------消息里面显示影响了多少行
SET NOCOUNT OFF
GO
SELECT * FROM T11 
------------------------------------消息里面不显示影响了多少行
SET NOCOUNT ON 
GO
SELECT * FROM T11 
------------------------------------消息里面显示警告
SET ANSI_WARNINGS ON
GO
SELECT *   FROM T11 
------------------------------------消息里面不显示警告
SET ANSI_WARNINGS OFF 
GO
SELECT *   FROM T11 


SELECT * FROM test_db.dbo.T11 t

SELECT a, SUM(b) FROM T11 GROUP BY a

INSERT INTO T11 VALUES (3, 3, 'Text string longer than 20 characters')

SELECT a/b FROM T11


SELECT a, SUM(b) FROM T11 GROUP BY a

INSERT INTO T11 VALUES (4, 4, 'Text string longer than 20 characters')

SELECT a/b FROM T11


--DROP TABLE T11
--GO
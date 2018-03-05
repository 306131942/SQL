--1.列出使用库名
USE [库名]
GO

--2.添加更新函数的判断
IF OBJECT_ID('rf_xx') IS NOT NULL
BEGIN
	DROP PROCEDURE rf_xx;
END
GO

--3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

--4.填写函数的基本信息
-- =========================================================================================
-- Author:		xx
-- Create date: 2012-12-08
-- Description:	函数的说明与描述（如：函数创建模版）

-- Modify [1]:  xx, 2012-12-09, 简化函数模版
-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================

--5.在创建函数时，对象名按命名规范（rf_两个字母的模块英文缩写_函数功能标识）
CREATE FUNCTION rf_xx
(
	--6.参数变量用( )括起来，每个一行
	@id	INT,					--字段说明 
	@date VARCHAR(20),			--字段说明 
	@money DECIMAL(18,2)		--字段说明
)
RETURNS data_type	--7.返回数据类型（表值函数请使用'多语句表值函数'代替'内联表值函数'）
WITH SCHEMABINDING  --8.如SQL查询语句中所有对象都是同一个数据库，则需加上SCHEMABINDING
AS
BEGIN
	--9.定义函数的入口参数(方便调试，发布时要注释)。每个一行
	/*
	DECLARE @id INT;
	DECLARE @date VARCHAR(20);
	DECLARE @money DECIMAL(18,2);
	SET @id = 0;
	SET @date = '2012-01-01';
	SET @money = 0;
	*/
	
	--10.SQL查询语句中的表对象需加上dbo架构名称，如dbo.table1
		
	--11.定义局部变量,要说明字段意义。每个一行
	DECLARE @name VARCHAR(20);		--字段说明
	DECLARE @code VARCHAR(20);		--字段说明
		
	--12.常量赋值使用SET，子查询赋值使用SELECT，需说明赋值语句含义。每个一行
	SET @name = '模板名称';
	SELECT @code = tc.code_code FROM dbo.tba_code tc WHERE tc.code_type = '' AND tc.code_module = '' AND tc.code_enable = 1;
	
	--13.每个IF ELSE 都要有逻辑说明
	--14.每个IF ELSE 都要有BEGIN ... END，END后添加标识这是哪个 IF 或 ESLE 的结束符注释
	IF @code <> '' --@code 不等于 ''
		BEGIN		
			SET @code = 'XXX'; --将CODE设置为XXX		
		END --IF @code <> '' 
	ELSE --@code 等于 '' 或者 @code 等于 NULL
		BEGIN
			--从tba_code中取出参数XXX赋值
			SELECT @code = tc.code_code FROM dbo.tba_code tc WHERE tc.code_type = '' AND tc.code_module = '' AND tc.code_enable = 1;					
		END --ELSE @code <> ''
		
	--15.每个 WHILE 循环 都要有逻辑注释说明
	--16.每个 WHILE 循环 都要有BEGIN ... END，END后添加标识这是哪个WHILE循环的结束符注释	
	WHILE @name IS NULL  --当@name为NULL时，给@name赋值
		BEGIN
			--给@name赋值
			SELECT @name = tc.code_name FROM dbo.tba_code tc WHERE tc.code_id = 100;
		END --WHILE @name IS NULL
	
	--17.如果语句中有公式/算法，须列出公式原型和列子	

END



--------------
USE XXXX
GO
IF (OBJECT_ID('rf_xx') IS NULL)
BEGIN
    EXEC ('CREATE FUNCTION rf_xx() RETURNS INT AS BEGIN RETURN 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON 
GO
-- =========================================================================================
-- Author:		xx
-- Create date: xx
-- Description:	字符分割函数
-- =========================================================================================
ALTER FUNCTION rf_xx
(
    @i_sourc_str VARCHAR(2000),			-- 源字符串 
    @i_split_str VARCHAR(3),			-- 分割字符
    @i_index VARCHAR(20)				-- 取值序号 
)
RETURNS VARCHAR(100)	-- 7.返回数据类型（表值函数请使用'多语句表值函数'代替'内联表值函数'）
WITH SCHEMABINDING		-- 8.如SQL查询语句中所有对象都是同一个数据库，则需加上SCHEMABINDING
AS
BEGIN
	/*
	
	SELECT XXXX.dbo.rf_fi_split('123#-#RMB','#-#',1)
    DECLARE @i_sourc_str VARCHAR(2000)='1,2,3';			-- 源字符串 
    DECLARE @i_split_str VARCHAR(3)=',';			-- 分割字符
    DECLARE @i_index VARCHAR(20)=2;				-- 取值序号 
	*/
	DECLARE @sourc_str VARCHAR(2000);
	DECLARE @result VARCHAR(2000);
	SET @sourc_str = @i_sourc_str;

	DECLARE @first INT;		--字段说明
	DECLARE @last INT;		--字段说明
	DECLARE @index_0 INT;
	-- 初始化表量
	SELECT @index_0 = 0, @last = 1

	WHILE((CHARINDEX(@i_split_str,@sourc_str) = 1) AND (@index_0 != @i_index))
	BEGIN
		SET @index_0 = @index_0 + 1;
		SET @result=''
		SET @sourc_str=SUBSTRING(@sourc_str, LEN(@i_split_str) + 1, LEN(@sourc_str))
	END

	WHILE(@index_0 != @i_index)
	BEGIN
		SET @index_0 = @index_0 + 1;
		IF(CHARINDEX(@i_split_str,@sourc_str) = 0)
		BEGIN
			SET @last = LEN(@sourc_str)
			SET @result = SUBSTRING(@sourc_str, 1, @last)
			SET @sourc_str=SUBSTRING(@sourc_str, @last + LEN(@i_split_str), LEN(@sourc_str))
		END
		ELSE
		BEGIN
			SET @last = CHARINDEX(@i_split_str, @sourc_str)
			SET @result = SUBSTRING(@sourc_str, 1, @last-1)
			SET @sourc_str=SUBSTRING(@sourc_str, @last + LEN(@i_split_str), LEN(@sourc_str))
		END
	END
	RETURN (@result)
END
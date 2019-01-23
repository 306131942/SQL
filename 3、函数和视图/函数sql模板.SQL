--1.列出使用库名
USE [库名]
GO

--2.添加更新函数的判断
IF OBJECT_ID('rf_ba_functiontemplate') IS NOT NULL
BEGIN
	DROP PROCEDURE rf_ba_functiontemplate;
END
GO

--3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

--4.填写函数的基本信息
-- =========================================================================================
-- Author:		谭建平
-- Create date: 2012-12-08
-- Description:	函数的说明与描述（如：函数创建模版）

-- Modify [1]:  谭建平, 2012-12-09, 简化函数模版
-- Modify [2]:  谭建平, 2012-12-10, 优化函数模版
-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================

--5.在创建函数时，对象名按命名规范（rf_两个字母的模块英文缩写_函数功能标识）
CREATE FUNCTION rf_ba_functiontemplate
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
	--责任利润 = ∑销售额
	--		   - ∑销售成本
	--		   - 增值税及附加
	--		   - 本部门的各项费用
	--		   - 广告费
	--		   - 运输费
	--		   - 品质成本
	--		   - 资金占用费
	--		   - 上缴管理费用
	--		   - 企业所得税
	--		   + 废品净收入		

END
--1.列出使用库名
USE [库名]
GO

--2.添加更新视图的判断
IF OBJECT_ID('v_xx','V') IS NOT NULL
BEGIN
	DROP VIEW v_xx;
END
GO

--3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

--4.填写视图的基本信息
-- =========================================================================================
-- Author:		xx
-- Create date: 2013-02-22
-- Description:	视图的说明与描述（如：视图创建模版）

-- Modify [1]:  xx, 2013-02-23, 简化视图创建模版
-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================

--5.创建视图时，视图命名需规范（v_两个字母的模块英文缩写_视图的功能标识）
CREATE VIEW v_xx
WITH SCHEMABINDING, --6.如SQL查询语句中所有对象都是同一个数据库，则需加上SCHEMABINDING
	 VIEW_METADATA	--7.需加上VIEW_METADATA 返回视图元数据信息
AS
--8.SQL查询语句中的表对象需加上dbo架构名称，如dbo.table1
--9.SQL查询语句中的表对象需加上注释说明
	SELECT	t1.id,
			t1.name,
			t2.name,
			... 
	FROM dbo.table1 t1 --table1说明
	INNER JOIN dbo.table2 t2 --table2说明
			   ON t1.id = t2.id
--10.需加上CHECK OPTION 验证			   
WITH CHECK OPTION;
GO

--注，SQL查询语句中不能包括下列内容：
--(1) COMPUTE 或 COMPUTE BY 子句；
--(2) ORDER BY 子句；
--(3) INTO 关键字；
--(4) OPTION 子句；
--(5) 引用临时表或表变量。


--------------------
USE xx
GO
IF(OBJECT_ID('v_xx','V') IS NULL)
BEGIN
	  EXEC ('CREATE VIEW v_xx AS SELECT id=1;');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		xx
-- Create date: xx
-- Description:	汇率信息视图
-- =========================================================================================
ALTER VIEW [dbo].[xx]
WITH VIEW_METADATA
AS
	SELECT
		c1,c2,c3,...
	FROM XXXX.dbo.xxxx

WITH CHECK OPTION;
GO
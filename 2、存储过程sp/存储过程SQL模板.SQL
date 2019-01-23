--1.列出使用库名
USE [库名]
GO

--2.添加更新存储过程的判断
IF OBJECT_ID('rp_ba_proceduretemplate','P') IS NOT NULL
BEGIN
	DROP PROCEDURE rp_ba_proceduretemplate;
END
GO

--3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

--4.填写存储过程的基本信息
-- =========================================================================================
-- Author:		谭建平
-- Create date: 2012-12-08
-- Description:	存储过程的说明与描述（如：存储过程模版）

-- Modify [1]:  谭建平, 2012-12-09, 简化存储过程模版
-- Modify [2]:  谭建平, 2012-12-10, 优化存储过程模版
-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================

--5.在编写存储过程时，对象名按命名规范（rp_两个字母的模块英文缩写_存储过程功能标识），且使用PROCEDURE 代替 PROC 简写
CREATE PROCEDURE rp_ba_proceduretemplate
(
	--6.参数变量命名应有io之分，i输入，o输出；且用( )括起来。每个一行
	@i_bid	INT,					--字段说明 
	@i_date VARCHAR(20),			--字段说明 
	@o_money DECIMAL(18,2) OUTPUT	--字段说明
)
AS
BEGIN TRY
	--7.兼容zbox：禁止警告提示和影响行提示
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--8.定义存储过程的入口参数(方便调试，发布时要注释)。每个一行
	/*
	DECLARE @i_bid INT;
	DECLARE @i_date VARCHAR(20);
	DECLARE @o_money DECIMAL(18,2);
	SET @i_bid = 0;
	SET @i_date = '2012-01-01';
	SET @o_money = 0;
	*/
	
	--9.定义局部变量,要说明字段意义。每个一行
	DECLARE @name VARCHAR(20);		--字段说明
	DECLARE @code VARCHAR(20);		--字段说明
		
	--10.常量赋值使用SET，子查询赋值使用SELECT，需说明赋值语句含义。每个一行
	SET @name = '模板名称';
	SELECT @code = tc.code_code FROM tba_code tc WHERE tc.code_type = '' AND tc.code_module = '' AND tc.code_enable = 1;
	
	--11.每个IF ELSE 都要有逻辑说明
	--12.每个IF ELSE 都要有BEGIN ... END，END后添加标识这是哪个 IF 或 ESLE 的结束符注释
	IF @code <> '' --@code 不等于 ''
		BEGIN		
			SET @code = 'XXX'; --将CODE设置为XXX		
		END --IF @code <> '' 
	ELSE --@code 等于 '' 或者 @code 等于 NULL
		BEGIN
			--从tba_code中取出参数XXX赋值
			SELECT @code = tc.code_code FROM tba_code tc WHERE tc.code_type = '' AND tc.code_module = '' AND tc.code_enable = 1;					
		END --ELSE @code <> ''
		
	--13.每个 WHILE 循环 都要有逻辑注释说明
	--14.每个 WHILE 循环 都要有BEGIN ... END，END后添加标识这是哪个WHILE循环的结束符注释	
	WHILE @name IS NULL  --当@name为NULL时，给@name赋值
		BEGIN
			--给@name赋值
			SELECT @name = tc.code_name FROM tba_code tc WHERE tc.code_id = 100;
		END --WHILE @name IS NULL
	
	--15.如果语句中有公式/算法，须列出公式原型和列子
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
	
END TRY
--16.需要 TRY CATCH 捕获异常结构
BEGIN CATCH

 DECLARE @ErrorMessage NVARCHAR(4000),
 		   @ErrorSeverity INT,
 		   @ErrorState INT;

 SELECT @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

 RAISERROR (@ErrorMessage, -- Message text.
            @ErrorSeverity, -- Severity.
            @ErrorState -- State.
            );

END CATCH
GO



PRINT @@ERROR+1
BEGIN TRY
PRINT @@ERROR +2
    -- Generate a divide-by-zero error.
    SELECT 1/0;
    PRINT @@ERROR +3
END TRY
--PRINT @@ERROR
BEGIN CATCH
PRINT @@ERROR
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
 


PRINT '123'
SELECT '123'
GO






BEGIN TRY

	SELECT 1
	
	BEGIN TRAN -- 开始事务
	SELECT 2/0
	IF (@@TRANCOUNT > 0)
	BEGIN
		SELECT 3
		COMMIT TRAN -- 提交事务
	END
END TRY
BEGIN CATCH
	SELECT 4
	IF (@@TRANCOUNT > 0)
	BEGIN
		SELECT 5
		ROLLBACK TRAN  -- 出错，则回滚事务
	END
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	-- SELECT @ErrorMessage, @ErrorSeverity, @ErrorState
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
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
-- Author:		xx
-- Create date: 2012-12-08
-- Description:	存储过程的说明与描述（如：存储过程模版）

-- Modify [1]:  xx, 2012-12-09, 简化存储过程模版
-- Modify [2]:  xx, 2012-12-10, 优化存储过程模版
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



--------------------------------------------------------------------------start

USE xx
GO
IF(OBJECT_ID('rp_xx','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_xx AS BEGIN SELECT 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		xx
-- Create date: xx
-- Description:	xx
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_xx]
(
	@i_wfcode VARCHAR(20)				-- 哪个流程推送
	, @o_abhm_nbr VARCHAR(20) OUTPUT	-- 返回付款单号
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;	
	/*
	-- 调试数据
	DECLARE @i_wfcode VARCHAR(20);
	DECLARE @o_abhm_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	SET @i_wfcode = 'xx05';
	*/
	SET @o_rntStr = 'OK';
	
	IF (xx = 0 OR xx IS NULL)
	BEGIN -- 关联单据为空
		SET @o_rntStr = '提示错误！';
	END
	--do something
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH
GO


----------------------------------------
USE xx
GO
IF(OBJECT_ID('rp_xx','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_xx AS BEGIN SELECT 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		xx
-- Create date: xx
-- Description:	获取最大值
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_xx]
(
	@i_nbrtb VARCHAR(50)		-- 表名
	, @i_nbrfld VARCHAR(50)		-- 段名
	, @o_nbr VARCHAR(20) OUTPUT	-- 返回值
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_nbrtb VARCHAR(50) = 'xx_m';
	--DECLARE @i_nbrfld VARCHAR(50) = 'xx_nbr';
	--DECLARE @o_nbr VARCHAR(20);
	
	DECLARE @left VARCHAR(10)='临时-12';			-- '临时-' + 年月
	DECLARE @curidx VARCHAR(4)='0001';			-- 返回的流水号                           			-- 
	--do something
	SET @o_nbr = @left + @curidx;
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
GO


-- 1.列出使用库名
USE [FIDB]
GO
--drop FUNCTION rf_fi_dept_budget
-- 2.添加新增函数的判断
IF (OBJECT_ID('rf_fi_dept_budget') IS NULL)
BEGIN
    --EXEC ('CREATE FUNCTION rf_fi_dept_budget() RETURNS INT AS BEGIN RETURN 1; END');
    -- 表值函数时
     EXEC ('CREATE FUNCTION rf_fi_dept_budget() RETURNS @temp_table TABLE( ID int primary key NOT NULL) AS BEGIN RETURN ; END');
END
GO

-- 3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

-- 4.填写函数的基本信息
-- =========================================================================================
-- Author:		zhoupan
-- Create date: 2016-03-14
-- Description:	计算部门预算
-- =========================================================================================

-- 5.在创建函数时，对象名按命名规范（rf_两个字母的模块英文缩写_函数功能标识）
ALTER FUNCTION [dbo].[rf_fi_dept_budget]
(										-- 6.参数变量用( )括起来，每个一行
    @i_dept_code VARCHAR(20),			-- 部门代码
    @i_fmonth VARCHAR(10),				-- 财月
    @i_item_id INT,					    -- 科目id 
    @i_dept_right VARCHAR(100)          --部门权限代码
)
RETURNS @PPI_RULER_TABLE TABLE				-- 7.返回数据类型（表值函数请使用'多语句表值函数'代替'内联表值函数'）
(
	[ppi_dept_name] VARCHAR(50),			-- 部门代码
	[ppi_ruler_sum] DECIMAL(18,4),			-- 累计预算余额
	[ppi_ruler]  DECIMAL(18,4)				-- 年预算余额
)
--WITH SCHEMABINDING		-- 8.如SQL查询语句中所有对象都是同一个数据库，则需加上SCHEMABINDING
AS
BEGIN

	--9.定义函数的入口参数(方便调试，发布时要注释)。每个一行
	/*
	
	SELECT FIDB.dbo.rf_fi_dept_budget('011024','2015F12',18)
    DECLARE @i_dept_code VARCHAR(20)='011024';			-- 部门代码 
    DECLARE @i_fmonth VARCHAR(10)='2015F12';			-- 财月
    DECLARE @i_item_id INT=18;							-- 科目id 
	*/
	DECLARE @ppi_ruler DECIMAL(18,4);					-- ppi年规划值
	DECLARE @ppi_ruler_sum DECIMAL(18,4);				-- ppi累计规划
	DECLARE @ppi_now_dept VARCHAR(20);					-- ppi部门中间变量
	DECLARE @ppi_upper_dept VARCHAR(20);				-- ppi上级部门
	DECLARE @ppi_id INT;								-- ppi指标ID
	DECLARE @cttn_amr	DECIMAL(18,4);					-- 分摊部门金额合计
	DECLARE @ppi_dept_name VARCHAR(50);					-- 目标部门名称
	
	DECLARE @DEPT TABLE									-- 权限临时表
	(
		[code] varchar(10)
    )
	
	INSERT into @DEPT(code) SELECT val FROM  fidb.dbo.rf_fi_SplitToTable(@i_dept_right,',')
	
	-- 查询目标PPI规划	
	SELECT @ppi_ruler = m.ppim_ruler
	FROM HSRP.dbo.thr_ppi_m m
	INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
	INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
	WHERE item.item_id=@i_item_id AND m.PPIM_CODE = @i_dept_code
	AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 

	
	-- 中间变量赋值
	SET @ppi_upper_dept = '';
	SET @ppi_now_dept = @i_dept_code;
	
	-- 目标PPI规划为空，寻找上级部门PPI规划
	WHILE(@ppi_ruler IS NULL AND  @i_dept_code != @ppi_upper_dept)
	BEGIN
		-- 初始化
		SET @ppi_upper_dept = '';
		-- 查询上级部门code
		SELECT TOP 1 @ppi_upper_dept=cc_code 
		FROM FIDB.dbo.v_fi_dept dept
		WHERE (SELECT cc_level FROM FIDB.dbo.v_fi_dept WHERE cc_code=@ppi_now_dept) LIKE dept.cc_level+'%'
		AND cc_level <> '' AND cc_code <> @ppi_now_dept
		ORDER BY cc_level DESC
		
		IF(@ppi_upper_dept IS NULL OR @ppi_upper_dept = '')
		BEGIN
			SET @i_dept_code = @ppi_now_dept;
			BREAK;
		END
		
		-- 查询上级部门预算
		SELECT @ppi_ruler = m.ppim_ruler
		FROM HSRP.dbo.thr_ppi_m m
		INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
		INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
		WHERE item.item_id=@i_item_id AND m.PPIM_CODE = @ppi_upper_dept
		AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 
		
		-- 中间变量赋值
		SET @ppi_now_dept = @ppi_upper_dept;
		
		IF(@ppi_ruler IS NOT NULL)
		BEGIN
			-- 赋值
			SET @i_dept_code = @ppi_upper_dept;
		END
	END

	-- 目标部门PPI年规划值 ,累计规划值	
	SELECT @ppi_ruler=ISNULL(m.ppim_ruler,0),@ppi_ruler_sum=ISNULL(pd.ppid_ruler_sum,0)
	FROM HSRP.dbo.thr_ppi_m m
	INNER JOIN HSRP.dbo.thr_ppi_d pd ON pd.PPID_PPIM_ID = m.PPIM_ID
	INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
	INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
	WHERE item.item_id=@i_item_id AND pd.PPID_TIME = @i_fmonth
	AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 
	AND m.PPIM_RULER IS NOT NULL AND m.PPIM_CODE = @i_dept_code 
	
	-- 目标部门已支出金额(本币)
	SELECT @cttn_amr=ISNULL(SUM(cttn.CTTN_AMT * cttn.cttn_rate),0)
	FROM FIDB.dbo.tfi_cost_allocation cttn
	LEFT JOIN FIDB.dbo.tfi_reimbursement m ON m.RMMT_ID = cttn.CTTN_RMMD_ID
	LEFT JOIN FIDB.dbo.v_fi_dept dept ON dept.cc_code = cttn.CTTN_DEPT
	WHERE m.RMMT_STATUS = 6 
	AND dept.cc_level LIKE (SELECT o.cc_level FROM FIDB.dbo.v_fi_dept o WHERE o.cc_code=@i_dept_code) +'%' 
	AND m.rmmt_applicant_date <= (SELECT mEndtime FROM HPORTAL.dbo.contrast_monthf WHERE fMonth=@i_fmonth) 
	AND m.rmmt_applicant_date >= (SELECT mBegdate FROM HPORTAL.dbo.contrast_monthf WHERE fMonth=(LEFT(@i_fmonth,5)+'01'))
	
	-- 目标部门名称
	SELECT @ppi_dept_name = cc_full
	FROM FIDB.dbo.v_fi_dept WHERE cc_code = @i_dept_code
	--AND CHARINDEX(','+dept.cc_level+',',','+@ppi_dept_level+',')>0
	
	IF EXISTS(select 1 from fidb.dbo.v_fi_dept a 
				inner join (select cc_level from  FIDB.dbo.v_fi_dept where cc_code in (select code from @DEPT)) b on a.cc_level like rtrim(b.cc_level)+'%' 
				where a.cc_code=@i_dept_code)

	BEGIN
	-- 插入部门名称、累计预算余额、年预算余额
		INSERT INTO @PPI_RULER_TABLE VALUES (@ppi_dept_name,@ppi_ruler_sum - @cttn_amr,@ppi_ruler - @cttn_amr)
	END
	ELSE 
	BEGIN
		INSERT INTO @PPI_RULER_TABLE VALUES ('',NULL,NULL)

	END

	RETURN ;
END

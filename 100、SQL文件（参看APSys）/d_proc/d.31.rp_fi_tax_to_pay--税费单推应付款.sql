USE FIDB
GO

IF(OBJECT_ID('rp_fi_tax_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_tax_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		fengxd
-- Create date: 2018-08-07
-- Description:	应交税费单：缴费方式为'自缴'时,审批通过后推应付款
-- =========================================================================================
ALTER PROCEDURE rp_fi_tax_to_pay
(
	@i_mid INT
	, @o_paym_id INT = 0 OUTPUT				-- 返回应付单id
	, @o_paym_nbr VARCHAR(20) = '' OUTPUT	-- 返回应付单号
	, @o_rntStr VARCHAR(800) = '' OUTPUT	-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	
	DECLARE @nbr_type TINYINT            -- 单据类型 1:应付;2:其它应付;3:应收;4:其它应收.
	DECLARE @twf_code VARCHAR(20)        -- 流程code (原单据)
	DECLARE @paym_emp VARCHAR(20)        -- 申请人
	DECLARE @paym_dept VARCHAR(20)       -- 申请部门code
	DECLARE @paym_duty INT               -- 申请人岗位
	DECLARE @paym_due_date DATETIME      -- 应付日期
	DECLARE @paym_paycode_type TINYINT   -- 对方类型 1:供应商;2:个人;3:客户;101:法人
	DECLARE @paym_pay_code VARCHAR(20)   -- 对方代码 
	DECLARE @paym_legal INT              -- 应收/应付法人 
	DECLARE @paym_currency VARCHAR(10)   -- 币别(必须是标准币别)
	DECLARE @paym_rate DECIMAL(19, 7)    -- 汇率
	DECLARE @paym_amt MONEY              -- 应付金额
	DECLARE @paym_pay_type TINYINT       -- 支付方式 1: 现金；2：转账
	DECLARE @paym_pay_bank VARCHAR(100)  -- 开户行(对方)
	DECLARE @paym_pay_name VARCHAR(100)  -- 开户名(对方)
	DECLARE @paym_pay_nbr VARCHAR(50)    -- 开户账号(对方)
	DECLARE @paym_admin_type INT         -- 往来方类型 1:供应商;2:个人;3:客户;4:部门; (一般都是4类型)
	DECLARE @paym_admin_dept VARCHAR(20) -- 往来方编码（应收/应付部门编码）
	DECLARE @paym_admin_desc VARCHAR(200)-- 往来方名称（应收/应付部门名称）
	DECLARE @paym_duty_emp VARCHAR(20)   -- 往来责任人 (没有的取申请人)
	DECLARE @paym_rmks VARCHAR(800)      -- 备注
	DECLARE @paym_ref_id INT             -- 关联单号id (原单据mid)
	DECLARE @paym_ref_did INT            -- 关联单号did (原单据did,整张单的0)
	DECLARE @paym_ref_nbr VARCHAR(20)    -- 关联单号 (原单据nbr)
	DECLARE @acctid INT                  -- acctid
	DECLARE @paym_date DATETIME = NULL   -- 业务发生日期
	DECLARE @paym_pay_deptcode VARCHAR(20) = ''  -- 内部法人交易部门(对方部门)
	
	SET @o_rntStr = 'OK';
	
	IF NOT EXISTS(SELECT 1 FROM FIDB.dbo.tfi_tax_admin_m WHERE ttam_id = @i_mid AND 1=ISNULL(ttam_pay_way,'') AND ttam_status = 6)
	BEGIN
		-- ttam_pay_way(0/null:扣费；1:自缴.)
		-- 缴费方式为'自缴'时,审批通过后推应付款,否则 RETURN
	   	RETURN;
	END
	
	SELECT -- 设置参数
		 @nbr_type = 1						-- 单据类型1:应付;2:其它应付;3:应收;4:其它应收.
       , @twf_code = LEFT(ttam.ttam_nbr,4)  -- 流程code
       , @paym_emp = ttam.ttam_emp			-- 申请人
       , @paym_dept = ttam.ttam_dept		-- 申请部门code
       , @paym_duty = ttam.ttam_duty        -- 申请人岗位
       , @paym_due_date = ttam.ttam_date    -- 应付日期
       , @paym_paycode_type = 5				-- 对方类型 1:供应商;2:个人;3:客户,5其他;101:法人
       , @paym_pay_code = ttam.ttam_payee	-- 对方代码
       , @paym_legal = ttam.ttam_legal      -- 应付法人
       , @paym_currency = UPPER(ttam.ttam_currency) -- 币别
       , @paym_rate = ttam.ttam_rate		-- 汇率
       , @paym_amt = ttam.ttam_tax_amt+ttam.ttam_late_fee+ttam.ttam_penalty	-- 应付金额
       , @paym_pay_type = 2					-- 支付方式1: 现金；2：转账
       , @paym_pay_bank = ttam.ttam_payee_bank	-- 开户行
       , @paym_pay_name = fpi.pay_fname			-- 开户名
       , @paym_pay_nbr = ttam.ttam_payee_acct	-- 开户账号
       , @paym_admin_type = 4					-- 往来方类型1:供应商;2:个人;3:客户;4:部门;
       , @paym_admin_dept = ttam.ttam_dept	-- 往来方编码
       , @paym_admin_desc = dept.cc_desc	-- 往来方名称
       , @paym_duty_emp = ttam.ttam_emp		-- 往来责任人
       , @paym_rmks = ttam_rmks				-- 备注
       , @paym_ref_id = ttam.ttam_id		-- 关联单号id
       , @paym_ref_did =0					-- 关联单号did
       , @paym_ref_nbr = ttam.ttam_nbr		-- 关联单号
       , @acctid = ttam.acctid
	FROM FIDB.dbo.tfi_tax_admin_m ttam
	LEFT JOIN HR90.dbo.cc_mstr1 dept ON dept.cc_code = ttam.ttam_dept
	LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.pay_code = ttam.ttam_payee
	WHERE ttam.ttam_id = @i_mid;
	
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--生成应付单
		IF (@paym_amt <> 0)
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2 
				  @nbr_type
				, @twf_code
				, @paym_emp
				, @paym_dept
				, @paym_duty
				, @paym_due_date
				, @paym_paycode_type
				, @paym_pay_code
				, @paym_legal
				, @paym_currency
				, @paym_rate
				, @paym_amt
				, @paym_pay_type
				, @paym_pay_bank
				, @paym_pay_name
				, @paym_pay_nbr
				, @paym_admin_type
				, @paym_admin_dept
				, @paym_admin_desc
				, @paym_duty_emp
				, @paym_rmks
				, @paym_ref_id
				, @paym_ref_did
				, @paym_ref_nbr
				, @acctid
				, @o_paym_id OUTPUT
				, @o_paym_nbr OUTPUT
				, @o_rntStr OUTPUT;
		END
	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成应付单！';
	END
	IF @o_rntStr <> 'OK'
	BEGIN
		RAISERROR (@o_rntStr, 16, 1); 
	END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
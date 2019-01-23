USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_gl_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_gl_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2014-12-19
-- Description:	预提单做付款通知单时先写应付数据
-- =========================================================================================
ALTER PROCEDURE rp_fi_gl_to_pay
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
	
	DECLARE @paym_item VARCHAR(20);			-- 会计科目
	DECLARE @paym_typm_id INT;				-- 应付类型mid
	DECLARE @paym_typd_id INT;				-- 应付类型did
	DECLARE @paym_flag TINYINT;				-- 1蓝字2红字
	DECLARE @paym_emp VARCHAR(20);			-- 申请人
	DECLARE @paym_dept VARCHAR(20);			-- 申请部门code
	DECLARE @paym_duty INT;					-- 申请人岗位
	DECLARE @paym_due_date DATETIME;		-- 应付日期
	DECLARE @paym_paycode_type TINYINT;		-- 对方类型 1供应商2个人
	DECLARE @paym_pay_code VARCHAR(20);		-- 对方代码
	DECLARE @paym_legal INT;				-- 应付法人
	DECLARE @paym_currency VARCHAR(10);		-- 币别
	DECLARE @paym_rate DECIMAL(19, 7);		-- 汇率
	DECLARE @paym_amt MONEY;				-- 应付金额
	DECLARE @paym_pay_type TINYINT;			-- 支付方式
	DECLARE @paym_pay_bank VARCHAR(100);	-- 开户行
	DECLARE @paym_pay_name VARCHAR(100);	-- 开户名
	DECLARE @paym_pay_nbr VARCHAR(50);		-- 开户账号
	DECLARE @paym_admin_dept VARCHAR(20);	-- 责任部门
	DECLARE @paym_duty_emp VARCHAR(20);		-- 责任人
	DECLARE @paym_rmks VARCHAR(200);		-- 备注
	DECLARE @paym_ref_id INT;				-- 关联单号id
	DECLARE @paym_ref_nbr VARCHAR(20);		-- 关联单号
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- 是否启用ACCTID
	
	SET @o_rntStr = 'OK';
	
	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	SELECT -- 设置参数
		@paym_item = ''
		, @paym_typm_id = ttd.typd_typm_id
		, @paym_typd_id = ttd.typd_id
		, @paym_flag = 1
		, @paym_emp = glpm.glpm_applicant
		, @paym_dept = glpm.glpm_dept
		, @paym_duty = glpm.glpm_duty
		, @paym_due_date = CONVERT(VARCHAR(10), DATEADD(DAY, 2, GETDATE()), 23)
		, @paym_paycode_type = glpm.glpm_objtype
		, @paym_pay_code = glpm.glpm_objcode
		, @paym_legal = (SELECT TOP(1)glpd_legal FROM FIDB.dbo.tfi_gl_preamz_d tgpd WHERE tgpd.glpd_glpm_id=@i_mid)
		, @paym_currency = glpm.glpm_curr
		, @paym_rate = hportal.dbo.rf_ba_getRate(glpm.acctid,glpm.glpm_curr, 'RMB', GETDATE())
		, @paym_amt = glpm.glpm_amt - ISNULL((SELECT SUM(ISNULL(paym_amt,0)) FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_nbr = glpm.glpm_nbr AND paym_ref_id = glpm.glpm_id AND isenable=0),0)
		, @paym_pay_type = 1
		, @paym_pay_bank = ''
		, @paym_pay_name = ''
		, @paym_pay_nbr = ''
		, @paym_admin_dept = glpm.glpm_dept
		, @paym_duty_emp = glpm.glpm_applicant
		, @paym_rmks = glpm.glpm_remark
		, @paym_ref_nbr = glpm.glpm_nbr
		, @paym_ref_id = glpm.glpm_id
		, @acctid = glpm.acctid
	FROM FIDB.dbo.tfi_gl_preamz_m glpm
	INNER JOIN FIDB.dbo.tfi_type_d ttd ON ttd.typd_wfm_code = LEFT(glpm.glpm_nbr, 4) AND EXISTS (
		SELECT 1 FROM FIDB.dbo.tfi_type_m ttm WHERE ttm.typm_id = ttd.typd_typm_id AND ttm.typm_attribute = 1 AND ttm.isenable = 1
	) AND ttd.acctid = (CASE WHEN @acctid_ctl = 1 THEN glpm.acctid ELSE ttd.acctid END)
	WHERE glpm.glpm_id = @i_mid;
				
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--生成应付单
		IF NOT EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_nbr=@paym_ref_nbr AND tpm.paym_ref_id=@paym_ref_id AND tpm.isenable=1)
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apac
				1
				, @paym_item
				, @paym_typm_id
				, @paym_typd_id
				, @paym_flag
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
				, @paym_admin_dept
				, @paym_duty_emp
				, @paym_rmks
				, @paym_ref_id
				, @paym_ref_nbr
				, @acctid
				, @o_paym_id OUTPUT
				, @o_paym_nbr OUTPUT
				, @o_rntStr OUTPUT;
			--IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_nbr=@paym_ref_nbr AND tpm.paym_ref_id=@paym_ref_id AND tpm.paym_id <> @o_paym_id)
			--BEGIN
			--	DECLARE @paym_split_sort INT;
				
			--	SELECT TOP(1) @paym_split_sort=tpm.paym_split_sort
			--	FROM FIDB.dbo.tfi_pay_m tpm 
			--	WHERE tpm.paym_ref_nbr=@paym_ref_nbr AND tpm.paym_ref_id=@paym_ref_id AND tpm.paym_id <> @o_paym_id
			--	ORDER BY tpm.addtime DESC;
			--	IF @paym_split_sort IS NULL
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = 1 WHERE paym_ref_nbr=@paym_ref_nbr AND paym_ref_id=@paym_ref_id AND paym_id <> @o_paym_id
			--		UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = 2 WHERE paym_id = @o_paym_id
			--	END
			--	ELSE
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort=@paym_split_sort+1 WHERE paym_id = @o_paym_id
			--	END
			--END
		END
		ELSE
		BEGIN
			SELECT @o_paym_id=paym_id,@o_paym_nbr=paym_nbr,@o_rntStr='OK'
			FROM FIDB.dbo.tfi_pay_m
			WHERE paym_ref_nbr=@paym_ref_nbr AND paym_ref_id=@paym_ref_id AND isenable=1
			
			--UPDATE FIDB.dbo.tfi_pay_m SET paym_amt = @paym_amt
			--WHERE paym_id=@o_paym_id
		END
	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成应付单！';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
USE [FIDB]
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_inam_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_inam_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2018-07-06
-- Description:	内部法人对账单审核通过后生成应付单
-- =========================================================================================
ALTER PROCEDURE rp_fi_inam_to_pay
(
	@i_mid INT
	, @i_twf_code VARCHAR(20)				-- 流程编码
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	DECLARE @paym_emp VARCHAR(20);			-- 申请人
	DECLARE @paym_dept VARCHAR(20);			-- 申请部门code
	DECLARE @paym_duty INT;					-- 申请人岗位
	DECLARE @paym_date DATETIME;		-- 发生日期
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
	DECLARE @paym_admin_type INT;			-- 往来方类型
	DECLARE @paym_admin_dept VARCHAR(20);	-- 往来方编码
	DECLARE @paym_admin_desc VARCHAR(200);	-- 往来方名称
	DECLARE @paym_duty_emp VARCHAR(20);		-- 往来责任人
	DECLARE @paym_rmks VARCHAR(800);		-- 备注
	DECLARE @paym_ref_id INT;				-- 关联单号id
	DECLARE @paym_ref_did INT;
	DECLARE @paym_ref_nbr VARCHAR(20);		-- 关联单号
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- 是否启用ACCTID
	DECLARE @o_paym_id INT;
	DECLARE @o_paym_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	DECLARE @inner_dept_code VARCHAR(20);
	DECLARE @inam_type INT;
	
	SET @o_rntStr = 'OK';

	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	SELECT -- 设置参数
	    @inam_type = inam.inam_type
		, @paym_emp = inam.inam_emp
		, @paym_dept = inam.inam_dept
		, @paym_duty = inam.inam_duty
		, @paym_date = inam.inam_date 
		, @paym_due_date = inam.inam_pay_date  
		, @paym_paycode_type = inam.inam_othercode_type
		, @paym_pay_code = (CASE WHEN inam_type = 0 THEN inam.inam_other_code ELSE inam.inam_pay_code END)
		, @paym_legal = (CASE WHEN inam_type = 0 THEN finc1.ficn_id ELSE finc2.ficn_id END)
		, @paym_currency = inam.inam_currency
		, @paym_rate = inam.inam_rate
		, @paym_amt = inam.inam_amt
		, @paym_pay_type = 2
		, @paym_pay_bank = (CASE WHEN inam_type = 0 THEN code2.code_name ELSE code1.code_name END)
		, @paym_pay_name = (CASE WHEN inam_type = 0 THEN finc2.ficn_name ELSE finc1.ficn_name END)
		, @paym_pay_nbr = (CASE WHEN inam_type = 0 THEN acct2.acct_code ELSE acct1.acct_code END)
		, @paym_admin_type = 4
		, @paym_admin_dept = (CASE WHEN inam_type = 0 THEN acct1.acct_department ELSE acct2.acct_department END)
		, @paym_admin_desc = (CASE WHEN inam_type = 0 THEN dept1.cc_desc ELSE dept2.cc_desc END)
		, @paym_duty_emp = inam.inam_emp
		, @paym_rmks = inam.inam_rmks
		, @paym_ref_nbr = inaa.wfna_nbr
		, @paym_ref_id = inam.inam_id
		, @paym_ref_did = 0
		, @acctid = inam.acctid
		, @inner_dept_code = (CASE WHEN inam_type = 0 THEN acct2.acct_department ELSE acct1.acct_department END)
	FROM dbo.tfi_inner_account_m inam
	INNER JOIN FIDB.dbo.tfi_inner_account_a inaa ON inam.inam_id = inaa.wfna_m_id
	INNER JOIN FIDB.dbo.VFI_CORPORATION finc1 ON finc1.ficn_code = inam.inam_pay_code
	INNER JOIN FIDB.dbo.VFI_CORPORATION finc2 ON finc2.ficn_code = inam.inam_other_code
	INNER JOIN FIDB.dbo.tfi_account acct1 ON acct1.ACCT_ID = inam.inam_pay_acct_id
	INNER JOIN FIDB.dbo.tfi_account acct2 ON acct2.ACCT_ID = inam.inam_other_acct_id
	LEFT JOIN FIDB.dbo.v_fi_tbacode code2 ON code2.code_type = 'acct_bank' AND acct2.acct_bank = code2.code_code
	LEFT JOIN FIDB.dbo.v_fi_tbacode code1 ON code1.code_type = 'acct_bank' AND acct1.acct_bank = code1.code_code
	LEFT JOIN FIDB.dbo.v_fi_dept dept1 ON dept1.cc_code = acct1.acct_department
	LEFT JOIN FIDB.dbo.v_fi_dept dept2 ON dept2.cc_code = acct2.acct_department
	WHERE inam.inam_id = @i_mid;
	
	declare @paym_pay_code_ver varchar(100)
	declare @paym_legal_ver int
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--生成应付单
		IF (@paym_amt <> 0 AND @inam_type = 0)
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2
				1
				, @i_twf_code
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
				, @o_rntStr OUTPUT
				, @paym_date
				, @inner_dept_code;
			
			--保存一笔法人应收
			select @paym_legal_ver=ficn_id from FIDB.dbo.VFI_CORPORATION where ficn_code=@paym_pay_code and acctid=@acctid
			select @paym_pay_code_ver=ficn_id from FIDB.dbo.VFI_CORPORATION where ficn_id=@paym_legal and acctid=@acctid
			
			EXEC FIDB.dbo.rp_fi_add_apacV2
				3
				, @i_twf_code
				, @paym_emp
				, @paym_dept
				, @paym_duty
				, @paym_due_date
				, @paym_paycode_type
				, @paym_pay_code_ver
				, @paym_legal_ver
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
				, @o_rntStr OUTPUT
				, @paym_date
				, @inner_dept_code;
		END
		ELSE IF((@paym_amt <> 0 AND @inam_type = 1))
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2
				3
				, @i_twf_code
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
				, @o_rntStr OUTPUT
				, @paym_date
				, @inner_dept_code;
				
			--保存一笔法人应收
			select @paym_legal_ver=ficn_id from FIDB.dbo.VFI_CORPORATION where ficn_code=@paym_pay_code and acctid=@acctid
			select @paym_pay_code_ver=ficn_id from FIDB.dbo.VFI_CORPORATION where ficn_id=@paym_legal and acctid=@acctid
			
			EXEC FIDB.dbo.rp_fi_add_apacV2
				1
				, @i_twf_code
				, @paym_emp
				, @paym_dept
				, @paym_duty
				, @paym_due_date
				, @paym_paycode_type
				, @paym_pay_code_ver
				, @paym_legal_ver
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
				, @o_rntStr OUTPUT
				, @paym_date
				, @inner_dept_code;
		END
	END
	ELSE
	BEGIN 
		SET @o_rntStr = '无法生成应收应付数据！';
	END
	IF(@o_rntStr <> 'OK')
	BEGIN
		RAISERROR(@o_rntStr, 16, 1);
	END
	
END TRY
BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	
END CATCH

GO
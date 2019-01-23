USE [FIDB]
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_bx_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_bx_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-06
-- Description:	报销单审核通过后生成应付单
-- Modify[1]:申请人离职时的特殊情况处理 by liuxiang
-- Modify[2]: 2014-04-23 liuxiang 调整离职人员的逻辑，将逻辑放入到生成付款通知单中
-- Modify[3]: 传应付单的金额计算逻辑修改且增加金额为0时不传应付单 by liuxiang at 2014-09-15
-- =========================================================================================
ALTER PROCEDURE rp_fi_bx_to_pay
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
	DECLARE @twf_code VARCHAR(20);			-- 流程code
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
	DECLARE @paym_admin_type INT;			-- 往来方类型
	DECLARE @paym_admin_dept VARCHAR(20);	-- 往来方编码
	DECLARE @paym_admin_desc VARCHAR(200);	-- 往来方名称
	DECLARE @paym_duty_emp VARCHAR(20);		-- 往来责任人
	DECLARE @paym_rmks VARCHAR(200);		-- 备注
	DECLARE @paym_ref_id INT;				-- 关联单号id
	DECLARE @paym_ref_did INT;
	DECLARE @paym_ref_nbr VARCHAR(20);		-- 关联单号
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- 是否启用ACCTID
	
	SET @o_rntStr = 'OK';
	
	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	
	IF OBJECT_ID('tempdb..#temp_rmmt_topay') IS NOT NULL 
	DROP TABLE #temp_rmmt_topay; 
 
	SELECT 
	twf_code = LEFT(tr.RMMT_NBR, 4)
	, paym_emp = (CASE WHEN tr.RMMT_ADSCRIPTION = 1 THEN tr.RMMT_APPLICANT ELSE tr.RMMT_USER_NO END)
	, paym_dept = tr.RMMT_DEPT
	, paym_duty = tr.RMMT_APPLY_DUTY_ID
	, paym_due_date = GETDATE()
	, paym_paycode_type = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 
							THEN (CASE WHEN isnull(rmmt_rec_code,'')<>'' THEN rmmt_rec_type ELSE ISNULL(tr.rmmt_obj_type,2) END) 
							ELSE (CASE WHEN rmmt_gl_type = 2 THEN d.rmmd_contacts_otype ELSE d.rmmd_contacts_rtype END) END)
	, paym_pay_code = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 
						THEN (CASE WHEN isnull(rmmt_rec_code,'')<>'' THEN rmmt_rec_code ELSE tr.rmmt_obj_code END) 
						ELSE (CASE WHEN rmmt_gl_type = 2 THEN d.rmmd_contacts_ocode ELSE d.rmmd_contacts_rcode END) END)
	, paym_legal = tr.RMMT_LEGAL
	, paym_currency = tr.RMMT_CURR_TYPE
	, paym_rate = tr.RMMT_RATE
	, paym_amt = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 THEN tr.RMMT_APPROVED-(ISNULL(tr.RMMT_PAYMENT_R,0)/tr.rmmt_rate) ELSE d.rmmd_pay_oamt END)
	, paym_pay_type = tr.RMMT_PAY_TYPE
	, paym_pay_bank = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 THEN tr.RMMT_REC_BANK ELSE d.rmmd_rec_bank END)
	, paym_pay_name = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 THEN tr.RMMT_REC_COMPANY ELSE d.rmmd_rec_company END)
	, paym_pay_nbr = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 THEN tr.RMMT_REC_ACCT ELSE d.rmmd_rec_acct END)
	, paym_admin_type = 4
	, paym_admin_dept = tr.RMMT_DEPT
	, paym_admin_desc = (SELECT dept.cc_desc  FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = tr.RMMT_DEPT )
	, paym_duty_emp = (CASE WHEN tr.RMMT_ADSCRIPTION = 1 THEN tr.RMMT_APPLICANT ELSE tr.RMMT_USER_NO END)
	, paym_rmks = tr.RMMT_BRIEF
	, paym_ref_nbr = tr.RMMT_NBR
	, paym_ref_id = tr.RMMT_ID
	, paym_ref_did = ISNULL(d.rmmd_id, 0)
	, acctid = tr.ACCTID
	INTO #temp_rmmt_topay
	FROM FIDB.dbo.TFI_REIMBURSEMENT tr
	LEFT JOIN FIDB.dbo.tfi_reimbursement_d d ON tr.RMMT_ID = d.rmmd_rmmt_id
	INNER JOIN FIDB.dbo.tfi_type_d ttd ON ttd.typd_wfm_code = LEFT(tr.RMMT_NBR, 4) 
	AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_type_m ttm WHERE ttm.typm_id = ttd.typd_typm_id AND ttm.typm_attribute = 1 AND ttm.isenable = 1)
	AND ttd.acctid = (CASE WHEN @acctid_ctl = 1 THEN tr.acctid ELSE ttd.acctid END)
	WHERE RMMT_ID = @i_mid;
	
	DECLARE @control_bx_to_pay VARCHAR(10);
	SET @control_bx_to_pay = '1';
	SELECT @control_bx_to_pay = code.code_code FROM FIDB.dbo.v_fi_tbacode code WHERE code.code_type='control_bx_to_pay'
	
	WHILE EXISTS(SELECT 1 FROM #temp_rmmt_topay)
	BEGIN
		SELECT TOP(1)
		@twf_code = twf_code
		, @paym_emp = paym_emp
		, @paym_dept = paym_dept
		, @paym_duty = paym_duty
		, @paym_due_date = paym_due_date 
		, @paym_paycode_type = paym_paycode_type
		, @paym_pay_code = paym_pay_code
		, @paym_legal = paym_legal
		, @paym_currency = paym_currency
		, @paym_rate = paym_rate
		, @paym_amt = paym_amt
		, @paym_pay_type = paym_pay_type
		, @paym_pay_bank = paym_pay_bank
		, @paym_pay_name = paym_pay_name
		, @paym_pay_nbr = paym_pay_nbr
		, @paym_admin_type = paym_admin_type
		, @paym_admin_dept = paym_admin_dept
		, @paym_admin_desc = paym_admin_desc
		, @paym_duty_emp = paym_duty_emp
		, @paym_rmks = paym_rmks
		, @paym_ref_nbr = paym_ref_nbr
		, @paym_ref_id = paym_ref_id
		, @paym_ref_did = paym_ref_did
		, @acctid = acctid
		FROM #temp_rmmt_topay
		
		IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
		BEGIN
			--生成应付单
			IF (@paym_amt <> 0 AND @control_bx_to_pay = '1')
			BEGIN
				EXEC FIDB.dbo.rp_fi_add_apacV2
					2
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
		
		DELETE FROM #temp_rmmt_topay WHERE paym_ref_id = @paym_ref_id AND paym_ref_did = @paym_ref_did
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
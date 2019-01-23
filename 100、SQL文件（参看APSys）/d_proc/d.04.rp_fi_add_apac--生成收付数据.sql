USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_add_apac','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_apac AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-03
-- Description:	生成应付单并提交工作流
-- Modify[1]:   lzs 2013-11-20 增加采购对账单推送付款通知单逻辑
-- Modify[2]:   刘蔚 2014-2-13 增加销售对账单推送收款通知单逻辑
-- modify[3]:   刘蔚 增加旧版本销售对账单推送收款通知的逻辑
-- modify[4]:   lzs 2014-03-03 增加礼品退库单推送收款通知的逻辑
-- modify[5]:   lzs 2014-03-05 增加薪资发放推付款通知逻辑
-- modify[6]:   by liuxiang at 2014-10-03 增加票务及快递对账推付款通知逻辑及报销对象逻辑
-- modify[6]:   by liuxiang at 2014-11-18 修改根据报销对象推付款单逻辑
-- modify[7]:   by liuxiang at 2015-02-03 生成应收付数据前的校验增加法人比较
-- modify[8]:   by zhoupan at 2016-03-02 报销生成付款通知时，通过记账方式是否为挂账来判断
-- =========================================================================================
ALTER PROCEDURE rp_fi_add_apac 
(
	@i_nbr_type TINYINT					-- 单据类型 1应付2其它应付3应收4其它应收
	, @i_paym_item VARCHAR(20)			-- 会计科目
	, @i_paym_typm_id INT				-- 应付类型mid
	, @i_paym_typd_id INT				-- 应付类型did
	, @i_paym_flag TINYINT				-- 1蓝字2红字
	, @i_paym_emp VARCHAR(20)			-- 申请人
	, @i_paym_dept VARCHAR(20)			-- 申请部门code
	, @i_paym_duty INT					-- 申请人岗位
	, @i_paym_due_date DATETIME			-- 应付日期
	, @i_paym_paycode_type TINYINT		-- 对方类型 1供应商2个人
	, @i_paym_pay_code VARCHAR(20)		-- 对方代码
	, @i_paym_legal INT					-- 应付法人
	, @i_paym_currency VARCHAR(10)		-- 币别
	, @i_paym_rate DECIMAL(19, 7)		-- 汇率
	, @i_paym_amt MONEY					-- 应付金额
	, @i_paym_pay_type TINYINT			-- 支付方式
	, @i_paym_pay_bank VARCHAR(100)		-- 开户行
	, @i_paym_pay_name VARCHAR(100)		-- 开户名
	, @i_paym_pay_nbr VARCHAR(50)		-- 开户账号
	, @i_paym_admin_dept VARCHAR(20)	-- 责任部门
	, @i_paym_duty_emp VARCHAR(20)		-- 责任人
	, @i_paym_rmks VARCHAR(200)			-- 备注
	, @i_paym_ref_id INT				-- 关联单号id
	, @i_paym_ref_nbr VARCHAR(20)		-- 关联单号
	, @i_acctid INT						-- acctid
	, @o_paym_id INT OUTPUT				-- 返回应付单id
	, @o_paym_nbr VARCHAR(20) OUTPUT	-- 返回应付单号
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	-- 调试数据
	DECLARE @i_paym_item VARCHAR(20);
	DECLARE @i_paym_typm_id INT;
	DECLARE @i_paym_typd_id INT;
	DECLARE @i_paym_flag TINYINT;
	DECLARE @i_paym_emp VARCHAR(20);
	DECLARE @i_paym_dept VARCHAR(20);
	DECLARE @i_paym_duty INT;
	DECLARE @i_paym_due_date DATETIME;
	DECLARE @i_paym_paycode_type TINYINT;
	DECLARE @i_paym_pay_code VARCHAR(20);
	DECLARE @i_paym_legal INT;
	DECLARE @i_paym_currency VARCHAR(10);
	DECLARE @i_paym_rate DECIMAL(19, 7);
	DECLARE @i_paym_amt MONEY;
	DECLARE @i_paym_pay_type TINYINT;
	DECLARE @i_paym_pay_bank VARCHAR(100);
	DECLARE @i_paym_pay_name VARCHAR(100);
	DECLARE @i_paym_pay_nbr VARCHAR(50);
	DECLARE @i_paym_admin_dept VARCHAR(20);
	DECLARE @i_paym_duty_emp VARCHAR(20);
	DECLARE @i_paym_rmks VARCHAR(200);
	DECLARE @i_paym_ref_id INT;
	DECLARE @i_paym_ref_nbr VARCHAR(20);
	DECLARE @i_acctid INT;
	DECLARE @o_paym_id INT;
	DECLARE @o_paym_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @i_paym_item = '1';
	SET @i_paym_typm_id = 1;
	SET @i_paym_typd_id = 2;
	SET @i_paym_flag = 1;
	SET @i_paym_emp = '00000001';
	SET @i_paym_dept = '012213';
	SET @i_paym_duty = 10026;
	SET @i_paym_due_date = '2013-8-30';
	SET @i_paym_paycode_type = 2;
	SET @i_paym_pay_code = '00000001';
	SET @i_paym_legal = -2;
	SET @i_paym_currency = 'RMB';
	SET @i_paym_rate = 1.0;
	SET @i_paym_amt = 1000.0;
	SET @i_paym_pay_type = 0;
	SET @i_paym_pay_bank = '';
	SET @i_paym_pay_name = '';
	SET @i_paym_pay_nbr = '';
	SET @i_paym_admin_dept = '012213';
	SET @i_paym_duty_emp = '00000001';
	SET @i_paym_rmks = '业务费用报销单';
	SET @i_paym_ref_id = 151;
	SET @i_paym_ref_nbr = 'AC11-12030001';
	SET @i_acctid = 1;
	*/
	
	SET @o_rntStr = 'OK';
	
	DECLARE @spl_name VARCHAR(200); -- 对方名称
	
	IF (@i_paym_ref_id = 0 OR @i_paym_ref_id IS NULL OR @i_paym_ref_nbr = '' OR @i_paym_ref_nbr IS NULL)
	BEGIN -- 关联单据为空
		SET @o_rntStr = '关联单据为空，不能生成应付/应收单！';
	END
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id 
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal=@i_paym_legal AND paym_status <> 8)
	BEGIN -- 已存在应付单，不再生成应付单
		SET @o_rntStr = @i_paym_ref_nbr + '已存在应付/应收单！';
	END
	ELSE
	BEGIN -- 生成应付单
		SET @i_paym_amt = (CASE WHEN @i_paym_flag = 2 THEN ABS(@i_paym_amt) * -1 ELSE ABS(@i_paym_amt) END);
		SELECT @spl_name = pay_fname FROM v_fi_paycode_info WHERE ctype = @i_paym_paycode_type AND pay_code = @i_paym_pay_code;
		SET @i_paym_item = (CASE WHEN @i_nbr_type = 1 THEN '1' ELSE '3' END);
	
		INSERT INTO tfi_pay_m ( -- 插入主表begin
			paym_nbr
			, paym_item
			, paym_typm_id
			, paym_typd_id
			, paym_flag
			, paym_emp
			, paym_dept
			, paym_duty
			, paym_date
			, paym_due_date
			, paym_paycode_type
			, paym_pay_code
			, paym_spl_name
			, paym_legal
			, paym_currency
			, paym_rate
			, paym_amt
			, paym_real_amt
			, paym_pay_type
			, paym_pay_bank
			, paym_pay_name
			, paym_pay_nbr
			, paym_admin_dept
			, paym_duty_emp
			, paym_rmks
			, paym_status
			, paym_ref_nbr
			, paym_ref_id
			, adduser
			, acctid
			, paym_nbr_flag
		) VALUES (
			@i_paym_ref_nbr
			, @i_paym_item
			, @i_paym_typm_id
			, @i_paym_typd_id
			, @i_paym_flag
			, @i_paym_emp
			, @i_paym_dept
			, @i_paym_duty
			, CONVERT(VARCHAR(10), GETDATE(), 23)
			, @i_paym_due_date
			, @i_paym_paycode_type
			, @i_paym_pay_code
			, @spl_name
			, @i_paym_legal
			, @i_paym_currency
			, @i_paym_rate
			, @i_paym_amt
			, 0
			, @i_paym_pay_type
			, @i_paym_pay_bank
			, @i_paym_pay_name
			, @i_paym_pay_nbr
			, @i_paym_admin_dept
			, @i_paym_duty_emp
			, @i_paym_rmks
			, (CASE WHEN @i_nbr_type = 1 THEN 5 ELSE 9 END)
			, @i_paym_ref_nbr
			, @i_paym_ref_id
			, @i_paym_emp
			, @i_acctid
			, @i_nbr_type
		);
		SET @o_paym_id = @@identity; -- 插入主表end
		SET @o_paym_nbr = @i_paym_ref_nbr;
		
		-- 报销应付单回写报销单及生成付款通知（不含通用）
		IF EXISTS (SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ( ttd.typd_wfm_code = 'AC13'))
		BEGIN
			-- 生成付款通知（旧版）
			IF(@i_paym_paycode_type=2 
				OR (@i_paym_paycode_type=3 AND NOT EXISTS(SELECT 1 FROM HSAL.dbo.tsa_acct_m WHERE actm_cust=@i_paym_pay_code)) 
				OR (@i_paym_paycode_type=1 AND NOT EXISTS(SELECT 1 FROM HPUR.dbo.TPU_ACCT_M WHERE actm_spl_code=@i_paym_pay_code)))
				
			BEGIN
				EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
			END
			
			IF (@o_rntStr = 'OK')
			BEGIN
				-- 回写报销单已付金额
				UPDATE a SET a.RMMT_PAYMENT_R = ROUND(ISNULL(a.RMMT_PAYMENT_R, 0) + b.paym_amt * b.paym_rate, 2)
				FROM TFI_REIMBURSEMENT a
				INNER JOIN tfi_pay_m b ON b.paym_ref_id = a.rmmt_id AND LEFT(b.paym_ref_nbr, 13) = a.rmmt_nbr
				WHERE b.paym_id = @o_paym_id;
			END
		END
		
		-- 通用报销
		ELSE IF EXISTS (SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ( ttd.typd_wfm_code = 'AC11'  OR ttd.typd_wfm_code = 'AC12' OR ttd.typd_wfm_code = 'AC14'))
			
		BEGIN
			DECLARE @rmmt_loan DECIMAL(19,2);	-- 抵扣金额
			SELECT @rmmt_loan = tr.RMMT_LOAN + tr.rmmt_rec_loan
			  FROM FIDB.dbo.TFI_REIMBURSEMENT tr WHERE tr.RMMT_ID = @i_paym_ref_id AND tr.RMMT_NBR = @i_paym_ref_nbr
			-- 生成付款通知(通用报销不为挂账时，新版)
			-- 1种情况推付款通知：1，权益方，收款方记账方式都为支付
			IF EXISTS (SELECT 1 FROM TFI_REIMBURSEMENT m
					   WHERE rmmt_id = @i_paym_ref_id AND RMMT_NBR = @i_paym_ref_nbr 
					   AND (m.rmmt_gl_type = 1 AND m.rmmt_rec_gltype = 1 OR (@rmmt_loan <> 0))) 
						 
			BEGIN
				EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
			END
			
			IF (@o_rntStr = 'OK')
			BEGIN
				-- 回写报销单已付金额
				UPDATE a SET a.RMMT_PAYMENT_R = ROUND(ISNULL(a.RMMT_PAYMENT_R, 0) + b.paym_amt * b.paym_rate, 2)
				FROM TFI_REIMBURSEMENT a
				INNER JOIN tfi_pay_m b ON b.paym_ref_id = a.rmmt_id AND LEFT(b.paym_ref_nbr, 13) = a.rmmt_nbr
				WHERE b.paym_id = @o_paym_id;
			END
		END
			
		--索赔单推送收款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'QM03')
		BEGIN
			DECLARE @type VARCHAR(10);
			SELECT @type=clam_pay_type FROM hqis.dbo.tqa_claim_m WHERE clam_id=@i_paym_ref_id;
			IF (@type = '1')
			BEGIN
				EXEC rp_fi_rec_to_incomebill @o_paym_id; -- 生成收款通知
			END
		END
		--采购对账单推送付款通知单
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('PU19','PU20','PU21','PU29','PU33','PU34','PU35'))
		BEGIN
			-- 生成付款通知
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
		END
		--销售对账单推送收款通知单
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'SA47')
		BEGIN
			-- 生成收款通知
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
		END
		--销售旧版推送收款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'AR01')
		BEGIN
			-- 生成收款通知
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--礼品退库推送收款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'GF03')
		BEGIN
			-- 生成收款通知
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--薪资发放推付款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('WG05', 'WG11'))
		BEGIN
			-- 生成付款通知
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--票务及快递对账推付款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('AD08'))
		BEGIN
			-- 生成付款通知
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--餐饮结算推付款通知
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('AD09'))
		BEGIN
			-- 生成付款通知
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
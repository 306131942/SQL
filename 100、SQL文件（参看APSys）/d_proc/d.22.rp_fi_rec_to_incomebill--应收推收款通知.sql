USE FIDB
GO
IF(OBJECT_ID('rp_fi_rec_to_incomebill','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_rec_to_incomebill AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗召洋
-- Create date: 2013-10-23
-- Description:	应收单审核通过后生成收款通知单
-- Modify[1]: 增加客户且供应商的情况处理 at 2014-11-03 by liuxiang
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_rec_to_incomebill]
(
	@i_mid INT--其他单据推送生成的paym数据的id(比如SA47对应的)
	, @o_icbm_id INT = 0 OUTPUT				-- 返回收款单id
	, @o_icbm_nbr VARCHAR(20) = '' OUTPUT		-- 返回收款单号
	, @o_rntStr VARCHAR(800) = '' OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	DECLARE @wfcode VARCHAR(20);			-- 哪个流程推送 AR05(应收->收款) 
	DECLARE @icbm_type TINYINT;				-- 收款类型 1收款 2预收
	DECLARE @icbm_item VARCHAR(20);			-- 会计科目
	DECLARE @icbm_emp VARCHAR(20);			-- 申请人
	DECLARE @icbm_dept VARCHAR(20);			-- 申请部门code
	DECLARE @icbm_duty INT;					-- 申请人岗位
	DECLARE @icbm_legal INT;				-- 法人
	DECLARE @icbm_reccode_type TINYINT;		-- 对方类型 2个人3客户
	DECLARE @icbm_rec_code VARCHAR(20);		-- 对方代码
	DECLARE @icbm_rec_type TINYINT;			-- 支付方式
	DECLARE @icbm_rec_bank VARCHAR(100);		-- 付款银行 
	DECLARE @icbm_rec_company VARCHAR(100);	    -- 付款账户名  付款开户名
	DECLARE @icbm_rec_acct VARCHAR(50);			-- 付款账号
	DECLARE @icbm_currency VARCHAR(10);		-- 币别
	DECLARE @icbm_amt MONEY;				-- 应收金额
	DECLARE @icbm_rec_date DATETIME;		-- 收款日期
	DECLARE @icbm_rmks VARCHAR(800);		-- 备注
	DECLARE @icbm_ref_id INT;				-- 关联单据ID
	DECLARE @acctid INT;					-- acctid
	
	DECLARE @paym_nbr VARCHAR(20);			--单据单号
	
	SET @o_rntStr = 'OK';
	
	SELECT -- 设置参数
		@wfcode = 'AR05'
		, @paym_nbr = tpm.paym_nbr
		, @icbm_type = 1
		, @icbm_item = tpm.paym_item
		, @icbm_emp = tpm.paym_emp
		, @icbm_dept = tpm.paym_dept
		, @icbm_duty = tpm.paym_duty
		, @icbm_legal = tpm.paym_legal
		, @icbm_reccode_type = tpm.paym_paycode_type
		, @icbm_rec_code = tpm.paym_pay_code
		, @icbm_rec_type = tpm.paym_pay_type
		, @icbm_currency = tpm.paym_currency
		, @icbm_rec_bank = tpm.paym_pay_bank
		, @icbm_rec_company = tpm.paym_pay_name
		, @icbm_rec_acct = tpm.paym_pay_nbr
		, @icbm_amt = tpm.paym_amt
		, @icbm_rec_date = tpm.paym_due_date
		, @icbm_rmks = tpm.paym_rmks
		, @icbm_ref_id = tpm.paym_id--其他单据推送生成的paym数据的id(比如SA47对应的)
		, @acctid = tpm.acctid
	FROM FIDB.dbo.tfi_pay_m tpm
	WHERE tpm.paym_id = @i_mid;
	
	IF (@icbm_ref_id IS NOT NULL)
	BEGIN
		IF (
			  ( @icbm_amt > 0 
				OR EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @i_mid AND (paym_nbr LIKE 'GF03%' OR paym_nbr LIKE 'SA47%' ))
			  )
			  AND --除其他应付单AP06,遇到双经销客户时不推送 
		     (  NOT EXISTS(SELECT 1 FROM HSAL.dbo.v_sa_customer WHERE CUST_CODE=@icbm_rec_code AND @icbm_reccode_type=3 AND ISNULL(cust_supplier,'')<>'') 
		  		OR @icbm_reccode_type <> 3
		  		OR LEFT(@paym_nbr,4)='AR06'
			  )
		   )
		BEGIN
			EXEC FIDB.DBO.rp_fi_add_incomebill
			@wfcode,
			@icbm_type,
			@icbm_item,
			@icbm_emp,
			@icbm_dept,
			@icbm_duty,
			@icbm_legal,
			@icbm_reccode_type,
			@icbm_rec_code,
			@icbm_rec_type,
			@icbm_currency,
			@icbm_rec_bank,
			@icbm_rec_company,
			@icbm_rec_acct,
			@icbm_amt,
			0,
			@icbm_amt,
			@icbm_rec_date,
			@icbm_rmks,
			@icbm_ref_id,--其他单据推送生成的paym数据的id(比如SA47对应的)
			@acctid,
			@o_icbm_id OUTPUT,
			@o_icbm_nbr OUTPUT,
			@o_rntStr OUTPUT;
		END
	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成收款通知单';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
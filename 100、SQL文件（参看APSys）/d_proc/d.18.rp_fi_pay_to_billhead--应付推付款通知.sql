USE FIDB
GO

IF(OBJECT_ID('rp_fi_pay_to_billhead','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_pay_to_billhead AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-06
-- Description:	报销应付单审核通过后生成付款通知单
-- Modify[1]: 增加供应商且客户的情况处理 at 2014-11-03 by liuxiang
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_pay_to_billhead]
(
	@i_mid INT
	, @o_abhm_id INT = 0 OUTPUT				-- 返回付款单id
	, @o_abhm_nbr VARCHAR(20) = '' OUTPUT 	-- 返回付款单号
	, @o_rntStr VARCHAR(800) = '' OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @mid INT;
	--SET @mid = 13244;
	
	DECLARE @wfcode VARCHAR(20);			-- 哪个流程推送 AP05(应付->付款) AC15(借款->预付)
	DECLARE @abhm_type TINYINT;				-- 付款类型 1付款 2预付
	DECLARE @abhm_item VARCHAR(20);			-- 会计科目
	DECLARE @abhm_emp VARCHAR(20);			-- 申请人
	DECLARE @abhm_dept VARCHAR(20);			-- 申请部门code
	DECLARE @abhm_duty INT;					-- 申请人岗位
	DECLARE @abhm_legal INT;				-- 法人
	DECLARE @abhm_paycode_type TINYINT;		-- 对方类型 1供应商2个人
	DECLARE @abhm_pay_code VARCHAR(20);		-- 对方代码
	DECLARE @abhm_pay_type TINYINT;			-- 支付方式
	DECLARE @abhm_pay_bank VARCHAR(100);	-- 开户行
	DECLARE @abhm_pay_name VARCHAR(100);	-- 开户名
	DECLARE @abhm_pay_nbr VARCHAR(50);		-- 开户账号
	DECLARE @abhm_currency VARCHAR(10);		-- 币别
	DECLARE @abhm_rate  DECIMAL(19, 7);  	-- 汇率
	DECLARE @abhm_amt MONEY;				-- 应付金额
	DECLARE @abhm_pay_date DATETIME;		-- 付款日期
	DECLARE @abhm_rmks VARCHAR(800);		-- 备注
	DECLARE @abhm_ref_id INT;				-- 关联单据ID
	DECLARE @acctid INT;					-- acctid
	
	DECLARE @paym_nbr VARCHAR(20);			--单据单号
	
	SET @o_rntStr = 'OK';
	
	SELECT -- 设置参数
		@wfcode = 'AP05'
		, @paym_nbr = tpm.paym_nbr
		, @abhm_type = 1
		, @abhm_item = tpm.paym_item
		, @abhm_emp = tpm.paym_emp
		, @abhm_dept = tpm.paym_dept
		, @abhm_duty = tpm.paym_duty
		, @abhm_legal = tpm.paym_legal
		, @abhm_paycode_type = tpm.paym_paycode_type
		, @abhm_pay_code = tpm.paym_pay_code
		, @abhm_pay_type = tpm.paym_pay_type
		, @abhm_pay_name = tpm.paym_pay_name
		, @abhm_pay_bank = tpm.paym_pay_bank
		, @abhm_pay_nbr = tpm.paym_pay_nbr
		, @abhm_currency = tpm.paym_currency
		, @abhm_rate = tpm.paym_rate
		, @abhm_amt = tpm.paym_amt
		, @abhm_pay_date = tpm.paym_due_date
		, @abhm_rmks = tpm.paym_rmks
		, @abhm_ref_id = tpm.paym_id
		, @acctid = tpm.acctid
	FROM FIDB.dbo.tfi_pay_m tpm
	WHERE tpm.paym_id = @i_mid;
	
	IF (@abhm_ref_id IS NOT NULL)
	BEGIN
		IF (@abhm_amt>0 
			 AND 	--除其他应付单AP06,遇到双经销客户时不推送
			   (
				  NOT EXISTS(SELECT 1 FROM HPUR.dbo.TPU_SUPPLIER WHERE SPL_TYPE IN (1,3) AND @abhm_paycode_type = 1 AND spl_code = @abhm_pay_code AND ISNULL(spl_domestic_cust,'') <> '') 
				  OR @abhm_paycode_type <> 1
				  OR LEFT(@paym_nbr,4)='AP06'
				)
			)
		BEGIN
			EXEC rp_fi_add_billhead
			@wfcode,
			@abhm_type,
			@abhm_item,
			@abhm_emp,
			@abhm_dept,
			@abhm_duty,
			@abhm_legal,
			@abhm_paycode_type,
			@abhm_pay_code,
			@abhm_pay_type,
			@abhm_pay_bank,
			@abhm_pay_name,
			@abhm_pay_nbr,
			@abhm_currency,
			@abhm_rate,
			@abhm_amt,
			0,
			@abhm_amt,
			@abhm_pay_date,
			@abhm_rmks,
			NULL,
			@abhm_ref_id,
			@acctid,
			@o_abhm_id OUTPUT,
			@o_abhm_nbr OUTPUT,
			@o_rntStr OUTPUT;
		END

	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成付款通知单';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
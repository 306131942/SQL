USE [FIDB]
GO

IF(OBJECT_ID('v_fi_match_bill','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_match_bill AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗召洋
-- Create date: 2013-07-12
-- Description:	匹配单据列表视图
-- modify: 修改现金存取单的匹配逻辑 at 2014-03-15 by liuxiang
-- modify: 增加特殊账户自身的收付流水相互匹配 at 2014-04-24 by liuxiang
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_match_bill]
WITH VIEW_METADATA
AS
	--从收款通知主表tfi_incomebill_m中查出icbm_status=9(待收)和icbm_status=10(部分收款)的单据
	SELECT
		match_id = icbm_id,										--主id
		match_nbr = icbm_nbr,									--单号
		match_nbr_name = ft.wfm_name,					--单据名称
		match_pay_code = icbm_rec_code,				--对方代码(code)
		match_pay_code_name = fpi.pay_name,		--对方代码(name)
		match_pay_code_fname = fpi.pay_fname,		--对方代码(full_name)
		match_acct_id = NULL,								--我方账户id
		match_pay_nbr = NULL,								--对方账号
		match_currency = icbm_currency,					--币别
		match_amt = ISNULL(icbm_inc_amt, 0.00),	--付款执行金额
		match_real_amt = ISNULL(icbm_real_amt, 0.00),	--已付金额
		match_status = icbm_status,							--审核状态
		match_ref_mid = NULL,								--关联单据mid
		match_ref_nbr = NULL	,								--关联单号
		match_type = tim.icbm_type,						--类型:1：收款通知，2：预收通知
		match_rmks = tim.icbm_rmks,						--备注
		match_ref_type = 1										--1表示从tfi_incomebill_m来
	FROM dbo.tfi_incomebill_m tim
	LEFT JOIN dbo.v_fi_paycode_info fpi ON tim.icbm_rec_code = fpi.pay_code
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(tim.icbm_nbr, 4) = ft.wfm_code
	WHERE icbm_status IN (9, 10) AND icbm_inc_amt <> icbm_real_amt
	UNION ALL
	SELECT
		match_id = exem_id,										--付款主id
		match_nbr = exem_nbr,								--单号
		match_nbr_name = ft.wfm_name,					--单据名称
		match_pay_code = abhm.abhm_pay_code,	--对方代码(code)
		match_pay_code_name = fpi.pay_name,		--对方代码(name)
		match_pay_code_fname = fpi.pay_fname,		--对方代码(full_name)
		match_acct_id = exem_acct_id,					--我方账户id
		match_pay_nbr = abhm.abhm_pay_nbr,		--对方账号
		match_currency = exem.exem_curr,		--币别
		match_amt = ISNULL(exem_amt, 0.00),		--付款执行金额
		match_real_amt = ISNULL(exem_real_amt, 0.00),	--已付金额
		match_status = exem_status,							--审核状态
		match_ref_mid = exem_ref_mid,					--关联单据mid
		match_ref_nbr = exem_ref_nbr	,					--关联单号
		match_type = abhm.abhm_type,					--类型:1：付款，2：预付
		match_rmks = exem.exem_rmks,					--备注
		match_ref_type = 2										--2表示从付款执行单tfi_execute_m来
	FROM dbo.tfi_execute_m exem
	LEFT JOIN dbo.tfi_billhead_m abhm ON exem.exem_ref_mid = abhm.abhm_id AND exem.exem_ref_nbr = abhm.abhm_nbr
	LEFT JOIN dbo.v_fi_paycode_info fpi ON abhm.abhm_pay_code = fpi.pay_code
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(exem.exem_nbr, 4) = ft.wfm_code
	WHERE exem_status IN (5, 6) AND exem_amt <> exem_real_amt
	UNION ALL
	--从贴现/承兑申请单tfi_discount中查出dcnt_status=5(完成)的单据
	SELECT
		match_id = dcnt_id,													--主id
		match_nbr = dcnt_nbr,												--单号
		match_nbr_name = ft.wfm_name,								--单据名称
		match_pay_code = '',												--对方代码(code)
		match_pay_code_name = '',										--对方代码(name)
		match_pay_code_fname = drft.drft_out_fullname,		--对方代码(full_name)(出票人全称)
		match_acct_id = dcnt_acct_id,									--我方账户id
		match_pay_nbr = drft.drft_out_act,							--对方账号(出票人帐号)
		match_currency = drft.drft_curr_type,						--币别
		match_amt = ISNULL(dcnt_amt, 0.00),						--付款执行金额(贴现/承兑金额)
		match_real_amt = ISNULL(dcnt_confirm, 0.00),		--已付金额
		match_status = dcnt_status,										--审核状态
		match_ref_mid = NULL,											--关联单据mid
		match_ref_nbr = NULL	,											--关联单号
		match_type = dcnt.dcnt_type,									--作业类型:1：承兑，2：贴现
		match_rmks = dcnt.dcnt_brief,									--备注
		match_ref_type = 3													--3表示从tfi_discount来
	FROM dbo.tfi_discount dcnt
	LEFT JOIN dbo.tfi_draft drft ON dcnt.dcnt_drft_id = drft.drft_id
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(dcnt.dcnt_nbr, 4) = ft.wfm_code
	WHERE dcnt_status = 5 AND dcnt_state <> 2
	--从现金交易申请表tfi_cash_tx中查出cstx_status=5(完成)的单据
	--由于现金交易单能和银行流水做匹配又能和现金流水做匹配
	--这里采用
	--match_ref_type=4表示能和银行流水做匹配的现金交易单
	--match_ref_type=5表示能和现金流水做匹配的现金交易单
	UNION ALL
	SELECT
		match_id = cstx_id,										--主id
		match_nbr = cstx_nbr,									--单号
		match_nbr_name = ft.wfm_name,					--单据名称
		match_pay_code = '',									--对方代码(code)
		match_pay_code_name = '',							--对方代码(name)
		match_pay_code_fname = '',							--对方代码(full_name)
		match_acct_id = cstx_acct_id,						--我方账户id
		match_pay_nbr = NULL,								--对方账号
		match_currency = cstx_curr_type,					--币别
		match_amt = ISNULL(cstx_amt, 0.00),			--付款执行金额(交易金额)
		match_real_amt = ISNULL(cstx_confirm, 0.00),	--已付金额(核销金额)
		match_status = cstx_status,							--审核状态
		match_ref_mid = cstx_prior_id,					--关联单据mid
		match_ref_nbr = cstx_prior_nbr,					--关联单号
		match_type = cstx.cstx_op_type,					--业务类型，1、存现；2、取现
		match_rmks = cstx.cstx_brief,						--备注
		match_ref_type = 4										--4表示从tfi_cash_tx来
	FROM dbo.tfi_cash_tx cstx
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(cstx.cstx_nbr, 4) = ft.wfm_code
	WHERE cstx_status = 5 AND cstx_state <> 2
	UNION ALL
	SELECT
		match_id = cstx_id,										--主id
		match_nbr = cstx_nbr,									--单号
		match_nbr_name = ft.wfm_name,					--单据名称
		match_pay_code = '',									--对方代码(code)
		match_pay_code_name = '',							--对方代码(name)
		match_pay_code_fname = '',							--对方代码(full_name)
		match_acct_id = cstx_cact_id,						--现金帐号id
		match_pay_nbr = NULL,								--对方账号
		match_currency = cstx_curr_type,					--币别
		match_amt = ISNULL(cstx_amt, 0.00),			--付款执行金额(交易金额)
		match_real_amt = ISNULL(cstx_cash_confirm, 0.00),	--已付金额(核销金额)
		match_status = cstx_status,							--审核状态
		match_ref_mid = cstx_prior_id,					--关联单据mid
		match_ref_nbr = cstx_prior_nbr,					--关联单号
		match_type = cstx.cstx_op_type,					--业务类型，1、存现；2、取现
		match_rmks = cstx.cstx_brief,						--备注
		match_ref_type = 5										--4表示从tfi_cash_tx来
	FROM dbo.tfi_cash_tx cstx
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(cstx.cstx_nbr, 4) = ft.wfm_code
	WHERE cstx_status = 5 AND cstx_cash_state <> 2
	UNION ALL
	SELECT
		match_id = atsp_id,									--主id
		match_nbr = atsp_nbr,								--单号
		match_nbr_name = '付款流水',						--单据名称
		match_pay_code = '',								--对方代码(code)
		match_pay_code_name = atsp_cust_name,				--对方代码(name)
		match_pay_code_fname = atsp_cust_name,				--对方代码(full_name)
		match_acct_id = atsp_acct_id,						--我方帐号id
		match_pay_nbr = atsp_cust_acct,						--对方账号
		match_currency = atsp_curr,					        --币别
		match_amt = ISNULL(atsp_amt, 0.00),					--付款执行金额(交易金额)
		match_real_amt = 0.00,								--已付金额(核销金额)
		match_status = NULL,								--审核状态
		match_ref_mid = NULL,								--关联单据mid
		match_ref_nbr = NULL,								--关联单号
		match_type = atsp.atsp_pay_type,					--业务类型: 0,收款; 1,付款;
		match_rmks = atsp.atsp_rmks,						--备注
		match_ref_type = 8									--7表示从银行流水的付款流水
	FROM dbo.tfi_account_tx_split atsp
	WHERE atsp_status = 0 AND atsp_pay_type = 1 AND atsp_type = 0
	UNION ALL
		SELECT
		match_id = atsp_id,									--主id
		match_nbr = atsp_nbr,								--单号
		match_nbr_name = '收款流水',						--单据名称
		match_pay_code = '',								--对方代码(code)
		match_pay_code_name = atsp_cust_name,				--对方代码(name)
		match_pay_code_fname = atsp_cust_name,				--对方代码(full_name)
		match_acct_id = atsp_acct_id,						--我方帐号id
		match_pay_nbr = atsp_cust_acct,						--对方账号
		match_currency = atsp_curr,					        --币别
		match_amt = ISNULL(atsp_amt, 0.00),					--付款执行金额(交易金额)
		match_real_amt = 0.00,								--已付金额(核销金额)
		match_status = NULL,								--审核状态
		match_ref_mid = NULL,								--关联单据mid
		match_ref_nbr = NULL,								--关联单号
		match_type = atsp.atsp_pay_type,					--业务类型: 0,收款; 1,付款;
		match_rmks = atsp.atsp_rmks,						--备注
		match_ref_type = 9									--7表示从银行流水的付款流水
	FROM dbo.tfi_account_tx_split atsp
	WHERE atsp_status = 0 AND atsp_pay_type = 0 AND atsp_type = 0

WITH CHECK OPTION;
USE [FIDB]
GO
IF(OBJECT_ID('v_fi_billhead_d_innera','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_billhead_d_innera AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:      
-- Create date: 2018-10-23
-- Description: 收付款单明细来源单信息
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_billhead_d_innera]
WITH VIEW_METADATA
AS
	-- 应付单(审核通过,未付完)
	SELECT vbdf_abhd_bill_type = (CASE WHEN paym.paym_nbr_flag = 5 THEN 2 ELSE paym.paym_nbr_flag END) -- 单据类型1:应付,2:其他应付，3:应收，4：其他应收；
		,vbdf_recorpay=2 --收付类型：1.收款，2.付款
		, vbdf_code_type = paym.paym_paycode_type --对方代码类型
		, vbdf_pay_code = paym_pay_code --对方代码
		, vbdf_mid = paym_id --单据id
		, vbdf_did = 0 --单据明细id
		, vbdf_source_URL = tm.acurl
		, vbdf_source_mid = paym.paym_ref_id
		, vbdf_nbr = paym.paym_nbr + (CASE WHEN paym.paym_split_sort > 0 THEN '-' + CAST(paym.paym_split_sort AS VARCHAR(10)) ELSE '' END) --原始单单号
		, vbdf_name = tm.wfm_name --原始单名称
		, vbdf_legal = paym.paym_legal--法人
		, vbdf_currency = paym.paym_currency--币别
		--, vbdf_rate = hportal.dbo.rf_ba_getRate(paym.acctid,paym_currency, 'RMB', GETDATE())--汇率
		, vbdf_rate = paym.paym_rate--汇率
		, vbdf_amt = paym.paym_amt-paym.paym_real_amt --应付余额
		, vbdf_rec_amt = 0 --应收余额
		, vbdf_status = paym.paym_status
		, vbdf_rmks = paym.paym_rmks
		, vbdf_acctid = paym.acctid -- 区域(深圳/河源等)
		, vbdf_date = paym.paym_due_date   --应付日期 
		, vbdf_admin_code = paym.paym_admin_dept	-- 应收应付部门
	FROM dbo.tfi_pay_m paym
	LEFT JOIN dbo.tfi_type_d typd ON paym .paym_typd_id = typd.typd_id
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(typd.typd_wfm_code, LEFT(paym.paym_nbr, 4))
	WHERE paym.paym_nbr_flag IN (1, 2, 5) AND paym.paym_status IN (5, 6, 7) 
	AND paym.paym_paycode_type=101
	AND typd.typd_wfm_code NOT IN('AP11','AC15','AC24','AP07','AR07') 
	UNION ALL
	-- 应收单(审核通过,未收完)
	SELECT vbdf_abhd_bill_type = (CASE WHEN recm.paym_nbr_flag = 6 THEN 4 ELSE recm.paym_nbr_flag END) -- 单据类型1:应付,2:其他应付，3:应收，4：其他应收；
		, vbdf_recorpay = 1
		, vbdf_code_type = recm.paym_paycode_type
		, vbdf_pay_code = paym_pay_code --对方代码
		, vbdf_mid = paym_id --单据id
		, vbdf_did = 0 --单据明细id
		, vbdf_URL = tm.acurl
		, vbdf_source_mid = recm.paym_ref_id
		, vbdf_nbr = recm.paym_nbr + (CASE WHEN recm.paym_split_sort > 0 THEN '-' + CAST(recm.paym_split_sort AS VARCHAR(10)) ELSE '' END) --原始单单号
		, vbdf_name = tm.wfm_name --原始单名称
		, vbdf_legal = recm.paym_legal--法人
		, vbdf_currency = recm.paym_currency--币别
		--, vbdf_rate = HPORTAL.dbo.rf_ba_getRate(recm.acctid,recm.paym_currency, 'RMB', GETDATE())--汇率
		, vbdf_rate = recm.paym_rate--汇率
		, vbdf_amt = 0 --应付余额
		, vbdf_rec_amt = recm.paym_amt-recm.paym_real_amt --应收余额
		, vbdf_status = recm.paym_status
		, vbdf_rmks = recm.paym_rmks
		, vbdf_acctid = recm.acctid -- 区域(深圳/河源等)
		, vbdf_date = recm.paym_due_date   --应收日期 
		, vbdf_admin_code = recm.paym_admin_dept	-- 应收应付部门
	FROM dbo.tfi_pay_m recm
	LEFT JOIN dbo.tfi_type_d typd ON recm.paym_typd_id = typd.typd_id
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(typd.typd_wfm_code, LEFT(recm.paym_nbr, 4))
	WHERE recm.paym_nbr_flag IN (3, 4, 6) AND recm.paym_status IN (9, 10, 11)
	AND recm.paym_paycode_type=101
	AND typd.typd_wfm_code NOT IN('AP11','AC15','AC24','AP07','AR07')
	
WITH CHECK OPTION;
GO 

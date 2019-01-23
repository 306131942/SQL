USE [FIDB]
GO

IF(OBJECT_ID('v_fi_wfing','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_wfing AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2014-03-05
-- Description:	审核中的收付数据
-- Modify[1]:   zhoupan at 2016-06-30 报销单审核中去掉借款单的收付数据
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_wfing]
WITH VIEW_METADATA
AS
	SELECT
		nbr_type = 1 -- 单据类型: 付款通知单
		, nbr_mid = m1.abhm_id -- 单据id
		, nbr_status = m1.abhm_status -- 单据状态
		, nbr_bill_type = abhd_bill_type -- 收付单类型
		, nbr_paym_id = d1.abhd_m_id -- 收付单ID
		, m1.acctid
	FROM FIDB.dbo.tfi_billhead_m m1
	INNER JOIN FIDB.dbo.tfi_billhead_d d1 ON d1.abhd_abhm_id = m1.abhm_id
	WHERE m1.abhm_type = 1 AND m1.abhm_status <= 4
	UNION ALL
	SELECT
		2 -- 收款通知单
		, m2.icbm_id
		, m2.icbm_status
		, d2.icbd_bill_type
		, d2.icbd_m_id
		, m2.acctid
	FROM FIDB.dbo.tfi_incomebill_m m2
	INNER JOIN FIDB.dbo.tfi_incomebill_d d2 ON d2.icbd_icbm_id=m2.icbm_id
	WHERE m2.icbm_type = 1 AND m2.icbm_status <= 4
	UNION ALL
	SELECT
		3 -- 报销单
		, rmmt_id
		, rmmt_status
		, (CASE WHEN rbre_nbr_type = 1 THEN 3 ELSE 2 END)
		, rbre_paym_id
		, tr.ACCTID
	FROM FIDB.dbo.tfi_reim_borrow_relation
	INNER JOIN FIDB.dbo.tfi_reimbursement tr ON rmmt_id = rbre_rmmt_id
	WHERE rmmt_status <= 4 
	UNION ALL
	SELECT 
		 4 -- 对账核准单
		, accm.accm_id
		, accm.accm_status
		, (CASE WHEN accm_flag = 1 THEN 2 ELSE 1 END)
		, accd.accd_m_id
		, accm.acctid
	FROM FIDB.dbo.tfi_accountcussent_m accm
	INNER JOIN FIDB.dbo.tfi_accountcussent_d accd ON accm.accm_id = accd.accd_accm_id
	WHERE accm.accm_status <= 4

WITH CHECK OPTION;
GO
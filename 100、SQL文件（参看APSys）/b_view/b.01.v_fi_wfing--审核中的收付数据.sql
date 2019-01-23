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
		, nbr_wfm_code = 'AP07'
		, nbr_mid = m1.abhm_id -- 单据id
		, nbr_nbr = m1.abhm_nbr -- 单据单号
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
		,'AR07'
		, m2.icbm_id
		, nbr_nbr = m2.icbm_nbr -- 单据单号
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
		,(CASE WHEN tr.rmmt_type = 1 THEN 'AC12' WHEN tr.rmmt_type = 2 THEN 'AC11' 
			   WHEN tr.rmmt_type = 3 THEN 'AC14' WHEN tr.rmmt_type = 4 THEN 'AC13' WHEN tr.rmmt_type = 5 THEN 'AC16'  END  )
		, rmmt_id
		, nbr_nbr = tr.RMMT_NBR -- 单据单号
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
		,'AP15'
		, accm.accm_id
		, nbr_nbr = accm.accm_nbr
		, accm.accm_status
		, (CASE WHEN accm_flag = 1 THEN 2 ELSE 1 END)
		, accd.accd_m_id
		, accm.acctid
	FROM FIDB.dbo.tfi_accountcussent_m accm
	INNER JOIN FIDB.dbo.tfi_accountcussent_d accd ON accm.accm_id = accd.accd_accm_id
	WHERE accm.accm_status <= 4
	UNION ALL
	SELECT 
		 5 -- 付款通知单本身
		, 'AP07'
		, tbm.abhm_id
		, nbr_nbr = tbm.abhm_nbr
		, tbm.abhm_status
		, 1
		, paym.paym_id
		, tbm.acctid
	FROM FIDB.dbo.tfi_billhead_m tbm
	INNER JOIN FIDB.dbo.tfi_pay_m paym ON tbm.abhm_nbr = paym.paym_nbr
	WHERE tbm.abhm_status <= 4
	
	UNION ALL
	SELECT 
		 6 -- 收款通知单本身
		,'AR07'
		, tim.icbm_id
		, nbr_nbr =tim.icbm_nbr
		, tim.icbm_status
		, 3
		, paym.paym_id
		, tim.acctid
	FROM FIDB.dbo.tfi_incomebill_m tim
	INNER JOIN FIDB.dbo.tfi_pay_m paym ON tim.icbm_nbr = paym.paym_nbr
	WHERE tim.icbm_status <= 4
	
	UNION ALL
	SELECT 
		7 -- 单据类型: 付款通知单
		, 'SA47'
		, m.actm_id
		, m.actm_nbr
		, m.actm_audit_status -- 单据状态
		, 3 -- 收付单类型
		, s.scts_from_id -- 收付单ID
		, m.acctid
	from hsal.dbo.tsa_acct_m m
	LEFT JOIN hsal.dbo.tsa_acct_s s ON s.scts_actm_id=m.actm_id
	WHERE m.actm_audit_status < 5 AND ISNULL(scts_select,1)=1 AND ISNULL(s.scts_from_id,0)>0

WITH CHECK OPTION;
GO

--select * from fidb.dbo.v_fi_wfing
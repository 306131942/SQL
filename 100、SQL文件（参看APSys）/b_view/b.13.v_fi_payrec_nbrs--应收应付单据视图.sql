USE [FIDB]
GO

IF(OBJECT_ID('v_fi_payrec_nbrs','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_payrec_nbrs AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-28
-- Description:	Ӧ��Ӧ��������Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_payrec_nbrs]
WITH VIEW_METADATA
AS
	-- Ӧ����
	SELECT nbr_type = 1														-- �������ͣ�1Ӧ��2Ӧ��
		, mid = tpm.paym_id													-- ����id
		, nbr = tpm.paym_nbr + (CASE WHEN tpm.paym_split_sort > 0 THEN '-' + CAST(tpm.paym_split_sort AS VARCHAR(10)) ELSE '' END)												-- ����
		, wfcode = tm.wfm_code												-- ���̱���
		, source_mid = ISNULL((SELECT TOP(1) twfa.wfna_m_id FROM HPORTAL.dbo.twf_a twfa WHERE twfa.wfna_nbr = tpm.paym_nbr), tpm.paym_ref_id)
		, wfurl = tm.acurl													-- ���ҳ������
		, wfname = tm.wfm_name												-- ��������
		, sxdate = tpm.modtime												-- ��Ч����
		, legal = tpm.paym_legal											-- ���˵�λ
		, dfcode = tpm.paym_pay_code										-- �Է�����
		, dfname =  fidb.dbo.rf_fi_getBillheadCodeName(tpm.paym_paycode_type, tpm.paym_pay_code) -- fpi.pay_name												-- �Է�����/���												-- �Է�����/���
		, admin_code = tpm.paym_admin_dept									-- ���β���code
		, admin_dept = RTRIM(cm.cc_full)									-- ���β�������
		, currency = tpm.paym_currency										-- �ұ�
		, rate = tpm.paym_rate												-- ����
		, pay_amt = tpm.paym_amt											-- Ӧ�����
		, pay_last_amt = tpm.paym_amt - tpm.paym_real_amt					-- Ӧ�����
		, rec_amt = 0														-- Ӧ�ս��
		, rec_last_amt = 0													-- Ӧ�����
		, nbr_status = tpm.paym_status										-- ״̬code
		, nbr_status_n = tc.code_name										-- ״̬
		, sfdate = tpm.paym_due_date										-- ��/������
		, rmks = tpm.paym_rmks												-- ��ע
		, acctid = tpm.acctid												-- ����
	FROM dbo.tfi_pay_m tpm
	INNER JOIN dbo.tfi_type_m ttm ON ttm.typm_id = tpm.paym_typm_id AND ttm.typm_attribute = 1 AND ttm.isenable = 1 -- AND ttm.acctid = tpm.acctid
	LEFT JOIN dbo.tfi_type_d ttd ON ttd.typd_typm_id = ttm.typm_id AND ttd.typd_id = tpm.paym_typd_id --AND ttd.acctid = tpm.acctid
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(ttd.typd_wfm_code, LEFT(tpm.paym_nbr, 4))
	--LEFT JOIN dbo.v_fi_paycode_info fpi ON fpi.ctype = tpm.paym_paycode_type AND fpi.pay_code = tpm.paym_pay_code
	LEFT JOIN dbo.v_fi_dept cm ON cm.cc_code = tpm.paym_admin_dept
	LEFT JOIN dbo.v_fi_tbacode tc ON tc.code_code = tpm.paym_status AND tc.code_type = 'ap_audit_status'
	WHERE tpm.paym_parent_id = 0 AND tpm.paym_nbr_flag IN (1, 2) AND tpm.paym_status IN (5, 6, 7) AND tpm.isenable = 1
	UNION ALL
	-- Ԥ����(ΪӦ��)
	SELECT 2
		, tbm.abhm_id
		, tbm.abhm_nbr
		, 'AP08'
		, source_mid = tbm.abhm_id
		, 'APSysV2/csp/APSys.dll?page=EFI56AC&pcmd=init'
		, 'Ԥ��֪ͨ��'
		, tbm.modtime
		, tbm.abhm_legal
		, tbm.abhm_pay_code
		, fidb.dbo.rf_fi_getBillheadCodeName( tbm.abhm_paycode_type, tbm.abhm_pay_code) -- fpi.pay_name
		, fe.cc_code
		, fe.cc_full
		, tbm.abhm_currency
		, tbm.abhm_rate
		, 0
		, 0
		, tbm.abhm_real_amt
		, tbm.abhm_real_amt - tbm.abhm_prtn_amt
		, tbm.abhm_status
		, tc.code_name
		, tbm.abhm_rec_date
		, tbm.abhm_rmks
		, tbm.acctid
	FROM dbo.tfi_billhead_m tbm
	--LEFT JOIN dbo.v_fi_paycode_info fpi ON fpi.ctype = tbm.abhm_paycode_type AND fpi.pay_code = tbm.abhm_pay_code
	LEFT JOIN dbo.v_fi_tbacode tc ON tc.code_code = tbm.abhm_status AND tc.code_type = 'ap_audit_status'
	LEFT JOIN dbo.v_fi_empmstr fe ON fe.emp_id = tbm.abhm_emp
	WHERE tbm.abhm_type = 2 AND tbm.abhm_status IN (6)
	UNION ALL
	-- Ӧ�յ�
	SELECT 2
		, trm.paym_id
		, trm.paym_nbr + (CASE WHEN trm.paym_split_sort > 0 THEN '-' + CAST(trm.paym_split_sort AS VARCHAR(10)) ELSE '' END)
		, tm.wfm_code
		, source_mid = ISNULL((SELECT TOP(1) twfa.wfna_m_id FROM HPORTAL.dbo.twf_a twfa WHERE twfa.wfna_nbr = trm.paym_nbr), trm.paym_ref_id)
		, wfurl = tm.acurl													-- ���ҳ������
		, tm.wfm_name
		, trm.modtime
		, trm.paym_legal
		, trm.paym_pay_code
		, fidb.dbo.rf_fi_getBillheadCodeName( trm.paym_paycode_type, trm.paym_pay_code) -- fpi.pay_name
		, trm.paym_admin_dept
		, RTRIM(cm.cc_full)
		, trm.paym_currency
		, trm.paym_rate
		, 0
		, 0
		, trm.paym_amt
		, trm.paym_amt - trm.paym_real_amt
		, trm.paym_status
		, tc.code_name
		, trm.paym_due_date
		, trm.paym_rmks
		, trm.acctid
	FROM dbo.tfi_pay_m trm
	INNER JOIN dbo.tfi_type_m ttm ON ttm.typm_id = trm.paym_typm_id AND ttm.typm_attribute = 2 AND ttm.isenable = 1 -- AND ttm.acctid = trm.acctid
	LEFT JOIN dbo.tfi_type_d ttd ON ttd.typd_typm_id = ttm.typm_id AND ttd.typd_id = trm.paym_typd_id -- AND ttd.acctid = trm.acctid
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(ttd.typd_wfm_code, LEFT(trm.paym_nbr, 4))
	--LEFT JOIN dbo.v_fi_paycode_info fpi ON fpi.ctype = trm.paym_paycode_type AND fpi.pay_code = trm.paym_pay_code
	LEFT JOIN dbo.v_fi_dept cm ON cm.cc_code = trm.paym_admin_dept
	LEFT JOIN dbo.v_fi_tbacode tc ON tc.code_code = trm.paym_status AND tc.code_type = 'ap_audit_status'
	WHERE trm.paym_parent_id = 0 AND trm.paym_nbr_flag IN (3, 4) AND trm.paym_status IN (9, 10, 11) AND trm.isenable = 1
	UNION ALL
	-- Ԥ�յ�(ΪӦ��)
	SELECT 1
		, tim.icbm_id
		, tim.icbm_nbr
		, 'AR08'
		, source_mid = tim.icbm_id
		, 'APSysV2/csp/APSys.dll?page=EFI66AC&pcmd=init'
		, 'Ԥ��֪ͨ��'
		, tim.modtime
		, tim.icbm_legal
		, tim.icbm_rec_code
		, fidb.dbo.rf_fi_getBillheadCodeName( tim.icbm_reccode_type, tim.icbm_rec_code) -- fpi.pay_name
		, fe.cc_code
		, fe.cc_full
		, tim.icbm_currency
		, tim.icbm_rate
		, tim.icbm_real_amt
		, tim.icbm_real_amt - tim.icbm_prtn_amt
		, 0
		, 0
		, tim.icbm_status
		, tc.code_name
		, tim.icbm_pay_date
		, tim.icbm_rmks
		, tim.acctid
	FROM dbo.tfi_incomebill_m tim
	--LEFT JOIN dbo.v_fi_paycode_info fpi ON fpi.ctype = tim.icbm_reccode_type AND fpi.pay_code = tim.icbm_rec_code
	LEFT JOIN dbo.v_fi_tbacode tc ON tc.code_code = tim.icbm_status AND tc.code_type = 'ap_audit_status'
	LEFT JOIN dbo.v_fi_empmstr fe ON fe.emp_id = tim.icbm_emp
	WHERE tim.icbm_type = 2 AND tim.icbm_status IN (10)

WITH CHECK OPTION;
GO
USE [FIDB]
GO
IF(OBJECT_ID('v_fi_billhead_d_from','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_billhead_d_from AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:����
-- Create date: 2013-05-28
-- Description:�����ϸ��Դ����Ϣ
-- modify[1]:�޸�QM03Ӧ�����ļ��㹫ʽ��
-- modify[2]:����Ԥ�ᵥ����Ϊ��ͼ��Դ��
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_billhead_d_from]
WITH VIEW_METADATA
AS
	-- Ӧ����(���ͨ��,δ����)
	SELECT vbdf_abhd_bill_type = (CASE WHEN paym.paym_nbr_flag = 5 THEN 2 ELSE paym.paym_nbr_flag END) -- ��������1:Ӧ��,2:����Ӧ����3:Ӧ�գ�4������Ӧ�գ�
		,vbdf_recorpay=2 --�ո����ͣ�1.�տ2.����
		, vbdf_code_type = paym.paym_paycode_type --�Է���������
		, vbdf_pay_code = paym_pay_code --�Է�����
		, vbdf_mid = paym_id --����id
		, vbdf_did = 0 --������ϸid
		, vbdf_source_URL = tm.acurl
		, vbdf_source_mid = paym.paym_ref_id
		, vbdf_nbr = paym.paym_nbr + (CASE WHEN paym.paym_split_sort > 0 THEN '-' + CAST(paym.paym_split_sort AS VARCHAR(10)) ELSE '' END) --ԭʼ������
		, vbdf_name = tm.wfm_name --ԭʼ������
		, vbdf_currency = paym.paym_currency--�ұ�
		--, vbdf_rate = hportal.dbo.rf_ba_getRate(paym.acctid,paym_currency, 'RMB', GETDATE())--����
		, vbdf_rate = paym.paym_rate--����
		, vbdf_amt = paym.paym_amt-paym.paym_real_amt --Ӧ�����
		, vbdf_rec_amt = 0 --Ӧ�����
		, vbdf_status = paym.paym_status
		, vbdf_status_abhm = fw.nbr_status --�������״̬
		, vbdf_rmks = paym.paym_rmks
		, vbdf_acctid = paym.acctid -- ����(����/��Դ��)
		, vbdf_date = paym.paym_due_date   --Ӧ������ 
		, vbdf_admin_code = paym.paym_admin_dept	-- Ӧ��Ӧ������
	FROM dbo.tfi_pay_m paym
	LEFT JOIN (SELECT nbr_paym_id, nbr_status = MAX(nbr_status) FROM dbo.v_fi_wfing GROUP BY nbr_paym_id) fw ON fw.nbr_paym_id = paym.paym_id
	LEFT JOIN dbo.tfi_type_d typd ON paym .paym_typd_id = typd.typd_id
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(typd.typd_wfm_code, LEFT(paym.paym_nbr, 4))
	WHERE paym.paym_nbr_flag IN (1, 2, 5) AND paym.paym_status IN (5, 6, 7) AND (typd.typd_send_flag = 1 OR paym.paym_nbr LIKE 'AR08%')
	UNION ALL
	-- Ӧ�յ�(���ͨ��,δ����)
	SELECT vbdf_abhd_bill_type = (CASE WHEN recm.paym_nbr_flag = 6 THEN 4 ELSE recm.paym_nbr_flag END) -- ��������1:Ӧ��,2:����Ӧ����3:Ӧ�գ�4������Ӧ�գ�
		, vbdf_recorpay = 1
		, vbdf_code_type = recm.paym_paycode_type
		, vbdf_pay_code = paym_pay_code --�Է�����
		, vbdf_mid = paym_id --����id
		, vbdf_did = 0 --������ϸid
		, vbdf_URL = tm.acurl
		, vbdf_source_mid = recm.paym_ref_id
		, vbdf_nbr = recm.paym_nbr + (CASE WHEN recm.paym_split_sort > 0 THEN '-' + CAST(recm.paym_split_sort AS VARCHAR(10)) ELSE '' END) --ԭʼ������
		, vbdf_name = tm.wfm_name --ԭʼ������
		, vbdf_currency = recm.paym_currency--�ұ�
		--, vbdf_rate = HPORTAL.dbo.rf_ba_getRate(recm.acctid,recm.paym_currency, 'RMB', GETDATE())--����
		, vbdf_rate = recm.paym_rate--����
		, vbdf_amt = 0 --Ӧ�����
		, vbdf_rec_amt = recm.paym_amt-recm.paym_real_amt --Ӧ�����
		, vbdf_status = recm.paym_status
		, vbdf_status_abhm = fw.nbr_status --�������״̬
		, vbdf_rmks = recm.paym_rmks
		, vbdf_acctid = recm.acctid -- ����(����/��Դ��)
		, vbdf_date = recm.paym_due_date   --Ӧ������ 
		, vbdf_admin_code = recm.paym_admin_dept	-- Ӧ��Ӧ������
	FROM dbo.tfi_pay_m recm
	LEFT JOIN (SELECT nbr_paym_id, nbr_status = MAX(nbr_status) FROM dbo.v_fi_wfing GROUP BY nbr_paym_id) fw ON fw.nbr_paym_id = recm.paym_id
	LEFT JOIN dbo.tfi_type_d typd ON recm.paym_typd_id = typd.typd_id
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ISNULL(typd.typd_wfm_code, LEFT(recm.paym_nbr, 4))
	WHERE recm.paym_nbr_flag IN (3, 4, 6) AND recm.paym_status IN (9, 10, 11) AND (typd.typd_send_flag = 1 OR recm.paym_nbr LIKE 'AP08%')
	
WITH CHECK OPTION;
GO 

USE [FIDB]
GO
--2.���������ͼ���ж�
IF(OBJECT_ID('v_fi_prepay_refnbr','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_prepay_refnbr AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-06-09
-- Description:	Ԥ��������������Ϣ
-- Modify[1]:	���Ӳɹ����������Ŀ��ƣ�ֻ�н��㷽ʽ��Ԥ���Ĺ�Ӧ�̲ſ���Ԥ�� by liuxiang at 2014-11-13��
-- Modify[2]:	ȡ��ֻ�н��㷽ʽ��Ԥ���Ŀ���
-- Modify[3]:	20180702ֻ�õ�reftype=0,1,3
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_prepay_refnbr]
WITH VIEW_METADATA
AS
	-- �ɹ�����
	SELECT
		reftype = 1
		, mid = tpm.PODM_ID
		, nbr = tpm.PODM_NBR
		, pay_code = tpm.PODM_SPL_CODE
		, amt = tpm.PODM_AMT
		, currency = tpm.PODM_CURR
		, repay_date = ''
		, rmks = '��Ӧ�̣�' + ISNULL(spl.SPL_SHORT_NAME, '') + '�������ܽ�' + CAST(CAST(tpm.PODM_AMT AS DECIMAL(19, 2)) AS VARCHAR(19)) + ISNULL(tpm.PODM_CURR, 'RMB')
	FROM HPUR.dbo.TPU_POD_M tpm
	INNER JOIN (SELECT t.SPL_CODE, t.SPL_SHORT_NAME FROM HPUR.dbo.TPU_SUPPLIER t ) spl ON spl.SPL_CODE=tpm.PODM_SPL_CODE
	WHERE tpm.PODM_STATUS IN (6, 7)
	UNION ALL
	-- ��
	SELECT
		reftype = 2
		, mid = tbmm.BRMM_ID
		, nbr = tbmm.BRMM_NBR
		, pay_code = tbmm.BRMM_APPLICANT
		, amt = tbmm.BRMM_APPROVED
		, currency = ISNULL(tbmm.BRMM_CURR_TYPE, 'RMB')
		, CONVERT(VARCHAR(10), BRMM_REPAYMENT_DATE, 23)
		, rmks = ISNULL(fpi.pay_name, '') + CONVERT(VARCHAR(10), tbmm.BRMM_APPLICANT_DATE, 23) + '������' + CAST(tbmm.BRMM_APPROVED AS VARCHAR(18)) + ISNULL(tbmm.BRMM_CURR_TYPE, 'RMB')
	FROM dbo.TFI_BORROW_MONEY_M tbmm
	LEFT JOIN dbo.v_fi_paycode_info fpi ON tbmm.BRMM_APPLICANT = fpi.pay_code AND fpi.ctype = 2
	WHERE tbmm.BRMM_STATUS = 6
	UNION ALL
	-- ��ͬ
	SELECT
		reftype = 3
		, mid = m1.CNTM_ID
		, nbr = m1.CNTM_NBR
		, pay_code = m2.poem_spl_code--ȡ�����Ĺ�Ӧ��
		, amt = m1.CNTM_AMT
		, currency = ISNULL(m1.CNTM_CURR_TYPE, 'RMB')
		, CONVERT(VARCHAR(10), m1.cntm_end_date, 23)
		, rmks =  '��ͬ��ţ�'+m1.CNTM_CODE+'����'+ CAST(m1.cntm_amt AS VARCHAR(10)) +m1.cntm_curr_type
	FROM FIDB.dbo.tfi_contract_m m1 
	INNER  JOIN R6ERP.dbo.tpu_poet_m m2 ON m1.cntm_code = m2.poem_contract_code 
	WHERE m1.CNTM_STATUS = 6 --AND m2.poem_spl_code = 'WZ006' 
	UNION ALL
	-- ��ͬ�ҷ�������Ԥ����������ͬʱ��ֱ�ӹ���
	SELECT
		reftype = 3
		, mid = m1.CNTM_ID
		, nbr = m1.CNTM_NBR
		, pay_code = m1.cntm_second--ȡ��ͬ�ҷ�
		, amt = m1.CNTM_AMT
		, currency = ISNULL(m1.CNTM_CURR_TYPE, 'RMB')
		, CONVERT(VARCHAR(10), m1.cntm_end_date, 23)
		, rmks =  '��ͬ��ţ�'+m1.CNTM_CODE+'����'+ CAST(m1.cntm_amt AS VARCHAR(20)) +m1.cntm_curr_type
	FROM FIDB.dbo.tfi_contract_m m1 
	WHERE m1.CNTM_STATUS = 6 
	AND  NOT EXISTS(SELECT 1 FROM R6ERP.dbo.tpu_poet_m m2 WHERE m2.poem_contract_code = m1.CNTM_CODE ) --���˹������ʲɹ��ĺ�ͬ�������ط�����


WITH CHECK OPTION;
GO
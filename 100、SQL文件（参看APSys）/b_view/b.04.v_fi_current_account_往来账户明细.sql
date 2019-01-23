USE [FIDB]
GO

IF(OBJECT_ID('v_fi_current_account','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_current_account AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-05-05
-- Description:	���������˻���ϸ
-- Modify[1]:   2017-02-28 zhoupan ֻ��ѯ�����˻�Ϊ��Ч��������ϸ
-- Modify[2]:   2017-03-10 zhoupan ����isenable�ֶ�,0:��Ч 1:��Ч
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_current_account]
WITH VIEW_METADATA
AS
	SELECT splr.splr_code								-- �������
		, splr.splr_short_name_cn						-- ��������
		, account_splr_code = splr2.splr_code			-- �Ӷ������
		, tsa.suat_name									-- ������
		, tsa.suat_bank									-- ������
		, tsa.suat_account								-- �˺�
		, tsa.suat_begdate								-- ��ʼʱ��
		, tsa.suat_enddate								-- ����ʱ��
		, suat_type=(CASE WHEN splr2.splr_type='H' THEN 2 ELSE 5 END)
		, tsa.isenable
	FROM HSRP.dbo.tfi_suppliers splr
	INNER JOIN HSRP.dbo.tfi_suppliers_account tsa ON splr.splr_id=tsa.suat_splr_id
	INNER JOIN HSRP.dbo.tfi_suppliers splr2 ON tsa.suat_relation_splr_id=splr2.splr_id
	WHERE splr2.isenable = 1
	UNION ALL
	SELECT pay_spl_code
		, pay_spat_name
		, pay_spl_code
		, pay_spat_name
		, pay_spat_bank
		, pay_spat_account
		, pay_spat_begdate
		, pay_spat_enddate
		, 1
		, 1
	FROM FIDB.dbo.v_fi_spl_account		--��Ӧ�̸����˺���ͼ
	UNION ALL
	SELECT acct.CUST_CODE
		, acct.CUST_NAME
		, acct.CUST_CODE
		, acct.CTAC_NAME_OPST
		, acct.CTAC_BANK_OPST
		, acct.CTAC_ACCT_OPST
		, acct.CTAC_BEGDATE
		, acct.CTAC_ENDDATE
		, 3
		, 1 
	FROM HSAL.dbo.v_sa_cust_bank acct	--�ͻ������˺�
WITH CHECK OPTION;

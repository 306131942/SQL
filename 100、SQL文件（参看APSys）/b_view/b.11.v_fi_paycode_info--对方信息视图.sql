USE [FIDB]
GO

IF(OBJECT_ID('v_fi_paycode_info','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_paycode_info AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-04-26
-- Description:	��ѯ�Է�����/��ƻ�����Ϣ
-- Modify[1]:   2013-12-23 ��ε ���ӹ۲죬��ͣ״̬�Ĺ�Ӧ�̣��˲��ֹ�Ӧ���в���δ���Ļ�����ߵֿ���
-- Modify[2]:   2014-03-21 ��ε ���ӹ�Ӧ�̵����ͣ�1���ⲿ��Ӧ�̣�2���ڲ���Ӧ�̣�3��ί�⹩Ӧ��
-- Modify[3]:   2016-03-24 zhoupan ���Ӹ������͵�ȫ��
-- Modify[3]:   2016-05-09 liuxiang ����֤������֤�����ֶ�
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_paycode_info]
WITH VIEW_METADATA
AS
	SELECT
		ctype = 1																-- �Է����ͣ�1��Ӧ�� 2����
		, pay_code = ts.SPL_CODE												-- �Է�����
		, pay_name = ts.SPL_SHORT_NAME											-- �Է����
		, pay_fname = ts.SPL_NAME												-- �Է����
		, pay_certificate_type=''                        						-- ֤����
		, pay_certificate_code=''												-- ֤����
		, isenable = (CASE WHEN ts.SPL_STATUS IN (2, 3,4,5) THEN 1 ELSE 0 END)	-- �Ƿ����
		, stype = ts.spl_type                                                   -- ��Ӧ������ 1���ⲿ��Ӧ�̣�2���ڲ���Ӧ�̣�3��ί�⹩Ӧ��,4: ������
	FROM HPUR.dbo.TPU_SUPPLIER ts
	UNION ALL
	SELECT
		(CASE WHEN splr_type = 'H' THEN 2 ELSE 1 END)
		, splr_code
		, splr_short_name_cn
		, splr_name_cn
		, splr_certificate_type
		, splr_certificate_code
		, isenable
		, 4
	FROM HSRP.dbo.tfi_suppliers WHERE splr_code <> '-1'
	UNION ALL
	SELECT
		2
		, RTRIM(hem.emp_id)
		, RTRIM(hem.emp_name) + (CASE WHEN hem.emp_lea_date IS NULL THEN '' ELSE '(��ְ)' END)
		, RTRIM(hem.emp_name)
		, ''
		, ''
		, (CASE WHEN hem.emp_lea_date IS NULL THEN 1 ELSE 0 END)
		, 1
	FROM HR90.dbo.v_emp_mstr hem
	WHERE NOT EXISTS(SELECT 1 FROM HSRP.dbo.tfi_suppliers WHERE splr_code = hem.emp_id)
	UNION ALL
	SELECT
		3
		, cust_code
		, cust_name
		, cust_name_cn
		, ''
		, ''
		, isenable = (CASE WHEN cust_status IN (1, 2, 5) THEN 1 ELSE 0 END)
		,1
	FROM HSAL.dbo.tsa_customer
	UNION ALL
	SELECT
		4
		, cc_code
		, cc_desc
		, cc_full
		, ''
		, ''
		, isenable
		,1
	FROM v_fi_dept

WITH CHECK OPTION;
GO
USE [FIDB]
GO

IF(OBJECT_ID('v_fi_twfm','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_twfm AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-08
-- Description:	������Ϣ��ͼ
-- modify1:������˱����ֶ� by liuxiang 
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_twfm]
WITH VIEW_METADATA
AS
	SELECT
		tm.wfm_id
		, tg.wfg_id
		, tg.wfg_name							-- ���̷�������
		, tm.wfm_code							-- ���̱���
		, tm.wfm_name							-- ��������
		, tm.wfm_comment						-- ����˵��
		, acurl = tm.wfm_form_url				-- �������ҳ��url
		, aburl = tm.wfm_form_url1				-- ����ҳ��url
		, glrm_url = tm.wfm_form_url3           -- ƾ֤����URL
		, a_table=wfm_form_a_code
		, tm.wfm_status
	FROM HPORTAL.dbo.twf_m tm					-- ��������
	LEFT JOIN HPORTAL.dbo.twf_group tg			-- ���̷����
	ON tg.wfg_id = tm.wfm_group_id
	WHERE tm.wfm_type=1 AND tm.wfm_cc_code IS NULL
	
	--SELECT * FROM HPORTAL.dbo.twf_m WHERE wfm_code = 'AC11'
	
WITH CHECK OPTION;
GO
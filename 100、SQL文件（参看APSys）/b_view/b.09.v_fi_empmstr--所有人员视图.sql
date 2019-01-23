USE [FIDB]
GO

IF(OBJECT_ID('v_fi_empmstr','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_empmstr AS SELECT id=1;');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-07
-- Description:	����Ա����Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_empmstr]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = hea.emp_id					-- ����
		, emp_name = RTRIM(hea.emp_name) + (CASE WHEN hea.emp_lea_date IS NULL THEN '' ELSE '(��ְ)' END) -- ����
		, cc_code = hea.cc_code				-- ���Ŵ���
		, cc_level = hea.cc_level			-- ����level
		, cc_desc = RTRIM(hea.cc_desc)				-- ���ż��
		, cc_full = RTRIM(hea.cc_desc)				-- ����ȫ��
		, duty_id = hea.bz_id						-- ��λid
		, duty_name = hea.bz_desc					-- ��λ����
		, emp_duty_huntkey = hea.emp_duty_huntkey	-- ְ��
		, emp_name_py = hea.emp_name_py
		, isenable = (CASE WHEN hea.emp_lea_date IS NULL THEN 1 ELSE 0 END) -- �Ƿ���ְ 1��ְ 0��ְ
		, emp_cost=hea.emp_cost
	FROM HR90.dbo.v_emp_mstr hea

WITH CHECK OPTION;
GO
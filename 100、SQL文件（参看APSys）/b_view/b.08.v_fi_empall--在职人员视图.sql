USE [FIDB]
GO

IF(OBJECT_ID('v_fi_empall','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_empall AS SELECT id=1;');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-07
-- Description:	��ְԱ����Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_empall]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = hea.emp_id							-- ����
		, emp_name = RTRIM(hea.emp_name)			-- ����
		, cc_code = hea.cc_code						-- ���Ŵ���
		, cc_level = hea.cc_level					-- ����level
		, cc_desc = RTRIM(cm.cc_desc)				-- ���ż��
		, cc_full = RTRIM(cm.cc_full)				-- ����ȫ��
		, duty_id = hea.bz_id						-- ��λid
		, duty_name = hea.bz_desc					-- ��λ����
		, emp_duty_huntkey = hea.emp_duty_huntkey	-- ְ��
		, emp_sal_type = hea.emp_sal_type			-- ְԱorԱ��
		, emp_memo = uem.emp_memo					-- �칫�绰
		, emp_name_py = hea.emp_name_py				-- ����ƴ��
		, emp_cost=hea.emp_cost
	FROM HR90.dbo.h_emp_all hea
	INNER JOIN HR90.dbo.cc_mstr1 cm ON cm.cc_code = hea.cc_code AND cm.cc_enable = 0
	LEFT JOIN HR90.dbo.u_emp_mstr uem ON uem.emp_id=hea.emp_id

WITH CHECK OPTION;
GO
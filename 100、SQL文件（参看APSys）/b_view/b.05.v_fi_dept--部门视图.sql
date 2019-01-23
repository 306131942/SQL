USE [FIDB]
GO

IF(OBJECT_ID('v_fi_dept','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_dept AS SELECT id=1;');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-07
-- Description:	������Ϣ��ͼ
-- =========================================================================================
alter VIEW [dbo].[v_fi_dept]
WITH VIEW_METADATA
AS
	SELECT
		cc_code = RTRIM(cm.cc_code)									-- ���Ŵ���
		, cc_desc = RTRIM(cm.cc_desc)								-- ���ż��
		, cc_full = RTRIM(cm.cc_full)								-- ����ȫ��
		, cc_level = RTRIM(cm.cc_level)								-- ����level
		, cc_indet = RTRIM(cm.cc_indet)
		, cm.cc_remark												-- ��������
		, isenable = (CASE WHEN cm.cc_enable = 0 THEN 1 ELSE 0 END)	-- �Ƿ���Ч 1��Ч 0ʧЧ
	FROM HR90.dbo.cc_mstr1 cm

WITH CHECK OPTION;
GO
USE [FIDB]
GO

IF(OBJECT_ID('v_fi_currency','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_currency AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-08
-- Description:	�ұ���Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_currency]
WITH VIEW_METADATA
AS
	SELECT
		tc.curr_code	-- �ұ����
		, tc.curr_name	-- �ұ�����
		, tc.curr_desc	-- �ұ�����
		, tc.curr_flag	-- ���ʱ�׼�ұ��־
		, isenable = (CASE WHEN tc.isenable = 1 AND (tc.curr_code = 'RMB' OR EXISTS (
			SELECT 1 FROM HPORTAL.dbo.tba_rate WHERE rate_curr_code1 = tc.curr_code
				AND rate_begdate <= CONVERT(VARCHAR(10), GETDATE(), 23) AND (rate_enddate IS NULL OR rate_enddate >= CONVERT(VARCHAR(10), GETDATE(), 23))))
			THEN 1 ELSE 0 END
		)	-- �Ƿ����
		, tc.acctid		-- ����(����/��Դ)
	FROM HPORTAL.dbo.tba_currency tc
	UNION ALL
	SELECT
		tc.curr_code	-- �ұ����
		, tc.curr_name	-- �ұ�����
		, tc.curr_desc	-- �ұ�����
		, tc.curr_flag	-- ���ʱ�׼�ұ��־
		, isenable = (CASE WHEN tc.isenable = 1 AND (tc.curr_code = 'RMB' OR EXISTS (
			SELECT 1 FROM HPORTAL.dbo.tba_rate WHERE rate_curr_code1 = tc.curr_code
				AND rate_begdate <= CONVERT(VARCHAR(10), GETDATE(), 23) AND (rate_enddate IS NULL OR rate_enddate >= CONVERT(VARCHAR(10), GETDATE(), 23))))
			THEN 1 ELSE 0 END
		)	-- �Ƿ����
		, 2		-- ����(����/��Դ)
	FROM HPORTAL.dbo.tba_currency tc

WITH CHECK OPTION;
GO
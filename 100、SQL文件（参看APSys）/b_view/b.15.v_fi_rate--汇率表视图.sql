USE [FIDB]
GO

IF(OBJECT_ID('v_fi_rate','V') IS NULL)
BEGIN
	  EXEC ('CREATE VIEW v_fi_rate AS SELECT id=1;');
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
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_rate]
WITH VIEW_METADATA
AS
	SELECT
		tr.rate_curr_code1		-- ����ұ�
		, tr.rate_curr_code2	-- ��λ��
		, tr.rate_rate1			-- ���㵥λ
		, tr.rate_rate2			-- ����
		, tr.rate_begdate		-- ��Ч����
		, tr.rate_enddate		-- ʧЧ����
		, tr.rate_rmks			-- ��ע
		, tr.isenable			-- �Ƿ����
		, tr.acctid				-- ����(����/��Դ)
	FROM HPORTAL.dbo.tba_rate tr

WITH CHECK OPTION;
GO
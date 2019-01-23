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
-- Author:		罗志胜
-- Create date: 2013-05-08
-- Description:	币别信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_currency]
WITH VIEW_METADATA
AS
	SELECT
		tc.curr_code	-- 币别代码
		, tc.curr_name	-- 币别名称
		, tc.curr_desc	-- 币别描述
		, tc.curr_flag	-- 国际标准币别标志
		, isenable = (CASE WHEN tc.isenable = 1 AND (tc.curr_code = 'RMB' OR EXISTS (
			SELECT 1 FROM HPORTAL.dbo.tba_rate WHERE rate_curr_code1 = tc.curr_code
				AND rate_begdate <= CONVERT(VARCHAR(10), GETDATE(), 23) AND (rate_enddate IS NULL OR rate_enddate >= CONVERT(VARCHAR(10), GETDATE(), 23))))
			THEN 1 ELSE 0 END
		)	-- 是否可用
		, tc.acctid		-- 区域(深圳/河源)
	FROM HPORTAL.dbo.tba_currency tc
	UNION ALL
	SELECT
		tc.curr_code	-- 币别代码
		, tc.curr_name	-- 币别名称
		, tc.curr_desc	-- 币别描述
		, tc.curr_flag	-- 国际标准币别标志
		, isenable = (CASE WHEN tc.isenable = 1 AND (tc.curr_code = 'RMB' OR EXISTS (
			SELECT 1 FROM HPORTAL.dbo.tba_rate WHERE rate_curr_code1 = tc.curr_code
				AND rate_begdate <= CONVERT(VARCHAR(10), GETDATE(), 23) AND (rate_enddate IS NULL OR rate_enddate >= CONVERT(VARCHAR(10), GETDATE(), 23))))
			THEN 1 ELSE 0 END
		)	-- 是否可用
		, 2		-- 区域(深圳/河源)
	FROM HPORTAL.dbo.tba_currency tc

WITH CHECK OPTION;
GO
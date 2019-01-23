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
-- Author:		罗志胜
-- Create date: 2013-05-08
-- Description:	汇率信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_rate]
WITH VIEW_METADATA
AS
	SELECT
		tr.rate_curr_code1		-- 换算币别
		, tr.rate_curr_code2	-- 本位币
		, tr.rate_rate1			-- 换算单位
		, tr.rate_rate2			-- 汇率
		, tr.rate_begdate		-- 生效日期
		, tr.rate_enddate		-- 失效日期
		, tr.rate_rmks			-- 备注
		, tr.isenable			-- 是否可用
		, tr.acctid				-- 区域(深圳/河源)
	FROM HPORTAL.dbo.tba_rate tr

WITH CHECK OPTION;
GO
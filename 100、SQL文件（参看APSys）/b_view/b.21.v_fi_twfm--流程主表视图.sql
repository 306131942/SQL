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
-- Author:		罗志胜
-- Create date: 2013-05-08
-- Description:	流程信息视图
-- modify1:增加审核表名字段 by liuxiang 
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_twfm]
WITH VIEW_METADATA
AS
	SELECT
		tm.wfm_id
		, tg.wfg_id
		, tg.wfg_name							-- 流程分类名称
		, tm.wfm_code							-- 流程编码
		, tm.wfm_name							-- 流程名称
		, tm.wfm_comment						-- 流程说明
		, acurl = tm.wfm_form_url				-- 流程审核页面url
		, aburl = tm.wfm_form_url1				-- 新增页面url
		, glrm_url = tm.wfm_form_url3           -- 凭证链接URL
		, a_table=wfm_form_a_code
		, tm.wfm_status
	FROM HPORTAL.dbo.twf_m tm					-- 流程主表
	LEFT JOIN HPORTAL.dbo.twf_group tg			-- 流程分类表
	ON tg.wfg_id = tm.wfm_group_id
	WHERE tm.wfm_type=1 AND tm.wfm_cc_code IS NULL
	
	--SELECT * FROM HPORTAL.dbo.twf_m WHERE wfm_code = 'AC11'
	
WITH CHECK OPTION;
GO
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
-- Author:		罗志胜
-- Create date: 2013-05-07
-- Description:	部门信息视图
-- =========================================================================================
alter VIEW [dbo].[v_fi_dept]
WITH VIEW_METADATA
AS
	SELECT
		cc_code = RTRIM(cm.cc_code)									-- 部门代码
		, cc_desc = RTRIM(cm.cc_desc)								-- 部门简称
		, cc_full = RTRIM(cm.cc_full)								-- 部门全称
		, cc_level = RTRIM(cm.cc_level)								-- 部门level
		, cc_indet = RTRIM(cm.cc_indet)
		, cm.cc_remark												-- 部门描述
		, isenable = (CASE WHEN cm.cc_enable = 0 THEN 1 ELSE 0 END)	-- 是否有效 1有效 0失效
	FROM HR90.dbo.cc_mstr1 cm

WITH CHECK OPTION;
GO
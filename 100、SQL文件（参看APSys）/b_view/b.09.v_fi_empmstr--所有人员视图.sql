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
-- Author:		罗志胜
-- Create date: 2013-05-07
-- Description:	所有员工信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_empmstr]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = hea.emp_id					-- 工号
		, emp_name = RTRIM(hea.emp_name) + (CASE WHEN hea.emp_lea_date IS NULL THEN '' ELSE '(离职)' END) -- 姓名
		, cc_code = hea.cc_code				-- 部门代码
		, cc_level = hea.cc_level			-- 部门level
		, cc_desc = RTRIM(hea.cc_desc)				-- 部门简称
		, cc_full = RTRIM(hea.cc_desc)				-- 部门全称
		, duty_id = hea.bz_id						-- 岗位id
		, duty_name = hea.bz_desc					-- 岗位名称
		, emp_duty_huntkey = hea.emp_duty_huntkey	-- 职级
		, emp_name_py = hea.emp_name_py
		, isenable = (CASE WHEN hea.emp_lea_date IS NULL THEN 1 ELSE 0 END) -- 是否在职 1在职 0离职
		, emp_cost=hea.emp_cost
	FROM HR90.dbo.v_emp_mstr hea

WITH CHECK OPTION;
GO
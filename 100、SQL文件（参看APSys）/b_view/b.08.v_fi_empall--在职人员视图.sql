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
-- Author:		罗志胜
-- Create date: 2013-05-07
-- Description:	在职员工信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_empall]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = hea.emp_id							-- 工号
		, emp_name = RTRIM(hea.emp_name)			-- 姓名
		, cc_code = hea.cc_code						-- 部门代码
		, cc_level = hea.cc_level					-- 部门level
		, cc_desc = RTRIM(cm.cc_desc)				-- 部门简称
		, cc_full = RTRIM(cm.cc_full)				-- 部门全称
		, duty_id = hea.bz_id						-- 岗位id
		, duty_name = hea.bz_desc					-- 岗位名称
		, emp_duty_huntkey = hea.emp_duty_huntkey	-- 职级
		, emp_sal_type = hea.emp_sal_type			-- 职员or员工
		, emp_memo = uem.emp_memo					-- 办公电话
		, emp_name_py = hea.emp_name_py				-- 姓名拼音
		, emp_cost=hea.emp_cost
	FROM HR90.dbo.h_emp_all hea
	INNER JOIN HR90.dbo.cc_mstr1 cm ON cm.cc_code = hea.cc_code AND cm.cc_enable = 0
	LEFT JOIN HR90.dbo.u_emp_mstr uem ON uem.emp_id=hea.emp_id

WITH CHECK OPTION;
GO
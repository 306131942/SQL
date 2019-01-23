USE [FIDB]
GO

IF(OBJECT_ID('v_fi_dutyall','V') IS NULL)
BEGIN
	  EXEC ('CREATE VIEW v_fi_dutyall AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-05-07
-- Description:	在职人员岗位信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_dutyall]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = ved.emp_id													-- 工号
		, emp_name = RTRIM(ved.emp_name)									-- 姓名
		, duty_id = ved.duty_id												-- 岗位id
		, duty_name = RTRIM(ved.duty_name)									-- 岗位名称
		, cc_code = ved.cc_code												-- 岗位所在部门code
		, cc_level = ved.cc_level											-- 岗位所在部门level
		, cc_desc = RTRIM(ved.cc_desc)										-- 岗位所在部门名称
		, ved.de_type_id													-- 岗位类型id
		, ved.de_type_name													-- 岗位类型名称
		, ved.de_type_order													-- 岗位类型排序
		, ismain = (CASE WHEN ved.de_type_id = 0 THEN 1 ELSE 0 END)			-- 是否任职岗位 1任职 0兼职/代职等
	FROM HR90.dbo.v_emp_duty ved

WITH CHECK OPTION;
GO
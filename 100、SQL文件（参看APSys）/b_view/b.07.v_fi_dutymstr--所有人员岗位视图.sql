USE [FIDB]
GO

IF(OBJECT_ID('v_fi_dutymstr','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_dutymstr AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-05-07
-- Description:	所有人员岗位信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_dutymstr]
WITH VIEW_METADATA
AS
	select 
	em.emp_id,               -- 工号
	em.emp_name,			 -- 姓名
	dm.duty_id,				 -- 岗位id
	duty_name,				 -- 岗位名称
	cc_code=dept_code,		 -- 岗位所在部门code
	cc_desc=RTRIM(LTRIM(dept_name)),-- 岗位所在部门名称 
	cc_level=dept_level,	 -- 岗位所在部门level
	de_type_id=pemr_type,	 -- 任职类型
	de_type_name=(CASE WHEN pm.pemr_type = 0 THEN '任职' WHEN pm.pemr_type = 1 THEN '兼职' ELSE '代职' END), --任职类型描述
	de_type_order=pemr_type_order, -- 排序
	de_sdate=pemr_sdate,
	de_edate=isnull(pemr_edate,'9999-12-31')
	FROM HR90.dbo.thr_person_mstr pm
	inner join HR90.dbo.thr_duty_mstr dm on pm.pemr_duty_id=dm.duty_id  and pm.pemr_sdate >= dm.duty_sdate and pm.pemr_sdate < isnull(dm.duty_edate,'9999-12-31')
	inner join hr90.dbo.thr_dept_mstr dp on dp.dept_id=dm.duty_dept_id and duty_sdate >= dp.dept_sdate and duty_sdate < isnull(dp.dept_edate,'9999-12-31')
	inner join hr90.dbo.h_emp_mstr em on pm.pemr_emp_id=em.emp_id

WITH CHECK OPTION;
GO


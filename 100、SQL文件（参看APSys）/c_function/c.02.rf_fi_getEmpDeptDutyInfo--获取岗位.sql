USE [FIDB]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rf_fi_getEmpDeptDutyInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[rf_fi_getEmpDeptDutyInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =========================================================================================
-- Author:		fdn
-- Create date: 2018-03-30
-- Description:	根据岗位ID和员工ID取部门/岗位信息
-- Format : duty_name + '-' + cc_desc + '(' + vfdm.de_type_name + ')' 
-- Modify[0]:
-- =========================================================================================

CREATE FUNCTION [dbo].[rf_fi_getEmpDeptDutyInfo]
(
@i_duty_id int,
@i_emp_id VARCHAR(20)
)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @info varchar(200);
	
	set @info = (SELECT RTRIM(duty.duty_name)+ '-' + RTRIM(dept.cc_desc) + '('
		+ (CASE WHEN empd.pemr_type = 0 THEN '任职' WHEN empd.pemr_type = 1 THEN '兼职' ELSE '代职' END) + ')'

	FROM (SELECT duty_id, duty_name, duty_dept_code, rn=ROW_NUMBER() OVER (PARTITION BY duty_id ORDER BY dm.id DESC)
		FROM HR90.dbo.thr_duty_mstr dm where dm.duty_id = @i_duty_id) duty
  
	INNER JOIN (SELECT pemr_id, pemr_emp_id, pemr_duty_id, pemr_type, pemr_type_order
		, rn = ROW_NUMBER() OVER (PARTITION BY pemr_emp_id, pemr_duty_id ORDER BY pemr_id DESC)
		FROM HR90.dbo.thr_person_mstr pm where pm.pemr_emp_id = @i_emp_id) empd 
		ON empd.rn =1 AND duty.duty_id = empd.pemr_duty_id

	INNER JOIN HR90.dbo.cc_mstr1 dept ON dept.cc_code = duty.duty_dept_code
	INNER JOIN HR90.dbo.v_emp_mstr empm ON empm.emp_id = empd.pemr_emp_id
	WHERE duty.rn = 1)

	RETURN isnull(@info, '');

END


GO


--select * FROM fidb.dbo.v_fi_empmstr 
--select  fidb.dbo.rf_fi_getEmpDeptDutyInfo(24021,'00000024')


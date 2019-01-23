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
-- Author:		��־ʤ
-- Create date: 2013-05-07
-- Description:	������Ա��λ��Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_dutymstr]
WITH VIEW_METADATA
AS
	select 
	em.emp_id,               -- ����
	em.emp_name,			 -- ����
	dm.duty_id,				 -- ��λid
	duty_name,				 -- ��λ����
	cc_code=dept_code,		 -- ��λ���ڲ���code
	cc_desc=RTRIM(LTRIM(dept_name)),-- ��λ���ڲ������� 
	cc_level=dept_level,	 -- ��λ���ڲ���level
	de_type_id=pemr_type,	 -- ��ְ����
	de_type_name=(CASE WHEN pm.pemr_type = 0 THEN '��ְ' WHEN pm.pemr_type = 1 THEN '��ְ' ELSE '��ְ' END), --��ְ��������
	de_type_order=pemr_type_order, -- ����
	de_sdate=pemr_sdate,
	de_edate=isnull(pemr_edate,'9999-12-31')
	FROM HR90.dbo.thr_person_mstr pm
	inner join HR90.dbo.thr_duty_mstr dm on pm.pemr_duty_id=dm.duty_id  and pm.pemr_sdate >= dm.duty_sdate and pm.pemr_sdate < isnull(dm.duty_edate,'9999-12-31')
	inner join hr90.dbo.thr_dept_mstr dp on dp.dept_id=dm.duty_dept_id and duty_sdate >= dp.dept_sdate and duty_sdate < isnull(dp.dept_edate,'9999-12-31')
	inner join hr90.dbo.h_emp_mstr em on pm.pemr_emp_id=em.emp_id

WITH CHECK OPTION;
GO


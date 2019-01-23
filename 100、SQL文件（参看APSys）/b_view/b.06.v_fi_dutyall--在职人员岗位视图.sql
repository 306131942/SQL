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
-- Author:		��־ʤ
-- Create date: 2013-05-07
-- Description:	��ְ��Ա��λ��Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_dutyall]
WITH VIEW_METADATA
AS
	SELECT
		emp_id = ved.emp_id													-- ����
		, emp_name = RTRIM(ved.emp_name)									-- ����
		, duty_id = ved.duty_id												-- ��λid
		, duty_name = RTRIM(ved.duty_name)									-- ��λ����
		, cc_code = ved.cc_code												-- ��λ���ڲ���code
		, cc_level = ved.cc_level											-- ��λ���ڲ���level
		, cc_desc = RTRIM(ved.cc_desc)										-- ��λ���ڲ�������
		, ved.de_type_id													-- ��λ����id
		, ved.de_type_name													-- ��λ��������
		, ved.de_type_order													-- ��λ��������
		, ismain = (CASE WHEN ved.de_type_id = 0 THEN 1 ELSE 0 END)			-- �Ƿ���ְ��λ 1��ְ 0��ְ/��ְ��
	FROM HR90.dbo.v_emp_duty ved

WITH CHECK OPTION;
GO
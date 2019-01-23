USE [FIDB]
GO

IF(OBJECT_ID('v_fi_paycode_info','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_paycode_info AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-04-26
-- Description:	查询对方代码/简称基础信息
-- Modify[1]:   2013-12-23 刘蔚 增加观察，暂停状态的供应商，此部分供应商有部分未付的货款或者抵扣项
-- Modify[2]:   2014-03-21 刘蔚 增加供应商的类型，1：外部供应商，2：内部供应商，3：委外供应商
-- Modify[3]:   2016-03-24 zhoupan 增加个人类型的全称
-- Modify[3]:   2016-05-09 liuxiang 增加证件名和证件号字段
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_paycode_info]
WITH VIEW_METADATA
AS
	SELECT
		ctype = 1																-- 对方类型：1供应商 2个人
		, pay_code = ts.SPL_CODE												-- 对方代码
		, pay_name = ts.SPL_SHORT_NAME											-- 对方简称
		, pay_fname = ts.SPL_NAME												-- 对方简称
		, pay_certificate_type=''                        						-- 证件名
		, pay_certificate_code=''												-- 证件号
		, isenable = (CASE WHEN ts.SPL_STATUS IN (2, 3,4,5) THEN 1 ELSE 0 END)	-- 是否可用
		, stype = ts.spl_type                                                   -- 供应商类型 1：外部供应商，2：内部供应商，3：委外供应商,4: 服务商
	FROM HPUR.dbo.TPU_SUPPLIER ts
	UNION ALL
	SELECT
		(CASE WHEN splr_type = 'H' THEN 2 ELSE 1 END)
		, splr_code
		, splr_short_name_cn
		, splr_name_cn
		, splr_certificate_type
		, splr_certificate_code
		, isenable
		, 4
	FROM HSRP.dbo.tfi_suppliers WHERE splr_code <> '-1'
	UNION ALL
	SELECT
		2
		, RTRIM(hem.emp_id)
		, RTRIM(hem.emp_name) + (CASE WHEN hem.emp_lea_date IS NULL THEN '' ELSE '(离职)' END)
		, RTRIM(hem.emp_name)
		, ''
		, ''
		, (CASE WHEN hem.emp_lea_date IS NULL THEN 1 ELSE 0 END)
		, 1
	FROM HR90.dbo.v_emp_mstr hem
	WHERE NOT EXISTS(SELECT 1 FROM HSRP.dbo.tfi_suppliers WHERE splr_code = hem.emp_id)
	UNION ALL
	SELECT
		3
		, cust_code
		, cust_name
		, cust_name_cn
		, ''
		, ''
		, isenable = (CASE WHEN cust_status IN (1, 2, 5) THEN 1 ELSE 0 END)
		,1
	FROM HSAL.dbo.tsa_customer
	UNION ALL
	SELECT
		4
		, cc_code
		, cc_desc
		, cc_full
		, ''
		, ''
		, isenable
		,1
	FROM v_fi_dept

WITH CHECK OPTION;
GO
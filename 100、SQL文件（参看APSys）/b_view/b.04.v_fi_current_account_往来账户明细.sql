USE [FIDB]
GO

IF(OBJECT_ID('v_fi_current_account','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_current_account AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-05-05
-- Description:	往来对象账户明细
-- Modify[1]:   2017-02-28 zhoupan 只查询往来账户为有效的往来明细
-- Modify[2]:   2017-03-10 zhoupan 增加isenable字段,0:无效 1:有效
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_current_account]
WITH VIEW_METADATA
AS
	SELECT splr.splr_code								-- 对象编码
		, splr.splr_short_name_cn						-- 对象名称
		, account_splr_code = splr2.splr_code			-- 子对象编码
		, tsa.suat_name									-- 开户名
		, tsa.suat_bank									-- 开户行
		, tsa.suat_account								-- 账号
		, tsa.suat_begdate								-- 开始时间
		, tsa.suat_enddate								-- 结束时间
		, suat_type=(CASE WHEN splr2.splr_type='H' THEN 2 ELSE 5 END)
		, tsa.isenable
	FROM HSRP.dbo.tfi_suppliers splr
	INNER JOIN HSRP.dbo.tfi_suppliers_account tsa ON splr.splr_id=tsa.suat_splr_id
	INNER JOIN HSRP.dbo.tfi_suppliers splr2 ON tsa.suat_relation_splr_id=splr2.splr_id
	WHERE splr2.isenable = 1
	UNION ALL
	SELECT pay_spl_code
		, pay_spat_name
		, pay_spl_code
		, pay_spat_name
		, pay_spat_bank
		, pay_spat_account
		, pay_spat_begdate
		, pay_spat_enddate
		, 1
		, 1
	FROM FIDB.dbo.v_fi_spl_account		--供应商付款账号视图
	UNION ALL
	SELECT acct.CUST_CODE
		, acct.CUST_NAME
		, acct.CUST_CODE
		, acct.CTAC_NAME_OPST
		, acct.CTAC_BANK_OPST
		, acct.CTAC_ACCT_OPST
		, acct.CTAC_BEGDATE
		, acct.CTAC_ENDDATE
		, 3
		, 1 
	FROM HSAL.dbo.v_sa_cust_bank acct	--客户银行账号
WITH CHECK OPTION;

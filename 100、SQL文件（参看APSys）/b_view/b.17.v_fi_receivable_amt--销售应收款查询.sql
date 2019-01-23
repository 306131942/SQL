USE [FIDB]
GO

IF(OBJECT_ID('v_fi_receivable_amt','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_receivable_amt AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2014-07-05
-- Description:	销售应收账款查询
-- modify[1]: 增加isenable条件限制 by liuxiang at 2014-07-09
-- Modify[2]: 刘蔚 2015-1-6 增加按照法人维度进行数据统计，并查询时按照法人关系进行分类统计
-- Modify[2]: 刘蔚 2015-6-5 调整未收应收款的查询逻辑。
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_receivable_amt]
WITH VIEW_METADATA
AS
	WITH ramt AS (
	SELECT tc2.cust_code
	,cust_receivalbe_amt=SUM(spvm_price*hportal.dbo.rf_ba_getrate(tpm.acctid,spvm_curr,'RMB',spvm_effdate) * (CASE WHEN spvm_trtype='ISS-SO' THEN  spvm_qty ELSE -1* spvm_qty END ))
	,data_type = 1,data_type_name = '未对' ,legal=spvm_legal
	FROM HSAL.dbo.tsa_pvo_m  tpm
	 INNER JOIN HSAL.dbo.TSA_CUSTOMER tc ON tc.cust_code=tpm.spvm_cust
	 INNER JOIN 
	  HSAL.dbo.tsa_cust_finace tcf ON tcf.ctfn_cust_id=tc.cust_id
	  INNER JOIN HSAL.dbo.TSA_CUSTOMER tc2 ON tcf.ctfn_settle_cust=tc2.cust_id
	  LEFT JOIN hsal.dbo.tsa_acct_m tam ON tam.actm_type=2 AND tam.actm_cust=tc2.cust_code AND tpm.spvm_legal=tam.actm_legal AND  tam.actm_audit_status IN (2,3,4,5) 
	 WHERE spvm_acct_flag = 1 AND tpm.spvm_effdate>=tam.actm_enddate AND isnull(tc2.cust_rdept,'')=''
	GROUP BY tc2.cust_code,tpm.spvm_legal
	UNION ALL
	SELECT actm_cust,SUM(actm_ccamt*hportal.dbo.rf_ba_getrate(tam.acctid,tam.actm_curr,'RMB',tam.actm_enddate))
	,data_type = 2,data_type_name = '未审',legal=actm_legal
	FROM HSAL.dbo.tsa_acct_m tam 
	WHERE tam.actm_audit_status IN (2,3,4) GROUP BY actm_cust,actm_legal
	UNION ALL
	SELECT paym_pay_code,SUM((paym_amt)* hportal.dbo.rf_ba_getrate(tpm.acctid,paym_currency,'RMB',paym_due_date))
	,data_type=3,data_type_name = '未收', legal=paym_legal
	FROM FIDB.dbo.tfi_pay_m tpm
	WHERE paym_paycode_type=3 AND paym_nbr_flag IN (3,4) AND tpm.isenable=1 GROUP BY paym_pay_code,tpm.paym_legal)
	SELECT ramt.cust_code,cust.cust_name,cust_receivalbe_amt,data_type,data_type_name,legal
	FROM ramt 
	LEFT JOIN HSAL.dbo.TSA_CUSTOMER cust ON cust.cust_code=ramt.cust_code
	
WITH CHECK OPTION;

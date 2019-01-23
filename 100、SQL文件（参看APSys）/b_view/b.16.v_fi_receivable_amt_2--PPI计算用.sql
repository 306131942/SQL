USE [HSAL]
GO

IF(OBJECT_ID('v_fi_receivable_amt_2','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_receivable_amt_2 AS SELECT id=1;');
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
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_receivable_amt_2]
WITH VIEW_METADATA
AS
	SELECT cust_code,cust_name,receivalbe_amt=SUM(spvm_amt)
	FROM
	(
		SELECT tc2.cust_code,tc2.cust_name,legal = spvm_legal, 
		spvm_amt = spvm_price * hportal.dbo.rf_ba_getrate(tpm.acctid, (CASE spvm_curr 
																	WHEN 'UD1' THEN 'USD' 
																	WHEN 'UD2' THEN 'USD' 
																	WHEN 'UD3' THEN 'USD' 
																	WHEN 'EU1' THEN 'EUR' 
																	WHEN 'EU2' THEN 'EUR' 
																	ELSE  spvm_curr END), 'RMB', spvm_effdate) 
			* (CASE WHEN spvm_trtype = 'ISS-SO' THEN spvm_qty ELSE -1 * spvm_qty END) -- 未对金额
		FROM   HSAL.dbo.tsa_pvo_m tpm
		INNER JOIN TSA_CUSTOMER tc ON tc.cust_code = tpm.spvm_cust
		INNER JOIN tsa_cust_finace tcf ON tcf.ctfn_cust_id = tc.cust_id
		INNER JOIN TSA_CUSTOMER tc2 ON tcf.ctfn_settle_cust = tc2.cust_id
		INNER JOIN HPORTAL.dbo.contrast_monthf cm ON spvm_effdate BETWEEN cm.mBegdate AND cm.mEndtime
		LEFT JOIN tsa_acct_m tam ON tam.actm_type = 2 AND tam.actm_cust = tc2.cust_code AND tpm.spvm_legal = tam.actm_legal AND tam.actm_audit_status IN (2, 3, 4, 5)
		WHERE LEFT(cm.fMonth,4)='2015' AND spvm_acct_flag = 1 AND spvm_price IS NOT NULL AND tpm.spvm_effdate >= tam.actm_enddate AND ISNULL(tc2.cust_rdept, '') = ''
		UNION ALL
		SELECT m.actm_cust,tc2.cust_name,m.actm_legal,receivalbe_amt=(ISNULL(actm_bamt,0) + ISNULL(actm_ccamt,0) - ISNULL(actm_crdamt,0) - ISNULL(actm_dedamt,0))
		FROM (SELECT m.actm_cust,m.actm_legal,actm_id=MAX(m.actm_id)
							FROM HSAL.dbo.tsa_acct_m m
							WHERE actm_audit_status IN (2, 3, 4, 5)
							GROUP BY m.actm_cust,m.actm_legal) actm 
		INNER JOIN tsa_acct_m m ON actm.actm_id=m.actm_id
		INNER JOIN TSA_CUSTOMER tc2 ON m.actm_cust = tc2.cust_code 
		UNION ALL
		SELECT tc.cust_code,tc.cust_name,legal=m.paym_legal,paym_amt=(paym_amt-paym_real_amt)*-1
		FROM FIDB.dbo.tfi_pay_m m
		INNER JOIN TSA_CUSTOMER tc ON tc.cust_code = m.paym_pay_code
		WHERE LEFT(m.paym_nbr,4) IN ('AP06','AC12','AC13') AND paym_paycode_type=3 AND paym_parent_id=0 
		AND NOT EXISTS (SELECT 1 FROM HSAL.dbo.tsa_acct_s WHERE scts_from_id=m.paym_id AND scts_from_nbr=m.paym_nbr)
		--SELECT * FROM FIDB.dbo.tfi_pay_m
	)temp
	GROUP BY cust_code, cust_name

 	
WITH CHECK OPTION;
 

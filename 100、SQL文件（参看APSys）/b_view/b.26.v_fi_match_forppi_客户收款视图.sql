USE [FIDB]
GO
IF(OBJECT_ID('v_fi_match_forppi','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_match_forppi AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:      朱振华
-- Create date: 2018-07-12
-- Description: 客户收款视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_match_forppi]
WITH VIEW_METADATA
AS

	SELECT m.atsm_id
		  , d.atsd_id
		  , m.atsm_nbr
		  , atsd_cust_code,ta.acct_legal,atsm_date = CONVERT(varchar(10), m.modtime, 120)
		  , d.atsd_matching_curr
		  , atsd_amt = CONVERT(DECIMAL(19,2), atsd_matching_amount * HPORTAL.dbo.rf_ba_getrate(1,d.atsd_matching_curr,'RMB',m.modtime))
		  ,atsd_type ='1'
	FROM HSAL.dbo.tsa_account_tx_split_m m
	INNER JOIN HSAL.dbo.tsa_account_tx_split_d d ON m.atsm_id = d.atsd_atsm_id
	INNER JOIN fidb.dbo.tfi_account_tx_split tats ON d.atsd_atsp_id= tats.atsp_id
	INNER JOIN fidb.dbo.tfi_account ta ON ta.acct_id = tats.atsp_acct_id
	WHERE atsm_audit_status = 5 
	and m.modtime >'2018-04-01'
UNION ALL
--自动认领
SELECT 1,atsp_id, tat.ACTX_NBR,tats.ATSP_CUST,ta.acct_legal,tats.ATSP_DATE,tats.ATSP_CURR,tat.ACTX_AMT_IN,atsd_type ='2'
FROM fidb.dbo.tfi_account_tx_split tats 
INNER JOIN fidb.dbo.tfi_account_tx tat ON tats.ATSP_TXID=tat.ACTX_ID
INNER JOIN fidb.dbo.v_fi_paycode_info fpi ON tats.ATSP_CUST=fpi.pay_code AND fpi.ctype=3
INNER JOIN fidb.dbo.tfi_account ta ON ta.acct_id = tat.actx_acct_id
WHERE isnull(tats.ATSP_CUST,'')<>'' AND tats.ATSP_TYPE IN(0,1) AND tat.ACTX_ID NOT IN(
SELECT tat1.ACTX_ID FROM fidb.dbo.tfi_account_tx_split tats
INNER JOIN hsal.dbo.tsa_account_tx_split_d tatd ON tatd.atsd_atsp_id=tats.ATSP_ID
INNER JOIN fidb.dbo.tfi_account_tx tat1 ON tats.ATSP_TXID=tat1.ACTX_ID) AND atsp_pay_type=0 AND tats.ATSP_DATE>'2018-04-01'
UNION ALL
--票据
SELECT DISTINCT 2,atsp_id,DRFT_NBR,tats.ATSP_CUST,td.drft_legal,tats.ATSP_DATE,tats.ATSP_CURR,DRFT_AMT,atsd_type ='3'
FROM fidb.dbo.tfi_account_tx_split tats
INNER JOIN fidb.dbo.tfi_draft td ON td.DRFT_ID=tats.ATSP_TXID
WHERE isnull(tats.ATSP_CUST,'')<>'' AND tats.ATSP_TYPE=2 AND tats.ATSP_DATE>'2018-04-01' 
	AND tats.ATSP_ID NOT IN (SELECT d.atsd_atsp_id FROM HSAL.dbo.tsa_account_tx_split_m m
	INNER JOIN HSAL.dbo.tsa_account_tx_split_d d ON m.atsm_id = d.atsd_atsm_id  WHERE atsm_audit_status = 5)
WITH CHECK OPTION;






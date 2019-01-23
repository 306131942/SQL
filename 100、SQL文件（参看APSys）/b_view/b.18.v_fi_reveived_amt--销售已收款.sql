USE [FIDB]
GO

IF(OBJECT_ID('v_fi_received_amt','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_received_amt AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��ε
-- Create date: 2014-08-08
-- Description:	���ۿͻ����տ��ѯ,��ѯÿ���ͻ��ӿ������ڵ�����Ϊֹ�����տ��ܶ�
-- Modify[1]: ��ε 2015-01-06 ���Ӱ��տ��˵��ķ��˽��й����������շ���ͳ�Ƶ�ǰ�����տ�����Ϊ�ͻ����룬����id�����ս��
-- Modify[2]: ��ε 2015-06-05 ���Ӱ��ս���ͻ�ͳ���տ���е��տͳ�Ƶ�����ͻ�ͷ�ϡ�
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_received_amt]
WITH VIEW_METADATA
AS
		SELECT tc2.cust_code AS atsp_cust,acct_legal,recd_amt=SUM(atsp_amt) FROM  fidb.dbo.TFI_ACCOUNT_TX_SPLIT tats 
		INNER JOIN fidb.dbo.TFI_ACCOUNT ta ON tats.atsp_acct_id=ta.ACCT_ID
		 INNER JOIN  HSAL.dbo.TSA_CUSTOMER tc 	 ON tc.cust_code= tats.atsp_cust
	 INNER JOIN  HSAL.dbo.tsa_cust_finace tcf ON tcf.ctfn_cust_id=tc.cust_id
	  INNER JOIN HSAL.dbo.TSA_CUSTOMER tc2 ON tcf.ctfn_settle_cust=tc2.cust_id
		LEFT JOIN hsal.dbo.tsa_acct_m tam ON tam.actm_type=2 AND tam.actm_cust=tc2.cust_code
		AND  tam.actm_audit_status IN (2,3,4,5)  AND tam.actm_legal=ta.acct_legal
		where  tats.ATSP_PAY_TYPE=0 AND isnull(tats.ATSP_CUST,'')<>'' AND tats.ATSP_DATE>=tam.actm_enddate 
		GROUP BY tc2.cust_code ,acct_legal
		
	
WITH CHECK OPTION;

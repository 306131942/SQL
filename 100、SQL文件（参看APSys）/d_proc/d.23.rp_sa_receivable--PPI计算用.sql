USE [HSAL]
GO
--2.��������洢���̵��ж�
--SELECT OBJECT_ID('rp_sa_receivable','P')
IF(OBJECT_ID('rp_sa_receivable','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_sa_receivable AS BEGIN SELECT 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2014-09-11
-- Description:	��ȡ����Ӧ�տ�
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_sa_receivable]
(
	@i_fyear VARCHAR(4)='2015',
	@i_beg_date INT=0,
	@i_end_date INT=0
)
AS
BEGIN TRY
	--DECLARE @i_fyear VARCHAR(4)='2015';
	--DECLARE @i_beg_date DATETIME='2015-01-01';
	--DECLARE @i_end_date DATETIME;
	IF ( OBJECT_ID('tempdb..#goal_temp') IS NOT NULL ) DROP TABLE #goal_temp
	CREATE TABLE #goal_temp(cust_code VARCHAR(10),leave_amt MONEY);
	IF ( OBJECT_ID('tempdb..#actm_temp') IS NOT NULL ) DROP TABLE #actm_temp
	--ȡ���ͻ������һ�Ŷ��˵�
	SELECT m.actm_cust,m.actm_legal,actm_id=MAX(m.actm_id)
	INTO #actm_temp
	FROM HSAL.dbo.tsa_acct_m m
	WHERE actm_audit_status IN (2, 3, 4, 5)
	GROUP BY m.actm_cust,m.actm_legal

	--��ȡ�����˵����С�ڵ���0������
	INSERT INTO #goal_temp
	SELECT actm_cust,leave_amt = ISNULL(actm_bamt,0) + ISNULL(actm_ccamt,0) - ISNULL(actm_crdamt,0) - ISNULL(actm_dedamt,0)
	FROM hsal.dbo.tsa_acct_m m 
	WHERE m.actm_id IN (SELECT actm_id FROM #actm_temp) 
	AND (ISNULL(actm_bamt,0) + ISNULL(actm_ccamt,0) - ISNULL(actm_crdamt,0) - ISNULL(actm_dedamt,0)) <= 0

	DELETE FROM #actm_temp 
	FROM hsal.dbo.tsa_acct_m m 
	WHERE m.actm_id=#actm_temp.actm_id AND (ISNULL(actm_bamt,0) + ISNULL(actm_ccamt,0) - ISNULL(actm_crdamt,0) - ISNULL(actm_dedamt,0)) <= 0
	--SELECT * FROM #goal_temp
	--SELECT * FROM #actm_temp
	--��������ؿͻ���ƾ֤������ʱ��
	IF ( OBJECT_ID('tempdb..#actm_temp1') IS NOT NULL ) DROP TABLE #actm_temp1
	SELECT 
	rn=ROW_NUMBER()OVER(PARTITION BY tc2.cust_code,vc.ficn_id ORDER BY spvm_effdate)
	,tc2.cust_code,vc.ficn_id
	,spvm_amt = spvm_price * hportal.dbo.rf_ba_getrate(m.acctid, (CASE spvm_curr 
																	WHEN 'UD1' THEN 'USD' 
																	WHEN 'UD2' THEN 'USD' 
																	WHEN 'UD3' THEN 'USD' 
																	WHEN 'EU1' THEN 'EUR' 
																	WHEN 'EU2' THEN 'EUR' 
																	ELSE  spvm_curr END), 'RMB', spvm_effdate)  
	* (CASE WHEN spvm_trtype = 'ISS-SO' THEN spvm_qty ELSE -1 * spvm_qty END)
	,spvm_effdate
	,sum_amt=0
	INTO #actm_temp1
	FROM HSAL.dbo.tsa_pvo_m m 
	INNER JOIN TSA_CUSTOMER tc ON tc.cust_code = m.spvm_cust
	INNER JOIN tsa_cust_finace tcf ON tcf.ctfn_cust_id = tc.cust_id
	INNER JOIN FIDB.dbo.VFI_CORPORATION vc ON tcf.ctfn_recv_acct=vc.ficn_code
	INNER JOIN TSA_CUSTOMER tc2 ON tcf.ctfn_settle_cust = tc2.cust_id	
	INNER JOIN #actm_temp actm ON actm.actm_cust=tc2.cust_code AND vc.ficn_id=actm.actm_legal
	INNER JOIN HPORTAL.dbo.contrast_monthf cm ON spvm_effdate BETWEEN cm.mBegdate AND cm.mEndtime
	WHERE LEFT(cm.fMonth,4)=@i_fyear 
	AND GETDATE() BETWEEN (DATEADD(DAY,@i_beg_date,DATEADD(MONTH,(CASE WHEN tcf.ctfn_settle_way='4' THEN 1 ELSE 0 END),m.spvm_effdate)))
	AND (DATEADD(DAY,@i_end_date,DATEADD(MONTH,(CASE WHEN tcf.ctfn_settle_way='4' THEN 1 ELSE 0 END),m.spvm_effdate)))
	--������ʱ���е���ƾ֤Ϊֹ�Ļ��ܽ��
	UPDATE a SET sum_amt=(SELECT SUM(ISNULL(b.spvm_amt,0)) FROM #actm_temp1 b WHERE b.cust_code=a.cust_code AND b.ficn_id=a.ficn_id AND b.rn<=a.rn)
	FROM #actm_temp1 a
	--SELECT * FROM #actm_temp1
	INSERT INTO #goal_temp
	SELECT cust_code,MAX(sum_amt)
	FROM(
	SELECT * FROM #actm_temp1 t3
	WHERE sum_amt<=(SELECT (ISNULL(actm_bamt,0) + ISNULL(actm_ccamt,0) - ISNULL(actm_crdamt,0) - ISNULL(actm_dedamt,0)) 
					 FROM hsal.dbo.tsa_acct_m m
					 INNER JOIN #actm_temp actm ON actm.actm_id=m.actm_id
					WHERE  actm.actm_cust=t3.cust_code AND actm.actm_legal=t3.ficn_id)
	)t2
	GROUP BY cust_code,ficn_id


	SELECT cust_code,leave_amt=SUM(leave_amt) FROM #goal_temp gt GROUP BY cust_code

END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
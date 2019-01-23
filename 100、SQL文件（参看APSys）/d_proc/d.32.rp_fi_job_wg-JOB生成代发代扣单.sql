USE FIDB
GO

IF(OBJECT_ID('rp_fi_job_wg','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_job_wg AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		luocg
-- Create date: 20180918
-- Description:	JOB生成代发代扣单
-- modify： 
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_job_wg]
(
	@i_mid INT = NULL
)

AS
BEGIN TRY

	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	DECLARE @m_id INT;
	DECLARE @hwag_month VARCHAR(20);
	DECLARE @hwag_emp VARCHAR(20);
	DECLARE @hwag_amt MONEY;
	DECLARE @abhm_nbr VARCHAR(20);
	DECLARE @abhm_pay_dept VARCHAR(20);
	DECLARE @abhm_emp VARCHAR(50);
	DECLARE @hwag_remark VARCHAR(1000);
	DECLARE @o_errmsg VARCHAR(1000);
	SET @o_errmsg = '';
	
	IF OBJECT_ID('tempdb..#wg_temp') IS NOT NULL
	BEGIN
		DROP TABLE #wg_temp;
	END
	
	CREATE TABLE #wg_temp(m_type INT, m_id INT, hwag_emp VARCHAR(20), hwag_amt MONEY,hwag_month VARCHAR(20), abhm_nbr VARCHAR(20)
								, abhm_pay_dept VARCHAR(20),abhm_emp VARCHAR(50), hwag_remark VARCHAR(1000))
	
	--支付方式为薪资代发，推送薪资代发，直接回写为已付，不推送执行单(在执行单job判断)，且不能撤销（在ap07流程判断）
	INSERT INTO #wg_temp
	SELECT		  m_type = 1--付款
				, m_id = m.abhm_id
				, hwag_emp = m.abhm_other_code
				, hwag_amt = m.abhm_pay_amt*m.abhm_rate
				, hwag_month = (SELECT mon.mMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE m.modtime BETWEEN mon.mBegdate AND mon.mEndtime)
				, abhm_nbr = m.abhm_nbr
				, abhm_pay_dept = m.abhm_pay_dept
				, abhm_emp = m.abhm_emp
				, hwag_remark = '付款通知单：'+ m.abhm_nbr + '推送的薪资代发, 金额：'+ + CAST(CAST(m.abhm_pay_amt*m.abhm_rate AS DECIMAL(19, 2)) AS VARCHAR(19)) + 'RMB'
				FROM FIDB.dbo.tfi_billhead_m m 
	WHERE m.abhm_pay_type = 8 AND m.abhm_status = 5 AND m.abhm_real_amt = 0 AND m.abhm_id = ISNULL(@i_mid, m.abhm_id)
	
	
	WHILE EXISTS(SELECT 1 FROM #wg_temp)
	BEGIN
		SELECT TOP(1)  
				@m_id			= m_id 
				, @hwag_emp		= hwag_emp 
				, @hwag_amt		= hwag_amt
				, @hwag_month	= hwag_month 
				, @abhm_nbr		= abhm_nbr 
				, @abhm_pay_dept= abhm_pay_dept
				, @abhm_emp		= abhm_emp
				, @hwag_remark	= hwag_remark
		FROM #wg_temp WHERE m_type = 1
		
		-- 推送薪资代发单
		EXEC HWAG.dbo.rp_wg_receivable @hwag_month, 3, @hwag_emp, @hwag_amt, @abhm_nbr, @abhm_pay_dept, @abhm_emp, @hwag_remark, @o_errmsg OUT;
		IF(@o_errmsg = '')
		BEGIN
			UPDATE FIDB.dbo.tfi_billhead_m SET abhm_status = 7, abhm_real_amt = abhm_pay_amt , abhm_rmks = abhm_rmks +'(已推送薪资代发)'
			WHERE abhm_id = @m_id;
			
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 7, isenable = 0, paym_real_amt = paym_amt
			FROM FIDB.dbo.tfi_billhead_m m
			WHERE paym_ref_id = m.abhm_id AND paym_ref_nbr = m.abhm_nbr AND m.abhm_id = @m_id;
		END	
		
		DELETE FROM #wg_temp WHERE m_id = @m_id
	END
	
	DELETE FROM #wg_temp WHERE m_type = 1
	SET @o_errmsg = '';
	
	--推送薪资代扣单
	INSERT INTO #wg_temp
	SELECT		  m_type = 2--收款
				, m_id = m.icbm_id
				, hwag_emp = m.icbm_rec_code
				, hwag_amt = m.icbm_inc_amt*m.icbm_rate
				, hwag_month = (SELECT mon.mMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE m.modtime BETWEEN mon.mBegdate AND mon.mEndtime)
				, abhm_nbr = m.icbm_nbr
				, abhm_pay_dept = m.icbm_rec_dept
				, abhm_emp = m.icbm_emp
				, hwag_remark = '收款通知单：'+ m.icbm_nbr+ '推送的薪资代扣, 金额：'+ + CAST(CAST(m.icbm_inc_amt*m.icbm_rate AS DECIMAL(19, 2)) AS VARCHAR(19)) + 'RMB'
			FROM FIDB.dbo.tfi_incomebill_m m 
	WHERE m.icbm_reccode_type = 2 AND m.icbm_rec_type = 7 AND m.icbm_status=9 AND m.icbm_real_amt = 0 AND m.icbm_id = ISNULL(@i_mid, m.icbm_id)
	
	
	WHILE EXISTS(SELECT 1 FROM #wg_temp)
	BEGIN
		SELECT TOP(1)  
				@m_id			= m_id 
				, @hwag_emp		= hwag_emp 
				, @hwag_amt		= hwag_amt
				, @hwag_month	= hwag_month 
				, @abhm_nbr		= abhm_nbr 
				, @abhm_pay_dept= abhm_pay_dept
				, @abhm_emp		= abhm_emp
				, @hwag_remark	= hwag_remark
		FROM #wg_temp WHERE m_type = 2
		
		-- 推送薪资代发单
		EXEC HWAG.dbo.rp_wg_receivable @hwag_month, 2, @hwag_emp, @hwag_amt, @abhm_nbr, @abhm_pay_dept, @abhm_emp, @hwag_remark, @o_errmsg OUT;
		IF(@o_errmsg = '')
		BEGIN
			UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 11, icbm_real_amt = @hwag_amt, icbm_rmks = icbm_rmks+' (已推送薪资代扣)' WHERE icbm_id = @m_id
					
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 11, paym_real_amt = @hwag_amt, isenable = 0 
			WHERE paym_nbr = (SELECT icbm_nbr FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @m_id)
		END	
		
		DELETE FROM #wg_temp WHERE m_id = @m_id
	END

		
	
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
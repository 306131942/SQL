USE [FIDB]
GO
--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_charge_add_icbm','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_charge_add_icbm AS BEGIN SELECT 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-05-19
-- Description:	生成应付单并推送后续单据
-- =========================================================================================
ALTER PROCEDURE rp_fi_charge_add_icbm
(
	@i_commit_date VARCHAR(20)			-- 收款截止日期
	, @i_commit_emp VARCHAR(20)			-- 收款操作员
	, @i_user_id VARCHAR(20)			-- 当前操作人		
	, @o_icbm_nbr VARCHAR(20) OUTPUT	-- 返回应付单号
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	--BEGIN TRAN
	/*
	-- 调试数据
	DECLARE @i_commit_date VARCHAR(20);
	DECLARE @i_commit_emp VARCHAR(20);
	DECLARE @o_icbm_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @i_commit_date = '00000001';
	SET @i_commit_emp = '012213';
	*/
	DECLARE @o_pay_other_mid INT;
	DECLARE @icbm_id INT;
	DECLARE @nbr VARCHAR(20);
	SET @o_rntStr = 'OK';
	SET @icbm_id = 0;
	SET @nbr = '';
	EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_pay_other_m', 'paym_nbr', @nbr OUTPUT; 
	
	INSERT INTO dbo.tfi_pay_other_m(paym_nbr, paym_nbr_flag, paym_item,paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept
				, paym_duty, paym_date, paym_due_date, paym_paycode_type,paym_pay_code, paym_spl_name
	            , paym_legal, paym_currency, paym_rate, paym_amt, paym_real_amt, paym_pay_type, paym_pay_bank, paym_pay_name, paym_pay_nbr
	            , paym_admin_type, paym_admin_dept, paym_admin_desc, paym_duty_emp, paym_rmks, paym_status, isenable, addtime, adduser, acctid, paym_gl_type) 
	SELECT @nbr, 4, ttp.typm_code, ttp.typm_id, ttp.typd_id , 1, @i_user_id, emp.cc_code, emp.duty_id, GETDATE(), GETDATE(), 2, @i_commit_emp, emp2.emp_name
		   , finc.ficn_id, 'RMB', 1.0, tchc.rec_amt, 0, 2 , '', '', ''
		   , 4, emp.cc_code, emp.cc_full, emp.emp_id, '系统生成，饭卡充值收款单。', 9, 1, getdate(), emp.emp_id, ttp.acctid, 0
	FROM (SELECT rec_amt = SUM(tchc.tchc_balance)
	      FROM FIDB.dbo.tfi_charge_card tchc
		  WHERE CONVERT(VARCHAR(10), tchc.tchc_rectime, 120) < @i_commit_date AND tchc.tchc_sceo_user = @i_commit_emp AND ISNULL(tchc.tchc_icbm_id, 0) = 0) tchc
	INNER JOIN (SELECT TOP(1) * FROM FIDB.dbo.v_fi_empall empa WHERE empa.emp_id = @i_user_id) emp ON 1=1
	INNER JOIN dbo.VFI_CORPORATION finc ON finc.code_value = emp.emp_cost
	INNER JOIN (SELECT TOP(1) * FROM FIDB.dbo.v_fi_empall empa WHERE empa.emp_id = @i_commit_emp) emp2 ON 1=1
	INNER JOIN (SELECT TOP(1) ttm.typm_code, ttm.typm_id, ttd.typd_id, ttm.acctid
	            FROM FIDB.dbo.tfi_type_m ttm
				INNER JOIN FIDB.dbo.tfi_type_d ttd ON ttm.typm_id = ttd.typd_typm_id
				WHERE ttm.typm_name LIKE '%其他%' AND ttd.typd_wfm_code = 'AR06') ttp ON 1 = 1
				
	SET @o_pay_other_mid = @@IDENTITY;
	
	UPDATE FIDB.dbo.tfi_charge_card SET tchc_icbm_id = @o_pay_other_mid
	WHERE CONVERT(VARCHAR(10), tchc_rectime, 120) < @i_commit_date AND tchc_sceo_user = @i_commit_emp AND ISNULL(tchc_icbm_id, 0) = 0
	
	-- 自动注册工作流
	DECLARE @wfm_id INT;
	DECLARE @remks VARCHAR(200)  --提交单据生成的单据摘要
	SET @remks='系统生成，饭卡充值收款单。';
	
	EXEC hportal.dbo.rp_wf_get_workflowByEmp 'AR06', @i_user_id, @o_pay_other_mid, @wfm_id OUTPUT, @o_rntStr OUTPUT;
	IF (@o_rntStr = 'OK')
	BEGIN
		EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfm_id, @i_user_id, @o_pay_other_mid, @nbr OUTPUT, @remks, '', '', @o_rntStr OUTPUT;
		
		IF @o_rntStr <> 'OK'
		BEGIN
			SET @o_rntStr = '[AR06]注册工作流失败！提示：' + @o_rntStr;
		END	
		ELSE
		BEGIN
			UPDATE FIDB.dbo.tfi_pay_other_m SET paym_nbr = @nbr WHERE paym_id = @o_pay_other_mid;	
		END
	END
			
	SELECT @o_icbm_nbr = tim.icbm_nbr, @icbm_id = tim.icbm_id
	FROM FIDB.dbo.tfi_pay_m tpm
	INNER JOIN FIDB.dbo.tfi_incomebill_d tid ON tpm.paym_id = tid.icbd_m_id
	INNER JOIN FIDB.dbo.tfi_incomebill_m tim ON tid.icbd_icbm_id = tim.icbm_id
	WHERE tpm.paym_nbr = @nbr	
	
	IF ISNULL(@o_icbm_nbr, '') = ''
	BEGIN
		SET @o_rntStr = '自动生成收款通知单失败，请联系运维人员。';
	END	
	
	IF(@o_rntStr <> 'OK')
	BEGIN
		RAISERROR(@o_rntStr, 16, 1);
	END

	--COMMIT TRAN
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
	--ROLLBACK;
END CATCH

GO
USE FIDB
GO

IF(OBJECT_ID('rp_fi_job_add_execute','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_job_add_execute AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2015-08-11
-- Description:	JOB���ɸ���ִ�е����ύ������
-- modify�� ���Ӱ��������̱������͸���ִ�е������Ͱ���֧�����ڼ���ǰʱ��ļ�������͸���ִ�е�
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_job_add_execute]
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	DECLARE @m_id INT;
	DECLARE @emp_id VARCHAR(20);
	DECLARE @wf_code VARCHAR(4);
	DECLARE @rntStr VARCHAR(200);
	DECLARE @dayinterval INT;
	
	SELECT @dayinterval= CAST(code_code AS INT ) FROM fidb.dbo.v_fi_tbacode ft WHERE ft.code_type='exem_interval'
	IF OBJECT_ID('tempdb..#exem_temp') IS NOT NULL
	BEGIN
		DROP TABLE #exem_temp;
	END
	DELETE FROM FIDB.dbo.tfi_execute_m WHERE exem_status = 1 AND exem_nbr LIKE '��ʱ%';
	
	CREATE TABLE #exem_temp(m_id INT,wf_code VARCHAR(4),emp_id VARCHAR(20))

	INSERT INTO #exem_temp
	SELECT tbm.abhm_id,wf_code=LEFT(tbm.abhm_nbr,4),tbm.moduser FROM FIDB.dbo.tfi_billhead_m tbm 
	WHERE tbm.abhm_status=5 
	and tbm.abhm_pay_amt > 0 --���ġ�֧����
	AND DATEDIFF(d,GETDATE(),abhm_pay_date)<= @dayinterval--��������-��ǰ����<=֪ͨ����ִ�еļ��ʱ��
	AND NOT EXISTS(SELECT 1 FROM FIDB.dbo.tfi_execute_m tem WHERE tem.exem_ref_mid=tbm.abhm_id AND tem.exem_ref_nbr=tbm.abhm_nbr)--δ���͹�ִ�е�
	AND (EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m tbm1
	            INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_abhm_id=tbm1.abhm_id
	            INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id=tbd.abhd_m_id
	            INNER JOIN FIDB.dbo.tfi_type_d ttd ON tpm.paym_typd_id=ttd.typd_id
	            WHERE  ISNULL(ttd.typd_excu_flag,0) = 1  AND tbm1.abhm_id=tbm.abhm_id)--���������ǲ���Ҫ����ִ�е�
		 OR EXISTS (SELECT 1 FROM FIDB.dbo.tfi_type_d WHERE typd_wfm_code = 'AP08' AND ISNULL(typd_excu_flag,0) = 1 AND tbm.abhm_type = 2))--�����ж�Ԥ�����߼�
	AND tbm.abhm_pay_type <> 8 --н�ʴ���������ִ�е�
	                       
	WHILE EXISTS(SELECT 1 FROM #exem_temp)
	BEGIN
		SELECT TOP(1) @m_id=m_id,@wf_code=wf_code,@emp_id=emp_id
		FROM #exem_temp
		
		EXEC FIDB.dbo.rp_fi_billhead_to_execute @i_exem_emp = '', @i_mid = @m_id, @o_rntStr = @rntStr OUTPUT;
		
		IF(@rntStr <> 'OK')
		BEGIN
			RAISERROR(@rntStr,16,1)
		END
		
		DELETE FROM #exem_temp WHERE m_id=@m_id
	END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
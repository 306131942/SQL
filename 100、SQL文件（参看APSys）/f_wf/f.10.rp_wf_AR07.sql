USE [FIDB]
GO
 
IF (OBJECT_ID('rp_wf_AR07' , 'P') IS NULL)
BEGIN
    EXEC (
             'CREATE PROCEDURE rp_wf_AR07 AS BEGIN SELECT 1; END'
         );
END
 GO
 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-07-06
-- Description:	
-- =========================================================================================
ALTER PROCEDURE rp_wf_AR07
(
    @m_id         INT --单据ID
    , @step_id    INT --流程步骤 0申请 1审核 2复核 3批准
    , @action_id  VARCHAR(20)--操作code 01通过	02退回	05撤销通过	10撤销完成	08退回上一步	11重新提交
    , @emp_id     VARCHAR(20) = '' -- 操作人
    , @node_id    INT -- 节点id
)
AS
BEGIN TRY
    SET ANSI_WARNINGS OFF;
    SET NOCOUNT ON;
    
    IF @step_id = 0--0申请
    BEGIN
        IF @action_id = '01'--01通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 2, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '01', @emp_id, 1;
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 1, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '05', @emp_id, 1 
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '10', @emp_id, 1 
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 1, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '08'--08退回上一步
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '11'--11重新提交
        BEGIN
            RETURN;
        END
    END
    ELSE 
    IF @step_id = 1--1审核
    BEGIN
        IF @action_id = '01'--01通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 3, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '01', @emp_id, 2 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 8, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '02', @emp_id, 2 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 2, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
            EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '10', @emp_id, 2
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 2, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '08'--08退回上一步
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '11'--11重新提交
        BEGIN
            RETURN;
        END
    END
    ELSE 
    IF @step_id = 2--2复核
    BEGIN
        IF @action_id = '01'--01通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '01', @emp_id, 3 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 8, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '02', @emp_id, 3 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 3, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
            EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '10', @emp_id, 3
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 3, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '08'--08退回上一步
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '11'--11重新提交
        BEGIN
            RETURN;
        END
    END
    ELSE 
    IF @step_id = 3--3批准
    BEGIN
        IF @action_id = '01'--01通过
        BEGIN
        	DECLARE @curr VARCHAR(20)
			DECLARE @rate DECIMAL(19,7)
			SELECT @curr = icbm_currency FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @m_id  
			SELECT @rate = HPORTAL.dbo.rf_ba_getrate(1, @curr , 'RMB' , GETDATE())
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_rate = @rate,icbm_status = 9, modtime = GETDATE(), modtime2 = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '01', @emp_id, 4 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 8, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '02', @emp_id, 4 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
            EXEC FIDB.dbo.rp_fi_ap_wf_update 'AR07', @m_id, '10', @emp_id, 4 
        	UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE icbm_id = @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '08'--08退回上一步
        BEGIN
            RETURN;
        END
        ELSE 
        IF @action_id = '11'--11重新提交
        BEGIN
            RETURN;
        END
    END
END TRY
BEGIN CATCH
    DECLARE @ErrorMessage  NVARCHAR(4000)
        , @ErrorSeverity   INT
        , @ErrorState      INT;
    SELECT @ErrorMessage = ERROR_MESSAGE()
        , @ErrorSeverity = ERROR_SEVERITY()
        , @ErrorState = ERROR_STATE();
    RAISERROR (@ErrorMessage , @ErrorSeverity , @ErrorState);
END CATCH
GO
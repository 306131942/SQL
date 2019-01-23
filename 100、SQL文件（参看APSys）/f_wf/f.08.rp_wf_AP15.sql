USE [FIDB]
GO
 
IF (OBJECT_ID('rp_wf_AP15' , 'P') IS NULL)
BEGIN
    EXEC (
             'CREATE PROCEDURE rp_wf_AP15 AS BEGIN SELECT 1; END'
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
ALTER PROCEDURE rp_wf_AP15
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
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 2, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
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
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 1, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
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
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 3, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 6, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 2, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
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
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 4, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id   
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status=6, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 3, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id  
            RETURN;
        END
        ELSE 
        IF @action_id = '10'--10撤销完成
        BEGIN
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
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 5, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
        	EXEC FIDB.dbo.rp_fi_accm_to_pay @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_accountcussent_m SET accm_status= 6, modtime = GETDATE(), moduser = @emp_id WHERE accm_id= @m_id 
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
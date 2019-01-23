USE [FIDB]
GO
 
IF (OBJECT_ID('rp_wf_AP06' , 'P') IS NULL)
BEGIN
    EXEC (
             'CREATE PROCEDURE rp_wf_AP06 AS BEGIN SELECT 1; END'
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
-- Modify[1]:   luocg 2018-01-26 结算方式为1(支付)时,若生成通知单,执行单,只要执行单未审核完,可撤销
-- =========================================================================================
ALTER PROCEDURE rp_wf_AP06
(
    @m_id         INT --单据ID
    , @step_id    INT --流程步骤 0申请 1审核 2复核 3批准
    , @action_id  VARCHAR(20)--操作code 01通过	02退回	05撤销通过	10撤销完成	08退回上一步	11重新提交
    , @emp_id     VARCHAR(20) = '' -- 操作人
    , @node_id    INT -- 节点id
)
AS
BEGIN TRY
	Declare @st INT --0关闭  1打开  -1未开账
	Declare @date varchar(20) --记账日期
	DECLARE @acctid INT 
	DECLARE @i_fmonth VARCHAR(10); --财月
    SET ANSI_WARNINGS OFF;
    SET NOCOUNT ON;
    
    IF @step_id = 0--0申请
    BEGIN
        IF @action_id = '01'--01通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 2, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
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
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 1, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
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
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 3, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 6, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 2, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
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
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 6, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
            RETURN;
        END
        ELSE 
        IF @action_id = '05'--05撤销通过
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 3, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
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
        	DECLARE @curr VARCHAR(20)
			DECLARE @rate DECIMAL(19,7)
			SELECT @curr = paym_currency FROM FIDB.DBO.tfi_pay_other_m WHERE paym_id = @m_id 
			SELECT @rate = HPORTAL.dbo.rf_ba_getrate(1, @curr , 'RMB' , GETDATE())
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_rate = @rate,paym_status = 5, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_other_to_pay @m_id, 'AP06'
            RETURN;
        END
        ELSE 
        IF @action_id = '02'--02退回
        BEGIN
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 6, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
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
        
			select  @acctid=acctid from fidb.dbo.tfi_pay_other_m where  paym_id=@m_id
			select  @date=CONVERT(varchar(100), tran_date , 23) from  fidb.[dbo].[v_fi_glrm_AP06] where mid=@m_id
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AP06', @date, 1, @st OUTPUT,1
			IF ( ISNULL(@st,0)=0  AND ISNULL(@date,'') <> '')
			BEGIN
				RAISERROR('账期已关闭，不能撤销完成.', 16, 1);
			END 
			
			--结算方式为1(支付)时,生成通知单,执行单,只要执行单未审核完,可撤销
            IF EXISTS(SELECT 1 FROM  FIDB.dbo.tfi_pay_other_m WHERE paym_id = @m_id AND paym_gl_type = 1)
        	BEGIN 
        		DECLARE @abhm_nbr VARCHAR(20);		--通知单号
        		DECLARE @abhm_id INT;				--通知单id
        		DECLARE @exem_nbr VARCHAR(20)='';   --看是否生成执行单
        		DECLARE @exem_id INT = 0 ;			--执行单id
        		DECLARE @exem_status INT = 0;		--执行单状态
        		SELECT TOP 1 @abhm_nbr = m.abhm_nbr, @abhm_id = m.abhm_id, @exem_nbr = isnull(em.exem_nbr,''), @exem_id = isnull(em.exem_id,0), @exem_status = isnull(em.exem_status,0)
        		FROM FIDB.dbo.tfi_pay_other_m om 
        		LEFT JOIN  fidb.dbo.tfi_billhead_d d ON om.paym_id = d.abhd_source_id AND om.paym_nbr = d.abhd_source_nbr 
        		LEFT JOIN  fidb.dbo.tfi_billhead_m m ON m.abhm_id = d.abhd_abhm_id
        		LEFT JOIN  fidb.dbo.tfi_execute_m em ON em.exem_ref_nbr = m.abhm_nbr AND em.exem_ref_mid = m.abhm_id AND  em.exem_status<>8
        		WHERE om.paym_id = @m_id AND  m.abhm_status <> 8
        		IF( @exem_status >= 5 AND @exem_status <>8 )--不能撤销
        		BEGIN
        			RAISERROR('单据推送的付款执行单已审核完，不可以撤销。',16,1)	
        		END	
        		ELSE
        		BEGIN
        			--删除执行单相关
        			DELETE FROM fidb.dbo.tfi_execute_a WHERE wfna_m_id = @exem_id
        			DELETE FROM HPORTAL.dbo.twf_a WHERE wfna_table = 'fidb.dbo.tfi_execute_a' AND wfna_m_id = @exem_id
        			DELETE FROM fidb.dbo.tfi_execute_m WHERE exem_id= @exem_id
        			--删除通知单相关
        			DELETE FROM fidb.dbo.tfi_billhead_a WHERE wfna_m_id = @abhm_id
        			DELETE FROM HPORTAL.dbo.twf_a WHERE wfna_table = 'fidb.dbo.tfi_billhead_a' AND wfna_m_id = @abhm_id
        			DELETE FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @abhm_id
        			DELETE FROM fidb.dbo.tfi_billhead_m WHERE abhm_id = @abhm_id
					DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@abhm_id AND paym_ref_nbr = @abhm_nbr
        			
        			--撤销其他应付单
        			UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
					DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AP06'
					 
					SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
					EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AP06', @i_fmonth, @m_id   
        		END                                        
        	END 
			
        	--存在isenable=1说明未生成通知单，可直接撤销
        	else IF (EXISTS (select 1 FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AP06' and  isenable=0)     
        	OR  --排除往来对账单  
        		EXISTS(
        			SELECT 1 FROM  fidb.dbo.tfi_pay_m pm
        			inner join FIDB.dbo.tfi_accountcussent_d d	ON d.accd_m_id = pm.paym_id
        			INNER JOIN FIDB.dbo.tfi_accountcussent_m  m ON m.accm_id = d.accd_accm_id
        			WHERE  pm.paym_ref_id= @m_id AND LEFT(paym_nbr,4)='AP06' AND m.accm_status<> 6)
        		)
        	BEGIN
        		RAISERROR('单据已经用于抵扣，不可以撤销。',16,1)	
        	END
 
        	ELSE
        	BEGIN
        		UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
				DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AP06' 
				
				SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
				EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AP06', @i_fmonth, @m_id   
        	END	
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
USE [FIDB]
GO
 
IF (OBJECT_ID('rp_wf_AR06' , 'P') IS NULL)
BEGIN
    EXEC (
             'CREATE PROCEDURE rp_wf_AR06 AS BEGIN SELECT 1; END'
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
-- Modify[1]:   luocg 2018-01-26 结算方式为0(收款)时,若生成收款通知单,只要收款通知单未审核完,可撤销
-- =========================================================================================
ALTER PROCEDURE rp_wf_AR06
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
			SELECT @curr = paym_currency FROM FIDB.dbo.tfi_pay_other_m WHERE paym_id = @m_id  
			SELECT @rate = HPORTAL.dbo.rf_ba_getrate(1, @curr , 'RMB' , GETDATE())
        	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_rate = @rate,paym_status = 5, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
        	EXEC FIDB.dbo.rp_fi_other_to_pay @m_id, 'AR06'
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
			select  @date=CONVERT(varchar(100), tran_date , 23) from  fidb.[dbo].[v_fi_glrm_AR06] where mid=@m_id
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AR06', @date, 1, @st OUTPUT,1
			IF ( ISNULL(@st,0)=0  AND ISNULL(@date,'') <> '')
			BEGIN
				RAISERROR('账期已关闭，不能撤销完成.', 16, 1);
			END 
			--结算方式为0(收款)时,生成收款通知单,只要通知单未匹配,可撤销
			IF EXISTS(SELECT 1 FROM  FIDB.dbo.tfi_pay_other_m WHERE paym_id = @m_id AND paym_gl_type = 0)
        	BEGIN 
        		DECLARE @icbm_nbr VARCHAR(20);		--通知单号
        		DECLARE @icbm_id INT;				--通知单id
        		DECLARE @icbm_status INT = 0;		--通知单状态
        		DECLARE @tdmm_status INT = 0;		--匹配单状态
        		SELECT TOP 1 @icbm_nbr = m.icbm_nbr, @icbm_id = m.icbm_id, @icbm_status = m.icbm_status, @tdmm_status =isnull(mm.tdmm_status,0)
        		FROM FIDB.dbo.tfi_pay_other_m om 
        		LEFT JOIN fidb.dbo.tfi_pay_m pm ON pm.paym_ref_nbr = om.paym_nbr AND pm.paym_ref_id = om.paym_id
        		LEFT JOIN  fidb.dbo.tfi_incomebill_d d ON d.icbd_m_id = pm.paym_id
        		LEFT JOIN  fidb.dbo.tfi_incomebill_m m ON m.icbm_id  = d.icbd_icbm_id
        		LEFT JOIN fidb.dbo.tfi_dealing_match_d md ON md.tdmd_bill_nbr = m.icbm_nbr
        		LEFT JOIN fidb.dbo.tfi_dealing_match_m mm ON md.tdmd_tdmm_id=mm.tdmm_id AND mm.tdmm_status <> 6
        		WHERE om.paym_id = @m_id AND  m.icbm_status <> 8 
        		IF( @icbm_status > 9 OR  @tdmm_status <> 0 )--不能撤销
        		BEGIN
        			RAISERROR('单据推送的收款通知单已匹配，不可以撤销。',16,1)	
        		END	
        		ELSE
        		BEGIN
        			--删除通知单相关
        			DELETE FROM fidb.dbo.tfi_incomebill_a WHERE wfna_m_id = @icbm_id
        			DELETE FROM HPORTAL.dbo.twf_a WHERE wfna_table = 'fidb.dbo.tfi_incomebill_a' AND wfna_m_id = @icbm_id
        			DELETE FROM fidb.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @icbm_id
        			DELETE FROM fidb.dbo.tfi_incomebill_m WHERE icbm_id = @icbm_id
					DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@icbm_id AND paym_ref_nbr = @icbm_nbr
        			
        			--撤销其他应付单
        			UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
					DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AR06' 
					
					SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
					EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AR06', @i_fmonth, @m_id   
        		END                                            
        	END
			
        	---- 记账方式，存在isenable=0，说明用于了抵扣，不能直接撤销
        	ELSE  IF (EXISTS (select 1 FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AR06' and isenable=0)  
        		OR  --排除往来对账单  
        		EXISTS(
        			SELECT 1 FROM  fidb.dbo.tfi_pay_m pm
        			inner join FIDB.dbo.tfi_accountcussent_d d	ON d.accd_m_id = pm.paym_id
        			INNER JOIN FIDB.dbo.tfi_accountcussent_m  m ON m.accm_id = d.accd_accm_id
        			WHERE  pm.paym_ref_id= @m_id AND LEFT(paym_nbr,4)='AR06' AND m.accm_status<> 6)
        		OR  --排除报销单  
        		EXISTS(
        			SELECT 1 FROM  fidb.dbo.tfi_pay_m pm
        			INNER  join FIDB.dbo.tfi_reim_borrow_relation d	ON d.rbre_paym_id = pm.paym_id
        			INNER JOIN FIDB.dbo.tfi_reimbursement  m ON m.RMMT_ID = d.rbre_rmmt_id
        			WHERE  pm.paym_ref_id= @m_id AND LEFT(paym_nbr,4)='AR06' AND m.rmmt_status   <> 7 )
        	)
        	BEGIN
        		RAISERROR('单据已经用于抵扣，不可以撤销。',16,1)
        	END
        	--记账方式，未用于抵扣，直接撤销
        	ELSE 
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_other_m SET paym_status = 4, modtime = GETDATE(), moduser = @emp_id WHERE paym_id = @m_id 
        		DELETE FROM fidb.dbo.tfi_pay_m WHERE paym_ref_id=@m_id AND LEFT(paym_nbr,4)='AR06' 
        		
        		SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
				EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AR06', @i_fmonth, @m_id   
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
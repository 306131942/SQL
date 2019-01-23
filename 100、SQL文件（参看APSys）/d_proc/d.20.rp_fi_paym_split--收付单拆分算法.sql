USE FIDB
GO
--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_paym_split','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_paym_split AS BEGIN SELECT 1; END');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-11-23
-- Description:	收付单拆分算法
-- midify[1]:预提单不拆分 by liuxiang at 2015-01-29
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_paym_split]
(
	@i_type TINYINT		-- 0收款 1付款
	, @i_mid INT		-- 单据id
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	DECLARE @curPayId INT;
	DECLARE @paym_id INT;
	DECLARE @new_paym_id INT;
	DECLARE @paym_ref_id INT;
	DECLARE @paym_ref_did INT;
	DECLARE @paym_nbr VARCHAR(20);
	DECLARE @paym_amt MONEY;
	DECLARE @abhd_amt MONEY;
	DECLARE @sort INT;
	DECLARE @paym_nbr_flag TINYINT;
	declare @paym_legal int;
	DECLARE @tb TABLE (paym_id INT, paym_ref_id INT, paym_ref_did INT, paym_nbr VARCHAR(20)
	, paym_amt MONEY, d_amt MONEY,paym_nbr_flag TINYINT,paym_legal int);
	
	-- 如果修改了金额，就要进行拆分
	IF (@i_type = 1)
	BEGIN
		INSERT INTO @tb (paym_id, paym_ref_id, paym_ref_did, paym_nbr, paym_amt, d_amt,paym_nbr_flag,paym_legal)
		SELECT paym_id, paym_ref_id, paym_ref_did, paym_nbr, paym_amt, abhd_pay_amt,paym_nbr_flag,paym_legal
		FROM FIDB.dbo.tfi_billhead_d
		INNER JOIN FIDB.dbo.tfi_pay_m ON paym_id = abhd_m_id
		WHERE abhd_abhm_id = @i_mid AND paym_amt <> abhd_pay_amt AND LEFT(paym_ref_nbr,4)<>'GL03' ;
	END
	ELSE
	BEGIN
		INSERT INTO @tb (paym_id, paym_ref_id, paym_ref_did, paym_nbr, paym_amt, d_amt,paym_nbr_flag,paym_legal)
		SELECT paym_id, paym_ref_id, paym_ref_did, paym_nbr, paym_amt, icbd_rec_amt,paym_nbr_flag,paym_legal
		FROM FIDB.dbo.tfi_incomebill_d
		INNER JOIN FIDB.dbo.tfi_pay_m ON paym_id = icbd_m_id
		WHERE icbd_icbm_id = @i_mid AND paym_amt <> icbd_rec_amt ;
	END
	WHILE EXISTS (SELECT 1 FROM @tb) -- 循环需要拆分的单据
	BEGIN
		SELECT TOP 1 @paym_id = paym_id, @paym_ref_id = ISNULL(paym_ref_id, 0), @paym_ref_did = ISNULL(paym_ref_did, 0)
		, @paym_nbr = paym_nbr, @paym_amt = paym_amt, @abhd_amt = d_amt,@paym_nbr_flag=paym_nbr_flag,@paym_legal=paym_legal
		FROM @tb;
		
		-- 查最大序号
		SELECT @sort = MAX(ISNULL(paym_split_sort, 1)) + 1 FROM FIDB.dbo.tfi_pay_m 
		WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND @paym_ref_did = ISNULL(paym_ref_did, 0) 
		AND paym_nbr = @paym_nbr AND paym_nbr_flag = @paym_nbr_flag
		AND paym_legal=@paym_legal;
		-- 更新明细收付单的金额及序号
		UPDATE FIDB.dbo.tfi_pay_m SET paym_amt = @abhd_amt, paym_split_sort = (CASE WHEN paym_split_sort > 0 THEN paym_split_sort ELSE 1 END)
		WHERE paym_id = @paym_id AND paym_legal=@paym_legal;
		-- 查询是否有已拆但未提交的收付单
		SET @curPayId = NULL;
		SELECT TOP 1 @curPayId = paym_id 
		FROM FIDB.dbo.tfi_pay_m WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND @paym_ref_did = ISNULL(paym_ref_did, 0) AND paym_nbr = @paym_nbr
		AND paym_id <> @paym_id AND isenable = 1 AND paym_parent_id = 0 AND paym_nbr_flag = @paym_nbr_flag  AND paym_legal=@paym_legal
		ORDER BY paym_split_sort;
		
		IF (@curPayId IS NOT NULL)
		BEGIN -- 如果有已拆且未提交的收付单，则将金额累加到第一条
			UPDATE FIDB.dbo.tfi_pay_m SET paym_amt = paym_amt + @paym_amt - @abhd_amt WHERE paym_id = @curPayId ;
		END
		ELSE
		BEGIN -- 否则拆单
			INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept
				, paym_duty, paym_date, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate
				, paym_amt,paym_nbr_amt, paym_real_amt, paym_pay_type, paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_dept
				, paym_duty_emp, paym_rmks, paym_status, paym_ref_nbr, paym_ref_id, paym_ref_did, paym_nbr_flag, paym_spl_name
				, paym_parent_id, paym_nbr, paym_split_sort, isenable, addtime, adduser, modtime, moduser, acctid, paym_admin_type, paym_admin_desc,paym_pay_deptcode)
			SELECT paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept
				, paym_duty, paym_date, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate
				, @paym_amt - @abhd_amt,paym_nbr_amt, 0, paym_pay_type, paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_dept
				, paym_duty_emp, paym_rmks, paym_status, paym_ref_nbr, paym_ref_id, paym_ref_did, paym_nbr_flag, paym_spl_name
				, 0, paym_nbr, @sort, 1, GETDATE(), adduser, GETDATE(), moduser, acctid, paym_admin_type, paym_admin_desc,paym_pay_deptcode
			FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @paym_id ;
			
			SET @new_paym_id = @@IDENTITY;
			
			UPDATE FIDB.dbo.tfi_reim_borrow_relation SET rbre_paym_id = @new_paym_id, modtime = GETDATE()
			FROM FIDB.dbo.TFI_REIMBURSEMENT rmmt
			WHERE rbre_rmmt_id = rmmt.RMMT_ID AND rbre_paym_id = @paym_id AND rmmt.RMMT_STATUS < =4;
		END
		
		DELETE FROM @tb WHERE paym_id = @paym_id;
	END
END TRY
BEGIN CATCH	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
USE FIDB
GO

IF(OBJECT_ID('rp_fi_paym_merge','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_paym_merge AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-11-23
-- Description:	收付单合并算法
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_paym_merge]
(
	@i_type TINYINT					-- 0收款 1付款
	, @i_mid INT					-- 单据id
	, @i_optype TINYINT				-- 0删单或退回逻辑 1撤消逻辑 2单内合并
	, @i_notmerge VARCHAR(100) = ''	-- 不合并
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	DECLARE @curPayId INT;
	DECLARE @paym_id INT;
	DECLARE @paym_ref_id INT;
	DECLARE @paym_ref_did INT;
	DECLARE @paym_nbr VARCHAR(20);
	DECLARE @paym_amt MONEY;
	DECLARE @sort INT;
	DECLARE @tb TABLE (paym_id INT, paym_nbr_flag INT, paym_ref_id INT, paym_ref_did INT, paym_nbr VARCHAR(20), paym_amt MONEY, paym_legal int);
	DECLARE @sql VARCHAR(8000);
	DECLARE @mergePayId INT;
	DECLARE @delPayId INT;
	DECLARE @paym_nbr_flag INT;
	declare @paym_legal int;
	DECLARE @did1 INT;
	DECLARE @did2 INT;
	DECLARE @tb1 TABLE (did INT, paym_id INT, paym_nbr_flag INT);
	
	IF (@i_optype = 2) -- 单内合并
	BEGIN
		-- 取需要合并的明细
		IF (@i_type = 1)
		BEGIN
			SET @sql = 'SELECT abhd_id, abhd_m_id, abhd_bill_type FROM (
	SELECT abhd_id, abhd_bill_type, abhd_m_id, rn = ROW_NUMBER() OVER (PARTITION BY ISNULL(tpm.paym_ref_id, 0), ISNULL(tpm.paym_ref_did, 0), tpm.paym_nbr ORDER BY abhd_id)
	FROM FIDB.dbo.tfi_billhead_d tbd
	INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.abhd_m_id
	WHERE abhd_abhm_id = ' + CAST(@i_mid AS VARCHAR(10)) + '
) m WHERE rn = 2';
		END
		ELSE
		BEGIN
			SET @sql = 'SELECT icbd_id, icbd_m_id, icbd_bill_type FROM (
	SELECT icbd_id, icbd_bill_type, icbd_m_id, rn = ROW_NUMBER() OVER (PARTITION BY ISNULL(tpm.paym_ref_id, 0), ISNULL(tpm.paym_ref_did, 0), tpm.paym_nbr ORDER BY icbd_id)
	FROM FIDB.dbo.tfi_incomebill_d tbd
	INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.icbd_m_id
	WHERE icbd_icbm_id = ' + CAST(@i_mid AS VARCHAR(10)) + '
) m WHERE rn = 2';
		END
		INSERT INTO @tb1 (did, paym_id, paym_nbr_flag)
		EXEC (@sql);
		WHILE EXISTS (SELECT 1 FROM @tb1)
		BEGIN
			SELECT TOP 1 @did2 = did, @delPayId = paym_id, @paym_nbr_flag = paym_nbr_flag FROM @tb1;
			
			-- 合并明细
			IF (@i_type = 1)
			BEGIN
				SELECT TOP 1 @did1 = abhd_id, @mergePayId = abhd_m_id
				FROM FIDB.dbo.tfi_billhead_d
				WHERE abhd_abhm_id = @i_mid 
				AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
				            WHERE tpm.paym_id = abhd_m_id 
							AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm2 
							            WHERE tpm2.paym_id = @delPayId AND tpm.paym_nbr_flag = tpm2.paym_nbr_flag
									    AND ISNULL(tpm2.paym_ref_id, 0) = ISNULL(tpm.paym_ref_id, 0) AND ISNULL(tpm2.paym_ref_did, 0) = ISNULL(tpm.paym_ref_did, 0) AND tpm2.paym_nbr = tpm.paym_nbr)
							);
				-- 将金额累加
				UPDATE tbd1 SET tbd1.abhd_pay_amt = tbd1.abhd_pay_amt + tbd2.abhd_pay_amt, tbd1.abhd_payb_amt = tbd1.abhd_payb_amt + tbd2.abhd_payb_amt
					, tbd1.abhd_recb_amt = tbd1.abhd_recb_amt + tbd2.abhd_recb_amt
				FROM FIDB.dbo.tfi_billhead_d tbd1
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd2 ON tbd2.abhd_id = @did2
				WHERE tbd1.abhd_id = @did1;
				-- 删除明细
				DELETE FROM FIDB.dbo.tfi_billhead_d WHERE abhd_id = @did2;
			END
			ELSE
			BEGIN
				SELECT TOP 1 @did1 = icbd_id, @mergePayId = icbd_m_id
				FROM FIDB.dbo.tfi_incomebill_d
				WHERE icbd_icbm_id = @i_mid AND EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = icbd_m_id AND EXISTS (
						SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm2 WHERE tpm2.paym_id = @delPayId AND tpm.paym_nbr_flag = tpm2.paym_nbr_flag
							AND ISNULL(tpm2.paym_ref_id, 0) = ISNULL(tpm.paym_ref_id, 0) AND ISNULL(tpm2.paym_ref_did, 0) = ISNULL(tpm.paym_ref_did, 0) AND tpm2.paym_nbr = tpm.paym_nbr
					)
				);
				-- 将金额累加
				UPDATE tid1 SET tid1.icbd_rec_amt = tid1.icbd_rec_amt + tid2.icbd_rec_amt, tid1.icbd_payb_amt = tid1.icbd_payb_amt + tid2.icbd_payb_amt
					, tid1.icbd_recb_amt = tid1.icbd_recb_amt + tid2.icbd_recb_amt
				FROM FIDB.dbo.tfi_incomebill_d tid1
				INNER JOIN FIDB.dbo.tfi_incomebill_d tid2 ON tid2.icbd_id = @did2
				WHERE tid1.icbd_id = @did1;
				-- 删除明细
				DELETE FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_id = @did2;
			END
			-- 合并pay_m
			SELECT @paym_ref_id = ISNULL(paym_ref_id, 0), @paym_ref_did = ISNULL(paym_ref_did, 0), @paym_nbr = paym_nbr, @sort = paym_split_sort, @paym_amt = paym_amt
			FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @delPayId;
			-- 累加金额
			UPDATE FIDB.dbo.tfi_pay_m SET paym_amt = paym_amt + @paym_amt WHERE paym_id = @mergePayId;
			-- 更新序号
			UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = paym_split_sort - 1
			WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr AND paym_split_sort > @sort;
			-- 删除pay_m
			DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @delPayId;
			
			-- 如果只有一条记录，则将拆分序号更新为NULL
			IF ((SELECT COUNT(1) FROM FIDB.dbo.tfi_pay_m WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr) = 1)
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = NULL WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr;
			END
			
			DELETE FROM @tb1 WHERE did = @did2;
		END
	END
	ELSE
	BEGIN
		-- 如果有拆单，则合并未使用的收付单
		IF (@i_type = 1)
		BEGIN
			SET @sql = 'SELECT paym_id, paym_nbr_flag, paym_ref_id, paym_ref_did, paym_nbr, paym_amt,paym_legal
						FROM FIDB.dbo.tfi_pay_m
			            WHERE paym_split_sort > 0 AND EXISTS (
							SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = ' + CAST(@i_mid AS VARCHAR(10)) + ' AND abhd_m_id = paym_id AND abhd_id NOT IN (0' + @i_notmerge + ')
						)';
		END
		ELSE
		BEGIN
			SET @sql = 'SELECT paym_id, paym_nbr_flag, paym_ref_id, paym_ref_did, paym_nbr, paym_amt,paym_legal
						FROM FIDB.dbo.tfi_pay_m
			            WHERE paym_split_sort > 0 AND EXISTS (
							SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = ' + CAST(@i_mid AS VARCHAR(10)) + ' AND icbd_m_id = paym_id AND icbd_id NOT IN (0' + @i_notmerge + ')
						)';
		END
		INSERT INTO @tb (paym_id, paym_nbr_flag, paym_ref_id, paym_ref_did, paym_nbr, paym_amt, paym_legal)
		EXEC (@sql);
		WHILE EXISTS (SELECT 1 FROM @tb)
		BEGIN
			SELECT TOP 1 @paym_id = paym_id, @paym_nbr_flag = paym_nbr_flag, @paym_ref_id = ISNULL(paym_ref_id, 0), @paym_ref_did = ISNULL(paym_ref_did, 0), @paym_nbr = paym_nbr
				, @paym_amt = paym_amt,@paym_legal=paym_legal
			FROM @tb;
			
			-- 查找可合并的收付单(未在通知单中使用，但包含当前循环的收付单)
			SET @curPayId = NULL;
			SELECT TOP 1 @curPayId = paym_id
			FROM FIDB.dbo.tfi_pay_m 
			WHERE paym_legal=@paym_legal AND ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr AND paym_nbr_flag = @paym_nbr_flag
			AND isenable = 1 AND paym_parent_id = 0 AND paym_id <> @paym_id 
			AND (NOT EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_m_id = paym_id 
								AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = abhd_abhm_id AND abhm_status = 1)) 
				 AND NOT EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_m_id = paym_id 
								AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = icbd_icbm_id AND icbm_status = 1))
				)
			ORDER BY paym_split_sort;
			
			IF (@curPayId IS NOT NULL) -- 有可合并的收付单
			BEGIN
				-- 合并到序号最小的收付单上
				IF (@paym_id < @curPayId)
				BEGIN
					SET @mergePayId = @paym_id;
					SET @delPayId = @curPayId;
				END
				ELSE
				BEGIN
					SET @mergePayId = @curPayId;
					SET @delPayId = @paym_id;
				END
				UPDATE FIDB.dbo.tfi_pay_m SET paym_amt = paym_amt + (SELECT paym_amt FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @delPayId) WHERE paym_id = @mergePayId;
				-- 更新使用了这些需要合并的收付单的通知单子表
				UPDATE FIDB.dbo.tfi_billhead_d SET abhd_m_id = @mergePayId WHERE abhd_m_id = @delPayId;
				UPDATE FIDB.dbo.tfi_incomebill_d SET icbd_m_id = @mergePayId WHERE icbd_m_id = @delPayId;
				UPDATE FIDB.dbo.tfi_reim_borrow_relation SET rbre_paym_id = @mergePayId WHERE rbre_paym_id = @delPayId;
				-- 删除合并了的收付单
				DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @delPayId;
				-- 更新拆分序号
				SELECT @sort = paym_split_sort FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @delPayId;
				UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = paym_split_sort - 1
				WHERE paym_legal=@paym_legal AND ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr AND paym_split_sort > @sort;
				-- 如果只有一条记录，则将拆分序号更新为NULL
				IF ((SELECT COUNT(1) FROM FIDB.dbo.tfi_pay_m WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr) = 1)
				BEGIN
					UPDATE FIDB.dbo.tfi_pay_m SET paym_split_sort = NULL WHERE ISNULL(paym_ref_id, 0) = @paym_ref_id AND ISNULL(paym_ref_did, 0) = @paym_ref_did AND paym_nbr = @paym_nbr;
				END
			END
			
			DELETE FROM @tb WHERE paym_id = @paym_id;
		END
	END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
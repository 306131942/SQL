

USE [FIDB]
GO

IF(OBJECT_ID('rp_fi_ap_wf_update','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_ap_wf_update AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-05-03
-- Description:	审核后更新数据
-- Modify[1]: 2013-11-20 lzs AP07增加付款通知单修改明细金额后的拆分逻辑
-- modify[2]: 2014-2-28 刘蔚 增加AP07 批准通过后，回写采购对账单的已付金额逻辑
-- modfiy[3]: 增加采购的货款冻结逻辑 by liuxiang at 2014-07-08
-- modfiy[4]: 资产投资单(外部)审核通过推送收款通知单 by luocg at 2017/07/31
-- modfiy[5]: 付款通知增加货款冻结是否控制执行参数 by luocg at 2017-09-20
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_ap_wf_update]
(
	@i_wfcode VARCHAR(50)			-- 流程代码
	, @i_mid INT					-- 单据id
	, @i_opcode VARCHAR(2) = '01'	-- 操作代码：01通过 02退回 05撤销
	, @i_userid VARCHAR(20) = 'N/A'	-- 操作人
	, @i_step TINYINT = 4			-- 节点：1申请 2审核 3复核 4批准
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	/*
	DECLARE @i_wfcode VARCHAR(50);
	DECLARE @i_mid INT;
	DECLARE @i_opcode VARCHAR(2);
	DECLARE @i_userid VARCHAR(20);
	DECLARE @i_step TINYINT;
	
	SET @i_wfcode = 'AP05';
	SET @i_mid = 38;
	SET @i_opcode = '01';
	SET @i_userid = '00000001';
	SET @i_step = 4;
	*/
	--BEGIN TRAN -- 开始事务
	
	DECLARE @curPayId INT;
	DECLARE @optype TINYINT;
	DECLARE @rntStr VARCHAR(800);
	
	-----撤销用于账期判断--------------------------------
	DECLARE @st INT --0关闭  1打开  -1未开账
	DECLARE @date varchar(20) --记账日期
	DECLARE @acctid INT 
	DECLARE @i_fmonth VARCHAR(10); --财月
	-----撤销用于账期判断--------------------------------
	                             
	
	DECLARE @fi_billhead_freez_flag INT;
	SET @fi_billhead_freez_flag = 1;
	SELECT @fi_billhead_freez_flag = ISNULL(code.code_value, 0) FROM HPORTAL.dbo.tba_code code WHERE code.code_type = 'fi_billhead_freez_flag'
	
	-- =====付款通知单=====BEGIN=====
	IF (@i_wfcode = 'AP07')
	BEGIN
		IF (@i_opcode = '01') -- 提交时将付款通知写入应付表
		BEGIN
			-- 拆分
			EXEC FIDB.dbo.rp_fi_paym_split 1, @i_mid;
			-- 单内合并
			EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, 2;
			
			IF (@i_step = 1)
			BEGIN
				-- 插入应付表
				UPDATE FIDB.dbo.tfi_billhead_m SET abhm_nbr = tba.wfna_nbr
				FROM FIDB.dbo.tfi_billhead_a tba 
				WHERE abhm_id = tba.wfna_m_id AND abhm_id = @i_mid
				
				UPDATE FIDB.dbo.tfi_billhead_d 
				SET abhd_payb_amt = (CASE WHEN abhd_payb_amt =  0 THEN 0 ELSE abhd_pay_amt END)
				    , abhd_recb_amt =(CASE WHEN abhd_recb_amt = 0 THEN 0 ELSE abhd_pay_amt END)
				WHERE abhd_abhm_id = @i_mid
				
				INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept, paym_duty, paym_date
					, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate, paym_amt,paym_nbr_amt,paym_pay_type
					,  paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_type, paym_admin_dept, paym_admin_desc, paym_duty_emp, paym_rmks, paym_status, paym_ref_nbr
					, paym_ref_id, addtime, adduser, acctid, paym_nbr_flag, paym_spl_name, paym_parent_id, paym_nbr)
				SELECT '1', ttd2.typd_typm_id, ttd2.typd_id, 1 , tbm.abhm_emp, tbm.abhm_dept, tbm.abhm_duty, tbm.abhm_date
				, tbm.abhm_pay_date, tbm.abhm_othercode_type, tbm.abhm_other_code, tbm.abhm_legal, tbm.abhm_currency, tbm.abhm_rate, tbm.abhm_pay_amt, tbm.abhm_pay_amt
				, tbm.abhm_pay_type, tbm.abhm_pay_bank, tbm.abhm_pay_name, tbm.abhm_pay_nbr, 4, tbm.abhm_pay_dept
				, (SELECT TOP(1) cc_desc FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = tbm.abhm_pay_dept), tpm.paym_duty_emp, tbm.abhm_rmks, 5, tbm.abhm_nbr
				, tbm.abhm_id, tbm.addtime, tbm.adduser, tbm.acctid, 1, fpi.pay_fname, 0, tbm.abhm_nbr
				FROM FIDB.dbo.tfi_billhead_m tbm
				INNER JOIN (SELECT TOP(1) abhd_abhm_id, abhd_m_id, abhd_d_id 
				            FROM FIDB.dbo.tfi_billhead_d 
				            WHERE abhd_abhm_id = @i_mid ORDER BY abhd_id 
							) tbd ON tbd.abhd_abhm_id = tbm.abhm_id
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.abhd_m_id
				LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.ctype = tbm.abhm_paycode_type AND fpi.pay_code = tbm.abhm_pay_code
				LEFT JOIN FIDB.dbo.tfi_type_d ttd2 ON ttd2.typd_typm_id = tpm.paym_typm_id AND ttd2.typd_wfm_code = 'AP07' 
				WHERE tbm.abhm_id = @i_mid;
				SET @curPayId = @@identity;
				-- 更新parent_id和isenable=0
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = @curPayId, isenable = 0 
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
				
				--对关联付款合同的物资采购对账单，回写合同当期已付金额
        		IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		BEGIN 
					UPDATE d
        			SET d.CNTD_PAID_AMT = (SELECT SUM(abhd_pay_amt) FROM fidb.dbo.tfi_billhead_d d WHERE d.abhd_abhm_id = @i_mid AND ISNULL(d.abhd_cntd_id, 0)<>0)
        			FROM fidb.dbo.tfi_contract_d d
        			WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		END
			END
			ELSE
			BEGIN
				-- 先判断货款是否冻结
				IF (EXISTS(SELECT 1 FROM  hpur.dbo.TPU_ACCT_M am 
					INNER JOIN  fidb.dbo.tfi_pay_m tpm  ON am.ACTM_NBR=tpm.paym_ref_nbr AND am.ACTM_ID=tpm.paym_ref_id
					INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
					WHERE tbd.abhd_abhm_id = @i_mid AND am.ACTM_FREEZ_BEGDATE <= GETDATE() AND ISNULL(am.actm_freez_enddate, GETDATE()) >= GETDATE())
					AND @fi_billhead_freez_flag = 1)-- 0不进行货款是否冻结判断
													-- 1进行货款是否冻结判断，20170920有效使用中
					
				BEGIN
					RAISERROR (N'该待付货款还在冻结期内，不允许付款！', 11, 1); 
				END
			END
		END
		-- 撤消申请结点或审核/复核/批准结点退回时，删除付款通知在应付单的数据
		IF ((@i_opcode = '05' AND @i_step = 1) OR (@i_opcode = '02' AND (@i_step = 2 OR @i_step = 3 OR @i_step = 4)))
		BEGIN
			-- 更新parent_id
			UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
			-- 删除应付表数据
			DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AP07%';
			-- 合并
			SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
			EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, @optype;
			
			 --对关联付款合同的物资采购对账单，还原合同当期已付金额
        	IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        	BEGIN 
				UPDATE d
        		SET d.CNTD_PAID_AMT = 0
        		FROM fidb.dbo.tfi_contract_d d
        		WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        	END
			
		END
		IF (@i_opcode = '10') -- 审核后撤销，撤回冲销金额及状态
		BEGIN
			
			select  @acctid=acctid from fidb.dbo.tfi_billhead_m where  abhm_id=@i_mid
			select  @date=CONVERT(varchar(100), modtime , 23) from  fidb.dbo.tfi_billhead_m where  abhm_id=@i_mid
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AP07', @date, 1, @st OUTPUT,1
			IF ISNULL(@st,0)=0 
			BEGIN
				RAISERROR('账期已关闭，不能撤销完成.', 16, 1);
			END 
				
			--isenable2=1，双经销客户对账单已抵扣，不能撤销完成
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id  = @i_mid AND isenable2 = 1 )
			BEGIN
				RAISERROR('双经销客户对账单已抵扣，不能撤销完成。', 16, 1);
			END 
			--abhm_pay_type=8，已推送薪资代发
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_type=8)
			BEGIN
				RAISERROR('已推送薪资代发，不能撤销完成.', 16, 1);
			END 
			--增加对付款执行单的检查,若存在付款执行单则需要先撤销付款执行单才能撤销付款通知单.
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE exem_status<>8 
			AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id=@i_mid and abhm_id = exem_ref_mid AND abhm_nbr = exem_ref_nbr))
			BEGIN
				DECLARE @execute_nbr VARCHAR(200);
				SELECT @execute_nbr=exem_nbr  FROM FIDB.dbo.tfi_execute_m WHERE exem_status<>8 and EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id=@i_mid and abhm_id = exem_ref_mid AND abhm_nbr = exem_ref_nbr)
				SET @execute_nbr='该付款通知单存在付款执行单 '+ @execute_nbr +'，不允许撤销，若需要撤销单据，请先退回付款执行单！'
				RAISERROR (@execute_nbr, 11, 1); 
			END
		
			--测试用过
			--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
			--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
	
			--因为审批流节点可能动态，撤销完成也可能动态(这里需要流程设置和f.10.rp_wf_AP07.sql设置支持)，只能强制这样判断，避免多次进入这里，避免不进入这里
			--实施要求,本来只存在一个撤销完成就简单点
			IF  EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid AND tpm.paym_real_amt = tbd.abhd_pay_amt)
			BEGIN
				 ----测试用过
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
						
				--回写明细表的已收金额icbd_real_amt------------------新加begin
				--1直接全额回写收款明细和减掉对应金额的付款明细(包括权益方和收款方的),其他付款明细由执行单审核通过时回写
				--2主表为人rmb时，明细可以任何币别，主表为其他币别，明细也只能为主表币别
				--3所以撤销时，直接回写为0
				UPDATE tbd
				SET tbd.abhd_real_amt = 0
				FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_abhm_id = @i_mid;
				--回写明细表的已收金额icbd_real_amt------------------新加end
				
				-- 回写收付数据 BEGIN
				-- 回写收付主表已付金额
				UPDATE tpm SET tpm.paym_real_amt = 0
				FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid;
				-- 回写收付主表状态
				UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 5 ELSE 9 END)
					WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 6 ELSE 10 END)
					ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 7 ELSE 11 END) END)
					, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				FROM FIDB.dbo.tfi_pay_m tpm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d tbd WHERE tbd.abhd_m_id = tpm.paym_id AND tbd.abhd_abhm_id = @i_mid);
				
				--付款通知单对应的应付数据paym_amt = 0 ,不等于0等情况做了执行单才会处理回写
				UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 5,isenable = 1 WHERE paym_ref_id = @i_mid AND paym_amt = 0 
				 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = paym_ref_id AND abhm_nbr = paym_nbr);
				                                                                                                                             	

				-- 回写预付单已收金额及状态 BEGIN
				-- 回写预付单抵扣金额：abhm_prtn_amt
				UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) - ISNULL(abhd.abhd_pay_amt, 0.00)
				FROM FIDB.dbo.tfi_billhead_m abhm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
				INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
				WHERE abhd.abhd_abhm_id = @i_mid;
				-- 写预付单状态:abhm_status
				UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
					, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
				FROM FIDB.dbo.tfi_billhead_m abhm
				WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr AND EXISTS (
						SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
						WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid 
					)
				);
				-- 回写预付单已收金额及状态 END
				
				-- 回写预收单已收金额及状态 BEGIN
				-- 回写预收单抵扣金额：icbm_prtn_amt
				UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) - ISNULL(abhd.abhd_pay_amt, 0.00)
				FROM FIDB.dbo.tfi_incomebill_m icbm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
				INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
				WHERE abhd.abhd_abhm_id = @i_mid ;
				-- 写预收单状态:icbm_status
				UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
					, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
				FROM FIDB.dbo.tfi_incomebill_m icbm
				WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr AND EXISTS (
						SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
						WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid 
					)
				);
				-- 回写预收单已收金额及状态 END
				
				-- 回写发票抵扣金额
				UPDATE tiid SET tiid.ivid_offset_amt = ISNULL(tiid.ivid_offset_amt, 0.00) - ISNULL(tibr.inbr_offset_amt, 0.00)
				FROM FIDB.dbo.tfi_inv_in_d tiid
				INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
				WHERE tibr.inbr_abhm_id = @i_mid;
				-- 回写发票抵扣状态
				UPDATE tiid SET tiid.ivid_offset_status = (CASE WHEN tiid.ivid_offset_amt = 0 THEN 2 WHEN ABS(tiid.ivid_offset_amt) < ABS(tiid.ivid_amt) THEN 3 ELSE 4 END)
					, tiid.modtime = GETDATE(), tiid.moduser = @i_userid
				FROM FIDB.dbo.tfi_inv_in_d tiid
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_inv_bill_r tibr WHERE tibr.inbr_ivid_id = tiid.ivid_id AND tibr.inbr_abhm_id = @i_mid);
				
				-- 如果该通知单有借款收款单，则回写借款单已付金额
				UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) - b.abhd_pay_amt
				FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
				INNER JOIN (
					select sum(ISNULL(tbd.abhd_pay_amt, 0.00)) abhd_pay_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
					from FIDB.dbo.tfi_pay_m paym 
					INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = paym.paym_id
					WHERE paym.paym_nbr_flag=4 and tbd.abhd_abhm_id = @i_mid and paym_nbr like 'AC15%' 
					group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR
					and (tbmm.brmm_lr_code=b.paym_pay_code OR 
					(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)	
					
				
			END	
			IF (@i_step = 1) AND  NOT EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d d ON d.abhd_m_id = tpm.paym_id
				WHERE d.abhd_abhm_id = @i_mid AND tpm.paym_parent_id = 0 AND tpm.isenable = 1)		-- 申请节点撤销完成加合并应收逻辑
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				
				-- 更新parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
				-- 删除应付表数据
				DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AP07%';
				-- 合并
				SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
				EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, @optype;
				
				 --对关联付款合同的物资采购对账单，还原合同当期已付金额
        		IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		BEGIN 
					UPDATE d
        			SET d.CNTD_PAID_AMT = 0
        			FROM fidb.dbo.tfi_contract_d d
        			WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		END
				
			END	
			
			--删除记账数据
			SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
			EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AP07', @i_fmonth, @i_mid	
			
		END
		IF (@i_opcode = '01' AND @i_step = 4) -- 审核通过后回写单据金额及状态
		BEGIN
			-- 先判断货款是否冻结
			IF (EXISTS(SELECT 1 FROM  hpur.dbo.TPU_ACCT_M am 
				INNER JOIN  fidb.dbo.tfi_pay_m tpm  ON am.ACTM_NBR=tpm.paym_ref_nbr AND am.ACTM_ID=tpm.paym_ref_id
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid AND am.ACTM_FREEZ_BEGDATE <= GETDATE() AND ISNULL(am.actm_freez_enddate, GETDATE()) >= GETDATE())
				AND @fi_billhead_freez_flag = 1)-- 0不进行货款是否冻结判断
												-- 1进行货款是否冻结判断，20170920有效使用中
			BEGIN
				RAISERROR (N'该待付货款还在冻结期内，不允许付款！', 11, 1); 
			END

			-- 回写收付数据 BEGIN
			-- 回写收付主表已付金额
			UPDATE tpm SET 
			tpm.paym_pay_type = tbm.abhm_pay_type,
			tpm.paym_real_amt = (CASE WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN ISNULL(tpm.paym_real_amt, 0.00) + ISNULL(tbd.abhd_pay_amt, 0.00) ELSE tpm.paym_real_amt END)
			FROM FIDB.dbo.tfi_pay_m tpm
			INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
			INNER JOIN FIDB.dbo.tfi_billhead_m tbm ON tbd.abhd_abhm_id = tbm.abhm_id
			WHERE tbd.abhd_abhm_id = @i_mid;
			-- 回写收付主表状态
			UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 5 ELSE 9 END)
				WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 6 ELSE 10 END)
				ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 7 ELSE 11 END) END)
				, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
			FROM FIDB.dbo.tfi_pay_m tpm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d tbd WHERE tbd.abhd_m_id = tpm.paym_id AND tbd.abhd_abhm_id = @i_mid);--付款通知单权益方明细对应的应收应付数据
			
			--付款通知单对应的应付数据paym_amt = 0 ,不等于0等情况做了执行单才会处理回写
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 7,isenable = 0 WHERE paym_ref_id = @i_mid AND paym_amt = 0 
			AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = paym_ref_id AND abhm_nbr = paym_nbr);
			
			-- 回写预付单已收金额及状态 BEGIN
			-- 回写预付单抵扣金额：abhm_prtn_amt
			UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) + ISNULL(abhd.abhd_pay_amt, 0.00)
			FROM FIDB.dbo.tfi_billhead_m abhm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
			INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
			WHERE abhd.abhd_abhm_id = @i_mid;
			-- 写预付单状态:abhm_status
			UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
				, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
			FROM FIDB.dbo.tfi_billhead_m abhm
			WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr AND EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
					WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid
				)
			);
			-- 回写预付单已收金额及状态 END
			
			-- 回写预收单已收金额及状态 BEGIN
			-- 回写预收单抵扣金额：abhm_prtn_amt
			UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) + ISNULL(abhd.abhd_pay_amt, 0.00)
			FROM FIDB.dbo.tfi_incomebill_m icbm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
			INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
			WHERE abhd.abhd_abhm_id = @i_mid;
			-- 写预收单状态:abhm_status
			UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_inc_amt) THEN 6 ELSE 7 END)
				, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
			FROM FIDB.dbo.tfi_incomebill_m icbm
			WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr AND EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
					WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid
				)
			);
			-- 回写预收单已收金额及状态 END
			
			-- 回写发票抵扣金额
			UPDATE tiid SET tiid.ivid_offset_amt = ISNULL(tiid.ivid_offset_amt, 0.00) + ISNULL(tibr.inbr_offset_amt, 0.00)
			FROM FIDB.dbo.tfi_inv_in_d tiid
			INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
			WHERE tibr.inbr_abhm_id = @i_mid;
			
			IF exists (select 1 FROM FIDB.dbo.tfi_inv_in_d tiid
				INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
				WHERE tibr.inbr_abhm_id = @i_mid AND tiid.ivid_offset_amt<tibr.inbr_offset_amt)
			BEGIN
					RAISERROR (N'回写发票抵扣金额错误，系统异常！', 16, 1); 
			END
			
			-- 回写发票抵扣状态
			UPDATE tiid SET tiid.ivid_offset_status = (CASE WHEN tiid.ivid_offset_amt = 0 THEN 2 WHEN ABS(tiid.ivid_offset_amt) < ABS(tiid.ivid_amt) THEN 3 ELSE 4 END)
				, tiid.modtime = GETDATE(), tiid.moduser = @i_userid
			FROM FIDB.dbo.tfi_inv_in_d tiid
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_inv_bill_r tibr WHERE tibr.inbr_ivid_id = tiid.ivid_id AND tibr.inbr_abhm_id = @i_mid);
			
			-- 如果该通知单有借款收款单，则回写借款单已付金额
			UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) + b.abhd_pay_amt
			FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
			INNER JOIN (
				select sum(ISNULL(tbd.abhd_pay_amt, 0.00)) abhd_pay_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				from FIDB.dbo.tfi_pay_m paym 
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = paym.paym_id
				WHERE paym_nbr_flag=4 and tbd.abhd_abhm_id = @i_mid and paym_nbr like 'AC15%' 
				group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
			) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
				and (tbmm.brmm_lr_code=b.paym_pay_code OR 
				(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)	
			
			
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_amt = 0)
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_m 
				SET paym_status = 7, isenable = 0
				FROM FIDB.dbo.tfi_billhead_m m
				WHERE paym_ref_id = m.abhm_id AND paym_ref_nbr = m.abhm_nbr AND m.abhm_id = @i_mid;
				
				UPDATE FIDB.dbo.tfi_billhead_m SET abhm_status = 7 WHERE abhm_id = @i_mid;
			END
			
			--回写付款通知单明细表的已付金额字段-----------begin---(直接全额回写收款明细和减掉对应金额的付款明细(包括权益方和收款方的),其他付款明细由执行单审核通过时回写)
			--主表为人rmb时，明细可以任何币别，主表为其他币别，明细也只能为主表币别
			DECLARE @sum_abhd_real_amt MONEY;--明细(收)的总额
			DECLARE @temp_abhd_id INT;--明细(付)did
			DECLARE @temp_abhm_curr VARCHAR(10);--币别
			                                   
			SELECT  @temp_abhm_curr = abhm_currency FROM fidb.dbo.tfi_billhead_m WHERE abhm_id = @i_mid
			
			SET @sum_abhd_real_amt = (SELECT SUM(tbd.abhd_pay_amt * tbd.abhd_rate  )--全转成rmb
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(3,4,6))--明细(收)
		
			--第一步,直接回写明细已付金额(抵扣部分)
			UPDATE tbd
			SET tbd.abhd_real_amt = tbd.abhd_pay_amt--不管币别
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(3,4,6)--明细(收)
			
			IF OBJECT_ID('tempdb..#temp_d_pay') IS NOT NULL DROP TABLE #temp_d_pay;		
			SELECT tbd.* ,pm.paym_date
			INTO #temp_d_pay  
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			INNER JOIN fidb.dbo.tfi_pay_m pm ON pm.paym_id=tbd.abhd_m_id
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(1,2,5)--明细(付)
                                    
			
			WHILE((@sum_abhd_real_amt>0) AND EXISTS (SELECT 1 FROM #temp_d_pay))
			BEGIN
				SET @temp_abhd_id = (SELECT TOP 1 abhd_id FROM #temp_d_pay ORDER BY paym_date ASC)
				
				UPDATE tbd
				SET tbd.abhd_real_amt = (
					CASE WHEN @sum_abhd_real_amt > tbd.abhd_pay_amt *tbd.abhd_rate   --该明细不够抵扣时
					THEN tbd.abhd_pay_amt 
					ELSE @sum_abhd_real_amt/tbd.abhd_rate END) 
				FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_id = @temp_abhd_id
				
				SET @sum_abhd_real_amt = @sum_abhd_real_amt-
				(SELECT tbd.abhd_real_amt* abhd_rate  FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_id = @temp_abhd_id )
				
				--循环删除
				DELETE FROM #temp_d_pay WHERE abhd_id = @temp_abhd_id
			END
			
			DROP TABLE #temp_d_pay
		                                                         
			
			--回写付款通知单明细表的已付金额字段-----------end---(直接全额回写收款明细和减掉对应金额的付款明细(包括权益方和收款方的),其他付款明细由执行单审核通过时回写)
			
			
			
			----支付方式为薪资代发，推送薪资代发，直接回写为已付，不推送执行单(在执行单job判断)，且不能撤销（在ap07流程判断）
		 --   IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_type = 8)
			--BEGIN
			--	DECLARE @hwag_month VARCHAR(20);
			--	DECLARE @hwag_emp VARCHAR(20);
			--	DECLARE @hwag_amt MONEY;
			--	DECLARE @abhm_nbr VARCHAR(20);
			--	DECLARE @abhm_pay_dept VARCHAR(20);
			--	DECLARE @abhm_emp VARCHAR(50);
			--	DECLARE @hwag_remark VARCHAR(1000);
			--	DECLARE @o_errmsg VARCHAR(1000);
			--	SET @o_errmsg = 'OK';
				
			--	SELECT @hwag_emp = m.abhm_other_code
			--		, @hwag_amt = m.abhm_pay_amt*m.abhm_rate
			--		, @hwag_month = (SELECT mon.mMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE m.modtime BETWEEN mon.mBegdate AND mon.mEndtime)
			--		, @abhm_nbr = m.abhm_nbr
			--		, @abhm_pay_dept = m.abhm_pay_dept
			--		, @abhm_emp = m.abhm_emp
			--		, @hwag_remark = '付款通知单：'+ m.abhm_nbr + '推送的薪资代发, 金额：'+ + CAST(CAST(@hwag_amt AS DECIMAL(19, 2)) AS VARCHAR(19)) + 'RMB'
			--	FROM FIDB.dbo.tfi_billhead_m m WHERE m.abhm_id = @i_mid
			--	-- 推送薪资代发单
			--	EXEC HWAG.dbo.rp_wg_receivable @hwag_month, 3, @hwag_emp, @hwag_amt,@abhm_nbr, @abhm_pay_dept, @abhm_emp, @hwag_remark, @o_errmsg OUT;
			--	IF(@o_errmsg = 'OK')
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_billhead_m SET abhm_status = 7, abhm_real_amt = abhm_pay_amt 
			--		, abhm_rmks = abhm_rmks +'(已推送薪资代发)'
			--		WHERE abhm_id = @i_mid;
					
			--		UPDATE FIDB.dbo.tfi_pay_m 
			--		SET paym_status = 7, isenable = 0, paym_real_amt = paym_amt
			--		FROM FIDB.dbo.tfi_billhead_m m
			--		WHERE paym_ref_id = m.abhm_id AND paym_ref_nbr = m.abhm_nbr AND m.abhm_id = @i_mid;
			--	END	
				
			--END
		END
	END
	-- =====付款通知单=====END=====
	
	-- =====预付通知单=====BEGIN=====
		IF (@i_wfcode = 'AP08')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- 审核通过后回写单据金额及状态
			BEGIN
			    EXEC rp_fi_billhead_to_execute @i_exem_emp = '',@i_mid = @i_mid, @o_rntStr = @rntStr OUTPUT;
				IF (@rntStr <> 'OK')
				BEGIN
					RAISERROR(@rntStr, 16, 1);
				END
			END
			IF (@i_opcode = '10' AND @i_step = 4) -- 批准节点撤销通过
			BEGIN
			    --已生成审核完的执行单，不能撤销
				IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m  WHERE abhm_id  =  @i_mid AND
									EXISTS (SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE  exem_ref_mid = abhm_id AND exem_ref_nbr = abhm_nbr AND exem_status>4 AND exem_status<>8 )
									)
				BEGIN
						RAISERROR (N'预付通知单生成的执行单已审核，请先撤销执行单！', 16, 1); 
				END
				--已生成未审核完的执行单，删除
				ELSE IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m  WHERE abhm_id  =  @i_mid AND
									EXISTS (SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE  exem_ref_mid = abhm_id AND exem_ref_nbr = abhm_nbr AND exem_status <= 4)
									)
				BEGIN
					DECLARE @exem_id INT; 
					SELECT @exem_id = em.exem_id 
					FROM FIDB.dbo.tfi_billhead_m bm
					INNER JOIN FIDB.dbo.tfi_execute_m em ON bm.abhm_id = em.exem_ref_mid AND bm.abhm_nbr=em.exem_ref_nbr
					WHERE bm.abhm_id = @i_mid
					
					--删除执行单
					DELETE HPORTAL.dbo.twf_a WHERE wfna_table='fidb.dbo.tfi_execute_a' AND  wfna_m_id =@exem_id
					DELETE fidb.dbo.tfi_execute_a WHERE wfna_m_id =@exem_id
					DELETE fidb.dbo.tfi_execute_m WHERE exem_id = @exem_id
				END
			END
			
		END
	-- =====预付通知单=====END=====
	
	-- =====收款通知单=====BEGIN=====
	IF (@i_wfcode = 'AR07')
	BEGIN
		IF(@i_opcode = '99')
		BEGIN
				-- 插入流水导入表数据: 流水直接回写匹配金额和状态。
				DECLARE @atsp_tx_id INT;
				DECLARE @atsp_id INT;
					
				DECLARE @fi_is_cash_atsp INT;
				SET @fi_is_cash_atsp = 0;
				
				SET @atsp_id = 0;
				SELECT @fi_is_cash_atsp = ISNULL(code.code_value, 0) FROM HPORTAL.dbo.tba_code code WHERE code.code_type = 'fi_is_cash_atsp'
				-- 判断是否是现金支付
				IF (EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m m WHERE m.icbm_id = @i_mid AND m.icbm_rec_type = 1) AND @fi_is_cash_atsp = 1)
				BEGIN 
					-- 如果已经匹配流水的，撤销匹配。
					DECLARE @actr_id_99 INT = 0;
					WHILE EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_relation rela
							  INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
							  WHERE icbm.icbm_id = @i_mid)
					BEGIN
						SELECT TOP(1) @actr_id_99 = actr_id 
						FROM FIDB.DBO.tfi_account_tx_relation rela
						INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
						WHERE icbm.icbm_id = @i_mid
				        
						UPDATE icbm
						SET icbm_real_amt = ISNULL(icbm_real_amt, 0.00) - rela.actr_amt, icbm_status = 10, modtime = GETDATE(), moduser = @i_userid
						FROM FIDB.DBO.tfi_account_tx_relation rela
						INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr        
						WHERE rela.actr_id = @actr_id_99
						
						-- 删除或更新流水数据
						--SELECT @atsp_id = actr_atsp_id FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id_99 
						--IF(SELECT COUNT(1) FROM FIDB.dbo.tfi_dealing_match_m tdmm
						--			INNER JOIN FIDB.dbo.tfi_dealing_match_d tdmd ON tdmm.tdmm_id = tdmd.tdmd_tdmm_id
						--   WHERE tdmm_atsp_id = @atsp_id) = 1
						--BEGIN
						UPDATE FIDB.dbo.tfi_dealing_match_m SET isenable = 0 WHERE tdmm_atsp_id = @atsp_id
						--END
						--ELSE
						--BEGIN
						--	RAISERROR('该收款通知单已经手工匹配流水，请先检查手工匹配是否有误！',16,1);
						--END
						
						
						DELETE FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id_99
										
						IF EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_split atsp WHERE atsp.atsp_nbr LIKE 'AR07%' AND atsp_id = @atsp_id)
						BEGIN
							UPDATE FIDB.dbo.tfi_balance 
          					SET blnc_balance = blnc_balance + ISNULL(actx.actx_amt_out - actx.actx_amt_in, 0), blnc_date = GETDATE(), modtime = GETDATE(), moduser = @i_userid
          					FROM FIDB.DBO.tfi_account_tx actx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id)
								
							DELETE FROM FIDB.DBO.tfi_account_tx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id)
							
							DELETE FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id;
						END
						ELSE
						BEGIN
							UPDATE FIDB.DBO.tfi_account_tx_split SET atsp_rmks = '', atsp_status = 0, modtime = GETDATE(), moduser = @i_userid
							WHERE atsp_id = @atsp_id;
							
							UPDATE FIDB.DBO.tfi_account_tx SET actx_confirm = actx_confirm - atsp_amt, actx_state = (CASE WHEN actx_confirm - atsp_amt = 0 THEN 0 ELSE 1 END), modtime = GETDATE(), moduser = @i_userid
							FROM FIDB.DBO.tfi_account_tx_split
							WHERE atsp_id = @atsp_id AND actx_id = atsp_txid
						END	
						
					END
					
					SET @atsp_id = 0;
					INSERT INTO dbo.tfi_account_tx(actx_acct_id, actx_nbr, actx_cust_name, actx_cust_bank, actx_cust_acct
					            , actx_curr_type, actx_tx_time, actx_tx_rate,actx_amt_in, actx_amt_out, actx_confirm, actx_balance, actx_type
					            , actx_brief, actx_cust, actx_state, addtime, adduser, acctid, isenable, actx_ref_nbr)
					SELECT tim.icbm_acct_id, tim.icbm_nbr, '', '', '', tim.icbm_currency
						, tim.icbm_rec_date, tim.icbm_rate, tim.icbm_inc_amt, 0, tim.icbm_inc_amt, ISNULL(tb.blnc_balance, 0) + tim.icbm_inc_amt, 0
						, tim.icbm_rmks, tim.icbm_rec_code, 2, GETDATE(), @i_userid, tim.acctid, 1, tim.icbm_nbr
					FROM FIDB.dbo.tfi_incomebill_m tim
					LEFT JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
					WHERE tim.icbm_id = @i_mid 
					SET @atsp_tx_id = @@identity;
					-- 插入流水拆分表数据
					INSERT INTO FIDB.dbo.tfi_account_tx_split
					   (atsp_txid, atsp_nbr, atsp_adduser, atsp_cust, atsp_cust_bank, atsp_cust_name, atsp_cust_acct
					   , atsp_curr, atsp_date,atsp_rate, atsp_acct_id, atsp_acct_code, atsp_rmks
					   , atsp_type, atsp_seq, atsp_sum_amt, atsp_amt, atsp_status, atsp_pay_type, addtime, adduser, acctid)
					SELECT @atsp_tx_id, tim.icbm_nbr, tim.icbm_emp, '', '', '', ''
					, tim.icbm_currency, tim.icbm_rec_date, tim.icbm_rate, tim.icbm_acct_id, ISNULL(acct.acct_department,''), tim.icbm_rmks
					, 1, 1, tim.icbm_inc_amt, tim.icbm_inc_amt, 2, 0, GETDATE(), tim.icbm_emp, tim.acctid              
					FROM FIDB.dbo.tfi_incomebill_m tim
					LEFT JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
					LEFT JOIN FIDB.dbo.tfi_account acct ON acct.acct_id = tim.icbm_acct_id AND acct.acct_class = 0
					WHERE tim.icbm_id = @i_mid 
					SET @atsp_id=@@identity
					-- BEGIN 回写余额：dbo.tfi_balance,无记录做插入，有记录做更新
					IF(EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim 
							  INNER JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
							  WHERE tim.icbm_id = @i_mid AND tb.blnc_type=1))
					BEGIN
          				UPDATE FIDB.dbo.tfi_balance 
          				SET blnc_balance = blnc_balance + ISNULL(tim.icbm_inc_amt, 0)
						, blnc_date = GETDATE(), modtime = GETDATE(), moduser = tim.icbm_emp
          				FROM FIDB.dbo.tfi_incomebill_m tim 
						WHERE blnc_acct_id = tim.icbm_acct_id AND blnc_curr_type = tim.icbm_currency AND tim.icbm_id = @i_mid AND blnc_type = 1 
					END
					ELSE
					BEGIN
        				INSERT INTO FIDB.dbo.tfi_balance 
        				(blnc_acct_id, blnc_curr_type, blnc_balance, blnc_type, blnc_date, isenable, addtime, adduser, acctid)
        				SELECT tim.icbm_acct_id, tim.icbm_currency, tim.icbm_inc_amt, 1
        				, GETDATE(), 1, GETDATE(), tim.icbm_emp, tim.acctid
        				FROM FIDB.dbo.tfi_incomebill_m tim 
						WHERE tim.icbm_id = @i_mid
					END
					-- END 回写余额：dbo.tfi_balance,无记录做插入，有记录做更新
			    
					--	写关系表：tfi_account_tx_relation
					INSERT INTO FIDB.dbo.tfi_account_tx_relation 
					(actr_atsp_id, actr_bill_id, actr_bill_nbr, actr_bill_type, actr_amt, actr_tablename, actr_type, acctid, addtime, adduser) 
					SELECT @atsp_id, tim.icbm_id, tim.icbm_nbr, 1, tim.icbm_inc_amt, 'FIDB.dbo.tfi_incomebill_m', 1, tim.acctid, GETDATE(), tim.icbm_emp
					FROM FIDB.dbo.tfi_incomebill_m tim  
					WHERE tim.icbm_id = @i_mid
					-- 更新拆分表状态为已匹配
					UPDATE FIDB.dbo.tfi_account_tx_split SET atsp_status = 2 WHERE atsp_id = @atsp_id
					-- 更新拆分表状态为已匹配
					UPDATE FIDB.dbo.tfi_account_tx SET actx_state = 2 WHERE actx_id = @atsp_tx_id 
					-- 更新付款执行单数据
					UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_real_amt = icbm_inc_amt, icbm_status = 11
					WHERE icbm_id = @i_mid
				END
			END
		IF (@i_opcode = '01') -- 提交时将收款通知写入应付表
		BEGIN
			-- 拆分
			EXEC FIDB.dbo.rp_fi_paym_split 0, @i_mid;
			-- 单内合并
			EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, 2;
			
			IF (@i_step = 1)
			BEGIN
				-- 插入应付表
				UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_nbr = tba.wfna_nbr
				FROM FIDB.dbo.tfi_incomebill_a tba 
				WHERE icbm_id = tba.wfna_m_id AND icbm_id = @i_mid
				
				UPDATE FIDB.dbo.tfi_incomebill_d 
				SET icbd_payb_amt = (CASE WHEN icbd_payb_amt =  0 THEN 0 ELSE icbd_rec_amt END)
				    , icbd_recb_amt =(CASE WHEN icbd_recb_amt = 0 THEN 0 ELSE icbd_rec_amt END)
				WHERE icbd_icbm_id = @i_mid
				
				INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept, paym_duty
					, paym_date
					, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate, paym_amt,paym_nbr_amt,paym_pay_type
					,  paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_type, paym_admin_dept, paym_admin_desc
					, paym_duty_emp, paym_rmks, paym_status
					, paym_ref_nbr, paym_ref_id, addtime, adduser, acctid, paym_nbr_flag, paym_spl_name, paym_parent_id, paym_nbr)
				SELECT '3', ttd2.typd_typm_id, ttd2.typd_id, 1, tbm.icbm_emp, tbm.icbm_dept, tbm.icbm_duty
					, (CASE WHEN tpm.paym_nbr LIKE 'SA47%' THEN (SELECT TOP 1 DATEADD(day,1,actm_enddate) FROM HSAL.dbo.tsa_acct_m WHERE actm_nbr = tpm.paym_nbr) ELSE tbm.icbm_date END )
					, tbm.icbm_rec_date, tbm.icbm_reccode_type, tbm.icbm_rec_code, tbm.icbm_legal, tbm.icbm_currency, tbm.icbm_rate, tbm.icbm_inc_amt, tbm.icbm_inc_amt, tbm.icbm_rec_type
					, tbm.icbm_rec_bank, tbm.icbm_rec_company, tbm.icbm_rec_acct, 4, tbm.icbm_rec_dept, (SELECT TOP(1) cc_desc FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = tbm.icbm_rec_dept)
					, tpm.paym_duty_emp, tbm.icbm_rmks, 9
					, tbm.icbm_nbr, tbm.icbm_id, tbm.addtime, tbm.adduser, tbm.acctid, 3, fpi.pay_fname, 0, tbm.icbm_nbr
				FROM FIDB.dbo.tfi_incomebill_m tbm
				INNER JOIN (SELECT TOP(1) icbd_icbm_id, icbd_m_id, icbd_d_id
				            FROM FIDB.dbo.tfi_incomebill_d
				            WHERE icbd_icbm_id = @i_mid ORDER BY icbd_id) tbd ON tbd.icbd_icbm_id = tbm.icbm_id
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.icbd_m_id
				LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.ctype = tbm.icbm_reccode_type AND fpi.pay_code = tbm.icbm_rec_code
				LEFT JOIN FIDB.dbo.tfi_type_d ttd2 ON ttd2.typd_typm_id = tpm.paym_typm_id AND ttd2.typd_wfm_code = 'AR07' 
				WHERE tbm.icbm_id = @i_mid;
				SET @curPayId = @@identity;
				-- 更新parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = @curPayId, isenable = 0 WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
				);
			END
		END
		-- 撤消申请结点或审核/复核/批准结点退回时，删除收款通知在应付单的数据
		IF ((@i_opcode = '05' AND @i_step = 1) OR (@i_opcode = '02' AND (@i_step = 2 OR @i_step = 3 OR @i_step = 4)))
		BEGIN
			-- 更新parent_id
			UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
			);
			-- 删除应付表数据
			DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AR07%';
			-- 合并
			SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
			EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, @optype;
		END
		IF (@i_opcode = '01' AND @i_step = 4) -- 审核通过后回写单据金额及状态
		BEGIN
			-- 回写收付数据及状态 BEGIN
			-- 回写收付主表已付金额
			UPDATE tpm SET tpm.paym_real_amt = ISNULL(tpm.paym_real_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_pay_m tpm
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- 回写收付主表状态
			UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 5 ELSE 9 END)
				WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 6 ELSE 10 END)
				ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 7 ELSE 11 END) END)
				, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
			FROM FIDB.dbo.tfi_pay_m tpm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid);
			
			--收款通知单对应的应收数据paym_amt = 0 ,不等于0等情况做了匹配才会处理回写
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 11, isenable = 0
			WHERE paym_amt = 0 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_id = paym_ref_id AND icbm_nbr = paym_nbr);
			
			-- 回写应付单数据及状态 END
			
			-- 回写预付单已收金额及状态 BEGIN
			-- 回写预付单抵扣金额：abhm_prtn_amt
			UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_billhead_m abhm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- 写预付单状态:abhm_status
			UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
				, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
			FROM FIDB.dbo.tfi_billhead_m abhm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
						  WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr 
						  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
									  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
						);
			-- 回写预付单已收金额及状态 END
			
			-- 回写预收单已收金额及状态 BEGIN
			-- 回写预收单抵扣金额：abhm_prtn_amt
			UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_incomebill_m icbm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- 写预付单状态:abhm_status
			UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
				, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
			FROM FIDB.dbo.tfi_incomebill_m icbm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
			              WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr 
			              AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
									  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
						);
			-- 回写预收单已收金额及状态 END
			
			-- 如果该通知单有借款收款单，则回写借款单已付金额
			UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) + b.icbd_rec_amt
			FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
			INNER JOIN (
				select sum(ISNULL(tbd.icbd_rec_amt, 0.00)) icbd_rec_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				from FIDB.dbo.tfi_pay_m paym 
				INNER JOIN FIDB.dbo.tfi_incomebill_d tbd ON tbd.icbd_m_id = paym.paym_id
				WHERE paym_nbr_flag=4 and tbd.icbd_icbm_id = @i_mid and paym.paym_nbr like 'AC15%' 
				group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
			) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
				and (tbmm.brmm_lr_code=b.paym_pay_code OR 
				(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)
			
			
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_inc_amt = 0)
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_m 
				SET paym_status = 11, isenable = 0
				FROM FIDB.dbo.tfi_incomebill_m m
				WHERE paym_ref_id = m.icbm_id AND paym_ref_nbr = m.icbm_nbr AND m.icbm_id = @i_mid;
				
				UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 11 WHERE icbm_id = @i_mid;
			END
			
			--回写收款通知单明细表的已收金额字段-----------begin---(直接回写付款明细和减掉对应金额的收款明细,其他收款明细由匹配时回写)
			--主表为人rmb时，明细可以任何币别，主表为其他币别，明细也只能为主表币别
			DECLARE @sum_icbd_real_amt MONEY;--明细(付)的总额
			DECLARE @temp_icbd_id INT;--明细(收)did
			DECLARE @temp_icbm_curr VARCHAR(10);--币别
			                                   
			SELECT  @temp_icbm_curr = icbm_currency FROM fidb.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid
			
			SET @sum_icbd_real_amt = (SELECT SUM(tid.icbd_rec_amt *(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END )  )
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			WHERE tim.icbm_type=  1 AND  tid.icbd_icbm_id = @i_mid AND tid.icbd_bill_type IN(1,2,5))--明细(付)
		
			--第一步,直接回写明细已收金额
			UPDATE tid
			SET tid.icbd_real_amt = tid.icbd_rec_amt--不管币别
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			WHERE tim.icbm_type=  1 AND tid.icbd_icbm_id = @i_mid AND tid.icbd_bill_type IN(1,2,5)--明细(付)
			
			IF OBJECT_ID('tempdb..#temp_d') IS NOT NULL DROP TABLE #temp_d;		
			SELECT tid.* ,pm.paym_date
			INTO #temp_d  
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			INNER JOIN fidb.dbo.tfi_pay_m pm ON pm.paym_id=tid.icbd_m_id
			WHERE tim.icbm_type=  1 AND  tid.icbd_icbm_id=@i_mid AND tid.icbd_bill_type IN(3,4,6)--明细(收)
                                    
			
			WHILE((@sum_icbd_real_amt>0) AND EXISTS (SELECT 1 FROM #temp_d))
			BEGIN
				SET @temp_icbd_id = (SELECT TOP 1 icbd_id FROM #temp_d ORDER BY paym_date ASC)
				
				UPDATE tid
				SET tid.icbd_real_amt = (
					CASE WHEN @sum_icbd_real_amt > tid.icbd_rec_amt *(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END )  --该明细不够抵扣时
					THEN tid.icbd_rec_amt 
					ELSE @sum_icbd_real_amt/(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END ) END) 
				FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_id = @temp_icbd_id
				
				SET @sum_icbd_real_amt = @sum_icbd_real_amt-
				(SELECT tid.icbd_real_amt*(CASE WHEN @temp_icbm_curr='RMB' THEN icbd_rate ELSE 1 END )  FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_id = @temp_icbd_id )
				
				--循环删除
				DELETE FROM #temp_d WHERE icbd_id = @temp_icbd_id
			END
			
			DROP TABLE #temp_d
		                                                         
			
			--回写收款通知单明细表的已收金额字段----------end---(直接回写付款明细和减掉对应金额的收款明细,其他收款明细由匹配时回写)
			
			
			---- 薪资代扣(参照薪资代发)
			--IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid AND tim.icbm_reccode_type = 2 AND tim.icbm_rec_type = 7)
			--BEGIN
			--	SET @o_errmsg = 'OK';
				
			--	SELECT @hwag_emp = tim.icbm_rec_code, @hwag_amt = tim.icbm_inc_amt 
			--	FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid;
			--	-- 推送薪资代扣单
			--	EXEC HWAG.dbo.rp_wg_receivable '', 2, @hwag_emp, @hwag_amt, '', @o_errmsg OUT;
			--	IF(@o_errmsg = 'OK')
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 11, icbm_real_amt = @hwag_amt, icbm_rmks = icbm_rmks+' (已推送薪资代扣)' WHERE icbm_id = @i_mid
					
			--		UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 11, paym_real_amt = @hwag_amt, isenable = 0 
			--		WHERE paym_nbr = (SELECT icbm_nbr FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid)
			--	END
				
			--END
		END
		IF (@i_opcode = '10') -- 撤销审核完成的单回写单据金额及状态
		BEGIN
			-- 薪资代扣
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid AND tim.icbm_rec_type = 7)
			BEGIN
				RAISERROR (N'支付方式为薪资代扣的，不允许撤销！', 16, 1); 
			END
			IF EXISTS(
			SELECT 1 FROM fidb.dbo.tfi_dealing_match_m m
			INNER JOIN fidb.dbo.tfi_dealing_match_d d ON d.tdmd_tdmm_id = m.tdmm_id
			INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = d.tdmd_bill_id AND d.tdmd_bill_nbr = icbm.icbm_nbr
			WHERE m.tdmm_status <> 6 AND icbm.icbm_id = @i_mid)
			OR EXISTS( SELECT 1 FROM fidb.dbo.tfi_incomebill_m m  where m.icbm_id = @i_mid AND m.icbm_real_amt<>0)
			BEGIN
				RAISERROR (N'单据已经匹配银行流水，请先撤销匹配！', 16, 1); 
			END
			
			select  @acctid=acctid from fidb.dbo.tfi_incomebill_m WHERE icbm_id =@i_mid
			select  @date=CONVERT(varchar(100), modtime , 23) from  fidb.dbo.tfi_incomebill_m WHERE icbm_id=@i_mid
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AR07', @date, 1, @st OUTPUT,1
			IF (ISNULL(@st,0)=0 AND  @i_step <> 5)--收款终止不提示账期关闭
			BEGIN
				RAISERROR('账期已关闭，不能撤销完成.', 16, 1);
			END 
			--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			
			--因为审批流节点可能动态，撤销完成也可能动态(这里需要流程设置和f.10.rp_wf_AR07.sql设置支持)，只能强制这样判断，避免多次进入这里，避免不进入这里
			--实施要求,本来只存在一个撤销完成就简单点
			IF  EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid AND tpm.paym_real_amt = icbd.icbd_rec_amt)
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END

				-- 删除匹配关系,该逻辑去掉,判断匹配了就不能做撤销完成逻辑
				--DECLARE @actr_id INT = 0;
				--DECLARE @atsp_id_2 INT = 0;
				--WHILE EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_relation rela
				--		  INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
				--          WHERE icbm.icbm_id = @i_mid)
				--BEGIN
				--	SELECT TOP(1) @actr_id = actr_id 
				--	FROM FIDB.DBO.tfi_account_tx_relation rela
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
			 --       WHERE icbm.icbm_id = @i_mid
			        
				--	UPDATE icbm
				--	SET icbm_real_amt = ISNULL(icbm_real_amt, 0.00) - rela.actr_amt, icbm_status = 10, modtime = GETDATE(), moduser = @i_userid
				--	FROM FIDB.DBO.tfi_account_tx_relation rela
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr        
				--	WHERE rela.actr_id = @actr_id
					
				--	--如果是收款通知单，icbm_status = 9(待收)
				--	UPDATE FIDB.DBO.tfi_incomebill_m SET icbm_status = 9, icbm_isreceived = 0, icbm_acct_id = 0 WHERE icbm_id = @i_mid AND icbm_real_amt = 0;
			
				--	UPDATE tpm SET tpm.paym_real_amt = tim.icbm_real_amt
				--	FROM FIDB.dbo.tfi_pay_m tpm 
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m tim ON tim.icbm_id = tpm.paym_ref_id AND tpm.paym_ref_nbr = tim.icbm_nbr
				--	WHERE tim.icbm_id = @i_mid;
					
				--	UPDATE tpm SET tpm.paym_status=(CASE WHEN tpm.paym_real_amt = 0 THEN 9 WHEN (tpm.paym_amt > tpm.paym_real_amt) THEN 10 ELSE 11 END)
				--	, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				--	FROM FIDB.dbo.tfi_pay_m tpm 
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m tim ON tim.icbm_id = tpm.paym_ref_id AND tpm.paym_ref_nbr = tim.icbm_nbr
				--	WHERE tim.icbm_id = @i_mid;
				--	-- 删除或更新流水数据
				--	SELECT @atsp_id_2 = actr_atsp_id FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id 
				--	DELETE FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id	
						
				--	IF EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_split atsp WHERE atsp.atsp_nbr LIKE 'AR07%' AND atsp_id = @atsp_id_2)
				--	BEGIN
				--		UPDATE FIDB.dbo.tfi_balance 
	   --       			SET blnc_balance = blnc_balance + ISNULL(actx.actx_amt_out - actx.actx_amt_in, 0), blnc_date = GETDATE(), modtime = GETDATE(), moduser = @i_userid
	   --       			FROM FIDB.DBO.tfi_account_tx actx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2)
							
				--		DELETE FROM FIDB.DBO.tfi_account_tx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2)
				--		DELETE FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2;
				--	END
				--	ELSE
				--	BEGIN
				--		UPDATE FIDB.DBO.tfi_account_tx_split SET atsp_rmks = '', atsp_status = 0, modtime = GETDATE(), moduser = @i_userid
				--		WHERE atsp_id = @atsp_id_2;
				--	END		
							
				--END
				-- 回写收付数据及状态 BEGIN
				-- 回写明细表对应的paym数据
				UPDATE tpm SET tpm.paym_real_amt = ISNULL(tpm.paym_real_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- 回写明细表对应的paym数据状态
				UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 5 ELSE 9 END)
					WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 6 ELSE 10 END)
					ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 7 ELSE 11 END) END)
					, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				FROM FIDB.dbo.tfi_pay_m tpm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid);
				
				-- 如果该通知单有借款收款单，则回写借款单已付金额
				UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) - b.icbd_rec_amt
				FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
				INNER JOIN (
					select sum(ISNULL(tbd.icbd_rec_amt, 0.00)) icbd_rec_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
					from FIDB.dbo.tfi_pay_m paym 
					INNER JOIN FIDB.dbo.tfi_incomebill_d tbd ON tbd.icbd_m_id = paym.paym_id
					WHERE paym_nbr_flag=4 and tbd.icbd_icbm_id = @i_mid and paym.paym_nbr like 'AC15%' 
					group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
					and (tbmm.brmm_lr_code=b.paym_pay_code OR 
					(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)
					
				
				--回写明细表的已收金额icbd_real_amt------------------新加begin
				UPDATE tid
				SET tid.icbd_real_amt = 0
				FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_icbm_id = @i_mid;
				--回写明细表的已收金额icbd_real_amt------------------新加end
				
									
				--收款通知单对应的应收数据paym_amt = 0 ,不等于0等情况做了匹配才会处理回写	
				UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 9, isenable =1
				WHERE paym_amt = 0 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_id = paym_ref_id AND icbm_nbr = paym_nbr);
				-- 回写应付单数据及状态 END
				
				-- 回写预付单已收金额及状态 BEGIN
				-- 回写预付单抵扣金额：abhm_prtn_amt
				UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_billhead_m abhm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- 写预付单状态:abhm_status
				UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
					, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
				FROM FIDB.dbo.tfi_billhead_m abhm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
							  WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr 
							  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
										  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
							);
				-- 回写预付单已收金额及状态 END
				
				-- 回写预收单已收金额及状态 BEGIN
				-- 回写预收单抵扣金额：abhm_prtn_amt
				UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_incomebill_m icbm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- 写预付单状态:abhm_status
				UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
					, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
				FROM FIDB.dbo.tfi_incomebill_m icbm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
							  WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr 
							  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
										  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
							);
				-- 回写预收单已收金额及状态 END
			END
			IF (@i_step = 1) AND  NOT EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid AND tpm.paym_parent_id = 0 AND tpm.isenable = 1)		-- 申请节点撤销完成加合并应收逻辑
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				
				-- 更新parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
				);
				-- 删除应付表数据
				DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AR07%';
				-- 合并
				SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
				EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, @optype;
			END
			
			--删除记账数据
			SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
			EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AR07', @i_fmonth, @i_mid	
			
		END
	END	
	-- =====收款通知单=====END=====
	
   -- =====资产投资单=====BEGIN=====
		IF (@i_wfcode = 'AC26')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- 审核通过
			BEGIN
				IF ((SELECT tcim_type FROM  fidb.dbo.tfi_capital_investment_m WHERE tcim_id = @i_mid ) = 2 ) --外部投资时
				BEGIN
					DECLARE @nbr_type INT;				   -- 单据类型 1:应付;2:其它应付;3:应收;4:其它应收.
					DECLARE @twf_code VARCHAR(100);		   -- 流程code
					DECLARE @paym_emp VARCHAR(20);		   -- 申请人
					DECLARE @paym_dept VARCHAR(20);		   -- 申请部门code
					DECLARE @paym_duty INT;				   -- 申请人岗位
					DECLARE @paym_due_date DATETIME;	   -- 应付日期
					DECLARE @paym_paycode_type TINYINT;	   -- 对方类型 1:供应商;2:个人;3:客户;
					DECLARE @paym_pay_code VARCHAR(20);	   -- 对方代码
					DECLARE @paym_legal INT;			   -- 应付法人 
					DECLARE @paym_currency VARCHAR(10);	   -- 币别
					DECLARE @paym_rate DECIMAL(19, 7);	   -- 汇率
					DECLARE @paym_amt MONEY;			   -- 应付金额
					DECLARE @paym_pay_type TINYINT;		   -- 支付方式 1: 现金；2：转账
					DECLARE @paym_pay_bank VARCHAR(100);   -- 开户行
					DECLARE @paym_pay_name VARCHAR(100);   -- 开户名
					DECLARE @paym_pay_nbr VARCHAR(50);	   -- 开户账号                          	   
					DECLARE @paym_admin_type INT;			-- 往来方类型 1:供应商;2:个人;3:客户;4:部门;
					DECLARE @paym_admin_dept VARCHAR(20);	-- 往来方编码
					DECLARE @paym_admin_desc VARCHAR(200)	-- 往来方名称
					DECLARE @paym_duty_emp VARCHAR(20);	   -- 往来责任人
					DECLARE @paym_rmks VARCHAR(200);	   -- 备注
					DECLARE @paym_ref_id INT;			   -- 关联单号id
					DECLARE @paym_ref_did INT;			   -- 关联单号did
					DECLARE @paym_ref_nbr VARCHAR(20);	   -- 关联单号
					--DECLARE @acctid INT;					-- acctid
					DECLARE @o_paym_id INT ;				-- 返回应付单id
					DECLARE @o_paym_nbr VARCHAR(20);		 -- 返回应付单号
					DECLARE @paym_date DATETIME = NULL	     -- 业务发生日期
					SET @rntStr = 'OK';
					
					SELECT  
						@nbr_type = 4
					    , @twf_code = @i_wfcode
						, @paym_emp = tcim.tcim_emp
						, @paym_dept = tcim.tcim_dept
						, @paym_duty = tcim.tcim_duty
						, @paym_due_date = tcim.tcim_begin_date
						, @paym_paycode_type = tcim.tcim_paycode_type
						, @paym_pay_code = tcim.tcim_pay_code
						, @paym_legal = tcid.tcid_legal
						, @paym_currency = tcim.tcim_curr
						, @paym_rate = hportal.dbo.rf_ba_getrate(tcim.acctid, ISNULL(tcim.tcim_curr,'RMB'),'RMB',GETDATE())
						, @paym_amt = tcim.tcim_amt
						, @paym_pay_type = 2 --转账
						, @paym_pay_bank = ''		-- 开户行
						, @paym_pay_name = ''		-- 开户名
						, @paym_pay_nbr = ''		-- 开户账号       
						, @paym_admin_type = 0		-- 往来方类型 1:供应商;2:个人;3:客户;4:部门;
						, @paym_admin_dept = ''		-- 往来方编码
						, @paym_admin_desc = ''		-- 往来方名称
						, @paym_duty_emp  = ''	    -- 往来责任人
						, @paym_rmks  = tcim.tcim_rmks	  
						, @paym_ref_id = tcim.tcim_id	  
						, @paym_ref_did = tcid.tcid_id		
						, @paym_ref_nbr = tcim.tcim_nbr		
						, @acctid = tcim.acctid			
						, @paym_date  = NULL	-- 业务发生日期
					FROM tfi_capital_investment_m tcim
					LEFT JOIN tfi_capital_investment_d tcid on tcid.tcid_tcim_id = tcim.tcim_id
					WHERE tcim.tcim_id = @i_mid
					
					-- 如果申请人离职，取部门第一负责人
					--IF(NOT EXISTS(SELECT emp_id FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @paym_emp))
					--BEGIN
					--	DECLARE @cc_level VARCHAR(100);
					--	SELECT @cc_level = cm.cc_level FROM HR90.dbo.cc_mstr1 cm WHERE cm.cc_code = @paym_dept;
					--	SELECT @paym_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@cc_level,'','','',1);
					--END
					
					--生成收款通知单
					EXEC FIDB.dbo.rp_fi_add_apacV2
						  @nbr_type
						, @twf_code
						, @paym_emp
						, @paym_dept
						, @paym_duty
						, @paym_due_date
						, @paym_paycode_type
						, @paym_pay_code
						, @paym_legal
						, @paym_currency
						, @paym_rate
						, @paym_amt
						, @paym_pay_type
						, @paym_pay_bank
						, @paym_pay_name
						, @paym_pay_nbr
						, @paym_admin_type
						, @paym_admin_dept
						, @paym_admin_desc
						, @paym_duty_emp
						, @paym_rmks
						, @paym_ref_id
						, @paym_ref_did
						, @paym_ref_nbr
						, @acctid
						, @o_paym_id OUTPUT
						, @o_paym_nbr OUTPUT
						, @rntStr OUTPUT
				END
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
			END
		END
	--  =====资产投资单=====END=====
	
	   -- =====客户退款单=====BEGIN=====
		IF (@i_wfcode = 'AP12')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- 审核通过
			BEGIN
					SET @rntStr = 'OK';
					
					SELECT   
						@nbr_type = 4
					    , @twf_code = @i_wfcode
						, @paym_emp = m.rfdm_emp
						, @paym_dept = m.rfdm_dept
						, @paym_duty = m.rfdm_duty  
						, @paym_due_date = m.rfdm_pay_date
						, @paym_paycode_type = m.rfdm_code_type
						, @paym_pay_code = m.rfdm_code
						, @paym_legal = m.rfdm_pay_legal
						, @paym_currency = m.rfdm_currency
						, @paym_rate = m.rfdm_rate
						, @paym_amt = m.rfdm_pay_amt
						, @paym_pay_type = m.rfdm_pay_type
						, @paym_pay_bank = m.rfdm_pay_bank
						, @paym_pay_name = m.rfdm_pay_name
						, @paym_pay_nbr = m.rfdm_pay_nbr
						, @paym_admin_type = 4					-- 往来方类型 1:供应商;2:个人;3:客户;4:部门;
						, @paym_admin_dept = m.rfdm_pay_dept	-- 往来方编码
						, @paym_admin_desc = (SELECT TOP 1 cc_desc FROM fidb.dbo.v_fi_dept WHERE cc_code = m.rfdm_pay_dept)		-- 往来方名称
						, @paym_duty_emp  = m.rfdm_emp 	   -- 往来责任人
						, @paym_rmks  = m.rfdm_rmks
						, @paym_ref_id = m.rfdm_id
						, @paym_ref_did = 0
						, @paym_ref_nbr = m.rfdm_nbr
						, @acctid = m.acctid			
						, @paym_date  = NULL	-- 业务发生日期
					FROM fidb.dbo.tfi_refound_m m
					WHERE m.rfdm_id = @i_mid
					
					
					--生成收款数据
					EXEC FIDB.dbo.rp_fi_add_apacV2
						  2
						, @twf_code
						, @paym_emp
						, @paym_dept
						, @paym_duty
						, @paym_due_date
						, @paym_paycode_type
						, @paym_pay_code
						, @paym_legal
						, @paym_currency
						, @paym_rate
						, @paym_amt
						, @paym_pay_type
						, @paym_pay_bank
						, @paym_pay_name
						, @paym_pay_nbr
						, @paym_admin_type
						, @paym_admin_dept
						, @paym_admin_desc
						, @paym_duty_emp
						, @paym_rmks
						, @paym_ref_id
						, @paym_ref_did
						, @paym_ref_nbr
						, @acctid
						, @o_paym_id OUTPUT
						, @o_paym_nbr OUTPUT
						, @rntStr OUTPUT
				
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
				
				--生成付款通知单
				EXEC FIDB.dbo.rp_fi_add_apacV2
					  @nbr_type
					, @twf_code
					, @paym_emp
					, @paym_dept
					, @paym_duty
					, @paym_due_date
					, @paym_paycode_type
					, @paym_pay_code
					, @paym_legal
					, @paym_currency
					, @paym_rate
					, @paym_amt
					, @paym_pay_type
					, @paym_pay_bank
					, @paym_pay_name
					, @paym_pay_nbr
					, @paym_admin_type
					, @paym_admin_dept
					, @paym_admin_desc
					, @paym_duty_emp
					, @paym_rmks
					, @paym_ref_id
					, @paym_ref_did
					, @paym_ref_nbr
					, @acctid
					, @o_paym_id OUTPUT
					, @o_paym_nbr OUTPUT
					, @rntStr OUTPUT
				
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
			END
		END
	--  =====客户退款单=====END=====
	
	
	
	
	--IF (@@TRANCOUNT > 0)
	--BEGIN
	--	COMMIT TRAN -- 提交事务
	--END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	--IF (@@TRANCOUNT > 0)
	--BEGIN
	--	ROLLBACK TRAN  -- 出错，则回滚事务
	--END
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
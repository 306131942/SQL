USE FIDB
GO

IF(OBJECT_ID('rp_fi_add_billhead','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_billhead AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-20
-- Description:	生成付款/预付通知单并提交工作流
-- modify[1]: 刘翔 调整付款通知单的提交时付款日期的控制逻辑
-- Modify[2]: 2014-4-23 liuxiang 增加离职人员的处理逻辑，若找不到上级，则提醒审批人员手工生成下一个流程的单据
-- Modify[3]: 2017-12-26 luocg 付款通知单明细增加来源单号和来源id两个字段
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_add_billhead]
(
	@i_wfcode VARCHAR(20)				-- 哪个流程推送 AP05(应付->付款) AC15(借款->预付)
	, @i_abhm_type TINYINT				-- 付款类型 1付款 2预付
	, @i_abhm_item VARCHAR(20)			-- 会计科目
	, @i_abhm_emp VARCHAR(20)			-- 申请人
	, @i_abhm_dept VARCHAR(20)			-- 申请部门code
	, @i_abhm_duty INT					-- 申请人岗位
	, @i_abhm_legal INT					-- 法人
	, @i_abhm_paycode_type TINYINT		-- 对方类型 1供应商2个人
	, @i_abhm_pay_code VARCHAR(20)		-- 对方代码
	, @i_abhm_pay_type TINYINT			-- 支付方式
	, @i_abhm_pay_bank VARCHAR(100)		-- 开户行
	, @i_abhm_pay_name VARCHAR(100)		-- 开户名
	, @i_abhm_pay_nbr VARCHAR(50)		-- 开户账号
	, @i_abhm_currency VARCHAR(10)		-- 币别
	--, @i_abhm_rate DECIMAL(19, 7)		-- 汇率(付款通知汇率取最新汇率)
	, @i_abhm_rate DECIMAL(19, 7)		-- 汇率
	, @i_abhm_amt MONEY					-- 应付金额
	, @i_abhm_rec_amt MONEY				-- 应收金额
	, @i_abhm_pay_amt MONEY				-- 支付金额
	, @i_abhm_pay_date DATETIME			-- 付款日期
	, @i_abhm_rmks VARCHAR(800)			-- 备注
	, @i_abhm_ref_type TINYINT			-- 关联单据类型
	, @i_abhm_ref_id INT				-- 关联单据ID
	, @i_acctid INT						-- acctid
	, @o_abhm_id INT OUTPUT				-- 返回付款单id
	, @o_abhm_nbr VARCHAR(20) OUTPUT	-- 返回付款单号
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
	, @i_abhm_rec_date DATETIME = NULL	-- 预计还款日
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	-- 调试数据
	DECLARE @i_wfcode VARCHAR(20);
	DECLARE @i_abhm_type TINYINT;
	DECLARE @i_abhm_item VARCHAR(20);
	DECLARE @i_abhm_emp VARCHAR(20);
	DECLARE @i_abhm_dept VARCHAR(20);
	DECLARE @i_abhm_duty INT;
	DECLARE @i_abhm_legal INT;
	DECLARE @i_abhm_paycode_type TINYINT;
	DECLARE @i_abhm_pay_code VARCHAR(20);
	DECLARE @i_abhm_pay_type TINYINT;
	DECLARE @i_abhm_pay_bank VARCHAR(100);
	DECLARE @i_abhm_pay_name VARCHAR(100);
	DECLARE @i_abhm_pay_nbr VARCHAR(50);
	DECLARE @i_abhm_currency VARCHAR(10);
	DECLARE @i_abhm_amt MONEY;
	DECLARE @i_abhm_rec_amt MONEY;
	DECLARE @i_abhm_pay_amt MONEY;
	DECLARE @i_abhm_pay_date DATETIME;
	DECLARE @i_abhm_rmks VARCHAR(200);
	DECLARE @i_abhm_ref_type TINYINT;
	DECLARE @i_abhm_ref_id INT;
	DECLARE @i_acctid INT;
	DECLARE @o_abhm_id INT;
	DECLARE @o_abhm_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @i_wfcode = 'AP05';
	SET @i_abhm_type = 1;
	SET @i_abhm_item = '1';
	SET @i_abhm_emp = '00000001';
	SET @i_abhm_dept = '012213';
	SET @i_abhm_duty = 10026;
	SET @i_abhm_legal = -2;
	SET @i_abhm_paycode_type = 2;
	SET @i_abhm_pay_code = '00000001';
	SET @i_abhm_pay_type = 0;
	SET @i_abhm_pay_bank = '';
	SET @i_abhm_pay_name = '';
	SET @i_abhm_pay_nbr = '';
	SET @i_abhm_currency = 'RMB';
	SET @i_abhm_amt = 2000.00;
	SET @i_abhm_rec_amt = 0;
	SET @i_abhm_pay_amt = 2000.00;
	SET @i_abhm_pay_date = '2013-8-13';
	SET @i_abhm_rmks = '由差旅报销应付单生成';
	SET @i_abhm_ref_type = 1;
	SET @i_abhm_ref_id = NULL;
	SET @i_acctid = 1;
	*/
	
	SET @o_rntStr = 'OK';
	
	DECLARE @abhm_dept_level VARCHAR(20);
	
	DECLARE @wfmid INT;					-- 流程id
	DECLARE @summary VARCHAR(200);		-- 工作流summary
	DECLARE @rmmt_id INT;				-- 报销单id
	DECLARE @rmmt_did INT;				-- 报销单did                  				
	DECLARE @rmmt_gl_type INT;
	DECLARE @rmmt_twf_code VARCHAR(20);
    --DECLARE @abhm_rate DECIMAL(19, 7);	-- 汇率 
    DECLARE @abhd_amt DECIMAL(19, 2);	-- 明细表金额
    DECLARE @fi_wf_status VARCHAR(20);	-- 0:推送为待审的付款通知单；1:推送为待提的付款通知单

                                       
    SET @abhd_amt = @i_abhm_amt;
    SET @fi_wf_status = (SELECT  code_value FROM hportal.dbo.tba_code  WHERE code_type='fi_wf_status' AND acctid = @i_acctid )
    
	IF (@i_abhm_ref_id = 0 OR @i_abhm_ref_id IS NULL)
	BEGIN -- 关联单据为空
		SET @o_rntStr = '推送单据为空，不能生成付款/预付通知单！';
	END
	ELSE IF @i_abhm_type = 1 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m tbm WHERE tbm.abhm_status <> 8 AND EXISTS (
		SELECT 1 FROM FIDB.dbo.tfi_billhead_d tbd
		WHERE tbd.abhd_abhm_id = tbm.abhm_id AND tbd.abhd_m_id = @i_abhm_ref_id))
	BEGIN
		SET @o_rntStr = CAST(@i_abhm_ref_id AS VARCHAR(10)) + '号单已存在付款通知单！';
	END
	ELSE IF @i_abhm_type = 2 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_ref_id = @i_abhm_ref_id AND abhm_status <> 8)
	BEGIN -- 已存在付款通知单，不再生成付款通知单
		SET @o_rntStr = CAST(@i_abhm_ref_id AS VARCHAR(10)) + '号单已存在预付通知单！';
	END
	ELSE
	BEGIN -- 生成付款通知单单
	    IF(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_abhm_emp))
		BEGIN
			DECLARE @temp_emp VARCHAR(20);
			SELECT @abhm_dept_level = cc_level FROM HR90.dbo.cc_mstr1 WHERE cc_code = @i_abhm_dept;
			SELECT @temp_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@abhm_dept_level, '', '', '', 1);
			
			IF(NOT EXISTS ( SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp))
			BEGIN
				SET @temp_emp=@i_abhm_emp
			END 
			
			DECLARE @i_while INT;
			SET @i_while = 0;
			WHILE(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp) AND @i_while < 3)
			BEGIN
				SELECT @temp_emp=de_directlyunder_emp_id FROM HR90.dbo.v_emp_duty_all WHERE emp_id = @temp_emp and de_type_id=0
				SET @i_while = @i_while + 1;
			END
			
			IF(EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp))
			BEGIN
			SET @i_abhm_emp = @temp_emp;
			--默认任职部门
			SET @i_abhm_duty = (SELECT duty_id  FROM fidb.dbo.v_fi_dutyall WHERE de_type_id = 0 AND emp_id = @i_abhm_emp)
			END
		END
	    IF(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_abhm_emp))
		BEGIN
			DECLARE @re_code VARCHAR(10);
			DECLARE @re_abhm_name VARCHAR(20);
			DECLARE @re_summry VARCHAR(200);
			DECLARE @re_aid INT;
			DECLARE @re_rid VARCHAR(20);
			DECLARE @a_table VARCHAR(50);
			DECLARE @re_nbr VARCHAR(20);
			
			IF(@i_wfcode='AP05')
			BEGIN
				SELECT @re_nbr = LEFT(paym_ref_nbr,4) FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @i_abhm_ref_id;
				SET @re_code = LEFT(@re_nbr,4);
				SET @re_summry='付款通知单（AP07），请在应付列表或者应付报表中查询出该单据进行手工推送 付款通知单(AP07)'
			END
			ELSE
			BEGIN
				SELECT @re_nbr = LEFT(brmm_nbr,4) FROM FIDB.dbo.TFI_BORROW_MONEY_M WHERE BRMM_ID = @i_abhm_ref_id;
				SET @re_code = LEFT(@re_nbr,4);
				SET @re_summry='预付通知单（AP08），请在应付列表或者应付报表中查询出该单据进行手工推送 预付通知单(AP08)'
			END
			
			IF OBJECT_ID('tempdb..#re_abhm_remind') IS NOT NULL
			BEGIN
				DROP TABLE #re_abhm_remind;
			END
			CREATE TABLE #re_abhm_remind(
				re_aid INT,
				re_rid VARCHAR(20)
			);
			SELECT TOP(1) @a_table = a_table FROM FIDB.dbo.v_fi_twfm WHERE wfm_code = @re_code;
			EXEC ('INSERT INTO #re_abhm_remind SELECT wfna_id,wfna_emp_id FROM '+ @a_table +' WHERE LEN(wfna_wf_route) - LEN(REPLACE(wfna_wf_route,'','','''')) = 3 AND wfna_m_id = '+@i_abhm_ref_id);
	
			WHILE EXISTS(SELECT 1 FROM #re_abhm_remind)
			BEGIN
				SELECT TOP(1) @re_aid = re_aid,@re_rid = re_rid FROM #re_abhm_remind ORDER BY re_aid DESC;
				
				IF EXISTS(SELECT 1 FROM HR90.dbo.h_emp_mstr hea WHERE hea.emp_id = @re_rid)
				BEGIN

					SELECT @re_abhm_name = emp_name FROM FIDB.dbo.v_fi_empmstr WHERE emp_id = @i_abhm_emp;
					SET @re_summry = '因申请人'+isnull(@re_abhm_name,'')+'('+isnull(@i_abhm_emp,'')+') 离职，导致单据 '+isnull(@re_nbr,'') +' 无法自动推送 ' + @re_summry;
					
					EXEC HPORTAL.dbo.rp_wf_remind @re_code,@re_rid,3,@re_summry,@o_rntStr OUTPUT;
				END
				
				DELETE FROM #re_abhm_remind WHERE re_aid = @re_aid;
			END
			DROP TABLE #re_abhm_remind ;
		END
		ELSE
		BEGIN	
			--SET @abhm_rate = HPORTAL.dbo.rf_ba_getrate(@i_acctid, @i_abhm_currency, 'RMB', GETDATE()); -- 取最新汇率
			IF (@i_wfcode = 'AP05')
			BEGIN
				SET @rmmt_gl_type = 1;
	    		SET @i_abhm_item = '1';
	    		
	    		-- 取报销单id
	    		SELECT @rmmt_id = paym_ref_id, @rmmt_did = paym_ref_did, @rmmt_twf_code = LEFT(paym_ref_nbr,4)
	    			, @rmmt_gl_type = (CASE WHEN tr.rmmt_gl_type = 2 OR tr.rmmt_rec_gltype = 2 THEN 2 ELSE 1 END) 
	    		FROM FIDB.dbo.tfi_pay_m m 
	    		LEFT JOIN FIDB.dbo.TFI_REIMBURSEMENT tr  ON tr.RMMT_NBR = m.paym_ref_nbr AND tr.RMMT_ID = m.paym_ref_id
	    		WHERE paym_id = @i_abhm_ref_id 
	    		
	    		IF((@rmmt_id IS NOT NULL) AND CHARINDEX(@rmmt_twf_code, 'AC12') > 0)
	    		BEGIN
	    			IF(@rmmt_gl_type = 2)-- 如果报销表中是记账
	    			BEGIN
	    				SELECT @i_abhm_rec_amt = ISNULL(rmmd_loan_oamt, 0) + isnull(rmmd_loan_ramt, 0)
	    				  , @rmmt_gl_type = (CASE WHEN tr.rmmt_gl_type = 2 OR tr.rmmt_rec_gltype = 2 THEN 2 ELSE 1 END)
	    				FROM FIDB.dbo.TFI_REIMBURSEMENT tr
	    				LEFT JOIN FIDB.dbo.tfi_reimbursement_d d ON tr.RMMT_ID = d.rmmd_rmmt_id
	    				WHERE rmmt_id = @rmmt_id AND rmmd_id = @rmmt_did
	    				
	    				SET @i_abhm_amt = @i_abhm_rec_amt;
	    				SET @i_abhm_pay_amt = 0;
	    			END
	    			ELSE
	    			BEGIN 
	    				SELECT @i_abhm_amt = SUM(d.rmmd_pay_oamt), @i_abhm_rec_amt = SUM(d.rmmd_loan_oamt)+SUM(d.rmmd_loan_ramt)
	    				FROM FIDB.dbo.TFI_REIMBURSEMENT tr
	    				LEFT JOIN FIDB.dbo.tfi_reimbursement_d d ON tr.RMMT_ID = d.rmmd_rmmt_id
	    				WHERE rmmt_id = @rmmt_id AND d.rmmd_contacts_rcode = @i_abhm_pay_code
	    						
	    				SET @i_abhm_pay_amt = @i_abhm_amt - @i_abhm_rec_amt;
	    			END
	    		END
	    		ELSE IF((@rmmt_id IS NOT NULL) AND CHARINDEX(@rmmt_twf_code, 'AC11,AC13,AC14,AC16,AC17') > 0)
	    		BEGIN
	    			SELECT @i_abhm_rec_amt = isnull(RMMT_LOAN, 0) + isnull(rmmt_rec_loan, 0)
	    			FROM FIDB.dbo.TFI_REIMBURSEMENT tr
	    			WHERE rmmt_id = @rmmt_id;
	    			IF(@rmmt_gl_type = 2)				-- 如果报销表中是记账
	    			BEGIN
	    				SET @i_abhm_amt = @i_abhm_rec_amt;
	    				SET @i_abhm_pay_amt = 0;
	    			END
	    			ELSE
	    			BEGIN   			
	    				SET @i_abhm_pay_amt = @i_abhm_amt - @i_abhm_rec_amt;
	    			END
	    		END
	    		ELSE IF((@rmmt_id IS NOT NULL) AND CHARINDEX(@rmmt_twf_code, 'SA82') > 0)
	    		BEGIN
	    			IF EXISTS(SELECT 1 FROM HSAL.dbo.tsa_rebate_m m WHERE m.rbtm_id = @rmmt_id AND m.rbtm_pay_amt > 0)
	    			BEGIN
	    				DECLARE @rbtm_pay_amt DECIMAL(19,2);
	    				SELECT @rbtm_pay_amt = rbtm_pay_amt FROM HSAL.dbo.tsa_rebate_m WHERE rbtm_id = @rmmt_id 
	    				
	    				SET @i_abhm_amt = @rbtm_pay_amt;
	    				SET @i_abhm_pay_amt = @rbtm_pay_amt;
	    			END
	    			SET @rmmt_id = 0;
	    		END
	    		ELSE
    			BEGIN
    				SET @rmmt_id = 0;
    			END
			END
			ELSE
			BEGIN
	    		SET @i_abhm_item = '6'
			END
		    
		DECLARE @abhm_nbr VARCHAR(20) = '';
		EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_billhead_m', 'abhm_nbr', @abhm_nbr OUTPUT; 
		
			INSERT INTO FIDB.dbo.tfi_billhead_m ( -- 插入主表begin
				abhm_type
				, abhm_nbr
				, abhm_item
				, abhm_emp
				, abhm_dept
				, abhm_pay_dept
				, abhm_duty
				, abhm_pemr_code
				, abhm_date
				, abhm_legal
				, abhm_paycode_type
				, abhm_pay_code
				, abhm_pay_type
				, abhm_othercode_type
				, abhm_other_code
				, abhm_other_amt
				, abhm_pay_name
				, abhm_pay_bank
				, abhm_pay_nbr
				, abhm_currency
				, abhm_rate
				, abhm_amt
				, abhm_rec_amt
				, abhm_pay_amt
				, abhm_pay_date
				, abhm_rec_date
				, abhm_rmks
				, abhm_status
				, abhm_ref_type
				, abhm_ref_id
				, adduser
				, acctid
			) VALUES (
				@i_abhm_type
				, @abhm_nbr
				, @i_abhm_item
				, @i_abhm_emp
				, @i_abhm_dept
				, (SELECT paym.paym_admin_dept FROM FIDB.dbo.tfi_pay_m paym WHERE paym.paym_id = @i_abhm_ref_id)
				, @i_abhm_duty
				, (select top 1 pemr_code from hr90.dbo.thr_person_mstr where pemr_emp_id = @i_abhm_emp AND pemr_duty_id = @i_abhm_duty)
				, CONVERT(VARCHAR(10), GETDATE(), 23)
				, @i_abhm_legal
				, @i_abhm_paycode_type
				, @i_abhm_pay_code
				, @i_abhm_pay_type
				, @i_abhm_paycode_type
				, @i_abhm_pay_code
				, 0
				, @i_abhm_pay_name
				, @i_abhm_pay_bank
				, @i_abhm_pay_nbr
				, @i_abhm_currency
				, @i_abhm_rate
				, @i_abhm_amt
				, @i_abhm_rec_amt
				, @i_abhm_pay_amt
				, (CASE WHEN DATEDIFF(DAY,GETDATE(),@i_abhm_pay_date)>=0 THEN @i_abhm_pay_date ELSE GETDATE() END)
				, @i_abhm_rec_date
				, @i_abhm_rmks
				, 1
				, (CASE WHEN @i_abhm_type = 2 THEN @i_abhm_ref_type ELSE NULL END)
				, (CASE WHEN @i_abhm_type = 2 THEN @i_abhm_ref_id ELSE NULL END)
				, @i_abhm_emp
				, @i_acctid
			);
			SET @o_abhm_id = @@identity; -- 插入主表end
			
			-- 插入子表begin
			IF (@i_wfcode = 'AP05') -- 应付->付款
			BEGIN
				INSERT INTO FIDB.dbo.tfi_billhead_d (
					abhd_abhm_id, abhd_bill_type, abhd_m_id
					, abhd_d_id, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
					, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
					, adduser, acctid, abhd_source_id, abhd_source_nbr
				) VALUES (
					@o_abhm_id, (SELECT tpm.paym_nbr_flag FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_abhm_ref_id), @i_abhm_ref_id
					, (SELECT isnull(tpm.paym_ref_did,0) FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_abhm_ref_id)
					, @i_abhm_currency, @i_abhm_rate, @abhd_amt, @i_abhm_rmks
					, @abhd_amt, 0, 0
					, @i_abhm_emp, @i_acctid
					, (SELECT tpm.paym_ref_id FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_abhm_ref_id)
					, (SELECT tpm.paym_ref_nbr FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_abhm_ref_id)
				);
				-- 借款冲报销
				INSERT INTO FIDB.dbo.tfi_billhead_d (
					abhd_abhm_id, abhd_bill_type, abhd_m_id, abhd_d_id
					, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
					, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
					, adduser, acctid, abhd_source_id, abhd_source_nbr
				)
				SELECT
					@o_abhm_id, paym_nbr_flag, rbre_paym_id, ISNULL(paym.paym_ref_did, 0)
					, paym.paym_currency, paym.paym_rate, rbre_amt, paym_rmks
					, 0, paym_amt - paym_real_amt, 0
					, @i_abhm_emp, @i_acctid, paym.paym_ref_id, paym.paym_ref_nbr
				FROM FIDB.dbo.tfi_reim_borrow_relation
				INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = rbre_paym_id
				WHERE rbre_rmmt_id = @rmmt_id AND ISNULL(rbre_rmmd_id, 0) = ISNULL(@rmmt_did, 0);
				
				--通用报销支付合并的情况
				IF((@rmmt_id IS NOT NULL) AND CHARINDEX(@rmmt_twf_code, 'AC12') > 0 AND @rmmt_gl_type = 1)
	    		BEGIN
	    			INSERT INTO FIDB.dbo.tfi_billhead_d (
					abhd_abhm_id, abhd_bill_type, abhd_m_id, abhd_d_id
					, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
					, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
					, adduser, acctid, abhd_source_id, abhd_source_nbr
					)
					SELECT @o_abhm_id, paym_nbr_flag, pm.paym_id, ISNULL(pm.paym_ref_did, 0)
						, pm.paym_currency, pm.paym_rate, pm.paym_amt, paym_rmks
						, pm.paym_amt, 0, 0
						, @i_abhm_emp, @i_acctid, pm.paym_ref_id, pm.paym_ref_nbr
					FROM FIDB.dbo.tfi_reimbursement_d d
					INNER JOIN FIDB.dbo.tfi_reimbursement m ON d.rmmd_rmmt_id = m.RMMT_ID
					INNER JOIN FIDB.dbo.tfi_pay_m pm ON d.rmmd_id = pm.paym_ref_did AND d.rmmd_rmmt_id = pm.paym_ref_id AND m.RMMT_NBR=pm.paym_ref_nbr
					WHERE d.rmmd_rmmt_id = @rmmt_id AND d.rmmd_contacts_rcode = @i_abhm_pay_code AND pm.paym_id <> @i_abhm_ref_id
					
					-- 借款冲报销
					INSERT INTO FIDB.dbo.tfi_billhead_d (
						abhd_abhm_id, abhd_bill_type, abhd_m_id, abhd_d_id
						, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
						, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
						, adduser, acctid, abhd_source_id, abhd_source_nbr
					)
					SELECT
						@o_abhm_id, paym_nbr_flag, rbre_paym_id, ISNULL(paym.paym_ref_did, 0)
						, paym.paym_currency, paym.paym_rate, rbre_amt, paym_rmks
						, 0, paym_amt - paym_real_amt, 0
						, @i_abhm_emp, @i_acctid, paym.paym_ref_id, paym.paym_ref_nbr
					FROM FIDB.dbo.tfi_reim_borrow_relation r
					INNER JOIN FIDB.dbo.tfi_reimbursement_d d ON d.rmmd_rmmt_id = r.rbre_rmmt_id AND d.rmmd_id = r.rbre_rmmd_id
					INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = rbre_paym_id
					WHERE rbre_rmmt_id = @rmmt_id AND rbre_rmmd_id <> @rmmt_did AND d.rmmd_contacts_rcode = @i_abhm_pay_code
					
	    		END 
				
			END
			-- 插入子表end

			-- 提交工作流
			--SELECT @summary = '付款：' + (CASE ctype WHEN 1 THEN '供应商' WHEN 2 THEN '个人' WHEN 3 THEN '客户' WHEN 4 THEN '部门' ELSE '其他' END)
				--+ ',' + pay_code + '-' + pay_name + ',' + CAST(CAST(@i_abhm_pay_amt AS DECIMAL(19, 2)) AS VARCHAR(19)) + @i_abhm_currency
			--FROM FIDB.dbo.v_fi_paycode_info WHERE ctype = @i_abhm_paycode_type AND pay_code = @i_abhm_pay_code;
			SELECT @summary = '付款：' + b.code_name + '：' + pay_name + '-' + pay_code + ',' + CAST(CAST(@i_abhm_pay_amt AS DECIMAL(19, 2)) AS VARCHAR(19)) + @i_abhm_currency
			FROM FIDB.dbo.v_fi_paycode_info info 
			LEFT JOIN HSRP.dbo.tba_code b on b.code_code = info.ctype AND  b.code_type='ap_paycodetype' 
			WHERE info.ctype = @i_abhm_paycode_type AND info.pay_code = @i_abhm_pay_code;
			
			DECLARE @wfcode VARCHAR(4);
			SET @wfcode = (CASE WHEN @i_abhm_type = 1 THEN 'AP07' ELSE 'AP08' END);
			EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp @wfcode, @i_abhm_emp, @o_abhm_id, @wfmid OUTPUT, @o_rntStr OUTPUT;
			IF (@o_rntStr = 'OK')
			BEGIN
				IF(@i_abhm_paycode_type = 1 AND ISNULL(@fi_wf_status, 0) = 1 )--付款方为供应商,且设置为推送待提单据
				BEGIN
					EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'SYSTEM', @o_abhm_id, @o_abhm_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT, '', '', @i_abhm_emp, 2;--推送为申请人待提
				END
				ELSE
				BEGIN
					EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, @i_abhm_emp, @o_abhm_id, @o_abhm_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT;--推送待审
				END
		
				IF (@o_rntStr <> 'OK')
				BEGIN
					SET @o_rntStr = '[AP07/08]注册工作流失败！提示：' + @o_rntStr;
				END
				ELSE
				BEGIN
					UPDATE FIDB.dbo.tfi_billhead_m SET abhm_nbr = @o_abhm_nbr WHERE abhm_id = @o_abhm_id;
				END
			END
			
		END
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_add_billhead_auto','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_billhead_auto AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
-- =========================================================================================
-- Author:		luocg
-- Create date: 2017-12-1
-- Description:	
-- 1、物资采购自动生成付款通知单，关联付款合同的对账单只推送了pay_m数据，满足条件后才推送付款通知单
-- 2、该合同未付款的总金额 = 相同合同的对账单总金额  才会推送
-- 3、多期时，每次只推送合同的一期，该期占该合同未付款的总金额的比例t1，多个对账单时则按照比例写入付款通知单的明细
-- modify [1]:  直接从对账单找到合同 luocg	2018-03-07
-- =========================================================================================
ALTER PROCEDURE rp_fi_add_billhead_auto
(
	@i_contract_code VARCHAR(40) = NULL --合同编号
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	DECLARE @i_contract_code VARCHAR(40); --合同编号
	SET @i_contract_code = '';
	*/
	
	DECLARE @c_code VARCHAR(40);	-- 合同编号
	DECLARE @c_date INT = 0;		-- 日期可提前天数
	DECLARE @acctid INT;			-- 区域  
	DECLARE @count INT = 0;			-- 计数  
	DECLARE @count_amt MONEY = 0;	-- 金额 
	
	DECLARE @fi_wf_status VARCHAR(20);	-- 0:推送为待审的付款通知单；1:推送为待提的付款通知单
	
	DECLARE @wfmid INT;					-- 流程id
	DECLARE @summary VARCHAR(200);		-- 工作流summary  
	DECLARE @rntStr VARCHAR(800);     
	                                         
	 -- 合同数据                  
	 DECLARE @CNTD_ID INT;				--记录id
	 DECLARE @CNTD_CNTM_ID INT;			--合同主记录id
	 DECLARE @CNTD_DUE_DATE DATETIME;	--付款到期日
	 DECLARE @CNTD_AMT MONEY = 0 ;			--当期应付金额
	 DECLARE @CNTD_PAID_AMT MONEY = 0;		--当期已付金额
	 DECLARE @CNTM_AMT MONEY;			--合同金额
	                         			
	 DECLARE @c_rate DECIMAL(19,7);		--分期比例                           		
	 DECLARE @c_sum_pay MONEY;			--pay_m表相同合同的金额之和  
	 DECLARE @c_sum_c MONEY;			--合同的待付总金额  
	   
	 --付款通知单主表数据
	 DECLARE @abhm_id INT;
	 DECLARE @abhm_nbr VARCHAR(20) = '';	--单号 
	 DECLARE @abhm_item VARCHAR(20);		-- 会计科目
	 DECLARE @abhm_emp VARCHAR(20);			-- 申请人
	 DECLARE @abhm_dept VARCHAR(20);		-- 申请部门code
	 DECLARE @abhm_pay_dept VARCHAR(20);	-- 付款部门
	 DECLARE @abhm_duty INT;				-- 申请人岗位
	 DECLARE @abhm_date DATETIME;			-- 申请日期
	 DECLARE @abhm_pay_date DATETIME;		-- 付款日期
	 DECLARE @abhm_legal INT;				-- 法人
	 DECLARE @abhm_paycode_type TINYINT;	-- 对方类型 1供应商 2个人
	 DECLARE @abhm_pay_code VARCHAR(20);	-- 对方代码
	 DECLARE @abhm_pay_type TINYINT;		-- 支付方式
	 DECLARE @abhm_pay_name VARCHAR(100);	-- 开户名
	 DECLARE @abhm_pay_bank VARCHAR(100);	-- 开户行
	 DECLARE @abhm_pay_nbr VARCHAR(50);		-- 开户账号
	 DECLARE @abhm_currency VARCHAR(10);	-- 币别
	 DECLARE @abhm_rate DECIMAL(19, 7);		-- 汇率
	 DECLARE @abhm_rmks VARCHAR(200);		-- 备注 
	                                 	 
	 -- 付款通知单明细表数据
	 DECLARE @abhd_abhm_id INT;				-- 付款主id
	 DECLARE @abhd_bill_type TINYINT;		-- 单据类型   
	 DECLARE @abhd_m_id VARCHAR(200);		-- 单据id   
	 DECLARE @abhd_currency VARCHAR(10);	-- 币别    
	 DECLARE @abhd_rate DECIMAL(19,7);		-- 汇率      
	 DECLARE @abhd_pay_amt 	MONEY;			-- 支付金额     
	 DECLARE @abhd_rmks VARCHAR(200);		-- 备注      
	 DECLARE @abhd_payb_amt MONEY;			-- 应付余额   
	 DECLARE @abhd_source_id INT;			-- 来源单据ID 
	 DECLARE @abhd_source_nbr VARCHAR(20);			-- 来源单据单号 
	 DECLARE @abhd_adduser VARCHAR(10);		   
	 DECLARE @abhd_acctid VARCHAR(10);	  
	  
	  
	IF OBJECT_ID('tempdb..#temp_pay') IS NOT NULL DROP TABLE #temp_pay;		-- 取物资采购推送的tfi_pay_m中的数据
	IF OBJECT_ID('tempdb..#temp_order') IS NOT NULL DROP TABLE #temp_order;	-- #temp_pay中的合同编号数据
	
	--关联合同的的未匹配数据
	--SELECT tpm.paym_id, tpm.paym_ref_id, paym_ref_nbr,paym_parent_id, 
	SELECT *
	INTO #temp_pay
	FROM fidb.dbo.tfi_pay_m tpm  
	WHERE tpm.paym_ref_nbr LIKE 'ET06-%' --物资采购对账单数据
	AND tpm.isenable = 1
	AND NOT EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_m m
						LEFT JOIN fidb.dbo.tfi_billhead_d d ON d.abhd_abhm_id = m.abhm_id
						WHERE m.abhm_status <> 8 AND d.abhd_m_id = tpm.paym_id
	)
	                  
	----合同数据,一个合同可能对应多个对账单主aetd_aetm_id, 对账单主明细aetd_id
	--SELECT d.aetd_id,d.aetd_aetm_id, d.aetd_po_nbr, poem.poem_contract_code, d.acctid 
	--INTO #temp_order
	--FROM  (SELECT rn = ROW_NUMBER() OVER (PARTITION BY aetd_aetm_id ORDER BY aetd_id ASC),*  FROM R6ERP.dbo.tpu_acctet_d)d--对账单明细表，相同aetd_aetm_id只取一条明细数据
	--INNER JOIN R6ERP.dbo.tpu_poet_m poem ON poem.poem_nbr = d.aetd_po_nbr 
	--AND poem.poem_contract_code = ISNULL(@i_contract_code, poem.poem_contract_code) --有输入参数时，测试用到
	--WHERE  d.rn=1 AND d.aetd_aetm_id IN (SELECT  paym_ref_id  FROM #temp_pay) 
	
	----合同数据,一个合同可能对应多个对账单主aetm_id
	SELECT m.aetm_id, m.aetm_contract_code, m.acctid 
	INTO #temp_order
	FROM  R6ERP.dbo.tpu_acctet_m m
	WHERE m.aetm_contract_code  = ISNULL(@i_contract_code,m.aetm_contract_code) --有输入参数时，测试用到
	AND m.aetm_id IN (SELECT  paym_ref_id  FROM #temp_pay) 
	
	--按合同数据循环
	--提交付款通知单回写合同明细的已付金额，撤销退回时还原
	WHILE EXISTS (SELECT 1 FROM #temp_order)
	BEGIN
		
		SET @count = 0;
		SET @count_amt = 0;
		
		SET @CNTD_AMT = 0;
		SET @c_sum_c = 0;
		SET @c_rate = 0;
		SET @c_sum_pay = 0;
		
		SELECT TOP 1 @c_code = aetm_contract_code, @acctid = acctid FROM #temp_order
		
		--推送待提还是待审
		SET @fi_wf_status = (SELECT code_value FROM hportal.dbo.tba_code  WHERE code_type='fi_wf_status' AND acctid = @acctid )
		
		--合同到期日可提前天数
		SELECT @c_date = ISNULL(code_value,0) FROM fidb.dbo.tba_code WHERE code_type = 'fi_contract_date' AND acctid = @acctid
		
		--到期合同明细,每次job只生成一期的付款通知单
		--找到到期的合同明细
		SELECT TOP 1  @CNTD_ID = d.CNTD_ID, @CNTD_CNTM_ID  = d.CNTD_CNTM_ID, @CNTD_DUE_DATE = d.CNTD_DUE_DATE,
		 @CNTD_AMT = d.CNTD_AMT, @CNTD_PAID_AMT = d.CNTD_PAID_AMT, @CNTM_AMT = m.CNTM_AMT
		FROM fidb.dbo.tfi_contract_d d
		INNER JOIN fidb.dbo.tfi_contract_m m ON m.CNTM_ID = d.CNTD_CNTM_ID
		WHERE m.CNTM_CODE = @c_code 
		AND d.CNTD_PAID_AMT = 0 
		--AND GETDATE() >= DATEADD(day, -@c_date, d.CNTD_DUE_DATE) AND GETDATE() <= d.CNTD_DUE_DATE
		AND d.CNTD_DUE_DATE <= DATEADD(day, 10, GETDATE())
		AND m.CNTM_STATUS = 6
		ORDER BY d.CNTD_ID ASC
		
		--该合同未付款的总金额
		SELECT @c_sum_c = SUM(d.CNTD_AMT) FROM fidb.dbo.tfi_contract_d d
		INNER JOIN fidb.dbo.tfi_contract_m m ON m.CNTM_ID = d.CNTD_CNTM_ID
		WHERE m.CNTM_CODE = @c_code AND d.CNTD_PAID_AMT = 0 AND m.CNTM_STATUS = 6
		
		--剩余金额的比例
		SET @c_rate = cast(cast(@CNTD_AMT as decimal(12,4)) /cast(@c_sum_c as decimal(12,4))  as decimal(12,4)) 
		
		
		IF(@CNTD_AMT > 0)--等于0说明不符合的合同明细，不用生成付款
		BEGIN
			 IF OBJECT_ID('tempdb..#temp_pay_id') IS NOT NULL DROP TABLE #temp_pay_id; --该合同下的pay_m表数据
			                                                                          
			--找到该合同的pay_m表数据
			SELECT *
			INTO #temp_pay_id
			FROM #temp_pay
			WHERE paym_ref_id IN(SELECT aetm_id FROM #temp_order WHERE aetm_contract_code = @c_code)	
			
			--相同合同的对账单paym总金额
			SELECT @c_sum_pay = SUM(paym_amt) FROM #temp_pay_id 
			--有几条对账单paym数据
			SELECT @count = COUNT(1) FROM #temp_pay_id 
			
			--符合条件开始生成付款通知单
			IF(@c_sum_c = @c_sum_pay)
			BEGIN
				
				EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_billhead_m', 'abhm_nbr', @abhm_nbr OUTPUT; 
			   	
				SELECT TOP 1 
					 @abhm_item = tpm.paym_item, @abhm_emp = tpm.paym_emp
					, @abhm_dept = tpm.paym_dept, @abhm_pay_dept = tpm.paym_admin_dept
					, @abhm_duty = tpm.paym_duty, @abhm_date = tpm.paym_date, @abhm_pay_date = tpm.paym_due_date
					, @abhm_legal = tpm.paym_legal, @abhm_paycode_type = tpm.paym_paycode_type
					, @abhm_pay_code = tpm.paym_pay_code, @abhm_pay_type = tpm.paym_pay_type
					, @abhm_pay_name = tpm.paym_pay_name, @abhm_pay_bank = tpm.paym_pay_bank
					, @abhm_pay_nbr = tpm.paym_pay_nbr, @abhm_currency = tpm.paym_currency
					, @abhm_rate = tpm.paym_rate
					, @abhm_rmks = '由以下物资采购对账单：'+  (SELECT STUFF((SELECT '，' + paym_ref_nbr FROM #temp_pay_id FOR XML PATH('')),1,1,'')) +'推送.'
				FROM #temp_pay_id tpm
				ORDER BY paym_id DESC 
				
				-- 插入主表begin
					INSERT INTO FIDB.dbo.tfi_billhead_m ( 
						abhm_type, abhm_nbr, abhm_item, abhm_emp, abhm_dept, abhm_pay_dept
						, abhm_duty, abhm_date, abhm_legal, abhm_paycode_type, abhm_pay_code, abhm_othercode_type, abhm_other_code
						, abhm_pay_type, abhm_pay_name, abhm_pay_bank, abhm_pay_nbr, abhm_currency
						, abhm_rate, abhm_amt, abhm_rec_amt, abhm_pay_amt, abhm_pay_date, abhm_rec_date
						, abhm_rmks, abhm_status, abhm_ref_type, abhm_ref_id, adduser, acctid)
					VALUES (
						1, @abhm_nbr, @abhm_item, @abhm_emp, @abhm_dept, @abhm_pay_dept
						, @abhm_duty, @abhm_date, @abhm_legal, @abhm_paycode_type, @abhm_pay_code, @abhm_paycode_type, @abhm_pay_code
						, @abhm_pay_type, @abhm_pay_name, @abhm_pay_bank, @abhm_pay_nbr, @abhm_currency
						, @abhm_rate, @CNTD_AMT, 0, @CNTD_AMT, @abhm_pay_date, NULL
						, @abhm_rmks, 1, null, null, @abhm_emp, @acctid);
					SET @abhm_id = @@identity; 
				-- 插入主表end
					
				-- 循环插入子表begin
					WHILE EXISTS (SELECT 1 FROM #temp_pay_id)
					BEGIN
						
						SELECT TOP 1 	
						@abhd_abhm_id = @abhm_id, @abhd_bill_type = m.paym_nbr_flag,
						@abhd_m_id = m.paym_id, @abhd_currency = m.paym_currency,
						@abhd_rate = m.paym_rate, @abhd_pay_amt = m.paym_amt*@c_rate,
						@abhd_rmks = m.paym_rmks, @abhd_payb_amt = m.paym_amt,	
						@abhd_adduser = m.adduser, @abhd_acctid = m.acctid
						, @abhd_source_id = m.paym_ref_id, @abhd_source_nbr = m.paym_ref_nbr
						FROM #temp_pay_id m
						ORDER BY paym_id ASC
						
						SET @abhd_pay_amt =  cast(@abhd_pay_amt as decimal(19,2))--金额都保存两位小数
						
						IF(@COUNT=1)--只有一条时@count_amt初始化为0的，最后一条时，减去用掉的
						BEGIN
							SET @abhd_pay_amt = @CNTD_AMT - @count_amt
						END
						ELSE 
						BEGIN
							SET @count_amt = @count_amt + @abhd_pay_amt;
						END
						
						SET @count = @count - 1;
						
						INSERT INTO FIDB.dbo.tfi_billhead_d (
						abhd_abhm_id, abhd_bill_type, abhd_m_id, abhd_d_id
						, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
						, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
						, adduser, acctid, abhd_cntd_id, abhd_source_id, abhd_source_nbr) 
						VALUES (
						 @abhm_id, @abhd_bill_type, @abhd_m_id, 0
						, @abhd_currency, @abhd_rate, @abhd_pay_amt, @abhd_rmks
						, @abhd_payb_amt, 0, 0, @abhd_adduser, @abhd_acctid, @CNTD_ID, @abhd_source_id, @abhd_source_nbr)
						
						--循环删除用
						DELETE FROM #temp_pay_id WHERE paym_id = @abhd_m_id;
						
					END
					DROP TABLE #temp_pay_id
				-- 插入子表end

				-- 提交工作流
					SELECT @summary = '付款：' + (CASE ctype WHEN 1 THEN '供应商' WHEN 2 THEN '个人' WHEN 3 THEN '客户' WHEN 4 THEN '部门' ELSE '其他' END)
						+ ',' + pay_code + '-' + pay_name + ',' + CAST(CAST(@CNTD_AMT AS DECIMAL(19, 2)) AS VARCHAR(19)) + @abhm_currency
					FROM FIDB.dbo.v_fi_paycode_info WHERE ctype = @abhm_paycode_type AND pay_code = @abhm_pay_code;
					
					DECLARE @wfcode VARCHAR(4);
					SET @wfcode =  'AP07';
					EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp  @wfcode, @abhm_emp, @abhm_id, @wfmid OUTPUT, @rntStr OUTPUT;
					IF (@rntStr = 'OK')
					BEGIN
						IF(@abhm_paycode_type = 1 AND ISNULL(@fi_wf_status, 0) = 1 )--付款方为供应商,且设置为推送待提单据
						BEGIN
							EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'SYSTEM', @abhm_id, @abhm_nbr OUTPUT, @summary, '', '', @rntStr OUTPUT, '', '', @abhm_emp, 2;--推送为申请人待提
						END
						ELSE
						BEGIN
							EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, @abhm_emp, @abhm_id, @abhm_nbr OUTPUT, @summary, '', '', @rntStr OUTPUT;--推送待审
						END
				
						IF (@rntStr <> 'OK')
						BEGIN
							SET @rntStr = '[AP07]注册工作流失败！提示：' + @rntStr;
						END
						ELSE
						BEGIN
							UPDATE FIDB.dbo.tfi_billhead_m SET abhm_nbr = @abhm_nbr WHERE abhm_id = @abhm_id;
						END
					END	
				
			END
		END 
			
		--循环删除
		DELETE FROM #temp_order WHERE @c_code = aetm_contract_code
	END
	
	DROP TABLE #temp_order
	DROP TABLE #temp_pay
	
		
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO

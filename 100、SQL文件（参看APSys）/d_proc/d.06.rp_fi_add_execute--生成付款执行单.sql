USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_add_execute','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_execute AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		刘蔚
-- Create date: 2013-10-08
-- Description:	生成付款执行单并提交工作流
-- Modify[1]:申请人离职时的特殊情况处理 by liuxiang
-- Modify[2]: 2014-4-23 liuxiang 增加离职人员的处理逻辑，若找不到上级，则提醒审批人员手工生成下一个流程的单据
-- modfiy[3]: 生成执行单时，增加币别、汇率的写入 by zhoupan at 2015-11-26
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_add_execute]
(
	@i_exem_emp  VARCHAR(20)			--申请人
	, @i_exem_dept VARCHAR(20)			--申请部门
	, @i_exem_duty INT					--申请岗位
	, @i_exem_date DATETIME				--申请日期
	, @i_exem_legal INT					--法人
	, @i_exem_pay_amt MONEY				--付款通知金额
	, @i_exem_amt MONEY					--付款执行金额
	, @i_exem_curr VARCHAR(3)			--执行币别
	, @i_exem_rate DECIMAL(19,7)		--执行汇率
	, @i_exem_rmks VARCHAR(800)			--备注
	, @i_exem_ref_mid INT				--前置单id
	, @i_exem_ref_nbr VARCHAR(20)		--前置单号
	, @i_exem_pay_date DATETIME			--付款日期
	, @i_acctid INT
	, @o_exem_nbr VARCHAR(20) OUTPUT	-- 返回付款单号
	, @o_exem_id INT OUTPUT				-- 返回付款单id
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	-- 调试数据
	DECLARE @i_exem_emp  VARCHAR(20)         --申请人
	DECLARE @i_exem_dept VARCHAR(20)         --申请部门
	DECLARE @i_exem_duty INT        --申请岗位
	DECLARE @i_exem_date DATETIME            --申请日期
	DECLARE @i_exem_legal INT         --法人
	DECLARE @i_exem_pay_amt MONEY      --付款通知金额
	DECLARE @i_exem_amt     MONEY     --付款执行金额
	DECLARE @i_exem_rmks VARCHAR(200)          --备注
	DECLARE @i_exem_ref_mid INT      --前置单id
	DECLARE @i_exem_ref_nbr VARCHAR(20)      --前置单号
	DECLARE @i_exem_pay_date DATETIME		--付款日期
	DECLARE @i_acctid INT 
	DECLARE @o_exem_nbr INT OUTPUT				-- 返回付款单id
	DECLARE @o_exem_id VARCHAR(20) OUTPUT	-- 返回付款单号
	DECLARE @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
	
	SET  @i_exem_emp= '00000001';       --申请人
	SET  @i_exem_dept = '012213';      --申请部门
	SET  @i_exem_duty = 10026;      --申请岗位
	SET  @i_exem_date=getdate();           --申请日期
	SET  @i_exem_legal =1 ;       --法人
	SET  @i_exem_pay_amt =1.00;     --付款通知金额
	SET  @i_exem_amt =1.00 ;    --付款执行金额
	SET  @i_exem_rmks ='';         --备注
	SET  @i_exem_ref_mid =1  ;    --前置单id
	SET  @i_exem_pay_date=GETDATE();
	SET  @i_exem_ref_nbr ='AP08-13090001'  ;    --前置单号
	SET  @i_acctid =1;
	*/
	DECLARE @exem_dept_level VARCHAR(20);  -- 申请人离职取部门负责人用
	DECLARE @code_type INT;
	DECLARE @pay_code VARCHAR(20);
	DECLARE @dept_code VARCHAR(20);
	DECLARE @dept_name VARCHAR(50);
	DECLARE @exem_acct_id INT='';--付款方账号
	
	
	SET @o_rntStr = 'OK';
	
	IF (@i_exem_ref_mid = 0 OR @i_exem_ref_mid IS NULL)
	BEGIN -- 关联单据为空
		SET @o_rntStr = '推送单据为空，不能生成付款执行单！';
	END
	--ELSE IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE exem_ref_mid = @i_exem_ref_mid AND exem_ref_nbr = @i_exem_ref_nbr AND exem_status <> 8)
	--BEGIN
		--SET @o_rntStr = @i_exem_ref_nbr + '号单已存在付款执行单！';
	--END
	ELSE
	BEGIN
		IF(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_exem_emp))
		BEGIN
			
			DECLARE @temp_emp VARCHAR(20);
			
			--先找部门主管人
			SELECT @exem_dept_level = cc_level FROM HR90.dbo.cc_mstr1 WHERE cc_code = @i_exem_dept;
			SELECT @temp_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@exem_dept_level, '', '', '', 1);
			
			IF(NOT EXISTS ( SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp))
			BEGIN
				SET @temp_emp=@i_exem_emp
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
			SET @i_exem_emp=@temp_emp;
			SELECT  @i_exem_dept = cc_code, @i_exem_duty = duty_id  FROM  fidb.dbo.v_fi_dutyall  WHERE emp_id = @i_exem_emp AND ismain=1
			END
		END
		
		IF(EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_exem_emp))
		BEGIN	
			SELECT @code_type=abhm_paycode_type, @pay_code=abhm_pay_code
			FROM FIDB.dbo.tfi_billhead_m tbm
			WHERE tbm.abhm_id=@i_exem_ref_mid
			IF(@code_type=1)
			BEGIN
				SELECT @dept_code=dept.cc_code, @dept_name=dept.cc_desc 
				FROM HPUR.dbo.TPU_SUPPLIER spl
				LEFT JOIN FIDB.dbo.v_fi_dept dept ON dept.cc_code = spl.spl_manage_dept
				WHERE spl.spl_code = @pay_code
				
				IF(ISNULL(@dept_code,'')='')
				BEGIN
					SELECT @dept_code = dept.cc_code, @dept_name = dept.cc_desc
					FROM FIDB.dbo.v_fi_dept dept 
					WHERE dept.cc_code=@i_exem_dept
				END
				
			END
			ELSE IF(@code_type=2)
			BEGIN
				SELECT @dept_code=fe.cc_code, @dept_name=fe.cc_desc 
				FROM FIDB.dbo.v_fi_empmstr fe 
				WHERE fe.emp_id = @pay_code
			END
			ELSE IF(@code_type=3)
			BEGIN
				SELECT @dept_code=dept.cc_code, @dept_name=dept.cc_desc FROM HSAL.dbo.TSA_CUSTOMER cust
				LEFT JOIN FIDB.dbo.v_fi_dept dept ON dept.cc_code = cust.cust_dept
				WHERE cust.cust_code = @pay_code
			END
			ELSE
			BEGIN
				SELECT @dept_code = dept.cc_code, @dept_name = dept.cc_desc
				FROM FIDB.dbo.v_fi_dept dept 
				WHERE dept.cc_code=@pay_code
			END
		
		DECLARE @nbr VARCHAR(20);
		DECLARE @exem_pay_type INT =0;
		SELECT TOP(1) @exem_pay_type = tbm.abhm_pay_type FROM FIDB.dbo.tfi_billhead_m tbm WHERE tbm.abhm_id = @i_exem_ref_mid
		--有效、非理财账户、银行或者现金类型、法人、币别下的账户排序
		SELECT TOP(1) @exem_acct_id = acct_id FROM fidb.dbo.tfi_account ta 
				   WHERE ta.acct_flag = 1 AND ta.acct_type <> 6 AND  ta.acct_class =(CASE WHEN @exem_pay_type = 1 THEN 1 ELSE 0 END) 
					AND ta.acct_legal = @i_exem_legal AND (acct_kind = 1 OR (acct_kind = 0 AND ISNULL(acct_curr_type,'') = @i_exem_curr))
					ORDER BY ISNULL(ta.acct_isdefault, 0) DESC
		
		SET @nbr = '';
		EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_execute_m', 'exem_nbr', @nbr OUTPUT; 

			INSERT INTO fidb.dbo.tfi_execute_m (
				exem_nbr
				,exem_emp
				,exem_dept
				,exem_duty
				,exem_pemr_code
				,exem_date
				,exem_legal
				,exem_acct_id
				,exem_pay_amt
				,exem_amt
				,exem_curr
				,exem_rate
				,exem_rmks
				,exem_status
				,exem_ref_mid
				,exem_ref_nbr
				,exem_pay_date
				,exem_balance_dept
				,exem_balance_deptname
				,exem_paycode_dept
				,exem_paycode_deptname
				,exem_pay_dept
				,isenable
				,addtime
				,adduser
				,acctid
				,exem_pay_type
			) VALUES (
				@nbr
				, @i_exem_emp
				, @i_exem_dept
				, @i_exem_duty
				, (SELECT TOP(1) pemr_code FROM hr90.dbo.thr_person_mstr
					where GETDATE() >= pemr_sdate AND GETDATE() <= ISNULL(pemr_edate,'9999-01-01') 
					AND pemr_emp_id = @i_exem_emp AND pemr_duty_id = @i_exem_duty)
				, @i_exem_date
				, @i_exem_legal
				--没有找到账户随便给一个有效的
				, (SELECT TOP(1) (CASE WHEN @exem_acct_id <> '' THEN @exem_acct_id ELSE  acct_id END ) FROM fidb.dbo.tfi_account ta 
				   WHERE ta.acct_class =(CASE WHEN @exem_pay_type = 1 THEN 1 ELSE 0 END) AND ta.acct_flag=1  )
				, @i_exem_pay_amt
				, @i_exem_amt
				, @i_exem_curr
				, @i_exem_rate
				, @i_exem_rmks
				, 1
				, @i_exem_ref_mid
				, @i_exem_ref_nbr
				, @i_exem_pay_date
				, 'Z00000'
				, '航嘉机构'
				, ISNULL(@dept_code,'')
				, ISNULL(@dept_name,'')
				, (SELECT abhm.abhm_pay_dept FROM FIDB.dbo.tfi_billhead_m abhm WHERE abhm.abhm_id = @i_exem_ref_mid)--@i_exem_dept
				, 1
				, GETDATE()
				, @i_exem_emp
				, @i_acctid
				, @exem_pay_type
			);
			SET @o_exem_id = @@identity;
			-- 插入主表end
			
			DECLARE @remks VARCHAR(200)  --提交单据生成的单据摘要
			SET @remks='通知单号：'+@i_exem_ref_nbr + @i_exem_rmks;
			
			DECLARE @wfm_id INT;
			EXEC hportal.dbo.rp_wf_get_workflowByEmp 'AP10',@i_exem_emp,@o_exem_id,@wfm_id OUTPUT,@o_rntStr OUTPUT;
			IF (@o_rntStr = 'OK')
			BEGIN
				EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfm_id, @i_exem_emp, @o_exem_id, @o_exem_nbr OUTPUT, @remks, '', '', @o_rntStr OUTPUT;
				
				IF @o_rntStr <> 'OK'
				BEGIN
					SET @o_rntStr = '[AP10]注册工作流失败！提示：' + @o_rntStr;
				END	
				ELSE
				BEGIN
					UPDATE FIDB.dbo.tfi_execute_m SET exem_nbr = @o_exem_nbr WHERE exem_id = @o_exem_id;	
				END
			END
		END
		ELSE
		BEGIN
			DECLARE @re_code VARCHAR(10);
			DECLARE @re_exem_name VARCHAR(20);
			DECLARE @re_summry VARCHAR(200);
			DECLARE @re_aid INT;
			DECLARE @re_rid VARCHAR(20);
			
			IF OBJECT_ID('tempdb..#re_exec_remind') IS NOT NULL
			BEGIN
				DROP TABLE #re_exec_remind;
			END
			SELECT wfna_id,wfna_emp_id INTO #re_exec_remind FROM FIDB.dbo.tfi_billhead_a WHERE LEN(wfna_wf_route) -LEN(REPLACE(wfna_wf_route,',','')) = 3 AND wfna_m_id = @i_exem_ref_mid;
			
			WHILE EXISTS(SELECT 1 FROM #re_exec_remind)
			BEGIN
				SELECT TOP(1) @re_aid = wfna_id,@re_rid = wfna_emp_id FROM #re_exec_remind ORDER BY wfna_id DESC;
				
				IF EXISTS(SELECT 1 FROM HR90.dbo.h_emp_mstr hea WHERE hea.emp_id = @re_rid)
				BEGIN
					SET @re_code = LEFT(@i_exem_ref_nbr,4);
					SELECT @re_exem_name = emp_name FROM FIDB.dbo.v_fi_empmstr WHERE emp_id = @i_exem_emp;
					SET @re_summry='因申请人'+isnull(@re_exem_name,'')+'('+isnull(@i_exem_emp,'')+') 离职，导致单据 '+isnull(@i_exem_ref_nbr,'')+' 无法自动推送付款执行单(AP10)，请在资金管理系统中的付款管理-->付款执行中查询出该单据进行手工推送付款执行单(AP10)'
				
					EXEC HPORTAL.dbo.rp_wf_remind @re_code,@re_rid,3,@re_summry,@o_rntStr OUTPUT;
				END
				
				DELETE FROM #re_exec_remind WHERE wfna_id = @re_aid;
			END
			DROP TABLE #re_exec_remind ;
		END
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
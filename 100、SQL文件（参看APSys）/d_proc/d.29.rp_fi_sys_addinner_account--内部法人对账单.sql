USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_sys_addinner_account','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_sys_addinner_account AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[rp_fi_sys_addinner_account]
(
	@i_fdate varchar(20) = '',					-- 对账时间
	@i_pficn varchar(20) = '',              -- 付款法人
	@i_rficn varchar(20) = ''               -- 收款法人
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;

	DECLARE @summary VARCHAR(200);
	DECLARE @wfmid INT;
	DECLARE @o_rntStr VARCHAR(800);
	DECLARE @o_inam_id INT;
	DECLARE @o_inam_nbr VARCHAR(20);
	
	declare @inam_emp varchar(20);
	declare @inam_dept varchar(20);
	declare @inam_duty INT;
	declare @inam_pemr_code varchar(20);
	
	declare @inam_nbr varchar(20);
	declare @inam_currency varchar(20);
	declare @inam_pay_type int;
	declare @inam_pay_acct_id int;
	declare @inam_other_acct_id int;
	declare @inam_pay_name varchar(80)
	declare @inam_other_name varchar(80)
	
	declare @inam_amt money;
		
	declare @m_id INT;
	declare @pay_ficn_code varchar(20);
	declare @rec_ficn_code varchar(20);
	
	DECLARE @temp_pay_ficn table(m_id int IDENTITY,pay_ficn_code varchar(20),rec_ficn_code varchar(20))
	DECLARE @temp_rec_ficn table(m_id int IDENTITY,pay_ficn_code varchar(20),rec_ficn_code varchar(20))
	
	DECLARE @beg_date datetime;
	DECLARE @end_date datetime;	
	IF(@i_fdate='')
	BEGIN
		SET @i_fdate = CONVERT(varchar(20),DATEADD(day ,-1,GETDATE()), 120);
	END
	select @beg_date=mBegdate,@end_date=mEndtime FROM HPORTAL.dbo.contrast_monthf where @i_fdate BETWEEN mBegdate AND mEndtime    
    --暂时申请人取段雯娟,取任职岗位部门
    set @inam_emp = '14040501'
    select TOP 1 @inam_dept = cc_code,@inam_duty = duty_id from FIDB.dbo.v_fi_dutyall where emp_id = @inam_emp
    select @inam_pemr_code = pemr_code from hr90.dbo.thr_person_mstr where pemr_emp_id = @inam_emp and pemr_duty_id = @inam_duty
    
    --暂时先设置支付方式和币别
    set @inam_currency = 'RMB';
    set @inam_pay_type = 2;
    
    --paym信息
    if object_id('tempdb..#paym') is not null drop table #paym  
	SELECT nbr_paym_id, nbr_status = MAX(nbr_status) into #paym FROM FIDB.dbo. v_fi_wfing GROUP BY nbr_paym_id;  
	create index idx_1 on #paym(nbr_paym_id);
	
	--付款数据
	insert INTO @temp_pay_ficn
	SELECT DISTINCT ficn.ficn_code,paym.paym_pay_code 
	FROM FIDB.dbo.v_fi_billhead_d_innera vbdf
	INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = vbdf.vbdf_mid
	inner JOIN FIDB.dbo.vfi_corporation ficn ON ficn.ficn_id = paym.paym_legal
	inner JOIN fidb.dbo.v_fi_paycode_info payc ON paym.paym_pay_code = payc.pay_code
	LEFT JOIN HSRP.dbo.tba_code tbac on tbac.code_code = payc.ctype AND  tbac.code_type='ap_paycodetype' 
	where paym_due_date between @beg_date AND @end_date and ctype = 101	                    --对账日期
	AND paym.paym_nbr_flag IN (1,2) AND paym.isenable = 1 AND paym.paym_parent_id = 0		--付款单
	AND NOT EXISTS (select 1 from FIDB.dbo.tfi_inner_account_m inam
		INNER JOIN FIDB.dbo.tfi_inner_account_d inad ON inad.inad_inam_id = inam.inam_id
		where inad_paym_id = paym.paym_id AND inam.inam_type = 0 AND inam.inam_status <> 6)
	AND vbdf.vbdf_nbr NOT LIKE 'AP11%'
	AND vbdf_amt + vbdf_rec_amt <> 0
	AND vbdf_nbr NOT like 'AC15%' 
	AND vbdf_nbr NOT like 'AC24%'
    
    --推送付款对账单
    WHILE exists(SELECT 1 from @temp_pay_ficn)
    BEGIN 
		SELECT TOP 1 @m_id = m_id,@pay_ficn_code = pay_ficn_code,@rec_ficn_code = rec_ficn_code from @temp_pay_ficn
		
		--取付款法人账号
		SELECT TOP 1 @inam_pay_acct_id = acct_id
		FROM FIDB.dbo.tfi_account acct
		INNER JOIN FIDB.dbo.tfi_balance tba ON tba.blnc_acct_id=acct.acct_id 
		LEFT JOIN FIDB.dbo.v_fi_tbacode code ON code.code_type='acct_bank' AND CONVERT(VARCHAR(10),acct.acct_bank)=code.code_code 
		LEFT JOIN fidb.dbo.VFI_CORPORATION vc ON vc.ficn_id = acct.acct_legal 
		WHERE tba.blnc_balance != 0 AND isnull(acct.acct_type,0) <> 6--过滤理财账户  
		AND vc.ficn_code = @pay_ficn_code AND ((acct_kind = 0 AND ACCT_CURR_TYPE='RMB') OR acct_kind =1 ) AND acct_class = 0 AND acct_type= 1
		
		--取收款法人账号
		SELECT TOP 1 @inam_other_acct_id = acct_id
		FROM FIDB.dbo.tfi_account acct
		INNER JOIN FIDB.dbo.tfi_balance tba ON tba.blnc_acct_id=acct.acct_id 
		LEFT JOIN FIDB.dbo.v_fi_tbacode code ON code.code_type='acct_bank' AND CONVERT(VARCHAR(10),acct.acct_bank)=code.code_code 
		LEFT JOIN fidb.dbo.VFI_CORPORATION vc ON vc.ficn_id = acct.acct_legal 
		WHERE tba.blnc_balance != 0 AND isnull(acct.acct_type,0) <> 6--过滤理财账户  
		AND vc.ficn_code = @rec_ficn_code AND ((acct_kind = 0 AND ACCT_CURR_TYPE='RMB') OR acct_kind =1 ) AND acct_class = 0 AND acct_type= 1
		
		--取付款法人名称
		SELECT @inam_pay_name = b.code_name +'：'+ a.pay_fname 
		FROM FIDB.dbo.v_fi_paycode_info a	 
		LEFT JOIN HSRP.dbo.tba_code b on b.code_code = a.ctype AND  b.code_type='ap_paycodetype' 
		WHERE pay_code = @pay_ficn_code
		
		--取收款法人名称
		SELECT @inam_other_name = b.code_name +'：'+ a.pay_fname 
		FROM FIDB.dbo.v_fi_paycode_info a	 
		LEFT JOIN HSRP.dbo.tba_code b on b.code_code = a.ctype AND  b.code_type='ap_paycodetype' 
		WHERE pay_code = @rec_ficn_code
		
		EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_inner_account_m', 'inam_nbr', @inam_nbr OUTPUT;
		
		--插入主表信息
		INSERT INTO FIDB.dbo.tfi_inner_account_m( 
				inam_type,inam_nbr,inam_emp,inam_dept,inam_duty,inam_pemr_code,		             --1  
				inam_date,inam_paycode_type,inam_pay_code,inam_pay_acct_id,inam_pay_type,		 --2  
				inam_othercode_type,inam_other_code,inam_other_acct_id,inam_currency,inam_rate,	 --3  
				inam_amt,inam_pay_date,inam_rmks,inam_status,inam_ref_id,isenable,				 --4  
				addtime,adduser,modtime,modtime2,moduser,acctid									 --5  
				)VALUES (
				0,@inam_nbr,@inam_emp,@inam_dept,@inam_duty,@inam_pemr_code,                     --1
				GETDATE(),101,@pay_ficn_code,isnull(@inam_pay_acct_id,0),2,                                                --2
				101,@rec_ficn_code,isnull(@inam_other_acct_id,0),@inam_currency,1.00,                                      --3
				0.00,GETDATE(),'',1,0,1,                                                         --4
				GETDATE(),@inam_emp,GETDATE(),'',@inam_emp,1                                     --5
				)
		SET @o_inam_id = @@identity;   
		
		--插入明细表信息
		INSERT INTO FIDB.dbo.tfi_inner_account_d					                             
				(inad_inam_id,inad_bill_type,inad_paym_id,inad_currency,						 --1
				inad_rate,inad_pay_amt,inad_rmks,inad_real_amt,									 --2
				inad_source_nbr,inad_source_id,isenable,addtime,								 --3
				adduser,modtime,moduser,acctid)													 --4
		SELECT @o_inam_id,vbdf_abhd_bill_type,vbdf_mid,vbdf_currency,                                                             --1
				vbdf_rate,vbdf_amt,'',vbdf_amt,	  --2
				vbdf_source_URL,vbdf_source_mid,1,GETDATE(),                                                                      --3
				@inam_emp,GETDATE(),@inam_emp,1																					  --4
		FROM FIDB.dbo.v_fi_billhead_d_innera vbdf
		INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = vbdf.vbdf_mid
		INNER JOIN FIDB.dbo.VFI_CORPORATION ficn on ficn.ficn_id = paym.paym_legal
		where ficn.ficn_code = @pay_ficn_code 
		AND vbdf.vbdf_pay_code = @rec_ficn_code
		AND paym.paym_nbr_flag IN (1,2) AND paym.isenable = 1 AND paym.paym_parent_id = 0		--付款单
		AND vbdf_date between @beg_date AND @end_date
		AND NOT EXISTS (select 1 from FIDB.dbo.tfi_inner_account_m inam
			INNER JOIN FIDB.dbo.tfi_inner_account_d inad ON inad.inad_inam_id = inam.inam_id
			where inad_paym_id = paym.paym_id AND inam.inam_type = 0 AND inam.inam_status <> 6)
		AND vbdf.vbdf_nbr NOT LIKE 'AP11%'
		AND vbdf_nbr NOT like 'AC15%' 
		AND vbdf_nbr NOT like 'AC24%'
		AND vbdf_amt + vbdf_rec_amt <> 0
		
		--计算更新对账金额
		select @inam_amt = sum(inad_real_amt * inad_rate) 
			from FIDB.dbo.tfi_inner_account_d where inad_inam_id = @o_inam_id
		UPDATE FIDB.dbo.tfi_inner_account_m SET inam_amt = isnull(@inam_amt,0.00) where inam_id = @o_inam_id  
		
		-- 提交工作流
		SET @summary = '付款' + @inam_pay_name + '与收款' + @inam_other_name + '对账单，对账日期：' + CONVERT(varchar,GETDATE(),23) + '，币别：RMB';

		EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp 'AP11', @inam_emp, @o_inam_id, @wfmid OUTPUT, @o_rntStr OUTPUT;
		IF (@o_rntStr = 'OK')
		BEGIN
			EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'system', @o_inam_id, @o_inam_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT,'','',@inam_emp,2;
			
			IF (@o_rntStr <> 'OK')
			BEGIN
				SET @o_rntStr = '[AC12]注册工作流失败！提示：' + @o_rntStr;
				RAISERROR(@o_rntStr, 16, 1);
			END
			ELSE
			BEGIN
				UPDATE FIDB.dbo.tfi_inner_account_m SET inam_nbr = @o_inam_nbr WHERE inam_id = @o_inam_id;
			END
		END
		ELSE
		BEGIN
			SET @o_rntStr = '[AC12]写审核信息失败！提示：' + @o_rntStr;
			RAISERROR(@o_rntStr, 16, 1);
		END
		
		delete from @temp_pay_ficn where m_id = @m_id
    END
    
    --收款数据
	insert INTO @temp_rec_ficn
	SELECT DISTINCT paym.paym_pay_code,ficn.ficn_code
	FROM FIDB.dbo.v_fi_billhead_d_innera vbdf
	INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = vbdf.vbdf_mid
	inner JOIN FIDB.dbo.vfi_corporation ficn ON ficn.ficn_id = paym.paym_legal
	inner JOIN fidb.dbo.v_fi_paycode_info payc ON paym.paym_pay_code = payc.pay_code
	LEFT JOIN HSRP.dbo.tba_code tbac on tbac.code_code = payc.ctype AND  tbac.code_type='ap_paycodetype' 
	where paym_due_date between @beg_date AND @end_date and ctype = 101	                    --对账日期
	AND paym.paym_nbr_flag IN (3,4) AND paym.isenable = 1 AND paym.paym_parent_id = 0		--付款单
	AND NOT EXISTS (select 1 from FIDB.dbo.tfi_inner_account_m inam
		INNER JOIN FIDB.dbo.tfi_inner_account_d inad ON inad.inad_inam_id = inam.inam_id
		where inad_paym_id = paym.paym_id AND inam.inam_type = 1 AND inam.inam_status <> 6)
	AND vbdf.vbdf_nbr NOT LIKE 'AP11%'
	AND vbdf_amt + vbdf_rec_amt <> 0
	AND vbdf_nbr NOT like 'AC15%' 
	AND vbdf_nbr NOT like 'AC24%'
   
   --推送收款对航单
	WHILE exists(SELECT 1 from @temp_rec_ficn) 
    BEGIN 
		SELECT TOP 1 @m_id = m_id,@pay_ficn_code = pay_ficn_code,@rec_ficn_code = rec_ficn_code from @temp_rec_ficn
		
				--取付款法人账号
		SELECT TOP 1 @inam_pay_acct_id = acct_id
		FROM FIDB.dbo.tfi_account acct
		INNER JOIN FIDB.dbo.tfi_balance tba ON tba.blnc_acct_id=acct.acct_id 
		LEFT JOIN FIDB.dbo.v_fi_tbacode code ON code.code_type='acct_bank' AND CONVERT(VARCHAR(10),acct.acct_bank)=code.code_code 
		LEFT JOIN fidb.dbo.VFI_CORPORATION vc ON vc.ficn_id = acct.acct_legal 
		WHERE tba.blnc_balance != 0 AND isnull(acct.acct_type,0) <> 6--过滤理财账户  
		AND vc.ficn_code = @pay_ficn_code AND ((acct_kind = 0 AND ACCT_CURR_TYPE='RMB') OR acct_kind =1 ) AND acct_class = 0 AND acct_type= 1
		
		--取收款法人账号
		SELECT TOP 1 @inam_other_acct_id = acct_id
		FROM FIDB.dbo.tfi_account acct
		INNER JOIN FIDB.dbo.tfi_balance tba ON tba.blnc_acct_id=acct.acct_id 
		LEFT JOIN FIDB.dbo.v_fi_tbacode code ON code.code_type='acct_bank' AND CONVERT(VARCHAR(10),acct.acct_bank)=code.code_code 
		LEFT JOIN fidb.dbo.VFI_CORPORATION vc ON vc.ficn_id = acct.acct_legal 
		WHERE tba.blnc_balance != 0 AND isnull(acct.acct_type,0) <> 6--过滤理财账户  
		AND vc.ficn_code = @rec_ficn_code AND ((acct_kind = 0 AND ACCT_CURR_TYPE='RMB') OR acct_kind =1 ) AND acct_class = 0 AND acct_type= 1

		--取付款法人名称
		SELECT @inam_pay_name = b.code_name +'：'+ a.pay_fname 
		FROM FIDB.dbo.v_fi_paycode_info a	 
		LEFT JOIN HSRP.dbo.tba_code b on b.code_code = a.ctype AND  b.code_type='ap_paycodetype' 
		WHERE pay_code = @pay_ficn_code
		
		--取收款法人名称
		SELECT @inam_other_name = b.code_name +'：'+ a.pay_fname 
		FROM FIDB.dbo.v_fi_paycode_info a	 
		LEFT JOIN HSRP.dbo.tba_code b on b.code_code = a.ctype AND  b.code_type='ap_paycodetype' 
		WHERE pay_code = @rec_ficn_code
		
		EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_inner_account_m', 'inam_nbr', @inam_nbr OUTPUT;
		
		--插入主表信息
		INSERT INTO FIDB.dbo.tfi_inner_account_m( 
				inam_type,inam_nbr,inam_emp,inam_dept,inam_duty,inam_pemr_code,		             --1  
				inam_date,inam_paycode_type,inam_pay_code,inam_pay_acct_id,inam_pay_type,		 --2  
				inam_othercode_type,inam_other_code,inam_other_acct_id,inam_currency,inam_rate,	 --3  
				inam_amt,inam_pay_date,inam_rmks,inam_status,inam_ref_id,isenable,				 --4  
				addtime,adduser,modtime,modtime2,moduser,acctid									 --5  
				)VALUES (
				1,@inam_nbr,@inam_emp,@inam_dept,@inam_duty,@inam_pemr_code,                     --1
				GETDATE(),101,@pay_ficn_code,isnull(@inam_pay_acct_id,0),2,                                                --2
				101,@rec_ficn_code,isnull(@inam_other_acct_id,0),@inam_currency,1.00,                                      --3
				0.00,GETDATE(),'',1,0,1,                                                         --4
				GETDATE(),@inam_emp,GETDATE(),'',@inam_emp,1                                     --5
				)
		SET @o_inam_id = @@identity;   
		
		--插入明细表信息
		INSERT INTO FIDB.dbo.tfi_inner_account_d					                             
				(inad_inam_id,inad_bill_type,inad_paym_id,inad_currency,						 --1
				inad_rate,inad_pay_amt,inad_rmks,inad_real_amt,									 --2
				inad_source_nbr,inad_source_id,isenable,addtime,								 --3
				adduser,modtime,moduser,acctid)													 --4
		SELECT @o_inam_id,vbdf_abhd_bill_type,vbdf_mid,vbdf_currency,                                                             --1
				vbdf_rate,vbdf_rec_amt,'',vbdf_rec_amt,                                                                        	  --2
				vbdf_source_URL,vbdf_source_mid,1,GETDATE(),                                                                      --3
				@inam_emp,GETDATE(),@inam_emp,1																					  --4
		FROM FIDB.dbo.v_fi_billhead_d_innera vbdf
		INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id = vbdf.vbdf_mid
		INNER JOIN FIDB.dbo.VFI_CORPORATION ficn on ficn.ficn_id = paym.paym_legal
		where ficn.ficn_code = @rec_ficn_code
		AND vbdf.vbdf_pay_code = @pay_ficn_code
		AND paym.paym_nbr_flag IN (3,4) AND paym.isenable = 1 AND paym.paym_parent_id = 0		--付款单
		AND vbdf_date between @beg_date AND @end_date
		AND NOT EXISTS (select 1 from FIDB.dbo.tfi_inner_account_m inam
			INNER JOIN FIDB.dbo.tfi_inner_account_d inad ON inad.inad_inam_id = inam.inam_id
			where inad_paym_id = paym.paym_id AND inam.inam_type = 1 AND inam.inam_status <> 6)
		AND vbdf.vbdf_nbr NOT LIKE 'AP11%'
		AND vbdf_nbr NOT like 'AC15%' 
		AND vbdf_nbr NOT like 'AC24%'
		AND vbdf_amt + vbdf_rec_amt <> 0
		
		--计算更新对账金额
		select @inam_amt = sum(inad_real_amt * inad_rate) 
			from FIDB.dbo.tfi_inner_account_d where inad_inam_id = @o_inam_id
		UPDATE FIDB.dbo.tfi_inner_account_m SET inam_amt = isnull(@inam_amt,0.00) where inam_id = @o_inam_id  
		
		-- 提交工作流
		SET @summary = '付款' + @inam_pay_name + '与收款' + @inam_other_name + '对账单，对账日期：' + CONVERT(varchar,GETDATE(),23) + '，币别：RMB';

		EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp 'AP11', @inam_emp, @o_inam_id, @wfmid OUTPUT, @o_rntStr OUTPUT;
		IF (@o_rntStr = 'OK')
		BEGIN
			EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'system', @o_inam_id, @o_inam_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT,'','',@inam_emp,2;
			
			IF (@o_rntStr <> 'OK')
			BEGIN
				SET @o_rntStr = '[AC12]注册工作流失败！提示：' + @o_rntStr;
				RAISERROR(@o_rntStr, 16, 1);
			END
			ELSE
			BEGIN
				UPDATE FIDB.dbo.tfi_inner_account_m SET inam_nbr = @o_inam_nbr WHERE inam_id = @o_inam_id;
			END
		END
		ELSE
		BEGIN
			SET @o_rntStr = '[AC12]写审核信息失败！提示：' + @o_rntStr;
			RAISERROR(@o_rntStr, 16, 1);
		END
		
		delete from @temp_rec_ficn where m_id = @m_id
    END

    
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO


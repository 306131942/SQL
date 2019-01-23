USE [FIDB]
GO
--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_add_apacV2','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_apacV2 AS BEGIN SELECT 1; END');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-05-19
-- Description:	生成应付单并推送后续单据
-- Modify[1]:   luocg 2017-11-16 判断是否传入供应商的默认账户，没有时取供应商账户信息表中的最近一笔有效的账户
-- Modify[2]:   luocg 2018-07-17 申请人\部门\岗位、对方类型、对方代码、法人、币别、汇率、往来方类型\编码\名称，增加相应有效性校验
-- =========================================================================================
ALTER PROCEDURE rp_fi_add_apacV2 
(
	@i_nbr_type TINYINT					-- 单据类型 1:应付;2:其它应付;3:应收;4:其它应收.
	, @i_twf_code VARCHAR(20)			-- 流程code (原单据)
	, @i_paym_emp VARCHAR(20)			-- 申请人
	, @i_paym_dept VARCHAR(20)			-- 申请部门code
	, @i_paym_duty INT					-- 申请人岗位
	, @i_paym_due_date DATETIME			-- 应付日期
	, @i_paym_paycode_type TINYINT		-- 对方类型 1:供应商;2:个人;3:客户;5:其他;101:法人
	, @i_paym_pay_code VARCHAR(20)		-- 对方代码 
	, @i_paym_legal INT					-- 应收/应付法人 
	, @i_paym_currency VARCHAR(10)		-- 币别(必须是标准币别)
	, @i_paym_rate DECIMAL(19, 7)		-- 汇率
	, @i_paym_amt MONEY					-- 应付金额
	, @i_paym_pay_type TINYINT			-- 支付方式 1: 现金；2：转账
	, @i_paym_pay_bank VARCHAR(100)		-- 开户行(对方)
	, @i_paym_pay_name VARCHAR(100)		-- 开户名(对方)
	, @i_paym_pay_nbr VARCHAR(50)		-- 开户账号(对方)
    , @i_paym_admin_type INT			-- 往来方类型 1:供应商;2:个人;3:客户;4:部门; (都是4类型)
	, @i_paym_admin_dept VARCHAR(20)	-- 往来方编码（应收/应付部门编码）
	, @i_paym_admin_desc VARCHAR(200)	-- 往来方名称（应收/应付部门名称）
	, @i_paym_duty_emp VARCHAR(20)		-- 往来责任人 (没有的取申请人)
	, @i_paym_rmks VARCHAR(800)			-- 备注
	, @i_paym_ref_id INT				-- 关联单号id (原单据mid)
	, @i_paym_ref_did INT				-- 关联单号did (原单据did,整张单的0)
	, @i_paym_ref_nbr VARCHAR(20)		-- 关联单号 (原单据nbr)
	, @i_acctid INT						-- acctid
	, @o_paym_id INT OUTPUT				-- 返回应付单id
	, @o_paym_nbr VARCHAR(20) OUTPUT	-- 返回应付单号
	, @o_rntStr VARCHAR(800) OUTPUT		-- 返回执行结果
	, @i_paym_date DATETIME = NULL		-- 业务发生日期
	, @i_paym_pay_deptcode VARCHAR(20) = ''		-- 内部法人交易部门(对方部门)
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	/*
	-- 调试数据
	DECLARE @i_paym_emp VARCHAR(20);
	DECLARE @i_paym_dept VARCHAR(20);
	DECLARE @i_paym_duty INT;
	DECLARE @i_paym_due_date DATETIME;
	DECLARE @i_paym_paycode_type TINYINT;
	DECLARE @i_paym_pay_code VARCHAR(20);
	DECLARE @i_paym_legal INT;
	DECLARE @i_paym_currency VARCHAR(10);
	DECLARE @i_paym_rate DECIMAL(19, 7);
	DECLARE @i_paym_amt MONEY;
	DECLARE @i_paym_pay_type TINYINT;
	DECLARE @i_paym_pay_bank VARCHAR(100);
	DECLARE @i_paym_pay_name VARCHAR(100);
	DECLARE @i_paym_pay_nbr VARCHAR(50);
	DECLARE @i_paym_admin_type INT;
	DECLARE @i_paym_admin_dept VARCHAR(20);
	DECLARE @i_paym_admin_desc VARCHAR(20);
	DECLARE @i_paym_duty_emp VARCHAR(20);
	DECLARE @i_paym_obj_name VARCHAR(200);
	DECLARE @i_paym_rmks VARCHAR(200);
	DECLARE @i_paym_ref_id INT;
	DECLARE @i_paym_ref_nbr VARCHAR(20);
	DECLARE @i_acctid INT;
	DECLARE @o_paym_id INT;
	DECLARE @o_paym_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @i_paym_emp = '00000001';
	SET @i_paym_dept = '012213';
	SET @i_paym_duty = 10026;
	SET @i_paym_due_date = '2013-8-30';
	SET @i_paym_paycode_type = 2;
	SET @i_paym_pay_code = '00000001';
	SET @i_paym_legal = -2;
	SET @i_paym_currency = 'RMB';
	SET @i_paym_rate = 1.0;
	SET @i_paym_amt = 1000.0;
	SET @i_paym_pay_type = 0;
	SET @i_paym_pay_bank = '';
	SET @i_paym_pay_name = '';
	SET @i_paym_pay_nbr = '';
	SET @i_paym_admin_type = 4;
	SET @i_paym_admin_dept = '012213';
	SET @i_paym_admin_desc = '航嘉源投资';
	SET @i_paym_duty_emp = '00000001';
	SET @i_paym_rmks = '业务费用报销单';
	SET @i_paym_ref_id = 151;
	SET @i_paym_ref_nbr = 'AC11-12030001';
	SET @i_acctid = 1;
	*/
	
	SET @o_rntStr = 'OK';
	
	DECLARE @spl_name VARCHAR(200);			-- 对方名称
	DECLARE @i_paym_typm_id INT				-- 应付类型mid
	DECLARE @i_paym_typd_id INT				-- 应付类型did
	DECLARE @acctid_ctl INT;				-- 是否启用ACCTID
	DECLARE @i_paym_flag INT;				-- 蓝/红标记
	DECLARE @i_paym_item INT;				-- 收付类型
	DECLARE @o_rntStr1 VARCHAR(2000)='';  	-- 校验结果                        				
	                         				

	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	SET @i_paym_date = (CASE WHEN ISNULL(@i_paym_date, GETDATE()) > @i_paym_due_date AND @i_paym_due_date IS NOT NULL THEN @i_paym_due_date  ELSE ISNULL(@i_paym_date, GETDATE()) END)
	SET @i_paym_amt = Convert(decimal(18,2),@i_paym_amt)--保留两位小数处理
	                                                    
	------------------------------------增加校验,存入fidb.dbo.tfi_ap_log
	--申请人\部门\岗位
	IF (isnull(@i_paym_emp,'') = '' OR isnull(@i_paym_dept,'') = '' OR  isnull(@i_paym_duty,0) = 0)
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '申请人信息为空(paym_emp、paym_dept、paym_duty)。';
	END
	IF (isnull(@i_paym_paycode_type,0) = 0 OR NOT EXISTS(SELECT 1 FROM hportal.dbo.tba_code WHERE code_type='ap_paycodetype' AND code_value=@i_paym_paycode_type))
	BEGIN
		SET @o_rntStr1 = @o_rntStr1 + '对方类型为空或不属于系统内设置的类型(paym_paycode_type)。';
	END
	IF (isnull(@i_paym_pay_code,'') = '')
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '对方代码为空(paym_pay_code)。';
	END
	IF (isnull(@i_paym_legal,0) = 0 OR NOT EXISTS(SELECT 1 FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id = @i_paym_legal ))
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '应付/应收法人为空或不属于系统内的法人(paym_legal)。';
	END
	IF (isnull(@i_paym_currency,'') = '' OR ISNULL((SELECT TOP(1) curr_flag  FROM fidb.dbo.v_fi_currency WHERE curr_code=@i_paym_currency ),0)=0)
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '币别为空或者不是标准币别(paym_currency)。';
	END
	IF (isnull(@i_paym_rate,0) = 0)
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '汇率为空(paym_rate)。';
	END
	--往来方类型\编码\名称
	IF (isnull(@i_paym_admin_type,0) <> 4 OR isnull(@i_paym_admin_dept,'') = '' OR isnull(@i_paym_admin_desc,'') = '' )
	BEGIN 
		SET @o_rntStr1 = @o_rntStr1 + '往来方类型必须部门(paym_admin_type=4)或编码/名称为空(paym_admin_dept、paym_admin_desc)。';
	END
	
		
	IF (@i_paym_ref_id = 0 OR @i_paym_ref_id IS NULL OR @i_paym_ref_nbr = '' OR @i_paym_ref_nbr IS NULL)
	BEGIN -- 关联单据为空
		SET @o_rntStr = '关联单据为空，不能生成应付/应收单！';
	END
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  
	                WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id AND ISNULL(paym_ref_did,0) = ISNULL(@i_paym_ref_did,0)
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal = @i_paym_legal AND isenable = 0 
					AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0) AND @i_paym_paycode_type <> 101 
	BEGIN
		SET @o_rntStr = '已经存在历史推送数据且数据已经被修改过！';
	END
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  
	                WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id AND ISNULL(paym_ref_did,0) = ISNULL(@i_paym_ref_did,0)
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal = @i_paym_legal AND isenable = 1 
					AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0) AND @i_paym_paycode_type <> 101 --AND @i_twf_code ='AD06'
	BEGIN
		SELECT @o_paym_id = paym_id, @o_paym_nbr = paym_nbr
		FROM dbo.tfi_pay_m
		WHERE paym_ref_id = @i_paym_ref_id AND paym_ref_did = @i_paym_ref_did AND paym_ref_nbr = @i_paym_ref_nbr AND paym_nbr_flag = @i_nbr_type
			  AND paym_legal = @i_paym_legal AND isenable = 1 AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0 AND @i_paym_paycode_type <> 101
		
		UPDATE dbo.tfi_pay_m SET paym_amt = @i_paym_amt, paym_nbr_amt = @i_paym_amt
		WHERE paym_ref_id = @i_paym_ref_id AND paym_ref_did = @i_paym_ref_did AND paym_ref_nbr = @i_paym_ref_nbr AND paym_nbr_flag = @i_nbr_type
			  AND paym_legal = @i_paym_legal AND isenable = 1 AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0 AND @i_paym_paycode_type <> 101
	END
	-- 法人应收应付(同单据同法人同部门间的数据累加)
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  
	                WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id --AND ISNULL(paym_ref_did,0) = ISNULL(@i_paym_ref_did,0)
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal = @i_paym_legal AND paym_currency = @i_paym_currency
					AND paym_admin_dept = @i_paym_admin_dept AND paym_pay_deptcode = @i_paym_pay_deptcode 
					AND paym_pay_code = @i_paym_pay_code AND isenable = 1 AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0
				   ) AND @i_paym_paycode_type = 101
	BEGIN
		SELECT @o_paym_id = paym_id, @o_paym_nbr = paym_nbr
		FROM dbo.tfi_pay_m
		WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal = @i_paym_legal 
		      AND paym_currency = @i_paym_currency AND paym_admin_dept = @i_paym_admin_dept AND paym_pay_deptcode = @i_paym_pay_deptcode
			  AND paym_pay_code = @i_paym_pay_code AND isenable = 1 AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0

		UPDATE dbo.tfi_pay_m SET paym_amt = paym_amt + @i_paym_amt, paym_ref_did = 0, paym_nbr_amt = paym_amt + @i_paym_amt
		WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal = @i_paym_legal 
		      AND paym_currency = @i_paym_currency AND paym_admin_dept = @i_paym_admin_dept AND paym_pay_deptcode = @i_paym_pay_deptcode
			  AND paym_pay_code = @i_paym_pay_code AND isenable = 1 AND DATEDIFF(DAY, paym_date, @i_paym_date) = 0
	END
	-- 防止非法人单据重复推送
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  
	                WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id AND ISNULL(paym_ref_did,0) = ISNULL(@i_paym_ref_did,0)
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal=@i_paym_legal AND paym_currency = @i_paym_currency) AND @i_paym_paycode_type <> 101
	BEGIN -- 已存在应付单，不再生成应付单
		SET @o_rntStr = @i_paym_ref_nbr + '已存在应付/应收单！';
	END
	-- 提示没有设置财务参数
	ELSE IF NOT EXISTS(SELECT 1
						FROM FIDB.dbo.tfi_type_d ttd 
						INNER JOIN FIDB.dbo.tfi_type_m ttm ON ttm.typm_id=ttd.typd_typm_id AND ttm.isenable = 1
						WHERE ttd.typd_wfm_code = @i_twf_code AND ttd.acctid = (CASE WHEN @acctid_ctl = 1 THEN @i_acctid ELSE ttd.acctid END)
						AND ttm.typm_attribute = (CASE WHEN (@i_nbr_type = 1 OR @i_nbr_type = 2) THEN 1 ELSE 2 END))
    BEGIN
    	SET @o_rntStr = '请先在应收应付系统设置该编码('+ @i_twf_code +')单据的应收/应付类型！';
    	SET @o_paym_id = 0;
    	SET @o_paym_nbr = '';
    END
	ELSE
	BEGIN -- 生成应付单
	    --判断是否传入供应商的默认账户，没有时取供应商账户信息：有效的，默认的顺序排序
	    IF( @i_paym_paycode_type = 1 AND (@i_paym_pay_bank = '' OR @i_paym_pay_name = '' OR @i_paym_pay_nbr= '') )
	    BEGIN
			SELECT TOP 1 @i_paym_pay_bank = fsa.pay_spat_bank, @i_paym_pay_name = fsa.pay_spat_name, @i_paym_pay_nbr= fsa.pay_spat_account
			FROM fidb.dbo.v_fi_spl_account fsa
			WHERE fsa.pay_spl_code = @i_paym_pay_code AND fsa.pay_spat_currency = @i_paym_currency 
			ORDER BY (CASE WHEN ISNULL(pay_spat_enddate,'9999-12-31')>=GETDATE() THEN 1 ELSE 0 END ) DESC, pay_spat_default DESC--有效的，默认的顺序排序
		END
	     
	    SELECT @i_paym_typm_id = ttd.typd_typm_id, @i_paym_typd_id = ttd.typd_id
	    FROM FIDB.dbo.tfi_type_d ttd 
		INNER JOIN FIDB.dbo.tfi_type_m ttm ON ttm.typm_id=ttd.typd_typm_id AND ttm.isenable = 1
	    WHERE ttd.typd_wfm_code = @i_twf_code AND ttd.acctid = (CASE WHEN @acctid_ctl = 1 THEN @i_acctid ELSE ttd.acctid END)
	    AND ttm.typm_attribute = (CASE WHEN (@i_nbr_type = 1 OR @i_nbr_type = 2) THEN 1 ELSE 2 END)
	    
		SET @i_paym_flag = (CASE WHEN @i_paym_amt < 0 THEN 2 ELSE 1 END);
		SELECT @spl_name = pay_fname FROM v_fi_paycode_info WHERE ctype = @i_paym_paycode_type AND pay_code = @i_paym_pay_code;
		SET @i_paym_item = (CASE WHEN (@i_nbr_type = 1 OR @i_nbr_type = 2) THEN '1' ELSE '3' END);
	
	
		INSERT INTO tfi_pay_m ( -- 插入主表begin
			paym_nbr, paym_item, paym_typm_id, paym_typd_id, paym_flag
			, paym_emp, paym_dept, paym_duty, paym_date, paym_due_date
			, paym_paycode_type, paym_pay_code, paym_spl_name, paym_legal
			, paym_currency, paym_rate, paym_amt,paym_nbr_amt, paym_real_amt
			, paym_pay_type, paym_pay_bank, paym_pay_name, paym_pay_nbr
			, paym_admin_type, paym_admin_dept, paym_admin_desc, paym_duty_emp, paym_rmks
			, paym_status, paym_ref_nbr, paym_ref_id, paym_ref_did, adduser, acctid, paym_nbr_flag, paym_pay_deptcode
		) 
		VALUES 
		(
			@i_paym_ref_nbr, @i_paym_item, @i_paym_typm_id, @i_paym_typd_id, @i_paym_flag
			, @i_paym_emp, @i_paym_dept, @i_paym_duty, @i_paym_date, @i_paym_due_date
			, @i_paym_paycode_type, @i_paym_pay_code, @spl_name, @i_paym_legal
			, @i_paym_currency, @i_paym_rate, @i_paym_amt,@i_paym_amt, 0
			, @i_paym_pay_type, @i_paym_pay_bank, @i_paym_pay_name, @i_paym_pay_nbr
			, @i_paym_admin_type, @i_paym_admin_dept, @i_paym_admin_desc, @i_paym_duty_emp, @i_paym_rmks
			, (CASE WHEN (@i_nbr_type = 1 OR @i_nbr_type = 2) THEN 5 ELSE 9 END), @i_paym_ref_nbr, @i_paym_ref_id, @i_paym_ref_did, @i_paym_emp, @i_acctid, @i_nbr_type, @i_paym_pay_deptcode
		);
		SET @o_paym_id = @@identity; -- 插入主表end
		SET @o_paym_nbr = @i_paym_ref_nbr;
		
		UPDATE tpm SET paym_status = (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 7 ELSE 11 END), isenable = 0
		FROM FIDB.dbo.tfi_pay_m tpm
		WHERE tpm.paym_id = @o_paym_id AND tpm.paym_amt = 0 AND (tpm.paym_nbr LIKE 'AR07%' OR tpm.paym_nbr LIKE 'AP07%' OR tpm.paym_nbr LIKE 'SA47%')
		
		
		--上面的校验写入日志表
		IF(@o_rntStr1<>'')
		BEGIN 
			INSERT INTO fidb.dbo.tfi_ap_log(aplg_code, aplg_m, aplg_d, aplg_a,aplg_rmks, isenable, addtime, adduser, modtime, moduser,acctid)
			VALUES(@i_paym_ref_nbr
			, cast(@i_paym_ref_id AS VARCHAR(40))
			, cast(@i_paym_ref_did AS VARCHAR(40))
			, cast(@o_paym_id AS VARCHAR(40))
			,@o_rntStr1,1,GETDATE(),@i_paym_emp,GETDATE(),@i_paym_emp,@i_acctid)	
		END
		
		IF(@i_paym_paycode_type <> '101' OR @i_twf_code = 'AP11'  OR @i_twf_code = 'AC15' OR @i_twf_code = 'AP06' OR @i_twf_code = 'AR06' OR @i_twf_code = 'FA07')
		BEGIN
			EXEC rp_fi_add_nextbill @i_mid = @o_paym_id, @i_nbr = @i_paym_ref_nbr, @i_twf_code=@i_twf_code, @o_rntStr = @o_rntStr OUTPUT;
		END
		
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
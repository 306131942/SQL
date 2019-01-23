USE FIDB
GO
--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_claim_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_claim_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		刘蔚
-- Create date: 2013-10-22
-- Description:	品质索赔单审核通过后生成应付单、或者应收单
-- Modify[1]:   2013-11-22 刘蔚 调整索赔单推送的应收单的币别与料号的交易币别一致
-- Modify[2]:	调整索赔单传应收的币别获取逻辑 by liuxiang at 2015-01-14
-- Modify[3]:	索赔金额不再转换为人民币,将原金额和币别保存 by fengxd at 2017-08-26
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_claim_to_pay]
(
	@i_mid INT
	, @o_paym_id INT = 0 OUTPUT				-- 返回应付单id
	, @o_paym_nbr VARCHAR(20) = '' OUTPUT	-- 返回应付单号
	, @o_rntStr VARCHAR(800) = '' OUTPUT	-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	
	DECLARE @paym_item VARCHAR(20);			-- 会计科目
	DECLARE @paym_typm_id INT;				-- 应付类型mid
	DECLARE @paym_typd_id INT;				-- 应付类型did
	DECLARE @paym_flag TINYINT;				-- 1蓝字2红字
	DECLARE @paym_emp VARCHAR(20);			-- 申请人
	DECLARE @paym_dept VARCHAR(20);			-- 申请部门code
	DECLARE @paym_duty INT;					-- 申请人岗位
	DECLARE @paym_due_date DATETIME;		-- 应付日期
	DECLARE @paym_paycode_type TINYINT;		-- 对方类型 1供应商2个人
	DECLARE @paym_pay_code VARCHAR(20);		-- 对方代码
	DECLARE @paym_legal INT;				-- 应付法人
	DECLARE @paym_legal2 INT;				-- 应付法人
	DECLARE @paym_currency VARCHAR(10);		-- 币别
	DECLARE @paym_rate DECIMAL(19, 7);		-- 汇率
	DECLARE @paym_amt MONEY;				-- 应付金额
	DECLARE @paym_pay_type TINYINT;			-- 支付方式
	DECLARE @paym_pay_bank VARCHAR(100);	-- 开户行
	DECLARE @paym_pay_name VARCHAR(100);	-- 开户名
	DECLARE @paym_pay_nbr VARCHAR(50);		-- 开户账号
	DECLARE @paym_duty_emp VARCHAR(20);		-- 责任人
	DECLARE @paym_rmks VARCHAR(200);		-- 备注
	DECLARE @paym_ref_id INT;				-- 关联单号id
	DECLARE @paym_ref_nbr VARCHAR(20);		-- 关联单号
	DECLARE @acctid INT;					-- acctid
	DECLARE @cc_level VARCHAR(100);
	DECLARE @twf_code VARCHAR(100);
	DECLARE @paym_admin_dept VARCHAR(20);	-- 往来方编码 
	DECLARE @paym_dept_desc VARCHAR(100);	-- 往来方名称
	
	SET @o_rntStr = 'OK';
	
	SELECT @paym_currency=tcm.clam_curr,@acctid=tcm.acctid,@paym_legal2=ISNULL(vc.ficn_id,-2)
	FROM HQIS.dbo.TQA_CLAIM_M tcm
	LEFT JOIN FIDB.dbo.VFI_CORPORATION vc ON vc.ficn_code = tcm.clam_legal
	WHERE tcm.CLAM_ID=@i_mid 
	
	SET @paym_rate=hportal.dbo.rf_ba_getrate(@acctid, ISNULL(@paym_currency,'RMB'),'RMB',GETDATE())
	
	SELECT  @twf_code = LEFT(tcm.clam_nbr, 4)
		, @paym_flag = 1
		, @paym_emp = tcm.CLAM_APPLY_EMP_ID
		, @paym_due_date = CONVERT(VARCHAR(10), DATEADD(DAY, 2, GETDATE()), 23)
		, @paym_paycode_type = CASE WHEN tcm.clam_aplay_type=2 THEN 5 ELSE 1 END
		, @paym_pay_code = tcm.clam_vend
		, @paym_legal =  CASE WHEN isnull(@paym_legal2,-2)=-2 THEN  ISNULL(vc.ficn_id,-2) ELSE @paym_legal2 END
		, @paym_currency = ISNULL(@paym_currency,'RMB') --通过料号采购报价表有效的报价，取报价的币别，若没有则取RMB
		, @paym_rate =@paym_rate
		, @paym_amt =( SELECT SUM(clad_sum) FROM hqis.dbo.tqa_claim_d tcd WHERE tcd.CLAD_CLAM_ID=tcm.CLAM_ID)
		, @paym_pay_type = 2 --默认为现金
		, @paym_pay_bank = tcm.clam_pay_bank
		, @paym_pay_name = tcm.clam_pay_name
		, @paym_pay_nbr = tcm.clam_pay_nbr
		, @paym_duty_emp = tcm.CLAM_APPLY_EMP_ID
		, @paym_rmks = tcm.clam_desc
		, @paym_ref_nbr = tcm.CLAM_NBR
		, @paym_ref_id = tcm.CLAM_ID
		, @acctid = tcm.ACCTID
	FROM HQIS.dbo.TQA_CLAIM_M tcm
	LEFT JOIN HPUR.dbo.TPU_SUPPLIER ts ON ts.SPL_CODE = tcm.CLAM_VEND
	LEFT JOIN FIDB.dbo.VFI_CORPORATION vc ON vc.ficn_code = ts.SPL_ACCT_CORPORATION
	WHERE tcm.CLAM_ID = @i_mid
	
	SELECT @paym_dept = emp.cc_code, @paym_dept_desc = emp.cc_desc, @paym_duty = emp.bz_id
	FROM hr90.dbo.v_emp_mstr emp 
	WHERE emp_id=@paym_emp
	
	SELECT @paym_admin_dept = vd.dept_code, @paym_dept_desc = vd.dept_name
	FROM HQIS.dbo.tqa_claim_m tcm 
	left join HR90.dbo.v_dept vd ON vd.dept_code=tcm.clam_spl_dept AND vd.dept_enable = 1
	WHERE tcm.CLAM_ID = @i_mid ;
	

	-- 如果申请人离职，取部门第一负责人
	IF(NOT EXISTS(SELECT emp_id FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @paym_emp))
	BEGIN
		SELECT @cc_level = cm.cc_level FROM HR90.dbo.cc_mstr1 cm WHERE cm.cc_code = @paym_dept;
		SELECT @paym_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@cc_level,'','','',1);
	END
	
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--生成应付单
		EXEC FIDB.dbo.rp_fi_add_apacV2
			4
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
			, 4
			, @paym_admin_dept
			, @paym_dept_desc
			, @paym_duty_emp
			, @paym_rmks
			, @paym_ref_id
			, 0
			, @paym_ref_nbr
			, @acctid
			, @o_paym_id OUTPUT
			, @o_paym_nbr OUTPUT
			, @o_rntStr OUTPUT;
	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成应付单！';
	END
	IF @o_rntStr <> 'OK'
	BEGIN
		RAISERROR (@o_rntStr, 16, 1); 
	END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
GO
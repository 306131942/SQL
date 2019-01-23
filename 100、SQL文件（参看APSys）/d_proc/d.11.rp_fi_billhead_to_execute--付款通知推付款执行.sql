USE FIDB
GO

IF(OBJECT_ID('rp_fi_billhead_to_execute','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_billhead_to_execute AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================
-- Author:		刘蔚
-- Create date: 2013-10-08
-- Description:	查询预付通知单或者付款通知单生成付款执行单
-- Modify[1]:   2013-12-05 刘蔚 修改流程审核自动通过时,取a表的单号,备注中前置单号的说明
-- modfiy[2]: 推执行单时，增加币别、汇率的写入 by zhoupan at 2015-11-26
-- modfiy[3]: 手动批量推执行单时存入的申请人信息为登入人信息，luocg at 2017-03-14
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_billhead_to_execute]
(
	@i_mid INT
	,@i_exem_emp  VARCHAR(20)			--申请人
	, @o_exem_nbr VARCHAR(20) = '' OUTPUT	-- 返回付款单号
	, @o_exem_id INT = 0 OUTPUT				-- 返回付款单id
	, @o_rntStr VARCHAR(800) = '' OUTPUT	-- 返回执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 12;
	
	DECLARE @exem_emp  VARCHAR(20);         --申请人
	DECLARE @exem_dept VARCHAR(20);         --申请部门
	DECLARE @exem_duty INT;					--申请岗位
	DECLARE @exem_date DATETIME;            --申请日期
	DECLARE @exem_legal INT ;				--法人
	DECLARE @exem_pay_amt MONEY ;			--付款通知金额
	DECLARE @exem_amt     MONEY;			--付款执行金额
	DECLARE @exem_curr VARCHAR(3);			--执行币别
	DECLARE @exem_rate DECIMAL(19,7);		--执行汇率
	DECLARE @exem_rmks VARCHAR(800);        --备注
	DECLARE @exem_ref_mid INT;				--前置单id
	DECLARE @exem_ref_nbr VARCHAR(20);      --前置单号
	DECLARE @exem_pay_date DATETIME;		--付款日期
	DECLARE @acctid INT ;
	
	SET @o_rntStr = 'OK';
	
	SELECT
		@exem_emp = abhm_emp,
		@exem_dept = abhm_dept,
		@exem_duty = abhm_duty,
		@exem_date = modtime,
		@exem_legal = abhm_legal,
		--select code_value,code_name from tba_code where code_type='ap_audit_status'
		--@exem_pay_amt = abhm_pay_amt-(SELECT SUM(tem.exem_amt) FROM FIDB.dbo.tfi_execute_m tem WHERE (tem.exem_status = 6 OR tem.exem_status = 7) AND tem.exem_ref_mid = tbm.abhm_id AND tem.exem_ref_nbr = tbm.abhm_nbr),
		--@exem_amt = abhm_pay_amt-(SELECT SUM(tem.exem_amt) FROM FIDB.dbo.tfi_execute_m tem WHERE (tem.exem_status = 6 OR tem.exem_status = 7)  AND tem.exem_ref_mid = tbm.abhm_id AND tem.exem_ref_nbr = tbm.abhm_nbr),
		@exem_pay_amt = abhm_pay_amt - ISNULL((SELECT SUM(CONVERT(DECIMAL(19,2), tem.exem_amt/tem.exem_rate)) FROM FIDB.dbo.tfi_execute_m tem WHERE tem.exem_status <> 8 AND tem.exem_ref_mid = tbm.abhm_id AND tem.exem_ref_nbr = tbm.abhm_nbr), 0),
		@exem_amt = abhm_pay_amt - ISNULL((SELECT SUM(CONVERT(DECIMAL(19,2), tem.exem_amt/tem.exem_rate)) FROM FIDB.dbo.tfi_execute_m tem WHERE tem.exem_status <> 8 AND tem.exem_ref_mid = tbm.abhm_id AND tem.exem_ref_nbr = tbm.abhm_nbr), 0),
		@exem_curr = abhm_currency,
		@exem_rate = 1.00,
		@exem_rmks = (CASE
			WHEN tbm.abhm_type = 1 THEN CAST(ISNULL(STUFF((SELECT ';业务单号:' + tpm.paym_ref_nbr + ' 金额:' + CAST(tpm.paym_amt AS VARCHAR(20)) + paym_currency
									FROM fidb.dbo.tfi_billhead_d tbd INNER JOIN fidb.dbo.tfi_pay_m tpm ON tbd.abhd_m_id = tpm.paym_id  WHERE abhd_abhm_id = tbm.abhm_id
									FOR XML PATH('')), 1, 1, ''), '') AS VARCHAR(8000))
			ELSE '业务单号:' + (SELECT TOP 1 vpr.nbr FROM FIDB.dbo.v_fi_prepay_refnbr vpr WHERE tbm.abhm_ref_id = vpr.mid AND tbm.abhm_ref_type = vpr.reftype)
				+ '预付金额:' + CAST(tbm.abhm_pay_amt AS VARCHAR(20)) + tbm.abhm_currency
			END) + ' 备注:' + abhm_rmks,
		@exem_ref_mid = abhm_id,
		@exem_ref_nbr = (SELECT TOP 1 wfna_nbr FROM fidb.dbo.tfi_billhead_a WHERE wfna_m_id=tbm.abhm_id),
		@exem_pay_date = abhm_pay_date,
		@acctid = tbm.acctid
	FROM fidb.dbo.tfi_billhead_m tbm
	WHERE tbm.abhm_id = @i_mid;
	
	--手动批量生成执行单时，申请人的id,部门id,岗位id设置为登入人的任职相关信息
	--改成同一取前置单的申请人，部门，岗位   （2018-06-04）
	--IF(@i_exem_emp <> '')
	--BEGIN
	--	SET @exem_emp = @i_exem_emp
	--	SET @exem_duty = (SELECT  duty_id FROM FIDB.dbo.v_fi_dutyall  WHERE emp_id = @exem_emp AND de_type_name='任职')
	--	SET @exem_dept = (SELECT  cc_code FROM FIDB.dbo.v_fi_dutyall  WHERE emp_id = @exem_emp AND de_type_name='任职')
	--END
	
	IF (@exem_ref_mid IS NOT NULL)
	BEGIN
		EXEC rp_fi_add_execute
			@i_exem_emp = @exem_emp,
			@i_exem_dept = @exem_dept,
			@i_exem_duty = @exem_duty,
			@i_exem_date = @exem_date,
			@i_exem_legal = @exem_legal,
			@i_exem_pay_amt = @exem_pay_amt,
			@i_exem_amt = @exem_amt,
			@i_exem_curr = @exem_curr,
			@i_exem_rate = @exem_rate,
			@i_exem_rmks = @exem_rmks,
			@i_exem_ref_mid = @exem_ref_mid,
			@i_exem_ref_nbr = @exem_ref_nbr,
			@i_exem_pay_date = @exem_pay_date,
			@i_acctid = @acctid,
			@o_exem_nbr = @o_exem_nbr OUTPUT,
			@o_exem_id = @o_exem_id OUTPUT,
			@o_rntStr = @o_rntStr OUTPUT;
	END
	ELSE
	BEGIN
		SET @o_rntStr = '无法生成付款执行单';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH


USE FIDB
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_qi_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_qi_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2014-12-10
-- Description:	�ͻ��������ͨ��������Ӧ����
-- =========================================================================================
ALTER PROCEDURE rp_fi_qi_to_pay
(
	@i_mid INT
	, @o_paym_id INT = 0 OUTPUT				-- ����Ӧ����id
	, @o_paym_nbr VARCHAR(20) = '' OUTPUT	-- ����Ӧ������
	, @o_rntStr VARCHAR(800) = '' OUTPUT	-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	
	DECLARE @paym_item VARCHAR(20);			-- ��ƿ�Ŀ
	DECLARE @paym_typm_id INT;				-- Ӧ������mid
	DECLARE @paym_typd_id INT;				-- Ӧ������did
	DECLARE @paym_flag TINYINT;				-- 1����2����
	DECLARE @paym_emp VARCHAR(20);			-- ������
	DECLARE @paym_dept VARCHAR(20);			-- ���벿��code
	DECLARE @paym_duty INT;					-- �����˸�λ
	DECLARE @paym_due_date DATETIME;		-- Ӧ������
	DECLARE @paym_date DATETIME;			-- ҵ��������
	DECLARE @paym_paycode_type TINYINT;		-- �Է����� 1��Ӧ��2����
	DECLARE @paym_pay_code VARCHAR(20);		-- �Է�����
	DECLARE @paym_legal INT;				-- Ӧ������
	DECLARE @paym_currency VARCHAR(10);		-- �ұ�
	DECLARE @paym_rate DECIMAL(19, 7);		-- ����
	DECLARE @paym_amt MONEY;				-- Ӧ�����
	DECLARE @paym_pay_type TINYINT;			-- ֧����ʽ
	DECLARE @paym_pay_bank VARCHAR(100);	-- ������
	DECLARE @paym_pay_name VARCHAR(100);	-- ������
	DECLARE @paym_pay_nbr VARCHAR(50);		-- �����˺�
	DECLARE @paym_admin_dept VARCHAR(20);	-- ���β���
	DECLARE @paym_duty_emp VARCHAR(20);		-- ������
	DECLARE @paym_rmks VARCHAR(200);		-- ��ע
	DECLARE @paym_ref_id INT;				-- ��������id
	DECLARE @paym_ref_nbr VARCHAR(20);		-- ��������
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- �Ƿ�����ACCTID
	DECLARE @twf_code VARCHAR(20);
	DECLARE @paym_dept_desc VARCHAR(100);	-- ���۲�������
	
	SET @o_rntStr = 'OK';
	
	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	SELECT -- ���ò���
		@twf_code = LEFT(comm.comm_nbr, 4)
		, @paym_flag = 1
		, @paym_emp = comm.comm_emp
		, @paym_dept = comm.comm_dept
		, @paym_dept_desc = dept.cc_desc
		, @paym_duty = comm.comm_duty
		, @paym_due_date = comm.comm_deduct_date
		, @paym_date = CONVERT(VARCHAR(10),GETDATE(),120)
		, @paym_paycode_type = 3
		, @paym_pay_code = comm.comm_cust
		, @paym_legal = legal.ficn_id
		, @paym_currency = comm.comm_curr
		, @paym_rate = hportal.dbo.rf_ba_getRate(comm.acctid,comm.comm_curr, 'RMB', GETDATE())
		, @paym_amt = ISNULL(comm.comm_amt,0)
		, @paym_pay_type = 1
		, @paym_pay_bank = ''
		, @paym_pay_name = ''
		, @paym_pay_nbr = ''
		, @paym_admin_dept = comm.comm_cust_dept
		, @paym_duty_emp = comm.comm_emp
		, @paym_rmks = comm.comm_desc
		, @paym_ref_nbr = comm.comm_nbr
		, @paym_ref_id = comm.comm_id
		, @acctid = comm.acctid
	FROM HQIS.dbo.tqa_compensate_m comm
	INNER JOIN HSAL.dbo.v_sa_customer cust ON cust.CUST_CODE=comm.comm_cust
	LEFT JOIN FIDB.dbo.VFI_CORPORATION legal ON legal.ficn_code=cust.CTFN_RECV_ACCT
	LEFT JOIN HR90.dbo.cc_mstr1 dept ON dept.cc_code = comm.comm_cust_dept
	WHERE comm.comm_id = @i_mid;
				
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--����Ӧ����
		IF (@paym_amt <> 0)
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2
				1
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
				, 4					-- 4������
				, @paym_admin_dept	-- ���۲���
				, @paym_dept_desc	-- ���۲�������
				, @paym_duty_emp
				, @paym_rmks
				, @paym_ref_id
				, 0
				, @paym_ref_nbr
				, @acctid
				, @o_paym_id OUTPUT
				, @o_paym_nbr OUTPUT
				, @o_rntStr OUTPUT
				, @paym_date
		END
	END
	ELSE
	BEGIN
		SET @o_rntStr = '�޷�����Ӧ������';
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
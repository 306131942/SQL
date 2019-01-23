USE [FIDB]
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_other_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_other_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-07-04
-- Description:	����Ӧ�պ�����Ӧ�������ͨ��������Ӧ����
-- Modify[1]:

-- =========================================================================================
ALTER PROCEDURE rp_fi_other_to_pay
(
	@i_mid INT
	, @i_twf_code VARCHAR(20)				-- ���̱���
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	DECLARE @paym_emp VARCHAR(20);			-- ������
	DECLARE @paym_dept VARCHAR(20);			-- ���벿��code
	DECLARE @paym_duty INT;					-- �����˸�λ
	DECLARE @paym_date DATETIME;		-- ��������
	DECLARE @paym_due_date DATETIME;		-- Ӧ������
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
	DECLARE @paym_admin_type INT;			-- ����������
	DECLARE @paym_admin_dept VARCHAR(20);	-- ����������
	DECLARE @paym_admin_desc VARCHAR(200);	-- ����������
	DECLARE @paym_duty_emp VARCHAR(20);		-- ����������
	DECLARE @paym_rmks VARCHAR(800);		-- ��ע
	DECLARE @paym_ref_id INT;				-- ��������id
	DECLARE @paym_ref_did INT;
	DECLARE @paym_ref_nbr VARCHAR(20);		-- ��������
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- �Ƿ�����ACCTID
	DECLARE @o_paym_id INT;
	DECLARE @o_paym_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @o_rntStr = 'OK';
	
	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;
	SELECT -- ���ò���
		@paym_emp = tpom.paym_emp
		, @paym_dept = tpom.paym_dept
		, @paym_duty = tpom.paym_duty
		, @paym_date = tpom.paym_date 
		, @paym_due_date = tpom.paym_due_date  
		, @paym_paycode_type = tpom.paym_paycode_type
		, @paym_pay_code = tpom.paym_pay_code
		, @paym_legal = tpom.paym_legal
		, @paym_currency = tpom.paym_currency
		, @paym_rate = HPORTAL.dbo.rf_ba_getrate(1,tpom.paym_currency,'rmb',GETDATE())
		, @paym_amt = tpom.paym_amt
		--AR06 ���㷽ʽ0Ϊ�տֱ�����տ�֪ͨ�����տʽ2ת�ˣ�paym_pay_typeҳ��Ĭ�ϱ����Ϊ2��
		--AP06 ���㷽ʽ1Ϊ֧����ֱ���Ƹ���֪ͨ�������ʽ2ת�ˣ�paym_pay_typeҳ��Ĭ�ϱ����Ϊ2��
		, @paym_pay_type = tpom.paym_pay_type
		, @paym_pay_bank = tpom.paym_pay_bank 
		, @paym_pay_name = tpom.paym_pay_name 
		, @paym_pay_nbr = tpom.paym_pay_nbr
		, @paym_admin_type = 4
		, @paym_admin_dept = tpom.paym_admin_dept
		, @paym_admin_desc = dept.cc_desc
		, @paym_duty_emp = tpom.paym_duty_emp
		, @paym_rmks = tpom.paym_rmks
		, @paym_ref_nbr = tpa.wfna_nbr
		, @paym_ref_id = tpom.paym_id
		, @paym_ref_did = 0
		, @acctid = tpom.acctid
	FROM FIDB.dbo.tfi_pay_other_m tpom
	LEFT JOIN FIDB.dbo.tfi_pay_a tpa ON tpom.paym_id=tpa.wfna_m_id
	LEFT JOIN FIDB.dbo.v_fi_dept dept ON dept.cc_code = tpom.paym_admin_dept
	WHERE tpom.paym_id = @i_mid;
	
	--��������Ӧ��Ӧ���Ļ���
	UPDATE FIDB.dbo.tfi_pay_other_m SET paym_rate = HPORTAL.dbo.rf_ba_getrate(1,paym_currency,'rmb',GETDATE()) where paym_id = @i_mid;
				
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--����Ӧ����
		IF (@paym_amt <> 0 AND @i_twf_code = 'AP06')
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2
				2
				, @i_twf_code
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
				, @o_rntStr OUTPUT
				, @paym_date;
		END
		ELSE IF((@paym_amt <> 0 AND @i_twf_code = 'AR06'))
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2
				4
				, @i_twf_code
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
				, @o_rntStr OUTPUT
				, @paym_date;
		END
	END
	ELSE
	BEGIN 
		SET @o_rntStr = '�޷�����Ӧ��Ӧ�����ݣ�';
	END
	IF(@o_rntStr <> 'OK')
	BEGIN
		RAISERROR(@o_rntStr, 16, 1);
	END
	
END TRY
BEGIN CATCH
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
	
END CATCH

GO
USE [FIDB]
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_accm_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_accm_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2013-06-06
-- Description:	�������˺�׼�����ͨ��������Ӧ����
-- =========================================================================================
ALTER PROCEDURE rp_fi_accm_to_pay
(
	@i_mid INT
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_mid INT;
	--SET @i_mid = 13244;
	DECLARE @o_paym_id INT = 0 				-- ����Ӧ����id
	DECLARE @o_paym_nbr VARCHAR(20) = '' 	-- ����Ӧ������
	DECLARE @o_rntStr VARCHAR(800) = 'OK' 	-- ����ִ�н��
	                                    	-- 
	DECLARE @twf_code VARCHAR(20);			-- ����code
	DECLARE @paym_emp VARCHAR(20);			-- ������
	DECLARE @paym_dept VARCHAR(20);			-- ���벿��code
	DECLARE @paym_duty INT;					-- �����˸�λ
	DECLARE @paym_due_date DATETIME;		-- Ӧ������
	DECLARE @paym_date DATETIME;			-- ��������
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
	DECLARE @paym_rmks VARCHAR(200);		-- ��ע
	DECLARE @paym_ref_id INT;				-- ��������id
	DECLARE @paym_ref_did INT;
	DECLARE @paym_ref_nbr VARCHAR(20);		-- ��������
	DECLARE @acctid INT;					-- acctid
	DECLARE @acctid_ctl INT;				-- �Ƿ�����ACCTID
	DECLARE @paym_nbr_flag INT;
	
	
	
	SET @o_rntStr = 'OK';
	
	SELECT @acctid_ctl = ISNULL(code_code, 0) FROM v_fi_tbacode WHERE code_type = 'ap_acctid_control' AND code_enable = 1;

	SELECT -- ���ò���
	     @twf_code = LEFT(accm.accm_nbr, 4)
	    , @paym_nbr_flag = 
	    --1�����ж�
	    --2����ж�
	    (CASE WHEN (accm_type=3 OR (accm_type=1 AND  accm.accm_approved_amt >= 0))   THEN 4 ELSE 2 END)
		, @paym_emp = accm.accm_emp
		, @paym_dept = accm.accm_dept
		, @paym_duty = accm.accm_duty
		, @paym_due_date = accm_date_end--accm.accm_pay_date paym_due_date��
		, @paym_date = accm.accm_date--ȡ��������
		, @paym_paycode_type = accm.accm_paycode_type
		, @paym_pay_code = accm.accm_pay_code
		, @paym_legal = accm.accm_legal
		, @paym_currency = accm_currency
		, @paym_rate = accm_rate
		, @paym_amt = ABS(accm_approved_amt)
		, @paym_pay_type = 1--֧����ʽ/�տʽ--�ֽ�
		, @paym_pay_bank = ''
		, @paym_pay_name = ''
		, @paym_pay_nbr = ''
		, @paym_admin_type = 4
		, @paym_admin_dept = accm.accm_admin_dept
		, @paym_admin_desc = (SELECT TOP(1) dept.cc_desc
		                      FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = accm.accm_admin_dept)
		, @paym_duty_emp = accm.accm_emp
		, @paym_rmks = accm.accm_rmks
		, @paym_ref_nbr = accm.accm_nbr
		, @paym_ref_id = accm.accm_id
		, @paym_ref_did = 0
		, @acctid = accm.acctid
	FROM FIDB.dbo.tfi_accountcussent_m accm
	WHERE accm_id = @i_mid;
				
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--����Ӧ����
		EXEC FIDB.dbo.rp_fi_add_apacV2
			@paym_nbr_flag
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
			, @o_rntStr OUTPUT
			, @paym_date;
			
			IF(@o_rntStr = 'OK')
			BEGIN
				--�Ժ�׼������ϸ��paym���ݣ�ʧЧ����д���paym_real_amt = paym_amt����״̬
				UPDATE FIDB.dbo.tfi_pay_m
				SET paym_parent_id = @o_paym_id, isenable = 0, paym_real_amt = paym_amt, paym_status = (CASE WHEN paym_nbr_flag = 1 OR paym_nbr_flag = 2 THEN 7 ELSE 11 END)
				FROM FIDB.dbo.tfi_accountcussent_m m
				INNER JOIN FIDB.dbo.tfi_accountcussent_d d ON m.accm_id = d.accd_accm_id
				WHERE m.accm_id = @i_mid AND d.accd_m_id = paym_id
				
				
				--���������paym���ݣ��������Ϊ0�Ļ���ֱ��ʧЧ�ͻ�д״̬
				UPDATE FIDB.dbo.tfi_pay_m
				SET isenable = 0, paym_status = (CASE WHEN paym_nbr_flag = 1 OR paym_nbr_flag = 2 THEN 7 ELSE 11 END)
				WHERE paym_id = @o_paym_id AND paym_nbr = @o_paym_nbr AND paym_amt = 0
			END

	END
	ELSE
	BEGIN
		SET @o_rntStr = '�޷�����Ӧ������';
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
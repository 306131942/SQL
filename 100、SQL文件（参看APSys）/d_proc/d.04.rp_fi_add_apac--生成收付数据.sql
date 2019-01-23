USE FIDB
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_add_apac','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_apac AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-06-03
-- Description:	����Ӧ�������ύ������
-- Modify[1]:   lzs 2013-11-20 ���Ӳɹ����˵����͸���֪ͨ���߼�
-- Modify[2]:   ��ε 2014-2-13 �������۶��˵������տ�֪ͨ���߼�
-- modify[3]:   ��ε ���Ӿɰ汾���۶��˵������տ�֪ͨ���߼�
-- modify[4]:   lzs 2014-03-03 ������Ʒ�˿ⵥ�����տ�֪ͨ���߼�
-- modify[5]:   lzs 2014-03-05 ����н�ʷ����Ƹ���֪ͨ�߼�
-- modify[6]:   by liuxiang at 2014-10-03 ����Ʊ�񼰿�ݶ����Ƹ���֪ͨ�߼������������߼�
-- modify[6]:   by liuxiang at 2014-11-18 �޸ĸ��ݱ��������Ƹ���߼�
-- modify[7]:   by liuxiang at 2015-02-03 ����Ӧ�ո�����ǰ��У�����ӷ��˱Ƚ�
-- modify[8]:   by zhoupan at 2016-03-02 �������ɸ���֪ͨʱ��ͨ�����˷�ʽ�Ƿ�Ϊ�������ж�
-- =========================================================================================
ALTER PROCEDURE rp_fi_add_apac 
(
	@i_nbr_type TINYINT					-- �������� 1Ӧ��2����Ӧ��3Ӧ��4����Ӧ��
	, @i_paym_item VARCHAR(20)			-- ��ƿ�Ŀ
	, @i_paym_typm_id INT				-- Ӧ������mid
	, @i_paym_typd_id INT				-- Ӧ������did
	, @i_paym_flag TINYINT				-- 1����2����
	, @i_paym_emp VARCHAR(20)			-- ������
	, @i_paym_dept VARCHAR(20)			-- ���벿��code
	, @i_paym_duty INT					-- �����˸�λ
	, @i_paym_due_date DATETIME			-- Ӧ������
	, @i_paym_paycode_type TINYINT		-- �Է����� 1��Ӧ��2����
	, @i_paym_pay_code VARCHAR(20)		-- �Է�����
	, @i_paym_legal INT					-- Ӧ������
	, @i_paym_currency VARCHAR(10)		-- �ұ�
	, @i_paym_rate DECIMAL(19, 7)		-- ����
	, @i_paym_amt MONEY					-- Ӧ�����
	, @i_paym_pay_type TINYINT			-- ֧����ʽ
	, @i_paym_pay_bank VARCHAR(100)		-- ������
	, @i_paym_pay_name VARCHAR(100)		-- ������
	, @i_paym_pay_nbr VARCHAR(50)		-- �����˺�
	, @i_paym_admin_dept VARCHAR(20)	-- ���β���
	, @i_paym_duty_emp VARCHAR(20)		-- ������
	, @i_paym_rmks VARCHAR(200)			-- ��ע
	, @i_paym_ref_id INT				-- ��������id
	, @i_paym_ref_nbr VARCHAR(20)		-- ��������
	, @i_acctid INT						-- acctid
	, @o_paym_id INT OUTPUT				-- ����Ӧ����id
	, @o_paym_nbr VARCHAR(20) OUTPUT	-- ����Ӧ������
	, @o_rntStr VARCHAR(800) OUTPUT		-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	-- ��������
	DECLARE @i_paym_item VARCHAR(20);
	DECLARE @i_paym_typm_id INT;
	DECLARE @i_paym_typd_id INT;
	DECLARE @i_paym_flag TINYINT;
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
	DECLARE @i_paym_admin_dept VARCHAR(20);
	DECLARE @i_paym_duty_emp VARCHAR(20);
	DECLARE @i_paym_rmks VARCHAR(200);
	DECLARE @i_paym_ref_id INT;
	DECLARE @i_paym_ref_nbr VARCHAR(20);
	DECLARE @i_acctid INT;
	DECLARE @o_paym_id INT;
	DECLARE @o_paym_nbr VARCHAR(20);
	DECLARE @o_rntStr VARCHAR(800);
	
	SET @i_paym_item = '1';
	SET @i_paym_typm_id = 1;
	SET @i_paym_typd_id = 2;
	SET @i_paym_flag = 1;
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
	SET @i_paym_admin_dept = '012213';
	SET @i_paym_duty_emp = '00000001';
	SET @i_paym_rmks = 'ҵ����ñ�����';
	SET @i_paym_ref_id = 151;
	SET @i_paym_ref_nbr = 'AC11-12030001';
	SET @i_acctid = 1;
	*/
	
	SET @o_rntStr = 'OK';
	
	DECLARE @spl_name VARCHAR(200); -- �Է�����
	
	IF (@i_paym_ref_id = 0 OR @i_paym_ref_id IS NULL OR @i_paym_ref_nbr = '' OR @i_paym_ref_nbr IS NULL)
	BEGIN -- ��������Ϊ��
		SET @o_rntStr = '��������Ϊ�գ���������Ӧ��/Ӧ�յ���';
	END
	ELSE IF EXISTS (SELECT 1 FROM tfi_pay_m  WHERE paym_nbr_flag = @i_nbr_type AND paym_ref_id = @i_paym_ref_id 
					AND paym_ref_nbr = @i_paym_ref_nbr AND paym_legal=@i_paym_legal AND paym_status <> 8)
	BEGIN -- �Ѵ���Ӧ��������������Ӧ����
		SET @o_rntStr = @i_paym_ref_nbr + '�Ѵ���Ӧ��/Ӧ�յ���';
	END
	ELSE
	BEGIN -- ����Ӧ����
		SET @i_paym_amt = (CASE WHEN @i_paym_flag = 2 THEN ABS(@i_paym_amt) * -1 ELSE ABS(@i_paym_amt) END);
		SELECT @spl_name = pay_fname FROM v_fi_paycode_info WHERE ctype = @i_paym_paycode_type AND pay_code = @i_paym_pay_code;
		SET @i_paym_item = (CASE WHEN @i_nbr_type = 1 THEN '1' ELSE '3' END);
	
		INSERT INTO tfi_pay_m ( -- ��������begin
			paym_nbr
			, paym_item
			, paym_typm_id
			, paym_typd_id
			, paym_flag
			, paym_emp
			, paym_dept
			, paym_duty
			, paym_date
			, paym_due_date
			, paym_paycode_type
			, paym_pay_code
			, paym_spl_name
			, paym_legal
			, paym_currency
			, paym_rate
			, paym_amt
			, paym_real_amt
			, paym_pay_type
			, paym_pay_bank
			, paym_pay_name
			, paym_pay_nbr
			, paym_admin_dept
			, paym_duty_emp
			, paym_rmks
			, paym_status
			, paym_ref_nbr
			, paym_ref_id
			, adduser
			, acctid
			, paym_nbr_flag
		) VALUES (
			@i_paym_ref_nbr
			, @i_paym_item
			, @i_paym_typm_id
			, @i_paym_typd_id
			, @i_paym_flag
			, @i_paym_emp
			, @i_paym_dept
			, @i_paym_duty
			, CONVERT(VARCHAR(10), GETDATE(), 23)
			, @i_paym_due_date
			, @i_paym_paycode_type
			, @i_paym_pay_code
			, @spl_name
			, @i_paym_legal
			, @i_paym_currency
			, @i_paym_rate
			, @i_paym_amt
			, 0
			, @i_paym_pay_type
			, @i_paym_pay_bank
			, @i_paym_pay_name
			, @i_paym_pay_nbr
			, @i_paym_admin_dept
			, @i_paym_duty_emp
			, @i_paym_rmks
			, (CASE WHEN @i_nbr_type = 1 THEN 5 ELSE 9 END)
			, @i_paym_ref_nbr
			, @i_paym_ref_id
			, @i_paym_emp
			, @i_acctid
			, @i_nbr_type
		);
		SET @o_paym_id = @@identity; -- ��������end
		SET @o_paym_nbr = @i_paym_ref_nbr;
		
		-- ����Ӧ������д�����������ɸ���֪ͨ������ͨ�ã�
		IF EXISTS (SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ( ttd.typd_wfm_code = 'AC13'))
		BEGIN
			-- ���ɸ���֪ͨ���ɰ棩
			IF(@i_paym_paycode_type=2 
				OR (@i_paym_paycode_type=3 AND NOT EXISTS(SELECT 1 FROM HSAL.dbo.tsa_acct_m WHERE actm_cust=@i_paym_pay_code)) 
				OR (@i_paym_paycode_type=1 AND NOT EXISTS(SELECT 1 FROM HPUR.dbo.TPU_ACCT_M WHERE actm_spl_code=@i_paym_pay_code)))
				
			BEGIN
				EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
			END
			
			IF (@o_rntStr = 'OK')
			BEGIN
				-- ��д�������Ѹ����
				UPDATE a SET a.RMMT_PAYMENT_R = ROUND(ISNULL(a.RMMT_PAYMENT_R, 0) + b.paym_amt * b.paym_rate, 2)
				FROM TFI_REIMBURSEMENT a
				INNER JOIN tfi_pay_m b ON b.paym_ref_id = a.rmmt_id AND LEFT(b.paym_ref_nbr, 13) = a.rmmt_nbr
				WHERE b.paym_id = @o_paym_id;
			END
		END
		
		-- ͨ�ñ���
		ELSE IF EXISTS (SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ( ttd.typd_wfm_code = 'AC11'  OR ttd.typd_wfm_code = 'AC12' OR ttd.typd_wfm_code = 'AC14'))
			
		BEGIN
			DECLARE @rmmt_loan DECIMAL(19,2);	-- �ֿ۽��
			SELECT @rmmt_loan = tr.RMMT_LOAN + tr.rmmt_rec_loan
			  FROM FIDB.dbo.TFI_REIMBURSEMENT tr WHERE tr.RMMT_ID = @i_paym_ref_id AND tr.RMMT_NBR = @i_paym_ref_nbr
			-- ���ɸ���֪ͨ(ͨ�ñ�����Ϊ����ʱ���°�)
			-- 1������Ƹ���֪ͨ��1��Ȩ�淽���տ���˷�ʽ��Ϊ֧��
			IF EXISTS (SELECT 1 FROM TFI_REIMBURSEMENT m
					   WHERE rmmt_id = @i_paym_ref_id AND RMMT_NBR = @i_paym_ref_nbr 
					   AND (m.rmmt_gl_type = 1 AND m.rmmt_rec_gltype = 1 OR (@rmmt_loan <> 0))) 
						 
			BEGIN
				EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
			END
			
			IF (@o_rntStr = 'OK')
			BEGIN
				-- ��д�������Ѹ����
				UPDATE a SET a.RMMT_PAYMENT_R = ROUND(ISNULL(a.RMMT_PAYMENT_R, 0) + b.paym_amt * b.paym_rate, 2)
				FROM TFI_REIMBURSEMENT a
				INNER JOIN tfi_pay_m b ON b.paym_ref_id = a.rmmt_id AND LEFT(b.paym_ref_nbr, 13) = a.rmmt_nbr
				WHERE b.paym_id = @o_paym_id;
			END
		END
			
		--���ⵥ�����տ�֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'QM03')
		BEGIN
			DECLARE @type VARCHAR(10);
			SELECT @type=clam_pay_type FROM hqis.dbo.tqa_claim_m WHERE clam_id=@i_paym_ref_id;
			IF (@type = '1')
			BEGIN
				EXEC rp_fi_rec_to_incomebill @o_paym_id; -- �����տ�֪ͨ
			END
		END
		--�ɹ����˵����͸���֪ͨ��
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('PU19','PU20','PU21','PU29','PU33','PU34','PU35'))
		BEGIN
			-- ���ɸ���֪ͨ
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
		END
		--���۶��˵������տ�֪ͨ��
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'SA47')
		BEGIN
			-- �����տ�֪ͨ
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;
		END
		--���۾ɰ������տ�֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'AR01')
		BEGIN
			-- �����տ�֪ͨ
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--��Ʒ�˿������տ�֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code = 'GF03')
		BEGIN
			-- �����տ�֪ͨ
			EXEC rp_fi_rec_to_incomebill @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--н�ʷ����Ƹ���֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('WG05', 'WG11'))
		BEGIN
			-- ���ɸ���֪ͨ
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--Ʊ�񼰿�ݶ����Ƹ���֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('AD08'))
		BEGIN
			-- ���ɸ���֪ͨ
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
		--���������Ƹ���֪ͨ
		ELSE IF EXISTS(SELECT 1 FROM tfi_type_d ttd WHERE ttd.typd_typm_id = @i_paym_typm_id AND ttd.typd_id = @i_paym_typd_id
			AND ttd.typd_wfm_code IN ('AD09'))
		BEGIN
			-- ���ɸ���֪ͨ
			EXEC rp_fi_pay_to_billhead @i_mid = @o_paym_id, @o_rntStr = @o_rntStr OUTPUT;			
		END
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
USE FIDB
GO

IF(OBJECT_ID('rp_fi_tax_to_pay','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_tax_to_pay AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		fengxd
-- Create date: 2018-08-07
-- Description:	Ӧ��˰�ѵ����ɷѷ�ʽΪ'�Խ�'ʱ,����ͨ������Ӧ����
-- =========================================================================================
ALTER PROCEDURE rp_fi_tax_to_pay
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
	
	DECLARE @nbr_type TINYINT            -- �������� 1:Ӧ��;2:����Ӧ��;3:Ӧ��;4:����Ӧ��.
	DECLARE @twf_code VARCHAR(20)        -- ����code (ԭ����)
	DECLARE @paym_emp VARCHAR(20)        -- ������
	DECLARE @paym_dept VARCHAR(20)       -- ���벿��code
	DECLARE @paym_duty INT               -- �����˸�λ
	DECLARE @paym_due_date DATETIME      -- Ӧ������
	DECLARE @paym_paycode_type TINYINT   -- �Է����� 1:��Ӧ��;2:����;3:�ͻ�;101:����
	DECLARE @paym_pay_code VARCHAR(20)   -- �Է����� 
	DECLARE @paym_legal INT              -- Ӧ��/Ӧ������ 
	DECLARE @paym_currency VARCHAR(10)   -- �ұ�(�����Ǳ�׼�ұ�)
	DECLARE @paym_rate DECIMAL(19, 7)    -- ����
	DECLARE @paym_amt MONEY              -- Ӧ�����
	DECLARE @paym_pay_type TINYINT       -- ֧����ʽ 1: �ֽ�2��ת��
	DECLARE @paym_pay_bank VARCHAR(100)  -- ������(�Է�)
	DECLARE @paym_pay_name VARCHAR(100)  -- ������(�Է�)
	DECLARE @paym_pay_nbr VARCHAR(50)    -- �����˺�(�Է�)
	DECLARE @paym_admin_type INT         -- ���������� 1:��Ӧ��;2:����;3:�ͻ�;4:����; (һ�㶼��4����)
	DECLARE @paym_admin_dept VARCHAR(20) -- ���������루Ӧ��/Ӧ�����ű��룩
	DECLARE @paym_admin_desc VARCHAR(200)-- ���������ƣ�Ӧ��/Ӧ���������ƣ�
	DECLARE @paym_duty_emp VARCHAR(20)   -- ���������� (û�е�ȡ������)
	DECLARE @paym_rmks VARCHAR(800)      -- ��ע
	DECLARE @paym_ref_id INT             -- ��������id (ԭ����mid)
	DECLARE @paym_ref_did INT            -- ��������did (ԭ����did,���ŵ���0)
	DECLARE @paym_ref_nbr VARCHAR(20)    -- �������� (ԭ����nbr)
	DECLARE @acctid INT                  -- acctid
	DECLARE @paym_date DATETIME = NULL   -- ҵ��������
	DECLARE @paym_pay_deptcode VARCHAR(20) = ''  -- �ڲ����˽��ײ���(�Է�����)
	
	SET @o_rntStr = 'OK';
	
	IF NOT EXISTS(SELECT 1 FROM FIDB.dbo.tfi_tax_admin_m WHERE ttam_id = @i_mid AND 1=ISNULL(ttam_pay_way,'') AND ttam_status = 6)
	BEGIN
		-- ttam_pay_way(0/null:�۷ѣ�1:�Խ�.)
		-- �ɷѷ�ʽΪ'�Խ�'ʱ,����ͨ������Ӧ����,���� RETURN
	   	RETURN;
	END
	
	SELECT -- ���ò���
		 @nbr_type = 1						-- ��������1:Ӧ��;2:����Ӧ��;3:Ӧ��;4:����Ӧ��.
       , @twf_code = LEFT(ttam.ttam_nbr,4)  -- ����code
       , @paym_emp = ttam.ttam_emp			-- ������
       , @paym_dept = ttam.ttam_dept		-- ���벿��code
       , @paym_duty = ttam.ttam_duty        -- �����˸�λ
       , @paym_due_date = ttam.ttam_date    -- Ӧ������
       , @paym_paycode_type = 5				-- �Է����� 1:��Ӧ��;2:����;3:�ͻ�,5����;101:����
       , @paym_pay_code = ttam.ttam_payee	-- �Է�����
       , @paym_legal = ttam.ttam_legal      -- Ӧ������
       , @paym_currency = UPPER(ttam.ttam_currency) -- �ұ�
       , @paym_rate = ttam.ttam_rate		-- ����
       , @paym_amt = ttam.ttam_tax_amt+ttam.ttam_late_fee+ttam.ttam_penalty	-- Ӧ�����
       , @paym_pay_type = 2					-- ֧����ʽ1: �ֽ�2��ת��
       , @paym_pay_bank = ttam.ttam_payee_bank	-- ������
       , @paym_pay_name = fpi.pay_fname			-- ������
       , @paym_pay_nbr = ttam.ttam_payee_acct	-- �����˺�
       , @paym_admin_type = 4					-- ����������1:��Ӧ��;2:����;3:�ͻ�;4:����;
       , @paym_admin_dept = ttam.ttam_dept	-- ����������
       , @paym_admin_desc = dept.cc_desc	-- ����������
       , @paym_duty_emp = ttam.ttam_emp		-- ����������
       , @paym_rmks = ttam_rmks				-- ��ע
       , @paym_ref_id = ttam.ttam_id		-- ��������id
       , @paym_ref_did =0					-- ��������did
       , @paym_ref_nbr = ttam.ttam_nbr		-- ��������
       , @acctid = ttam.acctid
	FROM FIDB.dbo.tfi_tax_admin_m ttam
	LEFT JOIN HR90.dbo.cc_mstr1 dept ON dept.cc_code = ttam.ttam_dept
	LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.pay_code = ttam.ttam_payee
	WHERE ttam.ttam_id = @i_mid;
	
	IF (@paym_ref_id IS NOT NULL AND @paym_ref_nbr IS NOT NULL)
	BEGIN
		--����Ӧ����
		IF (@paym_amt <> 0)
		BEGIN
			EXEC FIDB.dbo.rp_fi_add_apacV2 
				  @nbr_type
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
				, @o_rntStr OUTPUT;
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
USE FIDB
GO

IF(OBJECT_ID('rp_fi_pay_to_billhead','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_pay_to_billhead AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-06-06
-- Description:	����Ӧ�������ͨ�������ɸ���֪ͨ��
-- Modify[1]: ���ӹ�Ӧ���ҿͻ���������� at 2014-11-03 by liuxiang
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_pay_to_billhead]
(
	@i_mid INT
	, @o_abhm_id INT = 0 OUTPUT				-- ���ظ��id
	, @o_abhm_nbr VARCHAR(20) = '' OUTPUT 	-- ���ظ����
	, @o_rntStr VARCHAR(800) = '' OUTPUT		-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @mid INT;
	--SET @mid = 13244;
	
	DECLARE @wfcode VARCHAR(20);			-- �ĸ��������� AP05(Ӧ��->����) AC15(���->Ԥ��)
	DECLARE @abhm_type TINYINT;				-- �������� 1���� 2Ԥ��
	DECLARE @abhm_item VARCHAR(20);			-- ��ƿ�Ŀ
	DECLARE @abhm_emp VARCHAR(20);			-- ������
	DECLARE @abhm_dept VARCHAR(20);			-- ���벿��code
	DECLARE @abhm_duty INT;					-- �����˸�λ
	DECLARE @abhm_legal INT;				-- ����
	DECLARE @abhm_paycode_type TINYINT;		-- �Է����� 1��Ӧ��2����
	DECLARE @abhm_pay_code VARCHAR(20);		-- �Է�����
	DECLARE @abhm_pay_type TINYINT;			-- ֧����ʽ
	DECLARE @abhm_pay_bank VARCHAR(100);	-- ������
	DECLARE @abhm_pay_name VARCHAR(100);	-- ������
	DECLARE @abhm_pay_nbr VARCHAR(50);		-- �����˺�
	DECLARE @abhm_currency VARCHAR(10);		-- �ұ�
	DECLARE @abhm_rate  DECIMAL(19, 7);  	-- ����
	DECLARE @abhm_amt MONEY;				-- Ӧ�����
	DECLARE @abhm_pay_date DATETIME;		-- ��������
	DECLARE @abhm_rmks VARCHAR(800);		-- ��ע
	DECLARE @abhm_ref_id INT;				-- ��������ID
	DECLARE @acctid INT;					-- acctid
	
	DECLARE @paym_nbr VARCHAR(20);			--���ݵ���
	
	SET @o_rntStr = 'OK';
	
	SELECT -- ���ò���
		@wfcode = 'AP05'
		, @paym_nbr = tpm.paym_nbr
		, @abhm_type = 1
		, @abhm_item = tpm.paym_item
		, @abhm_emp = tpm.paym_emp
		, @abhm_dept = tpm.paym_dept
		, @abhm_duty = tpm.paym_duty
		, @abhm_legal = tpm.paym_legal
		, @abhm_paycode_type = tpm.paym_paycode_type
		, @abhm_pay_code = tpm.paym_pay_code
		, @abhm_pay_type = tpm.paym_pay_type
		, @abhm_pay_name = tpm.paym_pay_name
		, @abhm_pay_bank = tpm.paym_pay_bank
		, @abhm_pay_nbr = tpm.paym_pay_nbr
		, @abhm_currency = tpm.paym_currency
		, @abhm_rate = tpm.paym_rate
		, @abhm_amt = tpm.paym_amt
		, @abhm_pay_date = tpm.paym_due_date
		, @abhm_rmks = tpm.paym_rmks
		, @abhm_ref_id = tpm.paym_id
		, @acctid = tpm.acctid
	FROM FIDB.dbo.tfi_pay_m tpm
	WHERE tpm.paym_id = @i_mid;
	
	IF (@abhm_ref_id IS NOT NULL)
	BEGIN
		IF (@abhm_amt>0 
			 AND 	--������Ӧ����AP06,����˫�����ͻ�ʱ������
			   (
				  NOT EXISTS(SELECT 1 FROM HPUR.dbo.TPU_SUPPLIER WHERE SPL_TYPE IN (1,3) AND @abhm_paycode_type = 1 AND spl_code = @abhm_pay_code AND ISNULL(spl_domestic_cust,'') <> '') 
				  OR @abhm_paycode_type <> 1
				  OR LEFT(@paym_nbr,4)='AP06'
				)
			)
		BEGIN
			EXEC rp_fi_add_billhead
			@wfcode,
			@abhm_type,
			@abhm_item,
			@abhm_emp,
			@abhm_dept,
			@abhm_duty,
			@abhm_legal,
			@abhm_paycode_type,
			@abhm_pay_code,
			@abhm_pay_type,
			@abhm_pay_bank,
			@abhm_pay_name,
			@abhm_pay_nbr,
			@abhm_currency,
			@abhm_rate,
			@abhm_amt,
			0,
			@abhm_amt,
			@abhm_pay_date,
			@abhm_rmks,
			NULL,
			@abhm_ref_id,
			@acctid,
			@o_abhm_id OUTPUT,
			@o_abhm_nbr OUTPUT,
			@o_rntStr OUTPUT;
		END

	END
	ELSE
	BEGIN
		SET @o_rntStr = '�޷����ɸ���֪ͨ��';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
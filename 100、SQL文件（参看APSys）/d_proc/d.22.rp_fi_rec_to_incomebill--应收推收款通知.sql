USE FIDB
GO
IF(OBJECT_ID('rp_fi_rec_to_incomebill','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_rec_to_incomebill AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		������
-- Create date: 2013-10-23
-- Description:	Ӧ�յ����ͨ���������տ�֪ͨ��
-- Modify[1]: ���ӿͻ��ҹ�Ӧ�̵�������� at 2014-11-03 by liuxiang
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_rec_to_incomebill]
(
	@i_mid INT--���������������ɵ�paym���ݵ�id(����SA47��Ӧ��)
	, @o_icbm_id INT = 0 OUTPUT				-- �����տid
	, @o_icbm_nbr VARCHAR(20) = '' OUTPUT		-- �����տ��
	, @o_rntStr VARCHAR(800) = '' OUTPUT		-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	DECLARE @wfcode VARCHAR(20);			-- �ĸ��������� AR05(Ӧ��->�տ�) 
	DECLARE @icbm_type TINYINT;				-- �տ����� 1�տ� 2Ԥ��
	DECLARE @icbm_item VARCHAR(20);			-- ��ƿ�Ŀ
	DECLARE @icbm_emp VARCHAR(20);			-- ������
	DECLARE @icbm_dept VARCHAR(20);			-- ���벿��code
	DECLARE @icbm_duty INT;					-- �����˸�λ
	DECLARE @icbm_legal INT;				-- ����
	DECLARE @icbm_reccode_type TINYINT;		-- �Է����� 2����3�ͻ�
	DECLARE @icbm_rec_code VARCHAR(20);		-- �Է�����
	DECLARE @icbm_rec_type TINYINT;			-- ֧����ʽ
	DECLARE @icbm_rec_bank VARCHAR(100);		-- �������� 
	DECLARE @icbm_rec_company VARCHAR(100);	    -- �����˻���  �������
	DECLARE @icbm_rec_acct VARCHAR(50);			-- �����˺�
	DECLARE @icbm_currency VARCHAR(10);		-- �ұ�
	DECLARE @icbm_amt MONEY;				-- Ӧ�ս��
	DECLARE @icbm_rec_date DATETIME;		-- �տ�����
	DECLARE @icbm_rmks VARCHAR(800);		-- ��ע
	DECLARE @icbm_ref_id INT;				-- ��������ID
	DECLARE @acctid INT;					-- acctid
	
	DECLARE @paym_nbr VARCHAR(20);			--���ݵ���
	
	SET @o_rntStr = 'OK';
	
	SELECT -- ���ò���
		@wfcode = 'AR05'
		, @paym_nbr = tpm.paym_nbr
		, @icbm_type = 1
		, @icbm_item = tpm.paym_item
		, @icbm_emp = tpm.paym_emp
		, @icbm_dept = tpm.paym_dept
		, @icbm_duty = tpm.paym_duty
		, @icbm_legal = tpm.paym_legal
		, @icbm_reccode_type = tpm.paym_paycode_type
		, @icbm_rec_code = tpm.paym_pay_code
		, @icbm_rec_type = tpm.paym_pay_type
		, @icbm_currency = tpm.paym_currency
		, @icbm_rec_bank = tpm.paym_pay_bank
		, @icbm_rec_company = tpm.paym_pay_name
		, @icbm_rec_acct = tpm.paym_pay_nbr
		, @icbm_amt = tpm.paym_amt
		, @icbm_rec_date = tpm.paym_due_date
		, @icbm_rmks = tpm.paym_rmks
		, @icbm_ref_id = tpm.paym_id--���������������ɵ�paym���ݵ�id(����SA47��Ӧ��)
		, @acctid = tpm.acctid
	FROM FIDB.dbo.tfi_pay_m tpm
	WHERE tpm.paym_id = @i_mid;
	
	IF (@icbm_ref_id IS NOT NULL)
	BEGIN
		IF (
			  ( @icbm_amt > 0 
				OR EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @i_mid AND (paym_nbr LIKE 'GF03%' OR paym_nbr LIKE 'SA47%' ))
			  )
			  AND --������Ӧ����AP06,����˫�����ͻ�ʱ������ 
		     (  NOT EXISTS(SELECT 1 FROM HSAL.dbo.v_sa_customer WHERE CUST_CODE=@icbm_rec_code AND @icbm_reccode_type=3 AND ISNULL(cust_supplier,'')<>'') 
		  		OR @icbm_reccode_type <> 3
		  		OR LEFT(@paym_nbr,4)='AR06'
			  )
		   )
		BEGIN
			EXEC FIDB.DBO.rp_fi_add_incomebill
			@wfcode,
			@icbm_type,
			@icbm_item,
			@icbm_emp,
			@icbm_dept,
			@icbm_duty,
			@icbm_legal,
			@icbm_reccode_type,
			@icbm_rec_code,
			@icbm_rec_type,
			@icbm_currency,
			@icbm_rec_bank,
			@icbm_rec_company,
			@icbm_rec_acct,
			@icbm_amt,
			0,
			@icbm_amt,
			@icbm_rec_date,
			@icbm_rmks,
			@icbm_ref_id,--���������������ɵ�paym���ݵ�id(����SA47��Ӧ��)
			@acctid,
			@o_icbm_id OUTPUT,
			@o_icbm_nbr OUTPUT,
			@o_rntStr OUTPUT;
		END
	END
	ELSE
	BEGIN
		SET @o_rntStr = '�޷������տ�֪ͨ��';
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
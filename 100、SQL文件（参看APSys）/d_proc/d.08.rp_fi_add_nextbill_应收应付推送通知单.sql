USE [FIDB]
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_add_nextbill','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_nextbill AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2016-05-13
-- Description:	����Ӧ�������ύ������

-- =========================================================================================
ALTER PROCEDURE rp_fi_add_nextbill 
(
	@i_mid INT--���������������ɵ�paym���ݵ�id(����SA47��Ӧ��)
	, @i_nbr VARCHAR(20)
	, @i_twf_code VARCHAR(20)
	, @o_rntStr VARCHAR(800) = '' OUTPUT	-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	/*
	--DECLARE @mid INT;
	--SET @mid = 13244;
	*/
	SET @o_rntStr = 'OK';
	
	DECLARE @bill_flag INT;--�Ƿ����͸���֪ͨ��״̬��0�������ͣ�1������
	
	--��ȡ�����Ƿ����͸���֪ͨ����flag״̬
	SELECT @bill_flag=isnull(ttd.typd_next_flag,0) FROM FIDB.dbo.tfi_pay_m tpm
	INNER JOIN FIDB.dbo.tfi_type_d ttd ON tpm.paym_typd_id=ttd.typd_id
	WHERE paym_id=@i_mid

	-- ����Ӧ������д�����������ɸ���֪ͨ
	IF(CHARINDEX(@i_twf_code, 'AC11,AC12,AC13,AC14,AC16,AC17') > 0)
	BEGIN
		DECLARE @rmmt_loan DECIMAL(19,2);	-- �ֿ۽��
		DECLARE @rmmt_id INT;		 --ͨ�ñ�������
		DECLARE @rmmt_nbr VARCHAR(20);		 --ͨ�ñ�������
		DECLARE @rmmt_rec_code VARCHAR(500); --ͨ�ñ�����ϸ���տ
		DECLARE @rmmt_gl_type INT;			--ͨ�ñ������㷽ʽ
		SELECT @rmmt_loan = (CASE WHEN ISNULL(d.rmmd_id, 0) = 0 THEN tr.RMMT_LOAN + tr.rmmt_rec_loan ELSE d.rmmd_loan_oamt + d.rmmd_loan_ramt END)
		, @rmmt_id = tr.RMMT_ID
		, @rmmt_nbr = tr.RMMT_NBR
		, @rmmt_rec_code = isnull(d.rmmd_contacts_rcode,'')
		, @rmmt_gl_type = (CASE WHEN  tr.rmmt_gl_type = 1 AND tr.rmmt_rec_gltype = 1 THEN 1 ELSE 2 END)
		FROM FIDB.dbo.TFI_REIMBURSEMENT tr
		LEFT JOIN FIDB.dbo.TFI_REIMBURSEMENT_d d ON tr.RMMT_ID = d.rmmd_rmmt_id 
		INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_ref_id = tr.RMMT_ID AND paym.paym_ref_nbr = tr.rmmt_nbr AND ISNULL(d.rmmd_id, 0) = ISNULL(paym.paym_ref_did, 0)
		WHERE paym.paym_id = @i_mid
		
		-- ��д�������Ѹ����
		UPDATE m SET m.rmmt_payment_r = ROUND(ISNULL(m.rmmt_payment_r, 0) + b.paym_amt * b.paym_rate, 2)
		FROM dbo.tfi_reimbursement m
		LEFT JOIN dbo.tfi_reimbursement_d d ON d.rmmd_rmmt_id = m.rmmt_id
		INNER JOIN dbo.tfi_pay_m b ON b.paym_ref_id = m.rmmt_id AND ISNULL(d.rmmd_id, 0) = ISNULL(b.paym_ref_did, 0)
		WHERE b.paym_id = @i_mid;
		
		
		--ͨ�÷��ñ�������Ȩ�淽���͸���֪ͨ���߼��������տ��ͬʱ����Ҫ�ϲ����и��
		IF( @i_twf_code = 'AC12' 
			AND @bill_flag = 1 
			AND @rmmt_gl_type = 1
			AND @rmmt_rec_code <>'' 
			AND (SELECT COUNT(1) FROM FIDB.dbo.tfi_pay_m pm WHERE pm.paym_ref_nbr = @rmmt_nbr  AND pm.paym_pay_code = @rmmt_rec_code)
				 = (SELECT COUNT(1) FROM FIDB.dbo.TFI_REIMBURSEMENT_d d WHERE d.rmmd_rmmt_id = @rmmt_id  AND d.rmmd_contacts_rcode = @rmmt_rec_code))
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END
		--���ֲ����Ǻϲ�
		else IF( @i_twf_code = 'AC12' AND @bill_flag = 1 AND @rmmt_gl_type = 2 AND @rmmt_loan <> 0)
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END
		--��ǰ��ͨ�ð汾
		-- ���ɸ���֪ͨ(ͨ�ñ�����Ϊ����ʱ���°�)
		-- 1������Ƹ���֪ͨ��1��Ȩ�淽���տ���˷�ʽ��Ϊ֧��
		-- �ֿ۽�����0�϶����ͣ����˷�ʽΪ1�϶�����
		else IF( @i_twf_code <> 'AC12'  AND @bill_flag=1 AND EXISTS (SELECT 1 FROM TFI_REIMBURSEMENT m 
				   INNER JOIN tfi_pay_m paym ON paym.paym_ref_id=m.RMMT_ID AND paym.paym_ref_nbr=m.rmmt_nbr
		           WHERE paym.paym_id = @i_mid AND ((m.rmmt_gl_type = 1 AND m.rmmt_rec_gltype = 1 ) OR (@rmmt_loan <> 0))))
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END

		
		--IF (@o_rntStr = 'OK')
		--BEGIN
		--	-- ��д�������Ѹ����
		--	UPDATE m SET m.rmmt_payment_r = ROUND(ISNULL(m.rmmt_payment_r, 0) + b.paym_amt * b.paym_rate, 2)
		--	FROM dbo.tfi_reimbursement m
		--	LEFT JOIN dbo.tfi_reimbursement_d d ON d.rmmd_rmmt_id = m.rmmt_id
		--	INNER JOIN dbo.tfi_pay_m b ON b.paym_ref_id = m.rmmt_id AND d.rmmd_id = b.paym_ref_did
		--	WHERE b.paym_id = @i_mid;
		--END
	END
	-- ����ֻҪ��֧����ʽ�������͸���֪ͨ��(ֻ����һ�ʸ���֪ͨ������������Ǳ�paym)
	ELSE IF(@i_twf_code = 'AC15' AND  @bill_flag=1 
		      AND  EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m paym
						  INNER JOIN FIDB.dbo.TFI_BORROW_MONEY_M brmm ON brmm.BRMM_ID = paym.paym_ref_id AND brmm.BRMM_NBR = paym.paym_ref_nbr
						  WHERE paym_item = '1' AND paym_id = @i_mid AND brmm.brmm_gl_type = 1 AND paym.paym_legal = brmm.BRMM_LEGAL)
		    )
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
	END
	-- ��,���뷽ѡ����ʱ���ҽ��������˲�ͬʱ�������տ�֪ͨ��(ֻ����һ���տ�֪ͨ�������뷽��Ǯ���Ǳ�paym)
	ELSE IF(@i_twf_code = 'AC15'AND  @bill_flag=1 
		      and EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m paym
						  INNER JOIN FIDB.dbo.TFI_BORROW_MONEY_M brmm ON brmm.BRMM_ID = paym.paym_ref_id AND brmm.BRMM_NBR = paym.paym_ref_nbr
						  WHERE paym_item = '3' AND paym_id = @i_mid AND brmm.brmm_gl_type = 1 AND brmm.BRMM_LEGAL<>brmm.brmm_lr_legal AND paym.paym_paycode_type=101
							AND paym.paym_legal = brmm.brmm_lr_legal
		      )
		    )
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	ELSE IF(@i_twf_code = 'AP06')
	BEGIN
		IF (@bill_flag=1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_other_m tpom 
	                                         INNER JOIN FIDB.dbo.tfi_pay_m paym ON tpom.paym_id = paym.paym_ref_id
	                                         WHERE paym_gl_type = 1 AND paym.paym_id = @i_mid))
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END
	END
	--�ɹ����˵����͸���֪ͨ��
	ELSE IF(CHARINDEX(@i_twf_code, 'PU19,PU20,PU21,PU29,PU33,PU34,PU35') > 0)
	BEGIN
		-- ���ɸ���֪ͨ
		IF (@bill_flag = 1 AND (SELECT ISNULL(paym_amt, 0) FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_mid) > 0)
		BEGIN
		  EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END
		ELSE IF((SELECT ISNULL(paym_amt, 0) FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_mid) = 0)
		BEGIN
	 		UPDATE FIDB.dbo.tfi_pay_m SET isenable = 0, paym_status = 7 WHERE paym_id = @i_mid
		END
		IF(CHARINDEX(@i_twf_code, 'PU19,PU20,PU21') > 0)
		BEGIN	
			-- �����˵���صĶ���ƾ֤���ɵ�Ӧ�յ�ʧЧ
			UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_real_amt = a.paym_amt, a.paym_status = 7
			FROM FIDB.dbo.tfi_pay_m a
			INNER JOIN HPUR.dbo.TPU_PVO_m b ON b.pvom_id = a.paym_ref_id AND b.pvom_receive_nbr = a.paym_ref_nbr
			INNER JOIN HPUR.dbo.TPU_ACCT_D c ON c.actd_pvom_id = b.pvom_id AND c.actd_pvod_id = 0
			INNER JOIN FIDB.dbo.tfi_pay_m pa ON c.ACTD_ACTM_ID = pa.paym_ref_id
			WHERE pa.paym_id = @i_mid
			
			UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_real_amt = a.paym_amt, a.paym_status = 7
			FROM FIDB.dbo.tfi_pay_m a
			INNER JOIN HPUR.dbo.TPU_PVO_D b ON b.PVOD_ID = a.paym_ref_id AND b.pvod_nbr_ref = a.paym_ref_nbr
			INNER JOIN HPUR.dbo.TPU_ACCT_D c ON c.actd_pvom_id = b.pvod_pvom_id AND c.actd_pvod_id = b.pvod_id
			INNER JOIN FIDB.dbo.tfi_pay_m pa ON c.ACTD_ACTM_ID = pa.paym_ref_id
			WHERE pa.paym_id = @i_mid
		END
	END
	--��Ʒ������͸���֪ͨ
	ELSE IF(@i_twf_code = 'GF01' AND @bill_flag=1)
	BEGIN
		IF EXISTS(SELECT 1 FROM HOAM.dbo.tgf_list_m m 
				   INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_ref_id = m.gflm_id AND paym.paym_ref_nbr = m.gflm_nbr
		           WHERE paym.paym_id = @i_mid AND m.gflm_gl_type = 1)		 
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;	
		END		
	END
	--Ʊ�񼰿�ݶ����Ƹ���֪ͨ
	ELSE IF(@i_twf_code = 'AD08' AND @bill_flag=1)
	BEGIN
		IF EXISTS(SELECT 1 FROM HOAM.dbo.tad_account_checking_m m 
				   INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_ref_id = m.accm_id AND paym.paym_ref_nbr = m.accm_nbr
		           WHERE paym.paym_id = @i_mid AND m.accm_gl_type = 1 AND m.accm_rec_gltype = 1)		 
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;	
		END			
	END
	-- ���ʲɹ��Ƹ���֪ͨ�� 
	ELSE IF(@i_twf_code = 'ET06')
	BEGIN
		IF (@bill_flag = 1 AND (SELECT ISNULL(paym_amt, 0) FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_mid) > 0)
		BEGIN
			      	
			 DECLARE @c_code VARCHAR(40)='';--��ͬ����
			 
			SELECT TOP 1  @c_code = ISNULL(m.aetm_contract_code,'')
			 FROM  R6ERP.dbo.tpu_acctet_m m
			 WHERE m.aetm_nbr = @i_nbr
			 
			 --��������ͬ������Э���ֱͬ���Ƹ���֪ͨ��  
			 IF(@c_code='' OR (SELECT cntm_type FROM  fidb.dbo.tfi_contract_m WHERE CNTM_CODE = @c_code AND CNTM_STATUS = 6 ) = 2)
			 BEGIN 
				EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
			 END 
		END
		ELSE IF((SELECT ISNULL(paym_amt, 0) FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_mid) = 0)
		BEGIN
	 		UPDATE FIDB.dbo.tfi_pay_m SET isenable = 0, paym_status = 7 WHERE paym_id = @i_mid
	 		RETURN;
		END
		IF(@i_twf_code = 'ET06')
		BEGIN	
			-- �����˵���صĶ���ƾ֤���ɵ�Ӧ�յ�ʧЧ
			UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_real_amt = a.paym_amt, a.paym_status = 7
			FROM FIDB.dbo.tfi_pay_m a
			INNER JOIN R6ERP.dbo.tpu_pvoe_m b ON b.pvem_id = a.paym_ref_id AND b.pvem_receive_nbr = a.paym_ref_nbr
			INNER JOIN R6ERP.dbo.tpu_acctet_d d ON d.aetd_pvom_id = b.pvem_id AND d.aetd_pvod_id = 0
			INNER JOIN FIDB.dbo.tfi_pay_m pa ON d.aetd_aetm_id = pa.paym_ref_id
			WHERE pa.paym_id = @i_mid
			
			UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_real_amt = a.paym_amt, a.paym_status = 7
			FROM FIDB.dbo.tfi_pay_m a
			INNER JOIN R6ERP.dbo.tpu_pvoe_d b ON b.pved_id = a.paym_ref_id AND b.pved_nbr_ref = a.paym_ref_nbr
			INNER JOIN R6ERP.dbo.tpu_acctet_d c ON c.aetd_pvom_id = b.pved_pvem_id AND c.aetd_pvod_id = b.pved_id
			INNER JOIN FIDB.dbo.tfi_pay_m pa ON c.aetd_aetm_id = pa.paym_ref_id
			WHERE pa.paym_id = @i_mid
		END
	END
	-- ��ͨ�����Ƹ���֪ͨ
	ELSE IF(@i_twf_code = 'SA82' AND @bill_flag=1)
	BEGIN
		IF EXISTS(SELECT 1 FROM HSAL.dbo.tsa_rebate_m m 
				   INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_ref_id = m.rbtm_id AND paym.paym_ref_nbr = m.rbtm_nbr
		           WHERE paym.paym_id = @i_mid AND m.rbtm_pay = 2)		 
		BEGIN
			EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;	
		END			
	END
	--н�ʷ����Ƹ���֪ͨ
	ELSE IF(CHARINDEX(@i_twf_code, 'WG05,WG11,WG20,HR49') > 0 AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- ˰�ѽ��ɵ������͸���֪ͨ��
	ELSE IF(@i_twf_code = 'AP16' AND @bill_flag = 1 AND EXISTS(SELECT 1  FROM fidb.dbo.tfi_tax_admin_m  WHERE ttam_nbr=@i_nbr AND isnull(ttam_pay_way,0)=1))
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;				
	END
	--���������Ƹ���֪ͨ
	ELSE IF(@i_twf_code = 'AD09' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	--������˵��Ƹ���֪ͨ
	ELSE IF(@i_twf_code = 'TM02' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	--�ͻ��˿��֪ͨ
	ELSE IF(@i_twf_code = 'AP12' AND @bill_flag=1 AND EXISTS(SELECT 1  FROM fidb.dbo.tfi_pay_m   WHERE paym_id=@i_mid  AND paym_nbr_flag = 2   ))
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	
	---------------------------------start------------------------------------�տ��-------------------------
	-- ���۶��˵������տ�֪ͨ��
	ELSE IF (@i_twf_code = 'SA47')
	BEGIN
		-- �����˵���صĶ���ƾ֤���ɵ�Ӧ�յ�ʧЧ
		UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_real_amt = a.paym_amt, a.paym_status = 11
		FROM FIDB.dbo.tfi_pay_m a
		INNER JOIN HSAL.dbo.tsa_pvo_m pvom ON pvom.spvm_id = a.paym_ref_id AND pvom.spvm_cshm_nbr = a.paym_ref_nbr 
											  AND pvom.spvm_acct_qty=(pvom.spvm_qty + pvom.spvm_reserve_qty)
		INNER JOIN HSAL.dbo.tsa_acct_d accd ON accd.actd_spvm_id = pvom.spvm_id AND accd.actd_select = 1
		INNER JOIN FIDB.dbo.tfi_pay_m pa ON accd.actd_actm_id = pa.paym_ref_id
		WHERE pa.paym_id = @i_mid AND a.isenable = 1
		
		UPDATE a SET a.isenable = 0, a.paym_parent_id = @i_mid, a.paym_status = 11
					, a.paym_amt = accd.actd_price * accd.actd_fqty * (CASE WHEN spvm_lstmtype = '11' OR spvm_lstmtype = '19' THEN -1 ELSE 1 END)
					, a.paym_real_amt = accd.actd_price * accd.actd_fqty * (CASE WHEN spvm_lstmtype = '11' OR spvm_lstmtype = '19' THEN -1 ELSE 1 END)
					, a.paym_split_sort = ISNULL(a.paym_split_sort,1)
		FROM FIDB.dbo.tfi_pay_m a
		INNER JOIN HSAL.dbo.tsa_pvo_m pvom ON pvom.spvm_id = a.paym_ref_id AND pvom.spvm_cshm_nbr = a.paym_ref_nbr 
											  AND pvom.spvm_acct_qty <> (pvom.spvm_qty + pvom.spvm_reserve_qty)
		INNER JOIN HSAL.dbo.tsa_acct_d accd ON accd.actd_spvm_id = pvom.spvm_id AND accd.actd_select = 1
		INNER JOIN FIDB.dbo.tfi_pay_m pa ON accd.actd_actm_id = pa.paym_ref_id
		WHERE pa.paym_id = @i_mid AND a.isenable = 1
		
		INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept
				, paym_duty, paym_date, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate
				, paym_nbr_amt
				, paym_amt, paym_real_amt, paym_pay_type, paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_dept
				, paym_duty_emp, paym_rmks, paym_status, paym_ref_nbr, paym_ref_id, paym_nbr_flag, paym_spl_name
				, paym_parent_id, paym_nbr, paym_split_sort, isenable, addtime, adduser, modtime, moduser, acctid)
		SELECT  a.paym_item, a.paym_typm_id, a.paym_typd_id, a.paym_flag, a.paym_emp, a.paym_dept
				, a.paym_duty, a.paym_date, a.paym_due_date, a.paym_paycode_type, a.paym_pay_code, a.paym_legal, a.paym_currency, a.paym_rate
				, a.paym_nbr_amt
				, a.spvm_price*(a.spvm_qty + a.spvm_reserve_qty - a.spvm_acct_qty) * (CASE WHEN spvm_lstmtype = '11' OR spvm_lstmtype = '19' THEN -1 ELSE 1 END)
				, 0, a.paym_pay_type, a.paym_pay_bank, a.paym_pay_name, a.paym_pay_nbr, a.paym_admin_dept
				, a.paym_duty_emp, a.paym_rmks, 9, a.paym_ref_nbr, a.paym_ref_id, a.paym_nbr_flag, a.paym_spl_name
				, 0, a.paym_nbr, ISNULL(a.paym_split_sort,1) + 1, 1, a.addtime, a.adduser, a.modtime, GETDATE(), a.acctid
		FROM( SELECT m.*,pvom.spvm_acct_qty, pvom.spvm_qty, pvom.spvm_reserve_qty, pvom.spvm_price, pvom.spvm_lstmtype
					, rn=ROW_NUMBER() OVER (PARTITION BY m.paym_ref_id, m.paym_ref_nbr ORDER BY m.paym_split_sort DESC)
		FROM FIDB.dbo.tfi_pay_m m
		INNER JOIN HSAL.dbo.tsa_pvo_m pvom ON pvom.spvm_id = m.paym_ref_id AND pvom.spvm_cshm_nbr = m.paym_ref_nbr 
											  AND pvom.spvm_acct_qty <> (pvom.spvm_qty + pvom.spvm_reserve_qty)
		INNER JOIN HSAL.dbo.tsa_acct_d accd ON accd.actd_spvm_id = pvom.spvm_id AND accd.actd_select = 1
		INNER JOIN FIDB.dbo.tfi_pay_m pm ON accd.actd_actm_id = pm.paym_ref_id
		WHERE pm.paym_id = @i_mid) a WHERE rn = 1
		
		DECLARE @sum_paym_amt MONEY;
		DECLARE @sum_paym_deduction MONEY;
			
		SELECT @sum_paym_amt = SUM(payp.paym_amt) 
		FROM       FIDB.dbo.tfi_pay_m payp
		INNER JOIN FIDB.dbo.tfi_pay_m pays ON payp.paym_paycode_type = pays.paym_paycode_type AND payp.paym_pay_code = pays.paym_pay_code 
											AND payp.paym_legal = pays.paym_legal AND pays.paym_date >= payp.paym_date
		WHERE payp.isenable = 1 AND ISNULL(payp.paym_parent_id, 0) = 0 AND payp.paym_nbr LIKE 'SA47%' AND pays.paym_id = @i_mid
		AND NOT EXISTS(SELECT 1 FROM fidb.dbo.v_fi_wfing vw WHERE payp.paym_id = vw.nbr_paym_id)--ȥ������е��ո�����
		                                                                                       
		                                                                                        

		SELECT @sum_paym_deduction = SUM(scts.scts_amt_conf)
		FROM HSAL.dbo.tsa_acct_s scts 
		INNER JOIN HSAL.dbo.tsa_acct_m actm ON scts.scts_actm_id = actm.actm_id AND scts.scts_select = 1
		INNER JOIN FIDB.dbo.tfi_pay_m payp1 ON payp1.paym_id = scts.scts_from_id AND payp1.paym_ref_nbr = scts.scts_from_nbr--SA47����ϸ
		INNER JOIN FIDB.dbo.tfi_pay_m payp ON payp.paym_ref_id = actm.actm_id AND payp.paym_ref_nbr = actm.actm_nbr				--���а����Լ���SA47
		INNER JOIN FIDB.dbo.tfi_pay_m pays ON payp.paym_paycode_type = pays.paym_paycode_type AND payp.paym_pay_code = pays.paym_pay_code 
											AND payp.paym_legal = pays.paym_legal  AND pays.paym_date >= payp.paym_date
		WHERE pays.paym_id = @i_mid 
		AND payp.paym_nbr LIKE 'SA47%' AND ISNULL(payp.paym_parent_id, 0) = 0  
		AND payp1.isenable = 1 AND ISNULL(payp1.paym_parent_id, 0) = 0 
		AND NOT EXISTS(SELECT 1 FROM fidb.dbo.v_fi_wfing vw WHERE payp1.paym_id = vw.nbr_paym_id)--ȥ������е��ո�����
		AND   isnull(scts.scts_amt_conf,0)<>0                                                                               
		

		IF(ISNULL(@sum_paym_amt, 0) - ISNULL(@sum_paym_deduction, 0) >= 0 AND @bill_flag=1  
		 AND (@sum_paym_deduction IS NOT NULL OR @sum_paym_amt IS NOT NULL)
		) --����sa47���Ϊ0��Ҳ�����ڵֿۣ����ֲ�������
		BEGIN		
			-- �����տ�֪ͨ
			EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
		END
	END
	--���ⵥ�����տ�֪ͨ
	ELSE IF (@i_twf_code = 'QM03')
	BEGIN
		DECLARE @type VARCHAR(10);
		SELECT @type=clam_pay_type FROM hqis.dbo.tqa_claim_m  tcm 
		inner join FIDB.dbo.tfi_pay_m tpm on tpm.paym_ref_id=tcm.clam_id and tpm.paym_ref_nbr=tcm.clam_nbr WHERE paym_id=@i_mid;
		IF (@type = '1' AND @bill_flag=1)
		BEGIN
			EXEC rp_fi_rec_to_incomebill @i_mid; -- �����տ�֪ͨ
		END
	END
	-- ����Ӧ�յ������տ�֪ͨ
	ELSE IF(@i_twf_code = 'AR06' AND @bill_flag = 1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_other_m tpom 
	                                                           INNER JOIN FIDB.dbo.tfi_pay_m paym ON tpom.paym_id = paym.paym_ref_id
	                                                           WHERE paym_gl_type = 0 AND paym.paym_id = @i_mid))
	BEGIN
		-- �����տ�֪ͨ
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- ���ۿ��˵������տ�֪ͨ��
	ELSE IF (@i_twf_code = 'SA49' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;
	END
	-- �������������տ�֪ͨ
	ELSE IF(@i_twf_code = 'WM09' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- �������������տ�֪ͨ
	ELSE IF(@i_twf_code = 'WM08' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- �ʲ�Ͷ�������տ�֪ͨ
	ELSE IF(@i_twf_code = 'AC26' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- ��Ʒ�˿������տ�֪ͨ
	ELSE IF(@i_twf_code = 'GF03' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- ��Ʒ�˻������տ�֪ͨ
	ELSE IF(@i_twf_code = 'GF04' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- �ճ����˱��������տ�֪ͨ
	ELSE IF(@i_twf_code = 'AD05' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	-- 
	ELSE IF(@i_twf_code = 'FA07' AND @bill_flag=1)
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	--(20180829ȥ���˸��߼�)
	---- �ʽ�����������͸���֪ͨ��
	--ELSE IF(@i_twf_code = 'AC24' AND @bill_flag = 1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m  WHERE paym_nbr_flag=1 AND paym_id = @i_mid))
	--BEGIN
		--EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;				
	--END
    ---- �ʽ�������������տ�֪ͨ��
	--ELSE IF(@i_twf_code = 'AC24' AND @bill_flag = 1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m WHERE paym_nbr_flag=3 AND paym_id = @i_mid))
	--BEGIN
		--EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	--END
	
	-- ���͸���֪ͨ��
	ELSE IF(@i_twf_code = 'WG22' AND @bill_flag = 1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m  WHERE paym_nbr_flag = 2 AND paym_id = @i_mid))
	BEGIN
		EXEC rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;				
	END
    -- �����տ�֪ͨ��
	ELSE IF(@i_twf_code = 'WG22' AND @bill_flag = 1 AND EXISTS(SELECT 1 FROM FIDB.dbo.tfi_pay_m WHERE paym_nbr_flag  = 4 AND paym_id = @i_mid))
	BEGIN
		EXEC rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;			
	END
	
	 -- �ڲ����˶��˵���������/����֪ͨ��
	ELSE IF(@i_twf_code = 'AP11' AND @bill_flag = 1)
	BEGIN
		IF exists(SELECT 1 FROM dbo.tfi_inner_account_m m
		   INNER JOIN dbo.tfi_pay_m paym ON paym.paym_nbr = m.inam_nbr and paym_nbr_flag in (1,2)
		   WHERE paym.paym_id = @i_mid)
		BEGIN
			EXEC dbo.rp_fi_pay_to_billhead @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;	
		END
		ELSE IF exists(SELECT 1 FROM dbo.tfi_inner_account_m m
		   INNER JOIN dbo.tfi_pay_m paym ON paym.paym_nbr = m.inam_nbr and paym_nbr_flag in (3,4)
		   WHERE paym.paym_id = @i_mid) 
		BEGIN
			EXEC dbo.rp_fi_rec_to_incomebill @i_mid = @i_mid, @o_rntStr = @o_rntStr OUTPUT;	
		END
		IF (@o_rntStr = 'OK')
		BEGIN
			-- ��д�������Ѹ����
			UPDATE a SET isenable = 0, paym_parent_id = @i_mid,paym_real_amt=b.inad_real_amt
			,paym_status=case when a.paym_nbr_flag in (1,2) then 7 when a.paym_nbr_flag in (3,4) then 11 end
			from FIDB.dbo.tfi_pay_m a
			inner join FIDB.dbo.tfi_pay_m aa on a.paym_nbr=aa.paym_nbr and a.paym_ref_id=aa.paym_ref_id and a.paym_ref_did=aa.paym_ref_did
			inner join (
				SELECT inad_paym_id,inad_real_amt=inad_pay_amt,inam_type FROM dbo.tfi_inner_account_m m
				INNER JOIN dbo.tfi_inner_account_d d ON m.inam_id = d.inad_inam_id
				INNER JOIN dbo.tfi_pay_m paym ON paym.paym_nbr = m.inam_nbr
				WHERE paym.paym_id = @i_mid 
			) b on aa.paym_id=b.inad_paym_id
		END	
	END
	
	
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH

GO
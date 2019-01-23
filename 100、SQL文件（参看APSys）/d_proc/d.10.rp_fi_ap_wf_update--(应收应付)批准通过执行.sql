

USE [FIDB]
GO

IF(OBJECT_ID('rp_fi_ap_wf_update','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_ap_wf_update AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-03
-- Description:	��˺��������
-- Modify[1]: 2013-11-20 lzs AP07���Ӹ���֪ͨ���޸���ϸ����Ĳ���߼�
-- modify[2]: 2014-2-28 ��ε ����AP07 ��׼ͨ���󣬻�д�ɹ����˵����Ѹ�����߼�
-- modfiy[3]: ���Ӳɹ��Ļ�����߼� by liuxiang at 2014-07-08
-- modfiy[4]: �ʲ�Ͷ�ʵ�(�ⲿ)���ͨ�������տ�֪ͨ�� by luocg at 2017/07/31
-- modfiy[5]: ����֪ͨ���ӻ�����Ƿ����ִ�в��� by luocg at 2017-09-20
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_ap_wf_update]
(
	@i_wfcode VARCHAR(50)			-- ���̴���
	, @i_mid INT					-- ����id
	, @i_opcode VARCHAR(2) = '01'	-- �������룺01ͨ�� 02�˻� 05����
	, @i_userid VARCHAR(20) = 'N/A'	-- ������
	, @i_step TINYINT = 4			-- �ڵ㣺1���� 2��� 3���� 4��׼
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	/*
	DECLARE @i_wfcode VARCHAR(50);
	DECLARE @i_mid INT;
	DECLARE @i_opcode VARCHAR(2);
	DECLARE @i_userid VARCHAR(20);
	DECLARE @i_step TINYINT;
	
	SET @i_wfcode = 'AP05';
	SET @i_mid = 38;
	SET @i_opcode = '01';
	SET @i_userid = '00000001';
	SET @i_step = 4;
	*/
	--BEGIN TRAN -- ��ʼ����
	
	DECLARE @curPayId INT;
	DECLARE @optype TINYINT;
	DECLARE @rntStr VARCHAR(800);
	
	-----�������������ж�--------------------------------
	DECLARE @st INT --0�ر�  1��  -1δ����
	DECLARE @date varchar(20) --��������
	DECLARE @acctid INT 
	DECLARE @i_fmonth VARCHAR(10); --����
	-----�������������ж�--------------------------------
	                             
	
	DECLARE @fi_billhead_freez_flag INT;
	SET @fi_billhead_freez_flag = 1;
	SELECT @fi_billhead_freez_flag = ISNULL(code.code_value, 0) FROM HPORTAL.dbo.tba_code code WHERE code.code_type = 'fi_billhead_freez_flag'
	
	-- =====����֪ͨ��=====BEGIN=====
	IF (@i_wfcode = 'AP07')
	BEGIN
		IF (@i_opcode = '01') -- �ύʱ������֪ͨд��Ӧ����
		BEGIN
			-- ���
			EXEC FIDB.dbo.rp_fi_paym_split 1, @i_mid;
			-- ���ںϲ�
			EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, 2;
			
			IF (@i_step = 1)
			BEGIN
				-- ����Ӧ����
				UPDATE FIDB.dbo.tfi_billhead_m SET abhm_nbr = tba.wfna_nbr
				FROM FIDB.dbo.tfi_billhead_a tba 
				WHERE abhm_id = tba.wfna_m_id AND abhm_id = @i_mid
				
				UPDATE FIDB.dbo.tfi_billhead_d 
				SET abhd_payb_amt = (CASE WHEN abhd_payb_amt =  0 THEN 0 ELSE abhd_pay_amt END)
				    , abhd_recb_amt =(CASE WHEN abhd_recb_amt = 0 THEN 0 ELSE abhd_pay_amt END)
				WHERE abhd_abhm_id = @i_mid
				
				INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept, paym_duty, paym_date
					, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate, paym_amt,paym_nbr_amt,paym_pay_type
					,  paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_type, paym_admin_dept, paym_admin_desc, paym_duty_emp, paym_rmks, paym_status, paym_ref_nbr
					, paym_ref_id, addtime, adduser, acctid, paym_nbr_flag, paym_spl_name, paym_parent_id, paym_nbr)
				SELECT '1', ttd2.typd_typm_id, ttd2.typd_id, 1 , tbm.abhm_emp, tbm.abhm_dept, tbm.abhm_duty, tbm.abhm_date
				, tbm.abhm_pay_date, tbm.abhm_othercode_type, tbm.abhm_other_code, tbm.abhm_legal, tbm.abhm_currency, tbm.abhm_rate, tbm.abhm_pay_amt, tbm.abhm_pay_amt
				, tbm.abhm_pay_type, tbm.abhm_pay_bank, tbm.abhm_pay_name, tbm.abhm_pay_nbr, 4, tbm.abhm_pay_dept
				, (SELECT TOP(1) cc_desc FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = tbm.abhm_pay_dept), tpm.paym_duty_emp, tbm.abhm_rmks, 5, tbm.abhm_nbr
				, tbm.abhm_id, tbm.addtime, tbm.adduser, tbm.acctid, 1, fpi.pay_fname, 0, tbm.abhm_nbr
				FROM FIDB.dbo.tfi_billhead_m tbm
				INNER JOIN (SELECT TOP(1) abhd_abhm_id, abhd_m_id, abhd_d_id 
				            FROM FIDB.dbo.tfi_billhead_d 
				            WHERE abhd_abhm_id = @i_mid ORDER BY abhd_id 
							) tbd ON tbd.abhd_abhm_id = tbm.abhm_id
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.abhd_m_id
				LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.ctype = tbm.abhm_paycode_type AND fpi.pay_code = tbm.abhm_pay_code
				LEFT JOIN FIDB.dbo.tfi_type_d ttd2 ON ttd2.typd_typm_id = tpm.paym_typm_id AND ttd2.typd_wfm_code = 'AP07' 
				WHERE tbm.abhm_id = @i_mid;
				SET @curPayId = @@identity;
				-- ����parent_id��isenable=0
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = @curPayId, isenable = 0 
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
				
				--�Թ��������ͬ�����ʲɹ����˵�����д��ͬ�����Ѹ����
        		IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		BEGIN 
					UPDATE d
        			SET d.CNTD_PAID_AMT = (SELECT SUM(abhd_pay_amt) FROM fidb.dbo.tfi_billhead_d d WHERE d.abhd_abhm_id = @i_mid AND ISNULL(d.abhd_cntd_id, 0)<>0)
        			FROM fidb.dbo.tfi_contract_d d
        			WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		END
			END
			ELSE
			BEGIN
				-- ���жϻ����Ƿ񶳽�
				IF (EXISTS(SELECT 1 FROM  hpur.dbo.TPU_ACCT_M am 
					INNER JOIN  fidb.dbo.tfi_pay_m tpm  ON am.ACTM_NBR=tpm.paym_ref_nbr AND am.ACTM_ID=tpm.paym_ref_id
					INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
					WHERE tbd.abhd_abhm_id = @i_mid AND am.ACTM_FREEZ_BEGDATE <= GETDATE() AND ISNULL(am.actm_freez_enddate, GETDATE()) >= GETDATE())
					AND @fi_billhead_freez_flag = 1)-- 0�����л����Ƿ񶳽��ж�
													-- 1���л����Ƿ񶳽��жϣ�20170920��Чʹ����
					
				BEGIN
					RAISERROR (N'�ô�������ڶ������ڣ��������', 11, 1); 
				END
			END
		END
		-- ��������������/����/��׼����˻�ʱ��ɾ������֪ͨ��Ӧ����������
		IF ((@i_opcode = '05' AND @i_step = 1) OR (@i_opcode = '02' AND (@i_step = 2 OR @i_step = 3 OR @i_step = 4)))
		BEGIN
			-- ����parent_id
			UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
			-- ɾ��Ӧ��������
			DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AP07%';
			-- �ϲ�
			SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
			EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, @optype;
			
			 --�Թ��������ͬ�����ʲɹ����˵�����ԭ��ͬ�����Ѹ����
        	IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        	BEGIN 
				UPDATE d
        		SET d.CNTD_PAID_AMT = 0
        		FROM fidb.dbo.tfi_contract_d d
        		WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        	END
			
		END
		IF (@i_opcode = '10') -- ��˺��������س�����״̬
		BEGIN
			
			select  @acctid=acctid from fidb.dbo.tfi_billhead_m where  abhm_id=@i_mid
			select  @date=CONVERT(varchar(100), modtime , 23) from  fidb.dbo.tfi_billhead_m where  abhm_id=@i_mid
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AP07', @date, 1, @st OUTPUT,1
			IF ISNULL(@st,0)=0 
			BEGIN
				RAISERROR('�����ѹرգ����ܳ������.', 16, 1);
			END 
				
			--isenable2=1��˫�����ͻ����˵��ѵֿۣ����ܳ������
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id  = @i_mid AND isenable2 = 1 )
			BEGIN
				RAISERROR('˫�����ͻ����˵��ѵֿۣ����ܳ�����ɡ�', 16, 1);
			END 
			--abhm_pay_type=8��������н�ʴ���
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_type=8)
			BEGIN
				RAISERROR('������н�ʴ��������ܳ������.', 16, 1);
			END 
			--���ӶԸ���ִ�е��ļ��,�����ڸ���ִ�е�����Ҫ�ȳ�������ִ�е����ܳ�������֪ͨ��.
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE exem_status<>8 
			AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id=@i_mid and abhm_id = exem_ref_mid AND abhm_nbr = exem_ref_nbr))
			BEGIN
				DECLARE @execute_nbr VARCHAR(200);
				SELECT @execute_nbr=exem_nbr  FROM FIDB.dbo.tfi_execute_m WHERE exem_status<>8 and EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id=@i_mid and abhm_id = exem_ref_mid AND abhm_nbr = exem_ref_nbr)
				SET @execute_nbr='�ø���֪ͨ�����ڸ���ִ�е� '+ @execute_nbr +'����������������Ҫ�������ݣ������˻ظ���ִ�е���'
				RAISERROR (@execute_nbr, 11, 1); 
			END
		
			--�����ù�
			--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
			--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
	
			--��Ϊ�������ڵ���ܶ�̬���������Ҳ���ܶ�̬(������Ҫ�������ú�f.10.rp_wf_AP07.sql����֧��)��ֻ��ǿ�������жϣ������ν���������ⲻ��������
			--ʵʩҪ��,����ֻ����һ��������ɾͼ򵥵�
			IF  EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid AND tpm.paym_real_amt = tbd.abhd_pay_amt)
			BEGIN
				 ----�����ù�
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
						
				--��д��ϸ������ս��icbd_real_amt------------------�¼�begin
				--1ֱ��ȫ���д�տ���ϸ�ͼ�����Ӧ���ĸ�����ϸ(����Ȩ�淽���տ��),����������ϸ��ִ�е����ͨ��ʱ��д
				--2����Ϊ��rmbʱ����ϸ�����καұ�����Ϊ�����ұ���ϸҲֻ��Ϊ����ұ�
				--3���Գ���ʱ��ֱ�ӻ�дΪ0
				UPDATE tbd
				SET tbd.abhd_real_amt = 0
				FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_abhm_id = @i_mid;
				--��д��ϸ������ս��icbd_real_amt------------------�¼�end
				
				-- ��д�ո����� BEGIN
				-- ��д�ո������Ѹ����
				UPDATE tpm SET tpm.paym_real_amt = 0
				FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid;
				-- ��д�ո�����״̬
				UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 5 ELSE 9 END)
					WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 6 ELSE 10 END)
					ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 7 ELSE 11 END) END)
					, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				FROM FIDB.dbo.tfi_pay_m tpm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d tbd WHERE tbd.abhd_m_id = tpm.paym_id AND tbd.abhd_abhm_id = @i_mid);
				
				--����֪ͨ����Ӧ��Ӧ������paym_amt = 0 ,������0���������ִ�е��Żᴦ���д
				UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 5,isenable = 1 WHERE paym_ref_id = @i_mid AND paym_amt = 0 
				 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = paym_ref_id AND abhm_nbr = paym_nbr);
				                                                                                                                             	

				-- ��дԤ�������ս�״̬ BEGIN
				-- ��дԤ�����ֿ۽�abhm_prtn_amt
				UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) - ISNULL(abhd.abhd_pay_amt, 0.00)
				FROM FIDB.dbo.tfi_billhead_m abhm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
				INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
				WHERE abhd.abhd_abhm_id = @i_mid;
				-- дԤ����״̬:abhm_status
				UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
					, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
				FROM FIDB.dbo.tfi_billhead_m abhm
				WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr AND EXISTS (
						SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
						WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid 
					)
				);
				-- ��дԤ�������ս�״̬ END
				
				-- ��дԤ�յ����ս�״̬ BEGIN
				-- ��дԤ�յ��ֿ۽�icbm_prtn_amt
				UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) - ISNULL(abhd.abhd_pay_amt, 0.00)
				FROM FIDB.dbo.tfi_incomebill_m icbm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
				INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
				WHERE abhd.abhd_abhm_id = @i_mid ;
				-- дԤ�յ�״̬:icbm_status
				UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
					, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
				FROM FIDB.dbo.tfi_incomebill_m icbm
				WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr AND EXISTS (
						SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
						WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid 
					)
				);
				-- ��дԤ�յ����ս�״̬ END
				
				-- ��д��Ʊ�ֿ۽��
				UPDATE tiid SET tiid.ivid_offset_amt = ISNULL(tiid.ivid_offset_amt, 0.00) - ISNULL(tibr.inbr_offset_amt, 0.00)
				FROM FIDB.dbo.tfi_inv_in_d tiid
				INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
				WHERE tibr.inbr_abhm_id = @i_mid;
				-- ��д��Ʊ�ֿ�״̬
				UPDATE tiid SET tiid.ivid_offset_status = (CASE WHEN tiid.ivid_offset_amt = 0 THEN 2 WHEN ABS(tiid.ivid_offset_amt) < ABS(tiid.ivid_amt) THEN 3 ELSE 4 END)
					, tiid.modtime = GETDATE(), tiid.moduser = @i_userid
				FROM FIDB.dbo.tfi_inv_in_d tiid
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_inv_bill_r tibr WHERE tibr.inbr_ivid_id = tiid.ivid_id AND tibr.inbr_abhm_id = @i_mid);
				
				-- �����֪ͨ���н���տ�����д���Ѹ����
				UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) - b.abhd_pay_amt
				FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
				INNER JOIN (
					select sum(ISNULL(tbd.abhd_pay_amt, 0.00)) abhd_pay_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
					from FIDB.dbo.tfi_pay_m paym 
					INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = paym.paym_id
					WHERE paym.paym_nbr_flag=4 and tbd.abhd_abhm_id = @i_mid and paym_nbr like 'AC15%' 
					group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR
					and (tbmm.brmm_lr_code=b.paym_pay_code OR 
					(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)	
					
				
			END	
			IF (@i_step = 1) AND  NOT EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_billhead_d d ON d.abhd_m_id = tpm.paym_id
				WHERE d.abhd_abhm_id = @i_mid AND tpm.paym_parent_id = 0 AND tpm.isenable = 1)		-- ����ڵ㳷����ɼӺϲ�Ӧ���߼�
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser =  pm.paym_pay_bank+@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				
				-- ����parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND abhd_m_id = paym_id);
				-- ɾ��Ӧ��������
				DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AP07%';
				-- �ϲ�
				SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
				EXEC FIDB.dbo.rp_fi_paym_merge 1, @i_mid, @optype;
				
				 --�Թ��������ͬ�����ʲɹ����˵�����ԭ��ͬ�����Ѹ����
        		IF EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		BEGIN 
					UPDATE d
        			SET d.CNTD_PAID_AMT = 0
        			FROM fidb.dbo.tfi_contract_d d
        			WHERE d.cntd_id = (SELECT TOP 1 abhd_cntd_id FROM fidb.dbo.tfi_billhead_d WHERE abhd_abhm_id = @i_mid AND ISNULL(abhd_cntd_id, 0) <> 0 )
        		END
				
			END	
			
			--ɾ����������
			SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
			EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AP07', @i_fmonth, @i_mid	
			
		END
		IF (@i_opcode = '01' AND @i_step = 4) -- ���ͨ�����д���ݽ�״̬
		BEGIN
			-- ���жϻ����Ƿ񶳽�
			IF (EXISTS(SELECT 1 FROM  hpur.dbo.TPU_ACCT_M am 
				INNER JOIN  fidb.dbo.tfi_pay_m tpm  ON am.ACTM_NBR=tpm.paym_ref_nbr AND am.ACTM_ID=tpm.paym_ref_id
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
				WHERE tbd.abhd_abhm_id = @i_mid AND am.ACTM_FREEZ_BEGDATE <= GETDATE() AND ISNULL(am.actm_freez_enddate, GETDATE()) >= GETDATE())
				AND @fi_billhead_freez_flag = 1)-- 0�����л����Ƿ񶳽��ж�
												-- 1���л����Ƿ񶳽��жϣ�20170920��Чʹ����
			BEGIN
				RAISERROR (N'�ô�������ڶ������ڣ��������', 11, 1); 
			END

			-- ��д�ո����� BEGIN
			-- ��д�ո������Ѹ����
			UPDATE tpm SET 
			tpm.paym_pay_type = tbm.abhm_pay_type,
			tpm.paym_real_amt = (CASE WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN ISNULL(tpm.paym_real_amt, 0.00) + ISNULL(tbd.abhd_pay_amt, 0.00) ELSE tpm.paym_real_amt END)
			FROM FIDB.dbo.tfi_pay_m tpm
			INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = tpm.paym_id
			INNER JOIN FIDB.dbo.tfi_billhead_m tbm ON tbd.abhd_abhm_id = tbm.abhm_id
			WHERE tbd.abhd_abhm_id = @i_mid;
			-- ��д�ո�����״̬
			UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 5 ELSE 9 END)
				WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5)  THEN 6 ELSE 10 END)
				ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2, 5) THEN 7 ELSE 11 END) END)
				, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
			FROM FIDB.dbo.tfi_pay_m tpm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_d tbd WHERE tbd.abhd_m_id = tpm.paym_id AND tbd.abhd_abhm_id = @i_mid);--����֪ͨ��Ȩ�淽��ϸ��Ӧ��Ӧ��Ӧ������
			
			--����֪ͨ����Ӧ��Ӧ������paym_amt = 0 ,������0���������ִ�е��Żᴦ���д
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 7,isenable = 0 WHERE paym_ref_id = @i_mid AND paym_amt = 0 
			AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = paym_ref_id AND abhm_nbr = paym_nbr);
			
			-- ��дԤ�������ս�״̬ BEGIN
			-- ��дԤ�����ֿ۽�abhm_prtn_amt
			UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) + ISNULL(abhd.abhd_pay_amt, 0.00)
			FROM FIDB.dbo.tfi_billhead_m abhm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
			INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
			WHERE abhd.abhd_abhm_id = @i_mid;
			-- дԤ����״̬:abhm_status
			UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
				, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
			FROM FIDB.dbo.tfi_billhead_m abhm
			WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr AND EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
					WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid
				)
			);
			-- ��дԤ�������ս�״̬ END
			
			-- ��дԤ�յ����ս�״̬ BEGIN
			-- ��дԤ�յ��ֿ۽�abhm_prtn_amt
			UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) + ISNULL(abhd.abhd_pay_amt, 0.00)
			FROM FIDB.dbo.tfi_incomebill_m icbm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
			INNER JOIN FIDB.dbo.tfi_billhead_d abhd ON abhd.abhd_m_id = tpm.paym_id
			WHERE abhd.abhd_abhm_id = @i_mid;
			-- дԤ�յ�״̬:abhm_status
			UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_inc_amt) THEN 6 ELSE 7 END)
				, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
			FROM FIDB.dbo.tfi_incomebill_m icbm
			WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr AND EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_billhead_d abhd
					WHERE abhd.abhd_m_id = tpm.paym_id AND abhd.abhd_abhm_id = @i_mid
				)
			);
			-- ��дԤ�յ����ս�״̬ END
			
			-- ��д��Ʊ�ֿ۽��
			UPDATE tiid SET tiid.ivid_offset_amt = ISNULL(tiid.ivid_offset_amt, 0.00) + ISNULL(tibr.inbr_offset_amt, 0.00)
			FROM FIDB.dbo.tfi_inv_in_d tiid
			INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
			WHERE tibr.inbr_abhm_id = @i_mid;
			
			IF exists (select 1 FROM FIDB.dbo.tfi_inv_in_d tiid
				INNER JOIN FIDB.dbo.tfi_inv_bill_r tibr ON tibr.inbr_ivid_id = tiid.ivid_id
				WHERE tibr.inbr_abhm_id = @i_mid AND tiid.ivid_offset_amt<tibr.inbr_offset_amt)
			BEGIN
					RAISERROR (N'��д��Ʊ�ֿ۽�����ϵͳ�쳣��', 16, 1); 
			END
			
			-- ��д��Ʊ�ֿ�״̬
			UPDATE tiid SET tiid.ivid_offset_status = (CASE WHEN tiid.ivid_offset_amt = 0 THEN 2 WHEN ABS(tiid.ivid_offset_amt) < ABS(tiid.ivid_amt) THEN 3 ELSE 4 END)
				, tiid.modtime = GETDATE(), tiid.moduser = @i_userid
			FROM FIDB.dbo.tfi_inv_in_d tiid
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_inv_bill_r tibr WHERE tibr.inbr_ivid_id = tiid.ivid_id AND tibr.inbr_abhm_id = @i_mid);
			
			-- �����֪ͨ���н���տ�����д���Ѹ����
			UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) + b.abhd_pay_amt
			FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
			INNER JOIN (
				select sum(ISNULL(tbd.abhd_pay_amt, 0.00)) abhd_pay_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				from FIDB.dbo.tfi_pay_m paym 
				INNER JOIN FIDB.dbo.tfi_billhead_d tbd ON tbd.abhd_m_id = paym.paym_id
				WHERE paym_nbr_flag=4 and tbd.abhd_abhm_id = @i_mid and paym_nbr like 'AC15%' 
				group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
			) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
				and (tbmm.brmm_lr_code=b.paym_pay_code OR 
				(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)	
			
			
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_amt = 0)
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_m 
				SET paym_status = 7, isenable = 0
				FROM FIDB.dbo.tfi_billhead_m m
				WHERE paym_ref_id = m.abhm_id AND paym_ref_nbr = m.abhm_nbr AND m.abhm_id = @i_mid;
				
				UPDATE FIDB.dbo.tfi_billhead_m SET abhm_status = 7 WHERE abhm_id = @i_mid;
			END
			
			--��д����֪ͨ����ϸ����Ѹ�����ֶ�-----------begin---(ֱ��ȫ���д�տ���ϸ�ͼ�����Ӧ���ĸ�����ϸ(����Ȩ�淽���տ��),����������ϸ��ִ�е����ͨ��ʱ��д)
			--����Ϊ��rmbʱ����ϸ�����καұ�����Ϊ�����ұ���ϸҲֻ��Ϊ����ұ�
			DECLARE @sum_abhd_real_amt MONEY;--��ϸ(��)���ܶ�
			DECLARE @temp_abhd_id INT;--��ϸ(��)did
			DECLARE @temp_abhm_curr VARCHAR(10);--�ұ�
			                                   
			SELECT  @temp_abhm_curr = abhm_currency FROM fidb.dbo.tfi_billhead_m WHERE abhm_id = @i_mid
			
			SET @sum_abhd_real_amt = (SELECT SUM(tbd.abhd_pay_amt * tbd.abhd_rate  )--ȫת��rmb
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(3,4,6))--��ϸ(��)
		
			--��һ��,ֱ�ӻ�д��ϸ�Ѹ����(�ֿ۲���)
			UPDATE tbd
			SET tbd.abhd_real_amt = tbd.abhd_pay_amt--���ܱұ�
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(3,4,6)--��ϸ(��)
			
			IF OBJECT_ID('tempdb..#temp_d_pay') IS NOT NULL DROP TABLE #temp_d_pay;		
			SELECT tbd.* ,pm.paym_date
			INTO #temp_d_pay  
			FROM fidb.dbo.tfi_billhead_d tbd
			INNER  JOIN fidb.dbo.tfi_billhead_m tbm  ON tbm.abhm_id = tbd.abhd_abhm_id 
			INNER JOIN fidb.dbo.tfi_pay_m pm ON pm.paym_id=tbd.abhd_m_id
			WHERE tbm.abhm_type=  1 AND  tbd.abhd_abhm_id  = @i_mid AND tbd.abhd_bill_type IN(1,2,5)--��ϸ(��)
                                    
			
			WHILE((@sum_abhd_real_amt>0) AND EXISTS (SELECT 1 FROM #temp_d_pay))
			BEGIN
				SET @temp_abhd_id = (SELECT TOP 1 abhd_id FROM #temp_d_pay ORDER BY paym_date ASC)
				
				UPDATE tbd
				SET tbd.abhd_real_amt = (
					CASE WHEN @sum_abhd_real_amt > tbd.abhd_pay_amt *tbd.abhd_rate   --����ϸ�����ֿ�ʱ
					THEN tbd.abhd_pay_amt 
					ELSE @sum_abhd_real_amt/tbd.abhd_rate END) 
				FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_id = @temp_abhd_id
				
				SET @sum_abhd_real_amt = @sum_abhd_real_amt-
				(SELECT tbd.abhd_real_amt* abhd_rate  FROM fidb.dbo.tfi_billhead_d tbd WHERE tbd.abhd_id = @temp_abhd_id )
				
				--ѭ��ɾ��
				DELETE FROM #temp_d_pay WHERE abhd_id = @temp_abhd_id
			END
			
			DROP TABLE #temp_d_pay
		                                                         
			
			--��д����֪ͨ����ϸ����Ѹ�����ֶ�-----------end---(ֱ��ȫ���д�տ���ϸ�ͼ�����Ӧ���ĸ�����ϸ(����Ȩ�淽���տ��),����������ϸ��ִ�е����ͨ��ʱ��д)
			
			
			
			----֧����ʽΪн�ʴ���������н�ʴ�����ֱ�ӻ�дΪ�Ѹ���������ִ�е�(��ִ�е�job�ж�)���Ҳ��ܳ�������ap07�����жϣ�
		 --   IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m WHERE abhm_id = @i_mid AND abhm_pay_type = 8)
			--BEGIN
			--	DECLARE @hwag_month VARCHAR(20);
			--	DECLARE @hwag_emp VARCHAR(20);
			--	DECLARE @hwag_amt MONEY;
			--	DECLARE @abhm_nbr VARCHAR(20);
			--	DECLARE @abhm_pay_dept VARCHAR(20);
			--	DECLARE @abhm_emp VARCHAR(50);
			--	DECLARE @hwag_remark VARCHAR(1000);
			--	DECLARE @o_errmsg VARCHAR(1000);
			--	SET @o_errmsg = 'OK';
				
			--	SELECT @hwag_emp = m.abhm_other_code
			--		, @hwag_amt = m.abhm_pay_amt*m.abhm_rate
			--		, @hwag_month = (SELECT mon.mMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE m.modtime BETWEEN mon.mBegdate AND mon.mEndtime)
			--		, @abhm_nbr = m.abhm_nbr
			--		, @abhm_pay_dept = m.abhm_pay_dept
			--		, @abhm_emp = m.abhm_emp
			--		, @hwag_remark = '����֪ͨ����'+ m.abhm_nbr + '���͵�н�ʴ���, ��'+ + CAST(CAST(@hwag_amt AS DECIMAL(19, 2)) AS VARCHAR(19)) + 'RMB'
			--	FROM FIDB.dbo.tfi_billhead_m m WHERE m.abhm_id = @i_mid
			--	-- ����н�ʴ�����
			--	EXEC HWAG.dbo.rp_wg_receivable @hwag_month, 3, @hwag_emp, @hwag_amt,@abhm_nbr, @abhm_pay_dept, @abhm_emp, @hwag_remark, @o_errmsg OUT;
			--	IF(@o_errmsg = 'OK')
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_billhead_m SET abhm_status = 7, abhm_real_amt = abhm_pay_amt 
			--		, abhm_rmks = abhm_rmks +'(������н�ʴ���)'
			--		WHERE abhm_id = @i_mid;
					
			--		UPDATE FIDB.dbo.tfi_pay_m 
			--		SET paym_status = 7, isenable = 0, paym_real_amt = paym_amt
			--		FROM FIDB.dbo.tfi_billhead_m m
			--		WHERE paym_ref_id = m.abhm_id AND paym_ref_nbr = m.abhm_nbr AND m.abhm_id = @i_mid;
			--	END	
				
			--END
		END
	END
	-- =====����֪ͨ��=====END=====
	
	-- =====Ԥ��֪ͨ��=====BEGIN=====
		IF (@i_wfcode = 'AP08')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- ���ͨ�����д���ݽ�״̬
			BEGIN
			    EXEC rp_fi_billhead_to_execute @i_exem_emp = '',@i_mid = @i_mid, @o_rntStr = @rntStr OUTPUT;
				IF (@rntStr <> 'OK')
				BEGIN
					RAISERROR(@rntStr, 16, 1);
				END
			END
			IF (@i_opcode = '10' AND @i_step = 4) -- ��׼�ڵ㳷��ͨ��
			BEGIN
			    --������������ִ�е������ܳ���
				IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m  WHERE abhm_id  =  @i_mid AND
									EXISTS (SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE  exem_ref_mid = abhm_id AND exem_ref_nbr = abhm_nbr AND exem_status>4 AND exem_status<>8 )
									)
				BEGIN
						RAISERROR (N'Ԥ��֪ͨ�����ɵ�ִ�е�����ˣ����ȳ���ִ�е���', 16, 1); 
				END
				--������δ������ִ�е���ɾ��
				ELSE IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_billhead_m  WHERE abhm_id  =  @i_mid AND
									EXISTS (SELECT 1 FROM FIDB.dbo.tfi_execute_m WHERE  exem_ref_mid = abhm_id AND exem_ref_nbr = abhm_nbr AND exem_status <= 4)
									)
				BEGIN
					DECLARE @exem_id INT; 
					SELECT @exem_id = em.exem_id 
					FROM FIDB.dbo.tfi_billhead_m bm
					INNER JOIN FIDB.dbo.tfi_execute_m em ON bm.abhm_id = em.exem_ref_mid AND bm.abhm_nbr=em.exem_ref_nbr
					WHERE bm.abhm_id = @i_mid
					
					--ɾ��ִ�е�
					DELETE HPORTAL.dbo.twf_a WHERE wfna_table='fidb.dbo.tfi_execute_a' AND  wfna_m_id =@exem_id
					DELETE fidb.dbo.tfi_execute_a WHERE wfna_m_id =@exem_id
					DELETE fidb.dbo.tfi_execute_m WHERE exem_id = @exem_id
				END
			END
			
		END
	-- =====Ԥ��֪ͨ��=====END=====
	
	-- =====�տ�֪ͨ��=====BEGIN=====
	IF (@i_wfcode = 'AR07')
	BEGIN
		IF(@i_opcode = '99')
		BEGIN
				-- ������ˮ���������: ��ˮֱ�ӻ�дƥ�����״̬��
				DECLARE @atsp_tx_id INT;
				DECLARE @atsp_id INT;
					
				DECLARE @fi_is_cash_atsp INT;
				SET @fi_is_cash_atsp = 0;
				
				SET @atsp_id = 0;
				SELECT @fi_is_cash_atsp = ISNULL(code.code_value, 0) FROM HPORTAL.dbo.tba_code code WHERE code.code_type = 'fi_is_cash_atsp'
				-- �ж��Ƿ����ֽ�֧��
				IF (EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m m WHERE m.icbm_id = @i_mid AND m.icbm_rec_type = 1) AND @fi_is_cash_atsp = 1)
				BEGIN 
					-- ����Ѿ�ƥ����ˮ�ģ�����ƥ�䡣
					DECLARE @actr_id_99 INT = 0;
					WHILE EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_relation rela
							  INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
							  WHERE icbm.icbm_id = @i_mid)
					BEGIN
						SELECT TOP(1) @actr_id_99 = actr_id 
						FROM FIDB.DBO.tfi_account_tx_relation rela
						INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
						WHERE icbm.icbm_id = @i_mid
				        
						UPDATE icbm
						SET icbm_real_amt = ISNULL(icbm_real_amt, 0.00) - rela.actr_amt, icbm_status = 10, modtime = GETDATE(), moduser = @i_userid
						FROM FIDB.DBO.tfi_account_tx_relation rela
						INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr        
						WHERE rela.actr_id = @actr_id_99
						
						-- ɾ���������ˮ����
						--SELECT @atsp_id = actr_atsp_id FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id_99 
						--IF(SELECT COUNT(1) FROM FIDB.dbo.tfi_dealing_match_m tdmm
						--			INNER JOIN FIDB.dbo.tfi_dealing_match_d tdmd ON tdmm.tdmm_id = tdmd.tdmd_tdmm_id
						--   WHERE tdmm_atsp_id = @atsp_id) = 1
						--BEGIN
						UPDATE FIDB.dbo.tfi_dealing_match_m SET isenable = 0 WHERE tdmm_atsp_id = @atsp_id
						--END
						--ELSE
						--BEGIN
						--	RAISERROR('���տ�֪ͨ���Ѿ��ֹ�ƥ����ˮ�����ȼ���ֹ�ƥ���Ƿ�����',16,1);
						--END
						
						
						DELETE FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id_99
										
						IF EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_split atsp WHERE atsp.atsp_nbr LIKE 'AR07%' AND atsp_id = @atsp_id)
						BEGIN
							UPDATE FIDB.dbo.tfi_balance 
          					SET blnc_balance = blnc_balance + ISNULL(actx.actx_amt_out - actx.actx_amt_in, 0), blnc_date = GETDATE(), modtime = GETDATE(), moduser = @i_userid
          					FROM FIDB.DBO.tfi_account_tx actx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id)
								
							DELETE FROM FIDB.DBO.tfi_account_tx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id)
							
							DELETE FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id;
						END
						ELSE
						BEGIN
							UPDATE FIDB.DBO.tfi_account_tx_split SET atsp_rmks = '', atsp_status = 0, modtime = GETDATE(), moduser = @i_userid
							WHERE atsp_id = @atsp_id;
							
							UPDATE FIDB.DBO.tfi_account_tx SET actx_confirm = actx_confirm - atsp_amt, actx_state = (CASE WHEN actx_confirm - atsp_amt = 0 THEN 0 ELSE 1 END), modtime = GETDATE(), moduser = @i_userid
							FROM FIDB.DBO.tfi_account_tx_split
							WHERE atsp_id = @atsp_id AND actx_id = atsp_txid
						END	
						
					END
					
					SET @atsp_id = 0;
					INSERT INTO dbo.tfi_account_tx(actx_acct_id, actx_nbr, actx_cust_name, actx_cust_bank, actx_cust_acct
					            , actx_curr_type, actx_tx_time, actx_tx_rate,actx_amt_in, actx_amt_out, actx_confirm, actx_balance, actx_type
					            , actx_brief, actx_cust, actx_state, addtime, adduser, acctid, isenable, actx_ref_nbr)
					SELECT tim.icbm_acct_id, tim.icbm_nbr, '', '', '', tim.icbm_currency
						, tim.icbm_rec_date, tim.icbm_rate, tim.icbm_inc_amt, 0, tim.icbm_inc_amt, ISNULL(tb.blnc_balance, 0) + tim.icbm_inc_amt, 0
						, tim.icbm_rmks, tim.icbm_rec_code, 2, GETDATE(), @i_userid, tim.acctid, 1, tim.icbm_nbr
					FROM FIDB.dbo.tfi_incomebill_m tim
					LEFT JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
					WHERE tim.icbm_id = @i_mid 
					SET @atsp_tx_id = @@identity;
					-- ������ˮ��ֱ�����
					INSERT INTO FIDB.dbo.tfi_account_tx_split
					   (atsp_txid, atsp_nbr, atsp_adduser, atsp_cust, atsp_cust_bank, atsp_cust_name, atsp_cust_acct
					   , atsp_curr, atsp_date,atsp_rate, atsp_acct_id, atsp_acct_code, atsp_rmks
					   , atsp_type, atsp_seq, atsp_sum_amt, atsp_amt, atsp_status, atsp_pay_type, addtime, adduser, acctid)
					SELECT @atsp_tx_id, tim.icbm_nbr, tim.icbm_emp, '', '', '', ''
					, tim.icbm_currency, tim.icbm_rec_date, tim.icbm_rate, tim.icbm_acct_id, ISNULL(acct.acct_department,''), tim.icbm_rmks
					, 1, 1, tim.icbm_inc_amt, tim.icbm_inc_amt, 2, 0, GETDATE(), tim.icbm_emp, tim.acctid              
					FROM FIDB.dbo.tfi_incomebill_m tim
					LEFT JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
					LEFT JOIN FIDB.dbo.tfi_account acct ON acct.acct_id = tim.icbm_acct_id AND acct.acct_class = 0
					WHERE tim.icbm_id = @i_mid 
					SET @atsp_id=@@identity
					-- BEGIN ��д��dbo.tfi_balance,�޼�¼�����룬�м�¼������
					IF(EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim 
							  INNER JOIN FIDB.dbo.tfi_balance tb ON tim.icbm_acct_id = tb.blnc_acct_id AND tb.blnc_curr_type = tim.icbm_currency
							  WHERE tim.icbm_id = @i_mid AND tb.blnc_type=1))
					BEGIN
          				UPDATE FIDB.dbo.tfi_balance 
          				SET blnc_balance = blnc_balance + ISNULL(tim.icbm_inc_amt, 0)
						, blnc_date = GETDATE(), modtime = GETDATE(), moduser = tim.icbm_emp
          				FROM FIDB.dbo.tfi_incomebill_m tim 
						WHERE blnc_acct_id = tim.icbm_acct_id AND blnc_curr_type = tim.icbm_currency AND tim.icbm_id = @i_mid AND blnc_type = 1 
					END
					ELSE
					BEGIN
        				INSERT INTO FIDB.dbo.tfi_balance 
        				(blnc_acct_id, blnc_curr_type, blnc_balance, blnc_type, blnc_date, isenable, addtime, adduser, acctid)
        				SELECT tim.icbm_acct_id, tim.icbm_currency, tim.icbm_inc_amt, 1
        				, GETDATE(), 1, GETDATE(), tim.icbm_emp, tim.acctid
        				FROM FIDB.dbo.tfi_incomebill_m tim 
						WHERE tim.icbm_id = @i_mid
					END
					-- END ��д��dbo.tfi_balance,�޼�¼�����룬�м�¼������
			    
					--	д��ϵ��tfi_account_tx_relation
					INSERT INTO FIDB.dbo.tfi_account_tx_relation 
					(actr_atsp_id, actr_bill_id, actr_bill_nbr, actr_bill_type, actr_amt, actr_tablename, actr_type, acctid, addtime, adduser) 
					SELECT @atsp_id, tim.icbm_id, tim.icbm_nbr, 1, tim.icbm_inc_amt, 'FIDB.dbo.tfi_incomebill_m', 1, tim.acctid, GETDATE(), tim.icbm_emp
					FROM FIDB.dbo.tfi_incomebill_m tim  
					WHERE tim.icbm_id = @i_mid
					-- ���²�ֱ�״̬Ϊ��ƥ��
					UPDATE FIDB.dbo.tfi_account_tx_split SET atsp_status = 2 WHERE atsp_id = @atsp_id
					-- ���²�ֱ�״̬Ϊ��ƥ��
					UPDATE FIDB.dbo.tfi_account_tx SET actx_state = 2 WHERE actx_id = @atsp_tx_id 
					-- ���¸���ִ�е�����
					UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_real_amt = icbm_inc_amt, icbm_status = 11
					WHERE icbm_id = @i_mid
				END
			END
		IF (@i_opcode = '01') -- �ύʱ���տ�֪ͨд��Ӧ����
		BEGIN
			-- ���
			EXEC FIDB.dbo.rp_fi_paym_split 0, @i_mid;
			-- ���ںϲ�
			EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, 2;
			
			IF (@i_step = 1)
			BEGIN
				-- ����Ӧ����
				UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_nbr = tba.wfna_nbr
				FROM FIDB.dbo.tfi_incomebill_a tba 
				WHERE icbm_id = tba.wfna_m_id AND icbm_id = @i_mid
				
				UPDATE FIDB.dbo.tfi_incomebill_d 
				SET icbd_payb_amt = (CASE WHEN icbd_payb_amt =  0 THEN 0 ELSE icbd_rec_amt END)
				    , icbd_recb_amt =(CASE WHEN icbd_recb_amt = 0 THEN 0 ELSE icbd_rec_amt END)
				WHERE icbd_icbm_id = @i_mid
				
				INSERT INTO FIDB.dbo.tfi_pay_m (paym_item, paym_typm_id, paym_typd_id, paym_flag, paym_emp, paym_dept, paym_duty
					, paym_date
					, paym_due_date, paym_paycode_type, paym_pay_code, paym_legal, paym_currency, paym_rate, paym_amt,paym_nbr_amt,paym_pay_type
					,  paym_pay_bank, paym_pay_name, paym_pay_nbr, paym_admin_type, paym_admin_dept, paym_admin_desc
					, paym_duty_emp, paym_rmks, paym_status
					, paym_ref_nbr, paym_ref_id, addtime, adduser, acctid, paym_nbr_flag, paym_spl_name, paym_parent_id, paym_nbr)
				SELECT '3', ttd2.typd_typm_id, ttd2.typd_id, 1, tbm.icbm_emp, tbm.icbm_dept, tbm.icbm_duty
					, (CASE WHEN tpm.paym_nbr LIKE 'SA47%' THEN (SELECT TOP 1 DATEADD(day,1,actm_enddate) FROM HSAL.dbo.tsa_acct_m WHERE actm_nbr = tpm.paym_nbr) ELSE tbm.icbm_date END )
					, tbm.icbm_rec_date, tbm.icbm_reccode_type, tbm.icbm_rec_code, tbm.icbm_legal, tbm.icbm_currency, tbm.icbm_rate, tbm.icbm_inc_amt, tbm.icbm_inc_amt, tbm.icbm_rec_type
					, tbm.icbm_rec_bank, tbm.icbm_rec_company, tbm.icbm_rec_acct, 4, tbm.icbm_rec_dept, (SELECT TOP(1) cc_desc FROM FIDB.dbo.v_fi_dept dept WHERE dept.cc_code = tbm.icbm_rec_dept)
					, tpm.paym_duty_emp, tbm.icbm_rmks, 9
					, tbm.icbm_nbr, tbm.icbm_id, tbm.addtime, tbm.adduser, tbm.acctid, 3, fpi.pay_fname, 0, tbm.icbm_nbr
				FROM FIDB.dbo.tfi_incomebill_m tbm
				INNER JOIN (SELECT TOP(1) icbd_icbm_id, icbd_m_id, icbd_d_id
				            FROM FIDB.dbo.tfi_incomebill_d
				            WHERE icbd_icbm_id = @i_mid ORDER BY icbd_id) tbd ON tbd.icbd_icbm_id = tbm.icbm_id
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_id = tbd.icbd_m_id
				LEFT JOIN FIDB.dbo.v_fi_paycode_info fpi ON fpi.ctype = tbm.icbm_reccode_type AND fpi.pay_code = tbm.icbm_rec_code
				LEFT JOIN FIDB.dbo.tfi_type_d ttd2 ON ttd2.typd_typm_id = tpm.paym_typm_id AND ttd2.typd_wfm_code = 'AR07' 
				WHERE tbm.icbm_id = @i_mid;
				SET @curPayId = @@identity;
				-- ����parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = @curPayId, isenable = 0 WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
				);
			END
		END
		-- ��������������/����/��׼����˻�ʱ��ɾ���տ�֪ͨ��Ӧ����������
		IF ((@i_opcode = '05' AND @i_step = 1) OR (@i_opcode = '02' AND (@i_step = 2 OR @i_step = 3 OR @i_step = 4)))
		BEGIN
			-- ����parent_id
			UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 WHERE EXISTS (
				SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
			);
			-- ɾ��Ӧ��������
			DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AR07%';
			-- �ϲ�
			SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
			EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, @optype;
		END
		IF (@i_opcode = '01' AND @i_step = 4) -- ���ͨ�����д���ݽ�״̬
		BEGIN
			-- ��д�ո����ݼ�״̬ BEGIN
			-- ��д�ո������Ѹ����
			UPDATE tpm SET tpm.paym_real_amt = ISNULL(tpm.paym_real_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_pay_m tpm
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- ��д�ո�����״̬
			UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 5 ELSE 9 END)
				WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 6 ELSE 10 END)
				ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 7 ELSE 11 END) END)
				, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
			FROM FIDB.dbo.tfi_pay_m tpm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid);
			
			--�տ�֪ͨ����Ӧ��Ӧ������paym_amt = 0 ,������0���������ƥ��Żᴦ���д
			UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 11, isenable = 0
			WHERE paym_amt = 0 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_id = paym_ref_id AND icbm_nbr = paym_nbr);
			
			-- ��дӦ�������ݼ�״̬ END
			
			-- ��дԤ�������ս�״̬ BEGIN
			-- ��дԤ�����ֿ۽�abhm_prtn_amt
			UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_billhead_m abhm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- дԤ����״̬:abhm_status
			UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
				, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
			FROM FIDB.dbo.tfi_billhead_m abhm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
						  WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr 
						  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
									  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
						);
			-- ��дԤ�������ս�״̬ END
			
			-- ��дԤ�յ����ս�״̬ BEGIN
			-- ��дԤ�յ��ֿ۽�abhm_prtn_amt
			UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) + ISNULL(icbd.icbd_rec_amt, 0.00)
			FROM FIDB.dbo.tfi_incomebill_m icbm
			INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
			INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
			WHERE icbd.icbd_icbm_id = @i_mid;
			-- дԤ����״̬:abhm_status
			UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
				, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
			FROM FIDB.dbo.tfi_incomebill_m icbm
			WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
			              WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr 
			              AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
									  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
						);
			-- ��дԤ�յ����ս�״̬ END
			
			-- �����֪ͨ���н���տ�����д���Ѹ����
			UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) + b.icbd_rec_amt
			FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
			INNER JOIN (
				select sum(ISNULL(tbd.icbd_rec_amt, 0.00)) icbd_rec_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				from FIDB.dbo.tfi_pay_m paym 
				INNER JOIN FIDB.dbo.tfi_incomebill_d tbd ON tbd.icbd_m_id = paym.paym_id
				WHERE paym_nbr_flag=4 and tbd.icbd_icbm_id = @i_mid and paym.paym_nbr like 'AC15%' 
				group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
			) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
				and (tbmm.brmm_lr_code=b.paym_pay_code OR 
				(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)
			
			
			IF EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_inc_amt = 0)
			BEGIN
				UPDATE FIDB.dbo.tfi_pay_m 
				SET paym_status = 11, isenable = 0
				FROM FIDB.dbo.tfi_incomebill_m m
				WHERE paym_ref_id = m.icbm_id AND paym_ref_nbr = m.icbm_nbr AND m.icbm_id = @i_mid;
				
				UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 11 WHERE icbm_id = @i_mid;
			END
			
			--��д�տ�֪ͨ����ϸ������ս���ֶ�-----------begin---(ֱ�ӻ�д������ϸ�ͼ�����Ӧ�����տ���ϸ,�����տ���ϸ��ƥ��ʱ��д)
			--����Ϊ��rmbʱ����ϸ�����καұ�����Ϊ�����ұ���ϸҲֻ��Ϊ����ұ�
			DECLARE @sum_icbd_real_amt MONEY;--��ϸ(��)���ܶ�
			DECLARE @temp_icbd_id INT;--��ϸ(��)did
			DECLARE @temp_icbm_curr VARCHAR(10);--�ұ�
			                                   
			SELECT  @temp_icbm_curr = icbm_currency FROM fidb.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid
			
			SET @sum_icbd_real_amt = (SELECT SUM(tid.icbd_rec_amt *(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END )  )
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			WHERE tim.icbm_type=  1 AND  tid.icbd_icbm_id = @i_mid AND tid.icbd_bill_type IN(1,2,5))--��ϸ(��)
		
			--��һ��,ֱ�ӻ�д��ϸ���ս��
			UPDATE tid
			SET tid.icbd_real_amt = tid.icbd_rec_amt--���ܱұ�
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			WHERE tim.icbm_type=  1 AND tid.icbd_icbm_id = @i_mid AND tid.icbd_bill_type IN(1,2,5)--��ϸ(��)
			
			IF OBJECT_ID('tempdb..#temp_d') IS NOT NULL DROP TABLE #temp_d;		
			SELECT tid.* ,pm.paym_date
			INTO #temp_d  
			FROM fidb.dbo.tfi_incomebill_d tid
			INNER  JOIN fidb.dbo.tfi_incomebill_m tim ON tim.icbm_id = tid.icbd_icbm_id
			INNER JOIN fidb.dbo.tfi_pay_m pm ON pm.paym_id=tid.icbd_m_id
			WHERE tim.icbm_type=  1 AND  tid.icbd_icbm_id=@i_mid AND tid.icbd_bill_type IN(3,4,6)--��ϸ(��)
                                    
			
			WHILE((@sum_icbd_real_amt>0) AND EXISTS (SELECT 1 FROM #temp_d))
			BEGIN
				SET @temp_icbd_id = (SELECT TOP 1 icbd_id FROM #temp_d ORDER BY paym_date ASC)
				
				UPDATE tid
				SET tid.icbd_real_amt = (
					CASE WHEN @sum_icbd_real_amt > tid.icbd_rec_amt *(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END )  --����ϸ�����ֿ�ʱ
					THEN tid.icbd_rec_amt 
					ELSE @sum_icbd_real_amt/(CASE WHEN @temp_icbm_curr='RMB' THEN tid.icbd_rate ELSE 1 END ) END) 
				FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_id = @temp_icbd_id
				
				SET @sum_icbd_real_amt = @sum_icbd_real_amt-
				(SELECT tid.icbd_real_amt*(CASE WHEN @temp_icbm_curr='RMB' THEN icbd_rate ELSE 1 END )  FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_id = @temp_icbd_id )
				
				--ѭ��ɾ��
				DELETE FROM #temp_d WHERE icbd_id = @temp_icbd_id
			END
			
			DROP TABLE #temp_d
		                                                         
			
			--��д�տ�֪ͨ����ϸ������ս���ֶ�----------end---(ֱ�ӻ�д������ϸ�ͼ�����Ӧ�����տ���ϸ,�����տ���ϸ��ƥ��ʱ��д)
			
			
			---- н�ʴ���(����н�ʴ���)
			--IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid AND tim.icbm_reccode_type = 2 AND tim.icbm_rec_type = 7)
			--BEGIN
			--	SET @o_errmsg = 'OK';
				
			--	SELECT @hwag_emp = tim.icbm_rec_code, @hwag_amt = tim.icbm_inc_amt 
			--	FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid;
			--	-- ����н�ʴ��۵�
			--	EXEC HWAG.dbo.rp_wg_receivable '', 2, @hwag_emp, @hwag_amt, '', @o_errmsg OUT;
			--	IF(@o_errmsg = 'OK')
			--	BEGIN
			--		UPDATE FIDB.dbo.tfi_incomebill_m SET icbm_status = 11, icbm_real_amt = @hwag_amt, icbm_rmks = icbm_rmks+' (������н�ʴ���)' WHERE icbm_id = @i_mid
					
			--		UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 11, paym_real_amt = @hwag_amt, isenable = 0 
			--		WHERE paym_nbr = (SELECT icbm_nbr FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid)
			--	END
				
			--END
		END
		IF (@i_opcode = '10') -- ���������ɵĵ���д���ݽ�״̬
		BEGIN
			-- н�ʴ���
			IF EXISTS(SELECT 1 FROM FIDB.dbo.tfi_incomebill_m tim WHERE tim.icbm_id = @i_mid AND tim.icbm_rec_type = 7)
			BEGIN
				RAISERROR (N'֧����ʽΪн�ʴ��۵ģ�����������', 16, 1); 
			END
			IF EXISTS(
			SELECT 1 FROM fidb.dbo.tfi_dealing_match_m m
			INNER JOIN fidb.dbo.tfi_dealing_match_d d ON d.tdmd_tdmm_id = m.tdmm_id
			INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = d.tdmd_bill_id AND d.tdmd_bill_nbr = icbm.icbm_nbr
			WHERE m.tdmm_status <> 6 AND icbm.icbm_id = @i_mid)
			OR EXISTS( SELECT 1 FROM fidb.dbo.tfi_incomebill_m m  where m.icbm_id = @i_mid AND m.icbm_real_amt<>0)
			BEGIN
				RAISERROR (N'�����Ѿ�ƥ��������ˮ�����ȳ���ƥ�䣡', 16, 1); 
			END
			
			select  @acctid=acctid from fidb.dbo.tfi_incomebill_m WHERE icbm_id =@i_mid
			select  @date=CONVERT(varchar(100), modtime , 23) from  fidb.dbo.tfi_incomebill_m WHERE icbm_id=@i_mid
			EXEC R6ERP.dbo.rp_fi_account_getStatus 1, 'AR07', @date, 1, @st OUTPUT,1
			IF (ISNULL(@st,0)=0 AND  @i_step <> 5)--�տ���ֹ����ʾ���ڹر�
			BEGIN
				RAISERROR('�����ѹرգ����ܳ������.', 16, 1);
			END 
			--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+10 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
			
			--��Ϊ�������ڵ���ܶ�̬���������Ҳ���ܶ�̬(������Ҫ�������ú�f.10.rp_wf_AR07.sql����֧��)��ֻ��ǿ�������жϣ������ν���������ⲻ��������
			--ʵʩҪ��,����ֻ����һ��������ɾͼ򵥵�
			IF  EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid AND tpm.paym_real_amt = icbd.icbd_rec_amt)
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = @i_step+20 from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END

				-- ɾ��ƥ���ϵ,���߼�ȥ��,�ж�ƥ���˾Ͳ�������������߼�
				--DECLARE @actr_id INT = 0;
				--DECLARE @atsp_id_2 INT = 0;
				--WHILE EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_relation rela
				--		  INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
				--          WHERE icbm.icbm_id = @i_mid)
				--BEGIN
				--	SELECT TOP(1) @actr_id = actr_id 
				--	FROM FIDB.DBO.tfi_account_tx_relation rela
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr
			 --       WHERE icbm.icbm_id = @i_mid
			        
				--	UPDATE icbm
				--	SET icbm_real_amt = ISNULL(icbm_real_amt, 0.00) - rela.actr_amt, icbm_status = 10, modtime = GETDATE(), moduser = @i_userid
				--	FROM FIDB.DBO.tfi_account_tx_relation rela
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m icbm ON icbm.icbm_id = rela.actr_bill_id AND rela.actr_bill_nbr = icbm.icbm_nbr        
				--	WHERE rela.actr_id = @actr_id
					
				--	--������տ�֪ͨ����icbm_status = 9(����)
				--	UPDATE FIDB.DBO.tfi_incomebill_m SET icbm_status = 9, icbm_isreceived = 0, icbm_acct_id = 0 WHERE icbm_id = @i_mid AND icbm_real_amt = 0;
			
				--	UPDATE tpm SET tpm.paym_real_amt = tim.icbm_real_amt
				--	FROM FIDB.dbo.tfi_pay_m tpm 
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m tim ON tim.icbm_id = tpm.paym_ref_id AND tpm.paym_ref_nbr = tim.icbm_nbr
				--	WHERE tim.icbm_id = @i_mid;
					
				--	UPDATE tpm SET tpm.paym_status=(CASE WHEN tpm.paym_real_amt = 0 THEN 9 WHEN (tpm.paym_amt > tpm.paym_real_amt) THEN 10 ELSE 11 END)
				--	, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				--	FROM FIDB.dbo.tfi_pay_m tpm 
				--	INNER JOIN FIDB.dbo.tfi_incomebill_m tim ON tim.icbm_id = tpm.paym_ref_id AND tpm.paym_ref_nbr = tim.icbm_nbr
				--	WHERE tim.icbm_id = @i_mid;
				--	-- ɾ���������ˮ����
				--	SELECT @atsp_id_2 = actr_atsp_id FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id 
				--	DELETE FROM FIDB.DBO.tfi_account_tx_relation WHERE actr_id = @actr_id	
						
				--	IF EXISTS(SELECT 1 FROM FIDB.DBO.tfi_account_tx_split atsp WHERE atsp.atsp_nbr LIKE 'AR07%' AND atsp_id = @atsp_id_2)
				--	BEGIN
				--		UPDATE FIDB.dbo.tfi_balance 
	   --       			SET blnc_balance = blnc_balance + ISNULL(actx.actx_amt_out - actx.actx_amt_in, 0), blnc_date = GETDATE(), modtime = GETDATE(), moduser = @i_userid
	   --       			FROM FIDB.DBO.tfi_account_tx actx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2)
							
				--		DELETE FROM FIDB.DBO.tfi_account_tx WHERE actx_id = (SELECT atsp_txid FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2)
				--		DELETE FROM FIDB.DBO.tfi_account_tx_split WHERE atsp_id = @atsp_id_2;
				--	END
				--	ELSE
				--	BEGIN
				--		UPDATE FIDB.DBO.tfi_account_tx_split SET atsp_rmks = '', atsp_status = 0, modtime = GETDATE(), moduser = @i_userid
				--		WHERE atsp_id = @atsp_id_2;
				--	END		
							
				--END
				-- ��д�ո����ݼ�״̬ BEGIN
				-- ��д��ϸ���Ӧ��paym����
				UPDATE tpm SET tpm.paym_real_amt = ISNULL(tpm.paym_real_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- ��д��ϸ���Ӧ��paym����״̬
				UPDATE tpm SET tpm.paym_status = (CASE WHEN tpm.paym_real_amt = 0 THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 5 ELSE 9 END)
					WHEN ABS(tpm.paym_real_amt) < ABS(tpm.paym_amt) THEN (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 6 ELSE 10 END)
					ELSE (CASE WHEN tpm.paym_nbr_flag IN (1, 2) THEN 7 ELSE 11 END) END)
					, tpm.modtime = GETDATE(), tpm.moduser = @i_userid
				FROM FIDB.dbo.tfi_pay_m tpm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid);
				
				-- �����֪ͨ���н���տ�����д���Ѹ����
				UPDATE tbmm SET tbmm.BRMM_PAID_AMT = ISNULL(tbmm.BRMM_PAID_AMT, 0.00) - b.icbd_rec_amt
				FROM FIDB.dbo.TFI_BORROW_MONEY_M tbmm
				INNER JOIN (
					select sum(ISNULL(tbd.icbd_rec_amt, 0.00)) icbd_rec_amt ,paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
					from FIDB.dbo.tfi_pay_m paym 
					INNER JOIN FIDB.dbo.tfi_incomebill_d tbd ON tbd.icbd_m_id = paym.paym_id
					WHERE paym_nbr_flag=4 and tbd.icbd_icbm_id = @i_mid and paym.paym_nbr like 'AC15%' 
					group by paym.paym_ref_nbr,paym.paym_ref_id,paym_pay_code
				) b on b.paym_ref_id = tbmm.BRMM_ID AND b.paym_ref_nbr = tbmm.BRMM_NBR 
					and (tbmm.brmm_lr_code=b.paym_pay_code OR 
					(SELECT vc.ficn_code FROM fidb.dbo.VFI_CORPORATION vc WHERE vc.ficn_id=brmm_lr_legal)=b.paym_pay_code)
					
				
				--��д��ϸ������ս��icbd_real_amt------------------�¼�begin
				UPDATE tid
				SET tid.icbd_real_amt = 0
				FROM fidb.dbo.tfi_incomebill_d tid WHERE tid.icbd_icbm_id = @i_mid;
				--��д��ϸ������ս��icbd_real_amt------------------�¼�end
				
									
				--�տ�֪ͨ����Ӧ��Ӧ������paym_amt = 0 ,������0���������ƥ��Żᴦ���д	
				UPDATE FIDB.dbo.tfi_pay_m SET paym_status = 9, isenable =1
				WHERE paym_amt = 0 AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_m WHERE icbm_id = @i_mid AND icbm_id = paym_ref_id AND icbm_nbr = paym_nbr);
				-- ��дӦ�������ݼ�״̬ END
				
				-- ��дԤ�������ս�״̬ BEGIN
				-- ��дԤ�����ֿ۽�abhm_prtn_amt
				UPDATE abhm SET abhm.abhm_prtn_amt = ISNULL(abhm.abhm_prtn_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_billhead_m abhm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- дԤ����״̬:abhm_status
				UPDATE abhm SET abhm.abhm_status = (CASE WHEN abhm.abhm_prtn_amt = 0 THEN 9 WHEN ABS(abhm.abhm_prtn_amt) < ABS(abhm.abhm_pay_amt) THEN 10 ELSE 11 END)
					, abhm.modtime = GETDATE(), abhm.moduser = @i_userid
				FROM FIDB.dbo.tfi_billhead_m abhm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
							  WHERE tpm.paym_ref_id = abhm.abhm_id AND tpm.paym_ref_nbr = abhm.abhm_nbr 
							  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
										  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
							);
				-- ��дԤ�������ս�״̬ END
				
				-- ��дԤ�յ����ս�״̬ BEGIN
				-- ��дԤ�յ��ֿ۽�abhm_prtn_amt
				UPDATE icbm SET icbm.icbm_prtn_amt = ISNULL(icbm.icbm_prtn_amt, 0.00) - ISNULL(icbd.icbd_rec_amt, 0.00)
				FROM FIDB.dbo.tfi_incomebill_m icbm
				INNER JOIN FIDB.dbo.tfi_pay_m tpm ON tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid;
				-- дԤ����״̬:abhm_status
				UPDATE icbm SET icbm.icbm_status = (CASE WHEN icbm.icbm_prtn_amt = 0 THEN 5 WHEN ABS(icbm.icbm_prtn_amt) < ABS(icbm.icbm_pay_amt) THEN 6 ELSE 7 END)
					, icbm.modtime = GETDATE(), icbm.moduser = @i_userid
				FROM FIDB.dbo.tfi_incomebill_m icbm
				WHERE EXISTS (SELECT 1 FROM FIDB.dbo.tfi_pay_m tpm 
							  WHERE tpm.paym_ref_id = icbm.icbm_id AND tpm.paym_ref_nbr = icbm.icbm_nbr 
							  AND EXISTS (SELECT 1 FROM FIDB.dbo.tfi_incomebill_d icbd
										  WHERE icbd.icbd_m_id = tpm.paym_id AND icbd.icbd_icbm_id = @i_mid)
							);
				-- ��дԤ�յ����ս�״̬ END
			END
			IF (@i_step = 1) AND  NOT EXISTS (SELECT 1  FROM FIDB.dbo.tfi_pay_m tpm
				INNER JOIN FIDB.dbo.tfi_incomebill_d icbd ON icbd.icbd_m_id = tpm.paym_id
				WHERE icbd.icbd_icbm_id = @i_mid AND tpm.paym_parent_id = 0 AND tpm.isenable = 1)		-- ����ڵ㳷����ɼӺϲ�Ӧ���߼�
			BEGIN
				--IF(@i_step = 1) BEGIN     UPDATE pm  SET pm.paym_pay_bank = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948  END 
				--else IF(@i_step = 2) BEGIN   UPDATE pm  SET pm.paym_pay_name = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 3)  BEGIN  UPDATE pm  SET pm.adduser = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				--else IF(@i_step = 4) BEGIN   UPDATE pm  SET pm.moduser = pm.paym_pay_bank +@i_step from fidb.dbo.tfi_pay_m pm WHERE paym_id=761948 END
				
				-- ����parent_id
				UPDATE FIDB.dbo.tfi_pay_m SET paym_parent_id = 0, isenable = 1 WHERE EXISTS (
					SELECT 1 FROM FIDB.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @i_mid AND icbd_m_id = paym_id
				);
				-- ɾ��Ӧ��������
				DELETE FROM FIDB.dbo.tfi_pay_m WHERE paym_ref_id = @i_mid AND paym_ref_nbr LIKE 'AR07%';
				-- �ϲ�
				SET @optype = (CASE WHEN @i_opcode = '02' THEN 0 ELSE 1 END);
				EXEC FIDB.dbo.rp_fi_paym_merge 0, @i_mid, @optype;
			END
			
			--ɾ����������
			SELECT @i_fmonth = mon.fMonth FROM HPORTAL.dbo.contrast_monthf mon WHERE @date BETWEEN mon.mBegdate AND mon.mEndtime
			EXEC FIDB.dbo.rp_fi_gl_delete_v3 2, 'AR07', @i_fmonth, @i_mid	
			
		END
	END	
	-- =====�տ�֪ͨ��=====END=====
	
   -- =====�ʲ�Ͷ�ʵ�=====BEGIN=====
		IF (@i_wfcode = 'AC26')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- ���ͨ��
			BEGIN
				IF ((SELECT tcim_type FROM  fidb.dbo.tfi_capital_investment_m WHERE tcim_id = @i_mid ) = 2 ) --�ⲿͶ��ʱ
				BEGIN
					DECLARE @nbr_type INT;				   -- �������� 1:Ӧ��;2:����Ӧ��;3:Ӧ��;4:����Ӧ��.
					DECLARE @twf_code VARCHAR(100);		   -- ����code
					DECLARE @paym_emp VARCHAR(20);		   -- ������
					DECLARE @paym_dept VARCHAR(20);		   -- ���벿��code
					DECLARE @paym_duty INT;				   -- �����˸�λ
					DECLARE @paym_due_date DATETIME;	   -- Ӧ������
					DECLARE @paym_paycode_type TINYINT;	   -- �Է����� 1:��Ӧ��;2:����;3:�ͻ�;
					DECLARE @paym_pay_code VARCHAR(20);	   -- �Է�����
					DECLARE @paym_legal INT;			   -- Ӧ������ 
					DECLARE @paym_currency VARCHAR(10);	   -- �ұ�
					DECLARE @paym_rate DECIMAL(19, 7);	   -- ����
					DECLARE @paym_amt MONEY;			   -- Ӧ�����
					DECLARE @paym_pay_type TINYINT;		   -- ֧����ʽ 1: �ֽ�2��ת��
					DECLARE @paym_pay_bank VARCHAR(100);   -- ������
					DECLARE @paym_pay_name VARCHAR(100);   -- ������
					DECLARE @paym_pay_nbr VARCHAR(50);	   -- �����˺�                          	   
					DECLARE @paym_admin_type INT;			-- ���������� 1:��Ӧ��;2:����;3:�ͻ�;4:����;
					DECLARE @paym_admin_dept VARCHAR(20);	-- ����������
					DECLARE @paym_admin_desc VARCHAR(200)	-- ����������
					DECLARE @paym_duty_emp VARCHAR(20);	   -- ����������
					DECLARE @paym_rmks VARCHAR(200);	   -- ��ע
					DECLARE @paym_ref_id INT;			   -- ��������id
					DECLARE @paym_ref_did INT;			   -- ��������did
					DECLARE @paym_ref_nbr VARCHAR(20);	   -- ��������
					--DECLARE @acctid INT;					-- acctid
					DECLARE @o_paym_id INT ;				-- ����Ӧ����id
					DECLARE @o_paym_nbr VARCHAR(20);		 -- ����Ӧ������
					DECLARE @paym_date DATETIME = NULL	     -- ҵ��������
					SET @rntStr = 'OK';
					
					SELECT  
						@nbr_type = 4
					    , @twf_code = @i_wfcode
						, @paym_emp = tcim.tcim_emp
						, @paym_dept = tcim.tcim_dept
						, @paym_duty = tcim.tcim_duty
						, @paym_due_date = tcim.tcim_begin_date
						, @paym_paycode_type = tcim.tcim_paycode_type
						, @paym_pay_code = tcim.tcim_pay_code
						, @paym_legal = tcid.tcid_legal
						, @paym_currency = tcim.tcim_curr
						, @paym_rate = hportal.dbo.rf_ba_getrate(tcim.acctid, ISNULL(tcim.tcim_curr,'RMB'),'RMB',GETDATE())
						, @paym_amt = tcim.tcim_amt
						, @paym_pay_type = 2 --ת��
						, @paym_pay_bank = ''		-- ������
						, @paym_pay_name = ''		-- ������
						, @paym_pay_nbr = ''		-- �����˺�       
						, @paym_admin_type = 0		-- ���������� 1:��Ӧ��;2:����;3:�ͻ�;4:����;
						, @paym_admin_dept = ''		-- ����������
						, @paym_admin_desc = ''		-- ����������
						, @paym_duty_emp  = ''	    -- ����������
						, @paym_rmks  = tcim.tcim_rmks	  
						, @paym_ref_id = tcim.tcim_id	  
						, @paym_ref_did = tcid.tcid_id		
						, @paym_ref_nbr = tcim.tcim_nbr		
						, @acctid = tcim.acctid			
						, @paym_date  = NULL	-- ҵ��������
					FROM tfi_capital_investment_m tcim
					LEFT JOIN tfi_capital_investment_d tcid on tcid.tcid_tcim_id = tcim.tcim_id
					WHERE tcim.tcim_id = @i_mid
					
					-- �����������ְ��ȡ���ŵ�һ������
					--IF(NOT EXISTS(SELECT emp_id FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @paym_emp))
					--BEGIN
					--	DECLARE @cc_level VARCHAR(100);
					--	SELECT @cc_level = cm.cc_level FROM HR90.dbo.cc_mstr1 cm WHERE cm.cc_code = @paym_dept;
					--	SELECT @paym_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@cc_level,'','','',1);
					--END
					
					--�����տ�֪ͨ��
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
						, @rntStr OUTPUT
				END
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
			END
		END
	--  =====�ʲ�Ͷ�ʵ�=====END=====
	
	   -- =====�ͻ��˿=====BEGIN=====
		IF (@i_wfcode = 'AP12')
		BEGIN
			IF (@i_opcode = '01' AND @i_step = 4) -- ���ͨ��
			BEGIN
					SET @rntStr = 'OK';
					
					SELECT   
						@nbr_type = 4
					    , @twf_code = @i_wfcode
						, @paym_emp = m.rfdm_emp
						, @paym_dept = m.rfdm_dept
						, @paym_duty = m.rfdm_duty  
						, @paym_due_date = m.rfdm_pay_date
						, @paym_paycode_type = m.rfdm_code_type
						, @paym_pay_code = m.rfdm_code
						, @paym_legal = m.rfdm_pay_legal
						, @paym_currency = m.rfdm_currency
						, @paym_rate = m.rfdm_rate
						, @paym_amt = m.rfdm_pay_amt
						, @paym_pay_type = m.rfdm_pay_type
						, @paym_pay_bank = m.rfdm_pay_bank
						, @paym_pay_name = m.rfdm_pay_name
						, @paym_pay_nbr = m.rfdm_pay_nbr
						, @paym_admin_type = 4					-- ���������� 1:��Ӧ��;2:����;3:�ͻ�;4:����;
						, @paym_admin_dept = m.rfdm_pay_dept	-- ����������
						, @paym_admin_desc = (SELECT TOP 1 cc_desc FROM fidb.dbo.v_fi_dept WHERE cc_code = m.rfdm_pay_dept)		-- ����������
						, @paym_duty_emp  = m.rfdm_emp 	   -- ����������
						, @paym_rmks  = m.rfdm_rmks
						, @paym_ref_id = m.rfdm_id
						, @paym_ref_did = 0
						, @paym_ref_nbr = m.rfdm_nbr
						, @acctid = m.acctid			
						, @paym_date  = NULL	-- ҵ��������
					FROM fidb.dbo.tfi_refound_m m
					WHERE m.rfdm_id = @i_mid
					
					
					--�����տ�����
					EXEC FIDB.dbo.rp_fi_add_apacV2
						  2
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
						, @rntStr OUTPUT
				
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
				
				--���ɸ���֪ͨ��
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
					, @rntStr OUTPUT
				
				IF @rntStr <> 'OK'
				BEGIN
					RAISERROR (@rntStr, 16, 1); 
				END
			END
		END
	--  =====�ͻ��˿=====END=====
	
	
	
	
	--IF (@@TRANCOUNT > 0)
	--BEGIN
	--	COMMIT TRAN -- �ύ����
	--END
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	--IF (@@TRANCOUNT > 0)
	--BEGIN
	--	ROLLBACK TRAN  -- ������ع�����
	--END
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
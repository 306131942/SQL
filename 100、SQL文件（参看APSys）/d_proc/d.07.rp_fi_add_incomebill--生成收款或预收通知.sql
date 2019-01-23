USE FIDB
GO

IF(OBJECT_ID('rp_fi_add_incomebill','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_incomebill AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		������
-- Create date: 2013-10-23
-- Description:	�����տ�/Ԥ��֪ͨ�����ύ������
-- Modify[1]: 2014-4-23 liuxiang ������ְ��Ա�Ĵ����߼������Ҳ����ϼ���������������Ա�ֹ�������һ�����̵ĵ���
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_add_incomebill]
(
	
	@i_wfcode VARCHAR(20)				-- �ĸ��������� AR05(Ӧ��->�տ�) 
	, @i_icbm_type TINYINT				-- �տ����� 1�տ� 2Ԥ��
	, @i_icbm_item VARCHAR(20)			-- ��ƿ�Ŀ
	, @i_icbm_emp VARCHAR(20)			-- ������
	, @i_icbm_dept VARCHAR(20)			-- ���벿��code
	, @i_icbm_duty INT					-- �����˸�λ
	, @i_icbm_legal INT					-- ����
	, @i_icbm_reccode_type TINYINT		-- �Է����� 2����3�ͻ�
	, @i_icbm_rec_code VARCHAR(20)		-- �Է�����
	, @i_icbm_rec_type TINYINT			-- �տʽ
	, @i_icbm_currency VARCHAR(10)		-- �ұ�
	, @i_icbm_rec_bank VARCHAR(100)			-- ��������
	, @i_icbm_rec_company VARCHAR(100)		-- �������
	, @i_icbm_rec_acct VARCHAR(50)			-- �����˺�
	--, @i_icbm_rate DECIMAL(19, 7)		-- ����(�տ�֪ͨ����ȡ���»���)
	, @i_icbm_amt MONEY					-- Ӧ�ս��
	, @i_icbm_pay_amt MONEY				-- Ӧ�����
	, @i_icbm_inc_amt MONEY				-- �տ���/Ԥ�ս��
	, @i_icbm_rec_date DATETIME			-- �տ�����
	, @i_icbm_rmks VARCHAR(800)			-- ��ע
	, @i_icbm_ref_id INT				-- ��������ID   --���������������ɵ�paym���ݵ�id(����SA47��Ӧ��)
	, @i_acctid INT						-- acctid
	, @o_icbm_id INT OUTPUT				-- �����տid
	, @o_icbm_nbr VARCHAR(20) OUTPUT	-- �����տ��
	, @o_rntStr VARCHAR(800) OUTPUT		-- ����ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	SET @o_rntStr = 'OK';
	DECLARE @icbm_dept_level VARCHAR(20);
	
	DECLARE @wfmid INT; -- ����id
	DECLARE @summary VARCHAR(200); -- ������summary
	DECLARE @paym_id INT; -- ��Ʒ����Ӧ��id
    DECLARE @icbm_rate DECIMAL(19, 7); -- ����
    DECLARE @paym_nbr VARCHAR(20); -- ҵ�񵥺�
    DECLARE @nbr VARCHAR(20); -- ҵ�񵥺�
                                   
    DECLARE @paym_id_s INT; -- �ظ��ֿ�paym_id
    DECLARE @icbd_id_s INT; -- �ظ��ֿ�d_id
    
	IF (@i_icbm_ref_id = 0 OR @i_icbm_ref_id IS NULL)
	BEGIN -- ��������Ϊ��
		SET @o_rntStr = '���͵���Ϊ�գ����������տ�/Ԥ��֪ͨ����';
	END
	IF @i_icbm_type = 1 AND EXISTS (SELECT 1 FROM tfi_incomebill_m tim WHERE tim.icbm_status <> 8 AND EXISTS (
		SELECT 1 FROM tfi_incomebill_d tid
		WHERE tid.icbd_icbm_id = tim.icbm_id AND tid.icbd_m_id = @i_icbm_ref_id))
	BEGIN
		SET @o_rntStr = CAST(@i_icbm_ref_id AS VARCHAR(10)) + '�ŵ��Ѵ����տ�֪ͨ����';
	END
	ELSE
	BEGIN -- �����տ�֪ͨ��
	    IF(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_icbm_emp))
		BEGIN
			DECLARE @temp_emp VARCHAR(20);
			SELECT @icbm_dept_level = cc_level FROM HR90.dbo.cc_mstr1 WHERE cc_code = @i_icbm_dept;
			SELECT @temp_emp = RTRIM(emp_id) FROM HPORTAL.dbo.rf_wf_GetLeader2(@icbm_dept_level, '', '', '', 1);
			
			IF(NOT EXISTS ( SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp))
			BEGIN
				SET @temp_emp=@i_icbm_emp
			END 
			
			DECLARE @i_while INT;
			SET @i_while = 0;
			WHILE(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp) AND @i_while < 3)
			BEGIN
				SELECT @temp_emp=de_directlyunder_emp_id FROM HR90.dbo.v_emp_duty_all WHERE emp_id = @temp_emp and de_type_id=0
				SET @i_while = @i_while + 1;
			END
			
			IF(EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @temp_emp))
			BEGIN
			SET @i_icbm_emp = @temp_emp;
			END
		END
	    IF(NOT EXISTS(SELECT 1 FROM HR90.dbo.h_emp_all hea WHERE hea.emp_id = @i_icbm_emp))
	    BEGIN
	    	DECLARE @re_code VARCHAR(10);
			DECLARE @re_icbm_name VARCHAR(20);
			DECLARE @re_summry VARCHAR(200);
			DECLARE @re_aid INT;
			DECLARE @re_rid VARCHAR(20);
			DECLARE @a_table VARCHAR(50);
			DECLARE @re_nbr VARCHAR(20);
			
			SELECT @re_nbr = LEFT(paym_ref_nbr,4) FROM FIDB.dbo.tfi_pay_m WHERE paym_id = @i_icbm_ref_id;
			SET @re_code = LEFT(@re_nbr,4);
			SET @re_summry='�տ�֪ͨ��(AR07)������Ӧ���б����Ӧ�ձ����в�ѯ���õ��ݽ����ֹ����� �տ�֪ͨ��(AR07)'
			
			IF OBJECT_ID('tempdb..#re_icbm_remind') IS NOT NULL
			BEGIN
				DROP TABLE #re_icbm_remind;
			END
			CREATE TABLE #re_icbm_remind(
				re_aid INT,
				re_rid VARCHAR(20)
			);
			SELECT TOP(1) @a_table = a_table FROM FIDB.dbo.v_fi_twfm WHERE wfm_code = @re_code;
			EXEC ('INSERT INTO #re_icbm_remind SELECT wfna_id,wfna_emp_id FROM '+ @a_table +' WHERE LEN(wfna_wf_route) - LEN(REPLACE(wfna_wf_route,'','','''')) = 3 AND wfna_m_id = '+@i_icbm_ref_id);
	
			WHILE EXISTS(SELECT 1 FROM #re_icbm_remind)
			BEGIN
				SELECT TOP(1) @re_aid = re_aid,@re_rid = re_rid FROM #re_icbm_remind ORDER BY re_aid DESC;
				
				IF EXISTS(SELECT 1 FROM HR90.dbo.h_emp_mstr hea WHERE hea.emp_id = @re_rid)
				BEGIN

					SELECT @re_icbm_name = emp_name FROM FIDB.dbo.v_fi_empmstr WHERE emp_id = @i_icbm_emp;
					SET @re_summry = '��������'+isnull(@re_icbm_name,'')+'('+isnull(@i_icbm_emp,'')+') ��ְ�����µ��� '+isnull(@re_nbr,'')+' �޷��Զ����� ' + @re_summry;
					
					EXEC HPORTAL.dbo.rp_wf_remind @re_code,@re_rid, 3, @re_summry, @o_rntStr OUTPUT;
				END
				
				DELETE FROM #re_icbm_remind WHERE re_aid = @re_aid;
			END
			DROP TABLE #re_abhm_remind ;
	    END
	    ELSE
	    BEGIN
			SET @icbm_rate = HPORTAL.dbo.rf_ba_getrate(@i_acctid, @i_icbm_currency, 'RMB', GETDATE()); -- ȡ���»���
			IF (@i_wfcode = 'AR05')
			BEGIN
	    		SET @i_icbm_item = '3';
			END
			ELSE
			BEGIN
	    		SET @i_icbm_item = '5'
			END
			-- ��������begin
			EXEC fidb.dbo.rp_fi_get_tmpnbr 'tfi_incomebill_m', 'icbm_nbr', @nbr OUTPUT
			INSERT INTO tfi_incomebill_m (
				icbm_type
				, icbm_nbr
				, icbm_item
				, icbm_emp
				, icbm_dept
				, icbm_rec_dept
				, icbm_duty
				, icbm_pemr_code
				, icbm_date
				, icbm_legal
				, icbm_reccode_type
				, icbm_rec_code
				, icbm_rec_type
				, icbm_currency
				, icbm_rate
				, icbm_amt
				, icbm_pay_amt
				, icbm_inc_amt
				, icbm_rec_date
				, icbm_rec_bank 			-- ��������
				, icbm_rec_company 			-- �������
				, icbm_rec_acct 			-- �����˺�
				, icbm_rmks
				, icbm_status
				, adduser
				, acctid
			) VALUES (
				@i_icbm_type
				, @nbr
				, @i_icbm_item
				, @i_icbm_emp
				, @i_icbm_dept
				, (SELECT paym.paym_admin_dept FROM FIDB.dbo.tfi_pay_m paym WHERE paym.paym_id = @i_icbm_ref_id)
				, @i_icbm_duty
				, (select top 1 pemr_code from hr90.dbo.thr_person_mstr where pemr_emp_id = @i_icbm_emp AND pemr_duty_id = @i_icbm_duty)
				, CONVERT(VARCHAR(10), GETDATE(), 23)
				, @i_icbm_legal
				, @i_icbm_reccode_type
				, @i_icbm_rec_code
				, @i_icbm_rec_type
				, @i_icbm_currency
				, @icbm_rate
				, @i_icbm_amt
				, @i_icbm_pay_amt
				, @i_icbm_inc_amt
				, @i_icbm_rec_date
				, @i_icbm_rec_bank 			-- ��������
				, @i_icbm_rec_company 		-- �������
				, @i_icbm_rec_acct 			-- �����˺�
				, @i_icbm_rmks
				, 1
				, @i_icbm_emp
				, @i_acctid
			);
			SET @o_icbm_id = @@identity; 
			-- ��������end
			
			-- �����ӱ�begin
			IF (@i_wfcode = 'AR05') -- Ӧ��->�տ�
			BEGIN
				INSERT INTO tfi_incomebill_d (
					icbd_icbm_id
					, icbd_bill_type
					, icbd_m_id
					, icbd_d_id
					, icbd_currency
					, icbd_rate
					, icbd_rec_amt
					, icbd_rmks
					, icbd_payb_amt
					, icbd_recb_amt
					, icbd_real_amt
					, adduser
					, acctid
				) VALUES (
					@o_icbm_id
					, (SELECT tpm.paym_nbr_flag FROM FIDB.dbo.tfi_pay_m tpm WHERE tpm.paym_id = @i_icbm_ref_id)
					, @i_icbm_ref_id
					, 0
					, @i_icbm_currency
					, @icbm_rate
					, @i_icbm_amt
					, @i_icbm_rmks
					, 0
					, @i_icbm_amt
					, 0
					, @i_icbm_emp
					, @i_acctid
				);
				
				SELECT @paym_nbr = paym_nbr FROM tfi_pay_m WHERE paym_id = @i_icbm_ref_id;
				IF (LEFT(@paym_nbr, 4) = 'GF03')
				BEGIN
					-- ��Ʒ�˿����Ʒ����
					SELECT @paym_id = tpm.paym_id
					FROM tfi_pay_m tpm
					WHERE EXISTS (SELECT 1 FROM HOAM.dbo.tgf_list_m 
					              WHERE gflm_refid = tpm.paym_ref_id AND gflm_refnbr = tpm.paym_nbr 
									AND EXISTS (SELECT 1 FROM tfi_pay_m tpm1 WHERE tpm1.paym_id = @i_icbm_ref_id AND gflm_id = paym_ref_id)) 
					AND tpm.paym_status IN (9, 10) AND tpm.paym_parent_id = 0 AND NOT EXISTS (SELECT 1 FROM v_fi_wfing WHERE nbr_paym_id = paym_id);
					
					IF (@paym_id IS NULL)
					BEGIN
						SET @o_rntStr = '��Ӧ����Ʒ����Ӧ�յ���ռ�ÿ����Ƕ�Ӧ��ҵ������δ������';
						RAISERROR('��Ӧ����Ʒ����Ӧ�յ���ռ�ÿ����Ƕ�Ӧ��ҵ������δ������', 16, 1);
					END
					ELSE
					BEGIN
						INSERT INTO tfi_incomebill_d (
							icbd_icbm_id
							, icbd_bill_type
							, icbd_m_id
							, icbd_d_id
							, icbd_currency
							, icbd_rate
							, icbd_rec_amt
							, icbd_rmks
							, icbd_payb_amt
							, icbd_recb_amt
							, icbd_real_amt
							, adduser
							, acctid
						)
						SELECT
							@o_icbm_id
							, paym_nbr_flag
							, tpm.paym_id
							, 0
							, tpm.paym_currency
							, tpm.paym_rate
							, ABS(@i_icbm_amt)
							, tpm.paym_rmks
							, 0
							, tpm.paym_amt
							, 0
							, @i_icbm_emp
							, @i_acctid
						FROM tfi_pay_m tpm
						WHERE tpm.paym_id = @paym_id;
						
						UPDATE tfi_incomebill_m SET icbm_amt = 0, icbm_inc_amt = 0 WHERE icbm_id = @o_icbm_id;
					END
				END
				IF (LEFT(@paym_nbr, 4) = 'GF04')
				BEGIN
					-- ��Ʒ������Ʒ�˻�
							SELECT @paym_id = pm.paym_id
							FROM fidb.dbo.tfi_pay_m pm
							left join hoam.dbo.tgf_list_m m ON pm.paym_ref_id= m.gflm_refid AND pm.paym_ref_nbr = m.gflm_refnbr --GF04
							LEFT JOIN fidb.dbo.tfi_pay_m tpm ON m.gflm_id = tpm.paym_ref_id AND m.gflm_nbr = tpm.paym_ref_nbr
							WHERE tpm.paym_id = @i_icbm_ref_id AND pm.isenable = 1  AND pm.paym_pay_code=tpm.paym_pay_code
					
					IF (isnull(@paym_id,0)=0)
					BEGIN
						SET @o_rntStr = '��Ӧ����Ʒ��ⵥ�����쳣';
						RAISERROR('��Ӧ����Ʒ��ⵥ�����쳣', 16, 1);
					END
					ELSE
					BEGIN
						INSERT INTO tfi_incomebill_d (
							icbd_icbm_id
							, icbd_bill_type
							, icbd_m_id
							, icbd_d_id
							, icbd_currency
							, icbd_rate
							, icbd_rec_amt
							, icbd_rmks
							, icbd_payb_amt
							, icbd_recb_amt
							, icbd_real_amt
							, adduser
							, acctid
						)
						SELECT
							@o_icbm_id
							, tpm.paym_nbr_flag
							, tpm.paym_id
							, 0
							, tpm.paym_currency
							, tpm.paym_rate
							, tpm.paym_amt
							, tpm.paym_rmks
							, tpm.paym_amt
							, 0
							, 0
							, @i_icbm_emp
							, @i_acctid
						FROM tfi_pay_m tpm
						WHERE tpm.paym_id = @paym_id;
						
						UPDATE m
						SET m.icbm_pay_amt = d.icbd_rec_amt, m.icbm_inc_amt = m.icbm_amt - d.icbd_rec_amt
						FROM tfi_incomebill_m m
						LEFT JOIN tfi_incomebill_d d ON d.icbd_icbm_id = m.icbm_id
						WHERE d.icbd_m_id = @paym_id AND m.icbm_id = @o_icbm_id;
						
					END
				END
				
				IF(LEFT(@paym_nbr,4) = 'SA47')
				BEGIN
					--D���Ѿ���sa47����ӽ�ȥ��
					--�ҵ�֮ǰ��û�����͵�SA47(��������)===�����ǵĵֿ���ϸ
					INSERT INTO tfi_incomebill_d (
					icbd_icbm_id, icbd_bill_type, icbd_m_id, icbd_d_id, icbd_currency, icbd_rate
					, icbd_rec_amt, icbd_rmks, icbd_payb_amt, icbd_recb_amt, icbd_real_amt, adduser, acctid) 
					SELECT @o_icbm_id, paym.paym_nbr_flag, paym.paym_id, ISNULL(paym.paym_ref_did, 0), paym.paym_currency, paym.paym_rate
					, ABS(scts.scts_amt_conf), paym.paym_rmks
					, (CASE WHEN paym.paym_nbr_flag = 1 OR paym.paym_nbr_flag = 2 THEN paym.paym_amt ELSE 0 END)
					, (CASE WHEN paym.paym_nbr_flag = 3 OR paym.paym_nbr_flag = 4 THEN paym.paym_amt ELSE 0 END)
					, 0 ,@i_icbm_emp, @i_acctid
					FROM HSAL.dbo.tsa_acct_s scts
					INNER JOIN FIDB.dbo.tfi_pay_m paym ON paym.paym_id=scts.scts_from_id AND paym.paym_nbr=scts.scts_from_nbr
					INNER JOIN HSAL.dbo.tsa_acct_m actm ON scts.scts_actm_id = actm.actm_id
					INNER JOIN FIDB.dbo.tfi_pay_m payp ON payp.paym_ref_id = actm.actm_id AND payp.paym_ref_nbr = actm.actm_nbr
					INNER JOIN FIDB.dbo.tfi_pay_m pays ON payp.paym_paycode_type = pays.paym_paycode_type AND payp.paym_pay_code = pays.paym_pay_code 
															AND pays.paym_legal = payp.paym_legal AND pays.paym_date >= payp.paym_date
					WHERE scts.scts_select = 1 AND pays.paym_id = @i_icbm_ref_id
					AND paym.isenable = 1 AND ISNULL(paym.paym_parent_id, 0) = 0 
					AND ISNULL(payp.paym_parent_id, 0) = 0  AND payp.paym_nbr LIKE 'SA47%' 
					AND  NOT EXISTS(SELECT 1 FROM fidb.dbo.v_fi_wfing vw WHERE paym.paym_id = vw.nbr_paym_id)--ȥ������е��ո�����
					--AND (	payp.paym_id = @i_icbm_ref_id  --�������ϸ
					--	OR NOT EXISTS(SELECT 1 FROM fidb.dbo.v_fi_wfing vw WHERE payp.paym_id = vw.nbr_paym_id)--ȥ������е��ո�����
						
					
					--�ҵ�֮ǰ��û�����͵�SA47(����������)
					INSERT INTO tfi_incomebill_d (
					icbd_icbm_id, icbd_bill_type, icbd_m_id, icbd_d_id, icbd_currency, icbd_rate
					, icbd_rec_amt, icbd_rmks, icbd_payb_amt, icbd_recb_amt, icbd_real_amt, adduser, acctid) 
					SELECT @o_icbm_id, payp.paym_nbr_flag, payp.paym_id, ISNULL(payp.paym_ref_did, 0), payp.paym_currency
						  , payp.paym_rate, payp.paym_amt, payp.paym_rmks, 0, payp.paym_amt,0, @i_icbm_emp, @i_acctid
					FROM FIDB.dbo.tfi_pay_m payp
					INNER JOIN FIDB.dbo.tfi_pay_m pays ON payp.paym_paycode_type = pays.paym_paycode_type AND payp.paym_pay_code = pays.paym_pay_code 
															AND pays.paym_legal = payp.paym_legal  AND pays.paym_date >= payp.paym_date
					WHERE 
					payp.isenable = 1 
					AND ISNULL(payp.paym_parent_id, 0) = 0 
					AND payp.paym_id <> @i_icbm_ref_id 
					AND payp.paym_nbr LIKE 'SA47%' 
					AND pays.paym_id = @i_icbm_ref_id
					AND NOT EXISTS(SELECT 1 FROM fidb.dbo.v_fi_wfing vw WHERE payp.paym_id = vw.nbr_paym_id)--ȥ������е��ո�����
					
					DELETE FROM fidb.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @o_icbm_id AND icbd_rec_amt=0 
					
					WHILE(EXISTS(SELECT 1 FROM fidb.dbo.tfi_incomebill_d  d1
								 INNER JOIN  fidb.dbo.tfi_incomebill_d d2 ON d2.icbd_icbm_id=d1.icbd_icbm_id AND d1.icbd_m_id=d2.icbd_m_id AND d1.icbd_id<>d2.icbd_id 
					             WHERE d2.icbd_icbm_id = @o_icbm_id ))
		             BEGIN 
		             	SELECT TOP 1 @paym_id_s = d1.icbd_m_id, @icbd_id_s = d1.icbd_id		             	  
		             	FROM fidb.dbo.tfi_incomebill_d  d1
						INNER JOIN  fidb.dbo.tfi_incomebill_d d2 ON d2.icbd_icbm_id=d1.icbd_icbm_id AND d1.icbd_m_id=d2.icbd_m_id AND d1.icbd_id<>d2.icbd_id 
			            WHERE d2.icbd_icbm_id = @o_icbm_id 
			             
			             UPDATE d1
			             SET d1.icbd_rec_amt = (SELECT sum(icbd_rec_amt)  FROM fidb.dbo.tfi_incomebill_d  WHERE icbd_icbm_id = @o_icbm_id AND icbd_m_id= @paym_id_s)
			             FROM fidb.dbo.tfi_incomebill_d d1 WHERE d1.icbd_id = @icbd_id_s  AND d1.icbd_icbm_id=@o_icbm_id 
			             
			             DELETE FROM fidb.dbo.tfi_incomebill_d WHERE icbd_icbm_id = @o_icbm_id AND icbd_m_id = @paym_id_s AND icbd_id <> @icbd_id_s
		             END 
					
					UPDATE FIDB.dbo.tfi_incomebill_m 
					SET 
					icbm_amt = (SELECT SUM(icbd_rec_amt) FROM FIDB.dbo.tfi_incomebill_d d WHERE d.icbd_icbm_id = icbm_id AND icbd_bill_type IN (3,4)),
					icbm_pay_amt = (SELECT SUM(icbd_rec_amt) FROM FIDB.dbo.tfi_incomebill_d d WHERE d.icbd_icbm_id = icbm_id AND icbd_bill_type IN (1,2)),
					icbm_inc_amt = (SELECT SUM((CASE WHEN icbd_bill_type IN (3,4) THEN icbd_rec_amt ELSE -1*icbd_rec_amt END)) FROM FIDB.dbo.tfi_incomebill_d d WHERE d.icbd_icbm_id = icbm_id)
					WHERE icbm_id = @o_icbm_id
				END
			END
			-- �����ӱ�end
			
			-- �ύ������
			SELECT @summary = '�Է���ƣ�' + pay_name + '���տ��' + CAST(CAST(@i_icbm_inc_amt AS DECIMAL(19, 2)) AS VARCHAR(19)) + @i_icbm_currency
			FROM v_fi_paycode_info WHERE ctype = @i_icbm_reccode_type AND pay_code = @i_icbm_rec_code;
			
			EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp 'AR07', @i_icbm_emp, @o_icbm_id, @wfmid OUTPUT, @o_rntStr OUTPUT;
			IF (@o_rntStr = 'OK')
			BEGIN
				IF (LEFT(@paym_nbr, 4) = 'SA47' OR  LEFT(@paym_nbr, 4) = 'AC15'   )--���۶��˵������տ�֪ͨΪ���ᣬ�ɶ�Ӧ���������ύͨ��
				--IF (1=2)
				BEGIN
					EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'SYSTEM', @o_icbm_id, @o_icbm_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT, '', '', @i_icbm_emp, 2;--����Ϊ�����˴���
				END
				ELSE
				BEGIN
					EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, @i_icbm_emp, @o_icbm_id, @o_icbm_nbr OUTPUT, @summary, '', '', @o_rntStr OUTPUT;
				END
				IF @o_rntStr <> 'OK'
				BEGIN
					SET @o_rntStr = '[AR07]ע�Ṥ����ʧ�ܣ���ʾ��' + @o_rntStr;
				END
				ELSE
				BEGIN
					UPDATE tfi_incomebill_m SET icbm_nbr = @o_icbm_nbr WHERE icbm_id = @o_icbm_id;
				END
			END
	    END
	END
END TRY
BEGIN CATCH
	SET @o_rntStr = ERROR_MESSAGE();
END CATCH


GO



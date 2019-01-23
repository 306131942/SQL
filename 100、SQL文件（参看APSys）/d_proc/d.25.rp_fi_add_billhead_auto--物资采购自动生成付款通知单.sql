USE FIDB
GO

--2.��������洢���̵��ж�
IF(OBJECT_ID('rp_fi_add_billhead_auto','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_add_billhead_auto AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
-- =========================================================================================
-- Author:		luocg
-- Create date: 2017-12-1
-- Description:	
-- 1�����ʲɹ��Զ����ɸ���֪ͨ�������������ͬ�Ķ��˵�ֻ������pay_m���ݣ���������������͸���֪ͨ��
-- 2���ú�ͬδ������ܽ�� = ��ͬ��ͬ�Ķ��˵��ܽ��  �Ż�����
-- 3������ʱ��ÿ��ֻ���ͺ�ͬ��һ�ڣ�����ռ�ú�ͬδ������ܽ��ı���t1��������˵�ʱ���ձ���д�븶��֪ͨ������ϸ
-- modify [1]:  ֱ�ӴӶ��˵��ҵ���ͬ luocg	2018-03-07
-- =========================================================================================
ALTER PROCEDURE rp_fi_add_billhead_auto
(
	@i_contract_code VARCHAR(40) = NULL --��ͬ���
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	DECLARE @i_contract_code VARCHAR(40); --��ͬ���
	SET @i_contract_code = '';
	*/
	
	DECLARE @c_code VARCHAR(40);	-- ��ͬ���
	DECLARE @c_date INT = 0;		-- ���ڿ���ǰ����
	DECLARE @acctid INT;			-- ����  
	DECLARE @count INT = 0;			-- ����  
	DECLARE @count_amt MONEY = 0;	-- ��� 
	
	DECLARE @fi_wf_status VARCHAR(20);	-- 0:����Ϊ����ĸ���֪ͨ����1:����Ϊ����ĸ���֪ͨ��
	
	DECLARE @wfmid INT;					-- ����id
	DECLARE @summary VARCHAR(200);		-- ������summary  
	DECLARE @rntStr VARCHAR(800);     
	                                         
	 -- ��ͬ����                  
	 DECLARE @CNTD_ID INT;				--��¼id
	 DECLARE @CNTD_CNTM_ID INT;			--��ͬ����¼id
	 DECLARE @CNTD_DUE_DATE DATETIME;	--�������
	 DECLARE @CNTD_AMT MONEY = 0 ;			--����Ӧ�����
	 DECLARE @CNTD_PAID_AMT MONEY = 0;		--�����Ѹ����
	 DECLARE @CNTM_AMT MONEY;			--��ͬ���
	                         			
	 DECLARE @c_rate DECIMAL(19,7);		--���ڱ���                           		
	 DECLARE @c_sum_pay MONEY;			--pay_m����ͬ��ͬ�Ľ��֮��  
	 DECLARE @c_sum_c MONEY;			--��ͬ�Ĵ����ܽ��  
	   
	 --����֪ͨ����������
	 DECLARE @abhm_id INT;
	 DECLARE @abhm_nbr VARCHAR(20) = '';	--���� 
	 DECLARE @abhm_item VARCHAR(20);		-- ��ƿ�Ŀ
	 DECLARE @abhm_emp VARCHAR(20);			-- ������
	 DECLARE @abhm_dept VARCHAR(20);		-- ���벿��code
	 DECLARE @abhm_pay_dept VARCHAR(20);	-- �����
	 DECLARE @abhm_duty INT;				-- �����˸�λ
	 DECLARE @abhm_date DATETIME;			-- ��������
	 DECLARE @abhm_pay_date DATETIME;		-- ��������
	 DECLARE @abhm_legal INT;				-- ����
	 DECLARE @abhm_paycode_type TINYINT;	-- �Է����� 1��Ӧ�� 2����
	 DECLARE @abhm_pay_code VARCHAR(20);	-- �Է�����
	 DECLARE @abhm_pay_type TINYINT;		-- ֧����ʽ
	 DECLARE @abhm_pay_name VARCHAR(100);	-- ������
	 DECLARE @abhm_pay_bank VARCHAR(100);	-- ������
	 DECLARE @abhm_pay_nbr VARCHAR(50);		-- �����˺�
	 DECLARE @abhm_currency VARCHAR(10);	-- �ұ�
	 DECLARE @abhm_rate DECIMAL(19, 7);		-- ����
	 DECLARE @abhm_rmks VARCHAR(200);		-- ��ע 
	                                 	 
	 -- ����֪ͨ����ϸ������
	 DECLARE @abhd_abhm_id INT;				-- ������id
	 DECLARE @abhd_bill_type TINYINT;		-- ��������   
	 DECLARE @abhd_m_id VARCHAR(200);		-- ����id   
	 DECLARE @abhd_currency VARCHAR(10);	-- �ұ�    
	 DECLARE @abhd_rate DECIMAL(19,7);		-- ����      
	 DECLARE @abhd_pay_amt 	MONEY;			-- ֧�����     
	 DECLARE @abhd_rmks VARCHAR(200);		-- ��ע      
	 DECLARE @abhd_payb_amt MONEY;			-- Ӧ�����   
	 DECLARE @abhd_source_id INT;			-- ��Դ����ID 
	 DECLARE @abhd_source_nbr VARCHAR(20);			-- ��Դ���ݵ��� 
	 DECLARE @abhd_adduser VARCHAR(10);		   
	 DECLARE @abhd_acctid VARCHAR(10);	  
	  
	  
	IF OBJECT_ID('tempdb..#temp_pay') IS NOT NULL DROP TABLE #temp_pay;		-- ȡ���ʲɹ����͵�tfi_pay_m�е�����
	IF OBJECT_ID('tempdb..#temp_order') IS NOT NULL DROP TABLE #temp_order;	-- #temp_pay�еĺ�ͬ�������
	
	--������ͬ�ĵ�δƥ������
	--SELECT tpm.paym_id, tpm.paym_ref_id, paym_ref_nbr,paym_parent_id, 
	SELECT *
	INTO #temp_pay
	FROM fidb.dbo.tfi_pay_m tpm  
	WHERE tpm.paym_ref_nbr LIKE 'ET06-%' --���ʲɹ����˵�����
	AND tpm.isenable = 1
	AND NOT EXISTS(SELECT 1 FROM fidb.dbo.tfi_billhead_m m
						LEFT JOIN fidb.dbo.tfi_billhead_d d ON d.abhd_abhm_id = m.abhm_id
						WHERE m.abhm_status <> 8 AND d.abhd_m_id = tpm.paym_id
	)
	                  
	----��ͬ����,һ����ͬ���ܶ�Ӧ������˵���aetd_aetm_id, ���˵�����ϸaetd_id
	--SELECT d.aetd_id,d.aetd_aetm_id, d.aetd_po_nbr, poem.poem_contract_code, d.acctid 
	--INTO #temp_order
	--FROM  (SELECT rn = ROW_NUMBER() OVER (PARTITION BY aetd_aetm_id ORDER BY aetd_id ASC),*  FROM R6ERP.dbo.tpu_acctet_d)d--���˵���ϸ����ͬaetd_aetm_idֻȡһ����ϸ����
	--INNER JOIN R6ERP.dbo.tpu_poet_m poem ON poem.poem_nbr = d.aetd_po_nbr 
	--AND poem.poem_contract_code = ISNULL(@i_contract_code, poem.poem_contract_code) --���������ʱ�������õ�
	--WHERE  d.rn=1 AND d.aetd_aetm_id IN (SELECT  paym_ref_id  FROM #temp_pay) 
	
	----��ͬ����,һ����ͬ���ܶ�Ӧ������˵���aetm_id
	SELECT m.aetm_id, m.aetm_contract_code, m.acctid 
	INTO #temp_order
	FROM  R6ERP.dbo.tpu_acctet_m m
	WHERE m.aetm_contract_code  = ISNULL(@i_contract_code,m.aetm_contract_code) --���������ʱ�������õ�
	AND m.aetm_id IN (SELECT  paym_ref_id  FROM #temp_pay) 
	
	--����ͬ����ѭ��
	--�ύ����֪ͨ����д��ͬ��ϸ���Ѹ��������˻�ʱ��ԭ
	WHILE EXISTS (SELECT 1 FROM #temp_order)
	BEGIN
		
		SET @count = 0;
		SET @count_amt = 0;
		
		SET @CNTD_AMT = 0;
		SET @c_sum_c = 0;
		SET @c_rate = 0;
		SET @c_sum_pay = 0;
		
		SELECT TOP 1 @c_code = aetm_contract_code, @acctid = acctid FROM #temp_order
		
		--���ʹ��ỹ�Ǵ���
		SET @fi_wf_status = (SELECT code_value FROM hportal.dbo.tba_code  WHERE code_type='fi_wf_status' AND acctid = @acctid )
		
		--��ͬ�����տ���ǰ����
		SELECT @c_date = ISNULL(code_value,0) FROM fidb.dbo.tba_code WHERE code_type = 'fi_contract_date' AND acctid = @acctid
		
		--���ں�ͬ��ϸ,ÿ��jobֻ����һ�ڵĸ���֪ͨ��
		--�ҵ����ڵĺ�ͬ��ϸ
		SELECT TOP 1  @CNTD_ID = d.CNTD_ID, @CNTD_CNTM_ID  = d.CNTD_CNTM_ID, @CNTD_DUE_DATE = d.CNTD_DUE_DATE,
		 @CNTD_AMT = d.CNTD_AMT, @CNTD_PAID_AMT = d.CNTD_PAID_AMT, @CNTM_AMT = m.CNTM_AMT
		FROM fidb.dbo.tfi_contract_d d
		INNER JOIN fidb.dbo.tfi_contract_m m ON m.CNTM_ID = d.CNTD_CNTM_ID
		WHERE m.CNTM_CODE = @c_code 
		AND d.CNTD_PAID_AMT = 0 
		--AND GETDATE() >= DATEADD(day, -@c_date, d.CNTD_DUE_DATE) AND GETDATE() <= d.CNTD_DUE_DATE
		AND d.CNTD_DUE_DATE <= DATEADD(day, 10, GETDATE())
		AND m.CNTM_STATUS = 6
		ORDER BY d.CNTD_ID ASC
		
		--�ú�ͬδ������ܽ��
		SELECT @c_sum_c = SUM(d.CNTD_AMT) FROM fidb.dbo.tfi_contract_d d
		INNER JOIN fidb.dbo.tfi_contract_m m ON m.CNTM_ID = d.CNTD_CNTM_ID
		WHERE m.CNTM_CODE = @c_code AND d.CNTD_PAID_AMT = 0 AND m.CNTM_STATUS = 6
		
		--ʣ����ı���
		SET @c_rate = cast(cast(@CNTD_AMT as decimal(12,4)) /cast(@c_sum_c as decimal(12,4))  as decimal(12,4)) 
		
		
		IF(@CNTD_AMT > 0)--����0˵�������ϵĺ�ͬ��ϸ���������ɸ���
		BEGIN
			 IF OBJECT_ID('tempdb..#temp_pay_id') IS NOT NULL DROP TABLE #temp_pay_id; --�ú�ͬ�µ�pay_m������
			                                                                          
			--�ҵ��ú�ͬ��pay_m������
			SELECT *
			INTO #temp_pay_id
			FROM #temp_pay
			WHERE paym_ref_id IN(SELECT aetm_id FROM #temp_order WHERE aetm_contract_code = @c_code)	
			
			--��ͬ��ͬ�Ķ��˵�paym�ܽ��
			SELECT @c_sum_pay = SUM(paym_amt) FROM #temp_pay_id 
			--�м������˵�paym����
			SELECT @count = COUNT(1) FROM #temp_pay_id 
			
			--����������ʼ���ɸ���֪ͨ��
			IF(@c_sum_c = @c_sum_pay)
			BEGIN
				
				EXEC FIDB.dbo.rp_fi_get_tmpnbr 'tfi_billhead_m', 'abhm_nbr', @abhm_nbr OUTPUT; 
			   	
				SELECT TOP 1 
					 @abhm_item = tpm.paym_item, @abhm_emp = tpm.paym_emp
					, @abhm_dept = tpm.paym_dept, @abhm_pay_dept = tpm.paym_admin_dept
					, @abhm_duty = tpm.paym_duty, @abhm_date = tpm.paym_date, @abhm_pay_date = tpm.paym_due_date
					, @abhm_legal = tpm.paym_legal, @abhm_paycode_type = tpm.paym_paycode_type
					, @abhm_pay_code = tpm.paym_pay_code, @abhm_pay_type = tpm.paym_pay_type
					, @abhm_pay_name = tpm.paym_pay_name, @abhm_pay_bank = tpm.paym_pay_bank
					, @abhm_pay_nbr = tpm.paym_pay_nbr, @abhm_currency = tpm.paym_currency
					, @abhm_rate = tpm.paym_rate
					, @abhm_rmks = '���������ʲɹ����˵���'+  (SELECT STUFF((SELECT '��' + paym_ref_nbr FROM #temp_pay_id FOR XML PATH('')),1,1,'')) +'����.'
				FROM #temp_pay_id tpm
				ORDER BY paym_id DESC 
				
				-- ��������begin
					INSERT INTO FIDB.dbo.tfi_billhead_m ( 
						abhm_type, abhm_nbr, abhm_item, abhm_emp, abhm_dept, abhm_pay_dept
						, abhm_duty, abhm_date, abhm_legal, abhm_paycode_type, abhm_pay_code, abhm_othercode_type, abhm_other_code
						, abhm_pay_type, abhm_pay_name, abhm_pay_bank, abhm_pay_nbr, abhm_currency
						, abhm_rate, abhm_amt, abhm_rec_amt, abhm_pay_amt, abhm_pay_date, abhm_rec_date
						, abhm_rmks, abhm_status, abhm_ref_type, abhm_ref_id, adduser, acctid)
					VALUES (
						1, @abhm_nbr, @abhm_item, @abhm_emp, @abhm_dept, @abhm_pay_dept
						, @abhm_duty, @abhm_date, @abhm_legal, @abhm_paycode_type, @abhm_pay_code, @abhm_paycode_type, @abhm_pay_code
						, @abhm_pay_type, @abhm_pay_name, @abhm_pay_bank, @abhm_pay_nbr, @abhm_currency
						, @abhm_rate, @CNTD_AMT, 0, @CNTD_AMT, @abhm_pay_date, NULL
						, @abhm_rmks, 1, null, null, @abhm_emp, @acctid);
					SET @abhm_id = @@identity; 
				-- ��������end
					
				-- ѭ�������ӱ�begin
					WHILE EXISTS (SELECT 1 FROM #temp_pay_id)
					BEGIN
						
						SELECT TOP 1 	
						@abhd_abhm_id = @abhm_id, @abhd_bill_type = m.paym_nbr_flag,
						@abhd_m_id = m.paym_id, @abhd_currency = m.paym_currency,
						@abhd_rate = m.paym_rate, @abhd_pay_amt = m.paym_amt*@c_rate,
						@abhd_rmks = m.paym_rmks, @abhd_payb_amt = m.paym_amt,	
						@abhd_adduser = m.adduser, @abhd_acctid = m.acctid
						, @abhd_source_id = m.paym_ref_id, @abhd_source_nbr = m.paym_ref_nbr
						FROM #temp_pay_id m
						ORDER BY paym_id ASC
						
						SET @abhd_pay_amt =  cast(@abhd_pay_amt as decimal(19,2))--��������λС��
						
						IF(@COUNT=1)--ֻ��һ��ʱ@count_amt��ʼ��Ϊ0�ģ����һ��ʱ����ȥ�õ���
						BEGIN
							SET @abhd_pay_amt = @CNTD_AMT - @count_amt
						END
						ELSE 
						BEGIN
							SET @count_amt = @count_amt + @abhd_pay_amt;
						END
						
						SET @count = @count - 1;
						
						INSERT INTO FIDB.dbo.tfi_billhead_d (
						abhd_abhm_id, abhd_bill_type, abhd_m_id, abhd_d_id
						, abhd_currency, abhd_rate, abhd_pay_amt, abhd_rmks
						, abhd_payb_amt, abhd_recb_amt, abhd_real_amt
						, adduser, acctid, abhd_cntd_id, abhd_source_id, abhd_source_nbr) 
						VALUES (
						 @abhm_id, @abhd_bill_type, @abhd_m_id, 0
						, @abhd_currency, @abhd_rate, @abhd_pay_amt, @abhd_rmks
						, @abhd_payb_amt, 0, 0, @abhd_adduser, @abhd_acctid, @CNTD_ID, @abhd_source_id, @abhd_source_nbr)
						
						--ѭ��ɾ����
						DELETE FROM #temp_pay_id WHERE paym_id = @abhd_m_id;
						
					END
					DROP TABLE #temp_pay_id
				-- �����ӱ�end

				-- �ύ������
					SELECT @summary = '���' + (CASE ctype WHEN 1 THEN '��Ӧ��' WHEN 2 THEN '����' WHEN 3 THEN '�ͻ�' WHEN 4 THEN '����' ELSE '����' END)
						+ ',' + pay_code + '-' + pay_name + ',' + CAST(CAST(@CNTD_AMT AS DECIMAL(19, 2)) AS VARCHAR(19)) + @abhm_currency
					FROM FIDB.dbo.v_fi_paycode_info WHERE ctype = @abhm_paycode_type AND pay_code = @abhm_pay_code;
					
					DECLARE @wfcode VARCHAR(4);
					SET @wfcode =  'AP07';
					EXEC HPORTAl.dbo.rp_wf_get_workflowByEmp  @wfcode, @abhm_emp, @abhm_id, @wfmid OUTPUT, @rntStr OUTPUT;
					IF (@rntStr = 'OK')
					BEGIN
						IF(@abhm_paycode_type = 1 AND ISNULL(@fi_wf_status, 0) = 1 )--���Ϊ��Ӧ��,������Ϊ���ʹ��ᵥ��
						BEGIN
							EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, 'SYSTEM', @abhm_id, @abhm_nbr OUTPUT, @summary, '', '', @rntStr OUTPUT, '', '', @abhm_emp, 2;--����Ϊ�����˴���
						END
						ELSE
						BEGIN
							EXEC HPORTAL.DBO.rp_wf_add_new_form1 @wfmid, @abhm_emp, @abhm_id, @abhm_nbr OUTPUT, @summary, '', '', @rntStr OUTPUT;--���ʹ���
						END
				
						IF (@rntStr <> 'OK')
						BEGIN
							SET @rntStr = '[AP07]ע�Ṥ����ʧ�ܣ���ʾ��' + @rntStr;
						END
						ELSE
						BEGIN
							UPDATE FIDB.dbo.tfi_billhead_m SET abhm_nbr = @abhm_nbr WHERE abhm_id = @abhm_id;
						END
					END	
				
			END
		END 
			
		--ѭ��ɾ��
		DELETE FROM #temp_order WHERE @c_code = aetm_contract_code
	END
	
	DROP TABLE #temp_order
	DROP TABLE #temp_pay
	
		
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO

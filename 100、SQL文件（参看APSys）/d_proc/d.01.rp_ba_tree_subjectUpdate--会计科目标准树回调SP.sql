USE HPORTAL
GO
IF(OBJECT_ID('rp_ba_tree_subjectUpdate','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_ba_tree_subjectUpdate AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2014-02-10
-- Description:	��ƿ�Ŀ����������
-- Modify[1]: liaocx 14-10-22 btype = 1 mtype = 2��ά��û�б��tfi_subject�����ƣ��������������ԣ������
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_ba_tree_subjectUpdate]
(
	@i_btype INT					-- 1 KEY ά�� 0 ����춯
	, @i_mtype INT					-- 1 btype=1����/btype=0���� 2 btype=1�޸�/btype=0���� 3 ע��
	, @i_sub INT = 1				-- �Ƿ��¼�ע��
	, @i_pcode VARCHAR(20) = ''		-- ��������
	, @i_code VARCHAR(20)			-- ����
	, @i_name VARCHAR(100)			-- ����
	, @i_remark VARCHAR(200)		-- ��ע
	, @i_isv INT					-- �Ƿ�����
	, @i_bdate DATETIME				-- ��Ч����
	, @i_edate DATETIME				-- ʧЧ����
	, @i_emp_id VARCHAR(20)			-- ������
	, @i_acctid INT					-- acctid
	, @o_ret VARCHAR(200) OUTPUT	-- ִ�н��
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;

	DECLARE @suj_tree_code VARCHAR(20); -- ��Ŀ������
	DECLARE @ppi_tree_code VARCHAR(20); -- PPI������
	DECLARE @ppif_id INT; -- PPIָ��id
	DECLARE @ppif_code VARCHAR(20); -- PPIָ��code
	DECLARE @ppif_pcode VARCHAR(20); -- PPIָ�길code
	DECLARE @ppft_code VARCHAR(20); -- PPI��ƿ�Ŀ��code
	DECLARE @sujt_id INT; -- ��ƿ�Ŀid
	DECLARE @ppif_time VARCHAR(7); -- ����
	
	SET @suj_tree_code = 'TR10';
	SET @ppi_tree_code = 'TR13';
	SET @o_ret = 'OK';

	IF (@i_btype = 1)
	BEGIN -- KEY ά��begin
	    IF (@i_mtype = 1) -- ����
	    BEGIN
			-- 1��дHPORTAL.dbo.tfi_subject
			BEGIN TRY
				IF NOT EXISTS (SELECT 1 FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code)
				BEGIN
					IF EXISTS (SELECT 1 FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode)
					BEGIN
						INSERT INTO HPORTAL.dbo.tfi_subject (sujt_code, sujt_name, sujt_desc, sujt_vir, sujt_type, sujt_direct, sujt_person
							, sujt_auperson, sujt_state, sujt_begdate, sujt_enddate, isenable, addtime, adduser, acctid, sujt_ppif_id)
						SELECT @i_code, @i_name, @i_remark, @i_isv, sujt_type, sujt_direct, sujt_person, sujt_auperson, sujt_state
							, @i_bdate, @i_edate, 1, GETDATE(), @i_emp_id, @i_acctid, NULL
						FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode;
					END
					ELSE
					BEGIN
						INSERT INTO HPORTAL.dbo.tfi_subject (sujt_code, sujt_name, sujt_desc, sujt_vir, sujt_type, sujt_direct, sujt_person
							, sujt_auperson, sujt_state, sujt_begdate, sujt_enddate, isenable, addtime, adduser, acctid, sujt_ppif_id)
						VALUES (@i_code, @i_name, @i_remark, @i_isv, 0, 0, '', '', 0
							, @i_bdate, @i_edate, 1, GETDATE(), @i_emp_id, @i_acctid, NULL);
					END
				END
				ELSE
				BEGIN
					UPDATE HPORTAL.dbo.tfi_subject SET sujt_name = @i_name, sujt_desc = @i_remark, sujt_vir = @i_isv
					WHERE sujt_code = @i_code;
				END
			END TRY
			BEGIN CATCH
					RAISERROR('�����ƿ�Ŀ���ݳ���!',16,1);
			END CATCH
			
			-- 2���������Ľ�����THR_PPI_DEFINITION
			SELECT @ppif_code = MAX(CAST(PPIF_CODE AS INT)) + 1 FROM HSRP.dbo.THR_PPI_DEFINITION WHERE LEN(PPIF_CODE) = 4; -- ȡPPI code
			SELECT @ppft_code = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME LIKE '��ƿ�Ŀ%' AND ISENABLE = 1; -- ȡPPI����code
			SELECT @sujt_id = sujt_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code; -- ȡ��ƿ�Ŀid
			SELECT @ppif_time = fYear + 'YR' FROM HPORTAL.dbo.contrast_yearf WHERE GETDATE() BETWEEN yBegdate AND DATEADD(DAY, 1, yEnddate);
			
			BEGIN TRY
				INSERT INTO HSRP.dbo.THR_PPI_DEFINITION (PPIF_TIME, PPIF_CODE, PPIF_NAME, PPIF_DIRECTION, PPIF_DEFINITION, ppif_unit
				, PPIF_PROPERTY, PPIF_TYPE, ISENABLE, ADDTIME, ADDUSER, MODTIME, MODUSER, PPIF_ENCRY, PPIF_SOURCE, ppif_cc_range)
				SELECT @ppif_time, @ppif_code, sujt_name, 0, sujt_desc, 1, 0, @ppft_code, 1, GETDATE(), @i_emp_id, GETDATE(), 'N/A', 3, 1, 'dept'
				FROM HPORTAL.dbo.tfi_subject
				WHERE sujt_id = @sujt_id;
			SET @ppif_id = @@identity;
			END TRY
			BEGIN CATCH
				RAISERROR('����PPI���ݳ���',16,1);
			END CATCH
			
			-- 3���޸Ŀ�Ŀ����PPIΪ��������PPI
			UPDATE HPORTAL.dbo.tfi_subject SET sujt_ppif_id = @ppif_id WHERE sujt_id = @sujt_id;
			
			-- 4������PPI�����
			-- 1)����pcodeȡppif_id
			SET @ppif_id = NULL;
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode;
			-- 2)�ٸ���ppif_idȡpcode(PPI��)
			SELECT @ppif_pcode = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)����PPI�����
			IF (ISNULL(@ppif_pcode, '') = '') -- �һ�ƿ�Ŀ��
			BEGIN
				SET @ppif_pcode = @ppft_code;
			END
			--IF (ISNULL(@ppif_code, '') <> '' AND ISNULL(@ppif_pcode, '') <> '')
			--BEGIN
			--	--EXEC HPORTAL.dbo.rp_ba_tree_addNode1 @ppi_tree_code, @ppif_code, @ppif_pcode, @i_emp_id, @i_bdate, @i_edate, 'PPI', @o_ret OUTPUT;
			--END
	    END
	    ELSE IF (@i_mtype = 2) -- �޸�
	    BEGIN
	    	-- 1������THR_PPI_DEFINITION
			-- 1)ȡ@i_code��ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)��������
			SELECT @ppft_code = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME = '��ƿ�Ŀ��'; -- ȡPPI����code
			
			UPDATE HSRP.dbo.THR_PPI_DEFINITION SET PPIF_NAME = @i_name, PPIF_DEFINITION = @i_remark
			WHERE PPIF_ID = @ppif_id AND PPIF_TYPE = @ppft_code;
			--add by liaocx 14-10-22
			UPDATE HPORTAL.dbo.tfi_subject SET sujt_name = @i_name, sujt_desc = @i_remark, sujt_vir = @i_isv
			WHERE sujt_code = @i_code;
			------------------------
	    END
	END -- KEY ά��end
	ELSE IF (@i_btype = 0)
	BEGIN -- ����춯begin
		--IF (@i_mtype = 1) -- ������
		--BEGIN
			
		--END
		--ELSE
		IF (@i_mtype = 2) -- �������
		BEGIN
			-- 1������PPI�����
			-- 1)ȡ@i_code��ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)�ٸ���ppif_idȡppif_code
			SELECT @ppif_code = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)����pcodeȡppif_id
			SET @ppif_id = NULL;
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode;
			-- 6)�ٸ���ppif_idȡpcode(PPI��)
			SELECT @ppif_pcode = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 7)����PPI�����
			IF (ISNULL(@ppif_pcode, '') = '') -- �һ�ƿ�Ŀ��
			BEGIN
				SELECT @ppif_pcode = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME LIKE '��ƿ�Ŀ%' AND ISENABLE = 1; -- ȡPPI����code
			END
			IF (ISNULL(@ppif_code, '') <> '' AND ISNULL(@ppif_pcode, '') <> '')
			BEGIN
				EXEC HPORTAL.dbo.rp_ba_tree_moveNode1 @ppi_tree_code, @ppif_code, @ppif_pcode, @i_emp_id, @i_bdate, @i_edate, 'PPI', @o_ret OUTPUT;
			END
		END
		ELSE IF (@i_mtype = 3) -- ע�����
		BEGIN
			-- 1��ע��PPI�����
			-- 1)ȡ@i_code��ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)�ٸ���ppif_idȡppif_code
			SELECT @ppif_code = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)ע��PPI�����
			IF (ISNULL(@ppif_code, '') <> '')
			BEGIN
				SET @i_edate = GETDATE();
				EXEC HPORTAL.dbo.rp_ba_tree_removeNode1 @ppi_tree_code, @ppif_code, @i_emp_id, @i_edate, 'PPI', @o_ret OUTPUT, @i_sub;
			END
		END
	END	-- ����춯end
	
	IF (@o_ret <> 'OK')
	BEGIN
		RAISERROR(@o_ret, 16, 1);
	END
END TRY
BEGIN CATCH
	SET @o_ret = ERROR_MESSAGE();
	IF (@o_ret <> 'OK')
	BEGIN
		RAISERROR(@o_ret, 16, 1);
	END
END CATCH
GO

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
-- Author:		罗志胜
-- Create date: 2014-02-10
-- Description:	会计科目树变更后调用
-- Modify[1]: liaocx 14-10-22 btype = 1 mtype = 2的维护没有变更tfi_subject的名称，描述及虚拟属性，需加上
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_ba_tree_subjectUpdate]
(
	@i_btype INT					-- 1 KEY 维护 0 结点异动
	, @i_mtype INT					-- 1 btype=1新增/btype=0调入 2 btype=1修改/btype=0调出 3 注销
	, @i_sub INT = 1				-- 是否含下级注销
	, @i_pcode VARCHAR(20) = ''		-- 父结点代码
	, @i_code VARCHAR(20)			-- 代码
	, @i_name VARCHAR(100)			-- 名称
	, @i_remark VARCHAR(200)		-- 备注
	, @i_isv INT					-- 是否虚拟
	, @i_bdate DATETIME				-- 生效日期
	, @i_edate DATETIME				-- 失效日期
	, @i_emp_id VARCHAR(20)			-- 操作人
	, @i_acctid INT					-- acctid
	, @o_ret VARCHAR(200) OUTPUT	-- 执行结果
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;

	DECLARE @suj_tree_code VARCHAR(20); -- 科目树代码
	DECLARE @ppi_tree_code VARCHAR(20); -- PPI树代码
	DECLARE @ppif_id INT; -- PPI指标id
	DECLARE @ppif_code VARCHAR(20); -- PPI指标code
	DECLARE @ppif_pcode VARCHAR(20); -- PPI指标父code
	DECLARE @ppft_code VARCHAR(20); -- PPI会计科目类code
	DECLARE @sujt_id INT; -- 会计科目id
	DECLARE @ppif_time VARCHAR(7); -- 财年
	
	SET @suj_tree_code = 'TR10';
	SET @ppi_tree_code = 'TR13';
	SET @o_ret = 'OK';

	IF (@i_btype = 1)
	BEGIN -- KEY 维护begin
	    IF (@i_mtype = 1) -- 新增
	    BEGIN
			-- 1、写HPORTAL.dbo.tfi_subject
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
					RAISERROR('插入会计科目数据出错!',16,1);
			END CATCH
			
			-- 2、将新增的结点插入THR_PPI_DEFINITION
			SELECT @ppif_code = MAX(CAST(PPIF_CODE AS INT)) + 1 FROM HSRP.dbo.THR_PPI_DEFINITION WHERE LEN(PPIF_CODE) = 4; -- 取PPI code
			SELECT @ppft_code = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME LIKE '会计科目%' AND ISENABLE = 1; -- 取PPI分类code
			SELECT @sujt_id = sujt_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code; -- 取会计科目id
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
				RAISERROR('插入PPI数据出错',16,1);
			END CATCH
			
			-- 3、修改科目关联PPI为上面插入的PPI
			UPDATE HPORTAL.dbo.tfi_subject SET sujt_ppif_id = @ppif_id WHERE sujt_id = @sujt_id;
			
			-- 4、插入PPI树结点
			-- 1)根据pcode取ppif_id
			SET @ppif_id = NULL;
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode;
			-- 2)再根据ppif_id取pcode(PPI树)
			SELECT @ppif_pcode = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)插入PPI树结点
			IF (ISNULL(@ppif_pcode, '') = '') -- 挂会计科目类
			BEGIN
				SET @ppif_pcode = @ppft_code;
			END
			--IF (ISNULL(@ppif_code, '') <> '' AND ISNULL(@ppif_pcode, '') <> '')
			--BEGIN
			--	--EXEC HPORTAL.dbo.rp_ba_tree_addNode1 @ppi_tree_code, @ppif_code, @ppif_pcode, @i_emp_id, @i_bdate, @i_edate, 'PPI', @o_ret OUTPUT;
			--END
	    END
	    ELSE IF (@i_mtype = 2) -- 修改
	    BEGIN
	    	-- 1、更新THR_PPI_DEFINITION
			-- 1)取@i_code的ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)更新数据
			SELECT @ppft_code = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME = '会计科目类'; -- 取PPI分类code
			
			UPDATE HSRP.dbo.THR_PPI_DEFINITION SET PPIF_NAME = @i_name, PPIF_DEFINITION = @i_remark
			WHERE PPIF_ID = @ppif_id AND PPIF_TYPE = @ppft_code;
			--add by liaocx 14-10-22
			UPDATE HPORTAL.dbo.tfi_subject SET sujt_name = @i_name, sujt_desc = @i_remark, sujt_vir = @i_isv
			WHERE sujt_code = @i_code;
			------------------------
	    END
	END -- KEY 维护end
	ELSE IF (@i_btype = 0)
	BEGIN -- 结点异动begin
		--IF (@i_mtype = 1) -- 调入结点
		--BEGIN
			
		--END
		--ELSE
		IF (@i_mtype = 2) -- 调出结点
		BEGIN
			-- 1、调出PPI树结点
			-- 1)取@i_code的ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)再根据ppif_id取ppif_code
			SELECT @ppif_code = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)根据pcode取ppif_id
			SET @ppif_id = NULL;
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_pcode;
			-- 6)再根据ppif_id取pcode(PPI树)
			SELECT @ppif_pcode = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 7)调出PPI树结点
			IF (ISNULL(@ppif_pcode, '') = '') -- 挂会计科目类
			BEGIN
				SELECT @ppif_pcode = PPFT_CODE FROM HSRP.dbo.THR_PPI_DEFINITION_TYPE WHERE PPFT_NAME LIKE '会计科目%' AND ISENABLE = 1; -- 取PPI分类code
			END
			IF (ISNULL(@ppif_code, '') <> '' AND ISNULL(@ppif_pcode, '') <> '')
			BEGIN
				EXEC HPORTAL.dbo.rp_ba_tree_moveNode1 @ppi_tree_code, @ppif_code, @ppif_pcode, @i_emp_id, @i_bdate, @i_edate, 'PPI', @o_ret OUTPUT;
			END
		END
		ELSE IF (@i_mtype = 3) -- 注销结点
		BEGIN
			-- 1、注销PPI树结点
			-- 1)取@i_code的ppif_id
			SELECT @ppif_id = sujt_ppif_id FROM HPORTAL.dbo.tfi_subject WHERE sujt_code = @i_code;
			-- 2)再根据ppif_id取ppif_code
			SELECT @ppif_code = PPIF_CODE FROM HSRP.dbo.THR_PPI_DEFINITION WHERE PPIF_ID = @ppif_id;
			-- 3)注销PPI树结点
			IF (ISNULL(@ppif_code, '') <> '')
			BEGIN
				SET @i_edate = GETDATE();
				EXEC HPORTAL.dbo.rp_ba_tree_removeNode1 @ppi_tree_code, @ppif_code, @i_emp_id, @i_edate, 'PPI', @o_ret OUTPUT, @i_sub;
			END
		END
	END	-- 结点异动end
	
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

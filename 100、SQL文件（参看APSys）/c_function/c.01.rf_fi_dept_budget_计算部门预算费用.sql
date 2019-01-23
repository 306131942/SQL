-- 1.�г�ʹ�ÿ���
USE [FIDB]
GO
--drop FUNCTION rf_fi_dept_budget
-- 2.��������������ж�
IF (OBJECT_ID('rf_fi_dept_budget') IS NULL)
BEGIN
    --EXEC ('CREATE FUNCTION rf_fi_dept_budget() RETURNS INT AS BEGIN RETURN 1; END');
    -- ��ֵ����ʱ
     EXEC ('CREATE FUNCTION rf_fi_dept_budget() RETURNS @temp_table TABLE( ID int primary key NOT NULL) AS BEGIN RETURN ; END');
END
GO

-- 3.���� ANSI_NULLS �� QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 ��׼Ҫ���ڶԿ�ֵ���е��� (=) �򲻵��� (<>) �Ƚ�ʱȡֵΪ FALSE
GO

SET QUOTED_IDENTIFIER ON --��ʶ��������˫���ŷָ�
GO

-- 4.��д�����Ļ�����Ϣ
-- =========================================================================================
-- Author:		zhoupan
-- Create date: 2016-03-14
-- Description:	���㲿��Ԥ��
-- =========================================================================================

-- 5.�ڴ�������ʱ���������������淶��rf_������ĸ��ģ��Ӣ����д_�������ܱ�ʶ��
ALTER FUNCTION [dbo].[rf_fi_dept_budget]
(										-- 6.����������( )��������ÿ��һ��
    @i_dept_code VARCHAR(20),			-- ���Ŵ���
    @i_fmonth VARCHAR(10),				-- ����
    @i_item_id INT,					    -- ��Ŀid 
    @i_dept_right VARCHAR(100)          --����Ȩ�޴���
)
RETURNS @PPI_RULER_TABLE TABLE				-- 7.�����������ͣ���ֵ������ʹ��'������ֵ����'����'������ֵ����'��
(
	[ppi_dept_name] VARCHAR(50),			-- ���Ŵ���
	[ppi_ruler_sum] DECIMAL(18,4),			-- �ۼ�Ԥ�����
	[ppi_ruler]  DECIMAL(18,4)				-- ��Ԥ�����
)
--WITH SCHEMABINDING		-- 8.��SQL��ѯ��������ж�����ͬһ�����ݿ⣬�������SCHEMABINDING
AS
BEGIN

	--9.���庯������ڲ���(������ԣ�����ʱҪע��)��ÿ��һ��
	/*
	
	SELECT FIDB.dbo.rf_fi_dept_budget('011024','2015F12',18)
    DECLARE @i_dept_code VARCHAR(20)='011024';			-- ���Ŵ��� 
    DECLARE @i_fmonth VARCHAR(10)='2015F12';			-- ����
    DECLARE @i_item_id INT=18;							-- ��Ŀid 
	*/
	DECLARE @ppi_ruler DECIMAL(18,4);					-- ppi��滮ֵ
	DECLARE @ppi_ruler_sum DECIMAL(18,4);				-- ppi�ۼƹ滮
	DECLARE @ppi_now_dept VARCHAR(20);					-- ppi�����м����
	DECLARE @ppi_upper_dept VARCHAR(20);				-- ppi�ϼ�����
	DECLARE @ppi_id INT;								-- ppiָ��ID
	DECLARE @cttn_amr	DECIMAL(18,4);					-- ��̯���Ž��ϼ�
	DECLARE @ppi_dept_name VARCHAR(50);					-- Ŀ�겿������
	
	DECLARE @DEPT TABLE									-- Ȩ����ʱ��
	(
		[code] varchar(10)
    )
	
	INSERT into @DEPT(code) SELECT val FROM  fidb.dbo.rf_fi_SplitToTable(@i_dept_right,',')
	
	-- ��ѯĿ��PPI�滮	
	SELECT @ppi_ruler = m.ppim_ruler
	FROM HSRP.dbo.thr_ppi_m m
	INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
	INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
	WHERE item.item_id=@i_item_id AND m.PPIM_CODE = @i_dept_code
	AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 

	
	-- �м������ֵ
	SET @ppi_upper_dept = '';
	SET @ppi_now_dept = @i_dept_code;
	
	-- Ŀ��PPI�滮Ϊ�գ�Ѱ���ϼ�����PPI�滮
	WHILE(@ppi_ruler IS NULL AND  @i_dept_code != @ppi_upper_dept)
	BEGIN
		-- ��ʼ��
		SET @ppi_upper_dept = '';
		-- ��ѯ�ϼ�����code
		SELECT TOP 1 @ppi_upper_dept=cc_code 
		FROM FIDB.dbo.v_fi_dept dept
		WHERE (SELECT cc_level FROM FIDB.dbo.v_fi_dept WHERE cc_code=@ppi_now_dept) LIKE dept.cc_level+'%'
		AND cc_level <> '' AND cc_code <> @ppi_now_dept
		ORDER BY cc_level DESC
		
		IF(@ppi_upper_dept IS NULL OR @ppi_upper_dept = '')
		BEGIN
			SET @i_dept_code = @ppi_now_dept;
			BREAK;
		END
		
		-- ��ѯ�ϼ�����Ԥ��
		SELECT @ppi_ruler = m.ppim_ruler
		FROM HSRP.dbo.thr_ppi_m m
		INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
		INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
		WHERE item.item_id=@i_item_id AND m.PPIM_CODE = @ppi_upper_dept
		AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 
		
		-- �м������ֵ
		SET @ppi_now_dept = @ppi_upper_dept;
		
		IF(@ppi_ruler IS NOT NULL)
		BEGIN
			-- ��ֵ
			SET @i_dept_code = @ppi_upper_dept;
		END
	END

	-- Ŀ�겿��PPI��滮ֵ ,�ۼƹ滮ֵ	
	SELECT @ppi_ruler=ISNULL(m.ppim_ruler,0),@ppi_ruler_sum=ISNULL(pd.ppid_ruler_sum,0)
	FROM HSRP.dbo.thr_ppi_m m
	INNER JOIN HSRP.dbo.thr_ppi_d pd ON pd.PPID_PPIM_ID = m.PPIM_ID
	INNER JOIN HSRP.dbo.thr_ppi_definition d ON d.PPIF_ID = m.PPIM_PPIF_ID
	INNER JOIN HSRP.dbo.tfi_item item ON item.item_ppi_code = d.PPIF_CODE
	WHERE item.item_id=@i_item_id AND pd.PPID_TIME = @i_fmonth
	AND m.PPIM_CODE_TYPE = 0  AND LEFT(m.PPIM_TIME,4) = LEFT(@i_fmonth,4) 
	AND m.PPIM_RULER IS NOT NULL AND m.PPIM_CODE = @i_dept_code 
	
	-- Ŀ�겿����֧�����(����)
	SELECT @cttn_amr=ISNULL(SUM(cttn.CTTN_AMT * cttn.cttn_rate),0)
	FROM FIDB.dbo.tfi_cost_allocation cttn
	LEFT JOIN FIDB.dbo.tfi_reimbursement m ON m.RMMT_ID = cttn.CTTN_RMMD_ID
	LEFT JOIN FIDB.dbo.v_fi_dept dept ON dept.cc_code = cttn.CTTN_DEPT
	WHERE m.RMMT_STATUS = 6 
	AND dept.cc_level LIKE (SELECT o.cc_level FROM FIDB.dbo.v_fi_dept o WHERE o.cc_code=@i_dept_code) +'%' 
	AND m.rmmt_applicant_date <= (SELECT mEndtime FROM HPORTAL.dbo.contrast_monthf WHERE fMonth=@i_fmonth) 
	AND m.rmmt_applicant_date >= (SELECT mBegdate FROM HPORTAL.dbo.contrast_monthf WHERE fMonth=(LEFT(@i_fmonth,5)+'01'))
	
	-- Ŀ�겿������
	SELECT @ppi_dept_name = cc_full
	FROM FIDB.dbo.v_fi_dept WHERE cc_code = @i_dept_code
	--AND CHARINDEX(','+dept.cc_level+',',','+@ppi_dept_level+',')>0
	
	IF EXISTS(select 1 from fidb.dbo.v_fi_dept a 
				inner join (select cc_level from  FIDB.dbo.v_fi_dept where cc_code in (select code from @DEPT)) b on a.cc_level like rtrim(b.cc_level)+'%' 
				where a.cc_code=@i_dept_code)

	BEGIN
	-- ���벿�����ơ��ۼ�Ԥ������Ԥ�����
		INSERT INTO @PPI_RULER_TABLE VALUES (@ppi_dept_name,@ppi_ruler_sum - @cttn_amr,@ppi_ruler - @cttn_amr)
	END
	ELSE 
	BEGIN
		INSERT INTO @PPI_RULER_TABLE VALUES ('',NULL,NULL)

	END

	RETURN ;
END

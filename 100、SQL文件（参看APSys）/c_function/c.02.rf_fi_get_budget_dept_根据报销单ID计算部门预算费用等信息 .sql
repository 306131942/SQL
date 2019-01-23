-- USE [FIDB]
GO

-- 2.添加新增函数的判断
IF (OBJECT_ID('rf_fi_get_budget_dept') IS NULL)
BEGIN
    -- 表值函数时
    EXEC ('CREATE FUNCTION rf_fi_get_budget_dept() RETURNS @temp_table TABLE( ID int primary key NOT NULL) AS BEGIN RETURN ; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =========================================================================================
-- Author:	lcg	
-- Create date: 2018-07-19
-- Description:	根据报销单的mid找到预算单位、年预算额、累计预算额、累计预算余额、个人已报额、科目预算余额强关联弱关联等信息
--1、（从报销程序里面找出来的sql,详细解释看EFI03AB的代码注释）
--2、--PPI规划“预算管理”调整原来的0 无；	 1 强联下级； 2 弱联； 3强联本级 改成 0 无关联；1月关联；  2年关联
--3、st=0 部门 1 职员，
--4、个人有预算，不管是什么关联类型，都会校验金额； 年关联时，累计预算额=年预算额，会校验；月关联也会校验
-- =========================================================================================
ALTER FUNCTION [dbo].[rf_fi_get_budget_dept]
(
	@rmmt_id int
)
RETURNS @SplitStringsTable TABLE
(
	id INT IDENTITY(1, 1),
	 st INT,
	 ruler_code VARCHAR(20),--预算单位
	 ruler_obj VARCHAR(50),--预算单位
	 ruler_amt DECIMAL(19, 4),--年预算额（ppi主表金额）                           --// 年规划
	 ruler_sum_amt DECIMAL(19, 4),--累计预算额（ppi明细表金额）						--// 月累计规划
	 ruler_last_amt DECIMAL(19, 4),--累计预算余额									   --// 月累计规划余额
	 all_amt DECIMAL(19, 4),--个人已报额											   --个人已报销额人已报销额
	 ppim_budget_ctrl INT--科目预算余额强关联弱关联(参数设置的好像)
)

AS
BEGIN

DECLARE @ppif_id INT = 0;
DECLARE @fyear VARCHAR(7);
DECLARE @fmonth VARCHAR(10);
DECLARE @ppi_right INT = 0;
DECLARE @bdate VARCHAR(10);
DECLARE @edate VARCHAR(10);
DECLARE @item_code VARCHAR(20);
DECLARE @amt_type INT;
DECLARE @cc_code VARCHAR(20);
DECLARE @emp_id VARCHAR(20);
DECLARE @cc_level VARCHAR(50);	
				
DECLARE @st INT;
DECLARE @ruler_code VARCHAR(20);
DECLARE @ruler_obj VARCHAR(50);
DECLARE @ruler_amt DECIMAL(19, 4);
DECLARE @ruler_sum_amt DECIMAL(19, 4);
DECLARE @ruler_last_amt DECIMAL(19, 4);
DECLARE @all_amt DECIMAL(19, 4);
DECLARE @ppim_budget_ctrl INT = 0;


SELECT @edate = CONVERT(VARCHAR(10), rmmt_applicant_date, 23), @item_code= rmmt_itemcode , @amt_type=RMMT_TYPE, @cc_code=RMMT_DEPT,@emp_id=RMMT_APPLICANT
FROM FIDB.dbo.TFI_REIMBURSEMENT WHERE RMMT_ID = @rmmt_id;
SELECT @bdate = CONVERT(VARCHAR(10), yBegdate, 23) FROM HPORTAL.dbo.contrast_yearf WHERE GETDATE() BETWEEN yBegdate AND yEnddate

SELECT @fmonth = fMonth,@fyear = LEFT(fMonth,5) + 'YR'  FROM HPORTAL.dbo.contrast_monthf WHERE @edate BETWEEN mBegdate AND mEndtime;
SELECT @ppif_id = p.ppif_id 
FROM HSRP.dbo.THR_PPI_DEFINITION p
INNER JOIN (SELECT sujt_ppif_id=s.sujt_ppif_id FROM FIDB.dbo.TFI_REIMBURSEMENT m
LEFT JOIN HPORTAL.dbo.tfi_subject s ON s.sujt_code = m.rmmt_itemcode
WHERE m.RMMT_ID = @rmmt_id) t ON t.sujt_ppif_id = p.PPIF_ID
WHERE p.ISENABLE <> 0 

--SELECT @ppi_right = 1 FROM HSRP.dbo.THR_PPI_RIGHT
--WHERE PPIG_TIME = @fyear AND PPIG_EMP_ID = '00000001' AND PPIG_PPIF_ID = @ppif_id AND PPIG_VIEW = 1;

--SELECT ppif_id = @ppif_id, ppi_right = @ppi_right, fyear = @fyear, fmonth = @fmonth, bdate = @bdate, edate = @edate,item_code=@item_code,amt_type=@amt_type, cc_code= @cc_code
--,emp_id=@emp_id

--SET @emp_id = '06030374';
--SET @bdate = '2018-04-01';
--SET @edate = '2018-07-19 23:59:59';
--SET @fyear = '2018FYR';
--SET @fmonth = '2018F04';
--SET @ppif_id = 2843;
--SET @item_code = '5624';
--SET @amt_type = 2;  
--SET @cc_code = 'Z00171';
--// 单据类型：2业务报销，5礼品报销
----// 单据类型：1通用报销，3差旅报销，4专用付款， 6个人额度

IF(@amt_type = 2 or @amt_type = 5)
BEGIN 
	SELECT @all_amt = isnull(SUM(RMMT_APPROVED * RMMT_RATE),0) FROM FIDB.dbo.TFI_REIMBURSEMENT m 
	WHERE RMMT_TYPE IN (2,5)  AND m.rmmt_itemcode = @item_code
	AND RMMT_STATUS IN (6)
	AND RMMT_APPLICANT_DATE BETWEEN @bdate AND @edate AND RMMT_APPLICANT = @emp_id
END 
ELSE 
BEGIN 
	SELECT @all_amt = isnull(SUM(RMMT_APPROVED * RMMT_RATE),0) FROM FIDB.dbo.TFI_REIMBURSEMENT m 
	WHERE RMMT_TYPE = @amt_type AND RMMT_STATUS IN (6) AND RMMT_APPLICANT_DATE BETWEEN @bdate AND @edate AND RMMT_APPLICANT = @emp_id AND m.rmmt_itemcode = @item_code
END 

-------------------------------------------------------------------------------------------------------------@all_amt       个人已报销额人已报销额

SELECT @ruler_amt = PPIM_RULER 
,@ruler_sum_amt = (CASE WHEN  m.ppim_budget_ctrl = 2 THEN PPIM_RULER ELSE d.ppid_ruler_sum END)
,@ppim_budget_ctrl = m.ppim_budget_ctrl 
FROM HSRP.dbo.THR_PPI_M m
LEFT JOIN HSRP.dbo.thr_ppi_d d ON d.PPID_PPIM_ID = m.PPIM_ID AND d.PPID_TIME = @fmonth
WHERE PPIM_TIME = @fyear AND PPIM_PPIF_ID = @ppif_id AND PPIM_CODE_TYPE = 1 AND PPIM_CODE = @emp_id AND PPIM_RULER IS NOT NULL;

IF (@ruler_amt IS NOT NULL)
BEGIN
	SELECT @st = 1---------------------------------------@st = 1,表示个人
	, @ruler_code = emp_id, @ruler_obj = emp_id + '-' + emp_name FROM FIDB.dbo.v_fi_empmstr WHERE emp_id = @emp_id;
	SET @ruler_last_amt = @ruler_sum_amt - @all_amt;
END
ELSE
BEGIN--------------------------------------------个人没有预算找他的部门，上级部门
	SELECT @cc_level = cc_level FROM FIDB.dbo.v_fi_dept WHERE  cc_code = @cc_code;
	
	SELECT TOP 1 @ruler_code = tpm.PPIM_CODE, @ruler_obj = fd.cc_full
	, @ruler_amt = tpm.PPIM_RULER
	,@ruler_sum_amt =  (CASE WHEN  tpm.ppim_budget_ctrl = 2 THEN tpm.PPIM_RULER ELSE  d.ppid_ruler_sum END)
	, @st = 0,@ppim_budget_ctrl = tpm.ppim_budget_ctrl
	FROM HSRP.dbo.THR_PPI_M tpm
   LEFT JOIN HSRP.dbo.thr_ppi_d d ON d.PPID_PPIM_ID = tpm.PPIM_ID AND d.PPID_TIME = @fmonth
	INNER JOIN FIDB.dbo.v_fi_dept fd ON fd.cc_code = tpm.PPIM_CODE AND @cc_level LIKE fd.cc_level + '%' AND fd.cc_level<>'' 
	WHERE tpm.PPIM_TIME = @fyear AND tpm.PPIM_PPIF_ID = @ppif_id AND tpm.PPIM_CODE_TYPE = 0 AND tpm.PPIM_RULER IS NOT NULL
	ORDER BY fd.cc_level DESC;
	
	SELECT @ruler_last_amt = @ruler_sum_amt - (SELECT ISNULL(SUM(RMMT_APPROVED * RMMT_RATE),0)
												FROM FIDB.dbo.TFI_REIMBURSEMENT m
											 WHERE CHARINDEX(RMMT_TYPE,(CASE WHEN @amt_type = 2 OR @amt_type = 5 THEN '2,5' ELSE CONVERT(VARCHAR(10),@amt_type) END))> 0 
											 AND m.rmmt_itemcode = @item_code AND RMMT_STATUS IN (6)
												AND RMMT_APPLICANT_DATE BETWEEN @bdate AND @edate AND EXISTS ( 
												  SELECT 1 FROM FIDB.dbo.v_fi_dept vfd 
												   INNER JOIN FIDB.dbo.v_fi_dept vfd1 ON vfd1.cc_code = @ruler_code AND vfd.cc_level LIKE vfd1.cc_level + '%' 
											   WHERE RMMT_DEPT = vfd.cc_code AND NOT EXISTS( 
												 SELECT 1 FROM FIDB.dbo.v_fi_dept fd1 
												   INNER JOIN ( 
													 SELECT fd.cc_level 
													 FROM HSRP.dbo.THR_PPI_M tpm INNER JOIN  FIDB.dbo.v_fi_dept fd ON tpm.PPIM_CODE=fd.cc_code 
													 WHERE  PPIM_TIME= @fyear AND PPIM_PPIF_ID=@ppif_id AND tpm.PPIM_CODE_TYPE = 0 AND tpm.PPIM_RULER IS NOT NULL 
													 AND fd.cc_level LIKE  vfd1.cc_level + '%' AND fd.cc_code <> @ruler_code 
												   ) fd2 ON fd1.cc_level LIKE fd2.cc_level + '%' WHERE vfd.cc_code=fd1.cc_code 
												)
												))
END

IF (@st IS NULL)-----------------------------部门也没找到
BEGIN
 SELECT TOP 1 @ruler_code = vfd.cc_code, @ruler_obj = vfd.cc_full, @cc_level =vfd.cc_level 
	 FROM FIDB.dbo.v_fi_dept vfd  
				 WHERE vfd.cc_level = (SELECT SUBSTRING(cc_level,1,2) FROM FIDB.dbo.v_fi_dept WHERE  cc_code = @cc_code) 
					SELECT @st = 0, @ruler_amt = 0,@ruler_sum_amt = 0, @ruler_last_amt = isnull(SUM(RMMT_APPROVED * RMMT_RATE) * -1,0)
					FROM FIDB.dbo.TFI_REIMBURSEMENT WHERE RMMT_TYPE = @amt_type AND RMMT_STATUS IN (6) AND RMMT_APPLICANT_DATE BETWEEN @bdate AND @edate AND rmmt_itemcode = @item_code
				 AND EXISTS ( 
					  SELECT 1 FROM FIDB.dbo.v_fi_dept vfd 
					   INNER JOIN FIDB.dbo.v_fi_dept vfd1 ON vfd1.cc_code = @ruler_code AND vfd.cc_level LIKE vfd1.cc_level + '%' 
				   WHERE RMMT_DEPT = vfd.cc_code AND NOT EXISTS( 
					 SELECT 1 FROM FIDB.dbo.v_fi_dept fd1 
					   INNER JOIN ( 
						 SELECT fd.cc_level 
						 FROM HSRP.dbo.THR_PPI_M tpm INNER JOIN  FIDB.dbo.v_fi_dept fd ON tpm.PPIM_CODE=fd.cc_code 
						 WHERE  PPIM_TIME= @fyear AND PPIM_PPIF_ID=@ppif_id AND tpm.PPIM_CODE_TYPE = 0 AND tpm.PPIM_RULER IS NOT NULL 
						 AND fd.cc_level LIKE  vfd1.cc_level + '%' AND fd.cc_code <> @ruler_code 
					   ) fd2 ON fd1.cc_level LIKE fd2.cc_level + '%' WHERE vfd.cc_code=fd1.cc_code 
					)
				)
END
		
INSERT INTO @SplitStringsTable(st,
	 ruler_code ,
	 ruler_obj ,
	 ruler_amt ,
	 ruler_sum_amt ,
	 ruler_last_amt ,
	 all_amt ,
	 ppim_budget_ctrl) 
SELECT st = @st
	, ruler_code = @ruler_code
	, ruler_obj = @ruler_obj
	, ruler_amt = CAST(CAST(@ruler_amt AS DECIMAL(19, 2)) AS VARCHAR(19))
	, ruler_sum_amt = CAST(CAST(@ruler_sum_amt AS DECIMAL(19, 2)) AS VARCHAR(19))
	, ruler_last_amt = CAST(CAST(@ruler_last_amt AS DECIMAL(19, 2)) AS VARCHAR(19)), all_amt = CAST(CAST(ISNULL(@all_amt, 0) AS DECIMAL(19, 2)) AS VARCHAR(19))
	,ppim_budget_ctrl = @ppim_budget_ctrl;
		

    RETURN
END


GO


--SELECT * FROM  FIDB.dbo.rf_fi_get_budget_dept(86036)
--SELECT ISNULL(
--(SELECT cc_code  FROM fidb.db.v_fi_empmstr WHERE emp_id=(
--	SELECT ruler_code FROM  FIDB.dbo.rf_fi_get_budget_dept(86036)))
--	,
--	(SELECT ruler_code FROM  FIDB.dbo.rf_fi_get_budget_dept(86036))
--)
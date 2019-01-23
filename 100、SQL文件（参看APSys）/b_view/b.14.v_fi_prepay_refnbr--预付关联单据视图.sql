USE [FIDB]
GO
--2.添加新增视图的判断
IF(OBJECT_ID('v_fi_prepay_refnbr','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_prepay_refnbr AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-09
-- Description:	预付单关联单号信息
-- Modify[1]:	增加采购订单关联的控制，只有结算方式是预付的供应商才可以预付 by liuxiang at 2014-11-13。
-- Modify[2]:	取消只有结算方式是预付的控制

-- =========================================================================================
ALTER VIEW [dbo].[v_fi_prepay_refnbr]
WITH VIEW_METADATA
AS
	-- 采购订单
	SELECT
		reftype = 1
		, mid = tpm.PODM_ID
		, nbr = tpm.PODM_NBR
		, pay_code = tpm.PODM_SPL_CODE
		, amt = tpm.PODM_AMT
		, currency = tpm.PODM_CURR
		, repay_date = ''
		, rmks = '供应商：' + ISNULL(spl.SPL_SHORT_NAME, '') + '，订单总金额：' + CAST(CAST(tpm.PODM_AMT AS DECIMAL(19, 2)) AS VARCHAR(19)) + ISNULL(tpm.PODM_CURR, 'RMB')
	FROM HPUR.dbo.TPU_POD_M tpm
	INNER JOIN (SELECT t.SPL_CODE, t.SPL_SHORT_NAME FROM HPUR.dbo.TPU_SUPPLIER t ) spl ON spl.SPL_CODE=tpm.PODM_SPL_CODE
	WHERE tpm.PODM_STATUS IN (6, 7)
	UNION ALL
	-- 借款单
	SELECT
		reftype = 2
		, mid = tbmm.BRMM_ID
		, nbr = tbmm.BRMM_NBR
		, pay_code = tbmm.BRMM_APPLICANT
		, amt = tbmm.BRMM_APPROVED
		, currency = ISNULL(tbmm.BRMM_CURR_TYPE, 'RMB')
		, CONVERT(VARCHAR(10), BRMM_REPAYMENT_DATE, 23)
		, rmks = ISNULL(fpi.pay_name, '') + CONVERT(VARCHAR(10), tbmm.BRMM_APPLICANT_DATE, 23) + '申请借款' + CAST(tbmm.BRMM_APPROVED AS VARCHAR(18)) + ISNULL(tbmm.BRMM_CURR_TYPE, 'RMB')
	FROM dbo.TFI_BORROW_MONEY_M tbmm
	LEFT JOIN dbo.v_fi_paycode_info fpi ON tbmm.BRMM_APPLICANT = fpi.pay_code AND fpi.ctype = 2
	WHERE tbmm.BRMM_STATUS = 6

WITH CHECK OPTION;
GO
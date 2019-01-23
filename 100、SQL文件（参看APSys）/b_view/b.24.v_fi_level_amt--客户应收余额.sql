USE [FIDB]
GO

IF(OBJECT_ID('v_fi_level_amt','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_level_amt AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		liuxiang
-- Create date: 2014-07-05
-- Description:	销售应收账款查询
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_level_amt]
WITH VIEW_METADATA
AS
	SELECT paym.paym_pay_code, paym.paym_legal, paym.paym_currency
	, paym_level_amt = SUM(CASE WHEN paym.paym_nbr_flag IN (3, 4) THEN paym.paym_amt - paym.paym_real_amt ELSE (paym.paym_amt - paym.paym_real_amt) * -1 END)
	FROM FIDB.dbo.tfi_pay_m paym
	WHERE paym.paym_paycode_type = 3 AND paym.isenable = 1
	GROUP BY paym.paym_pay_code, paym.paym_legal, paym.paym_currency
	
WITH CHECK OPTION;

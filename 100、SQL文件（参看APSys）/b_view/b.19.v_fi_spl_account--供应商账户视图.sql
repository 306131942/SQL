USE [FIDB]
GO

IF(OBJECT_ID('v_fi_spl_account','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_spl_account AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		刘翔
-- Create date: 2013-05-08
-- Description:	供应商付款账号视图
-- modify[1]: 增加月结方式的查询 by liuxiang at 2014-07-22
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_spl_account]
WITH VIEW_METADATA
AS
	SELECT 	
			pay_spl_SPAT_ID=tsa.SPAT_ID,
	        pay_spl_code=tsa.SPAT_SPL_CODE,																				
			pay_spat_name=tsa.spat_name,	    --付款账号开户名																				
			pay_spat_bank=tsa.spat_bank,		--付款账号开户行																		
			pay_spat_account=tsa.spat_account,	--付款账号																			
			pay_spat_currency=tsa.spat_curr,	--付款账号交易币别																				
			pay_spat_begdate=tsa.spat_begdate,	--付款账号有效开始时间																				
			pay_spat_enddate=tsa.spat_enddate,	--付款账号有效结束时间	
			pay_spat_default=tsa.spat_default	--默认标识                           	                         --																		
	FROM HPUR.dbo.TPU_SUPPLIER_ACCOUNT tsa

WITH CHECK OPTION;
GO
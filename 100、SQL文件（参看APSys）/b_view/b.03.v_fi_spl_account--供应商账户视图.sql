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
-- Author:		����
-- Create date: 2013-05-08
-- Description:	��Ӧ�̸����˺���ͼ
-- modify[1]: �����½᷽ʽ�Ĳ�ѯ by liuxiang at 2014-07-22
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_spl_account]
WITH VIEW_METADATA
AS
	SELECT 	
			pay_spl_SPAT_ID=tsa.SPAT_ID,
	        pay_spl_code=tsa.SPAT_SPL_CODE,																				
			pay_spat_name=tsa.spat_name,	    --�����˺ſ�����																				
			pay_spat_bank=tsa.spat_bank,		--�����˺ſ�����																		
			pay_spat_account=tsa.spat_account,	--�����˺�																			
			pay_spat_currency=tsa.spat_curr,	--�����˺Ž��ױұ�																				
			pay_spat_begdate=tsa.spat_begdate,	--�����˺���Ч��ʼʱ��																				
			pay_spat_enddate=tsa.spat_enddate,	--�����˺���Ч����ʱ��	
			pay_spat_default=tsa.spat_default	--Ĭ�ϱ�ʶ                           	                         --																		
	FROM HPUR.dbo.TPU_SUPPLIER_ACCOUNT tsa

WITH CHECK OPTION;
GO
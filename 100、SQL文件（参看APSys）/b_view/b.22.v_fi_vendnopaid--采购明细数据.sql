USE [FIDB]
GO
IF(OBJECT_ID('v_fi_vendnopaid','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_vendnopaid AS SELECT id=1;');
END

/****** Object:  View [dbo].[v_fi_vendnopaid]    Script Date: 10/29/2014 17:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		张伟平
-- Create date: 2014-10-29
-- Description:	供应商应付视图
-- Modify [1]:  
-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================
ALTER VIEW v_fi_vendnopaid
WITH VIEW_METADATA
AS 
	WITH actm_paid AS(
		SELECT actm_spl_code,actm_enddate=MAX(actm_enddate)
		FROM HPUR.dbo.tpu_acct_m 
		WHERE ISNULL(actm_acrm_id,0)<>0 AND actm_type IN (1,2,3,4) AND actm_amt<>0
		GROUP BY actm_spl_code
	),venddate AS (
		SELECT spl_code=actm_spl_code,enddate=actm_enddate FROM actm_paid		
		UNION ALL
		--没对账单的供应商
		SELECT SPL_CODE,enddate=GETDATE()-360 FROM HPUR.dbo.TPU_SUPPLIER 
		WHERE SPL_CODE NOT IN (SELECT actm_spl_code FROM actm_paid)
	)
	--1、对账单未对数据
	SELECT vpay_type=tad.ACTD_TYPE				--类型：,收货,退货,使用,使用退货
		  ,vpay_po_nbr=tad.ACTD_PO_NBR			--订单单号
		  ,vpay_po_line=tad.ACTD_PO_LINE		--订单项次
		  ,vpay_nbr=tad.ACTD_NBR				--单号
		  ,vpay_line=tad.ACTD_LINE				--项次
		  ,vpay_part=tad.ACTD_PART				--料号    
		  ,vpay_date=tad.ACTD_DATE				--日期
		  ,vpay_qty=tad.ACTD_QTY				--数量
		  ,vpay_price=tad.ACTD_PRICE			--单价
		  ,vpay_amt=tad.ACTD_QTY*tad.ACTD_PRICE	--金额
		  ,vpay_curr=tam.ACTM_CURR				--币别
		  ,vpay_um=tad.ACTD_UM					--单位
		  ,vpay_spl_code=tam.ACTM_SPL_CODE		--供应商代码
		  ,vpay_account_date=tlm.modtime		--登账时间
		  ,vpay_legal=tpm.podm_corp				--法人
		  ,vpay_settle_way=ts.spl_settle_way    --结算方式
	FROM HPUR.dbo.TPU_ACCT_D tad 
	INNER JOIN HPUR.dbo.TPU_ACCT_M tam ON tam.ACTM_ID=tad.ACTD_ACTM_ID
	INNER JOIN HPUR.dbo.tpu_supplier ts ON ts.SPL_CODE=tam.ACTM_SPL_CODE
	INNER JOIN venddate vd ON vd.spl_code=tam.ACTM_SPL_CODE AND tam.ACTM_ENDDATE=vd.enddate
	LEFT JOIN r6erp.dbo.TWM_LIST_M tlm ON tlm.LSTM_NBR=tad.ACTD_NBR AND tlm.ACCTID=tad.ACCTID
	LEFT JOIN HPUR.dbo.TPU_POD_M tpm ON tpm.PODM_NBR=tad.ACTD_PO_NBR AND tpm.ACCTID=tad.ACCTID
	WHERE tad.ACTD_STATUS=0 --未对
	UNION ALL 
	--2、VMI 的只取PVO 3使用/6使用退货数据
	SELECT vpay_type=(CASE tpd.PVOD_TYPE WHEN 1 THEN 3 WHEN 2 THEN 6 ELSE -1 END)--3使用/6使用退货
		, tpm.PVOM_PODM_NBR
		, tpm.PVOM_PODD_LINE
		, tpd.PVOD_NBR_REF
		, tpd.PVOD_LINE
		, tpd.PVOD_PART
		, tpd.PVOD_DATE
		, tpd.PVOD_QTY
		, tpd.PVOD_PRICE
		, vpay_amt=tpd.PVOD_QTY*tpd.PVOD_PRICE
		, tpd.PVOD_CURR
		, tpd.PVOD_UM
		, tpm.PVOM_SPL_CODE
		, tlm.modtime
		, tpdm.podm_corp
		,ts.spl_settle_way                    --结算方式
	FROM HPUR.dbo.TPU_PVO_D tpd 
	INNER JOIN HPUR.dbo.TPU_PVO_M tpm ON tpd.PVOD_PVOM_ID=tpm.PVOM_ID AND tpm.PVOM_TYPE=1
	INNER JOIN HPUR.dbo.tpu_supplier ts ON ts.SPL_CODE=tpm.PVOM_SPL_CODE
	INNER JOIN venddate vd ON vd.spl_code=tpm.PVOM_SPL_CODE 
	LEFT JOIN r6erp.dbo.TWM_LIST_M tlm ON tlm.LSTM_NBR=tpd.PVOD_NBR_REF
	LEFT JOIN HPUR.dbo.TPU_POD_M tpdm ON tpdm.PODM_NBR=tpm.PVOM_PODM_NBR AND tpdm.ACCTID=tpm.ACCTID
	WHERE tpd.PVOD_DATE>vd.enddate AND tpd.PVOD_TYPE IN (1,2)
	AND tpd.PVOD_DATE>=(CASE WHEN(ts.SPL_VMI_BEGDATE IS NULL OR ts.SPL_VMI_BEGDATE='1900-01-01') THEN '9999-01-01' ELSE ts.SPL_VMI_BEGDATE END)
	UNION ALL
	--3、非VMI PVO 收货数据
	SELECT vpay_type=1 --收货
		, tpm.PVOM_PODM_NBR
		, tpm.PVOM_PODD_LINE
		, tpm.PVOM_RECEIVE_NBR
		, tpm.PVOM_LINE
		, tpm.PVOM_PART
		, tpm.PVOM_RECEIVE_DATE
		, tpm.PVOM_QTY_RECEIVE
		, tpm.PVOM_PRICE
		, vpay_amt=tpm.PVOM_QTY_RECEIVE*tpm.PVOM_PRICE
		, tpm.PVOM_CURR
		, tpm.PVOM_UM
		, tpm.PVOM_SPL_CODE
		, tlm.modtime
		, tpdm.podm_corp
		,ts.spl_settle_way                    --结算方式
	FROM HPUR.dbo.TPU_PVO_M tpm
	INNER JOIN HPUR.dbo.tpu_supplier ts ON ts.SPL_CODE=tpm.PVOM_SPL_CODE
	INNER JOIN venddate vd ON vd.spl_code=tpm.PVOM_SPL_CODE
	LEFT JOIN r6erp.dbo.TWM_LIST_M tlm ON tlm.LSTM_NBR=tpm.PVOM_RECEIVE_NBR
	LEFT JOIN HPUR.dbo.TPU_POD_M tpdm ON tpdm.PODM_NBR=tpm.PVOM_PODM_NBR AND tpdm.ACCTID=tpm.ACCTID
	WHERE tpm.PVOM_RECEIVE_DATE>vd.enddate AND tpm.PVOM_TYPE=0 
	AND tpm.PVOM_RECEIVE_DATE<(CASE WHEN(ts.SPL_VMI_BEGDATE IS NULL OR ts.SPL_VMI_BEGDATE='1900-01-01') THEN '9999-01-01' ELSE ts.SPL_VMI_BEGDATE END)
	UNION ALL
	--4、非VMI PVO 退货数据
	SELECT vpay_type=2--退货
		, tpm.PVOM_PODM_NBR
		, tpm.PVOM_PODD_LINE
		, tpd.PVOD_NBR_REF
		, tpd.PVOD_LINE
		, tpd.PVOD_PART
		, tpd.PVOD_DATE
		, tpd.PVOD_QTY
		, tpd.PVOD_PRICE
		, vpay_amt=tpd.PVOD_QTY*tpd.PVOD_PRICE
		, tpd.PVOD_CURR
		, tpd.PVOD_UM
		, tpm.PVOM_SPL_CODE
		, tlm.modtime
		, tpdm.podm_corp
		,ts.spl_settle_way                    --结算方式
	FROM HPUR.dbo.TPU_PVO_D tpd 
	INNER JOIN HPUR.dbo.TPU_PVO_M tpm ON tpd.PVOD_PVOM_ID=tpm.PVOM_ID AND tpm.PVOM_TYPE=0 
	INNER JOIN HPUR.dbo.tpu_supplier ts ON ts.SPL_CODE=tpm.PVOM_SPL_CODE
	INNER JOIN venddate vd ON vd.spl_code=tpm.PVOM_SPL_CODE
	LEFT JOIN r6erp.dbo.TWM_LIST_M tlm ON tlm.LSTM_NBR=tpd.PVOD_NBR_REF
	LEFT JOIN HPUR.dbo.TPU_POD_M tpdm ON tpdm.PODM_NBR=tpm.PVOM_PODM_NBR AND tpdm.ACCTID=tpm.ACCTID
	WHERE tpd.PVOD_DATE>vd.enddate 
	AND tpd.PVOD_DATE< (CASE WHEN(ts.SPL_VMI_BEGDATE IS NULL OR ts.SPL_VMI_BEGDATE='1900-01-01') THEN '9999-01-01' ELSE ts.SPL_VMI_BEGDATE END)
	
	
	--LEFT JOIN HPUR.dbo.v_exr_rate e on e.exr_start_date<=CONVERT(CHAR(10),tad.ACTD_DATE,120) AND e.exr_end_date>=CONVERT(CHAR(10),tad.ACTD_DATE,120)
	--AND e.exr_curr1=tam.ACTM_CURR AND e.exr_curr2='RMB' 
WITH CHECK OPTION
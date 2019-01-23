USE [FIDB]
GO

IF(OBJECT_ID('v_fi_paym_forsa','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_paym_forsa AS SELECT id=1;');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author: liuxiang
-- Create date: 2014-12-08
-- Description: ���۶��˵ֿ���ϸ��Դ����Ϣ

-- Modify [1]:  ���Ӳ�������ʾ���ķ��õֿ۵� ��ʤ2015-12-17
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_paym_forsa]
WITH VIEW_METADATA
AS

	SELECT
		 vbdf_scts_paycode = paym.paym_pay_code				--�Է�����
		, vbdf_scts_legal = paym.paym_legal					--�����id
		, vbdf_scts_legalname = legal.ficn_short_name		--���������
		, vbdf_scts_mid = paym_id							--Ӧ��Ӧ����id
		, vbdf_scts_billcode = tm.wfm_code					--ҵ�񵥾����̱���
		, vbdf_scts_billurl = tm.acurl						--ҵ�񵥾�URL
		, vbdf_scts_billnbr = ISNULL(paym.paym_ref_nbr,paym.paym_nbr)				--ҵ�񵥵���
		, vbdf_scts_billid = 
			CASE WHEN LEFT(ISNULL(paym.paym_ref_nbr,paym.paym_nbr),4)<>'SA48' 
			THEN ISNULL(paym.paym_ref_id,paym.paym_id)
			ELSE (
				SELECT trd.srtd_srtm_id FROM hsal.dbo.tsa_return_d trd WHERE trd.srtd_id = paym.paym_ref_id
			)
			END				--ҵ�񵥵���
		, vbdf_scts_billname = tm.wfm_name					--ҵ������
		, vbdf_scts_currency = paym.paym_currency			--�ұ�
		, vbdf_scts_rate = paym.paym_rate					--����
		, vbdf_scts_amt =  (CASE WHEN (paym.paym_nbr_flag = 1 OR paym.paym_nbr_flag = 2) THEN (paym.paym_amt) ELSE (paym.paym_amt) * -1 END) -- ���ݽ��
		, vbdf_scts_rmks = paym.paym_rmks					--���ݱ�ע
		, vbdf_scts_date = ISNULL(paym.paym_due_date, paym.paym_date)				--Ӧ������ 
		, vbdf_scts_isenable = paym.isenable
	FROM dbo.tfi_pay_m paym
	LEFT JOIN dbo.VFI_CORPORATION legal ON legal.ficn_id=paym.paym_legal
	LEFT JOIN dbo.tfi_type_d ttd ON ttd.typd_id=paym.paym_typd_id
	LEFT JOIN dbo.v_fi_twfm tm ON tm.wfm_code = ttd.typd_wfm_code
	left join ( 
		select 'SA47' as wf_code  -- ���˵�
		union all
		select 'SA49'  -- ���˵�
		union all
		select 'AP07'  -- ���
		union all
		select 'AR07'  -- �տ
		union all
		select 'SA37'  -- ���۳��ⵥ
		union all
		select 'SA38'  -- �г����ⵥ
		union all
		select 'SA39'  -- VMI����
		union all
		select 'SA42'  -- �����˻���
		union all
		select 'SA53'  -- ԭ���ϳ���֪ͨ��
		union all
		select 'SA68'  -- ˫����
	) nc on nc.wf_code=tm.wfm_code
	WHERE paym.paym_paycode_type=3 
	AND ISNULL(paym.paym_due_date, paym.paym_date) >= ISNULL((SELECT max(CODE_CODE) FROM hsal.dbo.TBA_CODE WHERE CODE_TYPE='scts_date'),'1900-01-01')
	AND  nc.wf_code is NULL
	AND ttd.typd_send_flag=1
	
WITH CHECK OPTION;
GO 



USE [FIDB]
GO

IF(OBJECT_ID('v_fi_match_bill','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_match_bill AS SELECT id=1;');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		������
-- Create date: 2013-07-12
-- Description:	ƥ�䵥���б���ͼ
-- modify: �޸��ֽ��ȡ����ƥ���߼� at 2014-03-15 by liuxiang
-- modify: ���������˻�������ո���ˮ�໥ƥ�� at 2014-04-24 by liuxiang
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_match_bill]
WITH VIEW_METADATA
AS
	--���տ�֪ͨ����tfi_incomebill_m�в��icbm_status=9(����)��icbm_status=10(�����տ�)�ĵ���
	SELECT
		match_id = icbm_id,										--��id
		match_nbr = icbm_nbr,									--����
		match_nbr_name = ft.wfm_name,					--��������
		match_pay_code = icbm_rec_code,				--�Է�����(code)
		match_pay_code_name = fpi.pay_name,		--�Է�����(name)
		match_pay_code_fname = fpi.pay_fname,		--�Է�����(full_name)
		match_acct_id = NULL,								--�ҷ��˻�id
		match_pay_nbr = NULL,								--�Է��˺�
		match_currency = icbm_currency,					--�ұ�
		match_amt = ISNULL(icbm_inc_amt, 0.00),	--����ִ�н��
		match_real_amt = ISNULL(icbm_real_amt, 0.00),	--�Ѹ����
		match_status = icbm_status,							--���״̬
		match_ref_mid = NULL,								--��������mid
		match_ref_nbr = NULL	,								--��������
		match_type = tim.icbm_type,						--����:1���տ�֪ͨ��2��Ԥ��֪ͨ
		match_rmks = tim.icbm_rmks,						--��ע
		match_ref_type = 1										--1��ʾ��tfi_incomebill_m��
	FROM dbo.tfi_incomebill_m tim
	LEFT JOIN dbo.v_fi_paycode_info fpi ON tim.icbm_rec_code = fpi.pay_code
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(tim.icbm_nbr, 4) = ft.wfm_code
	WHERE icbm_status IN (9, 10) AND icbm_inc_amt <> icbm_real_amt
	UNION ALL
	SELECT
		match_id = exem_id,										--������id
		match_nbr = exem_nbr,								--����
		match_nbr_name = ft.wfm_name,					--��������
		match_pay_code = abhm.abhm_pay_code,	--�Է�����(code)
		match_pay_code_name = fpi.pay_name,		--�Է�����(name)
		match_pay_code_fname = fpi.pay_fname,		--�Է�����(full_name)
		match_acct_id = exem_acct_id,					--�ҷ��˻�id
		match_pay_nbr = abhm.abhm_pay_nbr,		--�Է��˺�
		match_currency = exem.exem_curr,		--�ұ�
		match_amt = ISNULL(exem_amt, 0.00),		--����ִ�н��
		match_real_amt = ISNULL(exem_real_amt, 0.00),	--�Ѹ����
		match_status = exem_status,							--���״̬
		match_ref_mid = exem_ref_mid,					--��������mid
		match_ref_nbr = exem_ref_nbr	,					--��������
		match_type = abhm.abhm_type,					--����:1�����2��Ԥ��
		match_rmks = exem.exem_rmks,					--��ע
		match_ref_type = 2										--2��ʾ�Ӹ���ִ�е�tfi_execute_m��
	FROM dbo.tfi_execute_m exem
	LEFT JOIN dbo.tfi_billhead_m abhm ON exem.exem_ref_mid = abhm.abhm_id AND exem.exem_ref_nbr = abhm.abhm_nbr
	LEFT JOIN dbo.v_fi_paycode_info fpi ON abhm.abhm_pay_code = fpi.pay_code
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(exem.exem_nbr, 4) = ft.wfm_code
	WHERE exem_status IN (5, 6) AND exem_amt <> exem_real_amt
	UNION ALL
	--������/�ж����뵥tfi_discount�в��dcnt_status=5(���)�ĵ���
	SELECT
		match_id = dcnt_id,													--��id
		match_nbr = dcnt_nbr,												--����
		match_nbr_name = ft.wfm_name,								--��������
		match_pay_code = '',												--�Է�����(code)
		match_pay_code_name = '',										--�Է�����(name)
		match_pay_code_fname = drft.drft_out_fullname,		--�Է�����(full_name)(��Ʊ��ȫ��)
		match_acct_id = dcnt_acct_id,									--�ҷ��˻�id
		match_pay_nbr = drft.drft_out_act,							--�Է��˺�(��Ʊ���ʺ�)
		match_currency = drft.drft_curr_type,						--�ұ�
		match_amt = ISNULL(dcnt_amt, 0.00),						--����ִ�н��(����/�жҽ��)
		match_real_amt = ISNULL(dcnt_confirm, 0.00),		--�Ѹ����
		match_status = dcnt_status,										--���״̬
		match_ref_mid = NULL,											--��������mid
		match_ref_nbr = NULL	,											--��������
		match_type = dcnt.dcnt_type,									--��ҵ����:1���жң�2������
		match_rmks = dcnt.dcnt_brief,									--��ע
		match_ref_type = 3													--3��ʾ��tfi_discount��
	FROM dbo.tfi_discount dcnt
	LEFT JOIN dbo.tfi_draft drft ON dcnt.dcnt_drft_id = drft.drft_id
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(dcnt.dcnt_nbr, 4) = ft.wfm_code
	WHERE dcnt_status = 5 AND dcnt_state <> 2
	--���ֽ��������tfi_cash_tx�в��cstx_status=5(���)�ĵ���
	--�����ֽ��׵��ܺ�������ˮ��ƥ�����ܺ��ֽ���ˮ��ƥ��
	--�������
	--match_ref_type=4��ʾ�ܺ�������ˮ��ƥ����ֽ��׵�
	--match_ref_type=5��ʾ�ܺ��ֽ���ˮ��ƥ����ֽ��׵�
	UNION ALL
	SELECT
		match_id = cstx_id,										--��id
		match_nbr = cstx_nbr,									--����
		match_nbr_name = ft.wfm_name,					--��������
		match_pay_code = '',									--�Է�����(code)
		match_pay_code_name = '',							--�Է�����(name)
		match_pay_code_fname = '',							--�Է�����(full_name)
		match_acct_id = cstx_acct_id,						--�ҷ��˻�id
		match_pay_nbr = NULL,								--�Է��˺�
		match_currency = cstx_curr_type,					--�ұ�
		match_amt = ISNULL(cstx_amt, 0.00),			--����ִ�н��(���׽��)
		match_real_amt = ISNULL(cstx_confirm, 0.00),	--�Ѹ����(�������)
		match_status = cstx_status,							--���״̬
		match_ref_mid = cstx_prior_id,					--��������mid
		match_ref_nbr = cstx_prior_nbr,					--��������
		match_type = cstx.cstx_op_type,					--ҵ�����ͣ�1�����֣�2��ȡ��
		match_rmks = cstx.cstx_brief,						--��ע
		match_ref_type = 4										--4��ʾ��tfi_cash_tx��
	FROM dbo.tfi_cash_tx cstx
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(cstx.cstx_nbr, 4) = ft.wfm_code
	WHERE cstx_status = 5 AND cstx_state <> 2
	UNION ALL
	SELECT
		match_id = cstx_id,										--��id
		match_nbr = cstx_nbr,									--����
		match_nbr_name = ft.wfm_name,					--��������
		match_pay_code = '',									--�Է�����(code)
		match_pay_code_name = '',							--�Է�����(name)
		match_pay_code_fname = '',							--�Է�����(full_name)
		match_acct_id = cstx_cact_id,						--�ֽ��ʺ�id
		match_pay_nbr = NULL,								--�Է��˺�
		match_currency = cstx_curr_type,					--�ұ�
		match_amt = ISNULL(cstx_amt, 0.00),			--����ִ�н��(���׽��)
		match_real_amt = ISNULL(cstx_cash_confirm, 0.00),	--�Ѹ����(�������)
		match_status = cstx_status,							--���״̬
		match_ref_mid = cstx_prior_id,					--��������mid
		match_ref_nbr = cstx_prior_nbr,					--��������
		match_type = cstx.cstx_op_type,					--ҵ�����ͣ�1�����֣�2��ȡ��
		match_rmks = cstx.cstx_brief,						--��ע
		match_ref_type = 5										--4��ʾ��tfi_cash_tx��
	FROM dbo.tfi_cash_tx cstx
	LEFT JOIN dbo.v_fi_twfm ft ON LEFT(cstx.cstx_nbr, 4) = ft.wfm_code
	WHERE cstx_status = 5 AND cstx_cash_state <> 2
	UNION ALL
	SELECT
		match_id = atsp_id,									--��id
		match_nbr = atsp_nbr,								--����
		match_nbr_name = '������ˮ',						--��������
		match_pay_code = '',								--�Է�����(code)
		match_pay_code_name = atsp_cust_name,				--�Է�����(name)
		match_pay_code_fname = atsp_cust_name,				--�Է�����(full_name)
		match_acct_id = atsp_acct_id,						--�ҷ��ʺ�id
		match_pay_nbr = atsp_cust_acct,						--�Է��˺�
		match_currency = atsp_curr,					        --�ұ�
		match_amt = ISNULL(atsp_amt, 0.00),					--����ִ�н��(���׽��)
		match_real_amt = 0.00,								--�Ѹ����(�������)
		match_status = NULL,								--���״̬
		match_ref_mid = NULL,								--��������mid
		match_ref_nbr = NULL,								--��������
		match_type = atsp.atsp_pay_type,					--ҵ������: 0,�տ�; 1,����;
		match_rmks = atsp.atsp_rmks,						--��ע
		match_ref_type = 8									--7��ʾ��������ˮ�ĸ�����ˮ
	FROM dbo.tfi_account_tx_split atsp
	WHERE atsp_status = 0 AND atsp_pay_type = 1 AND atsp_type = 0
	UNION ALL
		SELECT
		match_id = atsp_id,									--��id
		match_nbr = atsp_nbr,								--����
		match_nbr_name = '�տ���ˮ',						--��������
		match_pay_code = '',								--�Է�����(code)
		match_pay_code_name = atsp_cust_name,				--�Է�����(name)
		match_pay_code_fname = atsp_cust_name,				--�Է�����(full_name)
		match_acct_id = atsp_acct_id,						--�ҷ��ʺ�id
		match_pay_nbr = atsp_cust_acct,						--�Է��˺�
		match_currency = atsp_curr,					        --�ұ�
		match_amt = ISNULL(atsp_amt, 0.00),					--����ִ�н��(���׽��)
		match_real_amt = 0.00,								--�Ѹ����(�������)
		match_status = NULL,								--���״̬
		match_ref_mid = NULL,								--��������mid
		match_ref_nbr = NULL,								--��������
		match_type = atsp.atsp_pay_type,					--ҵ������: 0,�տ�; 1,����;
		match_rmks = atsp.atsp_rmks,						--��ע
		match_ref_type = 9									--7��ʾ��������ˮ�ĸ�����ˮ
	FROM dbo.tfi_account_tx_split atsp
	WHERE atsp_status = 0 AND atsp_pay_type = 0 AND atsp_type = 0

WITH CHECK OPTION;
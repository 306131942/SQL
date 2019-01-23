

-----------------增
INSERT INTO XXXX.dbo.tfi_pay_m VALUES (c1,c2,...)

INSERT INTO XXXX.dbo.tfi_billhead_m  (c1,c2,...) 
SELECT c1,c2,...
FROM XXXX.dbo.tfi_pay_m m
LEFT JOIN XXXX.dbo.tfi_billhead_d d ON m.paym_id=d.abhd_m_id
WHERE m.paym_id=13


-----------------删
DELETE FROM XXXX.dbo.tfi_pay_m WHERE paym_id=13


-----------------改
UPDATE XXXX.dbo.tfi_inv_in_d
SET ivid_offset_status=5
WHERE ivid_id=13

UPDATE m
SET m.paym_nbr = 'AP07'
FROM XXXX.dbo.tfi_pay_m m
LEFT JOIN XXXX.dbo.tfi_billhead_d d ON m.paym_id=d.abhd_m_id
WHERE m.paym_id=13


-----------------查
SET NOCOUNT ON; 
--建立索引优化例子
IF OBJECT_ID('tempdb..#pinfo') IS NOT NULL DROP TABLE #pinfo;
SELECT ctype, pay_code, pay_name INTO #pinfo FROM XXXX.dbo.v_fi_paycode_info
CREATE INDEX PIndex ON #pinfo (pay_code, ctype)

SELECT pay_code=vfpi.pay_code,pay_name=vfpi.pay_name
FROM  XXXX.dbo.tfi_billhead_m AS abhm 
LEFT JOIN XXXX.dbo.VFI_CORPORATION AS vfic ON abhm.abhm_legal = vfic.FICN_ID
LEFT JOIN #pinfo AS vfpi ON vfpi.pay_code=abhm.abhm_pay_code AND vfpi.ctype = abhm.abhm_paycode_type
WHERE abhm.abhm_type = 1
SET NOCOUNT OFF;


-----------------运维
BEGIN TRANSACTION

IF OBJECT_ID('t empdb..#bill') IS NOT NULL DROP TABLE #bill;--临时表用

--DECLARE @mid INT;
--DECLARE @nbr VARCHAR(20);

SELECT c1,c2,...
INTO #bill
FROM XXXX.dbo.tfi_pay_m tpm
WHERE  tpm.isenable = 1  ...

WHILE EXISTS (SELECT 1 FROM #bill)--循环
BEGIN
	--do something
	--循环删除
	DELETE FROM #bill WHERE c1 = @mid
END

--删除临时表
DROP TABLE #bill

--提交
COMMIT TRANSACTION
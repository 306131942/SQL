USE FIDB
GO

IF(OBJECT_ID('dbo.v_sa_cust_lamt_for_fi') IS NULL)
BEGIN
    EXEC('CREATE VIEW v_sa_cust_lamt_for_fi AS SELECT 1 as id;')
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<liuxiang>
-- Create date: <2018-0--27>
-- Description:	<销售客户对账单期末余额视图>
-- Modify[1]:	
-- =============================================

ALTER VIEW dbo.v_sa_cust_lamt_for_fi
WITH VIEW_METADATA 
AS
WITH
 cust AS(
 	SELECT DISTINCT actm_cust,actm_curr,actm_legal 
	FROM HSAL.dbo.tsa_acct_m WHERE actm_cust<>''
 ),
 tempID AS(
 	SELECT ID,actm_date
	FROM   (
           SELECT rn = ROW_NUMBER() OVER(
                      PARTITION BY actm_cust,
                      actm_legal,
                      actm_curr ORDER BY actm_id DESC
                  ),
                  a.actm_id AS ID,
                  actm_date=DATEADD(D,1,a.actm_enddate)
           FROM   HSAL..tsa_acct_m a
           WHERE  a.actm_audit_status ='5' AND DATEADD(D,1,a.actm_enddate)<'2017-04-01'
       ) b 
	WHERE  rn = 1 AND ID<>0
 ) ,
 aft AS(
 	SELECT 
		tam.actm_nbr,
		tam.actm_cust,
		tam.actm_legal,
		actm_date=DATEADD(D,1,tam.actm_enddate),
		tam.actm_type,
		amt =(CASE WHEN actm_type = 2 THEN ISNULL(actm_ccamt, 0)
						   ELSE actm_bamt+actm_ccamt-actm_dedamt-actm_crdamt+ISNULL(c.actd_amt,0)
						   END),--如果没有调账金额就是NULL-->0，所以加上调账不影响结果
		  actm_curr = (CASE WHEN (tam.actm_curr='UD1' OR tam.actm_curr='UD2' OR tam.actm_curr='UD3') THEN 'USD'
		  WHEN (tam.actm_curr='EU1' OR tam.actm_curr='EU2') THEN 'EUR'
		  WHEN tam.actm_curr='RM1' THEN 'RMB'
		  ELSE tam.actm_curr END)
		,actm_dept
		,actm_id
	FROM hsal.dbo.tsa_acct_m tam  --关联调账明细，一个对账单只能有一笔调账。
	LEFT JOIN (SELECT actd_actm_id,actd_amt
	   FROM   hsal..tsa_acct_d
		WHERE  actd_spvm_id IS NULL
	) c ON  c.actd_actm_id = tam.actm_id 
	WHERE DATEADD(D,1,tam.actm_enddate) >= '2017-04-01' AND tam.actm_audit_status=5
 ),
 bef AS(
 	SELECT 
		b.actm_nbr,
		c.actm_cust,
		c.actm_legal,
		actm_date='2017-04-01',
		actm_type = CASE WHEN ISNULL(b.actm_nbr,'')='' THEN 4 ELSE 3 END,
		amt =(CASE WHEN actm_type = 2 THEN ISNULL(actm_ccamt, 0)
						   ELSE actm_bamt+actm_ccamt-actm_dedamt-actm_crdamt+ISNULL(d.actd_amt,0)
						   END),
		actm_curr = (CASE WHEN (b.actm_curr='UD1' OR b.actm_curr='UD2' OR b.actm_curr='UD3') THEN 'USD'
		  WHEN (b.actm_curr='EU1' OR b.actm_curr='EU2') THEN 'EUR'
		  WHEN b.actm_curr='RM1' THEN 'RMB'
		  ELSE b.actm_curr END)
		 ,actm_dept
		 ,actm_id
	FROM cust c
	LEFT JOIN(
		SELECT m.* 
		FROM tempID aid
		LEFT JOIN hsal.dbo.tsa_acct_m m ON m.actm_id=aid.ID
	) b ON b.actm_cust=c.actm_cust AND b.actm_curr=c.actm_curr AND b.actm_legal=c.actm_legal
	LEFT JOIN (SELECT actd_actm_id,actd_amt
	   FROM   hsal..tsa_acct_d
		WHERE  actd_spvm_id IS NULL
	) d ON  d.actd_actm_id = b.actm_id 
 )
	SELECT
		 actm_nbr,
		 actm_cust,
		 actm_curr,
		 actm_legal,
		 actm_date,
		 amt=amt,
		 actm_dept,
		 actm_id
	FROM (
	SELECT * FROM bef 
	where amt>0
	UNION ALL
	SELECT * FROM aft
	) a WHERE a.actm_type IN (1,3)
WITH CHECK OPTION;
GO
1,���� ANSI_NULLS �� QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 ��׼Ҫ���ڶԿ�ֵ���е��� (=) �򲻵��� (<>) �Ƚ�ʱȡֵΪ FALSE
GO
SET QUOTED_IDENTIFIER ON --��ʶ��������˫���ŷָ�
GO

2,SQL SERVER���ݿ������Ż�_ִ�мƻ�ƪ
	ѡ�����-����ѯ-����ʾ���Ƶ�ִ�мƻ�������ʵ�ʵ�ִ�мƻ��������ͻ���ͳ����Ϣ��
	set statistics profile on
	set statistic io on
	set statistic time on
	go
	select ......
	
3,SQL SERVER -���ݿ���ҵ���α�
	��ҵ����һϵ����SQL Server����˳��ִ�е�ָ����������ʱִ����Ҫ���еĽű�����
	�α꣺
	
4,��ͼ
���������淶
ʹ�ã��ͱ��ʹ��һ��
���ģ���spһ��
ɾ����DROP VIEW view_name

5������
������CREATE ��UNIQUE�� INDEX index_name
ON table_name (column_name)

CREATE INDEX PersonIndex
ON Person (LastName) 

CREATE INDEX PersonIndex
ON Person (LastName DESC) 

CREATE INDEX PersonIndex
ON Person (LastName, FirstName)


ʹ�ã�
���ģ�
ɾ����DROP INDEX table_name.index_name

6��������������������������
DROP TABLE �������ɾ������Ľṹ�������Լ�����Ҳ�ᱻɾ������
DROP TABLE ������


7��
%���һ�������ַ�
_һ���ַ�
like"%%"
not like"%%"
��ס�ĳ����� "A" �� "L" �� "N" ��ͷ���ˣ�WHERE City LIKE '[ALN]%'
���� "A" �� "L" �� "N" ��ͷ���ˣ�where city like '![ALN]%'

8��
DECLARE @rate DECIMAL(19, 4)
���̶����Ⱥ�С��λ������ֵ�������͡�
decimal [ (p [ , s ] ) ]
numeric [ (p [, s ] ) ]
pΪ���洢��ʮ���Ƶ���λ��������С�������ҵ�λ����1��38��Ĭ��Ϊ18
С�����ұ߿��Դ洢��ʮ�������ֵ����λ����С��λ�������Ǵ� 0 �� p ֮���ֵ��
����ָ�����Ⱥ�ſ���ָ��С��λ����Ĭ�ϵ�С��λ��Ϊ 0����ˣ�0 <= s <= p��

SET  @effdate=CAST(CONVERT(VARCHAR(20),@effdate,23) AS DATETIME)
CAST ( expression AS data_type )
convert ( data_type, expression [, style ] ) 
����ת��Ϊ data_type �� expression��


9��
�� SET NOCOUNT Ϊ ON ʱ�������ؼ�����
�� SET NOCOUNT Ϊ OFF ʱ�����ؼ�����
 ���ۣ�����Ӧ���ڴ洢���̵�ͷ������SET NOCOUNT ON �����Ļ������˳��洢���̵�ʱ�����SET NOCOUNT OFF�����Ļ����Դﵽ�Ż�

��ʹ�� SET NOCOUNT Ϊ ON ʱ��Ҳ���� @@ROWCOUNT ��������@@ROWCOUNT ��������һ���Ӱ�����������
�� SET NOCOUNT Ϊ ON ʱ��������ͻ��˷��ʹ洢������ÿ������ DONE_IN_PROC ��Ϣ��
����洢�����а���һЩ�����������ʵ�����ݵ���䣬����������̰��� Transact-SQL ѭ��������ͨ���������������٣���ˣ��� SET NOCOUNT ����Ϊ ON ������������ܡ�
SET NOCOUNT ָ������������ִ�л�����ʱ��Ч���������ڷ���ʱ��Ч��


BEGIN TRY
    -- Generate a divide-by-zero error.
    SELECT 1/0;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber
        ,ERROR_SEVERITY() AS ErrorSeverity
        ,ERROR_STATE() AS ErrorState
        ,ERROR_PROCEDURE() AS ErrorProcedure
        ,ERROR_LINE() AS ErrorLine
        ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
GO
 
TRY...CATCH ʹ�����д����������������Ϣ��
ERROR_NUMBER() ���ش���š�
ERROR_MESSAGE() ���ش�����Ϣ�������ı������ı�����Ϊ�κο��滻�������糤�ȡ���������ʱ�䣩�ṩ��ֵ��
ERROR_SEVERITY() ���ش��������ԡ�
ERROR_STATE() ���ش���״̬�š�
ERROR_LINE() ���ص��´���������е��кš�
ERROR_PROCEDURE() ���س��ִ���Ĵ洢���̻򴥷��������ơ�

����ʹ����Щ������ TRY...CATCH ����� CATCH ����������е��κ�λ�ü���������Ϣ������� CATCH ���������֮����ô�������
������������ NULL���� CATCH ����ִ�д洢����ʱ�������ڴ洢���������ô��������������ڼ���������Ϣ��
������������򲻱���ÿ�� CATCH �����ظ���������롣

10��
go
�� SQL Server ʵ�ù��߷���һ�� Transact-SQL ���������źš�������������������

USE AdventureWorks2008R2;
GO
DECLARE @MyMsg VARCHAR(50)
SELECT @MyMsg = 'Hello, World.'
GO -- @MyMsg is not valid after this GO ends the batch.
-- Yields an error because @MyMsg not declared in this batch.
PRINT @MyMsg
GO
SELECT @@VERSION;--version, ���ص�ǰ�� SQL Server ��װ�İ汾����������ϵ�ṹ���������ںͲ���ϵͳ��
-- Yields an error: Must be EXEC sp_who if not first statement in  batch.
sp_who
GO

11�� try...catch
TRY��CATCH ������������֣�һ�� TRY ���һ�� CATCH �顣����� TRY ���ڵ� Transact-SQL ����м�⵽��������������ƽ������ݵ� CATCH �飨���ڴ˿��д���˴��󣩡�
ÿ�� TRY...CATCH ���춼����λ��һ���������洢���̻򴥷����С����磬���ܽ� TRY �������һ���������ж��������� CATCH ���������һ���������С�

12,
select����ʾ�ڽ����
print:��ʾ����Ϣ��


13��
raiserror==>RAISERROR�����ɴ�����Ϣ�������Ự�Ĵ���������Ϣ��Ϊ������������Ϣ���ص�����Ӧ�ó��򣬻򷵻ص�TRY...CATCH����Ĺ���catch��



14��SQLע��
��������ҳ�л�ȡ�û����룬������ȡ�����ַ���ƴ�ӳ�sql��ִ�еĻ����Ϳ��ܻᷢ����ȫ���գ�
�õ��ĺܿ����ǻ����㲻֪�����������е� SQL ��䡣
�û��ṩ�����ݣ�ʹ����Щ����֮ǰ�����������֤��
ͨ������֤������ģʽƥ������ɣ�

��:У�������ǳƣ���������ĸ�����ֺ��»�����ɣ����ҳ����� 8 �� 20 ֮��

15��ģʽƥ��
�����ݽṹ���ַ�����һ�ֻ������㣬����һ���Ӵ���Ҫ����ĳ���ַ������ҳ�����Ӵ���ͬ�������Ӵ��������ģʽƥ�䡣









--ѧϰ������ϴ���github��
--E:\SCEO2.0\web\My-github

--SQL:
--E:\lcg\sqlѧϰ����

--VUE�򵥵���Ŀ�������һ��ģ����ɣ������ӿ�
--E:\SCEO2.0\IT10



--VSS����: tools==> find in files  ��*�ؼ���*



--����ͺ�ͬ��һ��������ܶ����ͬ
SELECT cntm_code, cntm_proj_id, * FROM fidb.dbo.tfi_contract_m
SELECT proj_code, * FROM fidb.dbo.tfi_proj


����vs·��
C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe


--����ת��
select Convert(VARCHAR(10),0.2) +'kkk'
select Convert(decimal(18,2),0.2)
SELECT CAST(0.22 AS VARCHAR(10))


--дsql�����ж�ʱ������null�����
DECLARE @t1 MONEY=NULL
SET  @t1 = @t1 + 2  
IF(@t1>0)--@t1=null
BEGIN 
 SELECT 1 --������
END 



IF OBJECT_ID('tempdb..#bill') IS NOT NULL DROP TABLE #bill;

USE fidb
GO

SELECT * FROM fidb.dbo.tfi_

DROP TABLE xxxx

UPDATE D
SET D.abhd_id = 1
FROM fidb.dbo.tfi_billhead_d d
LEFT JOIN  fidb.dbo.tfi_pay_m pm ON pm.paym_id
WHERE 

UPDATE fidb.dbo.tfi_collect_proj_m
SET tcpm_accumulate_way = 3
WHERE tcpm_id

DELETE 
FROM  fidb.dbo.tfi_account_tx 
WHERE actx_id = actx_id


SELECT TOP 20 rn = row_number() over (partition by wfna_m_id order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a --WHERE a.wfna_emp_id = '00000001' AND a.wfna_state = 0
--ʹ��row_number�����������б��
SELECT TOP 20 rn = row_number() over (order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a

--http://www.studyofnet.com/news/180.html(��ʱ�俴��)


SELECT  rn = row_number() over (partition by splr_name_cn order by splr_id asc),splr_code,splr_name_cn, * FROM HSRP.dbo.tfi_suppliers




С���㴦��--------------------------------------------------------------
--	1��numeric �ڹ����ϵȼ��� decimal������������Ĺ���
--	decimal[ (p[ , s] )] �� numeric[ (p[ , s] )]
--	Ĭ��decimal(18,0)
--	p�����ȣ�
--	�����Դ洢��ʮ�������ֵ���λ��������С������ߺ��ұߵ�λ�����þ��ȱ����Ǵ� 1 ����󾫶� 38 ֮���ֵ��Ĭ�Ͼ���Ϊ 18��
--	s��С��λ����
--	С�����ұ߿��Դ洢��ʮ�������ֵ����λ����С��λ�������Ǵ� 0 �� p ֮���ֵ��
--	����ָ�����Ⱥ�ſ���ָ��С��λ����Ĭ�ϵ�С��λ��Ϊ 0����ˣ�0 <= s <= p�����洢��С���ھ��ȶ��仯��
SELECT
select Convert(decimal(18,2),0.125) 
select Convert(numeric(18,2),123123123.211555) 
select Convert(numeric,1123123.255555) 

--2��ROUND ( numeric_expression , length [ ,function ] )���������룻ԭ����С����λ�����䣬�����������нضϵĹ���
--	length 
--		numeric_expression �����뾫�ȡ�length ������ tinyint��smallint �� int ���͵ı��ʽ��
--		��� length Ϊ�������� numeric_expression ���뵽 length ָ����С��λ������� length Ϊ�������� numeric_expression С������߲������뵽 length ָ���ĳ��ȡ�
--	function(�������,0Ĭ��,���ض�,����ֵ�ض�,����������)
--		Ҫִ�еĲ��������͡�function ����Ϊ tinyint��smallint �� int��
--		���ʡ�� function ����ֵΪ 0��Ĭ��ֵ���������� numeric_expression�����ָ���� 0 �����ֵ���򽫽ض� numeric_expression��
SELECT ROUND(12.55555,2),ROUND(12.55555,1), ROUND(12.55555,0), ROUND(12.55555,-1), ROUND(12.55555,-2)
SELECT ROUND(123.5555555,-2, 0),ROUND(123.55555555555,2, 0)
SELECT ROUND(123.123456789,-3, 2), ROUND(123.123456789,-1, 2), ROUND(123.123456789,0, 2), ROUND(123.123456789,1, 2)



DELETE HPORTAL.dbo.twf_a WHERE wfna_m_id = @tdmm_id ANd wfna_table='fidb.dbo.tfi_dealing_match_a'
DELETE fidb.dbo.tfi_dealing_match_a WHERE wfna_m_id =@tdmm_id
DELETE fidb.dbo.tfi_dealing_match_d WHERE tdmd_tdmm_id=@tdmm_id
DELETE fidb.dbo.tfi_dealing_match_m WHERE tdmm_id=@tdmm_id


IF OBJECT_ID('tempdb..#temp_pay') IS NOT NULL DROP TABLE #temp_pay;		
SELECT * INTO #temp_pay  FROM

WHILE EXISTS (SELECT 1 FROM #temp_pay)
BEGIN
	--ѭ��ɾ��
	DELETE FROM #temp_pay WHERE 
END

DROP TABLE #temp_pay



select * into #pay_m1 from (
SELECT a=null,b=1
UNION ALL
SELECT a=null,b=2
UNION ALL
SELECT a=1,b=3	
)a
SELECT * FROM #pay_m1

SELECT sum(b-a) FROM #pay_m1


                                                                     
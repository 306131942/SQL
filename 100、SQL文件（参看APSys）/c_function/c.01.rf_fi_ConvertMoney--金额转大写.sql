--1.�г�ʹ�ÿ���
USE [FIDB]
GO

--2.��Ӹ��º������ж�
IF OBJECT_ID('rf_fi_ConvertMoney') IS NOT NULL
BEGIN
	DROP FUNCTION rf_fi_ConvertMoney;
END
GO

--3.���� ANSI_NULLS �� QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 ��׼Ҫ���ڶԿ�ֵ���е��� (=) �򲻵��� (<>) �Ƚ�ʱȡֵΪ FALSE
GO

SET QUOTED_IDENTIFIER ON --��ʶ��������˫���ŷָ�
GO

--4.��д�����Ļ�����Ϣ
-- =========================================================================================
-- Author:		wujian
-- Create date: 2017-10-21
-- Description:	���ڽ�Сд����ֵ����ɴ�д���ַ�����֧�ֵ��֣���С�������λ��

-- ע�����ڸ�ʽʹ�� yyyy-MM-dd��Modify [n] n�����޸���ţ���1��ʼ��ÿ���޸ļ�1��
-- =========================================================================================

--5.�ڴ�������ʱ���������������淶��fn_������ĸ��ģ��Ӣ����д_�������ܱ�ʶ��
CREATE FUNCTION rf_fi_ConvertMoney
(
	--6.����������( )��������ÿ��һ��
	@decNum decimal(18,2)  --���
)
RETURNS VARCHAR(200)  	--7.�����������ͣ���ֵ������ʹ��'������ֵ����'����'������ֵ����'��
WITH SCHEMABINDING  --8.��SQL��ѯ��������ж�����ͬһ�����ݿ⣬�������SCHEMABINDING
AS
BEGIN
 DECLARE @chvNum varchar(200)  
 DECLARE @chvMoney varchar(200)  
 DECLARE @chvTemp varchar(200)  
 DECLARE @intIntLen int  
 DECLARE @intI int  
 DECLARE @chvTempI varchar(200)  
 DECLARE @chvReturn varchar(200)  
  
 IF @decNum=0   
  SET @chvMoney = '��'  
 ElSE 
 BEGIN  
   
  SET @chvTemp=convert(varchar(200),Round(@decNum*100,0))  
  IF charindex('.',@chvTemp,1)>0  
   SET @chvNum=left(@chvTemp,charindex('.',@chvTemp,1)-1)  
  ELSE  
   SET @chvNum=@chvTemp  
    
  SET @intIntLen=len(@chvNum)  
    
  SET @chvMoney=''  
  Set @chvReturn = ''  
  SET @intI=1  
    
  WHILE @intI <= @intIntLen  
  BEGIN  
   SET @chvTempI = substring(@chvNum,@intIntLen-@intI+1,1)  
   SET @chvMoney = substring('��Ҽ��������½��ƾ�',convert(int,@chvTempI)+1,1) + substring('�ֽ�Ԫʰ��Ǫ��ʰ��Ǫ��ʰ��Ǫ��ʰ��Ǫ��ʰ��Ǫ',(@intI-1)+1,1)  
   SET @intI = @intI + 1       
   SET @chvReturn = @chvMoney + @chvReturn  
  END  
 END  
  
 SET @chvReturn=Replace(@chvReturn,'��Ǫ','��')  
 SET @chvReturn=Replace(@chvReturn,'���','��')  
 SET @chvReturn=Replace(@chvReturn,'��ʰ','��')  
  
 while charindex('����',@chvReturn,1)>0  
  SET @chvReturn=Replace(@chvReturn,'����','��')  
 
 SET @chvReturn=Replace(@chvReturn,'����','��')  
 SET @chvReturn=Replace(@chvReturn,'����','��')  
 SET @chvReturn=Replace(@chvReturn,'����','��')  
 SET @chvReturn=Replace(@chvReturn,'��Ԫ','Ԫ')  
 SET @chvReturn=Replace(@chvReturn,'������','��')  
 SET @chvReturn=Replace(@chvReturn,'���','��')  
 SET @chvReturn=Replace(@chvReturn,'���','��')  
 SET @chvReturn=LTRIM(RTRIM(@chvReturn))  
   
 RETURN @chvReturn  	

END


--SELECT fidb.dbo.rf_fi_ConvertMoney('2.1113')
--SELECT fidb.dbo.rf_fi_ConvertMoney(123)
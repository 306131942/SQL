--1.列出使用库名
USE [FIDB]
GO

--2.添加更新函数的判断
IF OBJECT_ID('rf_fi_ConvertMoney') IS NOT NULL
BEGIN
	DROP FUNCTION rf_fi_ConvertMoney;
END
GO

--3.设置 ANSI_NULLS 和 QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 标准要求在对空值进行等于 (=) 或不等于 (<>) 比较时取值为 FALSE
GO

SET QUOTED_IDENTIFIER ON --标识符可以由双引号分隔
GO

--4.填写函数的基本信息
-- =========================================================================================
-- Author:		wujian
-- Create date: 2017-10-21
-- Description:	用于将小写的数值翻译成大写的字符串（支持到分，即小数点后两位）

-- 注：日期格式使用 yyyy-MM-dd。Modify [n] n代表修改序号，从1开始，每次修改加1。
-- =========================================================================================

--5.在创建函数时，对象名按命名规范（fn_两个字母的模块英文缩写_函数功能标识）
CREATE FUNCTION rf_fi_ConvertMoney
(
	--6.参数变量用( )括起来，每个一行
	@decNum decimal(18,2)  --金额
)
RETURNS VARCHAR(200)  	--7.返回数据类型（表值函数请使用'多语句表值函数'代替'内联表值函数'）
WITH SCHEMABINDING  --8.如SQL查询语句中所有对象都是同一个数据库，则需加上SCHEMABINDING
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
  SET @chvMoney = '零'  
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
   SET @chvMoney = substring('零壹贰叁肆伍陆柒捌玖',convert(int,@chvTempI)+1,1) + substring('分角元拾佰仟万拾佰仟亿拾佰仟兆拾佰仟京拾佰仟',(@intI-1)+1,1)  
   SET @intI = @intI + 1       
   SET @chvReturn = @chvMoney + @chvReturn  
  END  
 END  
  
 SET @chvReturn=Replace(@chvReturn,'零仟','零')  
 SET @chvReturn=Replace(@chvReturn,'零佰','零')  
 SET @chvReturn=Replace(@chvReturn,'零拾','零')  
  
 while charindex('零零',@chvReturn,1)>0  
  SET @chvReturn=Replace(@chvReturn,'零零','零')  
 
 SET @chvReturn=Replace(@chvReturn,'零兆','兆')  
 SET @chvReturn=Replace(@chvReturn,'零亿','亿')  
 SET @chvReturn=Replace(@chvReturn,'零万','万')  
 SET @chvReturn=Replace(@chvReturn,'零元','元')  
 SET @chvReturn=Replace(@chvReturn,'零角零分','整')  
 SET @chvReturn=Replace(@chvReturn,'零角','零')  
 SET @chvReturn=Replace(@chvReturn,'零分','整')  
 SET @chvReturn=LTRIM(RTRIM(@chvReturn))  
   
 RETURN @chvReturn  	

END


--SELECT fidb.dbo.rf_fi_ConvertMoney('2.1113')
--SELECT fidb.dbo.rf_fi_ConvertMoney(123)
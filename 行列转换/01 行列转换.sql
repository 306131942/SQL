

/*-----1 ʵ����ת��--------------------------*/

/*-----1.1 Case WHEN ʵ����ת��----------*/

--(1)��̬SQL
SELECT [����],
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end) AS ����,
 max(CASE �γ� WHEN '��ѧ' THEN ���� ELSE 0 end)AS ��ѧ,
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end)AS ����,
 SUM(����) AS �ܷ�,
 AVG(����) AS ƽ����
FROM tbScore GROUP BY [����]
SELECT  * FROM  tbScore




SELECT [����],
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end) AS ����,
 max(CASE �γ� WHEN '��ѧ' THEN ���� ELSE 0 end) AS ��ѧ,
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end) AS ����
FROM tbScoreNew GROUP BY [����]

SELECT [����],
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end) AS ����,
 max(CASE �γ� WHEN '��ѧ' THEN ���� ELSE 0 end) AS ��ѧ,
 max(CASE �γ� WHEN '����' THEN ���� ELSE 0 end) AS ����
FROM tbScore  GROUP BY [����]
SELECT  * FROM  tbScore
SELECT ����,	����,	��ѧ,	���� FROM tbScoreNew

--(2)��̬SQL
DECLARE @sql VARCHAR(500)
SET @sql = 'SELECT [����]'
SELECT  @sql = @sql + ',MAX(CASE [�γ�] WHEN ''' + [�γ�] + ''' THEN [����] ELSE 0 END)[' + [�γ�] + ']'
FROM    ( 
			SELECT DISTINCT [�γ�] FROM tbScore
        ) T1
--ͬFROM tbScore  GROUP BY [�γ�]��Ĭ�ϰ��γ�������
SET @sql = @sql + ' FROM tbScore GROUP BY [����]'
select '@sql: ' + @sql
EXEC(@sql)
SELECT  * FROM  tbScore


DECLARE @sql VARCHAR(500)
declare @sql2 varchar(500)='';
SET @sql = 'SELECT '
SELECT  @sql2 = @sql2 + ',MAX(CASE [�γ�] WHEN ''' + [�γ�] + ''' THEN [����] ELSE 0 END)[' + [�γ�] + ']'
FROM    ( 
			SELECT DISTINCT [�γ�] FROM tbScore
        ) T1
--ͬFROM tbScore  GROUP BY [�γ�]��Ĭ�ϰ��γ�������
SET @sql2 = substring(@sql2, 2, LEN(@sql2))
SET @sql = @sql + @sql2 + ' FROM tbScore '
select '@sql: ' + @sql
EXEC(@sql)
SELECT  * FROM  tbScore
SELECT    [����] , [�γ�] ,[����] FROM      tbScore


/*-----1.2.PIVOT ʵ����ת��----------*/
--(1)��̬SQL
SELECT  [����] ,
        [����] ,
        [��ѧ] ,
        [����]
FROM    ( SELECT    [����] ,
                    [�γ�] ,
                    [����]
          FROM      tbScore
        ) AS SourceTable PIVOT ( AVG([����]) FOR [�γ�] IN ( ����, ��ѧ, ���� ) ) T
        

--(2)��̬SQL
DECLARE @sql2 VARCHAR(8000)
SET @sql2 = ''
SELECT @sql2 = @sql2 + ',' + [�γ�] FROM dbo.tbScore GROUP BY [�γ�]
--STUFF�� ɾ��ָ�����ȵ��ַ�������ָ������㴦������һ���ַ���
SET @sql2= STUFF(@sql2,1,1,'')  --ȥ���׸�','
SET @sql2 = 'SELECT [����],' + @sql2 + ' FROM (SELECT [����],[�γ�],[����] FROM tbScore ) AS SourceTable PIVOT ( AVG([����]) FOR [�γ�] IN ( ' + @sql2 + ') ) T'
PRINT @sql2
EXEC(@sql2)



/*-----2 ʵ����ת��--------------------------*/

/*-----2.1 UNION ʵ����ת��----------*/

SELECT ����,	����,	��ѧ,	���� FROM tbScoreNew
--(1)��̬SQL
SELECT * FROM (
	SELECT [����],'����' AS �γ�,[����] AS ���� ,[����] FROM tbScoreNew
	UNION ALL
	SELECT [����],'��ѧ' AS �γ�,[��ѧ] AS ���� ,[����] FROM tbScoreNew
	UNION ALL
	SELECT [����],'����' AS �γ�,[����] AS ���� ,[����] FROM tbScoreNew
) T ORDER BY [����]

--(2)��̬SQL
DECLARE @sql3 VARCHAR(8000)
SELECT @sql3 = ISNULL(@sql3 + ' UNION ALL ','') + ' SELECT [����],' + QUOTENAME(name,'''') + ' AS �γ�,' + QUOTENAME(name) + ',[����] FROM tbScoreNew'
FROM sys.columns 
WHERE object_id = OBJECT_ID('tbScoreNew') AND  name NOT IN ('����','����')
SET @sql3 = 'SELECT * FROM ( ' + @sql3  + ' ) T ORDER BY [����]'
SELECT  @sql3
EXEC (@sql3)


SELECT ����,	����,	��ѧ,	���� FROM tbScoreNew
SELECT * FROM (  
	SELECT [����],'����' AS �γ�,[����],[����] FROM tbScoreNew 
	 UNION ALL
	SELECT [����],'��ѧ' AS �γ�,[��ѧ],[����] FROM tbScoreNew 
	 UNION ALL
	SELECT [����],'����' AS �γ�,[����],[����] FROM tbScoreNew 
	) T ORDER BY [����]


/*-----2.2 UNPIVOT ʵ����ת��----------*/
--(1)��̬SQL
SELECT * FROM (
	SELECT [����],[����],[����],[��ѧ],[����] FROM dbo.tbScoreNew
) T UNPIVOT ([����] FOR [�γ�] IN ([����],[��ѧ],[����])) T2
ORDER BY [����]


--(2)��̬SQL
DECLARE @sql4 VARCHAR(8000)
SELECT @sql4 = ISNULL(@sql4 + ',','') + QUOTENAME(name)
FROM sys.columns 
WHERE object_id = OBJECT_ID('tbScoreNew') AND  name NOT IN ('����','����')
SET @sql4 = 'SELECT * FROM ( SELECT [����],[����],' + @sql4 + ' FROM dbo.tbScoreNew ) T UNPIVOT ([����] FOR [�γ�] IN ('+ @sql4 +')) T2 ORDER BY [����]'
PRINT @sql4
EXEC (@sql4)







































/*-----1 实现行转列--------------------------*/

/*-----1.1 Case WHEN 实现行转列----------*/

--(1)静态SQL
SELECT [姓名],
 max(CASE 课程 WHEN '语文' THEN 分数 ELSE 0 end) AS 语文,
 max(CASE 课程 WHEN '数学' THEN 分数 ELSE 0 end)AS 数学,
 max(CASE 课程 WHEN '物理' THEN 分数 ELSE 0 end)AS 物理,
 SUM(分数) AS 总分,
 AVG(分数) AS 平均分
FROM tbScore GROUP BY [姓名]
SELECT  * FROM  tbScore




SELECT [姓名],
 max(CASE 课程 WHEN '语文' THEN 分数 ELSE 0 end) AS 语文,
 max(CASE 课程 WHEN '数学' THEN 分数 ELSE 0 end) AS 数学,
 max(CASE 课程 WHEN '物理' THEN 分数 ELSE 0 end) AS 物理
FROM tbScoreNew GROUP BY [姓名]

SELECT [姓名],
 max(CASE 课程 WHEN '语文' THEN 分数 ELSE 0 end) AS 语文,
 max(CASE 课程 WHEN '数学' THEN 分数 ELSE 0 end) AS 数学,
 max(CASE 课程 WHEN '物理' THEN 分数 ELSE 0 end) AS 物理
FROM tbScore  GROUP BY [姓名]
SELECT  * FROM  tbScore
SELECT 姓名,	语文,	数学,	物理 FROM tbScoreNew

--(2)动态SQL
DECLARE @sql VARCHAR(500)
SET @sql = 'SELECT [姓名]'
SELECT  @sql = @sql + ',MAX(CASE [课程] WHEN ''' + [课程] + ''' THEN [分数] ELSE 0 END)[' + [课程] + ']'
FROM    ( 
			SELECT DISTINCT [课程] FROM tbScore
        ) T1
--同FROM tbScore  GROUP BY [课程]，默认按课程名排序
SET @sql = @sql + ' FROM tbScore GROUP BY [姓名]'
select '@sql: ' + @sql
EXEC(@sql)
SELECT  * FROM  tbScore


DECLARE @sql VARCHAR(500)
declare @sql2 varchar(500)='';
SET @sql = 'SELECT '
SELECT  @sql2 = @sql2 + ',MAX(CASE [课程] WHEN ''' + [课程] + ''' THEN [分数] ELSE 0 END)[' + [课程] + ']'
FROM    ( 
			SELECT DISTINCT [课程] FROM tbScore
        ) T1
--同FROM tbScore  GROUP BY [课程]，默认按课程名排序
SET @sql2 = substring(@sql2, 2, LEN(@sql2))
SET @sql = @sql + @sql2 + ' FROM tbScore '
select '@sql: ' + @sql
EXEC(@sql)
SELECT  * FROM  tbScore
SELECT    [分数] , [课程] ,[姓名] FROM      tbScore


/*-----1.2.PIVOT 实现行转列----------*/
--(1)静态SQL
SELECT  [姓名] ,
        [语文] ,
        [数学] ,
        [物理]
FROM    ( SELECT    [分数] ,
                    [课程] ,
                    [姓名]
          FROM      tbScore
        ) AS SourceTable PIVOT ( AVG([分数]) FOR [课程] IN ( 语文, 数学, 物理 ) ) T
        

--(2)动态SQL
DECLARE @sql2 VARCHAR(8000)
SET @sql2 = ''
SELECT @sql2 = @sql2 + ',' + [课程] FROM dbo.tbScore GROUP BY [课程]
--STUFF： 删除指定长度的字符，并在指定的起点处插入另一组字符。
SET @sql2= STUFF(@sql2,1,1,'')  --去掉首个','
SET @sql2 = 'SELECT [姓名],' + @sql2 + ' FROM (SELECT [分数],[课程],[姓名] FROM tbScore ) AS SourceTable PIVOT ( AVG([分数]) FOR [课程] IN ( ' + @sql2 + ') ) T'
PRINT @sql2
EXEC(@sql2)



/*-----2 实现列转行--------------------------*/

/*-----2.1 UNION 实现列转行----------*/

SELECT 姓名,	语文,	数学,	物理 FROM tbScoreNew
--(1)静态SQL
SELECT * FROM (
	SELECT [姓名],'语文' AS 课程,[语文] AS 分数 ,[日期] FROM tbScoreNew
	UNION ALL
	SELECT [姓名],'数学' AS 课程,[数学] AS 分数 ,[日期] FROM tbScoreNew
	UNION ALL
	SELECT [姓名],'物理' AS 课程,[物理] AS 分数 ,[日期] FROM tbScoreNew
) T ORDER BY [姓名]

--(2)动态SQL
DECLARE @sql3 VARCHAR(8000)
SELECT @sql3 = ISNULL(@sql3 + ' UNION ALL ','') + ' SELECT [姓名],' + QUOTENAME(name,'''') + ' AS 课程,' + QUOTENAME(name) + ',[日期] FROM tbScoreNew'
FROM sys.columns 
WHERE object_id = OBJECT_ID('tbScoreNew') AND  name NOT IN ('姓名','日期')
SET @sql3 = 'SELECT * FROM ( ' + @sql3  + ' ) T ORDER BY [姓名]'
SELECT  @sql3
EXEC (@sql3)


SELECT 姓名,	语文,	数学,	物理 FROM tbScoreNew
SELECT * FROM (  
	SELECT [姓名],'语文' AS 课程,[语文],[日期] FROM tbScoreNew 
	 UNION ALL
	SELECT [姓名],'数学' AS 课程,[数学],[日期] FROM tbScoreNew 
	 UNION ALL
	SELECT [姓名],'物理' AS 课程,[物理],[日期] FROM tbScoreNew 
	) T ORDER BY [姓名]


/*-----2.2 UNPIVOT 实现列转行----------*/
--(1)静态SQL
SELECT * FROM (
	SELECT [姓名],[日期],[语文],[数学],[物理] FROM dbo.tbScoreNew
) T UNPIVOT ([分数] FOR [课程] IN ([语文],[数学],[物理])) T2
ORDER BY [姓名]


--(2)动态SQL
DECLARE @sql4 VARCHAR(8000)
SELECT @sql4 = ISNULL(@sql4 + ',','') + QUOTENAME(name)
FROM sys.columns 
WHERE object_id = OBJECT_ID('tbScoreNew') AND  name NOT IN ('姓名','日期')
SET @sql4 = 'SELECT * FROM ( SELECT [姓名],[日期],' + @sql4 + ' FROM dbo.tbScoreNew ) T UNPIVOT ([分数] FOR [课程] IN ('+ @sql4 +')) T2 ORDER BY [姓名]'
PRINT @sql4
EXEC (@sql4)





































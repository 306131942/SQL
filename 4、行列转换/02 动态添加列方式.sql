
CREATE TABLE #tmpYear
(
	[YEAR] INT,
	ID INT IDENTITY
)

--�������ս��
CREATE TABLE #tmpResult
(
	ID INT IDENTITY,
	DeptCode VARCHAR(20),--���ű���
	DeptName NVARCHAR(100), --��������
	ProCode VARCHAR(20),--��Ŀ����
	ProName NVARCHAR(100),--��Ŀ����
	KeyCode VARCHAR(50)
)
GO

--1.д���������
INSERT INTO #tmpResult( DeptCode ,DeptName , ProCode ,ProName,KeyCode)
SELECT DeptCode,MAX(DeptName), ProCode,MAX(ProName),DeptCode + '_' + ProCode FROM tbDeptBudget GROUP BY DeptCode,ProCode

--2.����Ԥ��������
--д���������
INSERT INTO #tmpYear SELECT DISTINCT Year FROM dbo.tbDeptBudget

DECLARE @SQL VARCHAR(5000)
DECLARE @ColName1 VARCHAR(50)
DECLARE @ColName2 VARCHAR(50)
DECLARE @ColName3 VARCHAR(50)
DECLARE @Year INT
DECLARE @ID INT
DECLARE @RowNum INT
SET @Year = 0
SET @ID = 1
SET @RowNum = (SELECT COUNT(0) FROM #tmpYear)
WHILE @ID <= @RowNum
BEGIN
	SET @Year = (SELECT [YEAR] FROM #tmpYear WHERE ID = @ID)	
	SET @ColName1 = 'Bduget_' + CAST(@Year AS VARCHAR(10))
	SET @ColName2 = 'Fact_' + CAST(@Year AS VARCHAR(10))
	SET @ColName3 = 'Remain_' + CAST(@Year AS VARCHAR(10))
	
	--���Ӷ�̬��
	SET @SQL = 'ALTER TABLE #tmpResult ADD ' + @ColName1 + ' Decimal(18,2)'
			  + 'ALTER TABLE #tmpResult ADD ' + @ColName2 + ' Decimal(18,2)'
			  + 'ALTER TABLE #tmpResult ADD ' + @ColName3 + ' Decimal(18,2)'
	EXEC(@SQL)
	
	--д�붯̬������
	SET @SQL = 'UPDATE T SET ' + @ColName1 + ' = S.BudgetAmount,' + @ColName2 + ' = S.FactAmount,'+ @ColName3 + ' = S.RemainAmount '
		+ ' FROM #tmpResult T INNER JOIN ( '
		+ ' SELECT (DeptCode + ' + QUOTENAME('_','''') +' + ProCode) AS KeyCode,MAX(BudgetAmount)AS BudgetAmount ,MAX(FactAmount)AS FactAmount,MAX(RemainAmount)AS RemainAmount '
		+ ' FROM dbo.tbDeptBudget WHERE Year= ' + CAST (@Year AS VARCHAR(10))
		+ ' GROUP BY DeptCode,ProCode '
		+ ') S ON T.KeyCode = S.KeyCode '
	
	PRINT @SQL
	EXEC(@SQL)
		
	SET @ID = @ID  + 1
END

--3.���ؽ��
SELECT * FROM #tmpResult

--4.������ʱ��
IF OBJECT_ID('tempdb..#tmpYear') IS NOT NULL
BEGIN
	DROP TABLE #tmpYear
END
IF OBJECT_ID('tempdb..#tmpResult') IS NOT NULL
BEGIN
	DROP TABLE #tmpResult
END









































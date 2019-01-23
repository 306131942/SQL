USE [FIDB]
GO

-- 2.添加新增函数的判断
IF (OBJECT_ID('rf_fi_SplitToTable') IS NULL)
BEGIN
    -- EXEC ('CREATE FUNCTION rf_fi_SplitToTable() RETURNS INT AS BEGIN RETURN 1; END');
    -- 表值函数时
    EXEC ('CREATE FUNCTION rf_fi_SplitToTable() RETURNS @temp_table TABLE( ID int primary key NOT NULL) AS BEGIN RETURN ; END');
END
GO

USE [FIDB]
GO

/****** Object:  UserDefinedFunction [dbo].[rf_fi_SplitToTable]    Script Date: 03/17/2014 15:35:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		罗志胜
-- Create date: 2013-08-15
-- Description:	拆分字符串
-- =============================================
ALTER FUNCTION [dbo].[rf_fi_SplitToTable]
(
	@SplitString VARCHAR(8000),
	@Separator VARCHAR(10) = ','
)
RETURNS @SplitStringsTable TABLE
(
	id INT IDENTITY(1, 1),
	val VARCHAR(MAX)
)
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @CurrentIndex INT
	DECLARE @NextIndex INT
	DECLARE @ReturnText VARCHAR(MAX)
	SET @CurrentIndex = 1
	WHILE (@CurrentIndex <= LEN(@SplitString))
	BEGIN
		SET @NextIndex = CHARINDEX(@Separator, @SplitString, @CurrentIndex)
		IF(@NextIndex = 0 OR @NextIndex IS NULL)
		BEGIN
			SET @NextIndex = LEN(@SplitString) + 1
		END
		SET @ReturnText = SUBSTRING(@SplitString, @CurrentIndex, @NextIndex - @CurrentIndex)
		INSERT INTO @SplitStringsTable(val) VALUES(@ReturnText)
		SET @CurrentIndex = @NextIndex + 1
	END
    RETURN
END


GO



--SELECT * FROM fidb.dbo.rf_fi_SplitToTable('1 1,2,3,4,',',')

--id	val
--1	1 1
--2	2
--3	3
--4	4
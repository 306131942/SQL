USE [FIDB]
GO

IF(OBJECT_ID('rp_fi_ap_region','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_ap_region AS BEGIN SELECT 1; END');
END
GO

USE [FIDB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-06-14
-- Description:	取应付区间
-- EXEC rp_fi_ap_region
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_ap_region]
(
	@i_sf TINYINT = 1	-- 收/付 1付2收
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	/*
	-- 调试数据
	DECLARE @i_sf TINYINT;
	SET @i_sf = 1;
	*/
	
	DECLARE @prdm_id INT;
	DECLARE @prdd_colname VARCHAR(20);
	DECLARE @prdd_unit VARCHAR(20);
	DECLARE @prdd_interval INT;
	DECLARE @prdd_enddays VARCHAR(30);
	DECLARE @rn INT;
	DECLARE @begdate DATETIME;
	DECLARE @enddate DATETIME;
	DECLARE @ubdate DATETIME; -- 单位开始日期
	DECLARE @date DATETIME;
	DECLARE @id INT;
	DECLARE @val INT;

	DECLARE @tb_ret TABLE (colname VARCHAR(20), coltype TINYINT, begdate DATETIME, enddate DATETIME, od TINYINT);
	DECLARE @tmp TABLE (id INT, val VARCHAR(10));

	IF (@i_sf = 1) -- 付款
	BEGIN
		SELECT TOP 1 @prdm_id = prdm_id FROM FIDB.dbo.tfi_period_m WHERE prdm_name = 'AP01' ORDER BY prdm_seq DESC;
	END
	ELSE -- 收款
	BEGIN
		SELECT TOP 1 @prdm_id = prdm_id FROM FIDB.dbo.tfi_period_m WHERE prdm_name = 'AR01' ORDER BY prdm_seq DESC;
	END

	-- 取逾期
	SELECT prdd_colname, prdd_unit, prdd_interval, prdd_enddays
		, rn = ROW_NUMBER() OVER (ORDER BY prdd_colseq, prdd_id)
	INTO #prdd0
	FROM FIDB.dbo.tfi_period_d
	WHERE prdd_prdm_id = @prdm_id AND prdd_type = 0;

	SET @begdate = CONVERT(VARCHAR(10), GETDATE(), 23);
	WHILE (EXISTS (SELECT 1 FROM #prdd0) AND @begdate IS NOT NULL) -- 遍历逾期
	BEGIN
		SET @enddate = DATEADD(DAY, -1, @begdate);
		SELECT TOP 1 @prdd_colname = prdd_colname, @prdd_unit = prdd_unit, @prdd_interval = prdd_interval, @prdd_enddays = prdd_enddays, @rn = rn
		FROM #prdd0 ORDER BY rn DESC;
		
		IF (ISNULL(@prdd_enddays, '') = '') -- 无拆分
		BEGIN
			IF (ISNULL(@prdd_interval, 0) = 0)
			BEGIN
				SET @begdate = NULL;
			END
			ELSE IF (@prdd_unit = '1') -- 天
			BEGIN
				SET @begdate = DATEADD(DAY, @prdd_interval * -1, DATEADD(DAY, 1, @enddate));
			END
			ELSE IF (@prdd_unit = '2') -- 周
			BEGIN
				SET @begdate = DATEADD(WEEK, @prdd_interval * -1, DATEADD(DAY, 1, @enddate));
			END
			ELSE IF (@prdd_unit = '3') -- 旬
			BEGIN
				SET @begdate = DATEADD(DAY, @prdd_interval * -10, DATEADD(DAY, 1, @enddate));
			END
			ELSE IF (@prdd_unit = '4') -- 月
			BEGIN
				SET @begdate = DATEADD(MONTH, @prdd_interval * -1, DATEADD(DAY, 1, @enddate));
			END
			ELSE IF (@prdd_unit = '5') -- 季
			BEGIN
				SET @begdate = DATEADD(QUARTER, @prdd_interval * -1, DATEADD(DAY, 1, @enddate));
			END
			ELSE IF (@prdd_unit = '6') -- 年
			BEGIN
				SET @begdate = DATEADD(YEAR, @prdd_interval * -1, DATEADD(DAY, 1, @enddate));
			END
		
			INSERT INTO @tb_ret VALUES (@prdd_colname, 0, @begdate, @enddate, @rn);
		END
		ELSE
		BEGIN
			IF(ISNULL(@prdd_interval, 0) = 0)
			BEGIN
	    		SET @begdate = NULL;
				INSERT INTO @tb_ret VALUES (@prdd_colname, 1, @begdate, @enddate, @rn);
			END
			ELSE
			BEGIN
				IF (@rn = 1)
				BEGIN
					IF (@prdd_unit = '1') -- 天
					BEGIN
						SET @ubdate = DATEADD(DAY, @prdd_interval * -1, @begdate);
					END
					ELSE IF (@prdd_unit = '2') -- 周
					BEGIN
						SET @ubdate = DATEADD(WEEK, @prdd_interval * -1, DATEADD(DAY, DATEPART(WEEKDAY, @begdate) * -1 + 1, @begdate));
					END
					ELSE IF (@prdd_unit = '3') -- 旬
					BEGIN
						SET @begdate = DATEADD(MONTH, -1, @begdate);
						IF (DATEPART(DAY, @begdate) <= 10)
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 1, @begdate);
						END
						ELSE IF (DATEPART(DAY, @begdate) <= 20)
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 11, @begdate);
						END
						ELSE
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 21, @begdate);
						END
						SET @begdate = CONVERT(VARCHAR(10), GETDATE(), 23);
					END
					ELSE IF (@prdd_unit = '4') -- 月
					BEGIN
						SET @ubdate = DATEADD(MONTH, @prdd_interval * -1, DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 1, @begdate));
					END
					ELSE IF (@prdd_unit = '5') -- 季
					BEGIN
						SET @ubdate = DATEADD(QUARTER, @prdd_interval * -1, DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @begdate), 0));
					END
					ELSE IF (@prdd_unit = '6') -- 年
					BEGIN
						SET @ubdate = DATEADD(YEAR, @prdd_interval * -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, @begdate), 0));
					END
				END
				
				INSERT INTO @tmp SELECT id, val FROM FIDB.dbo.rf_fi_SplitToTable(@prdd_enddays, ',');
				
				WHILE EXISTS (SELECT 1 FROM @tmp)
				BEGIN
					SELECT TOP 1 @id = id, @val = val FROM @tmp ORDER BY id DESC;
					SET @date = DATEADD(DAY, @val - 1, @ubdate);
					IF (@enddate >= @date)
					BEGIN
						SET @begdate = @date;
						INSERT INTO @tb_ret VALUES (@prdd_colname, 1, @begdate, @enddate, @rn + @id);
						SET @enddate = DATEADD(DAY, -1, @begdate);
					END
					
					DELETE FROM @tmp WHERE id = @id;
				END
			
				IF (@prdd_unit = '1') -- 天
				BEGIN
					SET @ubdate = DATEADD(DAY, @prdd_interval * -1, @ubdate);
				END
				ELSE IF (@prdd_unit = '2') -- 周
				BEGIN
					SET @ubdate = DATEADD(WEEK, @prdd_interval * -1, @ubdate);
				END
				ELSE IF (@prdd_unit = '3') -- 旬
				BEGIN
					SET @ubdate = DATEADD(MONTH, @prdd_interval / -3, @ubdate);
					IF (@prdd_interval % 3 > 0)
					BEGIN
						IF (DATEPART(DAY, @ubdate) = 21)
						BEGIN
							SET @ubdate = DATEADD(DAY, (@prdd_interval % 3) * -10, @ubdate);
						END
						ELSE IF (DATEPART(DAY, @ubdate) = 11)
						BEGIN
							IF (@prdd_interval % 3 = 1)
							BEGIN
								SET @ubdate = DATEADD(DAY, -10, @ubdate);
							END
							ELSE
							BEGIN
								SET @ubdate = DATEADD(DAY, 10, DATEADD(MONTH, -1, @ubdate));
							END
						END
						ELSE
						BEGIN
							SET @ubdate = DATEADD(DAY, (3 - (@prdd_interval % 3)) * 10, DATEADD(MONTH, -1, @ubdate));
						END
					END
				END
				ELSE IF (@prdd_unit = '4') -- 月
				BEGIN
					SET @ubdate = DATEADD(MONTH, @prdd_interval * -1, @ubdate);
				END
				ELSE IF (@prdd_unit = '5') -- 季
				BEGIN
					SET @ubdate = DATEADD(QUARTER, @prdd_interval * -1, @ubdate);
				END
				ELSE IF (@prdd_unit = '6') -- 年
				BEGIN
					SET @ubdate = DATEADD(YEAR, @prdd_interval * -1, @ubdate);
				END
			END
		END
		
		DELETE FROM #prdd0 WHERE rn = @rn;
	END
	DROP TABLE #prdd0;

	-- 取未逾期
	SELECT prdd_colname, prdd_unit, prdd_interval, prdd_enddays
		, rn = ROW_NUMBER() OVER (ORDER BY prdd_colseq, prdd_id)
	INTO #prdd1
	FROM FIDB.dbo.tfi_period_d
	WHERE prdd_prdm_id = @prdm_id AND prdd_type = 1;

	SET @enddate = CONVERT(VARCHAR(10), DATEADD(DAY, -1, GETDATE()), 23);
	WHILE (EXISTS (SELECT 1 FROM #prdd1) AND @enddate IS NOT NULL) -- 遍历未逾期
	BEGIN
		SET @begdate = DATEADD(DAY, 1, @enddate);
		SELECT TOP 1 @prdd_colname = prdd_colname, @prdd_unit = prdd_unit, @prdd_interval = prdd_interval, @prdd_enddays = prdd_enddays, @rn = rn
		FROM #prdd1 ORDER BY rn;
		
		--select * from #prdd1;
		IF (ISNULL(@prdd_enddays, '') = '') -- 无拆分
		BEGIN
			IF (ISNULL(@prdd_interval, 0) = 0)
			BEGIN
				SET @enddate = NULL;
			END
			ELSE IF (@prdd_unit = '1') -- 天
			BEGIN
				SET @begdate = DATEADD(DAY, @prdd_interval, DATEADD(DAY, -1, @begdate));
			END
			ELSE IF (@prdd_unit = '2') -- 周
			BEGIN
				SET @begdate = DATEADD(WEEK, @prdd_interval, DATEADD(DAY, -1, @begdate));
			END
			ELSE IF (@prdd_unit = '3') -- 旬
			BEGIN
				SET @begdate = DATEADD(DAY, @prdd_interval * 10, DATEADD(DAY, -1, @begdate));
			END
			ELSE IF (@prdd_unit = '4') -- 月
			BEGIN
				SET @begdate = DATEADD(MONTH, @prdd_interval, DATEADD(DAY, -1, @begdate));
			END
			ELSE IF (@prdd_unit = '5') -- 季
			BEGIN
				SET @begdate = DATEADD(QUARTER, @prdd_interval, DATEADD(DAY, -1, @begdate));
			END
			ELSE IF (@prdd_unit = '6') -- 年
			BEGIN
				SET @begdate = DATEADD(YEAR, @prdd_interval, DATEADD(DAY, -1, @begdate));
			END
			
			INSERT INTO @tb_ret VALUES (@prdd_colname, 1, @begdate, @enddate, @rn + 1);
		END
		ELSE
		BEGIN -- 有拆分
			IF(ISNULL(@prdd_interval, 0) = 0)
			BEGIN
	    		SET @enddate = NULL;
				INSERT INTO @tb_ret VALUES (@prdd_colname, 1, @begdate, @enddate, @rn + 1);
			END
			ELSE
			BEGIN
				IF (@rn = 1)
				BEGIN
					IF (@prdd_unit = '1') -- 天
					BEGIN
						SET @ubdate = @begdate;
					END
					ELSE IF (@prdd_unit = '2') -- 周
					BEGIN
						SET @ubdate = DATEADD(DAY, DATEPART(WEEKDAY, @begdate) * -1 + 1, @begdate);
					END
					ELSE IF (@prdd_unit = '3') -- 旬
					BEGIN
						IF (DATEPART(DAY, @begdate) <= 10)
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 1, @begdate);
						END
						ELSE IF (DATEPART(DAY, @begdate) <= 20)
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 11, @begdate);
						END
						ELSE
						BEGIN
							SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 21, @begdate);
						END
					END
					ELSE IF (@prdd_unit = '4') -- 月
					BEGIN
						SET @ubdate = DATEADD(DAY, DATEPART(DAY, @begdate) * -1 + 1, @begdate);
					END
					ELSE IF (@prdd_unit = '5') -- 季
					BEGIN
						SET @ubdate = DATEADD(QUARTER, DATEDIFF(QUARTER, 0, @begdate), 0);
					END
					ELSE IF (@prdd_unit = '6') -- 年
					BEGIN
						SET @ubdate = DATEADD(YEAR, DATEDIFF(YEAR, 0, @begdate), 0);
					END
				END
				
				INSERT INTO @tmp SELECT id, val FROM FIDB.dbo.rf_fi_SplitToTable(@prdd_enddays, ',');
				
				WHILE EXISTS (SELECT 1 FROM @tmp)
				BEGIN
					SELECT TOP 1 @id = id, @val = val FROM @tmp ORDER BY id;
					SET @date = DATEADD(DAY, @val - 1, @ubdate);
					--SELECT *,@begdate,@date FROM @tmp
					IF (@begdate < @date)
					BEGIN
						SET @enddate = DATEADD(DAY, -1, @date);
						INSERT INTO @tb_ret VALUES (@prdd_colname, 1, @begdate, @enddate, @rn + @id);
						SET @begdate = DATEADD(DAY, 1, @enddate);
					END
					
					DELETE FROM @tmp WHERE id = @id;
				END
			
				IF (@prdd_unit = '1') -- 天
				BEGIN
					SET @ubdate = DATEADD(DAY, @prdd_interval, @ubdate);
				END
				ELSE IF (@prdd_unit = '2') -- 周
				BEGIN
					SET @ubdate = DATEADD(WEEK, @prdd_interval, @ubdate);
				END
				ELSE IF (@prdd_unit = '3') -- 旬
				BEGIN
					SET @ubdate = DATEADD(MONTH, @prdd_interval / 3, @ubdate);
					IF (@prdd_interval % 3 > 0)
					BEGIN
						IF (DATEPART(DAY, @ubdate) = 1)
						BEGIN
							SET @ubdate = DATEADD(DAY, (@prdd_interval % 3) * 10, @ubdate);
						END
						ELSE IF (DATEPART(DAY, @ubdate) = 11)
						BEGIN
							IF (@prdd_interval % 3 = 1)
							BEGIN
								SET @ubdate = DATEADD(DAY, 10, @ubdate);
							END
							ELSE
							BEGIN
								SET @ubdate = DATEADD(DAY, -10, DATEADD(MONTH, 1, @ubdate));
							END
						END
						ELSE
						BEGIN
							SET @ubdate = DATEADD(DAY, (3 - (@prdd_interval % 3)) * -10, DATEADD(MONTH, 1, @ubdate));
						END
					END
				END
				ELSE IF (@prdd_unit = '4') -- 月
				BEGIN
					SET @ubdate = DATEADD(MONTH, @prdd_interval, @ubdate);
				END
				ELSE IF (@prdd_unit = '5') -- 季
				BEGIN
					SET @ubdate = DATEADD(QUARTER, @prdd_interval, @ubdate);
				END
				ELSE IF (@prdd_unit = '6') -- 年
				BEGIN
					SET @ubdate = DATEADD(YEAR, @prdd_interval, @ubdate);
				END
			END
		END
		
		DELETE FROM #prdd1 WHERE rn = @rn;
	END
	DROP TABLE #prdd1;
	
	UPDATE @tb_ret SET colname = REPLACE(REPLACE(colname, '{0}', ISNULL(RIGHT(CONVERT(VARCHAR(8), begdate, 11), 5), '')), '{1}', ISNULL(RIGHT(CONVERT(VARCHAR(8), enddate, 11), 5), ''));
	SELECT colname, coltype, begdate = CONVERT(VARCHAR(10), begdate, 23), enddate = CONVERT(VARCHAR(10), enddate, 23) FROM @tb_ret ORDER BY coltype, od;
	
	IF (@@TRANCOUNT > 0)
	BEGIN
		COMMIT TRAN -- 提交事务
	END
END TRY
BEGIN CATCH
	IF (@@TRANCOUNT > 0)
	BEGIN
		ROLLBACK TRAN  -- 出错，则回滚事务
	END
	
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH


GO



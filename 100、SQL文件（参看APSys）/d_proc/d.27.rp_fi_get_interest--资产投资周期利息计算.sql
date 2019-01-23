													   USE FIDB
GO

--2.添加新增存储过程的判断
IF(OBJECT_ID('rp_fi_get_interest','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_get_interest AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================

-- Description:	每日更新资产投资的利息

-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_get_interest]
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	DECLARE @tcid_id INT;		        
	DECLARE @tcid_tcim_id INT;
	DECLARE @tcid_amt money;
	DECLARE @tcid_rate decimal(19,7);
	DECLARE @tcid_interest_all money;
	DECLARE @tcim_begin_date datetime;
	DECLARE @tcim_end_date DATETIME;
	DECLARE @tcim_curr VARCHAR(4);
	DECLARE @interest_supply money;
	DECLARE @bfm VARCHAR(10);    --投资起始日期所属财月
	DECLARE @efm VARCHAR(10);    --投资结束财月
	DECLARE @fm VARCHAR(10);     --当前日期所属财月
	DECLARE @bfmm VARCHAR(10);    --投资起始日期所月份
	DECLARE @fmm VARCHAR(10);     --当前日期所属月分
	DECLARE @interest_day INT;    --某财月的计息天数
	DECLARE @mot datetime;        --节点月份
	DECLARE @FMOT VARCHAR(20);    --节点财月
	DECLARE @tcid_interest_money money;    --财月周期利息
	
	DECLARE @mdays INT;     --当前财月的天数
	DECLARE @odays INT;     --投资起始财月天数
	DECLARE @mon_num VARCHAR(4);
	DECLARE @month_money VARCHAR(30);
	DECLARE @sql VARCHAR(200);    --插入财月的周期利息的sql
	DECLARE @temp_money money;   
	IF OBJECT_ID('tempdb..#temp_interest_money') IS NOT NULL DROP TABLE #temp_interest_money 
	CREATE TABLE #temp_interest_money(month_money MONEY) 

	SELECT @mdays = 32-DAY(getdate()+32-DAY(getdate()))
	
	
	
    --获取需要补充以前的累计利息的资产投资单	
	CREATE TABLE #tcid_temp(tcid_id INT,tcid_tcim_id INT,tcid_amt money,tcid_rate decimal(19,7),tcid_interest_all money,tcim_begin_date datetime,tcim_end_date datetime,tcim_curr VARCHAR(4))
	INSERT INTO #tcid_temp 
	SELECT tcid_id,tcid_tcim_id,tcid_amt,tcid_rate,tcid_interest_all,tcim_begin_date,tcim_end_date,tcim.tcim_curr 
	FROM FIDB.dbo.tfi_capital_investment_d tcid 
	LEFT JOIN FIDB.dbo.tfi_capital_investment_m tcim ON tcid.tcid_tcim_id = tcim.tcim_id
	WHERE tcim.tcim_status = 5 
	WHILE EXISTS(SELECT 1 FROM #tcid_temp)
	BEGIN 
		SELECT TOP 1 @tcid_id=tcid_id,@tcid_tcim_id=tcid_tcim_id,@tcid_amt=tcid_amt,@tcid_rate=tcid_rate,@tcid_interest_all=tcid_interest_all,@tcim_begin_date=tcim_begin_date,@tcim_end_date=tcim_end_date,@tcim_curr = tcim_curr
		FROM #tcid_temp
		
		SELECT @fm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE GETDATE() BETWEEN mBegdate AND mEndtime		     --当前财月
		SELECT @bfm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @tcim_begin_date BETWEEN mBegdate AND mEndtime   --投资起始财月
		SELECT @efm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @tcim_end_date BETWEEN mBegdate AND mEndtime	 --投资结束财月
		
		--判断是否需要补充历史财月的周期利息
		--确定投资起始财月周期利息存放的字段
		SET @mon_num = RIGHT(@bfm,2) 
		SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
		SET @sql = 'SELECT ' + @month_money +' FROM FIDB.dbo.tfi_capital_investment_d WHERE tcid_id = '+ convert(varchar(20),@tcid_id)
		select @sql
		INSERT INTO #temp_interest_money 
		( 
		 month_money 
		) 
		EXEC (@sql)
		SELECT @temp_money =ISNULL(month_money,0) FROM #temp_interest_money   --投资起始财月周期利息存放的字段的数据
		IF(@temp_money = 0) 
		BEGIN
			IF(@tcim_begin_date < getdate()) --投资起始日期小于当前日期
			BEGIN
				IF(@fm = @bfm)	 --当前日期和投资起始日期属于同一个财月	 
				BEGIN
					SELECT @interest_day = cast((datediff(day,@tcim_begin_date,GETDATE()))as int)	 --间隔天数为投资起始日期到当前日期
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END ) 
					--确定周期利息存放的字段
					SET @mon_num = RIGHT(@bfm,2) 
					SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
					SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
					EXEC (@sql)
					DELETE FROM #tcid_temp WHERE tcid_id = @tcid_id
				END 
				ELSE 
				BEGIN
					SELECT @interest_day = cast((datediff(day,@tcim_begin_date,DATEADD(Day,-1,CONVERT(char(8),DATEADD(Month,1,@tcim_begin_date),120)+'2')))as int)	 --间隔天数为投资起始日期到起始财月月末的天数
					SELECT @odays = 32-DAY(@tcim_begin_date+32-DAY(@tcim_begin_date))             --投资起始财月的天数
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @odays ))   * @interest_day   * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',@tcim_begin_date) END ) 
						--select @tcid_id,@tcid_interest_money,'开始财月',@interest_day
					--确定周期利息存放的字段
					SET @mon_num = RIGHT(@bfm,2) 
					SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
					SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
					EXEC (@sql)
					
					SET @mot = @tcim_begin_date;
					SELECT @mot = dateadd(m,1,@mot)   --取下一个月份
					SELECT @fmot = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @mot BETWEEN mBegdate AND mEndtime	--取下一个财月
					WHILE(@fm <> @fmot and @fmot <> @efm)	 --当节点财月不属于起始财月并且不属于结束财月，当是结束财月时，
					BEGIN
						SELECT @tcid_interest_money = @tcid_amt * (@tcid_rate / 12 /100 ) * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',@mot) END ) 	  --节点财月的累计利息加上投资起始财月的累计利息
							--select @tcid_id,@tcid_interest_money,@mot,@fmot,@fm,@interest_day
						--确定周期利息存放的字段
						SET @mon_num = RIGHT(@fmot,2) 
						SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
						SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
						EXEC (@sql)
						SELECT @mot = dateadd(m,1,@mot)   --循环取下一个月份
						SELECT @fmot = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @mot BETWEEN mBegdate AND mEndtime    --循环取下一个财月
						
					END 
						--select '跳出循环', @tcid_id,@tcid_interest_money,@mot,@fmot,@fm,@interest_day
					--加上当前财月的累计利息,注意结束日期
					SELECT @interest_day = cast((datediff(day,CONVERT(varchar(10),dateadd(d,-day(getdate())+1,GETDATE()) ,120),CASE WHEN @tcim_end_date > GETDATE() THEN GETDATE() ELSE @tcim_end_date END ))as int) + 1
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END )
					   --select @tcid_id,@tcid_interest_money,'当前财月'   ,@interest_day,@mdays,@tcid_amt,@tcid_rate,(@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day
					
					--确定周期利息存放的字段
					SET @mon_num = RIGHT(@fmot,2) 
					SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
					SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
					EXEC (@sql)
				
					DELETE FROM #tcid_temp WHERE tcid_id = @tcid_id
				END
			END		
		END
		ELSE
		BEGIN
			IF(@tcim_end_date < getdate())	   --投资结束日期小于当前日期不用更新财月周期利息
			BEGIN 
				SELECT ''
			END
			ELSE 
			BEGIN
				--判断是否需要计算当前财月周期利息
				--当投资结束日期小于当前日期时,不需要再计算周期利息,否则需要计算周期利息
				--计算周期利息需要确定当前财月的天数,当前财月计息起始日,当前财月计息结束日期
				--当前财月计息起始日期有两种情况1.当前财月为投资起始财月,则计息开始日期为投资起始日期,2当前财月不是投资起始财月,则计息起始日期为当前财月的起始日期.
				--当前财月计息结束日期当前日期,因为有可能是投资结束日期的情况呗上面的计算条件限制,不需要考虑

				--确定当前财月周期利息存放的字段
				SET @mon_num = RIGHT(@fm,2) 
				SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
				--当前财月的天数
				SET @mdays = 32-DAY(getdate()+32-DAY(getdate()))
				--确定当前财月截止当前日期需计息的天数
				SET @interest_day = DATEDIFF(day,(CASE WHEN @fm <> @bfm THEN DATEADD(DAY,-DAY(GETDATE()),GETDATE()) ELSE GETDATE() END ),GETDATE())	--当前财月计息的天数
				--计算当前财月累计周期利息，考虑外币
				SELECT @tcid_interest_money = (@tcid_amt * (@tcid_rate / 100) / 12 / @mdays) * @interest_day * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END ) 
					--select @fm,@tcid_interest_money,@tcid_amt,@tcid_rate,@mdays,@tcid_interest_money,(CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END ) 
				SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
				EXEC (@sql)
			END
			DELETE FROM #tcid_temp WHERE tcid_id = @tcid_id
		END
		UPDATE FIDB.dbo.tfi_capital_investment_d set tcid_interest_all = ( isnull(tcid_interest_money01,0)
		+isnull(tcid_interest_money02,0)
		+isnull(tcid_interest_money03,0)
		+isnull(tcid_interest_money04,0)
		+isnull(tcid_interest_money05,0)
		+isnull(tcid_interest_money06,0)
		+isnull(tcid_interest_money07,0)
		+isnull(tcid_interest_money08,0)
		+isnull(tcid_interest_money09,0)
		+isnull(tcid_interest_money10,0)
		+isnull(tcid_interest_money11,0)
		+isnull(tcid_interest_money12 ,0) ) where tcid_id  = @tcid_id
			
	END 
			    
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH

GO
													   USE FIDB
GO

--2.��������洢���̵��ж�
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

-- Description:	ÿ�ո����ʲ�Ͷ�ʵ���Ϣ

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
	DECLARE @bfm VARCHAR(10);    --Ͷ����ʼ������������
	DECLARE @efm VARCHAR(10);    --Ͷ�ʽ�������
	DECLARE @fm VARCHAR(10);     --��ǰ������������
	DECLARE @bfmm VARCHAR(10);    --Ͷ����ʼ�������·�
	DECLARE @fmm VARCHAR(10);     --��ǰ���������·�
	DECLARE @interest_day INT;    --ĳ���µļ�Ϣ����
	DECLARE @mot datetime;        --�ڵ��·�
	DECLARE @FMOT VARCHAR(20);    --�ڵ����
	DECLARE @tcid_interest_money money;    --����������Ϣ
	
	DECLARE @mdays INT;     --��ǰ���µ�����
	DECLARE @odays INT;     --Ͷ����ʼ��������
	DECLARE @mon_num VARCHAR(4);
	DECLARE @month_money VARCHAR(30);
	DECLARE @sql VARCHAR(200);    --������µ�������Ϣ��sql
	DECLARE @temp_money money;   
	IF OBJECT_ID('tempdb..#temp_interest_money') IS NOT NULL DROP TABLE #temp_interest_money 
	CREATE TABLE #temp_interest_money(month_money MONEY) 

	SELECT @mdays = 32-DAY(getdate()+32-DAY(getdate()))
	
	
	
    --��ȡ��Ҫ������ǰ���ۼ���Ϣ���ʲ�Ͷ�ʵ�	
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
		
		SELECT @fm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE GETDATE() BETWEEN mBegdate AND mEndtime		     --��ǰ����
		SELECT @bfm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @tcim_begin_date BETWEEN mBegdate AND mEndtime   --Ͷ����ʼ����
		SELECT @efm = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @tcim_end_date BETWEEN mBegdate AND mEndtime	 --Ͷ�ʽ�������
		
		--�ж��Ƿ���Ҫ������ʷ���µ�������Ϣ
		--ȷ��Ͷ����ʼ����������Ϣ��ŵ��ֶ�
		SET @mon_num = RIGHT(@bfm,2) 
		SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
		SET @sql = 'SELECT ' + @month_money +' FROM FIDB.dbo.tfi_capital_investment_d WHERE tcid_id = '+ convert(varchar(20),@tcid_id)
		select @sql
		INSERT INTO #temp_interest_money 
		( 
		 month_money 
		) 
		EXEC (@sql)
		SELECT @temp_money =ISNULL(month_money,0) FROM #temp_interest_money   --Ͷ����ʼ����������Ϣ��ŵ��ֶε�����
		IF(@temp_money = 0) 
		BEGIN
			IF(@tcim_begin_date < getdate()) --Ͷ����ʼ����С�ڵ�ǰ����
			BEGIN
				IF(@fm = @bfm)	 --��ǰ���ں�Ͷ����ʼ��������ͬһ������	 
				BEGIN
					SELECT @interest_day = cast((datediff(day,@tcim_begin_date,GETDATE()))as int)	 --�������ΪͶ����ʼ���ڵ���ǰ����
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END ) 
					--ȷ��������Ϣ��ŵ��ֶ�
					SET @mon_num = RIGHT(@bfm,2) 
					SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
					SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
					EXEC (@sql)
					DELETE FROM #tcid_temp WHERE tcid_id = @tcid_id
				END 
				ELSE 
				BEGIN
					SELECT @interest_day = cast((datediff(day,@tcim_begin_date,DATEADD(Day,-1,CONVERT(char(8),DATEADD(Month,1,@tcim_begin_date),120)+'2')))as int)	 --�������ΪͶ����ʼ���ڵ���ʼ������ĩ������
					SELECT @odays = 32-DAY(@tcim_begin_date+32-DAY(@tcim_begin_date))             --Ͷ����ʼ���µ�����
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @odays ))   * @interest_day   * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',@tcim_begin_date) END ) 
						--select @tcid_id,@tcid_interest_money,'��ʼ����',@interest_day
					--ȷ��������Ϣ��ŵ��ֶ�
					SET @mon_num = RIGHT(@bfm,2) 
					SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
					SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
					EXEC (@sql)
					
					SET @mot = @tcim_begin_date;
					SELECT @mot = dateadd(m,1,@mot)   --ȡ��һ���·�
					SELECT @fmot = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @mot BETWEEN mBegdate AND mEndtime	--ȡ��һ������
					WHILE(@fm <> @fmot and @fmot <> @efm)	 --���ڵ���²�������ʼ���²��Ҳ����ڽ������£����ǽ�������ʱ��
					BEGIN
						SELECT @tcid_interest_money = @tcid_amt * (@tcid_rate / 12 /100 ) * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',@mot) END ) 	  --�ڵ���µ��ۼ���Ϣ����Ͷ����ʼ���µ��ۼ���Ϣ
							--select @tcid_id,@tcid_interest_money,@mot,@fmot,@fm,@interest_day
						--ȷ��������Ϣ��ŵ��ֶ�
						SET @mon_num = RIGHT(@fmot,2) 
						SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
						SET @sql = ' UPDATE FIDB.dbo.tfi_capital_investment_d SET modtime = GETDATE(),'+ @month_money + '=' + convert(varchar(20),@tcid_interest_money) + ' WHERE tcid_id = ' + convert(varchar(20),@tcid_id)
						EXEC (@sql)
						SELECT @mot = dateadd(m,1,@mot)   --ѭ��ȡ��һ���·�
						SELECT @fmot = fMonth FROM HPORTAL.dbo.contrast_monthf WHERE @mot BETWEEN mBegdate AND mEndtime    --ѭ��ȡ��һ������
						
					END 
						--select '����ѭ��', @tcid_id,@tcid_interest_money,@mot,@fmot,@fm,@interest_day
					--���ϵ�ǰ���µ��ۼ���Ϣ,ע���������
					SELECT @interest_day = cast((datediff(day,CONVERT(varchar(10),dateadd(d,-day(getdate())+1,GETDATE()) ,120),CASE WHEN @tcim_end_date > GETDATE() THEN GETDATE() ELSE @tcim_end_date END ))as int) + 1
					SELECT @tcid_interest_money = (@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day * (CASE WHEN @tcim_curr = 'RMB' THEN 1.0 ELSE HPORTAL.dbo.rf_ba_getrate(1,@tcim_curr ,'RMB',GETDATE()) END )
					   --select @tcid_id,@tcid_interest_money,'��ǰ����'   ,@interest_day,@mdays,@tcid_amt,@tcid_rate,(@tcid_amt * ((@tcid_rate / 12 /100 ) / @mdays )) * @interest_day
					
					--ȷ��������Ϣ��ŵ��ֶ�
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
			IF(@tcim_end_date < getdate())	   --Ͷ�ʽ�������С�ڵ�ǰ���ڲ��ø��²���������Ϣ
			BEGIN 
				SELECT ''
			END
			ELSE 
			BEGIN
				--�ж��Ƿ���Ҫ���㵱ǰ����������Ϣ
				--��Ͷ�ʽ�������С�ڵ�ǰ����ʱ,����Ҫ�ټ���������Ϣ,������Ҫ����������Ϣ
				--����������Ϣ��Ҫȷ����ǰ���µ�����,��ǰ���¼�Ϣ��ʼ��,��ǰ���¼�Ϣ��������
				--��ǰ���¼�Ϣ��ʼ�������������1.��ǰ����ΪͶ����ʼ����,���Ϣ��ʼ����ΪͶ����ʼ����,2��ǰ���²���Ͷ����ʼ����,���Ϣ��ʼ����Ϊ��ǰ���µ���ʼ����.
				--��ǰ���¼�Ϣ�������ڵ�ǰ����,��Ϊ�п�����Ͷ�ʽ������ڵ����������ļ�����������,����Ҫ����

				--ȷ����ǰ����������Ϣ��ŵ��ֶ�
				SET @mon_num = RIGHT(@fm,2) 
				SET @month_money = 'tcid_interest_money' + CONVERT(VARCHAR(5),@mon_num)
				--��ǰ���µ�����
				SET @mdays = 32-DAY(getdate()+32-DAY(getdate()))
				--ȷ����ǰ���½�ֹ��ǰ�������Ϣ������
				SET @interest_day = DATEDIFF(day,(CASE WHEN @fm <> @bfm THEN DATEADD(DAY,-DAY(GETDATE()),GETDATE()) ELSE GETDATE() END ),GETDATE())	--��ǰ���¼�Ϣ������
				--���㵱ǰ�����ۼ�������Ϣ���������
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
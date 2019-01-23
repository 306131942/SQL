USE FIDB
GO

IF(OBJECT_ID('rp_fi_get_tmpnbr','P') IS NULL)
BEGIN
    EXEC ('CREATE PROCEDURE rp_fi_get_tmpnbr AS BEGIN SELECT 1; END');
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		��־ʤ
-- Create date: 2013-05-02
-- Description:	ȡ��ʱ����(��ʽ�磺'��ʱ-12050001')
-- =========================================================================================
ALTER PROCEDURE [dbo].[rp_fi_get_tmpnbr]
(
	@i_nbrtb VARCHAR(50)		-- ����������
	, @i_nbrfld VARCHAR(50)		-- �����ֶ���
	, @o_nbr VARCHAR(20) OUTPUT	-- ��ʱ����
)
AS
BEGIN TRY
	SET ANSI_WARNINGS OFF;	
	SET NOCOUNT ON;
	
	--DECLARE @i_nbrtb VARCHAR(50) = 'tfi_write_off_m';
	--DECLARE @i_nbrfld VARCHAR(50) = 'wrim_nbr';
	--DECLARE @o_nbr VARCHAR(20);
	
	DECLARE @left VARCHAR(10);			-- '��ʱ-' + ����
	DECLARE @sql NVARCHAR(4000);		-- ȡ�����ˮ�ŵ�SQL
	DECLARE @maxidx TABLE(maxidx INT);	-- �洢��ǰ���������ˮ��
	DECLARE @curidx VARCHAR(4);			-- ���ص���ˮ��
	
	SET @left = '��ʱ-' + CONVERT(VARCHAR(4), GETDATE(), 12); -- ȡ��ǰ����ʱ��ǰ׺
	SET @sql = 'SELECT TOP 1 CAST(RIGHT(' + @i_nbrfld + ', 4) AS INT) FROM ' + @i_nbrtb + ' WHERE ' + @i_nbrfld + ' LIKE ''' + @left + '%'' ORDER BY CAST(RIGHT(' + @i_nbrfld + ', 4) AS INT) DESC';
	
	INSERT INTO @maxidx EXEC(@sql);
	
	SET @curidx = '0001'; -- ��ˮ��Ĭ�ϴ�1��ʼ
	SELECT TOP 1 @curidx = RIGHT('000' + CAST(maxidx + 1 AS VARCHAR(4)), 4) FROM @maxidx;
	SET @o_nbr = @left + @curidx;
END TRY
BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000), @ErrorSeverity INT, @ErrorState INT;
	SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
	RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH
GO


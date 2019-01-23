USE FIDB
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF (OBJECT_ID('VFI_CORPORATION','V') IS NULL)
BEGIN
	EXEC('CREATE VIEW [dbo].[VFI_CORPORATION]
	AS
	SELECT ficn_id='''', code_user1='''', code_name='''',ficn_code='''',
	code_value='''',code_cmmt='''',ficn_name='''',ficn_short_name='''',acctid='''',code_recid='''', 
    code_user2='''',code__qadc01='''',seq='''',ficn_flag='''',ficn_enable='''',ficn_acctid='''',flag=''''	 
	 FROM sysobjects WHERE 1=2')
END	

GO
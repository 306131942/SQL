USE [FIDB]
GO

IF(OBJECT_ID('v_fi_tbacode','V') IS NULL)
BEGIN
    EXEC ('CREATE VIEW v_fi_tbacode AS SELECT id=1;');
END

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =========================================================================================
-- Author:		罗志胜
-- Create date: 2013-05-08
-- Description:	代码表信息视图
-- =========================================================================================
ALTER VIEW [dbo].[v_fi_tbacode]
WITH VIEW_METADATA
AS
	SELECT
		tc.code_type
		, tc.code_module
		, tc.code_code
		, tc.code_name
		, tc.code_desc
		, tc.code_seq
		,tc.code_enable
	FROM HSRP.dbo.tba_code tc
	WHERE tc.code_module IN ('ap', 'fi','gl') AND tc.code_enable = 1

WITH CHECK OPTION;
GO
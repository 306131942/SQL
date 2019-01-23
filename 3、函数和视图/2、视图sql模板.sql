--1.�г�ʹ�ÿ���
USE [����]
GO

--2.��Ӹ�����ͼ���ж�
IF OBJECT_ID('v_xx','V') IS NOT NULL
BEGIN
	DROP VIEW v_xx;
END
GO

--3.���� ANSI_NULLS �� QUOTED_IDENTIFIER
SET ANSI_NULLS ON -- SQL-92 ��׼Ҫ���ڶԿ�ֵ���е��� (=) �򲻵��� (<>) �Ƚ�ʱȡֵΪ FALSE
GO

SET QUOTED_IDENTIFIER ON --��ʶ��������˫���ŷָ�
GO

--4.��д��ͼ�Ļ�����Ϣ
-- =========================================================================================
-- Author:		xx
-- Create date: 2013-02-22
-- Description:	��ͼ��˵�����������磺��ͼ����ģ�棩

-- Modify [1]:  xx, 2013-02-23, ����ͼ����ģ��
-- ע�����ڸ�ʽʹ�� yyyy-MM-dd��Modify [n] n�����޸���ţ���1��ʼ��ÿ���޸ļ�1��
-- =========================================================================================

--5.������ͼʱ����ͼ������淶��v_������ĸ��ģ��Ӣ����д_��ͼ�Ĺ��ܱ�ʶ��
CREATE VIEW v_xx
WITH SCHEMABINDING, --6.��SQL��ѯ��������ж�����ͬһ�����ݿ⣬�������SCHEMABINDING
	 VIEW_METADATA	--7.�����VIEW_METADATA ������ͼԪ������Ϣ
AS
--8.SQL��ѯ����еı���������dbo�ܹ����ƣ���dbo.table1
--9.SQL��ѯ����еı���������ע��˵��
	SELECT	t1.id,
			t1.name,
			t2.name,
			... 
	FROM dbo.table1 t1 --table1˵��
	INNER JOIN dbo.table2 t2 --table2˵��
			   ON t1.id = t2.id
--10.�����CHECK OPTION ��֤			   
WITH CHECK OPTION;
GO

--ע��SQL��ѯ����в��ܰ����������ݣ�
--(1) COMPUTE �� COMPUTE BY �Ӿ䣻
--(2) ORDER BY �Ӿ䣻
--(3) INTO �ؼ��֣�
--(4) OPTION �Ӿ䣻
--(5) ������ʱ���������


--------------------
USE xx
GO
IF(OBJECT_ID('v_xx','V') IS NULL)
BEGIN
	  EXEC ('CREATE VIEW v_xx AS SELECT id=1;');
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================
-- Author:		xx
-- Create date: xx
-- Description:	������Ϣ��ͼ
-- =========================================================================================
ALTER VIEW [dbo].[xx]
WITH VIEW_METADATA
AS
	SELECT
		c1,c2,c3,...
	FROM XXXX.dbo.xxxx

WITH CHECK OPTION;
GO
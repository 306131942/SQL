
--ָ�����ִ�������µ� SQL-92 ��׼��Ϊ��
--������Ϊ ON ʱ������ۺϺ������� SUM��AVG��MAX��MIN��STDEV��STDEVP��VAR��VARP �� COUNT���г��ֿ�ֵ�������ɾ�����Ϣ��������Ϊ OFF ʱ�����������档
--������Ϊ ON ʱ����������������������󽫵��»ع���䲢���ɴ�����Ϣ��������Ϊ OFF ʱ����������������������󽫵��·��ؿ�ֵ��-----��仰����ȷ
--				����� character��Unicode �� binary ���ϳ���ִ�� INSERT �� UPDATE ����������Щ���е���ֵ���ȳ�������д�С����������������������󽫵��·��ؿ�ֵ��
--				��� SET ANSI_WARNINGS Ϊ ON���� SQL-92 ��׼��ָ����ȡ�� INSERT �� UPDATE���������ַ��е�β��ո񣬺��Զ������е�β���㡣
--				������Ϊ OFF ʱ�����ݽ�����Ϊ�еĴ�С���������ִ�гɹ���
--˵��  �� binary �� varbinary ����ת���з����ض�ʱ������ SET ѡ���������ʲô��������������������Ϣ��

USE test_db
GO

CREATE TABLE T11 ( a int, b int NULL, c varchar(20) ) 
GO

SELECT * FROM T11 

SET NOCOUNT ON
GO

INSERT INTO T11 VALUES (1, NULL, '')
INSERT INTO T11 VALUES (1, 0, '')
INSERT INTO T11 VALUES (2, 1, '')
INSERT INTO T11 VALUES (2, 2, '')
GO

------------------------------------��Ϣ������ʾӰ���˶�����
SET NOCOUNT OFF
GO
SELECT * FROM T11 
------------------------------------��Ϣ���治��ʾӰ���˶�����
SET NOCOUNT ON 
GO
SELECT * FROM T11 
------------------------------------��Ϣ������ʾ����
SET ANSI_WARNINGS ON
GO
SELECT *   FROM T11 
------------------------------------��Ϣ���治��ʾ����
SET ANSI_WARNINGS OFF 
GO
SELECT *   FROM T11 


SELECT * FROM test_db.dbo.T11 t

SELECT a, SUM(b) FROM T11 GROUP BY a

INSERT INTO T11 VALUES (3, 3, 'Text string longer than 20 characters')

SELECT a/b FROM T11


SELECT a, SUM(b) FROM T11 GROUP BY a

INSERT INTO T11 VALUES (4, 4, 'Text string longer than 20 characters')

SELECT a/b FROM T11


--DROP TABLE T11
--GO
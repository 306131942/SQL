
https://www.cnblogs.com/johden2/p/5692765.html


/*-----1.��ת�еĲ�������--------------------------*/
IF OBJECT_ID('tbScore') IS NOT NULL 
    DROP TABLE tbScore

GO

CREATE TABLE tbScore
    (
      ���� VARCHAR(10) ,
      �γ� VARCHAR(10) ,
      ���� INT,
      ���� DATETIME
    )
GO

INSERT  INTO tbScore VALUES  ( '����', '����', 74,GETDATE() )
INSERT  INTO tbScore VALUES  ( '����', '����', 84,GETDATE() )
--INSERT  INTO tbScore VALUES  ( '����', '��ѧ', 83 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '����', '����', 93 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '����', '����', 74 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '����', '��ѧ', 84 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '����', '����', 94 ,GETDATE() )
GO

/*-----2.��ת�еĲ�������--------------------------*/
IF OBJECT_ID('tbScoreNew') IS NOT NULL 
    DROP TABLE tbScoreNew

GO

CREATE TABLE tbScoreNew(
      ���� VARCHAR(10) ,
      ���� INT,
      ��ѧ INT,
      ���� INT,
      ���� DATETIME
    )
GO

INSERT  INTO tbScoreNew VALUES  ( '����', 74,84,94,GETDATE() )
INSERT  INTO tbScoreNew VALUES  ( '����', 74,83,93,GETDATE() )
GO


/*-----3.��̬������ʵ����ת��(ģ��������ĿҪ��)--------------------------*/
IF OBJECT_ID('tbDeptBudget') IS NOT NULL 
    DROP TABLE tbDeptBudget

GO
--����Ԥ��
CREATE TABLE tbDeptBudget
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	DeptCode VARCHAR(20),--���ű���
	DeptName NVARCHAR(100), --��������
	ProCode VARCHAR(20),--��Ŀ����
	ProName NVARCHAR(100),--��Ŀ����
	Year INT, --���
	BudgetAmount DECIMAL(18,2), --Ԥ����
	FactAmount DECIMAL(18,2), --ʵ�ʽ��
	RemainAmount DECIMAL(18,2), --ʣ����
	CreateTime DATETIME  --����ʱ��
)
GO

INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('���²�','010000','01','���÷�',2014,100000.00,80000.00,20000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('���²�','010000','01','���÷�',2015,110000.00,90000.00,50000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('���²�','010000','01','���÷�',2016,120000.00,100000.00,80000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('���²�','010000','02','�칫��Ʒ',2015,200000.00,150000.00,10000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('���²�','010000','02','�칫��Ʒ',2016,160000.00,120000.00,80000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('����','020000','02','�칫��Ʒ',2014,50000.00,40000.00,0.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('����','020000','02','�칫��Ʒ',2015,50000.00,50000.00,10000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('����','020000','02','�칫��Ʒ',2016,60000.00,50000.00,40000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('����','020000','03','�ɹ���',2016,100000.00,80000.00,60000.00,GETDATE());











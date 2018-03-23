
https://www.cnblogs.com/johden2/p/5692765.html


/*-----1.行转列的测试数据--------------------------*/
IF OBJECT_ID('tbScore') IS NOT NULL 
    DROP TABLE tbScore

GO

CREATE TABLE tbScore
    (
      姓名 VARCHAR(10) ,
      课程 VARCHAR(10) ,
      分数 INT,
      日期 DATETIME
    )
GO

INSERT  INTO tbScore VALUES  ( '张三', '语文', 74,GETDATE() )
INSERT  INTO tbScore VALUES  ( '张三', '语文', 84,GETDATE() )
--INSERT  INTO tbScore VALUES  ( '张三', '数学', 83 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '张三', '物理', 93 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '李四', '语文', 74 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '李四', '数学', 84 ,GETDATE() )
INSERT  INTO tbScore VALUES  ( '李四', '物理', 94 ,GETDATE() )
GO

/*-----2.列转行的测试数据--------------------------*/
IF OBJECT_ID('tbScoreNew') IS NOT NULL 
    DROP TABLE tbScoreNew

GO

CREATE TABLE tbScoreNew(
      姓名 VARCHAR(10) ,
      语文 INT,
      数学 INT,
      物理 INT,
      日期 DATETIME
    )
GO

INSERT  INTO tbScoreNew VALUES  ( '李四', 74,84,94,GETDATE() )
INSERT  INTO tbScoreNew VALUES  ( '张三', 74,83,93,GETDATE() )
GO


/*-----3.动态增加列实现行转列(模拟组内项目要求)--------------------------*/
IF OBJECT_ID('tbDeptBudget') IS NOT NULL 
    DROP TABLE tbDeptBudget

GO
--部门预算
CREATE TABLE tbDeptBudget
(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	DeptCode VARCHAR(20),--部门编码
	DeptName NVARCHAR(100), --部门名称
	ProCode VARCHAR(20),--项目编码
	ProName NVARCHAR(100),--项目名称
	Year INT, --年度
	BudgetAmount DECIMAL(18,2), --预算金额
	FactAmount DECIMAL(18,2), --实际金额
	RemainAmount DECIMAL(18,2), --剩余金额
	CreateTime DATETIME  --创建时间
)
GO

INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('人事部','010000','01','差旅费',2014,100000.00,80000.00,20000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('人事部','010000','01','差旅费',2015,110000.00,90000.00,50000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('人事部','010000','01','差旅费',2016,120000.00,100000.00,80000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('人事部','010000','02','办公用品',2015,200000.00,150000.00,10000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('人事部','010000','02','办公用品',2016,160000.00,120000.00,80000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('财务部','020000','02','办公用品',2014,50000.00,40000.00,0.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('财务部','020000','02','办公用品',2015,50000.00,50000.00,10000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('财务部','020000','02','办公用品',2016,60000.00,50000.00,40000.00,GETDATE());
INSERT INTO tbDeptBudget(DeptName,DeptCode,ProCode,ProName,YEAR,BudgetAmount,FactAmount,RemainAmount,CreateTime)
VALUES('财务部','020000','03','采购费',2016,100000.00,80000.00,60000.00,GETDATE());
























--两列转两行

create table tb
(

   Subject varchar(10) ,
   Result  int
)

insert into tb( Subject , Result) values( '语文' , 74)
insert into tb( Subject , Result) values( '数学' , 83)
insert into tb( Subject , Result) values( '物理' , 93)
insert into tb( Subject , Result) values( '123' , 93)
go

SELECT * from tb

--动态SQL,指subject不止语文、数学、物理这三门课程。
declare @sql varchar(8000);
declare @sql2 varchar(8000)='';

set @sql = 'select'

select @sql2 = @sql2 + ', max(case Subject when ''' + Subject + ''' then Result else 0 end) [' + Subject + ']'
from (select distinct Subject from tb) as a

SET @sql2 = substring(@sql2, 2, LEN(@sql2))

set @sql = @sql + @sql2 + ' from tb '

--SELECT @sql

exec(@sql) 

--select Name as 姓名 , max(case Subject when '123' then Result else 0 end) [123] 
--, max(case Subject when '数学' then Result else 0 end) [数学] 
--, max(case Subject when '物理' then Result else 0 end) [物理] 
--, max(case Subject when '语文' then Result else 0 end) [语文] 
--from tb group by name

--SELECT  
--  [语文] = MAX(CASE WHEN SUBJECT= '语文' THEN Result ELSE 0 END) 
--, [数学] = MAX(CASE WHEN SUBJECT= '数学' THEN Result ELSE 0 END)
--, [物理] = MAX(CASE WHEN SUBJECT= '物理' THEN Result ELSE 0 END)
--FROM tb



DROP  TABLE tb


--select  substring('123456789', 2, LEN('123456789'))
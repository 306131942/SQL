












--����ת����

create table tb
(

   Subject varchar(10) ,
   Result  int
)

insert into tb( Subject , Result) values( '����' , 74)
insert into tb( Subject , Result) values( '��ѧ' , 83)
insert into tb( Subject , Result) values( '����' , 93)
insert into tb( Subject , Result) values( '123' , 93)
go

SELECT * from tb

--��̬SQL,ָsubject��ֹ���ġ���ѧ�����������ſγ̡�
declare @sql varchar(8000);
declare @sql2 varchar(8000)='';

set @sql = 'select'

select @sql2 = @sql2 + ', max(case Subject when ''' + Subject + ''' then Result else 0 end) [' + Subject + ']'
from (select distinct Subject from tb) as a

SET @sql2 = substring(@sql2, 2, LEN(@sql2))

set @sql = @sql + @sql2 + ' from tb '

--SELECT @sql

exec(@sql) 

--select Name as ���� , max(case Subject when '123' then Result else 0 end) [123] 
--, max(case Subject when '��ѧ' then Result else 0 end) [��ѧ] 
--, max(case Subject when '����' then Result else 0 end) [����] 
--, max(case Subject when '����' then Result else 0 end) [����] 
--from tb group by name

--SELECT  
--  [����] = MAX(CASE WHEN SUBJECT= '����' THEN Result ELSE 0 END) 
--, [��ѧ] = MAX(CASE WHEN SUBJECT= '��ѧ' THEN Result ELSE 0 END)
--, [����] = MAX(CASE WHEN SUBJECT= '����' THEN Result ELSE 0 END)
--FROM tb



DROP  TABLE tb


--select  substring('123456789', 2, LEN('123456789'))
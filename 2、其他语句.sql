
--row_number ��ʹ��
--
--http://www.studyofnet.com/news/180.html(��ʱ�俴��)
--
SELECT TOP 20 rn = row_number() over (partition by wfna_m_id order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a --WHERE a.wfna_emp_id = '00000001' AND a.wfna_state = 0
--ʹ��row_number�����������б��
SELECT TOP 20 rn = row_number() over (order by wfna_id asc), * FROM fidb.dbo.tfi_billhead_a a

SELECT  rn = row_number() over (partition by splr_name_cn order by splr_id asc),splr_code,splr_name_cn, * FROM HSRP.dbo.tfi_suppliers


--with as ��ʹ��

--http://www.cnblogs.com/fightLonely/archive/2011/02/24/1963907.html

1��with as ���壺
	WITH AS���Ҳ�����Ӳ�ѯ���֣�subquery factoring���������������ܶ����飬����һ��SQLƬ�ϣ���SQLƬ�ϻᱻ����SQL������õ����е�ʱ����Ϊ����SQL���Ŀɶ��Ը���Щ��Ҳ�п�������UNION ALL�Ĳ�ͬ���֣���Ϊ�ṩ���ݵĲ��֡� 
�ر����UNION ALL�Ƚ����á���ΪUNION ALL��ÿ�����ֿ�����ͬ���������ÿ�����ֶ�ȥִ��һ��Ļ�����ɱ�̫�ߣ����Կ���ʹ��WITH AS�����ֻҪִ��һ�鼴�ɡ�

2������ǹ��ñ���ʽ��CTE��

3����ʹ��CTEʱӦע�����¼��㣺
	A��CTE�������ֱ�Ӹ�ʹ��CTE��SQL��䣨��select��insert��update�ȣ�������CTE��ʧЧ��
	B��CTE����Ҳ���Ը�������CTE����ֻ��ʹ��һ��with�����CTE�м��ö��ţ�,���ָ���
	C�����CTE�ı��ʽ������ĳ�����ݱ����ͼ������������ڸ�CTE�����SQL���ʹ�õ���Ȼ��CTE����Ȼ�������SQL���ʹ�õľ������ݱ����ͼ��
  table1��һ��ʵ�ʴ��ڵı�

with
table1 as
(
    select * from persons where age < 30
)
select * from table1  --  ʹ������Ϊtable1�Ĺ�������ʽ
select * from table1  --  ʹ������Ϊtable1�����ݱ�
	
	
	
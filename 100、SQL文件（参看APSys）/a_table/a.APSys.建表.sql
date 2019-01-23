USE FIDB
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_refound_a') and type in ('V')) DROP VIEW tfi_refound_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_refound_a') and type in ('U')) create table tfi_refound_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_refound_d') and type in ('V')) DROP VIEW tfi_refound_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_refound_d') and type in ('U')) create table tfi_refound_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_refound_m') and type in ('V')) DROP VIEW tfi_refound_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_refound_m') and type in ('U')) create table tfi_refound_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_inner_account_a') and type in ('V')) DROP VIEW tfi_inner_account_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_inner_account_a') and type in ('U')) create table tfi_inner_account_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_inner_account_d') and type in ('V')) DROP VIEW tfi_inner_account_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_inner_account_d') and type in ('U')) create table tfi_inner_account_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_inner_account_m') and type in ('V')) DROP VIEW tfi_inner_account_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_inner_account_m') and type in ('U')) create table tfi_inner_account_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_ap_log') and type in ('V')) DROP VIEW tfi_ap_log;
if not exists (select * from sys.objects where object_id = object_id('tfi_ap_log') and type in ('U')) create table tfi_ap_log ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_a') and type in ('V')) DROP VIEW tfi_capital_investment_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_a') and type in ('U')) create table tfi_capital_investment_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_d') and type in ('V')) DROP VIEW tfi_capital_investment_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_d') and type in ('U')) create table tfi_capital_investment_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_m') and type in ('V')) DROP VIEW tfi_capital_investment_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_capital_investment_m') and type in ('U')) create table tfi_capital_investment_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_expenses_a') and type in ('V')) DROP VIEW tfi_pay_expenses_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_expenses_a') and type in ('U')) create table tfi_pay_expenses_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_expenses_invoice') and type in ('V')) DROP VIEW tfi_expenses_invoice;
if not exists (select * from sys.objects where object_id = object_id('tfi_expenses_invoice') and type in ('U')) create table tfi_expenses_invoice ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_expenses_m') and type in ('V')) DROP VIEW tfi_pay_expenses_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_expenses_m') and type in ('U')) create table tfi_pay_expenses_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_charge_card') and type in ('V')) DROP VIEW tfi_charge_card;
if not exists (select * from sys.objects where object_id = object_id('tfi_charge_card') and type in ('U')) create table tfi_charge_card ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_attach') and type in ('V')) DROP VIEW tfi_tax_admin_attach;
if not exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_attach') and type in ('U')) create table tfi_tax_admin_attach ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_a') and type in ('V')) DROP VIEW tfi_tax_admin_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_a') and type in ('U')) create table tfi_tax_admin_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_d') and type in ('V')) DROP VIEW tfi_tax_admin_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_d') and type in ('U')) create table tfi_tax_admin_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_m') and type in ('V')) DROP VIEW tfi_tax_admin_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_tax_admin_m') and type in ('U')) create table tfi_tax_admin_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_attach') and type in ('V')) DROP VIEW tfi_accountcussent_attach;
if not exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_attach') and type in ('U')) create table tfi_accountcussent_attach ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_a') and type in ('V')) DROP VIEW tfi_accountcussent_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_a') and type in ('U')) create table tfi_accountcussent_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_d') and type in ('V')) DROP VIEW tfi_accountcussent_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_d') and type in ('U')) create table tfi_accountcussent_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_m') and type in ('V')) DROP VIEW tfi_accountcussent_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_accountcussent_m') and type in ('U')) create table tfi_accountcussent_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_incomebill_a') and type in ('V')) DROP VIEW tfi_incomebill_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_incomebill_a') and type in ('U')) create table tfi_incomebill_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_incomebill_d') and type in ('V')) DROP VIEW tfi_incomebill_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_incomebill_d') and type in ('U')) create table tfi_incomebill_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_incomebill_m') and type in ('V')) DROP VIEW tfi_incomebill_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_incomebill_m') and type in ('U')) create table tfi_incomebill_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_execute_a') and type in ('V')) DROP VIEW tfi_execute_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_execute_a') and type in ('U')) create table tfi_execute_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_execute_m') and type in ('V')) DROP VIEW tfi_execute_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_execute_m') and type in ('U')) create table tfi_execute_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_period_d') and type in ('V')) DROP VIEW tfi_period_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_period_d') and type in ('U')) create table tfi_period_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_period_m') and type in ('V')) DROP VIEW tfi_period_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_period_m') and type in ('U')) create table tfi_period_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_inv_bill_r') and type in ('V')) DROP VIEW tfi_inv_bill_r;
if not exists (select * from sys.objects where object_id = object_id('tfi_inv_bill_r') and type in ('U')) create table tfi_inv_bill_r ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_billhead_a') and type in ('V')) DROP VIEW tfi_billhead_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_billhead_a') and type in ('U')) create table tfi_billhead_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_billhead_d') and type in ('V')) DROP VIEW tfi_billhead_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_billhead_d') and type in ('U')) create table tfi_billhead_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_billhead_collection') and type in ('V')) DROP VIEW tfi_billhead_collection;
if not exists (select * from sys.objects where object_id = object_id('tfi_billhead_collection') and type in ('U')) create table tfi_billhead_collection ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_billhead_m') and type in ('V')) DROP VIEW tfi_billhead_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_billhead_m') and type in ('U')) create table tfi_billhead_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_a') and type in ('V')) DROP VIEW tfi_pay_a;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_a') and type in ('U')) create table tfi_pay_a ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_attch') and type in ('V')) DROP VIEW tfi_pay_attch;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_attch') and type in ('U')) create table tfi_pay_attch ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_other_m') and type in ('V')) DROP VIEW tfi_pay_other_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_other_m') and type in ('U')) create table tfi_pay_other_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_pay_m') and type in ('V')) DROP VIEW tfi_pay_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_pay_m') and type in ('U')) create table tfi_pay_m ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_type_d') and type in ('V')) DROP VIEW tfi_type_d;
if not exists (select * from sys.objects where object_id = object_id('tfi_type_d') and type in ('U')) create table tfi_type_d ( temp_column int );
end try
begin catch
end catch
GO
begin try
if exists (select * from sys.objects where object_id = object_id('tfi_type_m') and type in ('V')) DROP VIEW tfi_type_m;
if not exists (select * from sys.objects where object_id = object_id('tfi_type_m') and type in ('U')) create table tfi_type_m ( temp_column int );
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'typm_id' ) alter table tfi_type_m add typm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'typm_code' ) alter table tfi_type_m add typm_code varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'typm_name' ) alter table tfi_type_m add typm_name varchar(50);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'typm_attribute' ) alter table tfi_type_m add typm_attribute tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'typm_desc' ) alter table tfi_type_m add typm_desc varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'isenable ' ) alter table tfi_type_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'addtime' ) alter table tfi_type_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'adduser' ) alter table tfi_type_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'modtime' ) alter table tfi_type_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'moduser' ) alter table tfi_type_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'acctid' ) alter table tfi_type_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_type_m') and name = 'temp_column' )alter table tfi_type_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_id' ) alter table tfi_type_d add typd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_typm_id' ) alter table tfi_type_d add typd_typm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_wfm_code' ) alter table tfi_type_d add typd_wfm_code varchar(8);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_send_flag' ) alter table tfi_type_d add typd_send_flag tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_source_table' ) alter table tfi_type_d add typd_source_table varchar(50);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_source_term' ) alter table tfi_type_d add typd_source_term varchar(1000);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_next_flag' ) alter table tfi_type_d add typd_next_flag tinyint default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'typd_excu_flag' ) alter table tfi_type_d add typd_excu_flag tinyint default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'isenable ' ) alter table tfi_type_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'addtime' ) alter table tfi_type_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'adduser' ) alter table tfi_type_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'modtime' ) alter table tfi_type_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'moduser' ) alter table tfi_type_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'acctid' ) alter table tfi_type_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_type_d') and name = 'temp_column' )alter table tfi_type_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_id' ) alter table tfi_pay_m add paym_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_nbr' ) alter table tfi_pay_m add paym_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_nbr_flag' ) alter table tfi_pay_m add paym_nbr_flag tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_item' ) alter table tfi_pay_m add paym_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_typm_id' ) alter table tfi_pay_m add paym_typm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_typd_id' ) alter table tfi_pay_m add paym_typd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_flag' ) alter table tfi_pay_m add paym_flag tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_emp' ) alter table tfi_pay_m add paym_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_dept' ) alter table tfi_pay_m add paym_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_duty' ) alter table tfi_pay_m add paym_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_date' ) alter table tfi_pay_m add paym_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_due_date' ) alter table tfi_pay_m add paym_due_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_legal' ) alter table tfi_pay_m add paym_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_currency' ) alter table tfi_pay_m add paym_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_rate' ) alter table tfi_pay_m add paym_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_amt' ) alter table tfi_pay_m add paym_amt money default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_nbr_amt' ) alter table tfi_pay_m add paym_nbr_amt money default 0;alter table tfi_pay_m alter column paym_nbr_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_real_amt' ) alter table tfi_pay_m add paym_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_type' ) alter table tfi_pay_m add paym_pay_type tinyint not null ;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_admin_type' ) alter table tfi_pay_m add paym_admin_type int;alter table tfi_pay_m alter column paym_admin_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_admin_dept' ) alter table tfi_pay_m add paym_admin_dept varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_admin_desc' ) alter table tfi_pay_m add paym_admin_desc varchar(200);alter table tfi_pay_m alter column paym_admin_desc varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_duty_emp' ) alter table tfi_pay_m add paym_duty_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_paycode_type' ) alter table tfi_pay_m add paym_paycode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_code' ) alter table tfi_pay_m add paym_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_spl_name' ) alter table tfi_pay_m add paym_spl_name varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_deptcode' ) alter table tfi_pay_m add paym_pay_deptcode varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_bank' ) alter table tfi_pay_m add paym_pay_bank varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_name' ) alter table tfi_pay_m add paym_pay_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_pay_nbr' ) alter table tfi_pay_m add paym_pay_nbr varchar(50);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_rmks' ) alter table tfi_pay_m add paym_rmks varchar(800);alter table tfi_pay_m alter column paym_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_status' ) alter table tfi_pay_m add paym_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_ref_nbr' ) alter table tfi_pay_m add paym_ref_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_ref_id' ) alter table tfi_pay_m add paym_ref_id int default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_ref_did' ) alter table tfi_pay_m add paym_ref_did int default 0;alter table tfi_pay_m alter column paym_ref_did int;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_parent_id' ) alter table tfi_pay_m add paym_parent_id int default 0;alter table tfi_pay_m alter column paym_parent_id int;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'paym_split_sort' ) alter table tfi_pay_m add paym_split_sort int;alter table tfi_pay_m alter column paym_split_sort int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'isenable ' ) alter table tfi_pay_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'addtime' ) alter table tfi_pay_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'adduser' ) alter table tfi_pay_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'modtime' ) alter table tfi_pay_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'moduser' ) alter table tfi_pay_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'acctid' ) alter table tfi_pay_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_m') and name = 'temp_column' )alter table tfi_pay_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_id' ) alter table tfi_pay_other_m add paym_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_nbr' ) alter table tfi_pay_other_m add paym_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_nbr_flag' ) alter table tfi_pay_other_m add paym_nbr_flag tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_item' ) alter table tfi_pay_other_m add paym_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_typm_id' ) alter table tfi_pay_other_m add paym_typm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_typd_id' ) alter table tfi_pay_other_m add paym_typd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_flag' ) alter table tfi_pay_other_m add paym_flag tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_emp' ) alter table tfi_pay_other_m add paym_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_dept' ) alter table tfi_pay_other_m add paym_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pemr_code' ) alter table tfi_pay_other_m add paym_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_duty' ) alter table tfi_pay_other_m add paym_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_date' ) alter table tfi_pay_other_m add paym_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_due_date' ) alter table tfi_pay_other_m add paym_due_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_paycode_type' ) alter table tfi_pay_other_m add paym_paycode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pay_code' ) alter table tfi_pay_other_m add paym_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_spl_name' ) alter table tfi_pay_other_m add paym_spl_name varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_legal' ) alter table tfi_pay_other_m add paym_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_currency' ) alter table tfi_pay_other_m add paym_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_rate' ) alter table tfi_pay_other_m add paym_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_amt' ) alter table tfi_pay_other_m add paym_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_real_amt' ) alter table tfi_pay_other_m add paym_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pay_type' ) alter table tfi_pay_other_m add paym_pay_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pay_bank' ) alter table tfi_pay_other_m add paym_pay_bank varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pay_name' ) alter table tfi_pay_other_m add paym_pay_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_pay_nbr' ) alter table tfi_pay_other_m add paym_pay_nbr varchar(50);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_admin_type' ) alter table tfi_pay_other_m add paym_admin_type int;alter table tfi_pay_other_m alter column paym_admin_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_admin_dept' ) alter table tfi_pay_other_m add paym_admin_dept varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_admin_desc' ) alter table tfi_pay_other_m add paym_admin_desc varchar(200);alter table tfi_pay_other_m alter column paym_admin_desc varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_duty_emp' ) alter table tfi_pay_other_m add paym_duty_emp varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_rmks' ) alter table tfi_pay_other_m add paym_rmks varchar(800);alter table tfi_pay_other_m alter column paym_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_status' ) alter table tfi_pay_other_m add paym_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'paym_gl_type' ) alter table tfi_pay_other_m add paym_gl_type int not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'isenable ' ) alter table tfi_pay_other_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'addtime' ) alter table tfi_pay_other_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'adduser' ) alter table tfi_pay_other_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'modtime' ) alter table tfi_pay_other_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'moduser' ) alter table tfi_pay_other_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'acctid' ) alter table tfi_pay_other_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_other_m') and name = 'temp_column' )alter table tfi_pay_other_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'payt_id' ) alter table tfi_pay_attch add payt_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'payt_paym_id' ) alter table tfi_pay_attch add payt_paym_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'payt_file_name' ) alter table tfi_pay_attch add payt_file_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'payt_file_path' ) alter table tfi_pay_attch add payt_file_path varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'isenable ' ) alter table tfi_pay_attch add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'addtime' ) alter table tfi_pay_attch add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'adduser' ) alter table tfi_pay_attch add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'modtime' ) alter table tfi_pay_attch add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'moduser' ) alter table tfi_pay_attch add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'acctid' ) alter table tfi_pay_attch add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_attch') and name = 'temp_column' )alter table tfi_pay_attch drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_id' ) alter table tfi_pay_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_wfm_id' ) alter table tfi_pay_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_wfnd_id' ) alter table tfi_pay_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_emp_id' ) alter table tfi_pay_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_m_id' ) alter table tfi_pay_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_m_state' ) alter table tfi_pay_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_m_remark' ) alter table tfi_pay_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_state' ) alter table tfi_pay_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_node_state' ) alter table tfi_pay_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_wf_route' ) alter table tfi_pay_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_nbr' ) alter table tfi_pay_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_summary' ) alter table tfi_pay_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_addtime' ) alter table tfi_pay_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_adduser' ) alter table tfi_pay_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_modtime' ) alter table tfi_pay_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_moduser' ) alter table tfi_pay_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_para1' ) alter table tfi_pay_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_para2' ) alter table tfi_pay_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_para3' ) alter table tfi_pay_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_cc_code' ) alter table tfi_pay_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_audit_type' ) alter table tfi_pay_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'wfna_audit_seq' ) alter table tfi_pay_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'acctid' ) alter table tfi_pay_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_a') and name = 'temp_column' )alter table tfi_pay_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_id' ) alter table tfi_billhead_m add abhm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_type' ) alter table tfi_billhead_m add abhm_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_nbr' ) alter table tfi_billhead_m add abhm_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_item' ) alter table tfi_billhead_m add abhm_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_emp' ) alter table tfi_billhead_m add abhm_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_dept' ) alter table tfi_billhead_m add abhm_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_duty' ) alter table tfi_billhead_m add abhm_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pemr_code' ) alter table tfi_billhead_m add abhm_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_date' ) alter table tfi_billhead_m add abhm_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_legal' ) alter table tfi_billhead_m add abhm_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_paycode_type' ) alter table tfi_billhead_m add abhm_paycode_type tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_code' ) alter table tfi_billhead_m add abhm_pay_code varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_type' ) alter table tfi_billhead_m add abhm_pay_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_othercode_type' ) alter table tfi_billhead_m add abhm_othercode_type tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_other_code' ) alter table tfi_billhead_m add abhm_other_code varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_name' ) alter table tfi_billhead_m add abhm_pay_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_bank' ) alter table tfi_billhead_m add abhm_pay_bank varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_nbr' ) alter table tfi_billhead_m add abhm_pay_nbr varchar(50);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_tel' ) alter table tfi_billhead_m add abhm_pay_tel varchar(30);alter table tfi_billhead_m alter column abhm_pay_tel varchar(30);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_license' ) alter table tfi_billhead_m add abhm_pay_license varchar(30);alter table tfi_billhead_m alter column abhm_pay_license varchar(30);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_currency' ) alter table tfi_billhead_m add abhm_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_rate' ) alter table tfi_billhead_m add abhm_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_amt' ) alter table tfi_billhead_m add abhm_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_rec_amt' ) alter table tfi_billhead_m add abhm_rec_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_amt' ) alter table tfi_billhead_m add abhm_pay_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_real_amt' ) alter table tfi_billhead_m add abhm_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_prtn_amt' ) alter table tfi_billhead_m add abhm_prtn_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_ivim_type' ) alter table tfi_billhead_m add abhm_ivim_type tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_inv_amt' ) alter table tfi_billhead_m add abhm_inv_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_other_amt' ) alter table tfi_billhead_m add abhm_other_amt money not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_date' ) alter table tfi_billhead_m add abhm_pay_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_rmks' ) alter table tfi_billhead_m add abhm_rmks varchar(800);alter table tfi_billhead_m alter column abhm_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_status' ) alter table tfi_billhead_m add abhm_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_ref_type' ) alter table tfi_billhead_m add abhm_ref_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_ref_id' ) alter table tfi_billhead_m add abhm_ref_id int;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_rec_date' ) alter table tfi_billhead_m add abhm_rec_date datetime;alter table tfi_billhead_m alter column abhm_rec_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_audit_rmks' ) alter table tfi_billhead_m add abhm_audit_rmks varchar(800);alter table tfi_billhead_m alter column abhm_audit_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'abhm_pay_dept' ) alter table tfi_billhead_m add abhm_pay_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'isenable ' ) alter table tfi_billhead_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'addtime' ) alter table tfi_billhead_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'adduser' ) alter table tfi_billhead_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'modtime' ) alter table tfi_billhead_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'modtime2' ) alter table tfi_billhead_m add modtime2 datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'moduser' ) alter table tfi_billhead_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'acctid' ) alter table tfi_billhead_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_billhead_m') and name = 'temp_column' )alter table tfi_billhead_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_id' ) alter table tfi_billhead_collection add abhc_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_abhm_id' ) alter table tfi_billhead_collection add abhc_abhm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_paycode_type' ) alter table tfi_billhead_collection add abhc_paycode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_code' ) alter table tfi_billhead_collection add abhc_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_type' ) alter table tfi_billhead_collection add abhc_pay_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_name' ) alter table tfi_billhead_collection add abhc_pay_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_bank' ) alter table tfi_billhead_collection add abhc_pay_bank varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_nbr' ) alter table tfi_billhead_collection add abhc_pay_nbr varchar(50);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_payb_amt' ) alter table tfi_billhead_collection add abhc_payb_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_deduc_amt' ) alter table tfi_billhead_collection add abhc_deduc_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_amt' ) alter table tfi_billhead_collection add abhc_pay_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'abhc_real_amt' ) alter table tfi_billhead_collection add abhc_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'isenable ' ) alter table tfi_billhead_collection add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'addtime' ) alter table tfi_billhead_collection add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'adduser' ) alter table tfi_billhead_collection add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'modtime' ) alter table tfi_billhead_collection add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'moduser' ) alter table tfi_billhead_collection add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'acctid' ) alter table tfi_billhead_collection add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_billhead_collection') and name = 'temp_column' )alter table tfi_billhead_collection drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_id' ) alter table tfi_billhead_d add abhd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_abhm_id' ) alter table tfi_billhead_d add abhd_abhm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_type' ) alter table tfi_billhead_d add abhd_type int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_abhc_id' ) alter table tfi_billhead_d add abhd_abhc_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_bill_type' ) alter table tfi_billhead_d add abhd_bill_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_m_id' ) alter table tfi_billhead_d add abhd_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_d_id' ) alter table tfi_billhead_d add abhd_d_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_currency' ) alter table tfi_billhead_d add abhd_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_rate' ) alter table tfi_billhead_d add abhd_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_pay_amt' ) alter table tfi_billhead_d add abhd_pay_amt money default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_rmks' ) alter table tfi_billhead_d add abhd_rmks varchar(800);alter table tfi_billhead_d alter column abhd_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_payb_amt' ) alter table tfi_billhead_d add abhd_payb_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_recb_amt' ) alter table tfi_billhead_d add abhd_recb_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_real_amt' ) alter table tfi_billhead_d add abhd_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_cntd_id' ) alter table tfi_billhead_d add abhd_cntd_id int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_source_id' ) alter table tfi_billhead_d add abhd_source_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'abhd_source_nbr' ) alter table tfi_billhead_d add abhd_source_nbr varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'isenable2' ) alter table tfi_billhead_d add isenable2 tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'isenable ' ) alter table tfi_billhead_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'addtime' ) alter table tfi_billhead_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'adduser' ) alter table tfi_billhead_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'modtime' ) alter table tfi_billhead_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'moduser' ) alter table tfi_billhead_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'acctid' ) alter table tfi_billhead_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_billhead_d') and name = 'temp_column' )alter table tfi_billhead_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_id' ) alter table tfi_billhead_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_wfm_id' ) alter table tfi_billhead_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_wfnd_id' ) alter table tfi_billhead_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_emp_id' ) alter table tfi_billhead_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_m_id' ) alter table tfi_billhead_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_m_state' ) alter table tfi_billhead_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_m_remark' ) alter table tfi_billhead_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_state' ) alter table tfi_billhead_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_node_state' ) alter table tfi_billhead_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_wf_route' ) alter table tfi_billhead_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_nbr' ) alter table tfi_billhead_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_summary' ) alter table tfi_billhead_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_addtime' ) alter table tfi_billhead_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_adduser' ) alter table tfi_billhead_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_modtime' ) alter table tfi_billhead_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_moduser' ) alter table tfi_billhead_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_para1' ) alter table tfi_billhead_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_para2' ) alter table tfi_billhead_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_para3' ) alter table tfi_billhead_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_cc_code' ) alter table tfi_billhead_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_audit_type' ) alter table tfi_billhead_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'wfna_audit_seq' ) alter table tfi_billhead_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'acctid' ) alter table tfi_billhead_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_billhead_a') and name = 'temp_column' )alter table tfi_billhead_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'inbr_id' ) alter table tfi_inv_bill_r add inbr_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'inbr_abhm_id' ) alter table tfi_inv_bill_r add inbr_abhm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'inbr_ivid_id' ) alter table tfi_inv_bill_r add inbr_ivid_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'inbr_offset_amt' ) alter table tfi_inv_bill_r add inbr_offset_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'inbr_rmks' ) alter table tfi_inv_bill_r add inbr_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'isenable ' ) alter table tfi_inv_bill_r add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'addtime' ) alter table tfi_inv_bill_r add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'adduser' ) alter table tfi_inv_bill_r add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'modtime' ) alter table tfi_inv_bill_r add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'moduser' ) alter table tfi_inv_bill_r add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'acctid' ) alter table tfi_inv_bill_r add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_inv_bill_r') and name = 'temp_column' )alter table tfi_inv_bill_r drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_id' ) alter table tfi_period_m add prdm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_name' ) alter table tfi_period_m add prdm_name varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_desc' ) alter table tfi_period_m add prdm_desc varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_module' ) alter table tfi_period_m add prdm_module varchar(4) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_code' ) alter table tfi_period_m add prdm_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'prdm_seq' ) alter table tfi_period_m add prdm_seq int default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'isenable ' ) alter table tfi_period_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'addtime' ) alter table tfi_period_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'adduser' ) alter table tfi_period_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'modtime' ) alter table tfi_period_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'moduser' ) alter table tfi_period_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'acctid' ) alter table tfi_period_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_period_m') and name = 'temp_column' )alter table tfi_period_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_id' ) alter table tfi_period_d add prdd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_prdm_id' ) alter table tfi_period_d add prdd_prdm_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_colseq' ) alter table tfi_period_d add prdd_colseq int not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_colname' ) alter table tfi_period_d add prdd_colname varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_type' ) alter table tfi_period_d add prdd_type varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_unit' ) alter table tfi_period_d add prdd_unit varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_interval' ) alter table tfi_period_d add prdd_interval int not null  default 1;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'prdd_enddays' ) alter table tfi_period_d add prdd_enddays varchar(30);alter table tfi_period_d alter column prdd_enddays varchar(30);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'isenable ' ) alter table tfi_period_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'addtime' ) alter table tfi_period_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'adduser' ) alter table tfi_period_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'modtime' ) alter table tfi_period_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'moduser' ) alter table tfi_period_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'acctid' ) alter table tfi_period_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_period_d') and name = 'temp_column' )alter table tfi_period_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_id' ) alter table tfi_execute_m add exem_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_nbr' ) alter table tfi_execute_m add exem_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_emp' ) alter table tfi_execute_m add exem_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_dept' ) alter table tfi_execute_m add exem_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_duty' ) alter table tfi_execute_m add exem_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_pemr_code' ) alter table tfi_execute_m add exem_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_date' ) alter table tfi_execute_m add exem_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_legal' ) alter table tfi_execute_m add exem_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_pay_type' ) alter table tfi_execute_m add exem_pay_type tinyint not null  default 2;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_acct_id' ) alter table tfi_execute_m add exem_acct_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_pay_amt' ) alter table tfi_execute_m add exem_pay_amt money default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_curr' ) alter table tfi_execute_m add exem_curr varchar(3);alter table tfi_execute_m alter column exem_curr varchar(3);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_rate' ) alter table tfi_execute_m add exem_rate decimal(19,7);alter table tfi_execute_m alter column exem_rate decimal(19,7);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_amt' ) alter table tfi_execute_m add exem_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_real_amt' ) alter table tfi_execute_m add exem_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_pay_date' ) alter table tfi_execute_m add exem_pay_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_rmks' ) alter table tfi_execute_m add exem_rmks varchar(800);alter table tfi_execute_m alter column exem_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_status' ) alter table tfi_execute_m add exem_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_ref_mid' ) alter table tfi_execute_m add exem_ref_mid int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_ref_nbr' ) alter table tfi_execute_m add exem_ref_nbr varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_balance_dept' ) alter table tfi_execute_m add exem_balance_dept varchar(20);alter table tfi_execute_m alter column exem_balance_dept varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_balance_deptname' ) alter table tfi_execute_m add exem_balance_deptname varchar(50);alter table tfi_execute_m alter column exem_balance_deptname varchar(50);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_paycode_dept' ) alter table tfi_execute_m add exem_paycode_dept varchar(20);alter table tfi_execute_m alter column exem_paycode_dept varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_paycode_deptname' ) alter table tfi_execute_m add exem_paycode_deptname varchar(50);alter table tfi_execute_m alter column exem_paycode_deptname varchar(50);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_approve_date' ) alter table tfi_execute_m add exem_approve_date datetime default getdate();alter table tfi_execute_m alter column exem_approve_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_ispaid' ) alter table tfi_execute_m add exem_ispaid int not null  default 0;alter table tfi_execute_m alter column exem_ispaid int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'exem_pay_dept' ) alter table tfi_execute_m add exem_pay_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'isenable ' ) alter table tfi_execute_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'addtime' ) alter table tfi_execute_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'adduser' ) alter table tfi_execute_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'modtime' ) alter table tfi_execute_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'modtime2' ) alter table tfi_execute_m add modtime2 datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'moduser' ) alter table tfi_execute_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'acctid' ) alter table tfi_execute_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_execute_m') and name = 'temp_column' )alter table tfi_execute_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_id' ) alter table tfi_execute_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_wfm_id' ) alter table tfi_execute_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_wfnd_id' ) alter table tfi_execute_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_emp_id' ) alter table tfi_execute_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_m_id' ) alter table tfi_execute_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_m_state' ) alter table tfi_execute_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_m_remark' ) alter table tfi_execute_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_state' ) alter table tfi_execute_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_node_state' ) alter table tfi_execute_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_wf_route' ) alter table tfi_execute_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_nbr' ) alter table tfi_execute_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_summary' ) alter table tfi_execute_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_addtime' ) alter table tfi_execute_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_adduser' ) alter table tfi_execute_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_modtime' ) alter table tfi_execute_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_moduser' ) alter table tfi_execute_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_para1' ) alter table tfi_execute_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_para2' ) alter table tfi_execute_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_para3' ) alter table tfi_execute_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_cc_code' ) alter table tfi_execute_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_audit_type' ) alter table tfi_execute_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'wfna_audit_seq' ) alter table tfi_execute_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'acctid' ) alter table tfi_execute_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_execute_a') and name = 'temp_column' )alter table tfi_execute_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_id' ) alter table tfi_incomebill_m add icbm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_type' ) alter table tfi_incomebill_m add icbm_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_nbr' ) alter table tfi_incomebill_m add icbm_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_item' ) alter table tfi_incomebill_m add icbm_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_emp' ) alter table tfi_incomebill_m add icbm_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_dept' ) alter table tfi_incomebill_m add icbm_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_duty' ) alter table tfi_incomebill_m add icbm_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_pemr_code' ) alter table tfi_incomebill_m add icbm_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_date' ) alter table tfi_incomebill_m add icbm_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_legal' ) alter table tfi_incomebill_m add icbm_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_reccode_type' ) alter table tfi_incomebill_m add icbm_reccode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_code' ) alter table tfi_incomebill_m add icbm_rec_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_type' ) alter table tfi_incomebill_m add icbm_rec_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_currency' ) alter table tfi_incomebill_m add icbm_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rate' ) alter table tfi_incomebill_m add icbm_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_amt' ) alter table tfi_incomebill_m add icbm_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_pay_amt' ) alter table tfi_incomebill_m add icbm_pay_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_inc_amt' ) alter table tfi_incomebill_m add icbm_inc_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_real_amt' ) alter table tfi_incomebill_m add icbm_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_prtn_amt' ) alter table tfi_incomebill_m add icbm_prtn_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_inv_amt' ) alter table tfi_incomebill_m add icbm_inv_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_date' ) alter table tfi_incomebill_m add icbm_rec_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rmks' ) alter table tfi_incomebill_m add icbm_rmks varchar(800);alter table tfi_incomebill_m alter column icbm_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_status' ) alter table tfi_incomebill_m add icbm_status tinyint default 1;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_pay_date' ) alter table tfi_incomebill_m add icbm_pay_date datetime;alter table tfi_incomebill_m alter column icbm_pay_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_glrec_type' ) alter table tfi_incomebill_m add icbm_glrec_type int not null  default 2;alter table tfi_incomebill_m alter column icbm_glrec_type int not null ;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_glrec_code' ) alter table tfi_incomebill_m add icbm_glrec_code varchar(20);alter table tfi_incomebill_m alter column icbm_glrec_code varchar(20);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_company' ) alter table tfi_incomebill_m add icbm_rec_company varchar(100);alter table tfi_incomebill_m alter column icbm_rec_company varchar(100);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_bank' ) alter table tfi_incomebill_m add icbm_rec_bank varchar(100);alter table tfi_incomebill_m alter column icbm_rec_bank varchar(100);
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_acct' ) alter table tfi_incomebill_m add icbm_rec_acct varchar(50);alter table tfi_incomebill_m alter column icbm_rec_acct varchar(50);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_isreceived ' ) alter table tfi_incomebill_m add icbm_isreceived  int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_acct_id' ) alter table tfi_incomebill_m add icbm_acct_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_dept' ) alter table tfi_incomebill_m add icbm_rec_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'isenable ' ) alter table tfi_incomebill_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'addtime' ) alter table tfi_incomebill_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'adduser' ) alter table tfi_incomebill_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'modtime' ) alter table tfi_incomebill_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'modtime2' ) alter table tfi_incomebill_m add modtime2 datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'moduser' ) alter table tfi_incomebill_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'acctid' ) alter table tfi_incomebill_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_incomebill_m') and name = 'temp_column' )alter table tfi_incomebill_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_id' ) alter table tfi_incomebill_d add icbd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_icbm_id' ) alter table tfi_incomebill_d add icbd_icbm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_bill_type' ) alter table tfi_incomebill_d add icbd_bill_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_m_id' ) alter table tfi_incomebill_d add icbd_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_d_id' ) alter table tfi_incomebill_d add icbd_d_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_currency' ) alter table tfi_incomebill_d add icbd_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_rate' ) alter table tfi_incomebill_d add icbd_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_rec_amt' ) alter table tfi_incomebill_d add icbd_rec_amt money default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_rmks' ) alter table tfi_incomebill_d add icbd_rmks varchar(800);alter table tfi_incomebill_d alter column icbd_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_payb_amt' ) alter table tfi_incomebill_d add icbd_payb_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_recb_amt' ) alter table tfi_incomebill_d add icbd_recb_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'icbd_real_amt' ) alter table tfi_incomebill_d add icbd_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'isenable ' ) alter table tfi_incomebill_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'addtime' ) alter table tfi_incomebill_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'adduser' ) alter table tfi_incomebill_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'modtime' ) alter table tfi_incomebill_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'moduser' ) alter table tfi_incomebill_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'acctid' ) alter table tfi_incomebill_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_incomebill_d') and name = 'temp_column' )alter table tfi_incomebill_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_id' ) alter table tfi_incomebill_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_wfm_id' ) alter table tfi_incomebill_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_wfnd_id' ) alter table tfi_incomebill_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_emp_id' ) alter table tfi_incomebill_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_m_id' ) alter table tfi_incomebill_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_m_state' ) alter table tfi_incomebill_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_m_remark' ) alter table tfi_incomebill_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_state' ) alter table tfi_incomebill_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_node_state' ) alter table tfi_incomebill_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_wf_route' ) alter table tfi_incomebill_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_nbr' ) alter table tfi_incomebill_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_summary' ) alter table tfi_incomebill_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_addtime' ) alter table tfi_incomebill_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_adduser' ) alter table tfi_incomebill_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_modtime' ) alter table tfi_incomebill_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_moduser' ) alter table tfi_incomebill_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_para1' ) alter table tfi_incomebill_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_para2' ) alter table tfi_incomebill_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_para3' ) alter table tfi_incomebill_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_cc_code' ) alter table tfi_incomebill_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_audit_type' ) alter table tfi_incomebill_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'wfna_audit_seq' ) alter table tfi_incomebill_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'acctid' ) alter table tfi_incomebill_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_incomebill_a') and name = 'temp_column' )alter table tfi_incomebill_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_id' ) alter table tfi_accountcussent_m add accm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_nbr' ) alter table tfi_accountcussent_m add accm_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_item' ) alter table tfi_accountcussent_m add accm_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_emp' ) alter table tfi_accountcussent_m add accm_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_dept' ) alter table tfi_accountcussent_m add accm_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_duty' ) alter table tfi_accountcussent_m add accm_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_pemr_code' ) alter table tfi_accountcussent_m add accm_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_date' ) alter table tfi_accountcussent_m add accm_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_legal' ) alter table tfi_accountcussent_m add accm_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_paycode_type' ) alter table tfi_accountcussent_m add accm_paycode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_pay_code' ) alter table tfi_accountcussent_m add accm_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_currency' ) alter table tfi_accountcussent_m add accm_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_rate' ) alter table tfi_accountcussent_m add accm_rate decimal(19,7) not null ;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_flag' ) alter table tfi_accountcussent_m add accm_flag tinyint;alter table tfi_accountcussent_m alter column accm_flag tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_bill_amt' ) alter table tfi_accountcussent_m add accm_bill_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_approved_amt' ) alter table tfi_accountcussent_m add accm_approved_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_difference_amt' ) alter table tfi_accountcussent_m add accm_difference_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_pay_date' ) alter table tfi_accountcussent_m add accm_pay_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_type' ) alter table tfi_accountcussent_m add accm_type tinyint not null  default 2;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_date_end' ) alter table tfi_accountcussent_m add accm_date_end datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_admin_dept' ) alter table tfi_accountcussent_m add accm_admin_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_rmks' ) alter table tfi_accountcussent_m add accm_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'accm_status' ) alter table tfi_accountcussent_m add accm_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'isenable ' ) alter table tfi_accountcussent_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'addtime' ) alter table tfi_accountcussent_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'adduser' ) alter table tfi_accountcussent_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'modtime' ) alter table tfi_accountcussent_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'moduser' ) alter table tfi_accountcussent_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'acctid' ) alter table tfi_accountcussent_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_m') and name = 'temp_column' )alter table tfi_accountcussent_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_id' ) alter table tfi_accountcussent_d add accd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_accm_id' ) alter table tfi_accountcussent_d add accd_accm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_bill_type' ) alter table tfi_accountcussent_d add accd_bill_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_m_id' ) alter table tfi_accountcussent_d add accd_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_d_id' ) alter table tfi_accountcussent_d add accd_d_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_currency' ) alter table tfi_accountcussent_d add accd_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_rate' ) alter table tfi_accountcussent_d add accd_rate decimal(19,7) not null ;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_flag' ) alter table tfi_accountcussent_d add accd_flag tinyint;alter table tfi_accountcussent_d alter column accd_flag tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_bill_amt' ) alter table tfi_accountcussent_d add accd_bill_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_approved_amt' ) alter table tfi_accountcussent_d add accd_approved_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_difference_amt' ) alter table tfi_accountcussent_d add accd_difference_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'accd_rmks' ) alter table tfi_accountcussent_d add accd_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'isenable ' ) alter table tfi_accountcussent_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'addtime' ) alter table tfi_accountcussent_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'adduser' ) alter table tfi_accountcussent_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'modtime' ) alter table tfi_accountcussent_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'moduser' ) alter table tfi_accountcussent_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'acctid' ) alter table tfi_accountcussent_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_d') and name = 'temp_column' )alter table tfi_accountcussent_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_id' ) alter table tfi_accountcussent_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_wfm_id' ) alter table tfi_accountcussent_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_wfnd_id' ) alter table tfi_accountcussent_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_emp_id' ) alter table tfi_accountcussent_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_id' ) alter table tfi_accountcussent_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_state' ) alter table tfi_accountcussent_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_remark' ) alter table tfi_accountcussent_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_state' ) alter table tfi_accountcussent_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_node_state' ) alter table tfi_accountcussent_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_wf_route' ) alter table tfi_accountcussent_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_nbr' ) alter table tfi_accountcussent_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_summary' ) alter table tfi_accountcussent_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_addtime' ) alter table tfi_accountcussent_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_adduser' ) alter table tfi_accountcussent_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_modtime' ) alter table tfi_accountcussent_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_moduser' ) alter table tfi_accountcussent_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_para1' ) alter table tfi_accountcussent_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_para2' ) alter table tfi_accountcussent_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_para3' ) alter table tfi_accountcussent_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_cc_code' ) alter table tfi_accountcussent_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_audit_type' ) alter table tfi_accountcussent_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'wfna_audit_seq' ) alter table tfi_accountcussent_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'acctid' ) alter table tfi_accountcussent_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_a') and name = 'temp_column' )alter table tfi_accountcussent_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'tact_id' ) alter table tfi_accountcussent_attach add tact_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'tact_accm_id' ) alter table tfi_accountcussent_attach add tact_accm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'tact_file_path' ) alter table tfi_accountcussent_attach add tact_file_path varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'tact_file_name' ) alter table tfi_accountcussent_attach add tact_file_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'isenable' ) alter table tfi_accountcussent_attach add isenable int not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'addtime' ) alter table tfi_accountcussent_attach add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'adduser' ) alter table tfi_accountcussent_attach add adduser varchar(20) not null  default ('0');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'modtime' ) alter table tfi_accountcussent_attach add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'moduser' ) alter table tfi_accountcussent_attach add moduser varchar(20) not null  default ('0');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'acctid' ) alter table tfi_accountcussent_attach add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_accountcussent_attach') and name = 'temp_column' )alter table tfi_accountcussent_attach drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_id' ) alter table tfi_tax_admin_m add ttam_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_type' ) alter table tfi_tax_admin_m add ttam_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_nbr' ) alter table tfi_tax_admin_m add ttam_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_emp' ) alter table tfi_tax_admin_m add ttam_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_dept' ) alter table tfi_tax_admin_m add ttam_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_duty' ) alter table tfi_tax_admin_m add ttam_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_pemr_code' ) alter table tfi_tax_admin_m add ttam_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_date' ) alter table tfi_tax_admin_m add ttam_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_legal' ) alter table tfi_tax_admin_m add ttam_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_bank' ) alter table tfi_tax_admin_m add ttam_pay_bank int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_acct_id' ) alter table tfi_tax_admin_m add ttam_acct_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_date' ) alter table tfi_tax_admin_m add ttam_pay_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_code' ) alter table tfi_tax_admin_m add ttam_pay_code tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_currency' ) alter table tfi_tax_admin_m add ttam_currency varchar(10) not null  default 'rmb';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_rate' ) alter table tfi_tax_admin_m add ttam_rate decimal(19,4) not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_tax_amt' ) alter table tfi_tax_admin_m add ttam_tax_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_late_fee' ) alter table tfi_tax_admin_m add ttam_late_fee money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_penalty' ) alter table tfi_tax_admin_m add ttam_penalty money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_begin_date' ) alter table tfi_tax_admin_m add ttam_begin_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_end_date' ) alter table tfi_tax_admin_m add ttam_end_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_rmks' ) alter table tfi_tax_admin_m add ttam_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_status' ) alter table tfi_tax_admin_m add ttam_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_type' ) alter table tfi_tax_admin_m add ttam_ref_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_id' ) alter table tfi_tax_admin_m add ttam_ref_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_nbr' ) alter table tfi_tax_admin_m add ttam_ref_nbr varchar(20) default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_confirm' ) alter table tfi_tax_admin_m add ttam_confirm money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_state' ) alter table tfi_tax_admin_m add ttam_state int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_way' ) alter table tfi_tax_admin_m add ttam_pay_way int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee' ) alter table tfi_tax_admin_m add ttam_payee varchar(50) default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee_bank' ) alter table tfi_tax_admin_m add ttam_payee_bank varchar(100) default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee_acct' ) alter table tfi_tax_admin_m add ttam_payee_acct varchar(50) default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'isenable ' ) alter table tfi_tax_admin_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'addtime' ) alter table tfi_tax_admin_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'adduser' ) alter table tfi_tax_admin_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'modtime' ) alter table tfi_tax_admin_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'moduser' ) alter table tfi_tax_admin_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'acctid' ) alter table tfi_tax_admin_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_m') and name = 'temp_column' )alter table tfi_tax_admin_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_id' ) alter table tfi_tax_admin_d add ttad_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_ttam_id' ) alter table tfi_tax_admin_d add ttad_ttam_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_type' ) alter table tfi_tax_admin_d add ttad_type tinyint;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_code' ) alter table tfi_tax_admin_d add ttad_code varchar(10) not null  default '';alter table tfi_tax_admin_d alter column ttad_code varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_rmks' ) alter table tfi_tax_admin_d add ttad_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_tax_amt' ) alter table tfi_tax_admin_d add ttad_tax_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_late_fee' ) alter table tfi_tax_admin_d add ttad_late_fee money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'ttad_penalty' ) alter table tfi_tax_admin_d add ttad_penalty money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'isenable ' ) alter table tfi_tax_admin_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'addtime' ) alter table tfi_tax_admin_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'adduser' ) alter table tfi_tax_admin_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'modtime' ) alter table tfi_tax_admin_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'moduser' ) alter table tfi_tax_admin_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'acctid' ) alter table tfi_tax_admin_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_d') and name = 'temp_column' )alter table tfi_tax_admin_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_id' ) alter table tfi_tax_admin_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_wfm_id' ) alter table tfi_tax_admin_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_wfnd_id' ) alter table tfi_tax_admin_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_emp_id' ) alter table tfi_tax_admin_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_id' ) alter table tfi_tax_admin_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_state' ) alter table tfi_tax_admin_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_remark' ) alter table tfi_tax_admin_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_state' ) alter table tfi_tax_admin_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_node_state' ) alter table tfi_tax_admin_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_wf_route' ) alter table tfi_tax_admin_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_nbr' ) alter table tfi_tax_admin_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_summary' ) alter table tfi_tax_admin_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_addtime' ) alter table tfi_tax_admin_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_adduser' ) alter table tfi_tax_admin_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_modtime' ) alter table tfi_tax_admin_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_moduser' ) alter table tfi_tax_admin_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_para1' ) alter table tfi_tax_admin_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_para2' ) alter table tfi_tax_admin_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_para3' ) alter table tfi_tax_admin_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_cc_code' ) alter table tfi_tax_admin_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_audit_type' ) alter table tfi_tax_admin_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'wfna_audit_seq' ) alter table tfi_tax_admin_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'acctid' ) alter table tfi_tax_admin_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_a') and name = 'temp_column' )alter table tfi_tax_admin_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_id' ) alter table tfi_tax_admin_attach add ttaa_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_ttam_id' ) alter table tfi_tax_admin_attach add ttaa_ttam_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_file_path' ) alter table tfi_tax_admin_attach add ttaa_file_path varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_file_name' ) alter table tfi_tax_admin_attach add ttaa_file_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'isenable' ) alter table tfi_tax_admin_attach add isenable int not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'addtime' ) alter table tfi_tax_admin_attach add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'adduser' ) alter table tfi_tax_admin_attach add adduser varchar(20) not null  default ('0');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'modtime' ) alter table tfi_tax_admin_attach add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'moduser' ) alter table tfi_tax_admin_attach add moduser varchar(20) not null  default ('0');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'acctid' ) alter table tfi_tax_admin_attach add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_tax_admin_attach') and name = 'temp_column' )alter table tfi_tax_admin_attach drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_id' ) alter table tfi_charge_card add tchc_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_recordid' ) alter table tfi_charge_card add tchc_recordid int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_empid' ) alter table tfi_charge_card add tchc_empid varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_sceo_emp' ) alter table tfi_charge_card add tchc_sceo_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_rectime' ) alter table tfi_charge_card add tchc_rectime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_rectype' ) alter table tfi_charge_card add tchc_rectype int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_bebalance' ) alter table tfi_charge_card add tchc_bebalance decimal(19,2) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_balance' ) alter table tfi_charge_card add tchc_balance decimal(19,2) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_afbalance' ) alter table tfi_charge_card add tchc_afbalance decimal(19,2) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_remark' ) alter table tfi_charge_card add tchc_remark varchar(400);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_userid' ) alter table tfi_charge_card add tchc_userid varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_sceo_user' ) alter table tfi_charge_card add tchc_sceo_user varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_localpc' ) alter table tfi_charge_card add tchc_localpc varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_deviceid' ) alter table tfi_charge_card add tchc_deviceid int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'tchc_icbm_id' ) alter table tfi_charge_card add tchc_icbm_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'isenable ' ) alter table tfi_charge_card add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'addtime' ) alter table tfi_charge_card add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'adduser' ) alter table tfi_charge_card add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'modtime' ) alter table tfi_charge_card add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'moduser' ) alter table tfi_charge_card add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'acctid' ) alter table tfi_charge_card add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_charge_card') and name = 'temp_column' )alter table tfi_charge_card drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_id' ) alter table tfi_pay_expenses_m add pexm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_nbr' ) alter table tfi_pay_expenses_m add pexm_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_emp' ) alter table tfi_pay_expenses_m add pexm_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_dept' ) alter table tfi_pay_expenses_m add pexm_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_duty' ) alter table tfi_pay_expenses_m add pexm_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pemr_code' ) alter table tfi_pay_expenses_m add pexm_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_date' ) alter table tfi_pay_expenses_m add pexm_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_dept' ) alter table tfi_pay_expenses_m add pexm_pay_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_legal' ) alter table tfi_pay_expenses_m add pexm_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_item' ) alter table tfi_pay_expenses_m add pexm_item varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_sujt_id' ) alter table tfi_pay_expenses_m add pexm_sujt_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_acct' ) alter table tfi_pay_expenses_m add pexm_pay_acct int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_currency' ) alter table tfi_pay_expenses_m add pexm_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_rate' ) alter table tfi_pay_expenses_m add pexm_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_amt' ) alter table tfi_pay_expenses_m add pexm_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_overdue_amt' ) alter table tfi_pay_expenses_m add pexm_overdue_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_inv_amt' ) alter table tfi_pay_expenses_m add pexm_inv_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_date' ) alter table tfi_pay_expenses_m add pexm_pay_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_paycode_type' ) alter table tfi_pay_expenses_m add pexm_paycode_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_code' ) alter table tfi_pay_expenses_m add pexm_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_rmks' ) alter table tfi_pay_expenses_m add pexm_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_status' ) alter table tfi_pay_expenses_m add pexm_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_confirm' ) alter table tfi_pay_expenses_m add pexm_confirm money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'pexm_atsp_state' ) alter table tfi_pay_expenses_m add pexm_atsp_state int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'isenable ' ) alter table tfi_pay_expenses_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'addtime' ) alter table tfi_pay_expenses_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'adduser' ) alter table tfi_pay_expenses_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'modtime' ) alter table tfi_pay_expenses_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'moduser' ) alter table tfi_pay_expenses_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'acctid' ) alter table tfi_pay_expenses_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_m') and name = 'temp_column' )alter table tfi_pay_expenses_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_id' ) alter table tfi_expenses_invoice add exin_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_pexm_id' ) alter table tfi_expenses_invoice add exin_pexm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_itemcode' ) alter table tfi_expenses_invoice add exin_itemcode varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_name' ) alter table tfi_expenses_invoice add exin_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_date' ) alter table tfi_expenses_invoice add exin_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_type' ) alter table tfi_expenses_invoice add exin_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_code' ) alter table tfi_expenses_invoice add exin_code varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_number' ) alter table tfi_expenses_invoice add exin_number varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_amt' ) alter table tfi_expenses_invoice add exin_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_nontax_amt' ) alter table tfi_expenses_invoice add exin_nontax_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_rate' ) alter table tfi_expenses_invoice add exin_rate decimal(19,7);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_tax_amt' ) alter table tfi_expenses_invoice add exin_tax_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_tot_amt' ) alter table tfi_expenses_invoice add exin_tot_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'exin_remark' ) alter table tfi_expenses_invoice add exin_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'isenable ' ) alter table tfi_expenses_invoice add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'addtime' ) alter table tfi_expenses_invoice add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'adduser' ) alter table tfi_expenses_invoice add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'modtime' ) alter table tfi_expenses_invoice add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'moduser' ) alter table tfi_expenses_invoice add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'acctid' ) alter table tfi_expenses_invoice add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_expenses_invoice') and name = 'temp_column' )alter table tfi_expenses_invoice drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_id' ) alter table tfi_pay_expenses_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wfm_id' ) alter table tfi_pay_expenses_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wfnd_id' ) alter table tfi_pay_expenses_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_emp_id' ) alter table tfi_pay_expenses_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_id' ) alter table tfi_pay_expenses_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_state' ) alter table tfi_pay_expenses_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_remark' ) alter table tfi_pay_expenses_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_state' ) alter table tfi_pay_expenses_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_node_state' ) alter table tfi_pay_expenses_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wf_route' ) alter table tfi_pay_expenses_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_nbr' ) alter table tfi_pay_expenses_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_summary' ) alter table tfi_pay_expenses_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_addtime' ) alter table tfi_pay_expenses_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_adduser' ) alter table tfi_pay_expenses_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_modtime' ) alter table tfi_pay_expenses_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_moduser' ) alter table tfi_pay_expenses_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_para1' ) alter table tfi_pay_expenses_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_para2' ) alter table tfi_pay_expenses_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_para3' ) alter table tfi_pay_expenses_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_cc_code' ) alter table tfi_pay_expenses_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_audit_type' ) alter table tfi_pay_expenses_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'wfna_audit_seq' ) alter table tfi_pay_expenses_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'acctid' ) alter table tfi_pay_expenses_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_pay_expenses_a') and name = 'temp_column' )alter table tfi_pay_expenses_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_id' ) alter table tfi_capital_investment_m add tcim_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_nbr' ) alter table tfi_capital_investment_m add tcim_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_emp' ) alter table tfi_capital_investment_m add tcim_emp varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_dept' ) alter table tfi_capital_investment_m add tcim_dept varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_duty' ) alter table tfi_capital_investment_m add tcim_duty int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_pemr_code' ) alter table tfi_capital_investment_m add tcim_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_date' ) alter table tfi_capital_investment_m add tcim_date datetime not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_paycode_type' ) alter table tfi_capital_investment_m add tcim_paycode_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_pay_code' ) alter table tfi_capital_investment_m add tcim_pay_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_type' ) alter table tfi_capital_investment_m add tcim_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_begin_date' ) alter table tfi_capital_investment_m add tcim_begin_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_end_date' ) alter table tfi_capital_investment_m add tcim_end_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_curr' ) alter table tfi_capital_investment_m add tcim_curr varchar(3);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_cycle' ) alter table tfi_capital_investment_m add tcim_cycle varchar(5);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_amt' ) alter table tfi_capital_investment_m add tcim_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_rmks' ) alter table tfi_capital_investment_m add tcim_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'tcim_status' ) alter table tfi_capital_investment_m add tcim_status tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'isenable' ) alter table tfi_capital_investment_m add isenable tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'addtime' ) alter table tfi_capital_investment_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'adduser' ) alter table tfi_capital_investment_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'modtime' ) alter table tfi_capital_investment_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'moduser' ) alter table tfi_capital_investment_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'acctid' ) alter table tfi_capital_investment_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_m') and name = 'temp_column' )alter table tfi_capital_investment_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_id' ) alter table tfi_capital_investment_d add tcid_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_tcim_id' ) alter table tfi_capital_investment_d add tcid_tcim_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_dept' ) alter table tfi_capital_investment_d add tcid_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_legal' ) alter table tfi_capital_investment_d add tcid_legal int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_rate' ) alter table tfi_capital_investment_d add tcid_rate decimal(19,7);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_amt' ) alter table tfi_capital_investment_d add tcid_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_all' ) alter table tfi_capital_investment_d add tcid_interest_all money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money01' ) alter table tfi_capital_investment_d add tcid_interest_money01 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money02' ) alter table tfi_capital_investment_d add tcid_interest_money02 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money03' ) alter table tfi_capital_investment_d add tcid_interest_money03 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money04' ) alter table tfi_capital_investment_d add tcid_interest_money04 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money05' ) alter table tfi_capital_investment_d add tcid_interest_money05 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money06' ) alter table tfi_capital_investment_d add tcid_interest_money06 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money07' ) alter table tfi_capital_investment_d add tcid_interest_money07 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money08' ) alter table tfi_capital_investment_d add tcid_interest_money08 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money09' ) alter table tfi_capital_investment_d add tcid_interest_money09 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money10' ) alter table tfi_capital_investment_d add tcid_interest_money10 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money11' ) alter table tfi_capital_investment_d add tcid_interest_money11 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money12' ) alter table tfi_capital_investment_d add tcid_interest_money12 money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'tcid_rmks' ) alter table tfi_capital_investment_d add tcid_rmks varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'isenable' ) alter table tfi_capital_investment_d add isenable tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'addtime' ) alter table tfi_capital_investment_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'adduser' ) alter table tfi_capital_investment_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'modtime' ) alter table tfi_capital_investment_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'moduser' ) alter table tfi_capital_investment_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'acctid' ) alter table tfi_capital_investment_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_d') and name = 'temp_column' )alter table tfi_capital_investment_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_id' ) alter table tfi_capital_investment_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_wfm_id' ) alter table tfi_capital_investment_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_wfnd_id' ) alter table tfi_capital_investment_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_emp_id' ) alter table tfi_capital_investment_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_id' ) alter table tfi_capital_investment_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_state' ) alter table tfi_capital_investment_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_remark' ) alter table tfi_capital_investment_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_state' ) alter table tfi_capital_investment_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_node_state' ) alter table tfi_capital_investment_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_wf_route' ) alter table tfi_capital_investment_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_nbr' ) alter table tfi_capital_investment_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_summary' ) alter table tfi_capital_investment_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_addtime' ) alter table tfi_capital_investment_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_adduser' ) alter table tfi_capital_investment_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_modtime' ) alter table tfi_capital_investment_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_moduser' ) alter table tfi_capital_investment_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_para1' ) alter table tfi_capital_investment_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_para2' ) alter table tfi_capital_investment_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_para3' ) alter table tfi_capital_investment_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_cc_code' ) alter table tfi_capital_investment_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_audit_type' ) alter table tfi_capital_investment_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'wfna_audit_seq' ) alter table tfi_capital_investment_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'acctid' ) alter table tfi_capital_investment_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_capital_investment_a') and name = 'temp_column' )alter table tfi_capital_investment_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_id' ) alter table tfi_ap_log add aplg_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_code' ) alter table tfi_ap_log add aplg_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_m' ) alter table tfi_ap_log add aplg_m varchar(40);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_d' ) alter table tfi_ap_log add aplg_d varchar(40);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_a' ) alter table tfi_ap_log add aplg_a varchar(40);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_amt' ) alter table tfi_ap_log add aplg_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_ramt' ) alter table tfi_ap_log add aplg_ramt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_real_amt' ) alter table tfi_ap_log add aplg_real_amt money;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'aplg_rmks' ) alter table tfi_ap_log add aplg_rmks varchar(2000);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'isenable ' ) alter table tfi_ap_log add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'addtime' ) alter table tfi_ap_log add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'adduser' ) alter table tfi_ap_log add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'modtime' ) alter table tfi_ap_log add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'moduser' ) alter table tfi_ap_log add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'acctid' ) alter table tfi_ap_log add acctid int default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_ap_log') and name = 'temp_column' )alter table tfi_ap_log drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_id' ) alter table tfi_inner_account_m add inam_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_type' ) alter table tfi_inner_account_m add inam_type int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_nbr' ) alter table tfi_inner_account_m add inam_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_emp' ) alter table tfi_inner_account_m add inam_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_dept' ) alter table tfi_inner_account_m add inam_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_duty' ) alter table tfi_inner_account_m add inam_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_pemr_code' ) alter table tfi_inner_account_m add inam_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_date' ) alter table tfi_inner_account_m add inam_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_acct_sdate' ) alter table tfi_inner_account_m add inam_acct_sdate datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_acct_edate' ) alter table tfi_inner_account_m add inam_acct_edate datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_paycode_type' ) alter table tfi_inner_account_m add inam_paycode_type tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_pay_code' ) alter table tfi_inner_account_m add inam_pay_code varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_pay_acct_id' ) alter table tfi_inner_account_m add inam_pay_acct_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_pay_type' ) alter table tfi_inner_account_m add inam_pay_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_othercode_type' ) alter table tfi_inner_account_m add inam_othercode_type tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_other_code' ) alter table tfi_inner_account_m add inam_other_code varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_other_acct_id' ) alter table tfi_inner_account_m add inam_other_acct_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_currency' ) alter table tfi_inner_account_m add inam_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_rate' ) alter table tfi_inner_account_m add inam_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_amt' ) alter table tfi_inner_account_m add inam_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_pay_date' ) alter table tfi_inner_account_m add inam_pay_date datetime;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_rmks' ) alter table tfi_inner_account_m add inam_rmks varchar(800);alter table tfi_inner_account_m alter column inam_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_status' ) alter table tfi_inner_account_m add inam_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'inam_ref_id' ) alter table tfi_inner_account_m add inam_ref_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'isenable ' ) alter table tfi_inner_account_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'addtime' ) alter table tfi_inner_account_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'adduser' ) alter table tfi_inner_account_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'modtime' ) alter table tfi_inner_account_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'modtime2' ) alter table tfi_inner_account_m add modtime2 datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'moduser' ) alter table tfi_inner_account_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'acctid' ) alter table tfi_inner_account_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_inner_account_m') and name = 'temp_column' )alter table tfi_inner_account_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_id' ) alter table tfi_inner_account_d add inad_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_inam_id' ) alter table tfi_inner_account_d add inad_inam_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_bill_type' ) alter table tfi_inner_account_d add inad_bill_type tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_paym_id' ) alter table tfi_inner_account_d add inad_paym_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_currency' ) alter table tfi_inner_account_d add inad_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_rate' ) alter table tfi_inner_account_d add inad_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_pay_amt' ) alter table tfi_inner_account_d add inad_pay_amt money default 0;
end try
begin catch
end catch
go

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_rmks' ) alter table tfi_inner_account_d add inad_rmks varchar(800);alter table tfi_inner_account_d alter column inad_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_real_amt' ) alter table tfi_inner_account_d add inad_real_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_source_id' ) alter table tfi_inner_account_d add inad_source_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'inad_source_nbr' ) alter table tfi_inner_account_d add inad_source_nbr varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'isenable ' ) alter table tfi_inner_account_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'addtime' ) alter table tfi_inner_account_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'adduser' ) alter table tfi_inner_account_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'modtime' ) alter table tfi_inner_account_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'moduser' ) alter table tfi_inner_account_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'acctid' ) alter table tfi_inner_account_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_inner_account_d') and name = 'temp_column' )alter table tfi_inner_account_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_id' ) alter table tfi_inner_account_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_wfm_id' ) alter table tfi_inner_account_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_wfnd_id' ) alter table tfi_inner_account_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_emp_id' ) alter table tfi_inner_account_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_m_id' ) alter table tfi_inner_account_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_m_state' ) alter table tfi_inner_account_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_m_remark' ) alter table tfi_inner_account_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_state' ) alter table tfi_inner_account_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_node_state' ) alter table tfi_inner_account_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_wf_route' ) alter table tfi_inner_account_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_nbr' ) alter table tfi_inner_account_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_summary' ) alter table tfi_inner_account_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_addtime' ) alter table tfi_inner_account_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_adduser' ) alter table tfi_inner_account_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_modtime' ) alter table tfi_inner_account_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_moduser' ) alter table tfi_inner_account_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_para1' ) alter table tfi_inner_account_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_para2' ) alter table tfi_inner_account_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_para3' ) alter table tfi_inner_account_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_cc_code' ) alter table tfi_inner_account_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_audit_type' ) alter table tfi_inner_account_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'wfna_audit_seq' ) alter table tfi_inner_account_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'acctid' ) alter table tfi_inner_account_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_inner_account_a') and name = 'temp_column' )alter table tfi_inner_account_a drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_id' ) alter table tfi_refound_m add rfdm_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_nbr' ) alter table tfi_refound_m add rfdm_nbr varchar(20) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_emp' ) alter table tfi_refound_m add rfdm_emp varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_dept' ) alter table tfi_refound_m add rfdm_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_duty' ) alter table tfi_refound_m add rfdm_duty int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pemr_code' ) alter table tfi_refound_m add rfdm_pemr_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_date' ) alter table tfi_refound_m add rfdm_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_rmks' ) alter table tfi_refound_m add rfdm_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_dept' ) alter table tfi_refound_m add rfdm_pay_dept varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_legal' ) alter table tfi_refound_m add rfdm_pay_legal int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_date' ) alter table tfi_refound_m add rfdm_pay_date datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_amt' ) alter table tfi_refound_m add rfdm_pay_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_currency' ) alter table tfi_refound_m add rfdm_currency varchar(10) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_rate' ) alter table tfi_refound_m add rfdm_rate decimal(19,7) not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_code_type' ) alter table tfi_refound_m add rfdm_code_type tinyint not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_code' ) alter table tfi_refound_m add rfdm_code varchar(20) not null  default '';
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_type' ) alter table tfi_refound_m add rfdm_pay_type tinyint not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_nbr' ) alter table tfi_refound_m add rfdm_pay_nbr varchar(50);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_name' ) alter table tfi_refound_m add rfdm_pay_name varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_pay_bank' ) alter table tfi_refound_m add rfdm_pay_bank varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'rfdm_status' ) alter table tfi_refound_m add rfdm_status tinyint default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'isenable ' ) alter table tfi_refound_m add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'addtime' ) alter table tfi_refound_m add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'adduser' ) alter table tfi_refound_m add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'modtime' ) alter table tfi_refound_m add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'moduser' ) alter table tfi_refound_m add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'acctid' ) alter table tfi_refound_m add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_refound_m') and name = 'temp_column' )alter table tfi_refound_m drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'rfdd_id' ) alter table tfi_refound_d add rfdd_id int identity not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'rfdd_rfdm_id' ) alter table tfi_refound_d add rfdd_rfdm_id int not null ;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'rfdd_actx_id' ) alter table tfi_refound_d add rfdd_actx_id int not null  default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'rfdd_amt' ) alter table tfi_refound_d add rfdd_amt money default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'rfdd_rmks' ) alter table tfi_refound_d add rfdd_rmks varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'isenable ' ) alter table tfi_refound_d add isenable  tinyint not null  default 1;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'addtime' ) alter table tfi_refound_d add addtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'adduser' ) alter table tfi_refound_d add adduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'modtime' ) alter table tfi_refound_d add modtime datetime not null  default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'moduser' ) alter table tfi_refound_d add moduser varchar(20) not null  default ('n/a');
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'acctid' ) alter table tfi_refound_d add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_refound_d') and name = 'temp_column' )alter table tfi_refound_d drop column temp_column;
end try
begin catch
end catch
GO

begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_id' ) alter table tfi_refound_a add wfna_id int identity;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_wfm_id' ) alter table tfi_refound_a add wfna_wfm_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_wfnd_id' ) alter table tfi_refound_a add wfna_wfnd_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_emp_id' ) alter table tfi_refound_a add wfna_emp_id varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_m_id' ) alter table tfi_refound_a add wfna_m_id int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_m_state' ) alter table tfi_refound_a add wfna_m_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_m_remark' ) alter table tfi_refound_a add wfna_m_remark varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_state' ) alter table tfi_refound_a add wfna_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_node_state' ) alter table tfi_refound_a add wfna_node_state tinyint;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_wf_route' ) alter table tfi_refound_a add wfna_wf_route varchar(800);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_nbr' ) alter table tfi_refound_a add wfna_nbr varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_summary' ) alter table tfi_refound_a add wfna_summary varchar(200);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_addtime' ) alter table tfi_refound_a add wfna_addtime datetime default getdate();
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_adduser' ) alter table tfi_refound_a add wfna_adduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_modtime' ) alter table tfi_refound_a add wfna_modtime datetime;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_moduser' ) alter table tfi_refound_a add wfna_moduser varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_para1' ) alter table tfi_refound_a add wfna_para1 int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_para2' ) alter table tfi_refound_a add wfna_para2 varchar(100);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_para3' ) alter table tfi_refound_a add wfna_para3 int default 0;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_cc_code' ) alter table tfi_refound_a add wfna_cc_code varchar(20);
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_audit_type' ) alter table tfi_refound_a add wfna_audit_type int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'wfna_audit_seq' ) alter table tfi_refound_a add wfna_audit_seq int;
end try
begin catch
end catch
go
begin try
if not exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'acctid' ) alter table tfi_refound_a add acctid int not null  default 0;
end try
begin catch
end catch
go

begin try
if exists (select * from sys.columns where object_id = object_id('tfi_refound_a') and name = 'temp_column' )alter table tfi_refound_a drop column temp_column;
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_type_m') and type = 'pk' ) 
 alter table tfi_type_m add constraint pk_typm_id primary key clustered (typm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_type_d') and type = 'pk' ) 
 alter table tfi_type_d add constraint pk_typd_id primary key clustered (typd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_m') and type = 'pk' ) 
 alter table tfi_pay_m add constraint pk_paym_id primary key clustered (paym_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_attch') and type = 'pk' ) 
 alter table tfi_pay_attch add constraint pk_payt_id primary key clustered (payt_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_a') and type = 'pk' ) 
 alter table tfi_pay_a add constraint pk_wfna_paym_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_m') and type = 'pk' ) 
 alter table tfi_billhead_m add constraint pk_abhm_id primary key clustered (abhm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_collection') and type = 'pk' ) 
 alter table tfi_billhead_collection add constraint pk_abhc_id primary key clustered (abhc_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_d') and type = 'pk' ) 
 alter table tfi_billhead_d add constraint pk_abhd_id primary key clustered (abhd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_a') and type = 'pk' ) 
 alter table tfi_billhead_a add constraint pk_wfna_abhm_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inv_bill_r') and type = 'pk' ) 
 alter table tfi_inv_bill_r add constraint pk_inbr_id primary key clustered (inbr_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_period_m') and type = 'pk' ) 
 alter table tfi_period_m add constraint pk_prdm_id primary key clustered (prdm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_period_d') and type = 'pk' ) 
 alter table tfi_period_d add constraint pk_prdd_id primary key clustered (prdd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_execute_m') and type = 'pk' ) 
 alter table tfi_execute_m add constraint pk_exem_id primary key clustered (exem_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_execute_a') and type = 'pk' ) 
 alter table tfi_execute_a add constraint pk_wfna_exem_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_incomebill_m') and type = 'pk' ) 
 alter table tfi_incomebill_m add constraint pk_icbm_id primary key clustered (icbm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_incomebill_d') and type = 'pk' ) 
 alter table tfi_incomebill_d add constraint pk_icbd_id primary key clustered (icbd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_incomebill_a') and type = 'pk' ) 
 alter table tfi_incomebill_a add constraint pk_wfna_icbm_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_m') and type = 'pk' ) 
 alter table tfi_accountcussent_m add constraint pk_accm_id primary key clustered (accm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_d') and type = 'pk' ) 
 alter table tfi_accountcussent_d add constraint pk_accd_id primary key clustered (accd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_a') and type = 'pk' ) 
 alter table tfi_accountcussent_a add constraint pk_wfna_accm_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_attach') and type = 'pk' ) 
 alter table tfi_accountcussent_attach add constraint pk_tact primary key clustered (tact_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_other_m') and type = 'pk' ) 
 alter table tfi_pay_other_m add constraint pk_paym_other_id primary key clustered (paym_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_m') and type = 'pk' ) 
 alter table tfi_tax_admin_m add constraint pk_ttam_id primary key clustered (ttam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_d') and type = 'pk' ) 
 alter table tfi_tax_admin_d add constraint pk_ttad_id primary key clustered (ttad_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_a') and type = 'pk' ) 
 alter table tfi_tax_admin_a add constraint pk_wfna_ttam_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_attach') and type = 'pk' ) 
 alter table tfi_tax_admin_attach add constraint pk_ttaa primary key clustered (ttaa_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_charge_card') and type = 'pk' ) 
 alter table tfi_charge_card add constraint pk_tchc_id primary key clustered (tchc_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_expenses_m') and type = 'pk' ) 
 alter table tfi_pay_expenses_m add constraint pk_pexm_id primary key clustered (pexm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_expenses_invoice') and type = 'pk' ) 
 alter table tfi_expenses_invoice add constraint pk_exin_id primary key clustered (exin_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_expenses_a') and type = 'pk' ) 
 alter table tfi_pay_expenses_a add constraint pk_wfna_pexm_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_capital_investment_m') and type = 'pk' ) 
 alter table tfi_capital_investment_m add constraint pk_tcim_id primary key clustered (tcim_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_capital_investment_d') and type = 'pk' ) 
 alter table tfi_capital_investment_d add constraint pk_tcid_id primary key clustered (tcid_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_capital_investment_a') and type = 'pk' ) 
 alter table tfi_capital_investment_a add constraint pk_wfna_tcim_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_ap_log') and type = 'pk' ) 
 alter table tfi_ap_log add constraint pk_aplg_id primary key clustered (aplg_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inner_account_m') and type = 'pk' ) 
 alter table tfi_inner_account_m add constraint pk_inam_id primary key clustered (inam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inner_account_d') and type = 'pk' ) 
 alter table tfi_inner_account_d add constraint pk_inad_id primary key clustered (inad_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inner_account_a') and type = 'pk' ) 
 alter table tfi_inner_account_a add constraint pk_wfna_inam_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_refound_m') and type = 'pk' ) 
 alter table tfi_refound_m add constraint pk_rfdm_id primary key clustered (rfdm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_refound_d') and type = 'pk' ) 
 alter table tfi_refound_d add constraint pk_rfdd_id primary key clustered (rfdd_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_refound_a') and type = 'pk' ) 
 alter table tfi_refound_a add constraint pk_wfna_rfdm_id primary key clustered (wfna_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_type_m') and name = 'dx_typm_code' ) 
 create unique nonclustered index dx_typm_code on  dbo.tfi_type_m( typm_code,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_type_d') and name = 'dx_typd_code' ) 
 create unique nonclustered index dx_typd_code on  dbo.tfi_type_d( typd_typm_id,typd_wfm_code,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_billhead_m') and name = 'dx_abhm_nbr' ) 
 create unique nonclustered index dx_abhm_nbr on  dbo.tfi_billhead_m( abhm_nbr,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_execute_m') and name = 'dx_exem_nbr' ) 
 create unique nonclustered index dx_exem_nbr on  dbo.tfi_execute_m( exem_nbr,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_incomebill_m') and name = 'dx_icbm_nbr' ) 
 create unique nonclustered index dx_icbm_nbr on  dbo.tfi_incomebill_m( icbm_nbr,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_accountcussent_m') and name = 'dx_accm_nbr' ) 
 create unique nonclustered index dx_accm_nbr on  dbo.tfi_accountcussent_m( accm_nbr,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_capital_investment_m') and name = 'dx_tcim_code' ) 
 create unique nonclustered index dx_tcim_code on  dbo.tfi_capital_investment_m( tcim_nbr);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_inner_account_m') and name = 'dx_inam_nbr' ) 
 create unique nonclustered index dx_inam_nbr on  dbo.tfi_inner_account_m( inam_nbr,acctid);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.indexes where object_id = object_id('tfi_refound_m') and name = 'dx_rfdm_nbr' ) 
 create unique nonclustered index dx_rfdm_nbr on  dbo.tfi_refound_m( rfdm_nbr);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_type_d') and name = 'fk_typd_typm_id' ) 
 alter table tfi_type_d add constraint fk_typd_typm_id foreign key (typd_typm_id) references tfi_type_m(typm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_attch') and name = 'fk_payt_paym_id' ) 
 alter table tfi_pay_attch add constraint fk_payt_paym_id foreign key (payt_paym_id) references tfi_pay_other_m(paym_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_a') and name = 'fk_wfna_paym_id' ) 
 alter table tfi_pay_a add constraint fk_wfna_paym_id foreign key (wfna_m_id) references tfi_pay_other_m(paym_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_collection') and name = 'fk_abhc_abhm_id' ) 
 alter table tfi_billhead_collection add constraint fk_abhc_abhm_id foreign key (abhc_abhm_id) references tfi_billhead_m(abhm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_d') and name = 'fk_abhd_abhm_id' ) 
 alter table tfi_billhead_d add constraint fk_abhd_abhm_id foreign key (abhd_abhm_id) references tfi_billhead_m(abhm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_billhead_a') and name = 'fk_wfna_abhm_id' ) 
 alter table tfi_billhead_a add constraint fk_wfna_abhm_id foreign key (wfna_m_id) references tfi_billhead_m(abhm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inv_bill_r') and name = 'fk_inbr_abhm_id' ) 
 alter table tfi_inv_bill_r add constraint fk_inbr_abhm_id foreign key (inbr_abhm_id) references tfi_billhead_m(abhm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_period_d') and name = 'fk_prdd_prdm_id' ) 
 alter table tfi_period_d add constraint fk_prdd_prdm_id foreign key (prdd_prdm_id) references tfi_period_m(prdm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_execute_a') and name = 'fk_wfna_exem_id' ) 
 alter table tfi_execute_a add constraint fk_wfna_exem_id foreign key (wfna_m_id) references tfi_execute_m(exem_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_incomebill_d') and name = 'fk_icbd_icbm_id' ) 
 alter table tfi_incomebill_d add constraint fk_icbd_icbm_id foreign key (icbd_icbm_id) references tfi_incomebill_m(icbm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_incomebill_a') and name = 'fk_wfna_icbm_id' ) 
 alter table tfi_incomebill_a add constraint fk_wfna_icbm_id foreign key (wfna_m_id) references tfi_incomebill_m(icbm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_d') and name = 'fk_accd_accm_id' ) 
 alter table tfi_accountcussent_d add constraint fk_accd_accm_id foreign key (accd_accm_id) references tfi_accountcussent_m(accm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_a') and name = 'fk_wfna_accm_id' ) 
 alter table tfi_accountcussent_a add constraint fk_wfna_accm_id foreign key (wfna_m_id) references tfi_accountcussent_m(accm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_accountcussent_attach') and name = 'fk_tact_accm_id' ) 
 alter table tfi_accountcussent_attach add constraint fk_tact_accm_id foreign key (tact_accm_id) references tfi_accountcussent_m(accm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_d') and name = 'fk_ttad_ttam_id' ) 
 alter table tfi_tax_admin_d add constraint fk_ttad_ttam_id foreign key (ttad_ttam_id) references tfi_tax_admin_m(ttam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_a') and name = 'fk_wfna_ttam_id' ) 
 alter table tfi_tax_admin_a add constraint fk_wfna_ttam_id foreign key (wfna_m_id) references tfi_tax_admin_m(ttam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_tax_admin_attach') and name = 'fk_ttaa_ttam_id' ) 
 alter table tfi_tax_admin_attach add constraint fk_ttaa_ttam_id foreign key (ttaa_ttam_id) references tfi_tax_admin_m(ttam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_expenses_invoice') and name = 'fk_exin_pexm_id' ) 
 alter table tfi_expenses_invoice add constraint fk_exin_pexm_id foreign key (exin_pexm_id) references tfi_pay_expenses_m(pexm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_pay_expenses_a') and name = 'fk_wfna_m_pexm_id' ) 
 alter table tfi_pay_expenses_a add constraint fk_wfna_m_pexm_id foreign key (wfna_m_id) references tfi_pay_expenses_m(pexm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_capital_investment_d') and name = 'fk_tcim_id' ) 
 alter table tfi_capital_investment_d add constraint fk_tcim_id foreign key (tcid_tcim_id) references tfi_capital_investment_m(tcim_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_capital_investment_a') and name = 'fk_wfna_tcim_id' ) 
 alter table tfi_capital_investment_a add constraint fk_wfna_tcim_id foreign key (wfna_m_id) references tfi_capital_investment_m(tcim_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inner_account_d') and name = 'fk_inad_inam_id' ) 
 alter table tfi_inner_account_d add constraint fk_inad_inam_id foreign key (inad_inam_id) references tfi_inner_account_m(inam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_inner_account_a') and name = 'fk_wfna_inam_id' ) 
 alter table tfi_inner_account_a add constraint fk_wfna_inam_id foreign key (wfna_m_id) references tfi_inner_account_m(inam_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_refound_d') and name = 'fk_rfdd_rfdm_id' ) 
 alter table tfi_refound_d add constraint fk_rfdd_rfdm_id foreign key (rfdd_rfdm_id) references tfi_refound_m(rfdm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.objects where parent_object_id = object_id('tfi_refound_a') and name = 'fk_wfna_rfdm_id' ) 
 alter table tfi_refound_a add constraint fk_wfna_rfdm_id foreign key (wfna_m_id) references tfi_refound_m(rfdm_id);
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'tfi_type_m' )
 EXEC sp_addextendedproperty N'tfi_type_m', N'类型主表  typm', 'USER', N'dbo', 'TABLE', N'tfi_type_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'typm_id' )
EXEC sp_addextendedproperty N'typm_id', N'类型主ID ', 'USER', N'dbo', 'TABLE', N'tfi_type_m', 'COLUMN', N'typm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'typm_code' )
EXEC sp_addextendedproperty N'typm_code', N'类型编码 ', 'USER', N'dbo', 'TABLE', N'tfi_type_m', 'COLUMN', N'typm_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'typm_name' )
EXEC sp_addextendedproperty N'typm_name', N'类型名称 ', 'USER', N'dbo', 'TABLE', N'tfi_type_m', 'COLUMN', N'typm_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'typm_attribute' )
EXEC sp_addextendedproperty N'typm_attribute', N'类型属性 参数  1：应付；2：应收', 'USER', N'dbo', 'TABLE', N'tfi_type_m', 'COLUMN', N'typm_attribute';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_m') and name = 'typm_desc' )
EXEC sp_addextendedproperty N'typm_desc', N'类型描述 ', 'USER', N'dbo', 'TABLE', N'tfi_type_m', 'COLUMN', N'typm_desc';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'tfi_type_d' )
 EXEC sp_addextendedproperty N'tfi_type_d', N'类型明细表  typd', 'USER', N'dbo', 'TABLE', N'tfi_type_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_id' )
EXEC sp_addextendedproperty N'typd_id', N'明细ID ', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_typm_id' )
EXEC sp_addextendedproperty N'typd_typm_id', N'类型主ID 来源于tfi_type_m.typm_id', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_typm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_wfm_code' )
EXEC sp_addextendedproperty N'typd_wfm_code', N'流程编码 来源于流程表twf_m.wfm_code   (有数据才会写paym数据，否则调用rp_fi_add_apacV2会报错)', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_wfm_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_send_flag' )
EXEC sp_addextendedproperty N'typd_send_flag', N'付/收款通知单可否选 参数 0：不可选；1：可选(手动做单是否可选)', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_send_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_source_table' )
EXEC sp_addextendedproperty N'typd_source_table', N'来源表 ', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_source_table';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_source_term' )
EXEC sp_addextendedproperty N'typd_source_term', N'来源条件 ', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_source_term';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_next_flag' )
EXEC sp_addextendedproperty N'typd_next_flag', N'是否推送付/收款通知单 参数 0：不推送；1：推送', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_next_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_type_d') and name = 'typd_excu_flag' )
EXEC sp_addextendedproperty N'typd_excu_flag', N'是否推送付款执行单 参数 0：不推送；1：推送', 'USER', N'dbo', 'TABLE', N'tfi_type_d', 'COLUMN', N'typd_excu_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'tfi_pay_m' )
 EXEC sp_addextendedproperty N'tfi_pay_m', N'应收/应付表  paym', 'USER', N'dbo', 'TABLE', N'tfi_pay_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_id' )
EXEC sp_addextendedproperty N'paym_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_nbr' )
EXEC sp_addextendedproperty N'paym_nbr', N'其他应收/应付单号 1，3标志为前置单据单号，2为AP06单号，4为AR06单号', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_nbr_flag' )
EXEC sp_addextendedproperty N'paym_nbr_flag', N'单据标志 参数 1：应付单，2：其他应付单 3：应收单 4：其他应收单；5：AR08预收通知单；6：AP08预付通知单', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_nbr_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_item' )
EXEC sp_addextendedproperty N'paym_item', N'会计科目 select code_code，code_name from tba_code where code_type=‘ap_abhm_item‘ and code_code=‘1‘ or code_code=‘2‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_typm_id' )
EXEC sp_addextendedproperty N'paym_typm_id', N'类型主id 来源于 tfi_type_m.typm_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_typm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_typd_id' )
EXEC sp_addextendedproperty N'paym_typd_id', N'类型明细id 来源于 tfi_type_d.typd_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_typd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_flag' )
EXEC sp_addextendedproperty N'paym_flag', N'单据标记 参数 1:蓝字，累加；2：红字，累减', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_emp' )
EXEC sp_addextendedproperty N'paym_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_dept' )
EXEC sp_addextendedproperty N'paym_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_duty' )
EXEC sp_addextendedproperty N'paym_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_date' )
EXEC sp_addextendedproperty N'paym_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_due_date' )
EXEC sp_addextendedproperty N'paym_due_date', N'应付日期/应收日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_due_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_legal' )
EXEC sp_addextendedproperty N'paym_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation（我方）', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_currency' )
EXEC sp_addextendedproperty N'paym_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_rate' )
EXEC sp_addextendedproperty N'paym_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_amt' )
EXEC sp_addextendedproperty N'paym_amt', N'应付金额/应收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_nbr_amt' )
EXEC sp_addextendedproperty N'paym_nbr_amt', N'已付金额/已收单据金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_nbr_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_real_amt' )
EXEC sp_addextendedproperty N'paym_real_amt', N'已付金额/已收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_type' )
EXEC sp_addextendedproperty N'paym_pay_type', N'支付方式/收款方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_admin_type' )
EXEC sp_addextendedproperty N'paym_admin_type', N'第三方类型 1：供应商，2：个人，3：客户，4：部门(都是4类型，我方)', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_admin_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_admin_dept' )
EXEC sp_addextendedproperty N'paym_admin_dept', N'第三方代码 采购部分来源于采购的负责人所在的部门，报销来源于报销申请人所在的部门索赔来源于索赔申请人所在部门，销售来源于销售的负责人所在部门（（应收/应付部门编码））', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_admin_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_admin_desc' )
EXEC sp_addextendedproperty N'paym_admin_desc', N'第三方名称 应收为权益方，应付为费用方（应收/应付部门名称） (没有的取申请人)', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_admin_desc';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_duty_emp' )
EXEC sp_addextendedproperty N'paym_duty_emp', N'责任人 采购部分来源于采购的负责人，报销来源于报销申请人，索赔来源于索赔申请人，销售来源于销售的负责人', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_duty_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_paycode_type' )
EXEC sp_addextendedproperty N'paym_paycode_type', N'对方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘增加类型：101 内部法人交易', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_code' )
EXEC sp_addextendedproperty N'paym_pay_code', N'对方代码 来源于供应商代码，个人工号，其他有业务来往的客户，固定资产供应商，法人等。', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_spl_name' )
EXEC sp_addextendedproperty N'paym_spl_name', N'对方名称 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_spl_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_deptcode' )
EXEC sp_addextendedproperty N'paym_pay_deptcode', N'内部法人交易部门 只有内部法人交易时必须(对方部门)', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_deptcode';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_bank' )
EXEC sp_addextendedproperty N'paym_pay_bank', N'对方开户行 应付使用，加入收款也用到了', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_name' )
EXEC sp_addextendedproperty N'paym_pay_name', N'对方开户名 应付使用', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_pay_nbr' )
EXEC sp_addextendedproperty N'paym_pay_nbr', N'对方账号 应付使用', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_pay_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_rmks' )
EXEC sp_addextendedproperty N'paym_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_status' )
EXEC sp_addextendedproperty N'paym_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_ref_nbr' )
EXEC sp_addextendedproperty N'paym_ref_nbr', N'来源单号 来源于采购对账单tpu_acct_m.typm_nbr，采购凭证表tpu_pvo_m.pvom_receive_nbr，tpu_pvo_d.pvod_nbr_ref报销主表tfi_reimbursement.rmmt_nbr索赔 tqa_claim_m.clam_nbr销售凭证表 nbr销售对账单表 nbr', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_ref_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_ref_id' )
EXEC sp_addextendedproperty N'paym_ref_id', N'来源单id 来源于采购对账单tpu_acct_m.typm_id，采购凭证表tpu_pvo_m.pvom_id，tpu_pvo_d.pvod_id报销主表tfi_reimbursement.rmmt_id索赔 tqa_claim_m.clam_id销售凭证表 id销售对账单表 id', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_ref_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_ref_did' )
EXEC sp_addextendedproperty N'paym_ref_did', N'来源单明细id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_ref_did';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_parent_id' )
EXEC sp_addextendedproperty N'paym_parent_id', N'父单据id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_parent_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_m') and name = 'paym_split_sort' )
EXEC sp_addextendedproperty N'paym_split_sort', N'拆分序号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_m', 'COLUMN', N'paym_split_sort';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_attch') and name = 'tfi_pay_attch' )
 EXEC sp_addextendedproperty N'tfi_pay_attch', N'应收/应付附件表  payt', 'USER', N'dbo', 'TABLE', N'tfi_pay_attch';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_attch') and name = 'payt_id' )
EXEC sp_addextendedproperty N'payt_id', N'记录ID ', 'USER', N'dbo', 'TABLE', N'tfi_pay_attch', 'COLUMN', N'payt_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_attch') and name = 'payt_paym_id' )
EXEC sp_addextendedproperty N'payt_paym_id', N'应付单主表id 来源于tfi_pay_m.paym_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_attch', 'COLUMN', N'payt_paym_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_attch') and name = 'payt_file_name' )
EXEC sp_addextendedproperty N'payt_file_name', N'附件名称 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_attch', 'COLUMN', N'payt_file_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_attch') and name = 'payt_file_path' )
EXEC sp_addextendedproperty N'payt_file_path', N'附件路径 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_attch', 'COLUMN', N'payt_file_path';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'tfi_pay_a' )
 EXEC sp_addextendedproperty N'tfi_pay_a', N'其他应收/应付审核表', 'USER', N'dbo', 'TABLE', N'tfi_pay_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于tfi_pay_m.paym_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'tfi_billhead_m' )
 EXEC sp_addextendedproperty N'tfi_billhead_m', N'付款通知主表  abhm', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_id' )
EXEC sp_addextendedproperty N'abhm_id', N'付款主id ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_type' )
EXEC sp_addextendedproperty N'abhm_type', N'付款类型 1：付款，2：预付', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_nbr' )
EXEC sp_addextendedproperty N'abhm_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_item' )
EXEC sp_addextendedproperty N'abhm_item', N'会计科目 select code_code，code_name from tba_code where code_type=‘ap_abhm_item‘ and code_code=‘1‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_emp' )
EXEC sp_addextendedproperty N'abhm_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_dept' )
EXEC sp_addextendedproperty N'abhm_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_duty' )
EXEC sp_addextendedproperty N'abhm_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pemr_code' )
EXEC sp_addextendedproperty N'abhm_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_date' )
EXEC sp_addextendedproperty N'abhm_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_legal' )
EXEC sp_addextendedproperty N'abhm_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_paycode_type' )
EXEC sp_addextendedproperty N'abhm_paycode_type', N'权益方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_code' )
EXEC sp_addextendedproperty N'abhm_pay_code', N'权益方代码 来源于tfi_pay_m.paym_pay_code', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_type' )
EXEC sp_addextendedproperty N'abhm_pay_type', N'支付方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_othercode_type' )
EXEC sp_addextendedproperty N'abhm_othercode_type', N'收款方类型 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_othercode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_other_code' )
EXEC sp_addextendedproperty N'abhm_other_code', N'收款方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_other_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_name' )
EXEC sp_addextendedproperty N'abhm_pay_name', N'收款开户名 深圳市瑞恒辉科技有限公司', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_bank' )
EXEC sp_addextendedproperty N'abhm_pay_bank', N'收款开户行 中国建设银行深圳公明支行', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_nbr' )
EXEC sp_addextendedproperty N'abhm_pay_nbr', N'收款账号 44201617800052512853', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_tel' )
EXEC sp_addextendedproperty N'abhm_pay_tel', N'收款联系人电话 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_tel';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_license' )
EXEC sp_addextendedproperty N'abhm_pay_license', N'收款身份证号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_license';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_currency' )
EXEC sp_addextendedproperty N'abhm_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_rate' )
EXEC sp_addextendedproperty N'abhm_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_amt' )
EXEC sp_addextendedproperty N'abhm_amt', N'本次应付 本次付款', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_rec_amt' )
EXEC sp_addextendedproperty N'abhm_rec_amt', N'应收抵扣 本次收款', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_rec_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_amt' )
EXEC sp_addextendedproperty N'abhm_pay_amt', N'支付金额/预付金额 该金额表示最后的“支付金额”，“合计付款”逻辑=最后支付金额+收款方抵扣', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_real_amt' )
EXEC sp_addextendedproperty N'abhm_real_amt', N'已付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_prtn_amt' )
EXEC sp_addextendedproperty N'abhm_prtn_amt', N'预付抵扣金额或收款金额 预付单时使用', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_prtn_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_ivim_type' )
EXEC sp_addextendedproperty N'abhm_ivim_type', N'发票类型 来源于select * from tba_code where code_type=‘ivim_type‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_ivim_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_inv_amt' )
EXEC sp_addextendedproperty N'abhm_inv_amt', N'需收发票金额 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_inv_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_other_amt' )
EXEC sp_addextendedproperty N'abhm_other_amt', N'收款方抵扣 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_other_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_date' )
EXEC sp_addextendedproperty N'abhm_pay_date', N'付款日期/预付日期 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_rmks' )
EXEC sp_addextendedproperty N'abhm_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_status' )
EXEC sp_addextendedproperty N'abhm_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_ref_type' )
EXEC sp_addextendedproperty N'abhm_ref_type', N'关联单据类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_reftype‘，预付单时使用', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_ref_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_ref_id' )
EXEC sp_addextendedproperty N'abhm_ref_id', N'关联单据id 预付单时使用', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_ref_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_rec_date' )
EXEC sp_addextendedproperty N'abhm_rec_date', N'预计收款/抵扣日期 预付单时使用', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_rec_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_audit_rmks' )
EXEC sp_addextendedproperty N'abhm_audit_rmks', N'异常原因 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_audit_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_m') and name = 'abhm_pay_dept' )
EXEC sp_addextendedproperty N'abhm_pay_dept', N'付款部门 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_m', 'COLUMN', N'abhm_pay_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'tfi_billhead_collection' )
 EXEC sp_addextendedproperty N'tfi_billhead_collection', N'付款通知收款方信息表  abhc', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_id' )
EXEC sp_addextendedproperty N'abhc_id', N'收款信息id ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_abhm_id' )
EXEC sp_addextendedproperty N'abhc_abhm_id', N'付款主id 来源于 tfi_billhead_m.abhm_id', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_abhm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_paycode_type' )
EXEC sp_addextendedproperty N'abhc_paycode_type', N'对方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_code' )
EXEC sp_addextendedproperty N'abhc_pay_code', N'对方代码 来源于tfi_pay_m.paym_pay_code', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_type' )
EXEC sp_addextendedproperty N'abhc_pay_type', N'支付方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_name' )
EXEC sp_addextendedproperty N'abhc_pay_name', N'对方开户名 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_bank' )
EXEC sp_addextendedproperty N'abhc_pay_bank', N'对方开户行 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_nbr' )
EXEC sp_addextendedproperty N'abhc_pay_nbr', N'对方账号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_payb_amt' )
EXEC sp_addextendedproperty N'abhc_payb_amt', N'本次付款 用于记录单据提交时的余额', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_payb_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_deduc_amt' )
EXEC sp_addextendedproperty N'abhc_deduc_amt', N'本次抵扣 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_deduc_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_pay_amt' )
EXEC sp_addextendedproperty N'abhc_pay_amt', N'支付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_collection') and name = 'abhc_real_amt' )
EXEC sp_addextendedproperty N'abhc_real_amt', N'已付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_collection', 'COLUMN', N'abhc_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'tfi_billhead_d' )
 EXEC sp_addextendedproperty N'tfi_billhead_d', N'付款通知明细表  abhd', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_id' )
EXEC sp_addextendedproperty N'abhd_id', N'付款明细id ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_abhm_id' )
EXEC sp_addextendedproperty N'abhd_abhm_id', N'付款主id 来源于 tfi_billhead_m.abhm_id', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_abhm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_type' )
EXEC sp_addextendedproperty N'abhd_type', N'明细类型 0：权益方明细；1：收款方明细', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_abhc_id' )
EXEC sp_addextendedproperty N'abhd_abhc_id', N'收款方信息表id 来源于 tfi_billhead_collection.abhc_id;当abhd_type为0时该id也为0', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_abhc_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_bill_type' )
EXEC sp_addextendedproperty N'abhd_bill_type', N'单据类型 参数 1：应付单，2：其他应付单 3：应收单 4：其他应收单', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_bill_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_m_id' )
EXEC sp_addextendedproperty N'abhd_m_id', N'单据id 来源于 tfi_pay_m.paym_id 或者tfi_rec_m.recm_id', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_d_id' )
EXEC sp_addextendedproperty N'abhd_d_id', N'单据明细id 来源于 tfi_pay_d.payd_id 或者tfi_rec_d.recd_id', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_d_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_currency' )
EXEC sp_addextendedproperty N'abhd_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_rate' )
EXEC sp_addextendedproperty N'abhd_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_pay_amt' )
EXEC sp_addextendedproperty N'abhd_pay_amt', N'支付金额 通过abhd_bill_type，1，2，5判断收款还是付款金额', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_rmks' )
EXEC sp_addextendedproperty N'abhd_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_payb_amt' )
EXEC sp_addextendedproperty N'abhd_payb_amt', N'应付余额 用于记录单据提交时的余额', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_payb_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_recb_amt' )
EXEC sp_addextendedproperty N'abhd_recb_amt', N'应收余额 用于记录单据提交时的余额', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_recb_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_real_amt' )
EXEC sp_addextendedproperty N'abhd_real_amt', N'已付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_cntd_id' )
EXEC sp_addextendedproperty N'abhd_cntd_id', N'关联的合同明细id 物资采购对账单关联付款合同时写入', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_cntd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_source_id' )
EXEC sp_addextendedproperty N'abhd_source_id', N'来源单据ID ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_source_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'abhd_source_nbr' )
EXEC sp_addextendedproperty N'abhd_source_nbr', N'来源单据单号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'abhd_source_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_d') and name = 'isenable2' )
EXEC sp_addextendedproperty N'isenable2', N'双经销抵扣标志 销售那边要求加的', 'USER', N'dbo', 'TABLE', N'tfi_billhead_d', 'COLUMN', N'isenable2';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'tfi_billhead_a' )
 EXEC sp_addextendedproperty N'tfi_billhead_a', N' 付款通知审核表', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_billhead_m.abhm_id', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_billhead_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_billhead_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'tfi_inv_bill_r' )
 EXEC sp_addextendedproperty N'tfi_inv_bill_r', N'发票检查表  inbr', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'inbr_id' )
EXEC sp_addextendedproperty N'inbr_id', N'发票抵扣ID ', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r', 'COLUMN', N'inbr_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'inbr_abhm_id' )
EXEC sp_addextendedproperty N'inbr_abhm_id', N'付款主表ID 来源于 tfi_billhead_m.abhm_id', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r', 'COLUMN', N'inbr_abhm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'inbr_ivid_id' )
EXEC sp_addextendedproperty N'inbr_ivid_id', N'发票明细ID 来源于 tfi_ivo_in_d.ivid_id', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r', 'COLUMN', N'inbr_ivid_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'inbr_offset_amt' )
EXEC sp_addextendedproperty N'inbr_offset_amt', N'检查金额 ', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r', 'COLUMN', N'inbr_offset_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inv_bill_r') and name = 'inbr_rmks' )
EXEC sp_addextendedproperty N'inbr_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_inv_bill_r', 'COLUMN', N'inbr_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'tfi_period_m' )
 EXEC sp_addextendedproperty N'tfi_period_m', N'期间设置主表 prdm', 'USER', N'dbo', 'TABLE', N'tfi_period_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_id' )
EXEC sp_addextendedproperty N'prdm_id', N'记录ID ', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_name' )
EXEC sp_addextendedproperty N'prdm_name', N'方案名称 ', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_desc' )
EXEC sp_addextendedproperty N'prdm_desc', N'方案描述 ', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_desc';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_module' )
EXEC sp_addextendedproperty N'prdm_module', N'应用模块 参数，AP:应付，AR:应收，PU:采购，SA:销售select code_code from hsrp.dbo.tba_code where code_type=‘ap_prdm_module‘', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_module';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_code' )
EXEC sp_addextendedproperty N'prdm_code', N'方案对方代码 采购模块时获取供应商代码，销售模块获取客户代码', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_m') and name = 'prdm_seq' )
EXEC sp_addextendedproperty N'prdm_seq', N'优先级 1 为默认', 'USER', N'dbo', 'TABLE', N'tfi_period_m', 'COLUMN', N'prdm_seq';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'tfi_period_d' )
 EXEC sp_addextendedproperty N'tfi_period_d', N'期间设置明细表 prdd', 'USER', N'dbo', 'TABLE', N'tfi_period_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_id' )
EXEC sp_addextendedproperty N'prdd_id', N'记录ID ', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_prdm_id' )
EXEC sp_addextendedproperty N'prdd_prdm_id', N'主表ID 来源于tfi_period_m.prdm_id', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_prdm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_colseq' )
EXEC sp_addextendedproperty N'prdd_colseq', N'列序号 ', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_colseq';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_colname' )
EXEC sp_addextendedproperty N'prdd_colname', N'列名 ', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_colname';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_type' )
EXEC sp_addextendedproperty N'prdd_type', N'类型 0:逾期， 1:未到期', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_unit' )
EXEC sp_addextendedproperty N'prdd_unit', N'区间单位 1:天(1)，2:周(7)， 3:旬(10)， 4:月， 5:季， 6:年select code_code from hsrp.dbo.tba_code where code_type=‘ap_prdd_unit‘', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_unit';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_interval' )
EXEC sp_addextendedproperty N'prdd_interval', N'区间间隔 ', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_interval';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_period_d') and name = 'prdd_enddays' )
EXEC sp_addextendedproperty N'prdd_enddays', N'间隔截止天数 周期内间隔的日期，例如：月份为30天，5，15，20', 'USER', N'dbo', 'TABLE', N'tfi_period_d', 'COLUMN', N'prdd_enddays';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'tfi_execute_m' )
 EXEC sp_addextendedproperty N'tfi_execute_m', N'付款执行表  exem', 'USER', N'dbo', 'TABLE', N'tfi_execute_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_id' )
EXEC sp_addextendedproperty N'exem_id', N'付款主id ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_nbr' )
EXEC sp_addextendedproperty N'exem_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_emp' )
EXEC sp_addextendedproperty N'exem_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_dept' )
EXEC sp_addextendedproperty N'exem_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_duty' )
EXEC sp_addextendedproperty N'exem_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_pemr_code' )
EXEC sp_addextendedproperty N'exem_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_date' )
EXEC sp_addextendedproperty N'exem_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_legal' )
EXEC sp_addextendedproperty N'exem_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_pay_type' )
EXEC sp_addextendedproperty N'exem_pay_type', N'支付方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_acct_id' )
EXEC sp_addextendedproperty N'exem_acct_id', N'我方账户id 来源于tfi_account.acct_id', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_acct_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_pay_amt' )
EXEC sp_addextendedproperty N'exem_pay_amt', N'付款通知余额 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_curr' )
EXEC sp_addextendedproperty N'exem_curr', N'付款执行币别 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_curr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_rate' )
EXEC sp_addextendedproperty N'exem_rate', N'币别汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_amt' )
EXEC sp_addextendedproperty N'exem_amt', N'付款执行金额 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_real_amt' )
EXEC sp_addextendedproperty N'exem_real_amt', N'已付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_pay_date' )
EXEC sp_addextendedproperty N'exem_pay_date', N'付款日期 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_rmks' )
EXEC sp_addextendedproperty N'exem_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_status' )
EXEC sp_addextendedproperty N'exem_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_ref_mid' )
EXEC sp_addextendedproperty N'exem_ref_mid', N'关联单据mid 可以来源付款通知单或预付单tfi_billhead_m', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_ref_mid';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_ref_nbr' )
EXEC sp_addextendedproperty N'exem_ref_nbr', N'关联单号 可以来源付款通知单或预付单tfi_billhead_m', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_ref_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_balance_dept' )
EXEC sp_addextendedproperty N'exem_balance_dept', N'结算中心编码 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_balance_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_balance_deptname' )
EXEC sp_addextendedproperty N'exem_balance_deptname', N'结算中心名称 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_balance_deptname';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_paycode_dept' )
EXEC sp_addextendedproperty N'exem_paycode_dept', N'支付对象部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_paycode_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_paycode_deptname' )
EXEC sp_addextendedproperty N'exem_paycode_deptname', N'支付对象部门名称 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_paycode_deptname';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_approve_date' )
EXEC sp_addextendedproperty N'exem_approve_date', N'单据批准日期 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_approve_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_ispaid' )
EXEC sp_addextendedproperty N'exem_ispaid', N'出纳是否付款 0:出纳未付；1：出纳已付', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_ispaid';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_m') and name = 'exem_pay_dept' )
EXEC sp_addextendedproperty N'exem_pay_dept', N'付款部门 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_m', 'COLUMN', N'exem_pay_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'tfi_execute_a' )
 EXEC sp_addextendedproperty N'tfi_execute_a', N' 付款执行审核表', 'USER', N'dbo', 'TABLE', N'tfi_execute_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_execute_m.exem_id', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_execute_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_execute_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'tfi_incomebill_m' )
 EXEC sp_addextendedproperty N'tfi_incomebill_m', N'收款通知主表  icbm', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_id' )
EXEC sp_addextendedproperty N'icbm_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_type' )
EXEC sp_addextendedproperty N'icbm_type', N'收款类型 1：收款通知，2：预收通知，3:还款单', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_nbr' )
EXEC sp_addextendedproperty N'icbm_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_item' )
EXEC sp_addextendedproperty N'icbm_item', N'会计科目 select code_code，code_name from tba_code where code_type=‘ap_abhm_item‘ and code_code=‘3‘', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_emp' )
EXEC sp_addextendedproperty N'icbm_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_dept' )
EXEC sp_addextendedproperty N'icbm_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_duty' )
EXEC sp_addextendedproperty N'icbm_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_pemr_code' )
EXEC sp_addextendedproperty N'icbm_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_date' )
EXEC sp_addextendedproperty N'icbm_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_legal' )
EXEC sp_addextendedproperty N'icbm_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_reccode_type' )
EXEC sp_addextendedproperty N'icbm_reccode_type', N'对方类型(费用方) 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_reccode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_code' )
EXEC sp_addextendedproperty N'icbm_rec_code', N'对方代码(费用方) 来源于tfi_rec_m.recm_rec_code', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_type' )
EXEC sp_addextendedproperty N'icbm_rec_type', N'收款方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paytype‘', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_currency' )
EXEC sp_addextendedproperty N'icbm_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rate' )
EXEC sp_addextendedproperty N'icbm_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_amt' )
EXEC sp_addextendedproperty N'icbm_amt', N'应收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_pay_amt' )
EXEC sp_addextendedproperty N'icbm_pay_amt', N'应付金额 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_inc_amt' )
EXEC sp_addextendedproperty N'icbm_inc_amt', N'收款金额/预收金额/还款金额 (最后的收款金额)=应收金额-应付金额', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_inc_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_real_amt' )
EXEC sp_addextendedproperty N'icbm_real_amt', N'已收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_prtn_amt' )
EXEC sp_addextendedproperty N'icbm_prtn_amt', N'预收抵扣金额或付款金额 预收单时使用', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_prtn_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_inv_amt' )
EXEC sp_addextendedproperty N'icbm_inv_amt', N'需开发票金额 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_inv_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_date' )
EXEC sp_addextendedproperty N'icbm_rec_date', N'收款日期/预收日期/还款日期 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rmks' )
EXEC sp_addextendedproperty N'icbm_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_status' )
EXEC sp_addextendedproperty N'icbm_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_pay_date' )
EXEC sp_addextendedproperty N'icbm_pay_date', N'预计付款/抵扣日期 预收单时使用', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_glrec_type' )
EXEC sp_addextendedproperty N'icbm_glrec_type', N'收款方类型 1：供应商 2:个人 3：客户；', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_glrec_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_glrec_code' )
EXEC sp_addextendedproperty N'icbm_glrec_code', N'收款方 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_glrec_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_company' )
EXEC sp_addextendedproperty N'icbm_rec_company', N'付款开户名 深圳市瑞恒辉科技有限公司', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_company';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_bank' )
EXEC sp_addextendedproperty N'icbm_rec_bank', N'付款开户行 中国建设银行深圳公明支行', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_acct' )
EXEC sp_addextendedproperty N'icbm_rec_acct', N'付款账号 44201617800052512853', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_acct';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_isreceived ' )
EXEC sp_addextendedproperty N'icbm_isreceived ', N'现金确认收款 0：未收；1：已收。', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_isreceived ';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_acct_id' )
EXEC sp_addextendedproperty N'icbm_acct_id', N'现金收款账户 select acct_id FROM FIDB.dbo.tfi_account', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_acct_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_m') and name = 'icbm_rec_dept' )
EXEC sp_addextendedproperty N'icbm_rec_dept', N'收款部门 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_m', 'COLUMN', N'icbm_rec_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'tfi_incomebill_d' )
 EXEC sp_addextendedproperty N'tfi_incomebill_d', N'收款通知明细表  icbd', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_id' )
EXEC sp_addextendedproperty N'icbd_id', N'收款明细id ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_icbm_id' )
EXEC sp_addextendedproperty N'icbd_icbm_id', N'收款主id 来源于 tfi_incomebill_m.icbm_id', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_icbm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_bill_type' )
EXEC sp_addextendedproperty N'icbd_bill_type', N'单据类型 1:应付单，2:应收单，3:预付单(应收)，4：预收单（应付）', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_bill_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_m_id' )
EXEC sp_addextendedproperty N'icbd_m_id', N'单据id 来源于 tfi_pay_m.paym_id 或者tfi_rec_m.recm_id 或者预付单/预收单', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_d_id' )
EXEC sp_addextendedproperty N'icbd_d_id', N'单据明细id 来源于 tfi_pay_d.payd_id 或者tfi_rec_d.recd_id 或者预付单/预收单', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_d_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_currency' )
EXEC sp_addextendedproperty N'icbd_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_rate' )
EXEC sp_addextendedproperty N'icbd_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_rec_amt' )
EXEC sp_addextendedproperty N'icbd_rec_amt', N'收款金额 （付方：支付金额）', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_rec_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_rmks' )
EXEC sp_addextendedproperty N'icbd_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_payb_amt' )
EXEC sp_addextendedproperty N'icbd_payb_amt', N'应付余额 用于记录单据提交时的余额', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_payb_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_recb_amt' )
EXEC sp_addextendedproperty N'icbd_recb_amt', N'应收余额 用于记录单据提交时的余额', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_recb_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_d') and name = 'icbd_real_amt' )
EXEC sp_addextendedproperty N'icbd_real_amt', N'已收金额 审核通过时回写付方的金额和对应金额给收方，匹配通过时回写收方的金额', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_d', 'COLUMN', N'icbd_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'tfi_incomebill_a' )
 EXEC sp_addextendedproperty N'tfi_incomebill_a', N'收款通知审核表', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_incomebill_m.icbm_id', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_incomebill_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_incomebill_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'tfi_accountcussent_m' )
 EXEC sp_addextendedproperty N'tfi_accountcussent_m', N'往来对账核准主表  ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_id' )
EXEC sp_addextendedproperty N'accm_id', N'核准主id ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_nbr' )
EXEC sp_addextendedproperty N'accm_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_item' )
EXEC sp_addextendedproperty N'accm_item', N'会计科目 select code_code，code_name from tba_code where code_type=‘ap_abhm_item‘ and code_code=‘1‘（正式库都没有值）（改后不用到）(新版20181108之后启用)', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_emp' )
EXEC sp_addextendedproperty N'accm_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_dept' )
EXEC sp_addextendedproperty N'accm_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_duty' )
EXEC sp_addextendedproperty N'accm_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_pemr_code' )
EXEC sp_addextendedproperty N'accm_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_date' )
EXEC sp_addextendedproperty N'accm_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_legal' )
EXEC sp_addextendedproperty N'accm_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_paycode_type' )
EXEC sp_addextendedproperty N'accm_paycode_type', N'对方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_pay_code' )
EXEC sp_addextendedproperty N'accm_pay_code', N'对方代码 来源于tfi_pay_m.paym_pay_code', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_currency' )
EXEC sp_addextendedproperty N'accm_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_rate' )
EXEC sp_addextendedproperty N'accm_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_flag' )
EXEC sp_addextendedproperty N'accm_flag', N'应收/应付标志 1：应付，2：应收（改后不用到）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_bill_amt' )
EXEC sp_addextendedproperty N'accm_bill_amt', N'单据金额 （改后不用到）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_bill_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_approved_amt' )
EXEC sp_addextendedproperty N'accm_approved_amt', N'核准金额 正数：对应paym数据的paym_nbr_flag 4（其他应收）；负数：2（其他应付）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_approved_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_difference_amt' )
EXEC sp_addextendedproperty N'accm_difference_amt', N'差异金额 因程序更改，历史数据可能为负数', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_difference_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_pay_date' )
EXEC sp_addextendedproperty N'accm_pay_date', N'对账日期 保存的就是申请日期', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_type' )
EXEC sp_addextendedproperty N'accm_type', N'单据类型 SELECT code_code， code_name FROM FIDB.dbo.v_fi_tbacode WHERE code_type = ‘accm_type‘(新加)', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_date_end' )
EXEC sp_addextendedproperty N'accm_date_end', N'核准截止日期 (新加)', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_date_end';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_admin_dept' )
EXEC sp_addextendedproperty N'accm_admin_dept', N'应收应付部门 (新加)，推送paym数据的paym_admin_dept字段', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_admin_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_rmks' )
EXEC sp_addextendedproperty N'accm_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_m') and name = 'accm_status' )
EXEC sp_addextendedproperty N'accm_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_m', 'COLUMN', N'accm_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'tfi_accountcussent_d' )
 EXEC sp_addextendedproperty N'tfi_accountcussent_d', N'往来对账核准明细表  ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_id' )
EXEC sp_addextendedproperty N'accd_id', N'核准明细id ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_accm_id' )
EXEC sp_addextendedproperty N'accd_accm_id', N'核准主id 来源于 tfi_billhead_m.abhm_id', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_accm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_bill_type' )
EXEC sp_addextendedproperty N'accd_bill_type', N'单据类型 参数 1：应付单，2：其他应付单 3：应收单 4：其他应收单；5：AR08预收通知单；6：AP08预付通知单（和pay_nbr_flag）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_bill_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_m_id' )
EXEC sp_addextendedproperty N'accd_m_id', N'单据id 来源于 tfi_pay_m.paym_id', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_d_id' )
EXEC sp_addextendedproperty N'accd_d_id', N'单据明细id 备用', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_d_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_currency' )
EXEC sp_addextendedproperty N'accd_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1（改后不用到）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_rate' )
EXEC sp_addextendedproperty N'accd_rate', N'汇率 （改后不用到）', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_flag' )
EXEC sp_addextendedproperty N'accd_flag', N'应收/应付标志 1：应付(accd_bill_type=1，2，5)，2：应收(accd_bill_type=3，4，6)', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_bill_amt' )
EXEC sp_addextendedproperty N'accd_bill_amt', N'单据余额 单据金额：paym_nbr_amt；单据余额：paym_amt-paym_real_amt', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_bill_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_approved_amt' )
EXEC sp_addextendedproperty N'accd_approved_amt', N'核准金额 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_approved_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_difference_amt' )
EXEC sp_addextendedproperty N'accd_difference_amt', N'差异金额 单据类型1，2，5（付）的：差异金额=核准金额-单据金额，单据类型3，4，6（收）的：差异金额=单据金额-核准金额', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_difference_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_d') and name = 'accd_rmks' )
EXEC sp_addextendedproperty N'accd_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_d', 'COLUMN', N'accd_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'tfi_accountcussent_a' )
 EXEC sp_addextendedproperty N'tfi_accountcussent_a', N'往来对账核准审核表', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_accountcussent_m.accm_id', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_attach') and name = 'tfi_accountcussent_attach' )
 EXEC sp_addextendedproperty N'tfi_accountcussent_attach', N'往来对账核准附件表', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_attach';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_attach') and name = 'tact_id' )
EXEC sp_addextendedproperty N'tact_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_attach', 'COLUMN', N'tact_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_attach') and name = 'tact_accm_id' )
EXEC sp_addextendedproperty N'tact_accm_id', N'主表id 来源于 tfi_accountcussent_m.accm_id', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_attach', 'COLUMN', N'tact_accm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_attach') and name = 'tact_file_path' )
EXEC sp_addextendedproperty N'tact_file_path', N'附件路径 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_attach', 'COLUMN', N'tact_file_path';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_accountcussent_attach') and name = 'tact_file_name' )
EXEC sp_addextendedproperty N'tact_file_name', N'附件名称 ', 'USER', N'dbo', 'TABLE', N'tfi_accountcussent_attach', 'COLUMN', N'tact_file_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'tfi_pay_other_m' )
 EXEC sp_addextendedproperty N'tfi_pay_other_m', N'应收/应付表  paym', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_id' )
EXEC sp_addextendedproperty N'paym_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_nbr' )
EXEC sp_addextendedproperty N'paym_nbr', N'其他应收/应付单号 1，3标志为前置单据单号，2为AP06单号，4为AR06单号', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_nbr_flag' )
EXEC sp_addextendedproperty N'paym_nbr_flag', N'单据标志 参数 1：应付单，2：其他应付单 3：应收单 4：其他应收单', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_nbr_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_item' )
EXEC sp_addextendedproperty N'paym_item', N'会计科目 select code_code，code_name from tba_code where code_type=‘ap_abhm_item‘ and code_code=‘1‘ or code_code=‘2‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_typm_id' )
EXEC sp_addextendedproperty N'paym_typm_id', N'类型主id 来源于 tfi_type_m.typm_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_typm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_typd_id' )
EXEC sp_addextendedproperty N'paym_typd_id', N'类型明细id 来源于 tfi_type_d.typd_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_typd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_flag' )
EXEC sp_addextendedproperty N'paym_flag', N'单据标记 参数 1:蓝字，累加；2：红字，累减', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_flag';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_emp' )
EXEC sp_addextendedproperty N'paym_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_dept' )
EXEC sp_addextendedproperty N'paym_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pemr_code' )
EXEC sp_addextendedproperty N'paym_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_duty' )
EXEC sp_addextendedproperty N'paym_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_date' )
EXEC sp_addextendedproperty N'paym_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_due_date' )
EXEC sp_addextendedproperty N'paym_due_date', N'应付日期/应收日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_due_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_paycode_type' )
EXEC sp_addextendedproperty N'paym_paycode_type', N'对方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pay_code' )
EXEC sp_addextendedproperty N'paym_pay_code', N'对方代码 来源于供应商代码，个人工号，其他有业务来往的客户，固定资产供应商等。', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_spl_name' )
EXEC sp_addextendedproperty N'paym_spl_name', N'对方名称 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_spl_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_legal' )
EXEC sp_addextendedproperty N'paym_legal', N'法人单位 来源于法人视图 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_currency' )
EXEC sp_addextendedproperty N'paym_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_rate' )
EXEC sp_addextendedproperty N'paym_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_amt' )
EXEC sp_addextendedproperty N'paym_amt', N'应付金额/应收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_real_amt' )
EXEC sp_addextendedproperty N'paym_real_amt', N'已付金额/已收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pay_type' )
EXEC sp_addextendedproperty N'paym_pay_type', N'支付方式/收款方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paytype‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pay_bank' )
EXEC sp_addextendedproperty N'paym_pay_bank', N'对方开户行 应付使用', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pay_name' )
EXEC sp_addextendedproperty N'paym_pay_name', N'对方开户名 应付使用', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pay_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_pay_nbr' )
EXEC sp_addextendedproperty N'paym_pay_nbr', N'对方账号 应付使用', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_pay_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_admin_type' )
EXEC sp_addextendedproperty N'paym_admin_type', N'第三方类型 1：供应商，2：个人，3：客户，4：部门', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_admin_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_admin_dept' )
EXEC sp_addextendedproperty N'paym_admin_dept', N'第三方代码 采购部分来源于采购的负责人所在的部门，报销来源于报销申请人所在的部门索赔来源于索赔申请人所在部门，销售来源于销售的负责人所在部门', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_admin_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_admin_desc' )
EXEC sp_addextendedproperty N'paym_admin_desc', N'第三方名称 应收为权益方，应付为费用方', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_admin_desc';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_duty_emp' )
EXEC sp_addextendedproperty N'paym_duty_emp', N'责任人 采购部分来源于采购的负责人，报销来源于报销申请人，索赔来源于索赔申请人，销售来源于销售的负责人', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_duty_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_rmks' )
EXEC sp_addextendedproperty N'paym_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_status' )
EXEC sp_addextendedproperty N'paym_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_other_m') and name = 'paym_gl_type' )
EXEC sp_addextendedproperty N'paym_gl_type', N'结算方式 来源于tba：rec_gl_type;ap_gl_type', 'USER', N'dbo', 'TABLE', N'tfi_pay_other_m', 'COLUMN', N'paym_gl_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'tfi_tax_admin_m' )
 EXEC sp_addextendedproperty N'tfi_tax_admin_m', N'缴/退税费主表  ttam', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_id' )
EXEC sp_addextendedproperty N'ttam_id', N'缴/退税费单主id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_type' )
EXEC sp_addextendedproperty N'ttam_type', N'单据类型 1：缴税单，2：退税单', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_nbr' )
EXEC sp_addextendedproperty N'ttam_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_emp' )
EXEC sp_addextendedproperty N'ttam_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_dept' )
EXEC sp_addextendedproperty N'ttam_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_duty' )
EXEC sp_addextendedproperty N'ttam_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_pemr_code' )
EXEC sp_addextendedproperty N'ttam_pemr_code', N'申请岗位code ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_date' )
EXEC sp_addextendedproperty N'ttam_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_legal' )
EXEC sp_addextendedproperty N'ttam_legal', N'缴税法人 SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_bank' )
EXEC sp_addextendedproperty N'ttam_pay_bank', N'付款银行 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_acct_id' )
EXEC sp_addextendedproperty N'ttam_acct_id', N'付款账户 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_acct_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_date' )
EXEC sp_addextendedproperty N'ttam_pay_date', N'缴费日期 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_code' )
EXEC sp_addextendedproperty N'ttam_pay_code', N'征收方 0：地税；1：国税', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_currency' )
EXEC sp_addextendedproperty N'ttam_currency', N'币别 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_rate' )
EXEC sp_addextendedproperty N'ttam_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_tax_amt' )
EXEC sp_addextendedproperty N'ttam_tax_amt', N'缴税金额合计 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_tax_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_late_fee' )
EXEC sp_addextendedproperty N'ttam_late_fee', N'滞纳金合计 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_late_fee';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_penalty' )
EXEC sp_addextendedproperty N'ttam_penalty', N'罚款合计 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_penalty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_begin_date' )
EXEC sp_addextendedproperty N'ttam_begin_date', N'缴费区间(开始) ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_begin_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_end_date' )
EXEC sp_addextendedproperty N'ttam_end_date', N'缴费区间(结束) ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_end_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_rmks' )
EXEC sp_addextendedproperty N'ttam_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_status' )
EXEC sp_addextendedproperty N'ttam_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_type' )
EXEC sp_addextendedproperty N'ttam_ref_type', N'关联单据类型 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_ref_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_id' )
EXEC sp_addextendedproperty N'ttam_ref_id', N'关联单据id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_ref_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_ref_nbr' )
EXEC sp_addextendedproperty N'ttam_ref_nbr', N'关联单据单号 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_ref_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_confirm' )
EXEC sp_addextendedproperty N'ttam_confirm', N'匹配确认金额 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_confirm';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_state' )
EXEC sp_addextendedproperty N'ttam_state', N'银行流水匹配回写状态 更新为：0：未匹配，1：部分匹配，2：已匹配', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_pay_way' )
EXEC sp_addextendedproperty N'ttam_pay_way', N'缴费方式 0/null:扣费；1:自缴. code_type=‘ttam_pay_way‘   新增 by fengxd 2018-08-06', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_pay_way';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee' )
EXEC sp_addextendedproperty N'ttam_payee', N'收款单位 新增 by fengxd 2018-08-07', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_payee';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee_bank' )
EXEC sp_addextendedproperty N'ttam_payee_bank', N'收款单位开户银行 新增 by fengxd 2018-08-07', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_payee_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_m') and name = 'ttam_payee_acct' )
EXEC sp_addextendedproperty N'ttam_payee_acct', N'收款单位开户账号 新增 by fengxd 2018-08-07', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_m', 'COLUMN', N'ttam_payee_acct';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'tfi_tax_admin_d' )
 EXEC sp_addextendedproperty N'tfi_tax_admin_d', N'缴/退税费明细表  ttad', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_id' )
EXEC sp_addextendedproperty N'ttad_id', N'缴/退税费单明细id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_ttam_id' )
EXEC sp_addextendedproperty N'ttad_ttam_id', N'缴/退税费单主id 来源于 tfi_tax_administration_m.ttam_id', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_ttam_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_type' )
EXEC sp_addextendedproperty N'ttad_type', N'税费类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ttad_tax_type‘', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_code' )
EXEC sp_addextendedproperty N'ttad_code', N'应缴税费科目 SELECT sujt_code ，sujt_name FROM FIDB.dbo.v_fi_bill_subject WHERE wfm_code=‘AP16‘', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_rmks' )
EXEC sp_addextendedproperty N'ttad_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_tax_amt' )
EXEC sp_addextendedproperty N'ttad_tax_amt', N'缴税金额 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_tax_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_late_fee' )
EXEC sp_addextendedproperty N'ttad_late_fee', N'滞纳金 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_late_fee';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_d') and name = 'ttad_penalty' )
EXEC sp_addextendedproperty N'ttad_penalty', N'罚款 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_d', 'COLUMN', N'ttad_penalty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'tfi_tax_admin_a' )
 EXEC sp_addextendedproperty N'tfi_tax_admin_a', N'缴/退税费审核表  ttad', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_tax_admin_m.ttam_id', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_attach') and name = 'tfi_tax_admin_attach' )
 EXEC sp_addextendedproperty N'tfi_tax_admin_attach', N'缴/退税费附件表', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_attach';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_id' )
EXEC sp_addextendedproperty N'ttaa_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_attach', 'COLUMN', N'ttaa_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_ttam_id' )
EXEC sp_addextendedproperty N'ttaa_ttam_id', N'主表id 来源于 tfi_tax_admin_m.ttam_id', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_attach', 'COLUMN', N'ttaa_ttam_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_file_path' )
EXEC sp_addextendedproperty N'ttaa_file_path', N'附件路径 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_attach', 'COLUMN', N'ttaa_file_path';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_tax_admin_attach') and name = 'ttaa_file_name' )
EXEC sp_addextendedproperty N'ttaa_file_name', N'附件名称 ', 'USER', N'dbo', 'TABLE', N'tfi_tax_admin_attach', 'COLUMN', N'ttaa_file_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tfi_charge_card' )
 EXEC sp_addextendedproperty N'tfi_charge_card', N'饭卡充值记录表 tchc', 'USER', N'dbo', 'TABLE', N'tfi_charge_card';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_id' )
EXEC sp_addextendedproperty N'tchc_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_RecordID' )
EXEC sp_addextendedproperty N'tchc_RecordID', N'原始表记录id ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_RecordID';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_EmpID' )
EXEC sp_addextendedproperty N'tchc_EmpID', N'原始员工id select empno from [NIMSDB].[dbo].employee where empid=', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_EmpID';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_sceo_emp' )
EXEC sp_addextendedproperty N'tchc_sceo_emp', N'SCEO员工工号 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_sceo_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_RecTime' )
EXEC sp_addextendedproperty N'tchc_RecTime', N'充值时间 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_RecTime';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_RecType' )
EXEC sp_addextendedproperty N'tchc_RecType', N'充值类型 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_RecType';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_BeBalance' )
EXEC sp_addextendedproperty N'tchc_BeBalance', N'充值前金额 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_BeBalance';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_Balance' )
EXEC sp_addextendedproperty N'tchc_Balance', N'充值金额 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_Balance';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_AfBalance' )
EXEC sp_addextendedproperty N'tchc_AfBalance', N'充值后金额 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_AfBalance';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_Remark' )
EXEC sp_addextendedproperty N'tchc_Remark', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_Remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_UserID' )
EXEC sp_addextendedproperty N'tchc_UserID', N'操作人 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_UserID';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_sceo_user' )
EXEC sp_addextendedproperty N'tchc_sceo_user', N'SCEO操作人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_sceo_user';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_LocalPC' )
EXEC sp_addextendedproperty N'tchc_LocalPC', N'操作机器 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_LocalPC';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_DeviceID' )
EXEC sp_addextendedproperty N'tchc_DeviceID', N'操作机器id ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_DeviceID';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_charge_card') and name = 'tchc_icbm_id' )
EXEC sp_addextendedproperty N'tchc_icbm_id', N'对应收款通知单 ', 'USER', N'dbo', 'TABLE', N'tfi_charge_card', 'COLUMN', N'tchc_icbm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'tfi_pay_expenses_m' )
 EXEC sp_addextendedproperty N'tfi_pay_expenses_m', N'费用缴纳单据表  pexm', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_id' )
EXEC sp_addextendedproperty N'pexm_id', N'单据id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_nbr' )
EXEC sp_addextendedproperty N'pexm_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_emp' )
EXEC sp_addextendedproperty N'pexm_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_dept' )
EXEC sp_addextendedproperty N'pexm_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_duty' )
EXEC sp_addextendedproperty N'pexm_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pemr_code' )
EXEC sp_addextendedproperty N'pexm_pemr_code', N'申请岗位code ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_date' )
EXEC sp_addextendedproperty N'pexm_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_dept' )
EXEC sp_addextendedproperty N'pexm_pay_dept', N'缴纳部门 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_pay_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_legal' )
EXEC sp_addextendedproperty N'pexm_legal', N'缴纳法人 来源：SELECT ficn_id， ficn_short_name FROM vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_item' )
EXEC sp_addextendedproperty N'pexm_item', N'缴纳项目 来源：SELECT * FROM HPORTAL.dbo.tba_code tc WHERE tc.code_type=‘pexm_item‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_item';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_sujt_id' )
EXEC sp_addextendedproperty N'pexm_sujt_id', N'费用科目 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_sujt_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_acct' )
EXEC sp_addextendedproperty N'pexm_pay_acct', N'对方账号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_pay_acct';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_currency' )
EXEC sp_addextendedproperty N'pexm_currency', N'币别 来源： select * FROM FIDB.dbo.v_fi_currency fc WHERE fc.curr_flag=1 AND isenable=1', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_rate' )
EXEC sp_addextendedproperty N'pexm_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_amt' )
EXEC sp_addextendedproperty N'pexm_amt', N'缴纳金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_overdue_amt' )
EXEC sp_addextendedproperty N'pexm_overdue_amt', N'滞纳金 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_overdue_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_inv_amt' )
EXEC sp_addextendedproperty N'pexm_inv_amt', N'发票金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_inv_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_date' )
EXEC sp_addextendedproperty N'pexm_pay_date', N'缴纳日期 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_paycode_type' )
EXEC sp_addextendedproperty N'pexm_paycode_type', N'对方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_pay_code' )
EXEC sp_addextendedproperty N'pexm_pay_code', N'对方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_rmks' )
EXEC sp_addextendedproperty N'pexm_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_status' )
EXEC sp_addextendedproperty N'pexm_status', N'审核状态 来源：SELECT * FROM HPORTAL.dbo.tba_code tc WHERE tc.code_type=‘accm_status‘', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_confirm' )
EXEC sp_addextendedproperty N'pexm_confirm', N'匹配确认金额 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_confirm';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_m') and name = 'pexm_atsp_state' )
EXEC sp_addextendedproperty N'pexm_atsp_state', N'银行流水匹配回写状态 更新为：0：未匹配，1：部分匹配，2：已匹配', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_m', 'COLUMN', N'pexm_atsp_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'tfi_expenses_invoice' )
 EXEC sp_addextendedproperty N'tfi_expenses_invoice', N'费用发票表 exin', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_id' )
EXEC sp_addextendedproperty N'exin_id', N'发票ID ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_pexm_id' )
EXEC sp_addextendedproperty N'exin_pexm_id', N'主表ID ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_pexm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_itemcode' )
EXEC sp_addextendedproperty N'exin_itemcode', N'科目编码 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_itemcode';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_name' )
EXEC sp_addextendedproperty N'exin_name', N'开票名称 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_date' )
EXEC sp_addextendedproperty N'exin_date', N'开票日期 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_type' )
EXEC sp_addextendedproperty N'exin_type', N'发票类型 1:专用税票 2：普通税票 SELECT code_code，code_name FROM hsrp.dbo.tba_code WHERE code_type=‘ivim_type‘', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_code' )
EXEC sp_addextendedproperty N'exin_code', N'发票代码 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_number' )
EXEC sp_addextendedproperty N'exin_number', N'发票号码 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_number';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_amt' )
EXEC sp_addextendedproperty N'exin_amt', N'不含税金额 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_nontax_amt' )
EXEC sp_addextendedproperty N'exin_nontax_amt', N'非税金额 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_nontax_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_rate' )
EXEC sp_addextendedproperty N'exin_rate', N'税率 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_tax_amt' )
EXEC sp_addextendedproperty N'exin_tax_amt', N'税额 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_tax_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_tot_amt' )
EXEC sp_addextendedproperty N'exin_tot_amt', N'含税总计 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_tot_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_expenses_invoice') and name = 'exin_remark' )
EXEC sp_addextendedproperty N'exin_remark', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_expenses_invoice', 'COLUMN', N'exin_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'tfi_pay_expenses_a' )
 EXEC sp_addextendedproperty N'tfi_pay_expenses_a', N'费用缴纳审核表  pexa', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_pay_expenses_m.pexm_id', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_pay_expenses_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_pay_expenses_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tfi_capital_investment_m' )
 EXEC sp_addextendedproperty N'tfi_capital_investment_m', N'资产投资申请主表 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_id' )
EXEC sp_addextendedproperty N'tcim_id', N'主id ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_nbr' )
EXEC sp_addextendedproperty N'tcim_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_emp' )
EXEC sp_addextendedproperty N'tcim_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_dept' )
EXEC sp_addextendedproperty N'tcim_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_duty' )
EXEC sp_addextendedproperty N'tcim_duty', N'申请人岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_pemr_code' )
EXEC sp_addextendedproperty N'tcim_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_date' )
EXEC sp_addextendedproperty N'tcim_date', N'申请时间 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_paycode_type' )
EXEC sp_addextendedproperty N'tcim_paycode_type', N'投资方类型 来源于代码表 select * from tba_code where code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_pay_code' )
EXEC sp_addextendedproperty N'tcim_pay_code', N'投资方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_type' )
EXEC sp_addextendedproperty N'tcim_type', N'投资类型 来源于代码表 select * from tba_code where code_type=‘tcim_type‘', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_begin_date' )
EXEC sp_addextendedproperty N'tcim_begin_date', N'投资区间（开始） ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_begin_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_end_date' )
EXEC sp_addextendedproperty N'tcim_end_date', N'投资区间（结束） ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_end_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_curr' )
EXEC sp_addextendedproperty N'tcim_curr', N'币别 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_curr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_cycle' )
EXEC sp_addextendedproperty N'tcim_cycle', N'计息周期 1：天，2：月', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_cycle';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_amt' )
EXEC sp_addextendedproperty N'tcim_amt', N'投资总金额 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_rmks' )
EXEC sp_addextendedproperty N'tcim_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_m') and name = 'tcim_status' )
EXEC sp_addextendedproperty N'tcim_status', N'审核状态 代码表：SELECT code_code， code_name FROM tba_code WHERE code_type = ‘account_status‘', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_m', 'COLUMN', N'tcim_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tfi_capital_investment_d' )
 EXEC sp_addextendedproperty N'tfi_capital_investment_d', N'资产投资申请明细表 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_id' )
EXEC sp_addextendedproperty N'tcid_id', N'明细id ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_tcim_id' )
EXEC sp_addextendedproperty N'tcid_tcim_id', N'主表id 来源于tfi_capital_investment_m.tcim_id', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_tcim_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_dept' )
EXEC sp_addextendedproperty N'tcid_dept', N'投资部门 内部投资时取值', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_legal' )
EXEC sp_addextendedproperty N'tcid_legal', N'投资法人 外部投资时取值', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_rate' )
EXEC sp_addextendedproperty N'tcid_rate', N'年利率 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_amt' )
EXEC sp_addextendedproperty N'tcid_amt', N'投资金额 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_all' )
EXEC sp_addextendedproperty N'tcid_interest_all', N'累计利息 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_all';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money01' )
EXEC sp_addextendedproperty N'tcid_interest_money01', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money01';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money02' )
EXEC sp_addextendedproperty N'tcid_interest_money02', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money02';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money03' )
EXEC sp_addextendedproperty N'tcid_interest_money03', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money03';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money04' )
EXEC sp_addextendedproperty N'tcid_interest_money04', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money04';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money05' )
EXEC sp_addextendedproperty N'tcid_interest_money05', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money05';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money06' )
EXEC sp_addextendedproperty N'tcid_interest_money06', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money06';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money07' )
EXEC sp_addextendedproperty N'tcid_interest_money07', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money07';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money08' )
EXEC sp_addextendedproperty N'tcid_interest_money08', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money08';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money09' )
EXEC sp_addextendedproperty N'tcid_interest_money09', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money09';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money10' )
EXEC sp_addextendedproperty N'tcid_interest_money10', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money10';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money11' )
EXEC sp_addextendedproperty N'tcid_interest_money11', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money11';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_interest_money12' )
EXEC sp_addextendedproperty N'tcid_interest_money12', N'每月累计周期利息 2018/02/03增加', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_interest_money12';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_d') and name = 'tcid_rmks' )
EXEC sp_addextendedproperty N'tcid_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_d', 'COLUMN', N'tcid_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'tfi_capital_investment_a' )
 EXEC sp_addextendedproperty N'tfi_capital_investment_a', N'资产投资申请申请审核表 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于tfi_capital_investment_m.tcim_id', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_capital_investment_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_capital_investment_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'tfi_ap_log' )
 EXEC sp_addextendedproperty N'tfi_ap_log', N'记录错误信息  aplg', 'USER', N'dbo', 'TABLE', N'tfi_ap_log';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_id' )
EXEC sp_addextendedproperty N'aplg_id', N'记录id ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_code' )
EXEC sp_addextendedproperty N'aplg_code', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_m' )
EXEC sp_addextendedproperty N'aplg_m', N'涉及的主表 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_d' )
EXEC sp_addextendedproperty N'aplg_d', N'明细表 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_a' )
EXEC sp_addextendedproperty N'aplg_a', N'审核表 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_amt' )
EXEC sp_addextendedproperty N'aplg_amt', N'金额 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_ramt' )
EXEC sp_addextendedproperty N'aplg_ramt', N'抵扣金额 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_ramt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_real_amt' )
EXEC sp_addextendedproperty N'aplg_real_amt', N'回写金额 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_ap_log') and name = 'aplg_rmks' )
EXEC sp_addextendedproperty N'aplg_rmks', N'记录信息 ', 'USER', N'dbo', 'TABLE', N'tfi_ap_log', 'COLUMN', N'aplg_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'tfi_inner_account_m' )
 EXEC sp_addextendedproperty N'tfi_inner_account_m', N'内部法人对账单主表  inam', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_id' )
EXEC sp_addextendedproperty N'inam_id', N'对账单主id ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_type' )
EXEC sp_addextendedproperty N'inam_type', N'对账单类型 0:应付对账单；1：应收对账单', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_nbr' )
EXEC sp_addextendedproperty N'inam_nbr', N'对账单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_emp' )
EXEC sp_addextendedproperty N'inam_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_dept' )
EXEC sp_addextendedproperty N'inam_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_duty' )
EXEC sp_addextendedproperty N'inam_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_pemr_code' )
EXEC sp_addextendedproperty N'inam_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_date' )
EXEC sp_addextendedproperty N'inam_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_acct_sdate' )
EXEC sp_addextendedproperty N'inam_acct_sdate', N'对账开始日期 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_acct_sdate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_acct_edate' )
EXEC sp_addextendedproperty N'inam_acct_edate', N'对账结束日期 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_acct_edate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_paycode_type' )
EXEC sp_addextendedproperty N'inam_paycode_type', N'付款方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘增加类型：101 内部法人交易', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_paycode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_pay_code' )
EXEC sp_addextendedproperty N'inam_pay_code', N'付款方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_pay_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_pay_acct_id' )
EXEC sp_addextendedproperty N'inam_pay_acct_id', N'付款账号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_pay_acct_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_pay_type' )
EXEC sp_addextendedproperty N'inam_pay_type', N'支付方式 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_othercode_type' )
EXEC sp_addextendedproperty N'inam_othercode_type', N'收款方类型 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_paycodetype‘增加类型：101 内部法人交易', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_othercode_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_other_code' )
EXEC sp_addextendedproperty N'inam_other_code', N'收款方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_other_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_other_acct_id' )
EXEC sp_addextendedproperty N'inam_other_acct_id', N'收款账号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_other_acct_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_currency' )
EXEC sp_addextendedproperty N'inam_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_rate' )
EXEC sp_addextendedproperty N'inam_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_amt' )
EXEC sp_addextendedproperty N'inam_amt', N'本次应付/应收 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_pay_date' )
EXEC sp_addextendedproperty N'inam_pay_date', N'付款/收款日期 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_rmks' )
EXEC sp_addextendedproperty N'inam_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_status' )
EXEC sp_addextendedproperty N'inam_status', N'审核状态 来源于代码表 select code_code，code_name from tba_code where code_type=‘ap_audit_status‘', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_m') and name = 'inam_ref_id' )
EXEC sp_addextendedproperty N'inam_ref_id', N'关联单据id 付款对账单与收款对账单相互记录', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_m', 'COLUMN', N'inam_ref_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'tfi_inner_account_d' )
 EXEC sp_addextendedproperty N'tfi_inner_account_d', N'内部法人对账单明细表  inad', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_id' )
EXEC sp_addextendedproperty N'inad_id', N'付款明细id ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_inam_id' )
EXEC sp_addextendedproperty N'inad_inam_id', N'付款主id 来源于 tfi_inner_account_m_m.inam_id', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_inam_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_bill_type' )
EXEC sp_addextendedproperty N'inad_bill_type', N'单据类型 参数 1：应付单，2：其他应付单 3：应收单 4：其他应收单', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_bill_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_paym_id' )
EXEC sp_addextendedproperty N'inad_paym_id', N'单据id 来源于 tfi_pay_m.paym_id', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_paym_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_currency' )
EXEC sp_addextendedproperty N'inad_currency', N'币别 来源于币别表 select curr_code，curr_code from tba_currency where isenable = 1', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_rate' )
EXEC sp_addextendedproperty N'inad_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_pay_amt' )
EXEC sp_addextendedproperty N'inad_pay_amt', N'付款金额/收款金额 通过inad_bill_type，1，2，5判断收款还是付款金额', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_rmks' )
EXEC sp_addextendedproperty N'inad_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_real_amt' )
EXEC sp_addextendedproperty N'inad_real_amt', N'已付金额/已收金额 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_real_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_source_id' )
EXEC sp_addextendedproperty N'inad_source_id', N'来源单据ID ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_source_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_d') and name = 'inad_source_nbr' )
EXEC sp_addextendedproperty N'inad_source_nbr', N'来源单据单号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_d', 'COLUMN', N'inad_source_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'tfi_inner_account_a' )
 EXEC sp_addextendedproperty N'tfi_inner_account_a', N' 内部法人对账单审核表', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id 来源于 tfi_inner_account_m.inam_id', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_inner_account_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_inner_account_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'tfi_refound_m' )
 EXEC sp_addextendedproperty N'tfi_refound_m', N'客户退款单主表  rfdm', 'USER', N'dbo', 'TABLE', N'tfi_refound_m';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_id' )
EXEC sp_addextendedproperty N'rfdm_id', N'主id ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_nbr' )
EXEC sp_addextendedproperty N'rfdm_nbr', N'单号 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_emp' )
EXEC sp_addextendedproperty N'rfdm_emp', N'申请人 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_emp';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_dept' )
EXEC sp_addextendedproperty N'rfdm_dept', N'申请部门 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_duty' )
EXEC sp_addextendedproperty N'rfdm_duty', N'申请岗位 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_duty';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pemr_code' )
EXEC sp_addextendedproperty N'rfdm_pemr_code', N'岗位安排code ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pemr_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_date' )
EXEC sp_addextendedproperty N'rfdm_date', N'申请日期 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_rmks' )
EXEC sp_addextendedproperty N'rfdm_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_dept' )
EXEC sp_addextendedproperty N'rfdm_pay_dept', N'退款部门 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_dept';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_legal' )
EXEC sp_addextendedproperty N'rfdm_pay_legal', N'退款法人 来源于法人视图 SELECT * FROM fidb.dbo.vfi_corporation', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_legal';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_date' )
EXEC sp_addextendedproperty N'rfdm_pay_date', N'退款日期 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_date';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_amt' )
EXEC sp_addextendedproperty N'rfdm_pay_amt', N'退款金额 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_currency' )
EXEC sp_addextendedproperty N'rfdm_currency', N'币别 来源于币别表 select * from hportal.dbo.tba_currency where curr_flag = 1', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_currency';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_rate' )
EXEC sp_addextendedproperty N'rfdm_rate', N'汇率 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_rate';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_code_type' )
EXEC sp_addextendedproperty N'rfdm_code_type', N'收款方类型 只用客户3；   来源select* from hportal.dbo.tba_code tc WHERE   code_type=‘ap_paycodetype‘', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_code_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_code' )
EXEC sp_addextendedproperty N'rfdm_code', N'收款方代码 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_code';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_type' )
EXEC sp_addextendedproperty N'rfdm_pay_type', N'支付方式 只用到1现金，2 转账;     select code_code，code_name from tba_code where code_type=‘ap_pay_type‘', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_type';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_nbr' )
EXEC sp_addextendedproperty N'rfdm_pay_nbr', N'收款账号 44201617800052512853', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_name' )
EXEC sp_addextendedproperty N'rfdm_pay_name', N'收款开户名 深圳市瑞恒辉科技有限公司', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_name';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_pay_bank' )
EXEC sp_addextendedproperty N'rfdm_pay_bank', N'收款开户行 中国建设银行深圳公明支行', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_pay_bank';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_m') and name = 'rfdm_status' )
EXEC sp_addextendedproperty N'rfdm_status', N'审核状态 select* from hportal.dbo.tba_code tc WHERE   code_type=‘account_status‘', 'USER', N'dbo', 'TABLE', N'tfi_refound_m', 'COLUMN', N'rfdm_status';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'tfi_refound_d' )
 EXEC sp_addextendedproperty N'tfi_refound_d', N'客户退款单明细表  rfdd', 'USER', N'dbo', 'TABLE', N'tfi_refound_d';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'rfdd_id' )
EXEC sp_addextendedproperty N'rfdd_id', N'退款单明细id ', 'USER', N'dbo', 'TABLE', N'tfi_refound_d', 'COLUMN', N'rfdd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'rfdd_rfdm_id' )
EXEC sp_addextendedproperty N'rfdd_rfdm_id', N'主表记录id ', 'USER', N'dbo', 'TABLE', N'tfi_refound_d', 'COLUMN', N'rfdd_rfdm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'rfdd_actx_id' )
EXEC sp_addextendedproperty N'rfdd_actx_id', N'银行流水id select * from fidb.dbo.tfi_account_tx', 'USER', N'dbo', 'TABLE', N'tfi_refound_d', 'COLUMN', N'rfdd_actx_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'rfdd_amt' )
EXEC sp_addextendedproperty N'rfdd_amt', N'退款金额 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_d', 'COLUMN', N'rfdd_amt';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_d') and name = 'rfdd_rmks' )
EXEC sp_addextendedproperty N'rfdd_rmks', N'备注 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_d', 'COLUMN', N'rfdd_rmks';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'tfi_refound_a' )
 EXEC sp_addextendedproperty N'tfi_refound_a', N'客户退款单审核表  rfda', 'USER', N'dbo', 'TABLE', N'tfi_refound_a';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_wfm_id' )
EXEC sp_addextendedproperty N'wfna_wfm_id', N'流程id ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_wfm_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_wfnd_id' )
EXEC sp_addextendedproperty N'wfna_wfnd_id', N'节点id ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_wfnd_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_emp_id' )
EXEC sp_addextendedproperty N'wfna_emp_id', N'待审人工号 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_emp_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_m_id' )
EXEC sp_addextendedproperty N'wfna_m_id', N'表单id select rfdm_id， * from fidb.dbo.tfi_refound_m', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_m_id';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_m_state' )
EXEC sp_addextendedproperty N'wfna_m_state', N'表单状态 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_m_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_m_remark' )
EXEC sp_addextendedproperty N'wfna_m_remark', N'审核备注 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_m_remark';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_state' )
EXEC sp_addextendedproperty N'wfna_state', N'审核人状态 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_node_state' )
EXEC sp_addextendedproperty N'wfna_node_state', N'审核节点状态 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_node_state';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_wf_route' )
EXEC sp_addextendedproperty N'wfna_wf_route', N'审核路径 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_wf_route';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_nbr' )
EXEC sp_addextendedproperty N'wfna_nbr', N'表单单号 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_nbr';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_summary' )
EXEC sp_addextendedproperty N'wfna_summary', N'摘要 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_summary';
end try
begin catch
end catch
GO
begin try
if not exists (select * from sys.extended_properties where class = 1 and major_id = object_id('tfi_refound_a') and name = 'wfna_cc_code' )
EXEC sp_addextendedproperty N'wfna_cc_code', N'审核人当前角色所在的部门编码 ', 'USER', N'dbo', 'TABLE', N'tfi_refound_a', 'COLUMN', N'wfna_cc_code';
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(typm_id),-1) FROM dbo.tfi_type_m WHERE typm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_type_m on ;
INSERT INTO tfi_type_m(typm_id,typm_code,typm_name,typm_attribute,typm_desc,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'','',0,'',0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_type_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(paym_id),-1) FROM dbo.tfi_pay_other_m WHERE paym_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_pay_other_m on ;
INSERT INTO tfi_pay_other_m(paym_id,paym_nbr,paym_nbr_flag,paym_item,paym_typm_id,paym_typd_id,paym_flag,paym_emp,paym_dept,paym_pemr_code,paym_duty,paym_date,paym_due_date,paym_paycode_type,paym_pay_code,paym_spl_name,paym_legal,paym_currency,paym_rate,paym_amt,paym_real_amt,paym_pay_type,paym_pay_bank,paym_pay_name,paym_pay_nbr,paym_admin_type,paym_admin_dept,paym_admin_desc,paym_duty_emp,paym_rmks,paym_status,paym_gl_type,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'',0,'',0,0,0,'','','',0,getdate(),getdate(),0,'','',0,'',0,0,0,0,'','','',0,'','','','',0,0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_pay_other_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(abhm_id),-1) FROM dbo.tfi_billhead_m WHERE abhm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_billhead_m on ;
INSERT INTO tfi_billhead_m(abhm_id,abhm_type,abhm_nbr,abhm_item,abhm_emp,abhm_dept,abhm_duty,abhm_pemr_code,abhm_date,abhm_legal,abhm_paycode_type,abhm_pay_code,abhm_pay_type,abhm_othercode_type,abhm_other_code,abhm_pay_name,abhm_pay_bank,abhm_pay_nbr,abhm_pay_tel,abhm_pay_license,abhm_currency,abhm_rate,abhm_amt,abhm_rec_amt,abhm_pay_amt,abhm_real_amt,abhm_prtn_amt,abhm_ivim_type,abhm_inv_amt,abhm_other_amt,abhm_pay_date,abhm_rmks,abhm_status,abhm_ref_type,abhm_ref_id,abhm_rec_date,abhm_audit_rmks,abhm_pay_dept,isenable ,addtime,adduser,modtime,modtime2,moduser,acctid)
values(0,0,'','','','',0,'',getdate(),0,0,'',0,0,'','','','','','','',0,0,0,0,0,0,0,0,0,getdate(),'',0,0,0,getdate(),'','',0,getdate(),'',getdate(),getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_billhead_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(prdm_id),-1) FROM dbo.tfi_period_m WHERE prdm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_period_m on ;
INSERT INTO tfi_period_m(prdm_id,prdm_name,prdm_desc,prdm_module,prdm_code,prdm_seq,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'','','','',0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_period_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(exem_id),-1) FROM dbo.tfi_execute_m WHERE exem_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_execute_m on ;
INSERT INTO tfi_execute_m(exem_id,exem_nbr,exem_emp,exem_dept,exem_duty,exem_pemr_code,exem_date,exem_legal,exem_pay_type,exem_acct_id,exem_pay_amt,exem_curr,exem_rate,exem_amt,exem_real_amt,exem_pay_date,exem_rmks,exem_status,exem_ref_mid,exem_ref_nbr,exem_balance_dept,exem_balance_deptname,exem_paycode_dept,exem_paycode_deptname,exem_approve_date,exem_ispaid,exem_pay_dept,isenable ,addtime,adduser,modtime,modtime2,moduser,acctid)
values(0,'','','',0,'',getdate(),0,0,0,0,'',0,0,0,getdate(),'',0,0,'','','','','',getdate(),0,'',0,getdate(),'',getdate(),getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_execute_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(icbm_id),-1) FROM dbo.tfi_incomebill_m WHERE icbm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_incomebill_m on ;
INSERT INTO tfi_incomebill_m(icbm_id,icbm_type,icbm_nbr,icbm_item,icbm_emp,icbm_dept,icbm_duty,icbm_pemr_code,icbm_date,icbm_legal,icbm_reccode_type,icbm_rec_code,icbm_rec_type,icbm_currency,icbm_rate,icbm_amt,icbm_pay_amt,icbm_inc_amt,icbm_real_amt,icbm_prtn_amt,icbm_inv_amt,icbm_rec_date,icbm_rmks,icbm_status,icbm_pay_date,icbm_glrec_type,icbm_glrec_code,icbm_rec_company,icbm_rec_bank,icbm_rec_acct,icbm_isreceived ,icbm_acct_id,icbm_rec_dept,isenable ,addtime,adduser,modtime,modtime2,moduser,acctid)
values(0,0,'','','','',0,'',getdate(),0,0,'',0,'',0,0,0,0,0,0,0,getdate(),'',0,getdate(),0,'','','','',0,0,'',0,getdate(),'',getdate(),getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_incomebill_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(accm_id),-1) FROM dbo.tfi_accountcussent_m WHERE accm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_accountcussent_m on ;
INSERT INTO tfi_accountcussent_m(accm_id,accm_nbr,accm_item,accm_emp,accm_dept,accm_duty,accm_pemr_code,accm_date,accm_legal,accm_paycode_type,accm_pay_code,accm_currency,accm_rate,accm_flag,accm_bill_amt,accm_approved_amt,accm_difference_amt,accm_pay_date,accm_type,accm_date_end,accm_admin_dept,accm_rmks,accm_status,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'','','','',0,'',getdate(),0,0,'','',0,0,0,0,0,getdate(),0,getdate(),'','',0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_accountcussent_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(ttam_id),-1) FROM dbo.tfi_tax_admin_m WHERE ttam_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_tax_admin_m on ;
INSERT INTO tfi_tax_admin_m(ttam_id,ttam_type,ttam_nbr,ttam_emp,ttam_dept,ttam_duty,ttam_pemr_code,ttam_date,ttam_legal,ttam_pay_bank,ttam_acct_id,ttam_pay_date,ttam_pay_code,ttam_currency,ttam_rate,ttam_tax_amt,ttam_late_fee,ttam_penalty,ttam_begin_date,ttam_end_date,ttam_rmks,ttam_status,ttam_ref_type,ttam_ref_id,ttam_ref_nbr,ttam_confirm,ttam_state,ttam_pay_way,ttam_payee,ttam_payee_bank,ttam_payee_acct,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,0,'','','',0,'',getdate(),0,0,0,getdate(),0,'',0,0,0,0,getdate(),getdate(),'',0,0,0,'',0,0,0,'','','',0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_tax_admin_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(pexm_id),-1) FROM dbo.tfi_pay_expenses_m WHERE pexm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_pay_expenses_m on ;
INSERT INTO tfi_pay_expenses_m(pexm_id,pexm_nbr,pexm_emp,pexm_dept,pexm_duty,pexm_pemr_code,pexm_date,pexm_pay_dept,pexm_legal,pexm_item,pexm_sujt_id,pexm_pay_acct,pexm_currency,pexm_rate,pexm_amt,pexm_overdue_amt,pexm_inv_amt,pexm_pay_date,pexm_paycode_type,pexm_pay_code,pexm_rmks,pexm_status,pexm_confirm,pexm_atsp_state,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'','','',0,'',getdate(),'',0,'','',0,'',0,0,0,0,getdate(),0,'','',0,0,0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_pay_expenses_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(tcim_id),-1) FROM dbo.tfi_capital_investment_m WHERE tcim_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_capital_investment_m on ;
INSERT INTO tfi_capital_investment_m(tcim_id,tcim_nbr,tcim_emp,tcim_dept,tcim_duty,tcim_pemr_code,tcim_date,tcim_paycode_type,tcim_pay_code,tcim_type,tcim_begin_date,tcim_end_date,tcim_curr,tcim_cycle,tcim_amt,tcim_rmks,tcim_status,isenable,addtime,adduser,modtime,moduser,acctid)
values(0,'','','',0,'',getdate(),0,'',0,getdate(),getdate(),'','',0,'',0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_capital_investment_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(inam_id),-1) FROM dbo.tfi_inner_account_m WHERE inam_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_inner_account_m on ;
INSERT INTO tfi_inner_account_m(inam_id,inam_type,inam_nbr,inam_emp,inam_dept,inam_duty,inam_pemr_code,inam_date,inam_acct_sdate,inam_acct_edate,inam_paycode_type,inam_pay_code,inam_pay_acct_id,inam_pay_type,inam_othercode_type,inam_other_code,inam_other_acct_id,inam_currency,inam_rate,inam_amt,inam_pay_date,inam_rmks,inam_status,inam_ref_id,isenable ,addtime,adduser,modtime,modtime2,moduser,acctid)
values(0,0,'','','',0,'',getdate(),getdate(),getdate(),0,'',0,0,0,'',0,'',0,0,getdate(),'',0,0,0,getdate(),'',getdate(),getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_inner_account_m off;
end
end try
begin catch
end catch
GO
begin try
IF (SELECT isnull(min(rfdm_id),-1) FROM dbo.tfi_refound_m WHERE rfdm_id=0)=-1 
begin 
SET IDENTITY_INSERT dbo.tfi_refound_m on ;
INSERT INTO tfi_refound_m(rfdm_id,rfdm_nbr,rfdm_emp,rfdm_dept,rfdm_duty,rfdm_pemr_code,rfdm_date,rfdm_rmks,rfdm_pay_dept,rfdm_pay_legal,rfdm_pay_date,rfdm_pay_amt,rfdm_currency,rfdm_rate,rfdm_code_type,rfdm_code,rfdm_pay_type,rfdm_pay_nbr,rfdm_pay_name,rfdm_pay_bank,rfdm_status,isenable ,addtime,adduser,modtime,moduser,acctid)
values(0,'','','',0,'',getdate(),'','',0,getdate(),0,'',0,0,'',0,'','','',0,0,getdate(),'',getdate(),'',0);
SET IDENTITY_INSERT dbo.tfi_refound_m off;
end
end try
begin catch
end catch
GO

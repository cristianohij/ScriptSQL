select top 1 * from P43000.DADOSAP5.dbo.SA1010

begin transaction
insert into TBS002 (CLICOD,CLINOM,UFESIG,CLIEMPCOD)
select cast(A1_COD as numeric),A1_NOME,A1_EST,'' from P43000.DADOSAP5.dbo.SA1010 where D_E_L_E_T_=''

commit transaction

select * from TBS002
delete from TBS002
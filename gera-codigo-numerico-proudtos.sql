select PROCOD from TBS010 (nolock) where PROCODNUM > 0 

begin tran
update TBS010 set PROCODNUM = 0
commit tran

-- controle do sequêncial
select * from TBS025 (nolock) where PARCHV=1215

-- tabela temporária com as sequências
drop table #PROSEQ

select PROCOD,PROCODNUM,row_number() over(order by PROCOD)+99999999 as SEQ
  into #PROSEQ
  from TBS010 nolock
 order by PROCOD

select * from #PROSEQ

-- atualização das sequências dos produtos

update TBS010 set PROCODNUM=SEQ
 from TBS010 right join #PROSEQ on #PROSEQ.PROCOD=TBS010.PROCOD

select PROCOD,PRODES,PROCODBAR1,PROCODBAR2,PROCODNUM
  from TBS010 nolock
 where PROCODNUM > 0
 order by PROCODNUM


-- ativação do parâmetro para gerar sequência automática no cadastro do produto
select * from TBS025 (nolock) where PARCHV=1214

begin tran
update TBS025 set PARVAL='N' where PARCHV=1214
commit tran

-- controle do sequêncial
select * from TBS025 (nolock) where PARCHV=1215

begin tran
update TBS025 set PARVAL=(select max() where PARCHV=1215
commit tran

select PROCOD,case when Len(PROCOD)=7 then '99'+Ltrim(PROCOD) else '9'+Ltrim(PROCOD) end from TBS010 (nolock) where MARCOD in(164,1640)
 
select PROCOD,MARCOD from TBS010 (nolock) where PROCOD='16400001'

select PROCOD,PRODES from TBS010 (nolock) where Len(PROCOD) > 8

select * into ProdutosEliminados2 from TBS010 (nolock) where Len(PROCOD) > 8

select * from ProdutosEliminados2 (nolock)

begin tran
delete TBS010 where Len(PROCOD) > 8
commit tran

-- acrescentando noves no inicio do código do produto

select count(*) from TBS010 (nolock) where PROCODEMPORIUM=0

begin tran
update TBS010 set PROCODEMPORIUM = case when Len(PROCOD)=7 then '99'+Ltrim(PROCOD) else '9'+Ltrim(PROCOD) end where PROCODEMPORIUM=0 --and MARCOD=1536
commit tran
rollback tran

select PROCOD,PROCODEMPORIUM from TBS010 (nolock) where MARCOD in(164,1640)

select PROCODEMPORIUM,count(*) from TBS010 (nolock)
 group by PROCODEMPORIUM
having count(*) > 1

select PROCOD,PROCODEMPORIUM from TBS010 (nolock) where PROCODEMPORIUM=999980002


-- correções tabelas

select * from TBS012 (nolock)

begin tran
delete TBS012 where GRUCOD=0
commit tran

select * from TBS011 (nolock)

begin tran
update TBS011 set UNIDES='SUB CAIXA' where UNICOD='SX'

select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4 from TBS010 (nolock)
 where PROUM1 in(' 1','0','X','N','82') or
       PROUM2 in(' 1','0','X','N','82') or
       PROUM3 in(' 1','0','X','N','82') or
       PROUM4 in(' 1','0','X','N','82')

select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4 from TBS010 (nolock)
 where PROUM1 in('''','-','--','00','10','24','5','6','=','G','N','PR','SX','X','cx','pt') or
       PROUM2 in('''','-','--','00','10','24','5','6','=','G','N','PR','SX','X','cx','pt') or
       PROUM3 in('''','-','--','00','10','24','5','6','=','G','N','PR','SX','X','cx','pt') or
       PROUM4 in('''','-','--','00','10','24','5','6','=','G','N','PR','SX','X','cx','pt')


select * from TBS011 (nolock) where UNICOD in(' 1','0','X','N','82')

begin tran
delete TBS011 where UNICOD in(' 1','0','X','N','82')
rollback tran
commit tran

begin tran
delete TBS011 where UNICOD in('''','-','--','00','10','24','5','6','=','G','N','PR','SX','X','cx','pt')
rollback tran
commit tran


select PROCOD,PROUM1,PROUM2,PROUM3,PROUM4 from TBS010 (nolock) where PROUM1='PR' or PROUM2 = 'PR' or PROUM3 = 'PR' or PROUM4 = 'PR'

select * from TBS010 (nolock) where MARCOD=1890

select PROCSN,count(*) from TBS010 (nolock) group by PROCSN

begin tran
update TBS010 set PROCSN='102' where PROCSN='101'
commit tran

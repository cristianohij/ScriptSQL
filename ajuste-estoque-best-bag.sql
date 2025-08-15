-- p1

-- elimina a tabela
drop table ESTOQUE

-- cria tabela de entradas/saídas e saldos do estoque
create table ESTOQUE (
   produto char(15) default '',
   unidade char(2) default '',
   miEntrada money default 0,
   miSaida money default 0,
   ecfEntrada money default 0,
   ecfSaida money default 0
)


-- p2

-- insere os produtos com movimentos internos na tabela ESTOQUE
insert into ESTOQUE
select PROCOD,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0371.PROCOD),
       0,
       0,
       0,
       0
  from TBS0371 (nolock)
 group by PROCOD


select * from TBS037 (nolock) where MVIDATLAN < '20150118 00:00'
select * from TBS0371 (nolock)

-- zera as entradas
update ESTOQUE set miEntrada=0

-- entradas via movimentos internos:

-- p3

--    tipo de movimentação = 1 e 501 (entrada via transferência)
--    estoque de destino = 2
update ESTOQUE set miEntrada=isnull((select sum(MVIQTDATD*MVIQTDEMB)
                                       from TBS0371 (nolock) left join TBS037 (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
                                      where TMVCOD in(1,501) and MVILOCDES=2 and PROCOD=produto
                                      group by PROCOD),0)

select * from TBS037 (nolock) where TMVCOD=501



-- zera as saídas
update ESTOQUE set miSaida=0

-- saídas via movimentos internos:

-- p4

--    tipo de movimentação = 500 e 501 (saída via transferência)
--    estoque de origem = 2
update ESTOQUE set miSaida=isnull((select sum(MVIQTDATD*MVIQTDEMB)
                                     from TBS0371 (nolock) left join TBS037 (nolock) on TBS037.MVIEMPCOD=TBS0371.MVIEMPCOD and TBS037.MVIDOC=TBS0371.MVIDOC
                                    where TMVCOD in(500,501) and MVILOCORI=2 and PROCOD=produto
                                    group by PROCOD),0)


select *,miEntrada-miSaida from ESTOQUE (nolock) where miEntrada-miSaida < 0 order by produto
 
select sum(MVIQTD*MVIQTDEMB) from TBS0371 (nolock) where 

select distinct NFSDEV from TBS067 (nolock)


-- p5

-- adiciona os atributos para contabilizar entradas/saídas via nf
alter table ESTOQUE add nfSaida money default 0 with values
go
alter table ESTOQUE add nfEntrada money default 0 with values
go


-- nf de saídas
select * from TBS0671 (nolock) left join TBS067 (nolock) on TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
 where NFSCAN='N' and NFSDEV='N' and NFSDATEMI >= '20150117' and LESCOD=2 and NFSMOVEST='S'

-- seleciona produtos da tabela de NF de saídas para incluir na tabela ESTOQUE

-- p6

select PROCOD,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'PROUM1'
  into #TMP
  from TBS0671 (nolock) left join TBS067 (nolock) on TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
 where NFSCAN='N' and NFSDEV='N' and NFSDATEMI >= '20150117' and LESCOD=2 and NFSMOVEST='S'
 group by PROCOD

-- p7

-- elimina registro que já existem na tabela ESTOQUE

delete #TMP from ESTOQUE where produto=PROCOD

select * from #TMP

-- p8

-- insere registro da tabela de NF de saídas na tabela ESTOQUE
insert into ESTOQUE select PROCOD,PROUM1,0,0,0,0,0,0 from #TMP


-- verifica se existem registros duplicados

select produto from ESTOQUE T1 (nolock) where (select count(*) from ESTOQUE T2 (nolock) where T1.produto=T2.produto) > 1


-- p9

-- elimina a tabela temporária
drop table #TMP

-- nf de entradas
select * from TBS0591 (nolock) left join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
 where NFEUSUEFE<>'' and NFEDATENT >= '20150117' and LESCOD=2 and NFEMOVEST='S'

--p10

-- seleciona produtos da tabela de NF de entradas para incluir na tabela ESTOQUE

select PROCOD,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0591.PROCOD) as 'PROUM1'
  into #TMP
  from TBS0591 (nolock) left join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
 where NFEUSUEFE<>'' and NFEDATENT >= '20150117' and LESCOD=2 and NFEMOVEST='S'
 group by PROCOD

-- elimina registro que já existem na tabela ESTOQUE

-- p11

delete #TMP from ESTOQUE where produto=PROCOD

-- insere registro da tabela de NF de saídas na tabela ESTOQUE
insert into ESTOQUE select PROCOD,PROUM1,0,0,0,0,0,0 from #TMP


-- entradas via NF

-- p12

update ESTOQUE set nfEntrada=isnull((select sum(NFEQTD*NFEQTDEMB)
                                       from TBS0591 (nolock) left join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.SERCOD=TBS0591.SERCOD
                                      where NFEUSUEFE<>'' and NFEDATENT >= '20150117' and LESCOD=2 and NFEMOVEST='S' and PROCOD=produto
                                      group by PROCOD),0)

-- p13

-- saídas via NF

update ESTOQUE set nfSaida=isnull((select sum(NFSQTD*NFSQTDEMB)
                                     from TBS0671 (nolock) left join TBS067 (nolock) on TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.NFSNUM=TBS0671.NFSNUM
                                    where NFSCAN='N' and NFSDEV='N' and NFSDATEMI >= '20150117' and LESCOD=2 and NFSMOVEST='S' and PROCOD=produto
                                    group by PROCOD),0)

select *,miEntrada+nfEntrada-miSaida-nfSaida from ESTOQUE (nolock) where miEntrada+nfEntrada-miSaida-nfSaida < 0 order by produto


-- Log de movimentações no estoque - para pegar os lançamentos realizados pela rotina de "gera saldo em estoque"
select * from TBS051 (nolock) where LMEDATHOR >= '20150117' and LMEROT='PEST010' order by LMEREG

-- p14

-- elimina a tabela temporária
drop table #TMP

-- seleciona produtos da tabela de Log para incluir na tabela ESTOQUE

select PROCOD,
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS051.PROCOD) as 'PROUM1'
  into #TMP
  from TBS051 (nolock)
 where LMEROT='PEST010' and LMEDATHOR >= '20150117' and LMELOCEST=2
 group by PROCOD


-- p15

-- elimina registro que já existem na tabela ESTOQUE
delete #TMP from ESTOQUE where produto=PROCOD

-- p16

-- adiciona os atributos para contabilizar entradas/saídas via Log de movimentações no estoque
alter table ESTOQUE add LogSaida money default 0 with values
go
alter table ESTOQUE add LogEntrada money default 0 with values
go

-- insere registro da tabela de Log de movimentações na tabela ESTOQUE
insert into ESTOQUE select PROCOD,PROUM1,0,0,0,0,0,0,0,0 from #TMP

-- entradas via geração de saldo em estoque

-- p17

update ESTOQUE set LogEntrada=isnull((select sum(LMEQTDMOV) from TBS051 (nolock)
                                       where LMEROT='PEST010' and LMEDATHOR >= '20150117' and LMELOCEST=2 and LMEACA='E' and PROCOD=produto
                                       group by PROCOD),0)


-- saídas via geração de saldo em estoque

-- p18

update ESTOQUE set LogSaida=isnull((select sum(LMEQTDMOV) from TBS051 (nolock)
                                     where LMEROT='PEST010' and LMEDATHOR >= '20150117' and LMELOCEST=2 and LMEACA='S' and PROCOD=produto
                                     group by PROCOD),0)


select *,miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida from ESTOQUE (nolock) where miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida < 0 order by produto


-- cupons fiscais vendas GZ

select top 500 * from MSL002 (nolock)

select * from MSL002 (nolock) where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN='F'

-- p19

-- elimina a tabela temporária
drop table #TMP

select M2_PROCOD,
       (select PROUM1 from TBS010 (nolock) where PROCOD=M2_PROCOD) as 'PROUM1'
  into #TMP
  from MSL002 (nolock) where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN='F'
 group by M2_PROCOD

-- elimina registro que já existem na tabela ESTOQUE
delete #TMP from ESTOQUE where produto=M2_PROCOD


-- saídas via cupons fiscais
update ESTOQUE set ecfSaida=isnull((select sum(M2_QTD) from MSL002 (nolock)
                                     where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN='F' and M2_PROCOD=produto
                                     group by M2_PROCOD),0)

-- entradas via cupons fiscais
update ESTOQUE set ecfEntrada=isnull((select sum(M2_QTD) from MSL002 (nolock)
                                       where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN='T' and M2_PROCOD=produto
                                       group by M2_PROCOD),0)

select *,miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida+ecfEntrada+ecfSaida from ESTOQUE (nolock)
 where miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida+ecfEntrada+ecfSaida < 0 order by produto


-- relatório comparativo

select produto,
       (select PRODES from TBS010 (nolock) where PROCOD=produto) as 'descrição',
       unidade,
       miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida+ecfEntrada-ecfSaida as 'saldo',
       ESTQTDATU,
       miEntrada as 'entrada-mov.int',
       nfEntrada as 'entrada-nf',
       miSaida as 'saída-mov.int',
       nfSaida as 'saída-nf',
       LogEntrada as 'entrada-gera-saldo',
       LogSaida as 'saida-gera-saldo',
       ecfEntrada as 'entrada-estorno-ecf',
       ecfSaida as 'saída-venda-ecf'
  from ESTOQUE (nolock) inner join TBS032 (nolock) on PROCOD=produto
 where ESTLOC=2 and miEntrada+nfEntrada-miSaida-nfSaida+LogEntrada-LogSaida+ecfEntrada-ecfSaida<>ESTQTDATU


if object_id('SIBD2..CUPCANCELADOS') is not null
   begin
      drop table CUPCANCELADOS
   end

select M2_CXA as 'caixa',
       M2_NUMECF as 'ecf',
       M2_DAT as 'data',
       M2_NUMDOC as 'cupom',
       M2_COO as 'coo'
  into CUPCANCELADOS
  from MSL002 (nolock)
 where M2_DAT >= '20150117' and M2_TIPREG='04'

select * from CUPCANCELADOS

select M2_REGCAN,M2_NUMECF,M2_CXA,M2_REGCAN,*
  from MSL002 (nolock) inner join CUPCANCELADOS (nolock)
       on M2_CXA=caixa and M2_NUMECF=ecf and M2_DAT=data and M2_NUMDOC=cupom and M2_NUMECF=ecf and M2_COO=coo
 where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN<>'T'

select * from CUPCAN

select M2_CXA,M2_DAT,M2_HOR,M2_NUMPED,M2_TIPDOC,M2_NUMDOC,M2_NUMECF,*
  from MSL002 (nolock)
 where M2_DAT >= '20150117' and M2_TIPREG='01' and M2_REGCAN='T' and
       not exists(select '' from CUPCANCELADOS
                   where M2_CXA=caixa and M2_NUMECF=ecf and M2_DAT=data and M2_NUMDOC=cupom)
 
select M2_DAT,M2_DATMOV,M2_DATPROC,M2_TIPREG,* from MSL002 (nolock)
 where M2_CXA=3 and M2_DAT='20150119' and M2_HOR='12:28' and M2_NUMPED='' and M2_TIPDOC='T' and M2_NUMDOC=44428 and M2_NUMECF=14 and M2_EMPCOD=0 and M2_LOJ=1

select M2_DAT,M2_DATMOV,M2_DATPROC,M2_TIPREG,* from MSL002 (nolock) where M2_CXA=2 and M2_DAT='20150123' and M2_TIPDOC='T' and M2_NUMDOC=47824 and M2_NUMECF=16

select * from CUPCANCELADOS



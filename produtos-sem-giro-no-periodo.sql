-- para tanby CD remove consultas de cupons fiscais


use SIBD
go

-- decalara variáveis

declare @DataDoProcessamento char(8),@DataDeReferencia char(8)

-- seta as variáveis

set @DataDoProcessamento=convert(char(8),getdate(),112)
set @DataDeReferencia=convert(char(8),getdate()-365,112)


-- PRIMEIRO PASSO

-- elimina a tabela de produtos inativos
if object_id('ProdutosSemGiro') is not null
   -- elimina a tabela
   drop table ProdutosSemGiro

-- recria a tabela

create table dbo.ProdutosSemGiro (
   CodigoDoProduto char(15) not null default '',
   DataDeReferencia datetime null default '17530101',
   DataDoProcessamento datetime null default '17530101',
   DataDaUltimaNFE datetime null default '17530101',
   ValorDaUltimaNFE decimal(12,4) default 0,
   DataDaUltimaNFS datetime null default '17530101',
   ValorDaUltimaNFS decimal(12,4) default 0,
   DataDoUltimoCF datetime null default '17530101',
   ValorDoUltimoCF decimal(12,4) default 0
   primary key (CodigoDoProduto)
) on [PRIMARY]

-- produtos sem nota fiscal de entrada

if object_id('TempDB.dbo.#NFENTRADA') is not null
   drop table #NFENTRADA

--select TBS0591.PROCOD as 'codigo',
--       max(TBS0591.DataEntrada) as 'data',
--       avg(dbo.NFEPRELIQ(TBS0591.NFEEMPCOD, TBS0591.NFETIP, TBS0591.NFENUM, TBS0591.NFECOD, TBS0591.SEREMPCOD, TBS0591.SERCOD, TBS0591.NFEITE)/TBS0591.NFEQTDEMB) as 'valor'
--  into #NFENTRADA
--  from TBS059 (nolock) right join TBS0591 (nolock) on TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD
-- where exists(select '' from TBS059 (nolock)
--               where TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.NFECOD=TBS0591.NFECOD and TBS059.SERCOD=TBS0591.SERCOD and
--                     TBS059.NFETIP='N' and
--                     TBS059.NFECAN='N' and
--                     TBS059.NFENOM not Like('BEST BAG%') and
--                     TBS059.NFENOM not Like('BEST OFFICE%') and
--                     TBS059.NFENOM not Like('MISASPEL%') and
--                     TBS059.NFENOM not Like('%PAPELYNA%') and
--                     TBS059.NFENOM not Like('TANBY%'))
-- group by PROCOD


--having max(TBS059.NFEDATENT) < @DataDeReferencia

select PROCOD as 'codigo',
       max(TBS059.NFEDATENT) as 'data',
       avg(dbo.NFEPRELIQ(TBS0591.NFEEMPCOD, TBS0591.NFETIP, TBS0591.NFENUM, TBS0591.NFECOD, TBS0591.SEREMPCOD, TBS0591.SERCOD, TBS0591.NFEITE)/TBS0591.NFEQTDEMB) as 'valor'
  into #NFENTRADA
  from TBS059 (nolock) right join TBS0591 (nolock) on TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD
 where TBS059.NFETIP='N' and
       TBS059.NFECAN='N' and
       TBS059.NFENOM not Like('BEST BAG%') and
       TBS059.NFENOM not Like('BEST OFFICE%') and
       TBS059.NFENOM not Like('MISASPEL%') and
       TBS059.NFENOM not Like('%PAPELYNA%') and
       TBS059.NFENOM not Like('TANBY%')
 group by PROCOD

-- atualiza os dados de vendas na tabela de produtos inativos caso já exista o registro

update ProdutosSemGiro set DataDaUltimaNFE=data,ValorDaUltimaNFE=valor from #NFENTRADA where data < @DataDeReferencia and CodigoDoProduto=codigo

--having max(TBS059.NFEDATENT) < @DataDeReferencia

-- insere os produtos da tabela temporária na tabela de produtos sem giro

--insert into ProdutosSemGiro (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaNFE,ValorDaUltimaNFE)
--select codigo,
--       @DataDeReferencia,
--       @DataDoProcessamento,
--       (select top 1 data from #NFENTRADA as a where a.codigo=b.codigo order by data desc),
--       (select top 1 valor from #NFENTRADA as a where a.codigo=b.codigo order by data desc)
--  from #NFENTRADA as b
---- where data < @DataDeReferencia
----group by codigo


--select * from #NFENTRADA where codigo in('1080067','1640054')
--select * from #NFENTRADA where codigo in('8426953')


-- elimina a tabela temporária de compras
drop table #NFENTRADA



-- elimina a tabela temporária de vendas caso exista

if object_id('TempDB.dbo.#NFSAIDAS') is not null
   drop table #NFSAIDAS

-- produtos que não foram vendidos (via NF-E)

select PROCOD as 'codigo',
       max(NFSDATEMI) as 'data',
       avg(dbo.NFSPRELIQ(TBS067.NFSEMPCOD, TBS067.NFSNUM, TBS067.SNEEMPCOD, TBS067.SNESER, TBS0671.NFSITE)/TBS0671.NFSQTDEMB) as 'valor'
       into #NFSAIDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSMOVEST='S' and
       TESCNTVEN='S' and
       NFSCLINOM not Like('BEST BAG%') and
       NFSCLINOM not Like('BEST OFFICE%') and
       NFSCLINOM not Like('MISASPEL%') and
       NFSCLINOM not Like('%PAPELYNA%') and
       NFSCLINOM not Like('TANBY%')
 group by PROCOD
--having max(NFSDATEMI) < @DataDeReferencia

-- insere os produtos da tabela temporária de venda na tabela de produtos inativos, se não existir o registro

insert into ProdutosSemGiro (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaNFS,ValorDaUltimaNFS)
select codigo,
       @DataDeReferencia,
       @DataDoProcessamento,
       (select top 1 data from #NFSAIDAS as a where a.codigo=b.codigo order by data desc),
       (select top 1 valor from #NFSAIDAS as a where a.codigo=b.codigo order by data desc)
  from #NFSAIDAS as b
 where data < @DataDeReferencia and not exists(select '' from ProdutosSemGiro (nolock) where CodigoDoProduto=codigo)
 --group by codigo

-- atualiza os dados de vendas na tabela de produtos inativos caso já exista o registro

update ProdutosSemGiro set DataDaUltimaNFS=data,ValorDaUltimaNFS=valor from #NFSAIDAS where data < @DataDeReferencia and CodigoDoProduto=codigo

-- elimina a tabela temporária de vendas
drop table #NFSAIDAS



-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- produtos que não foram vendidos (via cupom fiscal)

select M2_PROCOD as 'codigo',
       max(M2_DAT) as 'data',
       avg(M2_VALUNI) as 'valor'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where M2_TIPREG = '01' and
       M2_REGCAN = 'F'
 group by M2_PROCOD
--having max(M2_DAT) < @DataDeReferencia

-- insere os produtos da tabela temporária de cupons fiscais na tabela de produtos inativos, se não existir o registro

insert into ProdutosSemGiro (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDoUltimoCF,ValorDoUltimoCF)
select codigo,
       @DataDeReferencia,
       @DataDoProcessamento,
       (select top 1 data from #CUPOMFISCAL as a where a.codigo=b.codigo order by data desc),
       (select top 1 valor from #CUPOMFISCAL as a where a.codigo=b.codigo order by data desc)
  from #CUPOMFISCAL as b
 where data < @DataDeReferencia and not exists(select '' from ProdutosSemGiro (nolock) where CodigoDoProduto=codigo)
 group by codigo

--select codigo,@DataDeReferencia,@DataDoProcessamento,data,valor from #CUPOMFISCAL where data < @DataDeReferencia and not exists(select '' from ProdutosSemGiro (nolock) where CodigoDoProduto=codigo)

-- atualiza os dados de cupons fiscais na tabela de produtos inativos caso já exista o registro

update ProdutosSemGiro set DataDoUltimoCF=data,ValorDoUltimoCF=valor from #CUPOMFISCAL where data < @DataDeReferencia and CodigoDoProduto=codigo

-- elimina a tabela temporária de cupons fiscais
drop table #CUPOMFISCAL


-- insere os registros de produtos sem nenhuma movimentação na tabela de produtos inativos

insert into ProdutosSemGiro (CodigoDoProduto,DataDeReferencia,DataDoProcessamento)
select PROCOD,@DataDeReferencia,@DataDoProcessamento
       from TBS010 (nolock)
 where (select max(NFEDATENT)
          from TBS059 (nolock)
               right join TBS0591 (nolock) on TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFENUM=TBS059.NFENUM and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.SERCOD=TBS059.SERCOD
         where TBS059.NFETIP='N' and
               TBS059.NFECAN='N' and
               TBS0591.PROCOD=TBS010.PROCOD
         group by PROCOD) is null and
       (select max(NFSDATEMI)
          from TBS067 (nolock)
               left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
               left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
               left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
         where NFSTIP='N' and
               NFSCAN='N' and
               NFSDEV='N' and
               NFSMOVEST='S' and
               TESCNTVEN='S' and
               RDLCOD<>1 and
               TBS0671.PROCOD=TBS010.PROCOD
         group by TBS0671.PROCOD) is null and
       (select max(M2_DAT) from MSL002 (nolock) where M2_TIPREG = '01' and M2_REGCAN = 'F' and M2_PROCOD=TBS010.PROCOD group by M2_PROCOD) is null



-- SEGUNDO PASSO

-- decalara variáveis
declare @DataDoProcessamento char(8),@DataDeReferencia char(8)

set @DataDoProcessamento=convert(char(8),getdate(),112)
set @DataDeReferencia=convert(char(8),getdate()-180,112)

-- consulta entre os produto inativos

-- ... quais foram comprados nesta data do processamento e remove o produto da lista

delete ProdutosInativosA6Meses
--select top 1 PROCOD 
from TBS045 (nolock) right join TBS0451 (nolock) on TBS0451.PDCNUM=TBS045.PDCNUM where PDCDATCAD=@DataDoProcessamento and PROCOD=CodigoDoProduto

-- ... quais foram vendidos nesta data do processamento e remove o produto da lista

delete ProdutosInativosA6Meses
--select top 1 PROCOD
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI=@DataDoProcessamento and
       PROCOD=CodigoDoProduto and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSMOVEST='S' and
       TESCNTVEN='S' and
       RDLCOD<>1

-- ... quais foram vendidos via cupom fiscal nesta data do processamento e remove o produto da lista

delete ProdutosInativosA6Meses
--select M2_PROCOD
  from MSL002 (nolock) 
 where M2_DAT=@DataDoProcessamento and
       M2_PROCOD=CodigoDoProduto and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F'

-- consulta entre os produtos que não constam na lista de invativos

-- produtos que não foram comprados no últimos 6 meses

select PROCOD as 'codigo',
       max(PDCDATCAD) as 'data'
  into #COMPRAS
  from TBS045 (nolock) right join TBS0451 (nolock) on TBS0451.PDCNUM=TBS045.PDCNUM
 where --PDCDATCAD < @DataDeReferencia and
       not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=PROCOD)
 group by PROCOD
having max(PDCDATCAD) < @DataDeReferencia

-- produtos que não foram vendidos (via NF-E) nos últimos 6 meses

select PROCOD as 'codigo',
       max(NFSDATEMI) as 'data'
       into #NFSAIDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where --NFSDATEMI < @DataDeReferencia and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSMOVEST='S' and
       TESCNTVEN='S' and
       RDLCOD<>1 and
       not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=PROCOD)
 group by PROCOD
having max(NFSDATEMI) < @DataDeReferencia

-- produtos que não foram vendidos (via cupom fiscal) nos últimos 6 meses

select M2_PROCOD as 'codigo',
       max(M2_DAT) as 'data'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where --M2_DAT < @DataDeReferencia and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F' and
       not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=M2_PROCOD)
 group by M2_PROCOD
having max(M2_DAT) < @DataDeReferencia

-- insere os produtos da tabela temporária na tabela de produtos inativos
insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaCompraMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #COMPRAS

-- insere os produtos da tabela temporária de venda na tabela de produtos inativos, se não existir o registro
insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaNFSMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #NFSAIDAS where not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=codigo)

-- atualiza os dados de vendas na tabela de produtos inativos caso já exista o registro
update ProdutosInativosA6Meses set DataDaUltimaNFSMatriz=data from #NFSAIDAS where CodigoDoProduto=codigo

-- insere os produtos da tabela temporária de cupons fiscais na tabela de produtos inativos, se não existir o registro
insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDoUltimoCFMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #CUPOMFISCAL where not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=codigo)

-- atualiza os dados de cupons fiscais na tabela de produtos inativos caso já exista o registro
update ProdutosInativosA6Meses set DataDoUltimoCFMatriz=data from #CUPOMFISCAL where CodigoDoProduto=codigo

-- elimina as tabelas temporárias

drop table #COMPRAS
drop table #NFSAIDAS
drop table #CUPOMFISCAL
-- para tanby CD remove consultas de cupons fiscais


use SIBD
go

-- decalara variáveis

declare @DataDoProcessamento char(8),@DataDeReferencia char(8)

-- seta as variáveis

set @DataDoProcessamento=convert(char(8),getdate(),112)
set @DataDeReferencia=convert(char(8),getdate()-180,112)

-- PRIMEIRO PASSO

-- processamento na tanby matriz

-- elimina a tabela de produtos inativos
if object_id('ProdutosInativosA6Meses') is not null
   -- elimina a tabela
   drop table ProdutosInativosA6Meses

-- recria a tabela

create table dbo.ProdutosInativosA6Meses (
   CodigoDoProduto char(15) not null default '',
   DataDeReferencia datetime null default '17530101',
   DataDoProcessamento datetime null default '17530101',
   DataDaUltimaCompraMatriz datetime null default '17530101',
   DataDaUltimaCompraTaubate datetime null default '17530101',
   DataDaUltimaCompraCD datetime null default '17530101',
   DataDaUltimaNFSMatriz datetime null default '17530101',
   DataDaUltimaNFSTaubate datetime null default '17530101',
   DataDaUltimaNFSCD datetime null default '17530101',
   DataDoUltimoCFMatriz datetime null default '17530101',
   DataDoUltimoCFTaubate datetime null default '17530101',
   primary key (CodigoDoProduto)
) on [PRIMARY]

-- produtos que não foram comprados no últimos 6 meses

if object_id('TempDB.dbo.#COMPRAS') is not null
   drop table #COMPRAS

select PROCOD as 'codigo',
       max(PDCDATCAD) as 'data'
  into #COMPRAS
  from TBS045 (nolock) right join TBS0451 (nolock) on TBS0451.PDCNUM=TBS045.PDCNUM
 group by PROCOD
having max(PDCDATCAD) < @DataDeReferencia

-- insere os produtos da tabela temporária na tabela de produtos inativos

insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaCompraMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #COMPRAS

-- elimina a tabela temporária de compras
drop table #COMPRAS

-- elimina a tabela temporária de vendas caso exista

if object_id('TempDB.dbo.#NFSAIDAS') is not null
   drop table #NFSAIDAS

-- produtos que não foram vendidos (via NF-E) nos últimos 6 meses

select PROCOD as 'codigo',
       max(NFSDATEMI) as 'data'
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
       RDLCOD<>1
 group by PROCOD
having max(NFSDATEMI) < @DataDeReferencia

-- insere os produtos da tabela temporária de venda na tabela de produtos inativos, se não existir o registro

insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDaUltimaNFSMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #NFSAIDAS where not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=codigo)

-- atualiza os dados de vendas na tabela de produtos inativos caso já exista o registro

update ProdutosInativosA6Meses set DataDaUltimaNFSMatriz=data from #NFSAIDAS where CodigoDoProduto=codigo

-- elimina a tabela temporária de vendas
drop table #NFSAIDAS

-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- produtos que não foram vendidos (via cupom fiscal) nos últimos 6 meses

select M2_PROCOD as 'codigo',
       max(M2_DAT) as 'data'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where --M2_DAT < @DataDeReferencia and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F'
 group by M2_PROCOD
having max(M2_DAT) < @DataDeReferencia

-- insere os produtos da tabela temporária de cupons fiscais na tabela de produtos inativos, se não existir o registro

insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento,DataDoUltimoCFMatriz)
select codigo,@DataDeReferencia,@DataDoProcessamento,data from #CUPOMFISCAL where not exists(select '' from ProdutosInativosA6Meses (nolock) where CodigoDoProduto=codigo)

-- atualiza os dados de cupons fiscais na tabela de produtos inativos caso já exista o registro

update ProdutosInativosA6Meses set DataDoUltimoCFMatriz=data from #CUPOMFISCAL where CodigoDoProduto=codigo

-- elimina a tabela temporária de cupons fiscais
drop table #CUPOMFISCAL


-- insere os registros de produtos sem nenhuma movimentação na tabela de produtos inativos

insert into ProdutosInativosA6Meses (CodigoDoProduto,DataDeReferencia,DataDoProcessamento)
select PROCOD,@DataDeReferencia,@DataDoProcessamento
       from TBS010 (nolock)
 where (select max(PDCDATCAD) from TBS045 (nolock) right join TBS0451 (nolock) on TBS0451.PDCNUM=TBS045.PDCNUM where TBS0451.PROCOD=TBS010.PROCOD group by PROCOD) is null and
       (select max(NFSDATEMI) from TBS067 (nolock)
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
       (select max(M2_DAT) from MSL002 (nolock)
         where M2_TIPREG = '01' and
               M2_REGCAN = 'F' and
               M2_PROCOD=TBS010.PROCOD
         group by M2_PROCOD) is null



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
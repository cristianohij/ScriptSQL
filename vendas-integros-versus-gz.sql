select PROCOD as 'codigo',sum(NFSQTD),0,(select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) from TBS0671 (nolock) where PROCOD='0050006' group by PROCOD
union
select M2_PROCOD as 'codigo',0,sum(M2_QTD),(select PRODES from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD) from MSL002 (nolock) where M2_PROCOD='0050006' group by M2_PROCOD

--select * from TBS010 (nolock) where MARCOD=5

select PROCOD,sum(NFSQTD),0 from TBS0671 (nolock) where PROCOD='0050006' group by PROCOD

select PROCOD,
       NFSQTD,
       0,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD)
  from TBS0671 (nolock)
  where PROCOD='0050006'
union all
select M2_PROCOD,
       0,
       M2_QTD,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=MSL002.M2_PROCOD)
from MSL002 (nolock) where M2_PROCOD='0050006'





-- decalara variáveis
declare @DataDoProcessamento char(8)

set @dataProcessamento=convert(char(8),getdate(),112)
set @dataCorte=convert(char(8),getdate()-180,112)

-- elimina a tabela de vendas de produtos integros x gz

if object_id('VendasDeProdutosIntegrosXGZ') is not null
   -- elimina a tabela
   drop table VendasDeProdutosIntegrosXGZ

-- recria a tabela

create table dbo.VendasDeProdutosIntegrosXGZ (
   CodigoDoProduto varchar(15) not null default '',
   DataDaCriacao datetime null default '17530101',
   DataDoProcessamento datetime null default '17530101',
   DescricaoDoProduto varchar(60) null default '',
   UnidadeDeMedida varchar(2) null default '',
   CodigoDaMarca smallint null default 0,
   NomeDaMarca varchar(30) null default '',
   CodigoDoGrupo smallint null default 0,
   NomeDoGrupo varchar(20) null default '',
   CodigoDoSubgrupo smallint null default 0,
   NomeDoSubgrupo varchar(20) null default '',
   StatusDoProduto varchar(1) null default '',
   QtdeVendidaViaNFE decimal(12,3) null default 0,
   ValorVendidoViaNFE decimal(12,2) null default 0,
   PrecoMedioDeVendasViaNFE decimal(12,2) default 0,
   QtdeVendidaViaECF decimal(12,3) null default 0,
   ValorVendidoViaECF decimal(12,2) null default 0,
   PrecoMedioDeVendasViaECF decimal(12,2) default 0,
   PrecoDeCusto decimal(12,2) null default 0,
   DataDaUltimaNFE datetime null default '17530101',
   DataDoUltimoCF datetime null default '17530101'
   primary key (CodigoDoProduto)
) on [PRIMARY]


--  declara varíavel

declare @DataDoProcessamento char(8)

-- seta a variável

set @DataDoProcessamento=convert(char(8),getdate(),112)

--select * from VendasDeProdutosIntegrosXGZ

-- elimina a tabela temporária de notas fiscais de saídas caso exista

if object_id('TempDB.dbo.#NFSAIDAS') is not null
   drop table #NFSAIDAS

-- contabiliza as vendas via NFE

select PROCOD as 'codigo',
       max(NFSDATEMI) as 'data',
       sum(NFSQTD*NFSQTDEMB) as 'qtde',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'valor',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)/TBS0671.NFSQTDEMB) as 'preco'
       into #NFSAIDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI < @DataDoProcessamento and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSMOVEST='S' and
       TESCNTVEN='S' and
       RDLCOD<>1 and
       PROCOD='0050006'
 group by PROCOD


select * from #NFSAIDAS

-- insere os produtos na tabela de vendas de produtos integros x gz

insert into VendasDeProdutosIntegrosXGZ
   (CodigoDoProduto,
    DescricaoDoProduto,
    UnidadeDeMedida,
    CodigoDaMarca,
    NomeDaMarca,
    CodigoDoGrupo,
    NomeDoGrupo,
    CodigoDoSubgrupo,
    NomeDoSubgrupo,
    StatusDoProduto,
    QtdeVendidaViaNFE,
    ValorVendidoViaNFE,
    PrecoMedioDeVendasViaNFE,
    PrecoDeCusto,
    DataDaUltimaNFE)
select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       (select MARCOD from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
       (select GRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select GRUDES from TBS010 (nolock) join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD where PROCOD=codigo),
       (select SUBGRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select SUBGRUDES from TBS010 (nolock) join TBS0121 (nolock) on TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD where PROCOD=codigo),
       (select PROSTATUS from TBS010 (nolock) where PROCOD=codigo),
       qtde,
       valor,
       preco,
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=codigo),
       data
  from #NFSAIDAS
 where not exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- elimina a tabela temporária de notas fiscais de saídas
drop table #NFSAIDAS


declare @DataDoProcessamento char(8)

set @DataDoProcessamento=convert(char(8),getdate(),112)

-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- contabiliza as vendas via ECF

select M2_PROCOD as 'codigo',
       max(M2_DAT) as 'data',
       sum(MSL002.M2_QTD) as 'qtde',
       sum(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'valor',
       avg(MSL002.M2_VALUNI) as 'preco'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where M2_DAT < @DataDoProcessamento  and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F' and
       M2_PROCOD='0050006'
 group by M2_PROCOD

select * from #CUPOMFISCAL

-- insere os produtos na tabela de vendas de produtos integros x gz

insert into VendasDeProdutosIntegrosXGZ
   (CodigoDoProduto,
    DescricaoDoProduto,
    UnidadeDeMedida,
    CodigoDaMarca,
    NomeDaMarca,
    CodigoDoGrupo,
    NomeDoGrupo,
    CodigoDoSubgrupo,
    NomeDoSubgrupo,
    StatusDoProduto,
    QtdeVendidaViaNFE,
    ValorVendidoViaNFE,
    PrecoMedioDeVendasViaNFE,
    PrecoDeCusto,
    DataDaUltimaNFE)
select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       (select MARCOD from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
       (select GRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select GRUDES from TBS010 (nolock) join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD where PROCOD=codigo),
       (select SUBGRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select SUBGRUDES from TBS010 (nolock) join TBS0121 (nolock) on TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD where PROCOD=codigo),
       (select PROSTATUS from TBS010 (nolock) where PROCOD=codigo),
       qtde,
       valor,
       preco,
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=codigo),
       data
  from #CUPOMFISCAL
 where not exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- atualiza as informações dos produtos na tabela de vendas de produtos integros x gz

update VendasDeProdutosIntegrosXGZ
   set QtdeVendidaViaNFE=qtde,
       ValorVendidoViaNFE=valor,
       PrecoMedioDeVendasViaNFE=preco,
       DataDaUltimaNFE=data
  from #CUPOMFISCAL
 where exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- elimina a tabela temporária de cupons fiscais emitidos

drop table #CUPOMFISCAL



-- 2o. passo


-- atualiza as informações dos produtos na tabela de vendas de produtos integros x gz

--  declara varíavel

declare @DataDoProcessamento char(8)

-- seta a variável

set @DataDoProcessamento=convert(char(8),getdate(),112)

-- elimina a tabela temporária de notas fiscais de saídas caso exista

if object_id('TempDB.dbo.#NFSAIDAS') is not null
   drop table #NFSAIDAS

-- contabiliza as vendas via NFE

select PROCOD as 'codigo',
       max(NFSDATEMI) as 'data',
       sum(NFSQTD*NFSQTDEMB) as 'qtde',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as 'valor',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)/TBS0671.NFSQTDEMB) as 'preco'
       into #NFSAIDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where NFSDATEMI = @DataDoProcessamento and
       NFSTIP='N' and
       NFSCAN='N' and
       NFSDEV='N' and
       NFSMOVEST='S' and
       TESCNTVEN='S' and
       RDLCOD<>1 and
       PROCOD='0050006'
 group by PROCOD

-- insere os produtos na tabela de vendas de produtos integros x gz

insert into VendasDeProdutosIntegrosXGZ
   (CodigoDoProduto,
    DescricaoDoProduto,
    UnidadeDeMedida,
    CodigoDaMarca,
    NomeDaMarca,
    CodigoDoGrupo,
    NomeDoGrupo,
    CodigoDoSubgrupo,
    NomeDoSubgrupo,
    StatusDoProduto,
    QtdeVendidaViaNFE,
    ValorVendidoViaNFE,
    PrecoMedioDeVendasViaNFE,
    PrecoDeCusto,
    DataDaUltimaNFE)
select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       (select MARCOD from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
       (select GRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select GRUDES from TBS010 (nolock) join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD where PROCOD=codigo),
       (select SUBGRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select SUBGRUDES from TBS010 (nolock) join TBS0121 (nolock) on TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD where PROCOD=codigo),
       (select PROSTATUS from TBS010 (nolock) where PROCOD=codigo),
       qtde,
       valor,
       preco,
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=codigo),
       data
  from #NFSAIDAS
 where not exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- atualiza as informações dos produtos na tabela de vendas de produtos integros x gz

update VendasDeProdutosIntegrosXGZ
   set QtdeVendidaViaNFE=qtde,
       ValorVendidoViaNFE=valor,
       PrecoMedioDeVendasViaNFE=preco,
       DataDaUltimaNFE=data
  from #NFSAIDAS
 where exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- elimina a tabela temporária de cupons fiscais emitidos
drop table #NFSAIDAS


-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- contabiliza as vendas via ECF

select M2_PROCOD as 'codigo',
       max(M2_DAT) as 'data',
       sum(MSL002.M2_QTD) as 'qtde',
       sum(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'valor',
       avg(MSL002.M2_VALUNI) as 'preco'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where M2_DAT = @DataDoProcessamento  and
       M2_TIPREG = '01' and
       M2_REGCAN = 'F' and
       M2_PROCOD='0050006'
 group by M2_PROCOD

-- insere os produtos na tabela de vendas de produtos integros x gz

insert into VendasDeProdutosIntegrosXGZ
   (CodigoDoProduto,
    DescricaoDoProduto,
    UnidadeDeMedida,
    CodigoDaMarca,
    NomeDaMarca,
    CodigoDoGrupo,
    NomeDoGrupo,
    CodigoDoSubgrupo,
    NomeDoSubgrupo,
    StatusDoProduto,
    QtdeVendidaViaNFE,
    ValorVendidoViaNFE,
    PrecoMedioDeVendasViaNFE,
    PrecoDeCusto,
    DataDaUltimaNFE)
select codigo,
       (select PRODES from TBS010 (nolock) where PROCOD=codigo),
       (select PROUM1 from TBS010 (nolock) where PROCOD=codigo),
       (select MARCOD from TBS010 (nolock) where PROCOD=codigo),
       (select MARNOM from TBS010 (nolock) where PROCOD=codigo),
       (select GRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select GRUDES from TBS010 (nolock) join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD where PROCOD=codigo),
       (select SUBGRUCOD from TBS010 (nolock) where PROCOD=codigo),
       (select SUBGRUDES from TBS010 (nolock) join TBS0121 (nolock) on TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD where PROCOD=codigo),
       (select PROSTATUS from TBS010 (nolock) where PROCOD=codigo),
       qtde,
       valor,
       preco,
       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=codigo),
       data
  from #CUPOMFISCAL
 where not exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)

-- atualiza as informações dos produtos na tabela de vendas de produtos integros x gz

update VendasDeProdutosIntegrosXGZ
   set QtdeVendidaViaNFE=qtde,
       ValorVendidoViaNFE=valor,
       PrecoMedioDeVendasViaNFE=preco,
       DataDaUltimaNFE=data
  from #CUPOMFISCAL
 where exists(select '' from VendasDeProdutosIntegrosXGZ (nolock) where CodigoDoProduto=codigo)


declare @dataDe char(8),@dataAte char(8)

set @dataDe='20150109'
set @dataAte='20150109'

select case when TBS0671.PROCOD is null then MSL002.M2_PROCOD else TBS0671.PROCOD end, TBS0671.NFSQTD,MSL002.M2_QTD
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       full join MSL002 (nolock) on MSL002.M2_PROCOD=TBS0671.PROCOD
 where (TBS067.NFSDATEMI between @dataDe and @dataAte and TBS067.NFSTIP='N' and TBS067.NFSCAN='N') or
       (MSL002.M2_DAT between @dataDe and @dataAte and MSL002.M2_TIPREG='01' and MSL002.M2_REGCAN='F')



-----

/*
CREATE FUNCTION Sales.ufn_SalesByStore (@storeid int)
RETURNS TABLE
AS
RETURN 
(
    SELECT P.ProductID, P.Name, SUM(SD.LineTotal) AS 'Total'
    FROM Production.Product AS P 
    JOIN Sales.SalesOrderDetail AS SD ON SD.ProductID = P.ProductID
    JOIN Sales.SalesOrderHeader AS SH ON SH.SalesOrderID = SD.SalesOrderID
    JOIN Sales.Customer AS C ON SH.CustomerID = C.CustomerID
    WHERE C.StoreID = @storeid
    GROUP BY P.ProductID, P.Name
);
GO
*/


if object_id('sp_VendasIntegrosVersusGZ') is not null
   drop procedure sp_VendasIntegrosVersusGZ
go

create procedure sp_VendasIntegrosVersusGZ @dataDe date, @dataAte date, @produtoDe char(10), @produtoAte char(10)
as

begin
--declare @dataDe char(8), @dataAte char(8)

--set @dataDe='20150301'
--set @dataAte='20150731'

-- elimina a tabela temporária

set nocount on

if object_id('TempDB.dbo.#VENDAS') is not null
   drop table #VENDAS

create table #VENDAS (
   codigo char(15) not null default '',
   precoMedioCorp decimal(12,4) default 0,
   qtdeCorp decimal(12,4) default 0,
   totalCorp decimal(12,4) default 0,
   precoMedioLoja decimal(12,4) default 0,
   qtdeLoja decimal(12,4) default 0,
   totalLoja decimal(12,4) default 0,
   primary key (codigo)
) on [PRIMARY]

-- contabiliza vendas via NFE

insert into #VENDAS (codigo, precoMedioCorp, qtdeCorp, totalCorp)
select PROCOD,
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)/TBS0671.NFSQTDEMB),
       sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB),
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE))
--       into #VENDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where TBS067.NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS067.NFSDEV='N' and
       (TBS0671.NFSROPCNTVEN='S' or TBS042.TESCNTVEN='S') and
       TBS067.NFSCLINOM not Like('%BEST BAG%') and
       TBS067.NFSCLINOM not Like('%BEST OFFICE%') and
       TBS067.NFSCLINOM not Like('%MISASPEL%') and
       TBS067.NFSCLINOM not Like('%PAPELYNA%') and 
       TBS067.NFSCLINOM not Like('%TANBY%')
 group by TBS0671.PROCOD

-- insere dados na tabela de vendas

--insert into #VENDAS select * from #CUPOMFISCAL where not exists(select '' from #VENDAS where #VENDAS.codigo=#CUPOMFISCAL.codigo)


-- elimina a tabela temporária de cupons fiscais caso exista

if object_id('TempDB.dbo.#CUPOMFISCAL') is not null
   drop table #CUPOMFISCAL

-- contabiliza as vendas via ECF

select M2_PROCOD as 'codigo',
       avg(MSL002.M2_VALUNI) as 'precoMedioLoja',
       sum(MSL002.M2_QTD) as 'qtdeLoja',
       sum(MSL002.M2_VALTOT-MSL002.M2_ABT) as 'totalLoja'
       into #CUPOMFISCAL
  from MSL002 (nolock) 
 where MSL002.M2_DAT between @dataDe and @dataAte and
       MSL002.M2_PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       MSL002.M2_TIPREG = '01' and
       MSL002.M2_REGCAN = 'F'
 group by MSL002.M2_PROCOD

-- insere dados na tabela de vendas

insert into #VENDAS (codigo, precoMedioLoja, qtdeLoja, totalLoja) select codigo, precoMedioLoja, qtdeLoja, totalLoja
  from #CUPOMFISCAL
 where not exists(select '' from #VENDAS where #VENDAS.codigo collate database_default=#CUPOMFISCAL.codigo collate database_default)

update #VENDAS set precoMedioLoja=#CUPOMFISCAL.precoMedioLoja, qtdeLoja=#CUPOMFISCAL.qtdeLoja, totalLoja=#CUPOMFISCAL.totalLoja
  from #CUPOMFISCAL where #VENDAS.codigo collate database_default=#CUPOMFISCAL.codigo collate database_default

-- adiciona colunas de informações da loja

--alter table #VENDAS add precoMedioLoja smallmoney default 0 with values
--alter table #VENDAS add qtdeLoja decimal(10,4) default 0 with values


select codigo            as 'CodigoProduto',
       PRODES            as 'DescricaoProduto',
       PROUM1            as 'UnidadeMedida',
       precoMedioCorp    as 'PrecoMedioCorporativo',
       qtdeCorp          as 'QtdeVendidaCorporativo',
       totalCorp         as 'TotalVendasCorporativo',
       precoMedioLoja    as 'PrecoMedioLoja',
       qtdeLoja          as 'QtdeVendidaLoja',
       totalLoja         as 'TotalVendasLoja',
       TBS010.MARNOM     as 'MarcaProduto',
       TBS012.GRUDES     as 'GrupoProdutos',
       TBS0121.SUBGRUDES as 'SubgrupoProdutos'
  from #VENDAS
       left join TBS010 (nolock) on TBS010.PROCOD=#VENDAS.codigo collate database_default
       left join TBS012 (nolock) on TBS010.GRUCOD=TBS012.GRUCOD
       left join TBS0121 (nolock) on TBS0121.GRUCOD=TBS010.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD

end

-- fim: sp_VendasIntegrosVersusGZ




-- stored procedure

if exists(select name from sysobjects where name='sp_VendasIntegrosVersusGZ' and type='P')
   drop procedure sp_VendasIntegrosVersusGZ
go

create procedure sp_VendasIntegrosVersusGZ(@numeroNF numeric output) as
   if (select TBSMOD from TBS024 (noLock) where TBSNOM='TBS067') = 'C'
      set @numeroNF = (select max(update TBS024 set TBSVALSEQ = TBSVALSEQ + 1 where TBSNOM='TBS067') from TBS024 where TBSNOM='TBS067')
go





-- teste

if exists(select name from sysobjects where name='teste' and type='P')
   drop procedure teste
go

create procedure teste as
   select * from TBS001 (nolock)
go

exec teste

if object_id('teste') is not null
   select 'existe'
else
   select 'nao existe'


exec sp_VendasIntegrosVersusGZ '20150901', '20150904', '', ''
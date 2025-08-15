-- CFOP utilizados

/*
select NFSCFOP collate database_default
  from nd.SIBD.dbo.TBS0671 with (nolock)
union 
select NFSCFOP
  from tt.SIBD.dbo.TBS0671 with (nolock)
union 
select NFSCFOP
  from cd.SIBD.dbo.TBS0671 with (nolock)
union 
select NFSCFOP
  from bb.SIBD2.dbo.TBS0671 with (nolock)
union 
select NFSCFOP
  from mi.SIBD3.dbo.TBS0671 with (nolock)
union 
select NFSCFOP
  from pp.SIBD.dbo.TBS0671 with (nolock)
*/

if object_id('tempdb.dbo.#cfop_vendas') is not null 
begin 
	drop table #cfop_vendas
end 

select '5.101' as 'cfop'
  into #cfop_vendas

insert into #cfop_vendas
select '5.102'

insert into #cfop_vendas
select '5.116'

insert into #cfop_vendas
select '5.117'

insert into #cfop_vendas
select '5.118'

insert into #cfop_vendas
select '5.119'

insert into #cfop_vendas
select '5.123'

insert into #cfop_vendas
select '5.405'

insert into #cfop_vendas
select '5.922'

insert into #cfop_vendas
select '5.929'

insert into #cfop_vendas
select '6.102'

insert into #cfop_vendas
select '6.108'

insert into #cfop_vendas
select '6.117'

insert into #cfop_vendas
select '6.118'

insert into #cfop_vendas
select '6.119'

insert into #cfop_vendas
select '6.123'

insert into #cfop_vendas
select '6.403'

insert into #cfop_vendas
select '6.404'

insert into #cfop_vendas
select '6.923'

insert into #cfop_vendas
select '6.924'

insert into #cfop_vendas
select '6.929'

-- cfop transferência

insert into #cfop_vendas
select '5.152'

insert into #cfop_vendas
select '5.409'

insert into #cfop_vendas
select '5.557'

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end 

-- tabela dados das últimas compras

select CLICOD as 'cliente'
       ,(select top(1)
                Ltrim(str(nfe.SNESER)) + '|'
                + Ltrim(str(nfe.ENFNUM)) + '|'
                + convert(char(8),nfe.ENFDATEMI,112) + '|'
                + Ltrim(str(nfe.ENFVALTOT,15,2)) + '|'
                + Ltrim(str(nfs.NFSCLIEMP)) + '|'
           from TBS080 nfe with (nolock)
           inner join TBS067 nfs with (nolock)
              on nfs.NFSEMPCOD=nfe.ENFEMPCOD
                 and nfs.NFSNUM=nfe.ENFNUM
          where nfe.ENFSIT=6 
                and nfe.ENFCODDES=cli.CLICOD
                and exists (select 'e'
                              from TBS0671 nf_item with (nolock)
                             where nf_item.NFSEMPCOD=nfe.ENFEMPCOD
                                   and nf_item.SNESER=nfe.SNESER
                                   and nf_item.NFSNUM=nfe.ENFNUM
                                   and nf_item.NFSCFOP in (select cfop from #cfop_vendas)) 
          order by nfe.ENFDATEMI desc) as 'dados'
  into #dados
  from TBS002 cli with (nolock)

select *
  from #dados

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.cliente
       ,(select convert(smallint,elemento)
          from fSplit(d.dados,'|')
         where id=1) as 'nf_serie'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=2) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_emissao'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'valor'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'cli_empresa'
  into #atualizar
  from #dados d
 inner join TBS002 cli with (nolock)
    on cli.CLICOD=d.cliente
 where not dados is null
       and (
             cli.CLIUCPSER <> (select convert(smallint,elemento)
                                 from fSplit(d.dados,'|')
                                where id=1)
             or
             cli.CLIUCPNFS <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=2)
             or
             cli.CLIUCPDAT <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
             or 
             cli.CLIUCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
           )

if @@rowcount > 0
   update TBS002
      set CLIUCPSER=tab.nf_serie
          ,CLIUCPNFS=tab.nf_numero
          ,CLIUCPDAT=tab.nf_emissao
          ,CLIUCPVAL=tab.valor
     from (
            select cliente
                   ,nf_serie
                   ,nf_numero
                   ,nf_emissao
                   ,valor
                   ,cli_empresa
              from #atualizar
          ) tab
    where CLIEMPCOD=tab.cli_empresa
          and CLICOD=tab.cliente

-- tabela dados das primeiras compras

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end 

select CLICOD as 'cliente'
       ,(select top(1)
                Ltrim(str(nfe.SNESER)) + '|'
                + Ltrim(str(nfe.ENFNUM)) + '|'
                + convert(char(8),nfe.ENFDATEMI,112) + '|'
                + Ltrim(str(nfe.ENFVALTOT,15,2)) + '|'
                + Ltrim(str(nfs.NFSCLIEMP)) + '|'
           from TBS080 nfe with (nolock)
           inner join TBS067 nfs with (nolock)
              on nfs.NFSEMPCOD=nfe.ENFEMPCOD
                 and nfs.NFSNUM=nfe.ENFNUM
          where nfe.ENFSIT=6 
                and nfe.ENFCODDES=cli.CLICOD
                and exists (select 'e'
                              from TBS0671 nf_item with (nolock)
                             where nf_item.NFSEMPCOD=nfe.ENFEMPCOD
                                   and nf_item.SNESER=nfe.SNESER
                                   and nf_item.NFSNUM=nfe.ENFNUM
                                   and nf_item.NFSCFOP in (select cfop from #cfop_vendas)) 
          order by nfe.ENFDATEMI) as 'dados' -- somente removi a cláusula "desc"
  into #dados
  from TBS002 cli with (nolock)

select *
  from #dados

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.cliente
       ,(select convert(smallint,elemento)
          from fSplit(d.dados,'|')
         where id=1) as 'nf_serie'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=2) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_emissao'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'valor'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'cli_empresa'
  into #atualizar
  from #dados d
 inner join TBS002 cli with (nolock)
    on cli.CLICOD=d.cliente
 where not dados is null
       and (
             cli.CLIPCPSER <> (select convert(smallint,elemento)
                                 from fSplit(d.dados,'|')
                                where id=1)
             or
             cli.CLIPCPNFS <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=2)
             or
             cli.CLIPRICOM <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
             or 
             cli.CLIPCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
           )

if @@rowcount > 0
   update TBS002
      set CLIPCPSER=tab.nf_serie
          ,CLIPCPNFS=tab.nf_numero
          ,CLIPRICOM=tab.nf_emissao
          ,CLIPCPVAL=tab.valor
     from (
            select cliente
                   ,nf_serie
                   ,nf_numero
                   ,nf_emissao
                   ,valor
                   ,cli_empresa
              from #atualizar
          ) tab
    where CLIEMPCOD=tab.cli_empresa
          and CLICOD=tab.cliente

-- tabela dados da maior compra

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end

select CLICOD as 'cliente'
       ,(select top(1)
                Ltrim(str(nfe.SNESER)) + '|'
                + Ltrim(str(nfe.ENFNUM)) + '|'
                + convert(char(8),nfe.ENFDATEMI,112) + '|'
                + Ltrim(str(nfe.ENFVALTOT,15,2)) + '|'
                + Ltrim(str(nfs.NFSCLIEMP)) + '|'
           from TBS080 nfe with (nolock)
           inner join TBS067 nfs with (nolock)
              on nfs.NFSEMPCOD=nfe.ENFEMPCOD
                 and nfs.NFSNUM=nfe.ENFNUM
          where nfe.ENFSIT=6 
                and nfe.ENFCODDES=cli.CLICOD
                and exists (select 'e'
                              from TBS0671 nf_item with (nolock)
                             where nf_item.NFSEMPCOD=nfe.ENFEMPCOD
                                   and nf_item.SNESER=nfe.SNESER
                                   and nf_item.NFSNUM=nfe.ENFNUM
                                   and nf_item.NFSCFOP in (select cfop from #cfop_vendas)) 
          order by nfe.ENFVALTOT desc) as 'dados' -- maior valor
  into #dados
  from TBS002 cli with (nolock)

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.cliente
       ,(select convert(smallint,elemento)
          from fSplit(d.dados,'|')
         where id=1) as 'nf_serie'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=2) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_emissao'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'valor'
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'cli_empresa'
  into #atualizar
  from #dados d
 inner join TBS002 cli with (nolock)
    on cli.CLICOD=d.cliente
 where not dados is null
       and (
             cli.CLIMCPSER <> (select convert(smallint,elemento)
                                 from fSplit(d.dados,'|')
                                where id=1)
             or
             cli.CLIMCPNFS <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=2)
             or
             cli.CLIMCPDAT <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
             or 
             cli.CLIMCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
           )

if @@rowcount > 0
   update TBS002
      set CLIMCPSER=tab.nf_serie
          ,CLIMCPNFS=tab.nf_numero
          ,CLIMCPDAT=tab.nf_emissao
          ,CLIMCPVAL=tab.valor
     from (
            select cliente
                   ,nf_serie
                   ,nf_numero
                   ,nf_emissao
                   ,valor
                   ,cli_empresa
              from #atualizar
          ) tab
    where CLIEMPCOD=tab.cli_empresa
          and CLICOD=tab.cliente


-- CLIMAIATR maior atraso
-- CLIACUATR acumulo dos atrasos
-- CLIMEDATR fórmula

-- relatório

select c.CLICOD as 'codigo'
       ,c.CLINOM as 'nome'
       --,c.CLIDATFUN
       ,c.CLIINIATI as 'inicio_atividades'
       ,c.CLIDATCAD as 'cadastro'
       ,c.CLIPRICOM as 'primeira_compra'
       ,c.CLIUCPDAT as 'ultima_compra'
       ,c.CLIMCPVAL as 'maior_compra'
       ,v.VENNOM as 'vendedor'
  into #clientes
  from TBS002 c with (nolock)
 inner join TBS004 v with (nolock)
         on v.VENCOD=c.VENCOD
 where c.CLIPRICOM != '17530101'
       or c.CLIUCPDAT != '17530101'
       --c.CLICOD=1120
 order by c.CLIUCPDAT

select *
  from #clientes

select year(ENFDATEMI) as 'ano_emissao'
      ,ENFCODDES as 'codigo_cliente'
      ,count(*) as 'qtde_notas'
  from TBS080 with (nolock)
 where ENFDATEMI >= '20080101'
       and ENFSIT=6
       and ENFFINEMI=1
       and ENFTIPDOC=1
       and ENFCODDES > 0
 group by year(ENFDATEMI), ENFCODDES
 order by ENFCODDES, year(ENFDATEMI)

-- chatgpt

-- Criar tabela temporária para a primeira consulta
select c.CLICOD as 'codigo_cliente'
       ,year(ENFDATEMI) as 'ano_emissao'
       ,count(*) as 'qtde_notas'
  into #clientes_notas
  from TBS002 c with (nolock)
 inner join TBS080 nf with (nolock)
         on nf.ENFCODDES = c.CLICOD
 where nf.ENFDATEMI >= '20080101'
       and nf.ENFSIT = 6
       and nf.ENFFINEMI = 1
       and nf.ENFTIPDOC = 1
       and nf.ENFCODDES > 0
 group by c.CLICOD, year(nf.ENFDATEMI);

-- Consulta final juntando as duas tabelas temporárias
select c.*
       ,n.ano_emissao
       ,n.qtde_notas
  into #resultado_final
  from #clientes c
       left join #clientes_notas n
       on c.codigo = n.codigo_cliente;

-- Selecionar os resultados da tabela temporária final
select *
  from #resultado_final;

-- Lembre-se de dropar (remover) as tabelas temporárias quando não forem mais necessárias
-- drop table #clientes_notas;
-- drop table #resultado_final;

-- 2

-- Criar tabela temporária para a primeira consulta

select min(ano_emissao)
       ,max(ano_emissao)
  from (
select year(ENFDATEMI) as 'ano_emissao'
  from TBS080 with (nolock)
 where ENFDATEMI >= '20080101'
       and ENFSIT=6
       and ENFFINEMI=1
       and ENFTIPDOC=1
       and ENFCODDES > 0
 group by year(ENFDATEMI)
  ) as tab

select c.CLICOD as 'codigo_cliente'
       ,year(ENFDATEMI) as 'ano_emissao'
       ,count(*) as 'qtde_notas'
  into #clientes_notas
  from TBS002 c with (nolock)
 inner join TBS080 nf with (nolock)
         on nf.ENFCODDES = c.CLICOD
 where nf.ENFDATEMI >= '20080101'
       and nf.ENFSIT = 6
       and nf.ENFFINEMI = 1
       and nf.ENFTIPDOC = 1
       and nf.ENFCODDES > 0
 group by c.CLICOD, year(nf.ENFDATEMI);

-- Consulta final com PIVOT
select codigo_cliente,
       [2008] as '2008',
       [2009] as '2009',
       [2010] as '2010',  -- Adicione mais colunas conforme necessário
       [2011] as '2011',
       [2012] as '2012',
       [2013] as '2013',
       [2014] as '2014',
       [2015] as '2015',
       [2016] as '2016',
       [2017] as '2017',
       [2018] as '2018',
       [2019] as '2019',
       [2020] as '2020',
       [2021] as '2021',
       [2022] as '2022',
       [2023] as '2023',
       [2024] as '2024'
from (
    select codigo_cliente,
           ano_emissao,
           'ano_emissao_' + cast(ano_emissao as varchar) as ano_emissao_col,
           'qtde_notas_' + cast(ano_emissao as varchar) as qtde_notas_col,
           qtde_notas
    from #clientes_notas
) as src
pivot (
    max(qtde_notas)
    for ano_emissao_col in ([2008], [2009], [2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021], [2022], [2023], [2024])  -- Adicione mais colunas conforme necessário
) as piv;

-- Lembre-se de dropar (remover) as tabelas temporárias quando não forem mais necessárias
-- drop table #clientes_notas;

-- 3

-- Criar tabela temporária para a primeira consulta

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #clientes_notas
end 

-- Criar tabela temporária para a primeira consulta
select c.CLICOD as 'codigo_cliente'
       ,c.CLINOM as 'nome'
       ,c.CLIINIATI as 'inicio_atividades'
       ,c.CLIDATCAD as 'cadastro'
       ,c.CLIPRICOM as 'primeira_compra'
       ,c.CLIUCPDAT as 'ultima_compra'
       ,c.CLIMCPVAL as 'maior_compra'
       ,c.CLIMAIATR as 'maior_atraso'
       ,c.CLITITPRO as 'titulos_protestados'
       ,c.CLITITCAR as 'titulos_cartorio'
       ,v.VENNOM as 'vendedor'
       ,year(ENFDATEMI) as 'ano_emissao'
       ,count(*) as 'qtde_notas'
  into #clientes_notas
  from TBS002 c with (nolock)
 inner join TBS080 nf with (nolock)
         on nf.ENFCODDES = c.CLICOD
 inner join TBS004 v with (nolock)
         on v.VENCOD = c.VENCOD
 where nf.ENFDATEMI >= '20080101'
       and nf.ENFSIT = 6
       and nf.ENFFINEMI = 1
       and nf.ENFTIPDOC = 1
       and nf.ENFCODDES > 0
 group by c.CLICOD, c.CLINOM, c.CLIINIATI, c.CLIDATCAD, c.CLIPRICOM, c.CLIUCPDAT, c.CLIMCPVAL, c.CLIMAIATR, c.CLITITPRO, c.CLITITCAR, v.VENNOM, year(nf.ENFDATEMI);

-- Consulta final com PIVOT e coluna de total
select codigo_cliente,
       nome,
       inicio_atividades,
       cadastro,
       primeira_compra,
       ultima_compra,
       maior_compra,
       maior_atraso,
       titulos_protestados,
       titulos_cartorio,
       vendedor,
       ISNULL([2008], 0) as [2008],
       ISNULL([2009], 0) as [2009],
       ISNULL([2010], 0) as [2010],
       ISNULL([2011], 0) as [2011],
       ISNULL([2012], 0) as [2012],
       ISNULL([2013], 0) as [2013],
       ISNULL([2014], 0) as [2014],
       ISNULL([2015], 0) as [2015],
       ISNULL([2016], 0) as [2016],
       ISNULL([2017], 0) as [2017],
       ISNULL([2018], 0) as [2018],
       ISNULL([2019], 0) as [2019],
       ISNULL([2020], 0) as [2020],
       ISNULL([2021], 0) as [2021],
       ISNULL([2022], 0) as [2022],
       ISNULL([2023], 0) as [2023],
       ISNULL([2024], 0) as [2024],
       ISNULL([2008], 0) + ISNULL([2009], 0) + ISNULL([2010], 0) + ISNULL([2011], 0) + ISNULL([2012], 0) + ISNULL([2013], 0) + ISNULL([2014], 0) + ISNULL([2015], 0) + ISNULL([2016], 0) + ISNULL([2017], 0) + ISNULL([2018], 0) + ISNULL([2019], 0) + ISNULL([2020], 0) + ISNULL([2021], 0) + ISNULL([2022], 0) + ISNULL([2023], 0) + ISNULL([2024], 0) as 'total_notas',
       datediff(day, ultima_compra, getdate()) as 'dif_dias',
       datediff(month, ultima_compra, getdate()) as 'dif_mese',
       datediff(year, ultima_compra, getdate()) as 'dif_anos'
from (
    select *
    from #clientes_notas
) as src
pivot (
    max(qtde_notas)
    for ano_emissao in ([2008], [2009], [2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021], [2022], [2023], [2024])
) as piv

-- Lembre-se de dropar (remover) as tabelas temporárias quando não forem mais necessárias
-- drop table #clientes_notas;



-- dados do sintegra

select CLICOD
       ,CLINOM
       ,CLISINHAB
       ,CLIDATBAICON
       ,CLIDATHORCONSIN
       ,CLIINIATI
       ,CLIMODSITCAD
       ,CLICRENFE
       ,CLICRT
       ,CLICNAE
       ,replicate('',60) xNome
       ,replicate('',14) CNPJ
       ,replicate('',18) IE
       ,replicate('', 2) UF
       ,replicate('',60) xLgr
       ,replicate('',60) nro
       ,replicate('',60) xBairro
       ,0 cMun
       ,replicate('',9) CEP
       ,replicate('',60) xCpl
  into CLISINTEGRA
  from TBS002 with (nolock)

select *
  from CLISINTEGRA with (nolock)
 where CLICOD=1120

select c.CLICOD
  from TBS002 c with (nolock)
 inner join CLISINTEGRA s with (nolock)
         on c.CLICOD=s.CLICOD
 where c.CLISINHAB != s.CLISINHAB

begin tran
update TBS002
   set CLISINHAB = s.CLISINHAB
       --,CLIDATBAICON = s.CLIDATBAICON
       ,CLIDATHORCONSIN = s.CLIDATHORCONSIN
       ,CLIINIATI = s.CLIINIATI
       ,CLIMODSITCAD = s.CLIMODSITCAD
       ,CLICRENFE = s.CLICRENFE
       ,CLICRT = s.CLICRT
       ,CLICNAE = s.CLICNAE
  from TBS002 c with (nolock)
 inner join CLISINTEGRA s with (nolock)
         on c.CLICOD=s.CLICOD
 where (c.CLISINHAB != s.CLISINHAB
       --or c.CLIDATBAICON != s.CLIDATBAICON
       or c.CLIINIATI != s.CLIINIATI
       or c.CLIMODSITCAD != s.CLIMODSITCAD
       or c.CLICRENFE != s.CLICRENFE
       or c.CLICRT != s.CLICRT)
       --and c.CLICOD=1120

rollback tran
commit tran


select *
  from CLISINTEGRA with (nolock)
 where year(CLIINIATI) > 2024



-- ENTRADAS

-- CFOP utilizados

/*
select NFECFOP collate database_default
  from nd.SIBD.dbo.TBS0591 with (nolock)
union 
select NFECFOP
  from tt.SIBD.dbo.TBS0591 with (nolock)
union 
select NFECFOP
  from cd.SIBD.dbo.TBS0591 with (nolock)
union 
select NFECFOP
  from bb.SIBD2.dbo.TBS0591 with (nolock)
union 
select NFECFOP
  from mi.SIBD3.dbo.TBS0591 with (nolock)
union 
select NFECFOP
  from pp.SIBD.dbo.TBS0591 with (nolock)
*/

if object_id('tempdb.dbo.#cfop_compras') is not null 
begin 
	drop table #cfop_compras
end 

select '1.101' as 'cfop'
  into #cfop_compras

insert into #cfop_compras
select '1.102'

insert into #cfop_compras
select '1.403'

insert into #cfop_compras
select '2.101'

insert into #cfop_compras
select '2.102'

insert into #cfop_compras
select '2.403'

-- empresa do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedores_grupo') is not null
begin 
	drop table #fornecedores_grupo
end

select FORCOD as 'codigo'
  into #fornecedores_grupo
  from TBS006 with (nolock)
 where FORCGC in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')
 group by FORCOD

--ooo

-- tabela dados das últimas compras

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end

select *
  into #dados
   from (
         select FORCOD as 'fornecedor'
                ,(select top(1)
                         c.SERCOD + '|'
                         + c.NFETIP + '|'
                         --+ Ltrim(str(c.NFECOD)) + '|'
                         + Ltrim(str(c.NFENUM)) + '|'
                         + convert(char(8),c.NFEDATEFE,112) + '|'
                         + Ltrim(str(dbo.NFETOTOPE(c.NFEEMPCOD, c.NFETIP, c.NFENUM, c.NFECOD, c.SEREMPCOD, c.SERCOD),15,2)) + '|'
                    from TBS059 c with (nolock)
                   inner join TBS0591 d with (nolock)
                           on c.NFEEMPCOD=d.NFEEMPCOD and c.NFECOD=d.NFECOD and c.NFENUM=d.NFENUM and c.NFETIP=d.NFETIP and c.SERCOD=d.SERCOD and c.SEREMPCOD=d.SEREMPCOD
                   where c.NFECAN='N'
                         and c.NFECOD=f.FORCOD
                         and d.NFECFOP in (select cfop from #cfop_compras)
                   order by c.NFEDATEFE desc) as 'dados'
           from TBS006 f with (nolock)
          where f.FORCOD not in (select codigo from #fornecedores_grupo)
       ) as tab
 where tab.dados is not null

select *
  from #dados

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.fornecedor
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'nf_data'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'nf_valor'
  into #atualizar
  from #dados d
 inner join TBS006 f with (nolock)
    on f.FORCOD=d.fornecedor
 where not dados is null
       and (
             f.FORUCPDAT <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
             or
             f.FORUCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=5)
             or
             f.FORUCPNFE <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
           )

if @@rowcount > 0
   update TBS006
      set FORUCPDAT=tab.nf_data
          ,FORUCPVAL=tab.nf_valor
          ,FORUCPNFE=tab.nf_numero
     from (
            select fornecedor
                   ,nf_numero
                   ,nf_data
                   ,nf_valor
              from #atualizar
          ) tab
    where FOREMPCOD=0
          and FORCOD=tab.fornecedor

-- tabela dados das primeiras compras

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end 

select *
  into #dados
   from (
         select FORCOD as 'fornecedor'
                ,(select top(1)
                         c.SERCOD + '|'
                         + c.NFETIP + '|'
                         --+ Ltrim(str(c.NFECOD)) + '|'
                         + Ltrim(str(c.NFENUM)) + '|'
                         + convert(char(8),c.NFEDATEFE,112) + '|'
                         + Ltrim(str(dbo.NFETOTOPE(c.NFEEMPCOD, c.NFETIP, c.NFENUM, c.NFECOD, c.SEREMPCOD, c.SERCOD),15,2)) + '|'
                    from TBS059 c with (nolock)
                   inner join TBS0591 d with (nolock)
                           on c.NFEEMPCOD=d.NFEEMPCOD and c.NFECOD=d.NFECOD and c.NFENUM=d.NFENUM and c.NFETIP=d.NFETIP and c.SERCOD=d.SERCOD and c.SEREMPCOD=d.SEREMPCOD
                   where c.NFECAN='N'
                         and c.NFECOD=f.FORCOD
                         and d.NFECFOP in (select cfop from #cfop_compras)
                   order by c.NFEDATEFE) as 'dados'     -- removi o parâmetro "desc"
           from TBS006 f with (nolock)
          where f.FORCOD not in (select codigo from #fornecedores_grupo)
       ) as tab
 where tab.dados is not null

select *
  from #dados

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.fornecedor
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'nf_data'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'nf_valor'
  into #atualizar
  from #dados d
 inner join TBS006 f with (nolock)
    on f.FORCOD=d.fornecedor
 where not dados is null
       and (
             f.FORPRICOM <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
             or
             f.FORPCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=5)
             or
             f.FORPCPNFE <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
           )

if @@rowcount > 0
   update TBS006
      set FORPRICOM=tab.nf_data
          ,FORPCPVAL=tab.nf_valor
          ,FORPCPNFE=tab.nf_numero
     from (
            select fornecedor
                   ,nf_numero
                   ,nf_data
                   ,nf_valor
              from #atualizar
          ) tab
    where FOREMPCOD=0
          and FORCOD=tab.fornecedor

-- tabela dados da maior compra

if object_id('tempdb.dbo.#dados') is not null 
begin 
	drop table #dados
end

select *
  into #dados
   from (
         select FORCOD as 'fornecedor'
                ,(select top(1)
                         c.SERCOD + '|'
                         + c.NFETIP + '|'
                         + Ltrim(str(c.NFENUM)) + '|'
                         + convert(char(8),c.NFEDATEFE,112) + '|'
                         + Ltrim(str(dbo.NFETOTOPE(c.NFEEMPCOD, c.NFETIP, c.NFENUM, c.NFECOD, c.SEREMPCOD, c.SERCOD),15,2)) + '|'
                    from TBS059 c with (nolock)
                   inner join TBS0591 d with (nolock)
                           on c.NFEEMPCOD=d.NFEEMPCOD and c.NFECOD=d.NFECOD and c.NFENUM=d.NFENUM and c.NFETIP=d.NFETIP and c.SERCOD=d.SERCOD and c.SEREMPCOD=d.SEREMPCOD
                   where c.NFECAN='N'
                         and c.NFECOD=f.FORCOD
                         and d.NFECFOP in (select cfop from #cfop_compras)
                   order by dbo.NFETOTOPE(c.NFEEMPCOD, c.NFETIP, c.NFENUM, c.NFECOD, c.SEREMPCOD, c.SERCOD) desc) as 'dados'    -- maior valor
           from TBS006 f with (nolock)
          where f.FORCOD not in (select codigo from #fornecedores_grupo)
       ) as tab
 where tab.dados is not null

-- tabela atualizar

if object_id('tempdb.dbo.#atualizar') is not null 
begin 
	drop table #atualizar
end 

select d.fornecedor
       ,(select convert(int,elemento)
          from fSplit(d.dados,'|')
         where id=3) as 'nf_numero'
       ,(select convert(date,elemento)
          from fSplit(d.dados,'|')
         where id=4) as 'nf_data'
       ,(select convert(decimal(15,2),elemento)
          from fSplit(d.dados,'|')
         where id=5) as 'nf_valor'
  into #atualizar
  from #dados d
 inner join TBS006 f with (nolock)
    on f.FORCOD=d.fornecedor
 where not dados is null
       and (
             f.FORMCPDAT <> (select convert(date,elemento)
                                 from fSplit(d.dados,'|')
                                where id=4)
             or
             f.FORMCPVAL <> (select convert(decimal(15,2),elemento)
                                 from fSplit(d.dados,'|')
                                where id=5)
             or
             f.FORMCPNFE <> (select convert(int,elemento)
                                 from fSplit(d.dados,'|')
                                where id=3)
           )

if @@rowcount > 0
   update TBS006
      set FORMCPDAT=tab.nf_data
          ,FORMCPVAL=tab.nf_valor
          ,FORMCPNFE=tab.nf_numero
     from (
            select fornecedor
                   ,nf_numero
                   ,nf_data
                   ,nf_valor
              from #atualizar
          ) tab
    where FOREMPCOD=0
          and FORCOD=tab.fornecedor




-- relatório

if object_id('tempdb.dbo.#pedidos_compradores') is not null 
begin 
	drop table #pedidos_compradores
end

select COMCOD as comprador
       ,max(PDCNUM) AS ultimo_pedido
       ,FORCOD as fornecedor
  into #pedidos_compradores
  from TBS045 with (nolock)
 group by COMCOD, FORCOD

select *
  from #pedidos_compradores

select c.COMCOD
  from TBS046 c with (nolock)

select *
  into #pedidos_compradores
   from (
         select c.COMCOD as codigo
                ,c.COMNOM as nome
                ,(select top(1)
                         p.FORCOD
                    from TBS045 p with (nolock)
                   where dbo.PDCTOTBRU(p.PDCEMPCOD, p.PDCNUM) > 0
                         and p.FORCOD not in (select codigo from #fornecedores_grupo)
                         and p.COMCOD=c.COMCOD
                   order by p.PDCNUM desc) as fornecedor
           from TBS046 c with (nolock)
       ) as tab
 where tab.fornecedor is not null

select *
  --into #pedidos_compradores
   from (
         select f.FORCOD as codigo
                --,c.COMNOM
                --,
                ,(select top(1)
                         c.COMNOM
                    from TBS045 p with (nolock)
                    Left join TBS046 c with (nolock)
                           on c.COMCOD=p.COMCOD
                   where dbo.PDCTOTBRU(p.PDCEMPCOD, p.PDCNUM) > 0
                         and p.FORCOD not in (select codigo from #fornecedores_grupo)
                         and p.FORCOD=f.FORCOD
                   order by p.PDCNUM desc) as 'dados'
           from TBS006 f with (nolock)
       ) as tab
 where tab.dados is not null

select f.FORCOD as codigo
       ,f.FORNOM as nome
       ,f.FORDATCAD as cadastro
       ,f.FORPRICOM as primeira_compra
       ,f.FORUCPDAT as ultima_compra
       ,f.FORMCPDAT as maior_compra
       --,c.COMNOM as comprador
       ,isnull(p.nome,'')
  from TBS006 f with (nolock)
  Left join #pedidos_compradores p with (nolock)
         on f.FORCOD=p.fornecedor
 --inner join TBS046 c with (nolock)
         --on p.comprador=c.COMCOD
 where (f.FORPRICOM != '17530101'
       or f.FORUCPDAT != '17530101')
       and f.FORCOD not in (select codigo from #fornecedores_grupo)
 order by f.FORUCPDAT desc


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
 inner join TBS046 c with (nolock)
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
 group by c.CLICOD, c.CLINOM, c.CLIINIATI, c.CLIDATCAD, c.CLIPRICOM, c.CLIUCPDAT, c.CLIMCPVAL, v.VENNOM, year(nf.ENFDATEMI);

-- Consulta final com PIVOT e coluna de total
select codigo_cliente,
       nome,
       inicio_atividades,
       cadastro,
       primeira_compra,
       ultima_compra,
       maior_compra,
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
       ISNULL([2008], 0) + ISNULL([2009], 0) + ISNULL([2010], 0) + ISNULL([2011], 0) + ISNULL([2012], 0) + ISNULL([2013], 0) + ISNULL([2014], 0) + ISNULL([2015], 0) + ISNULL([2016], 0) + ISNULL([2017], 0) + ISNULL([2018], 0) + ISNULL([2019], 0) + ISNULL([2020], 0) + ISNULL([2021], 0) + ISNULL([2022], 0) + ISNULL([2023], 0) + ISNULL([2024], 0) as 'total_notas'
from (
    select *
    from #clientes_notas
) as src
pivot (
    max(qtde_notas)
    for ano_emissao in ([2008], [2009], [2010], [2011], [2012], [2013], [2014], [2015], [2016], [2017], [2018], [2019], [2020], [2021], [2022], [2023], [2024])
) as piv;

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



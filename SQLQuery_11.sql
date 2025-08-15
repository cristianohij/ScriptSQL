-- códigos dos clientes "grupo"
if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_ClientesGrupo 1

select *
  from #grupo

-- últimas vendas

if object_id('ultimas_vendas') is not null
    begin
    	drop table ultimas_vendas
    end

select --dw1.numeroDocumento
       --,dw1.numeroSerieDocumento
       --,dw1.caixa
       --,dw1.codigoCliente
       --,dw1.chave
       dw1.[data]
       ,dw1.codigoProduto
       --,dw1.quantidade
       --,dw1.precoUnitario
       --,dw1.valorTotal
  into ultimas_vendas
  --into #ultimas_vendas_bb
  --from tt.SIBD.dbo.DWVendas dw1 with (nolock) -- taubaté
  from DWVendas dw1 with (nolock) -- best bag
  --from DWVendas dw1 with (nolock) -- sjc
 where dw1.[data] <= getdate() - 1 -- '20240331'
       --and 
       --dw1.codigoProduto='1080067'
       --and 
       and dw1.cancelado='N'
       and dw1.numeroSerieDocumento != 3
       and dw1.codigoCliente not in (select codigo from #grupo)
       and convert(datetime,convert(char(10),[data])+'T'+hora) = (
                          select top(1) convert(datetime,convert(char(10),[data])+'T'+hora)
                            --from tt.SIBD.dbo.DWVendas dw2  with (nolock) -- taubaté
                            --from DWVendas dw2  with (nolock) -- sjc
                            from DWVendas dw2  with (nolock) -- best bag
                           where dw2.cancelado='N'
                                 and dw2.numeroSerieDocumento != 3
                                 and dw2.codigoCliente not in(select codigo from #grupo)
                                 and dw2.codigoProduto=dw1.codigoProduto
                           order by convert(datetime,convert(char(10),[data])+'T'+hora) desc
                        )
 group by  dw1.[data]
           ,dw1.codigoProduto

-- lista única de produtos vendidos

-- com data de corte

if object_id('tempdb.dbo.#produtos') is not null
    begin
    	drop table #produtos
    end

declare @data as date
set @data = '20231231'

select codigoProduto
  into #produtos
  from ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from TBS032 with (nolock)
               where ESTLOC in(1,2)
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0

union 
select codigoProduto
  from bb.SIBD2.dbo.ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from bb.SIBD2.dbo.TBS032 with (nolock)
               where ESTLOC = 2
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0

union 
select codigoProduto
  from mi.SIBD3.dbo.ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from mi.SIBD3.dbo.TBS032 with (nolock)
               where ESTLOC = 1
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0

union 
select codigoProduto
  from pp.SIBD.dbo.ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from pp.SIBD.dbo.TBS032 with (nolock)
               where ESTLOC = 1
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0

union 
select codigoProduto
  from tt.SIBD.dbo.ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from tt.SIBD.dbo.TBS032 with (nolock)
               where ESTLOC in(1,2)
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0
/*
winpack poderia duplicar a informação, pois ela repassa as vendas do grupo
union 
select codigoProduto
  from wp.SIBD4.dbo.ultimas_vendas with (nolock)
 where [data] <= @data
       and (
              select sum(ESTQTDATU - ESTQTDRES)
                from wp.SIBD4.dbo.TBS032 with (nolock)
               where ESTLOC in(1,2)
                     and PROCOD = codigoProduto
                     and ESTQTDATU - ESTQTDRES > 0
           ) > 0
*/

-- sem data de corte


if object_id('tempdb.dbo.#produtos') is not null
    begin
    	drop table #produtos
    end

select codigoProduto
  into #produtos
  from ultimas_vendas with (nolock)

union 
select codigoProduto
  from bb.SIBD2.dbo.ultimas_vendas with (nolock)

union 
select codigoProduto
  from mi.SIBD3.dbo.ultimas_vendas with (nolock)

union 
select codigoProduto
  from pp.SIBD.dbo.ultimas_vendas with (nolock)

union 
select codigoProduto
  from tt.SIBD.dbo.ultimas_vendas with (nolock)

union 
select codigoProduto
  from wp.SIBD4.dbo.ultimas_vendas with (nolock)

-- últimas vendas do grupo

if object_id('ultimas_vendas_grupo') is not null
    begin
    	drop table ultimas_vendas_grupo
    end

select p1.codigoProduto as 'codigo'
       ,p2.PRODES as 'descricao'
       ,(select MARNOM from TBS014 m with (nolock) where m.MARCOD=p2.MARCOD) as 'marca'
       ,(
           select isnull(sum(ESTQTDATU - ESTQTDRES),0)
             from TBS032 with (nolock)
            where ESTLOC in(1,2)
                  and PROCOD = p1.codigoProduto
                  and ESTQTDATU - ESTQTDRES > 0
        ) as 'tanby_sjc'
       ,(
           select [data]
             from ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_sjc'
       ,(
            select isnull(sum(ESTQTDATU - ESTQTDRES),0)
              from bb.SIBD2.dbo.TBS032 with (nolock)
             where ESTLOC = 2
                   and PROCOD = codigoProduto
                   and ESTQTDATU - ESTQTDRES > 0
        ) as 'best_bag'
       ,(
           select [data]
             from bb.SIBD2.dbo.ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_bb'
       ,(
            select isnull(sum(ESTQTDATU - ESTQTDRES),0)
              from mi.SIBD3.dbo.TBS032 with (nolock)
             where ESTLOC = 1
                   and PROCOD = codigoProduto
                   and ESTQTDATU - ESTQTDRES > 0
        ) as 'misaspel'
       ,(
           select [data]
             from pp.SIBD3.dbo.ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_mis'
       ,(
            select isnull(sum(ESTQTDATU - ESTQTDRES),0)
              from pp.SIBD.dbo.TBS032 with (nolock)
             where ESTLOC = 1
                   and PROCOD = codigoProduto
                   and ESTQTDATU - ESTQTDRES > 0
        ) as 'papelyna'
       ,(
           select [data]
             from pp.SIBD.dbo.ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_py'
       ,(
            select isnull(sum(ESTQTDATU - ESTQTDRES),0)
              from tt.SIBD.dbo.TBS032 with (nolock)
             where ESTLOC in(1,2)
                   and PROCOD = codigoProduto
                   and ESTQTDATU - ESTQTDRES > 0
        ) as 'tanby_taubate'
       ,(
           select [data]
             from tt.SIBD.dbo.ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_tt'
       ,(
            select isnull(sum(ESTQTDATU - ESTQTDRES),0)
              from wp.SIBD4.dbo.TBS032 with (nolock)
             where ESTLOC = 1
                   and PROCOD = codigoProduto
                   and ESTQTDATU - ESTQTDRES > 0
        ) as 'winpack'
       ,(
           select [data]
             from wp.SIBD4.dbo.ultimas_vendas v with (nolock)
            where v.codigoProduto = p1.codigoProduto
        ) as 'data_wp'
  into ultimas_vendas_grupo
  from #produtos p1
 inner join TBS010 p2 with (nolock) on p2.PROCOD=p1.codigoProduto

-- where not exists(select 'ne' from TBS010 with (nolock) where PROCOD=codigoProduto) 

-- relatório

-- se não houver data de corte, pode ser especificada a data desejada

declare @data as date
set @data = '20231231'

select *
  from ultimas_vendas_grupo with (nolock)
 where data_sjc <= @data
       and data_bb <= @data
       and data_mis <= @data
       and data_py <= @data
       and data_tt <= @data
       and data_wp <= @data

select PROCOD
       ,PRODES
       ,PROUVDDAT
  from TBS010 with (nolock)
 where convert(date,PROUVDDAT) <= '20230531'

select count(*)
  from TBS010 with (nolock)

select PROCOD
       ,PRODES
       ,PROUVDDAT
  from TBS010 with (nolock)
 where PROCOD='1080067'

select quantidade
       ,*
  from DWVendas with (nolock)
 where [data] between '20240301' and '20240331'
       and codigoProduto='1080067'
       and cancelado='N'
       and numeroSerieDocumento != 3
       and codigoCliente not in(select codigo from #clientesGrupo)

select c.NFETIP
       ,c.SERCOD
       ,c.NFECOD
       ,c.NFENUM
       ,c.NFEDATEFE
       ,i.PROCOD
       ,i.NFECESTXML
  into #procest
  from TBS059 c with (nolock)
 inner join TBS0591 i with (nolock)
    on c.NFETIP=i.NFETIP and c.SERCOD=i.SERCOD and c.NFECOD=i.NFECOD and c.NFENUM=i.NFENUM --and c.NFECAN != 'S' and c.NFEDATEFE != '17530101'
 where c.NFEDATEFE != '17530101'
       and c.NFECAN = 'N'
       and c.NFETIP='N'
       and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
       and i.NFECESTXML != ''
       and c.NFEDATEFE = (
                           select max(NFEDATEFE)
                             from TBS059 c1 with (nolock)
                            inner join TBS0591 i1 with (nolock)
                               on c1.NFETIP=i1.NFETIP and c1.SERCOD=i1.SERCOD and c1.NFECOD=i1.NFECOD and c1.NFENUM=i1.NFENUM --and c1.NFECAN != 'S' and c1.NFEDATEFE != '17530101'
                            where c1.NFEDATEFE != '17530101'
                                  and c1.NFECAN = 'N'
                                  and c1.NFETIP='N'
                                  and i1.PROCOD = i.PROCOD
                                  and i1.NFECESTXML != ''
                                  and c.NFECOD not in(select codigo from #fornecedoresGrupo with (nolock))
                         )



drop table ultimas_vendas


select top(1) [data], hora
       ,convert(datetime,convert(char(10),[data])+'T'+hora)
  from DWVendas with (nolock)
 where codigoProduto='1080067'

select *
  from bb.SIBD2.dbo.DWVendas with (nolock)
 where hora=''

begin tran
update DWVendas
   set hora='00:00:00'
 where hora=''

rollback tran
commit tran

select *
       ,'papelyna'
  from #ultimas_vendas_papelyna
 where [data] <= '20230531'

select *
       ,'best_bag'
  from bb.SIBD2.dbo.ultimas_vendas_bb with (nolock)

select hora
  from DWVendas with (nolock)
 where [data] <= '20240331'
 group by hora

select hora
  from DWVendas with (nolock)
 where [data] between '20240301' and '20240331'
 group by hora

select [data]
  from DWVendas with (nolock)
 where [data] <= '20240331'
 group by [data]

select convert(datetime,convert(char(10),[data])+'T'+hora)
  from DWVendas with (nolock)
 where [data] <= '20240231'
 group by convert(datetime,convert(char(10),[data])+'T'+hora)
 order by convert(datetime,convert(char(10),[data])+'T'+hora) desc

update DWVendas
   set hora='00:00:00'
 where hora='REIRA:19'

update DWVendas
   set hora='00:00:00'
 where Len(hora) < 8

EXEC sp_rename 'ultimas_vendas_taubate', 'ultimas_vendas'

select *
  from ultimas_vendas with (nolock)





---


---

select *
  from ultimas_vendas with (nolock)
 where codigoProduto = '0040274'

select *
  from ultimas_vendas with (nolock)
 where not exists(select 'ne' from TBS010 with (nolock) where PROCOD=codigoProduto) 








select count(*)
  from ultimas_vendas with (nolock)

-- checar duplicidade

select codigoProduto
       ,count(*)
  from ultimas_vendas
 group by codigoProduto
having count(*) > 1

/*
if object_id('ultimas_vendas') is not null
    begin
    	drop table ultimas_vendas
    end

select numeroDocumento
       ,numeroSerieDocumento
       ,caixa
       ,codigoCliente
       ,chave
       ,[data]
       ,codigoProduto
       ,quantidade
       ,precoUnitario
       ,valorTotal
  into ultimas_vendas
  from #ultimas_vendas
 group by numeroDocumento
          ,numeroSerieDocumento
          ,caixa
          ,codigoCliente
          ,chave
          ,[data]
          ,codigoProduto
          ,quantidade
          ,precoUnitario
          ,valorTotal

select *
  from ultimas_vendas
 where codigoProduto in ('28870001'
,'1750462'
,'2860101'
,'8490561'
,'5221124'
,'4960131'
,'0071145'
,'8021040'
,'24440002'
,'1060040'
,'3251837'
,'8420521'
,'3794617'
)
*/

-- busca produto na DWVendas

select [data]
       ,*
  from DWVendas with (nolock)
 where codigoProduto='0040274'

select datediff(month, '20230331', getdate())

select getdate() - 365


/* script menos eficiente

if object_id('ultimas_vendas_grupo') is not null
    begin
    	drop table ultimas_vendas_grupo
    end;

WITH UltimaVendaCTE AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        ultimas_vendas
    GROUP BY
        codigoProduto
)
SELECT
    p1.codigoProduto AS codigo,
    p2.PRODES AS descricao,
    m.MARNOM AS marca,
    ISNULL(tanby_sjc, 0) AS tanby_sjc,
    uv_sjc.ultima_data_venda AS data_sjc,
    ISNULL(best_bag, 0) AS best_bag,
    uv_bb.ultima_data_venda AS data_bb,
    ISNULL(misaspel, 0) AS misaspel,
    uv_mis.ultima_data_venda AS data_mis,
    ISNULL(papelyna, 0) AS papelyna,
    uv_py.ultima_data_venda AS data_py,
    ISNULL(tanby_taubate, 0) AS tanby_taubate,
    uv_tt.ultima_data_venda AS data_tt,
    ISNULL(winpack, 0) AS winpack,
    uv_wp.ultima_data_venda AS data_wp
INTO
    ultimas_vendas_grupo
FROM
    #produtos p1
INNER JOIN
    TBS010 p2 ON p2.PROCOD = p1.codigoProduto
LEFT JOIN
    TBS014 m ON m.MARCOD = p2.MARCOD
LEFT JOIN
    UltimaVendaCTE uv_sjc ON uv_sjc.codigoProduto = p1.codigoProduto
LEFT JOIN
    (SELECT
         PROCOD,
         SUM(CASE WHEN ESTLOC IN (1, 2) THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS tanby_sjc
     FROM
         TBS032
     WHERE
         ESTQTDATU - ESTQTDRES > 0
     GROUP BY
         PROCOD) AS s ON s.PROCOD = p1.codigoProduto
LEFT JOIN
    bb.SIBD2.dbo.TBS032 AS bb ON bb.PROCOD = p1.codigoProduto
LEFT JOIN
    mi.SIBD3.dbo.TBS032 AS mis ON mis.PROCOD = p1.codigoProduto
LEFT JOIN
    pp.SIBD.dbo.TBS032 AS py ON py.PROCOD = p1.codigoProduto
LEFT JOIN
    tt.SIBD.dbo.TBS032 AS tt ON tt.PROCOD = p1.codigoProduto
LEFT JOIN
    wp.SIBD4.dbo.TBS032 AS wp ON wp.PROCOD = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE uv_bb ON uv_bb.codigoProduto = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE uv_mis ON uv_mis.codigoProduto = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE uv_py ON uv_py.codigoProduto = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE uv_tt ON uv_tt.codigoProduto = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE uv_wp ON uv_wp.codigoProduto = p1.codigoProduto;
*/



if object_id('tempdb.dbo.#produtos') is not null
    begin
    	drop table #produtos
    end;

DECLARE @data AS DATE
SET @data = '2024-04-17'

;WITH ProdutosComEstoque AS (
    SELECT DISTINCT
        uv.codigoProduto
    FROM
        ultimas_vendas uv WITH (NOLOCK)
    WHERE
        uv.[data] <= @data
    UNION
    SELECT DISTINCT
        bb.codigoProduto
    FROM
        bb.SIBD2.dbo.ultimas_vendas bb WITH (NOLOCK)
    WHERE
        bb.[data] <= @data
    UNION
    SELECT DISTINCT
        mi.codigoProduto
    FROM
        mi.SIBD3.dbo.ultimas_vendas mi WITH (NOLOCK)
    WHERE
        mi.[data] <= @data
    UNION
    SELECT DISTINCT
        pp.codigoProduto
    FROM
        pp.SIBD.dbo.ultimas_vendas pp WITH (NOLOCK)
    WHERE
        pp.[data] <= @data
    UNION
    SELECT DISTINCT
        tt.codigoProduto
    FROM
        tt.SIBD.dbo.ultimas_vendas tt WITH (NOLOCK)
    WHERE
        tt.[data] <= @data
    UNION
    SELECT DISTINCT
        wp.codigoProduto
    FROM
        wp.SIBD4.dbo.ultimas_vendas wp WITH (NOLOCK)
    WHERE
        wp.[data] <= @data
),
ProdutosComEstoqueFinal AS (
    SELECT DISTINCT
        pce.codigoProduto
    FROM
        ProdutosComEstoque pce
    INNER JOIN
        TBS032 e WITH (NOLOCK) ON e.PROCOD = pce.codigoProduto
    WHERE
        e.ESTQTDATU - e.ESTQTDRES > 0
)
SELECT
    codigoProduto
INTO
    #produtos
FROM
    ProdutosComEstoqueFinal;


if object_id('tempdb.dbo.#produtos') is not null
begin
    drop table #produtos
end;

DECLARE @data AS DATE
SET @data = '2024-04-17'

;WITH ProdutosComEstoque AS (
    SELECT DISTINCT
        uv.codigoProduto,
        uv.[data]
    FROM
        ultimas_vendas uv WITH (NOLOCK)
    WHERE
        uv.[data] <= @data
    UNION
    SELECT DISTINCT
        bb.codigoProduto,
        bb.[data]
    FROM
        bb.SIBD2.dbo.ultimas_vendas bb WITH (NOLOCK)
    WHERE
        bb.[data] <= @data
    UNION
    SELECT DISTINCT
        mi.codigoProduto,
        mi.[data]
    FROM
        mi.SIBD3.dbo.ultimas_vendas mi WITH (NOLOCK)
    WHERE
        mi.[data] <= @data
    UNION
    SELECT DISTINCT
        pp.codigoProduto,
        pp.[data]
    FROM
        pp.SIBD.dbo.ultimas_vendas pp WITH (NOLOCK)
    WHERE
        pp.[data] <= @data
    UNION
    SELECT DISTINCT
        tt.codigoProduto,
        tt.[data]
    FROM
        tt.SIBD.dbo.ultimas_vendas tt WITH (NOLOCK)
    WHERE
        tt.[data] <= @data
    UNION
    SELECT DISTINCT
        wp.codigoProduto,
        wp.[data]
    FROM
        wp.SIBD4.dbo.ultimas_vendas wp WITH (NOLOCK)
    WHERE
        wp.[data] <= @data
),
ProdutosComEstoqueFinal AS (
    SELECT DISTINCT
        pce.codigoProduto,
        pce.[data]
    FROM
        ProdutosComEstoque pce
    INNER JOIN
        TBS032 e WITH (NOLOCK) ON e.PROCOD = pce.codigoProduto
    WHERE
        e.ESTQTDATU - e.ESTQTDRES > 0
)
SELECT
    codigoProduto,
    [data]
INTO
    #produtos
FROM
    ProdutosComEstoqueFinal;

select *
  from #produtos

select *
  from ultimas_vendas



if object_id('ultimas_vendas_grupo') is not null
    begin
    	drop table ultimas_vendas_grupo
    end;

WITH UltimaVendaCTE AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        ultimas_vendas
    GROUP BY
        codigoProduto
),
TanbySjcCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC IN (1, 2) AND ESTQTDATU - ESTQTDRES > 0 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS tanby_sjc
    FROM
        TBS032
    GROUP BY
        PROCOD
),
TanbyTaubateCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC IN (1, 2) AND ESTQTDATU - ESTQTDRES > 0 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS tanby_taubate
    FROM
        tt.SIBD.dbo.TBS032
    GROUP BY
        PROCOD
),
BestBagCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 2 AND ESTQTDATU - ESTQTDRES > 0 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS best_bag
    FROM
        bb.SIBD2.dbo.TBS032
    GROUP BY
        PROCOD
),
MisaspelCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 1 AND ESTQTDATU - ESTQTDRES > 0 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS misaspel
    FROM
        mi.SIBD3.dbo.TBS032
    GROUP BY
        PROCOD
),
PapelynaCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 1 AND ESTQTDATU - ESTQTDRES > 0 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS papelyna
    FROM
        pp.SIBD.dbo.TBS032
    GROUP BY
        PROCOD
),
WinpackCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 1 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS winpack
    FROM
        wp.SIBD4.dbo.TBS032
    GROUP BY
        PROCOD
)
SELECT
    p1.codigoProduto AS codigo,
    p2.PRODES AS descricao,
    m.MARNOM AS marca,
    ISNULL(ts.tanby_sjc, 0) AS tanby_sjc,
    ISNULL(uv_sjc.ultima_data_venda, '1900-01-01') AS data_sjc,
    ISNULL(bb.best_bag, 0) AS best_bag,
    ISNULL(uv_bb.ultima_data_venda, '1900-01-01') AS data_bb,
    ISNULL(mis.misaspel, 0) AS misaspel,
    ISNULL(uv_mis.ultima_data_venda, '1900-01-01') AS data_mis,
    ISNULL(pp.papelyna, 0) AS papelyna,
    ISNULL(uv_pp.ultima_data_venda, '1900-01-01') AS data_pp,
    ISNULL(tt.tanby_taubate, 0) AS tanby_taubate,
    ISNULL(uv_tt.ultima_data_venda, '1900-01-01') AS data_tt,
    ISNULL(wp.winpack, 0) AS winpack,
    ISNULL(uv_wp.ultima_data_venda, '1900-01-01') AS data_wp
INTO
    ultimas_vendas_grupo
FROM
    #produtos p1
INNER JOIN
    TBS010 p2 ON p2.PROCOD = p1.codigoProduto
LEFT JOIN
    TBS014 m ON m.MARCOD = p2.MARCOD
LEFT JOIN
    UltimaVendaCTE uv_sjc ON uv_sjc.codigoProduto = p1.codigoProduto
LEFT JOIN
    TanbySjcCTE ts ON ts.PROCOD = p1.codigoProduto
LEFT JOIN
    BestBagCTE bb ON bb.PROCOD = p1.codigoProduto
LEFT JOIN
    bb.SIBD2.dbo.ultimas_vendas uv_bb ON uv_bb.codigoProduto = p1.codigoProduto
LEFT JOIN
    MisaspelCTE mis ON mis.PROCOD = p1.codigoProduto
LEFT JOIN
    mi.SIBD3.dbo.ultimas_vendas uv_mis ON uv_mis.codigoProduto = p1.codigoProduto
LEFT JOIN
    PapelynaCTE pp ON pp.PROCOD = p1.codigoProduto
LEFT JOIN
    pp.SIBD.dbo.ultimas_vendas uv_pp ON uv_pp.codigoProduto = p1.codigoProduto
LEFT JOIN
    TanbyTaubateCTE tt ON tt.PROCOD = p1.codigoProduto
LEFT JOIN
    tt.SIBD.dbo.ultimas_vendas uv_tt ON uv_tt.codigoProduto = p1.codigoProduto
LEFT JOIN
    WinpackCTE wp ON wp.PROCOD = p1.codigoProduto
LEFT JOIN
    wp.SIBD4.dbo.ultimas_vendas uv_wp ON uv_wp.codigoProduto = p1.codigoProduto;




---------------------------

-- melhorias com chatgpt

-- últimas vendas de cada unidade

select count(*) -- 37438
  from ultimas_vendas

if object_id('ultimas_vendas') is not null
    begin
    	drop table ultimas_vendas
    end;

WITH UltimasVendasCTE AS (
    SELECT 
        [data],
        codigoProduto,
        ROW_NUMBER() OVER (PARTITION BY codigoProduto ORDER BY [data] DESC, hora DESC) AS RowNum
    FROM 
        DWVendas with (nolock)
    WHERE 
        [data] <= GETDATE() - 1
        AND cancelado = 'N'
        AND numeroSerieDocumento != 3
        AND codigoCliente NOT IN (SELECT codigo FROM #grupo)
)
SELECT 
    [data],
    codigoProduto
INTO 
    ultimas_vendas
FROM 
    UltimasVendasCTE
WHERE 
    RowNum = 1;

-- checar duplicidade

select codigoProduto
       ,count(*)
  from ultimas_vendas
 group by codigoProduto
having count(*) > 1

-- produto únicos entre as unidades

declare @data as date
set @data = '20231231'

BEGIN TRY
    BEGIN TRANSACTION;

    -- Se a tabela temporária existir, remova-a
    IF OBJECT_ID('tempdb.dbo.#produtos') IS NOT NULL
        DROP TABLE #produtos;

    -- Criação da tabela temporária e inserção de dados
    SELECT codigoProduto
    INTO #produtos
    FROM (
        SELECT codigoProduto FROM ultimas_vendas WITH (NOLOCK) where [data] <= @data
        UNION
        SELECT codigoProduto FROM bb.SIBD2.dbo.ultimas_vendas WITH (NOLOCK) where [data] <= @data
        UNION
        SELECT codigoProduto FROM mi.SIBD3.dbo.ultimas_vendas WITH (NOLOCK) where [data] <= @data
        UNION
        SELECT codigoProduto FROM pp.SIBD.dbo.ultimas_vendas WITH (NOLOCK) where [data] <= @data
        UNION
        SELECT codigoProduto FROM tt.SIBD.dbo.ultimas_vendas WITH (NOLOCK) where [data] <= @data
        UNION
        SELECT codigoProduto FROM wp.SIBD4.dbo.ultimas_vendas WITH (NOLOCK) where [data] <= @data
    ) AS Produtos;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;

-- últimas vendas do grupo todo

-- Se a tabela temporária existir, remova-a
IF OBJECT_ID('ultimas_vendas_grupo') IS NOT NULL
BEGIN
    DROP TABLE ultimas_vendas_grupo;
END;

-- CTE para obter os produtos
WITH ProdutosCTE AS (
    SELECT codigoProduto
    FROM #produtos
),

-- CTE para obter os dados de TBS032 de diferentes fontes
TBS032CTE AS (
    SELECT 
        PROCOD,
        ESTLOC,
        SUM(ISNULL(ESTQTDATU - ESTQTDRES, 0)) AS ESTQTD
    FROM (
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM TBS032 with (nolock) where ESTLOC in (1,2)
        UNION ALL
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM bb.SIBD2.dbo.TBS032 with (nolock) where ESTLOC = 2
        UNION ALL
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM mi.SIBD3.dbo.TBS032 with (nolock) where ESTLOC = 1
        UNION ALL
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM pp.SIBD.dbo.TBS032 with (nolock) where ESTLOC = 1
        UNION ALL
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM tt.SIBD.dbo.TBS032 with (nolock) where ESTLOC in (1,2)
        UNION ALL
        SELECT PROCOD, ESTLOC, ESTQTDATU, ESTQTDRES FROM wp.SIBD4.dbo.TBS032 with (nolock) where ESTLOC = 1
    ) AS AllTBS032
    GROUP BY PROCOD, ESTLOC
),

-- CTE para obter os dados de ultimas_vendas de diferentes fontes
UltimasVendasCTE AS (
    SELECT 
        codigoProduto,
        [data]
    FROM (
        SELECT codigoProduto, [data] FROM ultimas_vendas with (nolock)
        UNION ALL
        SELECT codigoProduto, [data] FROM bb.SIBD2.dbo.ultimas_vendas with (nolock)
        UNION ALL
        SELECT codigoProduto, [data] FROM mi.SIBD3.dbo.ultimas_vendas with (nolock)
        UNION ALL
        SELECT codigoProduto, [data] FROM pp.SIBD.dbo.ultimas_vendas with (nolock)
        UNION ALL
        SELECT codigoProduto, [data] FROM tt.SIBD.dbo.ultimas_vendas with (nolock)
        UNION ALL
        SELECT codigoProduto, [data] FROM wp.SIBD4.dbo.ultimas_vendas with (nolock)
    ) AS AllUltimasVendas
)

-- CTE final para combinar todas as informações
SELECT 
    p.codigoProduto AS codigo,
    p2.PRODES AS descricao,
    m.MARNOM AS marca,
    SUM(CASE WHEN t.ESTLOC IN (1,2) THEN t.ESTQTD ELSE 0 END) AS tanby_sjc,
    MAX(u.data) AS data_sjc,
    SUM(CASE WHEN t.ESTLOC = 2 THEN t.ESTQTD ELSE 0 END) AS best_bag,
    MAX(u2.data) AS data_bb,
    SUM(CASE WHEN t.ESTLOC = 1 THEN t.ESTQTD ELSE 0 END) AS misaspel,
    MAX(u3.data) AS data_mis,
    SUM(CASE WHEN t.ESTLOC = 1 THEN t.ESTQTD ELSE 0 END) AS papelyna,
    MAX(u4.data) AS data_py,
    SUM(CASE WHEN t.ESTLOC IN (1,2) THEN t.ESTQTD ELSE 0 END) AS tanby_taubate,
    MAX(u5.data) AS data_tt,
    SUM(CASE WHEN t.ESTLOC = 1 THEN t.ESTQTD ELSE 0 END) AS winpack,
    MAX(u6.data) AS data_wp
INTO ultimas_vendas_grupo
FROM 
    ProdutosCTE p
JOIN 
    TBS010 p2 with (nolock) ON p2.PROCOD = p.codigoProduto
JOIN 
    TBS014 m with (nolock) ON m.MARCOD = p2.MARCOD
LEFT JOIN 
    TBS032CTE t ON t.PROCOD = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u ON u.codigoProduto = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u2 ON u2.codigoProduto = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u3 ON u3.codigoProduto = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u4 ON u4.codigoProduto = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u5 ON u5.codigoProduto = p.codigoProduto
LEFT JOIN 
    UltimasVendasCTE u6 ON u6.codigoProduto = p.codigoProduto
GROUP BY
    p.codigoProduto, p2.PRODES, m.MARNOM;

-- consultar as vendas do grupo

declare @data as date
set @data = '20231231'

select *
  from ultimas_vendas_grupo with (nolock)
 where data_sjc <= @data
       and data_bb <= @data
       and data_mis <= @data
       and data_py <= @data
       and data_tt <= @data
       --and data_wp <= @data
       and (tanby_sjc > 0 or best_bag > 0 or misaspel > 0 or papelyna > 0 or tanby_taubate > 0) -- or winpack > 0)

select top(10) *
  from ultimas_vendas

select top(1000) *
  from ultimas_vendas_grupo


-- tabelas de estoque de cada unidade do grupo

select top(10)
       *
  from TBS032 with (nolock)

IF OBJECT_ID('tempdb..#estoque_nd', 'U') IS NOT NULL
    DROP TABLE #estoque_nd;

select PROCOD as codigo
       ,PRODES as descricao
       ,PROSTATUS as status
       ,ESTQTDATU  as quantidade
  into #estoque_nd
  from TBS032 with (nolock)
 where ESTLOC in(1,2)
       and ESTQTDATU > 0

IF OBJECT_ID('tempdb..#estoque_nd', 'U') IS NOT NULL
    DROP TABLE #estoque_nd;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       [1] AS quantidade_estoque,
       [2] AS quantidade_loja
INTO #estoque_nd
FROM (
    SELECT PROCOD,
           PRODES,
           PROSTATUS,
           ESTLOC,
           ESTQTDATU
    FROM TBS032 WITH (NOLOCK)
    WHERE ESTLOC IN (1, 2)
          AND ESTQTDATU > 0
) AS SourceTable
PIVOT (
    SUM(ESTQTDATU)
    FOR ESTLOC IN ([1], [2])
) AS PivotTable;

select *
  from #estoque_nd

IF OBJECT_ID('tempdb..#estoque_bb', 'U') IS NOT NULL
    DROP TABLE #estoque_bb;

select PROCOD
       ,PRODES
       ,PROSTATUS
  into #estoque_BB
  from bb.SIBD2.dbo.TBS032 with (nolock)

select [data]
       ,codigoProduto
  into #ultimas_vendas_mi
  from pp.SIBD3.dbo.ultimas_vendas with (nolock)

select [data]
       ,codigoProduto
  into #ultimas_vendas_py
  from pp.SIBD.dbo.ultimas_vendas with (nolock)

select [data]
       ,codigoProduto
  into #ultimas_vendas_tt
  from tt.SIBD.dbo.ultimas_vendas with (nolock)

select [data]
       ,codigoProduto
  into #ultimas_vendas_wp
  from pp.SIBD4.dbo.ultimas_vendas with (nolock)

select *
  from #estoque_nd
 where PROCOD = '1640054'

-- agrupamento dos produtos

IF OBJECT_ID('tempdb..#produtos', 'U') IS NOT NULL
    DROP TABLE #produtos;

WITH TodasVendas AS (
    SELECT DISTINCT codigoProduto FROM (
        SELECT codigoProduto FROM #ultimas_vendas_nd
        UNION ALL
        SELECT codigoProduto FROM #ultimas_vendas_bb
        UNION ALL
        SELECT codigoProduto FROM #ultimas_vendas_mi
        UNION ALL
        SELECT codigoProduto FROM #ultimas_vendas_py
        UNION ALL
        SELECT codigoProduto FROM #ultimas_vendas_tt
        UNION ALL
        SELECT codigoProduto FROM #ultimas_vendas_wp
    ) AS todas
)
SELECT codigoProduto
INTO #produtos
FROM TodasVendas;


-- últimas vendas do grupo todo

IF OBJECT_ID('ultimas_vendas_grupo', 'U') IS NOT NULL
    DROP TABLE ultimas_vendas_grupo;

CREATE TABLE ultimas_vendas_grupo (
    codigoProduto INT,
    data_nd DATE,
    data_bb DATE,
    data_mi DATE,
    data_py DATE,
    data_tt DATE,
    data_wp DATE
);

INSERT INTO ultimas_vendas_grupo (codigoProduto, data_nd, data_bb, data_mi, data_py, data_tt, data_wp)
SELECT 
    nd.codigoProduto,
    nd.data AS data_nd,
    bb.data AS data_bb,
    mi.data AS data_mi,
    py.data AS data_py,
    tt.data AS data_tt,
    wp.data AS data_wp
FROM
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_nd GROUP BY codigoProduto) AS nd
LEFT JOIN
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_bb GROUP BY codigoProduto) AS bb
ON nd.codigoProduto = bb.codigoProduto
LEFT JOIN
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_mi GROUP BY codigoProduto) AS mi
ON nd.codigoProduto = mi.codigoProduto
LEFT JOIN
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_py GROUP BY codigoProduto) AS py
ON nd.codigoProduto = py.codigoProduto
LEFT JOIN
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_tt GROUP BY codigoProduto) AS tt
ON nd.codigoProduto = tt.codigoProduto
LEFT JOIN
    (SELECT codigoProduto, MAX([data]) AS data FROM #ultimas_vendas_wp GROUP BY codigoProduto) AS wp
ON nd.codigoProduto = wp.codigoProduto;

select *
  from ultimas_vendas_grupo with (nolock)



-- atualiza os dados

UPDATE TBS032
SET TBS032.PRODES = TBS010.PRODES,
    TBS032.PROSTATUS = TBS010.PROSTATUS,
    TBS032.MARCOD = TBS010.MARCOD
FROM TBS032 with (nolock)
JOIN TBS010 with (nolock) ON TBS032.PROCOD = TBS010.PROCOD;



-- winpack

IF OBJECT_ID('tempdb..#estoque_wp', 'U') IS NOT NULL
    DROP TABLE #estoque_wy;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL(sum(ESTQTDATU), 0) AS quantidade
INTO #estoque_wy
  from pp.SIBD.dbo.TBS032 with (nolock)
    WHERE ESTLOC = 1
          AND ESTQTDATU > 0
 group by PROCOD
          ,PRODES
          ,PROSTATUS

select *
  from #estoque_nd


-- Criar a tabela ultimas_vendas_grupo, caso não exista
IF OBJECT_ID('ultimas_vendas_grupo', 'U') IS not NULL
BEGIN
    drop table ultimas_vendas_grupo
    CREATE TABLE ultimas_vendas_grupo (
        codigoProduto varchar(10),
        descricao VARCHAR(60),
        status CHAR(1),
        quantidade_estoque INT,
        quantidade_loja INT
    );
END

-- Inserir dados da tabela #estoque_nd em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade_estoque, quantidade_loja)
SELECT codigo, descricao, status, quantidade_estoque, quantidade_loja
FROM #estoque_nd;

-- Inserir dados da tabela #estoque_bb em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade_loja)
SELECT codigo, descricao, status, quantidade
FROM #estoque_bb;

-- Inserir dados da tabela #estoque_mi em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade)
SELECT codigo, descricao, status, quantidade
FROM #estoque_mi;

-- Inserir dados da tabela #estoque_py em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade)
SELECT codigo, descricao, status, quantidade
FROM #estoque_py;

-- Inserir dados da tabela #estoque_tt em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade_estoque, quantidade_loja)
SELECT codigo, descricao, status, quantidade_estoque, quantidade_loja
FROM #estoque_tt;

-- Inserir dados da tabela #estoque_wy em ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade)
SELECT codigo, descricao, status, quantidade
FROM #estoque_wy;

-- Limpar as tabelas temporárias
DROP TABLE IF EXISTS #estoque_nd;
DROP TABLE IF EXISTS #estoque_bb;
DROP TABLE IF EXISTS #estoque_mi;
DROP TABLE IF EXISTS #estoque_py;
DROP TABLE IF EXISTS #estoque_tt;
DROP TABLE IF EXISTS #estoque_wy;




-- Criar a tabela ultimas_vendas_grupo, caso não exista
IF OBJECT_ID('ultimas_vendas_grupo', 'U') IS NULL
BEGIN
    CREATE TABLE ultimas_vendas_grupo (
        codigoProduto INT,
        descricao NVARCHAR(MAX),
        status NVARCHAR(MAX),
        quantidade_estoque INT,
        quantidade_loja INT
    );
END
ELSE
BEGIN
    -- Se a tabela já existir, limpar seus dados
    DELETE FROM ultimas_vendas_grupo;
END

-- Inserir os dados agrupados na tabela ultimas_vendas_grupo
INSERT INTO ultimas_vendas_grupo (codigoProduto, descricao, status, quantidade_estoque, quantidade_loja)
SELECT codigoProduto,
       MAX(descricao) AS descricao,
       MAX(status) AS status,
       SUM(quantidade_estoque) AS quantidade_estoque,
       SUM(quantidade_loja) AS quantidade_loja
FROM (
    SELECT codigo AS codigoProduto, descricao, status, quantidade_estoque, quantidade_loja
    FROM #estoque_nd
    UNION ALL
    SELECT codigo, descricao, status, 0, quantidade
    FROM #estoque_bb
    UNION ALL
    SELECT codigo, descricao, status, quantidade, 0
    FROM #estoque_mi
    UNION ALL
    SELECT codigo, descricao, status, quantidade, 0
    FROM #estoque_py
    UNION ALL
    SELECT codigo AS codigoProduto, descricao, status, quantidade_estoque, quantidade_loja
    FROM #estoque_tt
    UNION ALL
    SELECT codigo, descricao, status, 0, quantidade
    FROM #estoque_wy
) AS todas_vendas
GROUP BY codigoProduto;

-- Limpar as tabelas temporárias
DROP TABLE IF EXISTS #estoque_nd;
DROP TABLE IF EXISTS #estoque_bb;
DROP TABLE IF EXISTS #estoque_mi;
DROP TABLE IF EXISTS #estoque_py;
DROP TABLE IF EXISTS #estoque_tt;
DROP TABLE IF EXISTS #estoque_wy;

select *
  from ultimas_vendas_grupo with (nolock)






-- Remover tabela temporária #ultimas_vendas_grupo, se existir
IF OBJECT_ID('tempdb..#ultimas_vendas_grupo', 'U') IS NOT NULL
    DROP TABLE #ultimas_vendas_grupo;

-- Criar tabela temporária #ultimas_vendas_grupo
CREATE TABLE #ultimas_vendas_grupo (
    codigoProduto varchar(10),
    data_nd DATE,
    data_bb DATE,
    data_mi DATE,
    data_py DATE,
    data_tt DATE,
    data_wp DATE,
    quantidade_estoque INT,
    quantidade_loja INT
);

-- Inserir dados nas colunas de data
INSERT INTO #ultimas_vendas_grupo (codigoProduto, data_nd, data_bb, data_mi, data_py, data_tt, data_wp, quantidade_estoque, quantidade_loja)
SELECT
    COALESCE(nd.codigoProduto, bb.codigoProduto, mi.codigoProduto, py.codigoProduto, tt.codigoProduto, wp.codigoProduto) AS codigoProduto,
    nd.data_nd,
    bb.data_bb,
    mi.data_mi,
    py.data_py,
    tt.data_tt,
    wp.data_wp,
    COALESCE(estoque_nd.quantidade_estoque, 0) AS quantidade_estoque,
    COALESCE(estoque_nd.quantidade_loja, 0) AS quantidade_loja
FROM
    (SELECT codigoProduto, MAX(data) AS data_nd FROM #ultimas_vendas_nd GROUP BY codigoProduto) AS nd
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data_bb FROM #ultimas_vendas_bb GROUP BY codigoProduto) AS bb ON nd.codigoProduto = bb.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data_mi FROM #ultimas_vendas_mi GROUP BY codigoProduto) AS mi ON nd.codigoProduto = mi.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data_py FROM #ultimas_vendas_py GROUP BY codigoProduto) AS py ON nd.codigoProduto = py.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data_tt FROM #ultimas_vendas_tt GROUP BY codigoProduto) AS tt ON nd.codigoProduto = tt.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data_wp FROM #ultimas_vendas_wp GROUP BY codigoProduto) AS wp ON nd.codigoProduto = wp.codigoProduto
FULL JOIN
    (SELECT codigo, quantidade_estoque, quantidade_loja FROM #estoque_nd) AS estoque_nd ON nd.codigoProduto = estoque_nd.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_bb) AS estoque_bb ON nd.codigoProduto = estoque_bb.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_mi) AS estoque_mi ON nd.codigoProduto = estoque_mi.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_py) AS estoque_py ON nd.codigoProduto = estoque_py.codigo
FULL JOIN
    (SELECT codigo, quantidade_estoque, quantidade_loja FROM #estoque_tt) AS estoque_tt ON nd.codigoProduto = estoque_tt.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_wy) AS estoque_wy ON nd.codigoProduto = estoque_wy.codigo;

-- Verificar se a tabela foi criada e populada corretamente
SELECT * FROM #ultimas_vendas_grupo;

-- Remover tabelas temporárias
DROP TABLE IF EXISTS #ultimas_vendas_grupo;
DROP TABLE IF EXISTS #estoque_nd;
DROP TABLE IF EXISTS #estoque_bb;
DROP TABLE IF EXISTS #estoque_mi;
DROP TABLE IF EXISTS #estoque_py;
DROP TABLE IF EXISTS #estoque_tt;
DROP TABLE IF EXISTS #estoque_wy;





-- Remover tabela temporária #ultimas_vendas_grupo, se existir
IF OBJECT_ID('tempdb..#ultimas_vendas_grupo', 'U') IS NOT NULL
    DROP TABLE #ultimas_vendas_grupo;

-- Criar tabela temporária #ultimas_vendas_grupo
CREATE TABLE #ultimas_vendas_grupo (
    codigoProduto varchar(10),
    data_nd DATE,
    data_bb DATE,
    data_mi DATE,
    data_py DATE,
    data_tt DATE,
    data_wp DATE,
    quantidade_estoque_nd INT,
    quantidade_loja_nd INT,
    quantidade_estoque_bb INT,
    quantidade_loja_bb INT,
    quantidade_estoque_mi INT,
    quantidade_loja_mi INT,
    quantidade_estoque_py INT,
    quantidade_loja_py INT,
    quantidade_estoque_tt INT,
    quantidade_loja_tt INT,
    quantidade_estoque_wp INT,
    quantidade_loja_wp INT
);

-- Inserir dados nas colunas de data e estoque
INSERT INTO #ultimas_vendas_grupo (
    codigoProduto,
    data_nd,
    data_bb,
    data_mi,
    data_py,
    data_tt,
    data_wp,
    quantidade_estoque_nd,
    quantidade_loja_nd,
    quantidade_estoque_bb,
    quantidade_loja_bb,
    quantidade_estoque_mi,
    quantidade_loja_mi,
    quantidade_estoque_py,
    quantidade_loja_py,
    quantidade_estoque_tt,
    quantidade_loja_tt,
    quantidade_estoque_wp,
    quantidade_loja_wp
)
SELECT
    COALESCE(nd.codigoProduto, bb.codigoProduto, mi.codigoProduto, py.codigoProduto, tt.codigoProduto, wp.codigoProduto) AS codigoProduto,
    MAX(nd.data) AS data_nd,
    MAX(bb.data) AS data_bb,
    MAX(mi.data) AS data_mi,
    MAX(py.data) AS data_py,
    MAX(tt.data) AS data_tt,
    MAX(wp.data) AS data_wp,
    COALESCE(estoque_nd.quantidade_estoque, 0) AS quantidade_estoque_nd,
    COALESCE(estoque_nd.quantidade_loja, 0) AS quantidade_loja_nd,
    COALESCE(estoque_bb.quantidade, 0) AS quantidade_estoque_bb,
    0 AS quantidade_loja_bb,
    COALESCE(estoque_mi.quantidade, 0) AS quantidade_estoque_mi,
    0 AS quantidade_loja_mi,
    COALESCE(estoque_py.quantidade, 0) AS quantidade_estoque_py,
    0 AS quantidade_loja_py,
    COALESCE(estoque_tt.quantidade_estoque, 0) AS quantidade_estoque_tt,
    COALESCE(estoque_tt.quantidade_loja, 0) AS quantidade_loja_tt,
    COALESCE(estoque_wy.quantidade, 0) AS quantidade_estoque_wp,
    0 AS quantidade_loja_wp
FROM
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_nd GROUP BY codigoProduto) AS nd
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_bb GROUP BY codigoProduto) AS bb ON nd.codigoProduto = bb.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_mi GROUP BY codigoProduto) AS mi ON nd.codigoProduto = mi.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_py GROUP BY codigoProduto) AS py ON nd.codigoProduto = py.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_tt GROUP BY codigoProduto) AS tt ON nd.codigoProduto = tt.codigoProduto
FULL JOIN
    (SELECT codigoProduto, MAX(data) AS data FROM #ultimas_vendas_wp GROUP BY codigoProduto) AS wp ON nd.codigoProduto = wp.codigoProduto
FULL JOIN
    (SELECT codigo, quantidade_estoque, quantidade_loja FROM #estoque_nd) AS estoque_nd ON nd.codigoProduto = estoque_nd.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_bb) AS estoque_bb ON nd.codigoProduto = estoque_bb.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_mi) AS estoque_mi ON nd.codigoProduto = estoque_mi.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_py) AS estoque_py ON nd.codigoProduto = estoque_py.codigo
FULL JOIN
    (SELECT codigo, quantidade_estoque, quantidade_loja FROM #estoque_tt) AS estoque_tt ON nd.codigoProduto = estoque_tt.codigo
FULL JOIN
    (SELECT codigo, quantidade FROM #estoque_wy) AS estoque_wy ON nd.codigoProduto = estoque_wy.codigo
GROUP BY
    COALESCE(nd.codigoProduto, bb.codigoProduto, mi.codigoProduto, py.codigoProduto, tt.codigoProduto, wp.codigoProduto),
    estoque_nd.quantidade_estoque,
    estoque_nd.quantidade_loja,
    estoque_bb.quantidade,
    estoque_mi.quantidade,
    estoque_py.quantidade,
    estoque_tt.quantidade_estoque,
    estoque_tt.quantidade_loja,
    estoque_wy.quantidade;

-- Verificar se a tabela foi criada e populada corretamente
SELECT * FROM #ultimas_vendas_grupo;

-- Remover tabelas temporárias
DROP TABLE IF EXISTS #ultimas_vendas_grupo;
DROP TABLE IF EXISTS #estoque_nd;
DROP TABLE IF EXISTS #estoque_bb;
DROP TABLE IF EXISTS #estoque_mi;
DROP TABLE IF EXISTS #estoque_py;
DROP TABLE IF EXISTS #estoque_tt;
DROP TABLE IF EXISTS #estoque_wy;







select *
  from ultimas_vendas_grupo
 where codigo = '8407293'



-- produtos sem vendas até uma determinada data

declare @data as date
set @data = '20230331'
/*
select *
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where data_nd <= @data
       and data_bb <= @data
       and data_mi <= @data
       and data_py <= @data
       and data_tt <= @data
       and data_wp <= @data
       and (estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt) > 0
*/
if object_id('tempdb..#consulta_pro', 'U') IS NOT NULL
    drop table #consulta_pro;

select codigo
  into #consulta_pro
  from ultimas_vendas_grupo with (nolock)
 where (data_nd > @data
       or data_bb > @data
       or data_mi > @data
       or data_py > @data
       or data_tt > @data
       or data_wp > @data)
       and (estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt) > 0

select *
  from #consulta_pro

-- produtos sem vendas até uma determinada data na tanby matriz, mas que vendeu em outra unidade

declare @data as date
set @data = '20230331'

select (select PROLOCFIS from TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where data_nd <= @data
       and estoque_mais_loja_nd > 0
       and codigo in (select codigo from #consulta_pro)

-- tabela CEST integros

select *
  from TBS123 with (nolock)







-- empresas do grupo

BEGIN TRY
    BEGIN TRANSACTION;
    
    IF OBJECT_ID('tempdb..#grupo') IS NOT NULL
        DROP TABLE #grupo;
    
    CREATE TABLE #grupo (codigo INT);
    
    INSERT INTO #grupo
    EXEC sp_ClientesGrupo;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT 
        @ErrorMessage = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;

-- últimas vendas nas unidades do grupo

if object_id('ultimas_vendas') is not null
    begin
    	drop table ultimas_vendas
    end;

WITH UltimasVendasCTE AS (
    SELECT 
        [data],
        codigoProduto,
        ROW_NUMBER() OVER (PARTITION BY codigoProduto ORDER BY [data] DESC, hora DESC) AS RowNum
    FROM 
        DWVendas with (nolock)
    WHERE 
        [data] <= GETDATE() - 1
        AND cancelado = 'N'
        AND numeroSerieDocumento != 3
        AND codigoCliente NOT IN (SELECT codigo FROM #grupo)
)
SELECT 
    [data],
    codigoProduto
INTO 
    ultimas_vendas
FROM 
    UltimasVendasCTE
WHERE 
    RowNum = 1;

-- checar duplicidade

select codigoProduto
       ,count(*)
  from ultimas_vendas
 group by codigoProduto
having count(*) > 1

select *
  from ultimas_vendas
 where codigoProduto = '1495992'
 
-- tabelas de vendas de cada unidade do grupo

select [data]
       ,codigoProduto
  into #ultimas_vendas_nd
  from ultimas_vendas with (nolock);

select [data]
       ,codigoProduto
  into #ultimas_vendas_bb
  from bb.SIBD2.dbo.ultimas_vendas with (nolock);

select [data]
       ,codigoProduto
  into #ultimas_vendas_mi
  from pp.SIBD3.dbo.ultimas_vendas with (nolock);

select [data]
       ,codigoProduto
  into #ultimas_vendas_py
  from pp.SIBD.dbo.ultimas_vendas with (nolock);

select [data]
       ,codigoProduto
  into #ultimas_vendas_tt
  from tt.SIBD.dbo.ultimas_vendas with (nolock);

select [data]
       ,codigoProduto
  into #ultimas_vendas_wp
  from pp.SIBD4.dbo.ultimas_vendas with (nolock);

-- quantidades em estoque

-- tanby matriz

IF OBJECT_ID('tempdb..#estoque_nd', 'U') IS NOT NULL
    DROP TABLE #estoque_nd;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL([1], 0) AS quantidade_estoque,
       ISNULL([2], 0) AS quantidade_loja
INTO #estoque_nd
FROM (
    SELECT PROCOD,
           PRODES,
           PROSTATUS,
           ESTLOC,
           ISNULL(ESTQTDATU, 0) AS ESTQTDATU
    FROM TBS032 WITH (NOLOCK)
    WHERE ESTLOC IN (1, 2)
          AND ESTQTDATU > 0
) AS SourceTable
PIVOT (
    SUM(ESTQTDATU)
    FOR ESTLOC IN ([1], [2])
) AS PivotTable;

-- best bag

IF OBJECT_ID('tempdb..#estoque_bb', 'U') IS NOT NULL
    DROP TABLE #estoque_bb;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL(sum(ESTQTDATU), 0) AS quantidade
INTO #estoque_bb
  from bb.SIBD2.dbo.TBS032 with (nolock)
    WHERE ESTLOC = 2
          AND ESTQTDATU > 0
 group by PROCOD
          ,PRODES
          ,PROSTATUS;

-- misaspel

IF OBJECT_ID('tempdb..#estoque_mi', 'U') IS NOT NULL
    DROP TABLE #estoque_mi;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL(sum(ESTQTDATU), 0) AS quantidade
INTO #estoque_mi
  from pp.SIBD3.dbo.TBS032 with (nolock)
    WHERE ESTLOC = 1
          AND ESTQTDATU > 0
 group by PROCOD
          ,PRODES
          ,PROSTATUS;

-- papelyna

IF OBJECT_ID('tempdb..#estoque_py', 'U') IS NOT NULL
    DROP TABLE #estoque_py;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL(sum(ESTQTDATU), 0) AS quantidade
INTO #estoque_py
  from pp.SIBD.dbo.TBS032 with (nolock)
    WHERE ESTLOC = 1
          AND ESTQTDATU > 0
 group by PROCOD
          ,PRODES
          ,PROSTATUS;

-- tanby taubaté

IF OBJECT_ID('tempdb..#estoque_tt', 'U') IS NOT NULL
    DROP TABLE #estoque_tt;

SELECT PROCOD AS codigo,
       PRODES AS descricao,
       PROSTATUS AS status,
       ISNULL([1], 0) AS quantidade_estoque,
       ISNULL([2], 0) AS quantidade_loja
INTO #estoque_tt
FROM (
    SELECT PROCOD,
           PRODES,
           PROSTATUS,
           ESTLOC,
           ISNULL(ESTQTDATU, 0) AS ESTQTDATU
    FROM tt.SIBD.dbo.TBS032 WITH (NOLOCK)
    WHERE ESTLOC IN (1, 2)
          AND ESTQTDATU > 0
) AS SourceTable
PIVOT (
    SUM(ESTQTDATU)
    FOR ESTLOC IN ([1], [2])
) AS PivotTable;

-- produtos da tanby matriz (base dos produtos)

if object_id('tempdb..#produtos', 'U') is not null
   drop table #produtos;

select p.PROCOD as codigo
       ,p.PRODES as descricao
       ,p.PROSTATUS as 'status'
       ,(select MARNOM from TBS014 m with (nolock) where m.MARCOD=p.MARCOD) as marca
       ,p.PRODATCAD as cadastro
  into #produtos
  from TBS010 p with (nolock);

select *
  from #produtos

-- checar duplicidade

select codigo
       ,count(*)
  from #produtos
 group by codigo
having count(*) > 1

-- tabelas temporárias últimas vendas do grupo

IF OBJECT_ID('tempdb..#ultimas_vendas_grupo', 'U') IS NOT NULL
    DROP TABLE #ultimas_vendas_grupo;

if object_id('ultimas_vendas_grupo', 'U') IS NOT NULL
    drop table ultimas_vendas_grupo;

select p.*
       ,isnull(nd.[data],'17530101') as data_nd
       ,isnull(bb.[data],'17530101') as data_bb
       ,isnull(mi.[data],'17530101') as data_mi
       ,isnull(py.[data],'17530101') as data_py
       ,isnull(tt.[data],'17530101') as data_tt
       ,isnull(wp.[data],'17530101') as data_wp
       ,isnull(e_nd.quantidade_estoque,0) as estoque_nd
       ,isnull(e_nd.quantidade_loja,0) as loja_nd
       ,isnull(e_nd.quantidade_estoque + e_nd.quantidade_loja,0) as estoque_mais_loja_nd
       ,isnull(e_bb.quantidade,0) as qtde_bb
       ,isnull(e_mi.quantidade,0) as qtde_mi
       ,isnull(e_py.quantidade,0) as qtde_py
       ,isnull(e_tt.quantidade_estoque,0) as estoque_tt
       ,isnull(e_tt.quantidade_loja,0) as loja_tt
       ,isnull(e_tt.quantidade_estoque + e_tt.quantidade_loja,0) as estoque_mais_loja_tt
  into ultimas_vendas_grupo
  from #produtos p
  Left join #ultimas_vendas_nd nd
    on nd.codigoProduto = p.codigo
  Left join #ultimas_vendas_bb bb
    on bb.codigoProduto = p.codigo
  Left join #ultimas_vendas_mi mi
    on mi.codigoProduto = p.codigo
  Left join #ultimas_vendas_py py
    on py.codigoProduto = p.codigo
  Left join #ultimas_vendas_tt tt
    on tt.codigoProduto = p.codigo
  Left join #ultimas_vendas_wp wp
    on wp.codigoProduto = p.codigo
  Left join #estoque_nd e_nd
    on e_nd.codigo = p.codigo
  Left join #estoque_bb e_bb
    on e_bb.codigo = p.codigo
  Left join #estoque_mi e_mi
    on e_mi.codigo = p.codigo
  Left join #estoque_py e_py
    on e_py.codigo = p.codigo
  Left join #estoque_tt e_tt
    on e_tt.codigo = p.codigo

-- checar duplicidade

select codigo
       ,count(*)
  from ultimas_vendas_grupo
 group by codigo
having count(*) > 1

select *
  from ultimas_vendas_grupo
 where codigo = '0470578'

-- produtos sem vendas até uma determinada data

declare @data as date
set @data = '20230930'

select *
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where data_nd <= @data
       and data_bb <= @data
       and data_mi <= @data
       and data_py <= @data
       and data_tt <= @data
       and data_wp <= @data
       and cadastro <= @data
       and (estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt) > 0

-- produtos sem vendas até uma determinada data, com saldo em estoque, mas que vendeu em outra unidade

declare @data as date
set @data = '20230930'

if object_id('tempdb..#consulta_pro', 'U') IS NOT NULL
    drop table #consulta_pro;

select codigo
  into #consulta_pro
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data --(
       and estoque_mais_loja_nd > 0
       --and qtde_bb > 0
       --and qtde_mi > 0
       --and qtde_py > 0
       --and estoque_mais_loja_tt > 0
       and (estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt) > 0
       and data_nd <= @data
       --and data_bb <= @data
       --and data_mi <= @data
       --and data_py <= @data
       --and data_tt <= @data
       --and data_wp <= @data 
       and ( 
             --data_nd > @data or
             data_bb > @data or
             data_mi > @data or
             data_py > @data or
             data_tt > @data or
             data_wp > @data
           )

select *
  from #consulta_pro

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where data_nd <= @data
       and estoque_mais_loja_nd > 0
       and codigo in (select codigo from #consulta_pro)

-- tanby matriz

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data
       and data_nd <= @data
       and estoque_mais_loja_nd > 0
       and ( 
             --data_nd > @data or
             data_bb > @data or
             data_mi > @data or
             data_py > @data or
             data_tt > @data or
             data_wp > @data
           )       

-- best bag

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from bb.SIBD2.dbo.TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data
       and data_bb <= @data
       and qtde_bb > 0
       and ( 
             data_nd > @data or
             data_mi > @data or
             data_py > @data or
             data_tt > @data or
             data_wp > @data
           )       

-- misaspel

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from mi.SIBD3.dbo.TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data
       and data_mi <= @data
       and qtde_mi > 0
       and ( 
             data_bb > @data or
             data_nd > @data or
             data_py > @data or
             data_tt > @data or
             data_wp > @data
           )       

-- papelyna

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from pp.SIBD.dbo.TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data
       and data_py <= @data
       and qtde_py > 0
       and ( 
             data_bb > @data or
             data_nd > @data or
             data_mi > @data or
             data_tt > @data or
             data_wp > @data
           )       

-- tanby taubaté

declare @data as date
set @data = '20230930'

select (select PROLOCFIS from tt.SIBD.dbo.TBS010 with (nolock) where PROCOD=codigo) as localizacao
       ,*
       ,estoque_mais_loja_nd + qtde_bb + qtde_mi + qtde_py + estoque_mais_loja_tt as qtde_total
  from ultimas_vendas_grupo with (nolock)
 where cadastro <= @data
       and data_tt <= @data
       and estoque_mais_loja_tt > 0
       and ( 
             data_bb > @data or
             data_nd > @data or
             data_mi > @data or
             data_py > @data or
             data_wp > @data
           )       


SELECT 
    name AS Nome_Tabela,
    create_date AS Data_Criacao,
    modify_date AS Ultima_Modificacao
FROM sys.objects
WHERE type = 'U'  -- 'U' significa tabelas do usuário
  AND name = 'ultimas_vendas_bkp';  -- Substitua pelo nome da sua tabela

select *
  from ultimas_vendas with (nolock)




-- UTILIZADOS

-- códigos dos clientes "grupo"

if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_ClientesGrupo 1

select *
  from #grupo

/*
if object_id('ultimas_vendas') is not null
    begin
    	drop table ultimas_vendas
    end

select dw1.[data]
       ,dw1.codigoProduto
  into ultimas_vendas
  from DWVendas dw1 with (nolock) -- best bag
 where dw1.[data] <= getdate() - 1 -- '20240331'
       and dw1.cancelado='N'
       and dw1.numeroSerieDocumento != 3
       and dw1.codigoCliente not in (select codigo from #grupo)
       and convert(datetime,convert(char(10),[data])+'T'+hora) = (
                          select top(1) convert(datetime,convert(char(10),[data])+'T'+hora)
                            --from tt.SIBD.dbo.DWVendas dw2  with (nolock) -- taubaté
                            --from DWVendas dw2  with (nolock) -- sjc
                            from DWVendas dw2  with (nolock) -- best bag
                           where dw2.cancelado='N'
                                 and dw2.numeroSerieDocumento != 3
                                 and dw2.codigoCliente not in(select codigo from #grupo)
                                 and dw2.codigoProduto=dw1.codigoProduto
                           order by convert(datetime,convert(char(10),[data])+'T'+hora) desc
                        )
 group by  dw1.[data]
           ,dw1.codigoProduto
*/

-- otimizado gpt

-- últimas vendas de cada unidade do grupo

WITH UltimaVendaProduto AS (
    SELECT 
        dw1.[data],
        dw1.codigoProduto,
        ROW_NUMBER() OVER (
            PARTITION BY dw1.codigoProduto
            ORDER BY CAST(dw1.[data] AS DATETIME) + CAST(dw1.hora AS DATETIME) DESC
        ) AS rn
    FROM DWVendas dw1 WITH (NOLOCK)
    WHERE dw1.[data] <= GETDATE() - 1
      AND dw1.cancelado = 'N'
      AND dw1.numeroSerieDocumento != 3
      AND dw1.codigoCliente NOT IN (SELECT codigo FROM #grupo)
)
SELECT 
    [data],
    codigoProduto
INTO ultimas_vendas
FROM UltimaVendaProduto
WHERE rn = 1;

select *
  from ultimas_vendas with (nolock)

select min([data])
  from ultimas_vendas with (nolock)

select min([data])
  from DWVendas with (nolock)

-- produtos vendidos em cada unidade do grupo e com estoque maior do que zero

IF OBJECT_ID('tempdb.dbo.#produtos') IS NOT NULL
BEGIN
    DROP TABLE #produtos;
END;

SELECT codigoProduto
INTO #produtos
FROM ultimas_vendas WITH (NOLOCK)
WHERE (
          SELECT SUM(ESTQTDATU - ESTQTDRES)
          FROM TBS032 WITH (NOLOCK)
          WHERE ESTLOC IN (1, 2)
            AND PROCOD = '0040001' --codigoProduto
            AND ESTQTDATU - ESTQTDRES > 0
      ) > 0

UNION

SELECT codigoProduto
FROM bb.SIBD2.dbo.ultimas_vendas WITH (NOLOCK)
WHERE (
          SELECT SUM(ESTQTDATU - ESTQTDRES)
          FROM bb.SIBD2.dbo.TBS032 WITH (NOLOCK)
          WHERE ESTLOC = 2
            AND PROCOD = codigoProduto
            AND ESTQTDATU - ESTQTDRES > 0
      ) > 0

UNION

SELECT codigoProduto
FROM mi.SIBD3.dbo.ultimas_vendas WITH (NOLOCK)
WHERE (
          SELECT SUM(ESTQTDATU - ESTQTDRES)
          FROM mi.SIBD3.dbo.TBS032 WITH (NOLOCK)
          WHERE ESTLOC = 1
            AND PROCOD = codigoProduto
            AND ESTQTDATU - ESTQTDRES > 0
      ) > 0

UNION

SELECT codigoProduto
FROM pp.SIBD.dbo.ultimas_vendas WITH (NOLOCK)
WHERE (
          SELECT SUM(ESTQTDATU - ESTQTDRES)
          FROM pp.SIBD.dbo.TBS032 WITH (NOLOCK)
          WHERE ESTLOC = 1
            AND PROCOD = codigoProduto
            AND ESTQTDATU - ESTQTDRES > 0
      ) > 0

UNION

SELECT codigoProduto
FROM tt.SIBD.dbo.ultimas_vendas WITH (NOLOCK)
WHERE (
          SELECT SUM(ESTQTDATU - ESTQTDRES)
          FROM tt.SIBD.dbo.TBS032 WITH (NOLOCK)
          WHERE ESTLOC IN (1, 2)
            AND PROCOD = codigoProduto
            AND ESTQTDATU - ESTQTDRES > 0
      ) > 0;

select *
  from #produtos

-- últimas vendas do grupo

IF OBJECT_ID('ultimas_vendas_grupo') IS NOT NULL
BEGIN
    DROP TABLE ultimas_vendas_grupo;
END;

WITH UltimaVendaCTE AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        ultimas_vendas
    GROUP BY
        codigoProduto
),
UltimaVendaCTE_BB AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        bb.SIBD2.dbo.ultimas_vendas
    GROUP BY
        codigoProduto
),
UltimaVendaCTE_MIS AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        mi.SIBD3.dbo.ultimas_vendas
    GROUP BY
        codigoProduto
),
UltimaVendaCTE_PP AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        pp.SIBD.dbo.ultimas_vendas
    GROUP BY
        codigoProduto
),
UltimaVendaCTE_TT AS (
    SELECT
        codigoProduto,
        MAX([data]) AS ultima_data_venda
    FROM
        tt.SIBD.dbo.ultimas_vendas
    GROUP BY
        codigoProduto
),
TanbySjcCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC IN (1, 2) AND ESTQTDATU - ESTQTDRES > 0 
                 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS tanby_sjc
    FROM
        TBS032
    GROUP BY
        PROCOD
),
TanbyTaubateCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC IN (1, 2) AND ESTQTDATU - ESTQTDRES > 0 
                 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS tanby_taubate
    FROM
        tt.SIBD.dbo.TBS032
    GROUP BY
        PROCOD
),
BestBagCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 2 AND ESTQTDATU - ESTQTDRES > 0 
                 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS best_bag
    FROM
        bb.SIBD2.dbo.TBS032
    GROUP BY
        PROCOD
),
MisaspelCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 1 AND ESTQTDATU - ESTQTDRES > 0 
                 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS misaspel
    FROM
        mi.SIBD3.dbo.TBS032
    GROUP BY
        PROCOD
),
PapelynaCTE AS (
    SELECT
        PROCOD,
        SUM(CASE WHEN ESTLOC = 1 AND ESTQTDATU - ESTQTDRES > 0 
                 THEN ESTQTDATU - ESTQTDRES ELSE 0 END) AS papelyna
    FROM
        pp.SIBD.dbo.TBS032
    GROUP BY
        PROCOD
)
SELECT
    p1.codigoProduto AS codigo,
    p2.PRODES AS descricao,
    m.MARNOM AS marca,
    ISNULL(ts.tanby_sjc, 0) AS tanby_sjc,
    ISNULL(uv_sjc.ultima_data_venda, '1900-01-01') AS data_sjc,
    ISNULL(bb.best_bag, 0) AS best_bag,
    ISNULL(uv_bb.ultima_data_venda, '1900-01-01') AS data_bb,
    ISNULL(mis.misaspel, 0) AS misaspel,
    ISNULL(uv_mis.ultima_data_venda, '1900-01-01') AS data_mis,
    ISNULL(pp.papelyna, 0) AS papelyna,
    ISNULL(uv_pp.ultima_data_venda, '1900-01-01') AS data_pp,
    ISNULL(tt.tanby_taubate, 0) AS tanby_taubate,
    ISNULL(uv_tt.ultima_data_venda, '1900-01-01') AS data_tt,
    g.GRUDES AS grupo,
    s.SUBGRUDES AS subgrupo
INTO
    ultimas_vendas_grupo
FROM
    #produtos p1
INNER JOIN
    TBS010 p2 ON p2.PROCOD = p1.codigoProduto
LEFT JOIN
    TBS014 m ON m.MARCOD = p2.MARCOD
LEFT JOIN
    TBS012 g ON g.GRUCOD = p2.GRUCOD
LEFT JOIN
    TBS0121 s ON s.GRUCOD = p2.GRUCOD and s.SUBGRUCOD = p2.SUBGRUCOD
LEFT JOIN
    UltimaVendaCTE uv_sjc ON uv_sjc.codigoProduto = p1.codigoProduto
LEFT JOIN
    TanbySjcCTE ts ON ts.PROCOD = p1.codigoProduto
LEFT JOIN
    BestBagCTE bb ON bb.PROCOD = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE_BB uv_bb ON uv_bb.codigoProduto = p1.codigoProduto
LEFT JOIN
    MisaspelCTE mis ON mis.PROCOD = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE_MIS uv_mis ON uv_mis.codigoProduto = p1.codigoProduto
LEFT JOIN
    PapelynaCTE pp ON pp.PROCOD = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE_PP uv_pp ON uv_pp.codigoProduto = p1.codigoProduto
LEFT JOIN
    TanbyTaubateCTE tt ON tt.PROCOD = p1.codigoProduto
LEFT JOIN
    UltimaVendaCTE_TT uv_tt ON uv_tt.codigoProduto = p1.codigoProduto;

select *
  from ultimas_vendas_grupo with (nolock)

-- checar duplicidade

select codigo
       ,count(*)
  from ultimas_vendas_grupo
 group by codigo
having count(*) > 1

-- listagem final

-- versão 1

-- se o somatório dos saldos das empresas for maior do que zero
-- e se pelo menos uma das empresas tenha vendido pela última vez antes de 31/12/2025 com ou sem saldo atual

SELECT
    codigo,
    descricao,
    marca,
    tanby_sjc,
    best_bag,
    misaspel,
    papelyna,
    tanby_taubate,
    NULLIF(data_sjc, '1900-01-01') AS data_sjc,
    NULLIF(data_bb, '1900-01-01') AS data_bb,
    NULLIF(data_mis, '1900-01-01') AS data_mis,
    NULLIF(data_pp, '1900-01-01') AS data_pp,
    NULLIF(data_tt, '1900-01-01') AS data_tt
FROM
    ultimas_vendas_grupo
WHERE
    (ISNULL(tanby_sjc, 0) 
    + ISNULL(best_bag, 0) 
    + ISNULL(misaspel, 0) 
    + ISNULL(papelyna, 0) 
    + ISNULL(tanby_taubate, 0)) > 0
    AND (
        (NULLIF(data_sjc, '1900-01-01') IS NOT NULL AND NULLIF(data_sjc, '1900-01-01') < '2023-12-31') OR
        (NULLIF(data_bb, '1900-01-01') IS NOT NULL AND NULLIF(data_bb, '1900-01-01') < '2023-12-31') OR
        (NULLIF(data_mis, '1900-01-01') IS NOT NULL AND NULLIF(data_mis, '1900-01-01') < '2023-12-31') OR
        (NULLIF(data_pp, '1900-01-01') IS NOT NULL AND NULLIF(data_pp, '1900-01-01') < '2023-12-31') OR
        (NULLIF(data_tt, '1900-01-01') IS NOT NULL AND NULLIF(data_tt, '1900-01-01') < '2023-12-31')
    );

-- versão 2

-- somatório maior do que zero
-- e pelo menos uma data da última venda menor ou igual a 31/12/2023

SELECT
    codigo,
    descricao,
    marca,
    tanby_sjc,
    best_bag,
    misaspel,
    papelyna,
    tanby_taubate,
    -- Calcula a última venda válida (desconsiderando 1900-01-01)
    (SELECT MAX(data_venda)
     FROM (
        SELECT NULLIF(data_sjc, '1900-01-01') AS data_venda
        UNION ALL
        SELECT NULLIF(data_bb, '1900-01-01')
        UNION ALL
        SELECT NULLIF(data_mis, '1900-01-01')
        UNION ALL
        SELECT NULLIF(data_pp, '1900-01-01')
        UNION ALL
        SELECT NULLIF(data_tt, '1900-01-01')
     ) AS datas
    ) AS ultima_venda
FROM
    ultimas_vendas_grupo
WHERE
    -- Saldo total maior que zero
    (ISNULL(tanby_sjc, 0) 
    + ISNULL(best_bag, 0) 
    + ISNULL(misaspel, 0) 
    + ISNULL(papelyna, 0) 
    + ISNULL(tanby_taubate, 0)) > 0
    -- Última venda válida menor ou igual a 31/12/2023
    AND (
        SELECT MAX(data_venda)
        FROM (
            SELECT NULLIF(data_sjc, '1900-01-01') AS data_venda
            UNION ALL
            SELECT NULLIF(data_bb, '1900-01-01')
            UNION ALL
            SELECT NULLIF(data_mis, '1900-01-01')
            UNION ALL
            SELECT NULLIF(data_pp, '1900-01-01')
            UNION ALL
            SELECT NULLIF(data_tt, '1900-01-01')
        ) AS datas
    ) <= '2023-12-31';

-- versão 3

-- exibe somente a menor data da última venda em qualquer empresa

SELECT
    codigo,
    descricao,
    marca,
    -- Estoque de cada loja
    tanby_sjc,
    best_bag,
    misaspel,
    papelyna,
    tanby_taubate,
    -- Última venda válida de cada loja (desconsiderando '1900-01-01')
    CASE WHEN tanby_sjc > 0 AND data_sjc <> '1900-01-01' AND data_sjc < '2023-12-31' THEN data_sjc END AS ultima_venda_sjc,
    CASE WHEN best_bag > 0 AND data_bb  <> '1900-01-01' AND data_bb  < '2023-12-31' THEN data_bb  END AS ultima_venda_bb,
    CASE WHEN misaspel > 0 AND data_mis <> '1900-01-01' AND data_mis < '2023-12-31' THEN data_mis END AS ultima_venda_mis,
    CASE WHEN papelyna > 0 AND data_pp  <> '1900-01-01' AND data_pp  < '2023-12-31' THEN data_pp  END AS ultima_venda_pp,
    CASE WHEN tanby_taubate > 0 AND data_tt <> '1900-01-01' AND data_tt < '2023-12-31' THEN data_tt END AS ultima_venda_tt
FROM
    ultimas_vendas_grupo
WHERE
    -- Pelo menos uma loja com saldo > 0 e data válida < 31/12/2023
    ( (tanby_sjc > 0 AND data_sjc <> '1900-01-01' AND data_sjc <= '2023-12-31') OR
      (best_bag > 0 AND data_bb  <> '1900-01-01' AND data_bb  <= '2023-12-31') OR
      (misaspel > 0 AND data_mis <> '1900-01-01' AND data_mis <= '2023-12-31') OR
      (papelyna > 0 AND data_pp  <> '1900-01-01' AND data_pp  <= '2023-12-31') OR
      (tanby_taubate > 0 AND data_tt <> '1900-01-01' AND data_tt <= '2023-12-31')
    );


-- versão 4, versão final

-- se o somatório dos saldos das empresas for maior do que zero
-- e se pelo menos uma das empresas tenha vendido pela última vez antes de 31/12/2023 e tenha saldo em estoque

SELECT
    codigo,
    descricao,
    marca,
    tanby_sjc,
    NULLIF(data_sjc, '1900-01-01') AS data_sjc,
    best_bag,
    NULLIF(data_bb, '1900-01-01') AS data_bb,
    misaspel,
    NULLIF(data_mis, '1900-01-01') AS data_mis,
    papelyna,
    NULLIF(data_pp, '1900-01-01') AS data_pp,
    tanby_taubate,
    NULLIF(data_tt, '1900-01-01') AS data_tt,
    grupo,
    subgrupo
FROM
    ultimas_vendas_grupo
WHERE
    (ISNULL(tanby_sjc, 0) 
    + ISNULL(best_bag, 0) 
    + ISNULL(misaspel, 0) 
    + ISNULL(papelyna, 0) 
    + ISNULL(tanby_taubate, 0)) > 0
    AND (
        (NULLIF(data_sjc, '1900-01-01') IS NOT NULL AND NULLIF(data_sjc, '1900-01-01') <= '2023-12-31' and tanby_sjc > 0) or
        (NULLIF(data_bb, '1900-01-01') IS NOT NULL AND NULLIF(data_bb, '1900-01-01') <= '2023-12-31' and best_bag > 0) or
        (NULLIF(data_mis, '1900-01-01') IS NOT NULL AND NULLIF(data_mis, '1900-01-01') <= '2023-12-31' and misaspel > 0) or
        (NULLIF(data_pp, '1900-01-01') IS NOT NULL AND NULLIF(data_pp, '1900-01-01') <= '2023-12-31' and papelyna > 0) or
        (NULLIF(data_tt, '1900-01-01') IS NOT NULL AND NULLIF(data_tt, '1900-01-01') <= '2023-12-31' and tanby_taubate > 0)
    );


-- teste




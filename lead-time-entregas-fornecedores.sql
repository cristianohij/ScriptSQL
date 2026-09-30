-- lead time de entregas de fornecedores

select top(100)
       pa.NFEATEDAT
       ,c.NFEDATEFE
       ,datediff(day, pc.PDCDATCAD, pa.NFEATEDAT)
       ,*
  from TBS0592 pa with (nolock)
  inner join TBS059 c with (nolock)
     on c.NFEEMPCOD=pa.NFEEMPCOD and c.NFECOD=pa.NFECOD and c.NFENUM=pa.NFENUM and c.NFETIP=pa.NFETIP and c.SERCOD=pa.SERCOD and c.SEREMPCOD=pa.SEREMPCOD
  inner join TBS045 pc with (nolock)
     on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM
 where pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'
       --and convert(date, pa.NFEATEDAT) <> convert(date, c.NFEDATEFE)
       --and convert(date, c.NFEDATEFE,112) >= '20220101'

-- empresa do grupo cadastradas como fornecedores

if object_id('tempdb.dbo.#fornecedores_grupo') is not null
begin 
	drop table #fornecedores_grupo
end

select FORCOD
  into #fornecedores_grupo
  from TBS006 with (nolock)
 where FORCGC in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')
 group by FORCOD

select *
  from #fornecedores_grupo

if object_id('tempdb.dbo.#notas') is not null
begin 
	drop table #notas
end

select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,(select count(*)
           from TBS0591 d with (nolock)
          where d.NFEEMPCOD=n.NFEEMPCOD and d.NFECOD=n.NFECOD and d.NFENUM=n.NFENUM and d.NFETIP=n.NFETIP and d.SERCOD=n.SERCOD and d.SEREMPCOD=n.SEREMPCOD
        ) as 'qtde_itens'
  into #notas
  from TBS059 n with (nolock)
 where n.NFEDATEFE between '20230101' and '20231231'
       and n.NFETIP='N'
       and n.NFECAN='N'
       and n.NFECOD not in(select g.FORCOD from #fornecedores_grupo g)
       and exists(select ''
                    from TBS0592 pa with (nolock)
                   where pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP and pa.SERCOD=n.SERCOD and pa.SEREMPCOD=n.SEREMPCOD
                 )

select *
  from #notas

if object_id('tempdb.dbo.#pc_atendidos') is not null
begin 
	drop table #pc_atendidos
end

select pa.NFEEMPCOD
       ,pa.NFETIP
       ,pa.NFENUM
       ,pa.NFECOD
       ,pa.SEREMPCOD
       ,pa.SERCOD
       ,pa.NFEPEDEMP
       ,pa.NFEPEDNUM
       ,pa.NFEPEDITE
       ,pa.NFEPEDUNI
       ,pa.NFEPEDQTD
       ,pa.NFEPEDEMB
       ,pa.NFEATEQTD
  into #pc_atendidos
  from TBS0592 pa with (nolock)
 where pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'
       and exists(select ''
                    from #notas n
                   where n.NFEEMPCOD=pa.NFEEMPCOD and n.NFECOD=pa.NFECOD and n.NFENUM=pa.NFENUM and n.NFETIP=pa.NFETIP and n.SERCOD=pa.SERCOD and n.SEREMPCOD=pa.SEREMPCOD 
                 )

select *
  from #pc_atendidos

if object_id('tempdb.dbo.#pc_itens') is not null
begin 
	drop table #pc_itens
end

select pd.PDCEMPCOD
       ,pd.PDCNUM
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  into #pc_itens
  from TBS0451 pd with (nolock)
 where exists(select '' 
                from #pc_atendidos pa
               where pa.NFEPEDEMP=pd.PDCEMPCOD
                     and pa.NFEPEDNUM=pd.PDCNUM
                     and pa.NFEPEDITE=pd.PDCITE
             )

select *
  from #pc_itens

if object_id('tempdb.dbo.#compras') is not null
begin 
	drop table #compras
end

select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,pa.NFEATEQTD
       ,pc.PDCEMPCOD
       ,pc.PDCNUM
       ,pc.PDCDATCAD
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCUNI
       ,pd.PDCQTD
       ,pd.PDCQTDEMB
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  into #compras     
  from TBS059 n with (nolock)
 inner join TBS0592 pa with (nolock)
    on pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP and pa.SERCOD=n.SERCOD and pa.SEREMPCOD=n.SEREMPCOD
 inner join TBS045 pc with (nolock)
    on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM 
 inner join TBS0451 pd with (nolock)
    on pd.PDCEMPCOD=pa.NFEPEDEMP and pd.PDCNUM=pa.NFEPEDNUM and pd.PDCITE=pa.NFEPEDITE
 where n.NFEDATEFE between '20240101' and '20250731'
       and n.NFETIP='N'
       and n.NFECAN='N'
       and subString(n.NFECHAACE,7,14) not in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')
       and pa.NFETIPPED='C'
       and pa.NFEATEDAT <> '17530101'

select *
  from #compras

if object_id('tempdb.dbo.#media_entregas') is not null
begin 
	drop table #media_entregas
end

select NFECOD
       ,NFENOM
       ,NFEESTORI
       ,avg(datediff(day, PDCDATCAD, NFEDATEFE)) as 'media'
  into #media_entregas
  from #compras
 group by NFECOD, NFENOM, NFEESTORI

select *
  from #media_entregas
 order by NFENOM

update TBS006
   set FORTEMREP=0

update TBS006
   set FORTEMREP=media
  from TBS006 f
  join #media_entregas m on f.FORCOD=m.NFECOD


select top(100) *
  from TBS045 with (nolock)

-- média geral

select avg(media) as 'media_geral'
  from #media_entregas

-- media por estado

select NFEESTORI as 'UF'
       ,avg(media) as 'media'
  from #media_entregas
 group by NFEESTORI
 order by NFEESTORI

-- moda

-- uma forma

with tmModa as (
   select media
          ,count(*) as 'freqAbs'
     from #media_entregas
    group by media
   having count(*) > 1
)
select top (1) with ties media as 'moda'
  from tmModa
 order by freqAbs desc

-- outra forma

select top(1) with ties media as 'moda'
       ,count(*)
  from #media_entregas
 group by media
having count(*) > 1
 order by count(*) desc
 
-- conta pedidos de compras

select convert(char(6),PDCDATCAD,112)
       ,count(*)
  from TBS045 with (nolock)
 where PDCDATCAD >= '20220101'
 group by convert(char(6),PDCDATCAD,112)

select count(distinct NFECOD)
  from TBS059 with (nolock)
 where NFEDATEFE between '20230101' and '20231231'
 
select NFECOD
  from TBS059 with (nolock)
 where NFEDATEFE between '20230101' and '20231231'
 group by NFECOD

select NFECOD
       ,max(NFEDATEFE) as 'UltimaDataEntrega'
  from TBS059 with (nolock)
 where NFECAN = 'N' and NFETIP = 'N'  
 group by NFECOD

select codigo
       ,nome
       ,ultima_entrega
  from (
select NFECOD as 'codigo'
       ,NFENOM as 'nome'
       ,max(NFEDATEFE) as 'ultima_entrega'
  from TBS059 with (nolock)
 where NFEDATEFE != '17530101'
       and NFECAN='N'
       and NFETIP='N'
 group by NFECOD, NFENOM
  ) as tab
 order by ultima_entrega desc

select distinct NFECOD
                ,NFENOM
       ,(select FORUCPDAT from TBS006 with (nolock) where FORCOD=NFECOD)
  from TBS059 with (nolock)
 where NFEDATEFE between '20240101' and '20250731'
       and NFECAN = 'N'
       and NFETIP = 'N'
       and subString(NFECHAACE,7,14) not in('05118717000237','05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')


-- códigos dos fornecedores "grupo"

if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_FornecedoresGrupo 1

select *
  from #grupo

-- cfop de compras

select d.NFECFOP
       ,(select COPDES from TBS041 cfop with (nolock) where cfop.COPTIP = 'E' and right(cfop.COPCODDDE,3) = right(d.NFECFOP,3))
       ,(select COPTXT from TBS041 cfop with (nolock) where cfop.COPTIP = 'E' and right(cfop.COPCODDDE,3) = right(d.NFECFOP,3))
  from TBS059 c with (nolock)
 inner join TBS0591 d with (nolock)
    on d.NFEEMPCOD=c.NFEEMPCOD and d.NFETIP=c.NFETIP and d.NFECOD=c.NFECOD  and d.SEREMPCOD=c.SEREMPCOD and d.SERCOD=c.SERCOD and d.NFENUM=c.NFENUM
 where c.NFEDATEFE >= '20230101'
       and c.NFETIP = 'N'
       and c.NFECAN = 'N'
       and c.NFECOD not in (select codigo from #grupo where codigo=c.NFECOD)
 group by d.NFECFOP

if object_id('tempdb.dbo.#cfop') is not null 
begin 
	drop table #cfop
end 

select '1.102' as 'cfop'
  into #cfop

insert into #cfop
select '1.403'

insert into #cfop
select '1.407'

insert into #cfop
select '1.556'

insert into #cfop
select '2.102'

insert into #cfop
select '2.403'

insert into #cfop
select '2.556'

-- produtos comprados

if object_id('tempdb.dbo.#compras') is not null
begin 
	drop table #compras
end

select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,pa.NFEATEQTD
       ,pc.PDCEMPCOD
       ,pc.PDCNUM
       ,pc.PDCDATCAD
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCUNI
       ,pd.PDCQTD
       ,pd.PDCQTDEMB
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  into #compras     
  from TBS059 n with (nolock)
 inner join TBS0591 d with (nolock)
         on d.NFEEMPCOD = n.NFEEMPCOD
            and d.NFETIP = n.NFETIP
            and d.NFECOD = n.NFECOD
            and d.SEREMPCOD = n.SEREMPCOD
            and d.SERCOD = n.SERCOD
            and d.NFENUM = n.NFENUM
 inner join TBS0592 pa with (nolock)
    on pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP and pa.SERCOD=n.SERCOD and pa.SEREMPCOD=n.SEREMPCOD
 inner join TBS045 pc with (nolock)
    on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM 
 inner join TBS0451 pd with (nolock)
    on pd.PDCEMPCOD=pa.NFEPEDEMP and pd.PDCNUM=pa.NFEPEDNUM and pd.PDCITE=pa.NFEPEDITE
 where n.NFEDATEFE between '20230101' and '20250930'
       and n.NFETIP = 'N'
       and n.NFECAN = 'N'
       and n.NFECOD not in (select codigo from #grupo where codigo=n.NFECOD)
       and pa.NFETIPPED = 'C'
       and pa.NFEATEDAT <> '17530101'
       and d.NFECFOP in (select cfop from #cfop)

-- tanby CD

insert into #compras
select n.NFEEMPCOD
       ,n.NFETIP
       ,n.NFENUM
       ,n.NFECOD
       ,n.NFENOM
       ,n.SEREMPCOD
       ,n.SERCOD
       ,n.NFEESTORI
       ,n.NFEDATEFE
       ,pa.NFEATEQTD
       ,pc.PDCEMPCOD
       ,pc.PDCNUM
       ,pc.PDCDATCAD
       ,pd.PDCITE
       ,pd.PROEMPCOD
       ,pd.PROCOD
       ,pd.PDCUNI
       ,pd.PDCQTD
       ,pd.PDCQTDEMB
       ,pd.PDCDES
       ,pd.PDCDATPRE
       ,pd.PDCDATFAT
  from cd.SIBD.dbo.TBS059 n with (nolock)
 inner join cd.SIBD.dbo.TBS0591 d with (nolock)
         on d.NFEEMPCOD = n.NFEEMPCOD
            and d.NFETIP = n.NFETIP collate database_default
            and d.NFECOD = n.NFECOD
            and d.SEREMPCOD = n.SEREMPCOD
            and d.SERCOD = n.SERCOD collate database_default
            and d.NFENUM = n.NFENUM
 inner join cd.SIBD.dbo.TBS0592 pa with (nolock)
    on pa.NFEEMPCOD=n.NFEEMPCOD and pa.NFECOD=n.NFECOD and pa.NFENUM=n.NFENUM and pa.NFETIP=n.NFETIP collate database_default and pa.SERCOD=n.SERCOD collate database_default and pa.SEREMPCOD=n.SEREMPCOD
 inner join cd.SIBD.dbo.TBS045 pc with (nolock)
    on pc.PDCEMPCOD=pa.NFEPEDEMP and pc.PDCNUM=pa.NFEPEDNUM 
 inner join cd.SIBD.dbo.TBS0451 pd with (nolock)
    on pd.PDCEMPCOD=pa.NFEPEDEMP and pd.PDCNUM=pa.NFEPEDNUM and pd.PDCITE=pa.NFEPEDITE
 where n.NFEDATEFE between '20230101' and '20250930'
       and n.NFETIP = 'N'
       and n.NFECAN = 'N'
       and n.NFECOD not in (select codigo from #grupo where codigo=n.NFECOD)
       and pa.NFETIPPED = 'C'
       and pa.NFEATEDAT <> '17530101'
       and d.NFECFOP collate database_default in (select cfop from #cfop)

select *
  from #compras

-- tempo médio de entregas

if object_id('tempdb.dbo.#media_entregas') is not null
begin 
	drop table #media_entregas
end

select NFECOD
       --,NFENOM
       ,NFEESTORI
       ,PROCOD
       ,avg(datediff(day, PDCDATCAD, NFEDATEFE)) as 'media'
  into #media_entregas
  from #compras
-- group by NFECOD, NFENOM, NFEESTORI, PROCOD
 group by NFECOD, NFEESTORI, PROCOD

select *
  from #media_entregas
 order by NFENOM

select NFECOD
       ,PROCOD
       ,count(*)
  from #media_entregas
 group by NFECOD, PROCOD
having count(*)>1

select *
  from #media_entregas
 where NFECOD = 2628
       and PROCOD = '8414173'

update #media_entregas
   set NFENOM = 'TIGRE MATERIAIS E SOLUCOES PARA CONSTRUCAO LTDA'
 where NFECOD = 2628

-- zera a informação

-- fornecedores

update TBS006
   set FORTEMREP = 0

-- produtos

update TBS010
   set PROTEMREP = 0

-- atualiza média de entrega

-- fornecedores

update TBS006
   set FORTEMREP = media
  from TBS006 f
 inner join #media_entregas m
         on f.FORCOD = m.NFECOD

-- produtos

update TBS010
   set PROTEMREP = media
  from TBS010 p
 inner join #media_entregas m
         on p.PROCOD = m.PROCOD
 where PROCALPOP = 'S'

select top(10) *
  from TBS035 with (nolock)

select top(10) *
  from TBS035 with (nolock)
 where LOGTAB = 'TBS002'
       and LOGOPE = 'A'
       and LOGATT = 'FORTEMREP'

select FORTEMREP
  from TBS006 with (nolock)
 where FORCOD = 1845

select FORCOD
       ,FORNOM
       ,FORTEMREP
       ,UFESIG
       ,FORNOMFAN
  from TBS006 with (nolock)
 where FORTEMREP > 0
 order by FORNOM

exec sp_help 'TBS0451'

/*  Como funciona:
    Para cada linha (pedido de um produto), o CROSS APPLY busca a última data anterior de compra do mesmo produto (MAX(c2.PDCDATCAD) menor que a atual).
    Faz o DATEDIFF entre essa data anterior e a atual.
    Calcula a média dos intervalos (AVG) agrupando por produto. */

;WITH Compras AS (
    SELECT 
        i.PROCOD,
        c.PDCDATCAD,
        DATEDIFF(
            DAY, 
            p.DataAnterior, 
            c.PDCDATCAD
        ) AS DiasEntre
    FROM TBS0451 i
    INNER JOIN TBS045 c with (nolock)
        ON c.PDCEMPCOD = i.PDCEMPCOD 
       AND c.PDCNUM = i.PDCNUM
    CROSS APPLY (
        SELECT MAX(c2.PDCDATCAD) AS DataAnterior
        FROM TBS0451 i2 with (nolock)
        INNER JOIN TBS045 c2 with (nolock)
            ON c2.PDCEMPCOD = i2.PDCEMPCOD 
           AND c2.PDCNUM = i2.PDCNUM
        WHERE i2.PROCOD = i.PROCOD
          AND c2.PDCDATCAD < c.PDCDATCAD
    ) p
    WHERE c.PDCDATCAD >= '2025-01-01' -- data base
)
SELECT 
    PROCOD,
    AVG(DiasEntre * 1.0) AS MediaDiasEntreCompras
FROM Compras
WHERE DiasEntre IS NOT NULL
GROUP BY PROCOD
ORDER BY MediaDiasEntreCompras;

-- Listar data e número do pedido de cada produto

SELECT 
    i.PROCOD,
    c.PDCNUM,
    c.PDCDATCAD
FROM TBS0451 i WITH (NOLOCK)
INNER JOIN TBS045 c WITH (NOLOCK)
    ON c.PDCEMPCOD = i.PDCEMPCOD 
   AND c.PDCNUM    = i.PDCNUM
WHERE c.PDCDATCAD >= '2025-01-01'  -- data base
ORDER BY i.PROCOD, c.PDCDATCAD;

-- relatório de saldos em relação a curva ABC

/*
    Você pode comparar o resultado de Perc_com_Saldo com os percentuais desejados (meta):
    A → ≥ 80%
    B → ≥ 15%
    C → ≥ 5%
*/

WITH Saldos AS (
    SELECT
        E.PROCOD,
        SUM(E.ESTQTDATU - E.ESTQTDRES) AS Saldo
    FROM TBS032 AS E WITH (NOLOCK)
    WHERE E.ESTLOC IN ('01', '02')
    GROUP BY E.PROCOD
)
SELECT
    P.PROCURABC AS Curva,
    COUNT(DISTINCT P.PROCOD) AS Qtde_Produtos,
    SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) AS Produtos_com_Saldo,
    CAST(SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) * 100.0 
         / COUNT(DISTINCT P.PROCOD) AS DECIMAL(5,2)) AS Perc_com_Saldo
FROM TBS010 AS P WITH (NOLOCK)
LEFT JOIN Saldos AS S ON S.PROCOD = P.PROCOD
WHERE P.PROCURABC IN ('A', 'B', 'C')
GROUP BY P.PROCURABC
ORDER BY P.PROCURABC;

WITH Saldos AS (
    SELECT
        E.PROCOD,
        SUM(E.ESTQTDATU - E.ESTQTDRES) AS Saldo
    FROM TBS032 AS E WITH (NOLOCK)
    WHERE E.ESTLOC IN ('01', '02')
    GROUP BY E.PROCOD
)
SELECT
    P.PROCURABC AS Curva,
    COUNT(DISTINCT P.PROCOD) AS Qtde_Produtos,
    SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) AS Produtos_com_Saldo,
    CAST(SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) * 100.0 
         / COUNT(DISTINCT P.PROCOD) AS DECIMAL(5,2)) AS Perc_com_Saldo,
    CASE 
        WHEN P.PROCURABC = 'A' AND (SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT P.PROCOD)) >= 80 THEN 'OK'
        WHEN P.PROCURABC = 'B' AND (SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT P.PROCOD)) >= 15 THEN 'OK'
        WHEN P.PROCURABC = 'C' AND (SUM(CASE WHEN ISNULL(S.Saldo, 0) > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT P.PROCOD)) >= 5 THEN 'OK'
        ELSE 'Abaixo da meta'
    END AS Situacao
FROM TBS010 AS P WITH (NOLOCK)
LEFT JOIN Saldos AS S ON S.PROCOD = P.PROCOD
WHERE P.PROCURABC IN ('A','B','C')
GROUP BY P.PROCURABC
ORDER BY P.PROCURABC;

/*
  Relatório Detalhado — Produtos Sem Saldo
  Este mostra quais produtos estão zerados, para que você possa agir.
*/

WITH Saldos AS (
    SELECT
        E.PROCOD,
        SUM(E.ESTQTDATU - E.ESTQTDRES) AS Saldo
    FROM TBS032 AS E WITH (NOLOCK)
    WHERE E.ESTLOC IN ('01', '02')
    GROUP BY E.PROCOD
)
SELECT
    P.PROCOD,
    P.PRODES AS Nome_Produto,
    P.PROCURABC AS Curva,
    ISNULL(S.Saldo, 0) AS Saldo
FROM TBS010 AS P WITH (NOLOCK)
LEFT JOIN Saldos AS S ON S.PROCOD = P.PROCOD
WHERE ISNULL(S.Saldo, 0) <= 0
  AND P.PROCURABC IN ('A','B','C')
ORDER BY P.PROCURABC, P.PRODES;



-- Relatório Resumido com Parâmetros (Metas configuráveis)

DECLARE 
    @MetaA DECIMAL(5,2) = 80,
    @MetaB DECIMAL(5,2) = 15,
    @MetaC DECIMAL(5,2) = 5;

-- ==========================================
-- Passo 1: Saldo por produto
-- ==========================================
IF OBJECT_ID('tempdb..#Saldos') IS NOT NULL
    DROP TABLE #Saldos;

SELECT
    E.PROCOD,
    SUM(E.ESTQTDATU - E.ESTQTDRES) AS Saldo
INTO #Saldos
FROM TBS032 AS E WITH (NOLOCK)
WHERE E.ESTLOC IN ('01','02')
GROUP BY E.PROCOD;

-- ==========================================
-- Passo 2: Resumo por curva ABC (somente produtos com CURVA)
-- ==========================================
IF OBJECT_ID('tempdb..#Resumo') IS NOT NULL
    DROP TABLE #Resumo;

SELECT
    P.PROCURABC AS Curva,
    COUNT(DISTINCT P.PROCOD) AS Qtde_Produtos,
    SUM(CASE WHEN ISNULL(S.Saldo,0) > 0 THEN 1 ELSE 0 END) AS Produtos_com_Saldo,
    CAST(SUM(CASE WHEN ISNULL(S.Saldo,0) > 0 THEN 1 ELSE 0 END) * 100.0 
         / COUNT(DISTINCT P.PROCOD) AS DECIMAL(5,2)) AS Perc_com_Saldo
INTO #Resumo
FROM TBS010 AS P WITH (NOLOCK)
LEFT JOIN #Saldos AS S ON S.PROCOD = P.PROCOD
WHERE P.PROCURABC IN ('A','B','C')
GROUP BY P.PROCURABC;

-- ==========================================
-- Parte 1: Resumo geral
-- ==========================================
SELECT 
    R.Curva,
    R.Qtde_Produtos,
    R.Produtos_com_Saldo,
    R.Perc_com_Saldo,
    CASE 
        WHEN R.Curva = 'A' AND R.Perc_com_Saldo >= @MetaA THEN 'OK'
        WHEN R.Curva = 'B' AND R.Perc_com_Saldo >= @MetaB THEN 'OK'
        WHEN R.Curva = 'C' AND R.Perc_com_Saldo >= @MetaC THEN 'OK'
        ELSE 'Abaixo da Meta'
    END AS Situacao,
    CASE R.Curva
        WHEN 'A' THEN @MetaA
        WHEN 'B' THEN @MetaB
        WHEN 'C' THEN @MetaC
    END AS Meta_Esperada
FROM #Resumo AS R
ORDER BY R.Curva;

-- ==========================================
-- Parte 2: Produtos sem saldo (somente produtos com CURVA)
-- ==========================================
PRINT CHAR(13) + '===== PRODUTOS SEM SALDO =====' + CHAR(13);

SELECT 
    P.PROCOD,
    P.PRODES AS Nome_Produto,
    P.PROCURABC AS Curva,
    ISNULL(S.Saldo,0) AS Saldo
FROM TBS010 AS P WITH (NOLOCK)
LEFT JOIN #Saldos AS S ON S.PROCOD = P.PROCOD
WHERE ISNULL(S.Saldo,0) <= 0
  AND P.PROCURABC IN ('A','B','C')  -- somente produtos com curva
ORDER BY P.PROCURABC, P.PRODES;

-- ==========================================
-- Limpeza de tabelas temporárias
-- ==========================================
DROP TABLE #Saldos;
DROP TABLE #Resumo;


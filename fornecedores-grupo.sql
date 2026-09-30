select @emp,
    ano=year(TBS059.NFEDATEFE),
    mes=month(TBS059.NFEDATEFE),
    PROCOD,

    -- qtde compra na menor unidade * pre�o unit�rio (sem alguns impostos)
    sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do m�s
    /
    case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo, -- qtde total do m�s

    sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as valor,
    sum(NFEQTD * NFEQTDEMB) as qtde, -- qtde total do m�s

    str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)

--                avg(dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) as custo

from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                        inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

where not exists(select null from CUSTOAQUISICAO
                where empresa=@emp and ano=year(TBS059.NFEDATEFE) and mes=month(TBS059.NFEDATEFE) and produto=PROCOD collate database_default)
    and TBS059.NFEDATEFE between @dataDe and @dataAte
    and TBS0591.NFETIP='N'
    and TBS059.NFECAN<>'S'
    --TBS059.NFEDATEFE between @dataDe and @dataAte and --TBS0591.NFETIP<>'D' and
    --and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350') and
    and right(NFECFOP,3) in('102','403','121','202','411')
--                and right(NFECFOP,3) in('202','411') -- devolu��es
--                and TBS059.NFENUM<>263505
group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),PROCOD

if object_id('tempdb.dbo.#grupo') is not null
    begin
    	drop table #grupo
    end

create table #grupo (codigo int)

insert into #grupo
exec usp_FornecedoresGrupo 1

select *
  from #grupo

select f.FORCGC
       ,f.FORNOM
       ,d.NFETOTOPEITE
  from TBS0591 d with (nolock)
 inner join TBS059 c with (nolock)
         on c.SERCOD = d.SERCOD
            and c.NFETIP = d.NFETIP
            and c.NFECOD = d.NFECOD
            and c.NFENUM = d.NFENUM
 inner join TBS006 f with (nolock)
         on f.FORCOD = c.NFECOD
where c.NFEDATEFE >= '20240101'
      and c.NFETIP = 'N'
      and c.NFECAN <> 'S'
      and f.FORCOD not in (select codigo from #grupo)
      and right(d.NFECFOP,3) in('102','403')

-- dados agrupados

select 
      f.FORNOM,
      count(*) as QtdeRegistros,
      sum(d.NFETOTOPEITE) as TotalNFETOTOPEITE
from TBS0591 d with (nolock)
inner join TBS059 c with (nolock)
        on c.SERCOD = d.SERCOD
       and c.NFETIP = d.NFETIP
       and c.NFECOD = d.NFECOD
       and c.NFENUM = d.NFENUM
inner join TBS006 f with (nolock)
        on f.FORCOD = c.NFECOD
where c.NFEDATEFE >= '20240101'
  and c.NFETIP = 'N'
  and c.NFECAN <> 'S'
  and f.FORCOD not in (select codigo from #grupo)
  and right(d.NFECFOP,3) in ('102','403')
group by f.FORNOM, d.PROCOD
order by f.FORNOM;

select f.FORNOM
      ,d.PROCOD
      ,d.NFEQTD
      ,d.NFETOTOPEITE
from TBS0591 d with (nolock)
inner join TBS059 c with (nolock)
        on c.SERCOD = d.SERCOD
       and c.NFETIP = d.NFETIP
       and c.NFECOD = d.NFECOD
       and c.NFENUM = d.NFENUM
inner join TBS006 f with (nolock)
        on f.FORCOD = c.NFECOD
where c.NFEDATEFE >= '20240101'
  and c.NFETIP = 'N'
  and c.NFECAN <> 'S'
  and f.FORCOD not in (select codigo from #grupo)
  and right(d.NFECFOP,3) in ('102','403')

-- agrupamento por nome

select 
      f.FORNOM,
      sum(d.NFETOTOPEITE) as TotalComprado,
      count(distinct d.PROCOD) as QtdeProdutosDistintos
from TBS0591 d with (nolock)
inner join TBS059 c with (nolock)
        on c.SERCOD = d.SERCOD
       and c.NFETIP = d.NFETIP
       and c.NFECOD = d.NFECOD
       and c.NFENUM = d.NFENUM
inner join TBS006 f with (nolock)
        on f.FORCOD = c.NFECOD
where c.NFEDATEFE >= '20240101'
  and c.NFETIP = 'N'
  and c.NFECAN <> 'S'
  and f.FORCOD not in (select codigo from #grupo)
  and right(d.NFECFOP,3) in ('102','403')
group by f.FORNOM
order by f.FORNOM;

-- agrupamento por CNPJ

select Left(f.FORCGC,8)
       ,sum(d.NFETOTOPEITE) as TotalComprado
       ,count(distinct d.PROCOD) as QtdeProdutosDistintos
  from TBS0591 d with (nolock)
 inner join TBS059 c with (nolock)
         on c.SERCOD = d.SERCOD
            and c.NFETIP = d.NFETIP
            and c.NFECOD = d.NFECOD
            and c.NFENUM = d.NFENUM
  inner join TBS006 f with (nolock)
          on f.FORCOD = c.NFECOD
  where c.NFEDATEFE >= '20240101'
        and c.NFETIP = 'N'
        and c.NFECAN <> 'S'
        and f.FORCOD not in (select FORCOD from vw_FornecedorGrupo)
        and right(d.NFECFOP,3) in ('102','403')
group by Left(f.FORCGC,8)

union

-- best bag
select Left(f.FORCGC,8)
       ,sum(d.NFETOTOPEITE) as TotalComprado
       ,count(distinct d.PROCOD) as QtdeProdutosDistintos
  from bb.SIBD2.dbo.TBS0591 d with (nolock)
 inner join bb.SIBD2.dbo.TBS059 c with (nolock)
         on c.SERCOD = d.SERCOD
            and c.NFETIP = d.NFETIP
            and c.NFECOD = d.NFECOD
            and c.NFENUM = d.NFENUM
  inner join bb.SIBD2.dbo.TBS006 f with (nolock)
          on f.FORCOD = c.NFECOD
  where c.NFEDATEFE >= '20240101'
        and c.NFETIP = 'N'
        and c.NFECAN <> 'S'
        and f.FORCOD not in (select FORCOD from vw_FornecedorGrupo)
        and right(d.NFECFOP,3) in ('102','403')
group by Left(f.FORCGC,8)

union

-- misaspel
select Left(f.FORCGC,8)
       ,sum(d.NFETOTOPEITE) as TotalComprado
       ,count(distinct d.PROCOD) as QtdeProdutosDistintos
  from mi.SIBD3.dbo.TBS0591 d with (nolock)
 inner join mi.SIBD3.dbo.TBS059 c with (nolock)
         on c.SERCOD = d.SERCOD
            and c.NFETIP = d.NFETIP
            and c.NFECOD = d.NFECOD
            and c.NFENUM = d.NFENUM
  inner join mi.SIBD3.dbo.TBS006 f with (nolock)
          on f.FORCOD = c.NFECOD
  where c.NFEDATEFE >= '20240101'
        and c.NFETIP = 'N'
        and c.NFECAN <> 'S'
        and f.FORCOD not in (select FORCOD from vw_FornecedorGrupo)
        and right(d.NFECFOP,3) in ('102','403')
group by Left(f.FORCGC,8)

union

-- papelyna
select Left(f.FORCGC,8)
       ,sum(d.NFETOTOPEITE) as TotalComprado
       ,count(distinct d.PROCOD) as QtdeProdutosDistintos
  from pp.SIBD.dbo.TBS0591 d with (nolock)
 inner join pp.SIBD.dbo.TBS059 c with (nolock)
         on c.SERCOD = d.SERCOD
            and c.NFETIP = d.NFETIP
            and c.NFECOD = d.NFECOD
            and c.NFENUM = d.NFENUM
  inner join pp.SIBD.dbo.TBS006 f with (nolock)
          on f.FORCOD = c.NFECOD
  where c.NFEDATEFE >= '20240101'
        and c.NFETIP = 'N'
        and c.NFECAN <> 'S'
        and f.FORCOD not in (select FORCOD from vw_FornecedorGrupo)
        and right(d.NFECFOP,3) in ('102','403')
group by Left(f.FORCGC,8)

-- ajustado

drop table #compras

SELECT 
    cnpj,
    SUM(valor) AS valor,
    --count(distinct produtos) AS produtos
    sum(produtos) AS produtos
  into #compras
FROM
(
    -- MATRIZ
    SELECT 
        LEFT(f.FORCGC,8) AS cnpj,
        SUM(d.NFETOTOPEITE) AS valor,
        COUNT(DISTINCT d.PROCOD) AS produtos
    FROM TBS0591 d WITH (NOLOCK)
    INNER JOIN TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)
--) X
--GROUP BY cnpj
--ORDER BY cnpj;
--select * from #compras
    UNION ALL

    -- BEST BAG
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        SUM(d.NFETOTOPEITE),
        COUNT(DISTINCT d.PROCOD)
    FROM bb.SIBD2.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN bb.SIBD2.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN bb.SIBD2.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM bb.SIBD2.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)

    UNION ALL

    -- MISASPEL
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        SUM(d.NFETOTOPEITE),
        COUNT(DISTINCT d.PROCOD)
    FROM mi.SIBD3.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN mi.SIBD3.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN mi.SIBD3.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM mi.SIBD3.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)

    UNION ALL

    -- PAPELYNA
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        SUM(d.NFETOTOPEITE),
        COUNT(DISTINCT d.PROCOD)
    FROM pp.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN pp.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN pp.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM pp.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)

    union all

    -- tanby cd
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        SUM(d.NFETOTOPEITE),
        COUNT(DISTINCT d.PROCOD)
    FROM cd.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN cd.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN cd.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM cd.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)

    union all

    -- tanby taubaté
    SELECT 
        LEFT(f.FORCGC,8) collate database_default AS FORCGC8 ,
        SUM(d.NFETOTOPEITE),
        COUNT(DISTINCT d.PROCOD)
    FROM tt.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN tt.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN tt.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM tt.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8)

) X
GROUP BY cnpj
ORDER BY cnpj;

drop table #fornecedores

select FORNOM
       ,FORCGC
  into #fornecedores
  from TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from vw_FornecedorGrupo)
union

-- bb
select FORNOM
       ,FORCGC
  from bb.SIBD2.dbo.TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from bb.SIBD2.dbo.vw_FornecedorGrupo)  
union

-- mi
select FORNOM
       ,FORCGC
  from mi.SIBD3.dbo.TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from mi.SIBD3.dbo.vw_FornecedorGrupo)  
union

-- pp
select FORNOM
       ,FORCGC
  from pp.SIBD.dbo.TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from pp.SIBD.dbo.vw_FornecedorGrupo)  
union

-- cd
select FORNOM collate database_default
       ,FORCGC collate database_default
  from cd.SIBD.dbo.TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from cd.SIBD.dbo.vw_FornecedorGrupo)  
union

-- taubaté
select FORNOM
       ,FORCGC
  from tt.SIBD.dbo.TBS006 with (nolock)
 where FORCGC <> ''
       and FORCOD not in(select FORCOD from tt.SIBD.dbo.vw_FornecedorGrupo)

select (select top 1 FORNOM
          from #fornecedores
         where Left(FORCGC,8) = cnpj)
       ,(select top 1 FORCGC
          from #fornecedores
         where Left(FORCGC,8) = cnpj)         
       ,*
  from #compras

SELECT 
    f.FORNOM,
    f.FORCGC,
    c.valor,
    c.produtos
FROM #compras c
LEFT JOIN #fornecedores f
       ON LEFT(f.FORCGC, 8) = c.cnpj;

WITH fornecedores_unicos AS (
    SELECT
        FORNOM,
        FORCGC,
        ROW_NUMBER() OVER (
            PARTITION BY LEFT(FORCGC,8)
            ORDER BY FORCGC
        ) AS rn
    FROM #fornecedores
)
SELECT 
    f.FORNOM,
    f.FORCGC,
    c.*
FROM #compras c
LEFT JOIN fornecedores_unicos f
       ON LEFT(f.FORCGC,8) = c.cnpj
      AND f.rn = 1;

WITH fornecedores_unicos AS (
    SELECT
        FORNOM,
        FORCGC,
        ROW_NUMBER() OVER (
            PARTITION BY LEFT(FORCGC,8)
            ORDER BY FORCGC
        ) AS rn
    FROM #fornecedores
)
SELECT 
    f.FORNOM,
    f.FORCGC,
    FORMAT(c.valor, 'N2', 'pt-BR') AS valor,
    c.*
FROM #compras c
LEFT JOIN fornecedores_unicos f
       ON LEFT(f.FORCGC,8) = c.cnpj
      AND f.rn = 1;


SELECT
		FORCOD 	
	FROM TBS006 A (NOLOCK) 	
	WHERE
		A.FOREMPCOD = @EMPRESATBS006 AND 
		(A.FORCGC like('65069593%') OR	-- tanbys
		A.FORCGC like('05118717%') OR	-- misaspel
		A.FORCGC like('52080207%') OR	-- best bag
		A.FORCGC like('44125185%') OR	-- papelyna
		A.FORCGC like('41952080%'))		-- winpack
	ORDER BY
		A.FOREMPCOD,
		A.FORCGC

create view dbo.vw_FornecedorGrupo as
select FORCOD
  from TBS006 with (nolock)
 where (FORCGC Like '65069593%'    -- tanbys
        or FORCGC Like '05118717%'    -- misaspel
        or FORCGC Like '52080207%'    -- best bag
        or FORCGC Like '44125185%'    -- papelyna
        or FORCGC Like '41952080%')   -- winpack

select *
  from vw_FornecedorGrupo

SELECT 
    cnpj,
    SUM(valor) AS valor,
    count(distinct PROCOD) AS produtos
    --count(distinct produtos) AS produtos
    --sum(produtos) AS produtos
  into #compras
FROM
(
    -- MATRIZ
    SELECT 
        LEFT(f.FORCGC,8) AS cnpj,
        d.PROCOD,
        SUM(d.NFETOTOPEITE) AS valor
        --COUNT(DISTINCT d.PROCOD) AS produtos
    FROM TBS0591 d WITH (NOLOCK)
    INNER JOIN TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD

    UNION ALL

    -- BEST BAG
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        d.PROCOD,
        SUM(d.NFETOTOPEITE)
        --COUNT(DISTINCT d.PROCOD)
    FROM bb.SIBD2.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN bb.SIBD2.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN bb.SIBD2.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM bb.SIBD2.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD

    UNION ALL

    -- misaspel
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        d.PROCOD,
        SUM(d.NFETOTOPEITE)
        --COUNT(DISTINCT d.PROCOD)
    FROM mi.SIBD3.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN mi.SIBD3.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN mi.SIBD3.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM mi.SIBD3.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD

    UNION ALL

    -- papelyna
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        d.PROCOD,
        SUM(d.NFETOTOPEITE)
        --COUNT(DISTINCT d.PROCOD)
    FROM pp.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN pp.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN pp.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM pp.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD

    UNION ALL

    -- cd
    SELECT 
        LEFT(f.FORCGC,8) collate database_default AS FORCGC8,
        d.PROCOD collate database_default,
        SUM(d.NFETOTOPEITE)
        --COUNT(DISTINCT d.PROCOD)
    FROM cd.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN cd.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN cd.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM cd.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD

    union all
    -- taubaté
    SELECT 
        LEFT(f.FORCGC,8) AS FORCGC8,
        d.PROCOD,
        SUM(d.NFETOTOPEITE)
        --COUNT(DISTINCT d.PROCOD)
    FROM tt.SIBD.dbo.TBS0591 d WITH (NOLOCK)
    INNER JOIN tt.SIBD.dbo.TBS059 c WITH (NOLOCK)
        ON c.SERCOD = d.SERCOD
        AND c.NFETIP = d.NFETIP
        AND c.NFECOD = d.NFECOD
        AND c.NFENUM = d.NFENUM
    INNER JOIN tt.SIBD.dbo.TBS006 f WITH (NOLOCK)
        ON f.FORCOD = c.NFECOD
    WHERE c.NFEDATEFE >= '20240101'
      AND c.NFETIP = 'N'
      AND c.NFECAN <> 'S'
      AND f.FORCOD NOT IN (SELECT FORCOD FROM tt.SIBD.dbo.vw_FornecedorGrupo)
      AND RIGHT(d.NFECFOP,3) IN ('102','403')
    GROUP BY LEFT(f.FORCGC,8), d.PROCOD
) X
GROUP BY cnpj
ORDER BY cnpj;
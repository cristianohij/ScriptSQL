select count(distinct l.PROCOD)
  from TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'

select year(l.LMEDATHOR)
       ,count(distinct l.PROCOD)
  from TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20250101'
       and l.LMEINFALT = 'E'
 group by year(l.LMEDATHOR)

select l.PROCOD
       ,count(*)
  from TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

-- tanby nd
select l.PROCOD
  from TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

union 
-- best bag
select l.PROCOD
  from bb.SIBD2.dbo.TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

union 
-- misaspel
select l.PROCOD
  from mi.SIBD3.dbo.TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

union 
-- papelyna
select l.PROCOD
  from pp.SIBD.dbo.TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

union 
-- tanby tte
select l.PROCOD
  from tt.SIBD.dbo.TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD

union 
-- tanby cd
select l.PROCOD collate database_default
  from cd.SIBD.dbo.TBS051 l with (nolock)
 where cast(l.LMEDATHOR as date) >= '20240101'
       and l.LMEINFALT = 'E'
 group by l.PROCOD


-- UNION remove duplicados e pode perder valores.
-- UNION ALL é mais rápido e mantém todos os registros para depois somar.

select PROCOD,
       sum(qtde) as qtde
          into #mov_produtos
from (
        -- tanby nd
        select l.PROCOD
               ,count(*) as qtde
          from TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD

        union all

        -- best bag
        select l.PROCOD
               ,count(*)
          from bb.SIBD2.dbo.TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD

        union all
        
        -- misaspel
        select l.PROCOD
               ,count(*)
          from mi.SIBD3.dbo.TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD

        union all
        
        -- papelyna
        select l.PROCOD
               ,count(*)
          from pp.SIBD.dbo.TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD

        union all
        
        -- tanby tte
        select l.PROCOD
               ,count(*)
          from tt.SIBD.dbo.TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD

        union all
        
        -- tanby cd
        select l.PROCOD collate database_default
               ,count(*)
          from cd.SIBD.dbo.TBS051 l with (nolock)
         where cast(l.LMEDATHOR as date) >= '20240101'
               and l.LMEINFALT = 'E'
         group by l.PROCOD        
) x
group by PROCOD
order by PROCOD;

select Left(PROCOD,3) as codigo_marca
       ,(select MARNOM from TBS014 mar with (nolock) where mar.MARCOD = cast(Left(PROCOD,3) as smallint) )
       ,sum(qtde)
  from #mov_produtos mov
 group by Left(PROCOD,3)

-- Versão recomendada

select Left(PROCOD,3) as codigo_marca
       ,(select MARNOM 
           from TBS014 mar with (nolock) 
          where mar.MARCOD = cast(Left(PROCOD,3) as smallint)) as marca
       ,sum(qtde) as movimentacoes
       ,sum(qtde) * 100.0 / sum(sum(qtde)) over() as percentual
       ,count(distinct mov.PROCOD) as produtos_distintos
from #mov_produtos mov
group by Left(PROCOD,3);

-- Melhorando sua query (mais performática)

select Left(mov.PROCOD,3) as codigo_marca
       ,mar.MARNOM
       ,sum(mov.qtde) as movimentacoes
       ,sum(mov.qtde) * 100.0 / sum(sum(mov.qtde)) over() as percentual
       ,count(distinct mov.PROCOD) as produtos_distintos
       ,sum(mov.qtde) / count(distinct mov.PROCOD) as mov_por_item
  from #mov_produtos mov
  left join TBS014 mar with (nolock)
         on mar.MARCOD = cast(Left(mov.PROCOD,3) as smallint)
 group by Left(mov.PROCOD,3), mar.MARNOM
 order by movimentacoes desc

select count(*)
  from TBS010 p with (nolock)
 where p.MARCOD = 788

select p.PROCOD
       ,p.PRODES
       ,p.PROCLAFIS
       ,p.PROCEST
       ,p.PROSTBA
       ,p.PROSTBB
       ,p.PROREDBASICMS
       ,p.PROANEIBSCBS
  from TBS010 p with (nolock)
 where p.MARCOD = 788
       and exists (select 1 from #mov_produtos mov where mov.PROCOD = p.PROCOD)





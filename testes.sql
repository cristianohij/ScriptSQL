drop table #TES

SELECT 
ROW_NUMBER() OVER(PARTITION BY PROCOD ORDER BY LMEREG DESC ,PROCOD) as RANK,
LMEREG, 
LMEDATHOR, 
PROCOD, 
LMEQTDSAL

INTO #TES 
FROM TBS051 (NOLOCK) 

WHERE
LMEDATHOR <= '20180301' AND 
LMEINFALT = 'C'  

ORDER BY 
LMEREG DESC, PROCOD

DELETE #TES

select * from #TES order by PROCOD,RANK

select getdate()


drop table #mov

      select row_number() over(partition by PROCOD order by LMEREG desc, PROCOD) as rank,
             LMEDATHOR data,
             LMELOCEST estoque,
             PROCOD codigo,
             LMEQTDSAL qtde
        into #mov
        from TBS051 (nolock)
       where LMEDATHOR <= getdate() and LMEINFALT in('C')
       order by LMEREG desc, PROCOD

select max(convert(date,data)),estoque,codigo from #mov where estoque in(1,2) and codigo='0060186' group by estoque,codigo

select max(data),estoque,codigo,(select qtde from #mov b where b.rank=1 and b.estoque=a.estoque and b.codigo=a.codigo)
  from #mov a where estoque in(1,2) and codigo='0060186' group by estoque,codigo

select * from #mov where estoque in(1,2) and codigo='0060186' order by data desc

      select data,codigo,sum(qtde) qtde 
        --into #kardex
        from #mov group by data, codigo

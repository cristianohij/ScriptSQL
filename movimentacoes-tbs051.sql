with tab as (
select LMELOCEST as estoque,
       LMEACA as acao,
       convert(char(8),LMEDATHOR,3) as data,
       sum(LMEQTDMOV) as qtde
  from TBS051 (nolock)
 where LMEDATHOR between '20161001' and '20170501' and LMEINFALT='E' and PROCOD='1640054'
 group by LMELOCEST,LMEACA,convert(char(8),LMEDATHOR,3))

select data,estoque,entrada=isnull(sum(case when acao = 'E' then qtde end),0),saida=isnull(sum(case when acao = 'S' then qtde end),0) from tab group by data,estoque order by data,estoque
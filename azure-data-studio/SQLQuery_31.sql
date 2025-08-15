select distinct PROCOD
  from TBS051 with (nolock)
 where convert(date, LMEDATHOR) between '20230101' and '20230407'
       and LMELOCEST=7
       and LMEACA='E'
       and LMEINFALT='E'
       
select PROCOD as 'codigo'
       ,PRODES as 'descricao'
  from TBS010 with (nolock)
 where PROCOD in (select distinct PROCOD
  from TBS051 with (nolock)
 where convert(date, LMEDATHOR) between '20230101' and '20230407'
       and LMELOCEST=7
       and LMEACA='E'
       and LMEINFALT='E'
)

select convert(date, LMEDATHOR) as 'data'
       ,PROCOD as 'codigo'
       ,(select PRODES from TBS010 p with (nolock) where p.PROCOD=l.PROCOD) as 'descricao'
       ,LMEUNI as 'unidade'
       ,LMEQTDMOV as 'entrada'
       ,LMEQTDSAL as 'saldo'
       ,LMEUSU as 'usuario'
  from TBS051 l with (nolock)
 where convert(date, LMEDATHOR) between '20230101' and '20230704'
       and LMELOCEST=7
       and LMEACA='E'
       and LMEINFALT='E'
       and LMEQTDMOV > 0
 order by LMEREG







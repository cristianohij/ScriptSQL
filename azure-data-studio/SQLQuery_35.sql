-- podem haver mais de um produto em uma mesma localização

select PROCOD
       ,PRODES
       ,PROLOCFIS
  into #localizados
  from TBS010 with (nolock)
 where PROLOCFIS != ''

drop table #localizados

select *
  from #localizados

select l.*
       ,e.ESTQTDATU
  from #localizados l
 inner join TBS032 e with (nolock)
    on e.PROCOD=l.PROCOD
 where e.ESTLOC=1
       and e.ESTQTDATU > 0


OOO

select *
  from TBS032 e with (nolock)
 where ESTLOC=1
       and not exists(select 'ne' from TBS010 p with (nolock) where p.PROCOD=e.PROCOD)
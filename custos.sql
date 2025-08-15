select ESTLOC,count(*) from TBS032 with (nolock) where ESTQTDATU > 0 group by ESTLOC

select * from TBS034 with (nolock)

select * from TBS032 with (nolock) where ESTLOC=5 and ESTQTDATU > 0


select * from TBS124 with (nolock) where SINDAT='20180701'

select PROCOD as codigo,
       (select PRODES from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD) as descricao,
       ESTQTDATU as qtde,
       isnull((select top 1 SINCUSAQU from TBS124 (nolock) where SINPROCOD=PROCOD and SINDAT<='20180831' and SINCUSAQU > 0 order by SINDAT desc),0) as custo
  into #invent
  from TBS032 with (nolock)
 where ESTLOC=5 and ESTQTDATU > 0

select * from #invent

select sum(qtde*custo) from #invent

select count(*) from #invent where custo > 0
select count(*) from #invent where custo = 0




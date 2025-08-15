select * from TBS124 (nolock) where SINDAT='20161231' and SINPROCOD='9870070' and SINQTD > 0


select * from TBS0151 (nolock) where PDPCOD='9870070'

select * from TBS015 (nolock) where PDPCOD='9870070'

select * from TBS0311 (nolock) where TDPPROCOD='9870070' and TDPHISDAT<='20161231' and TDPHISCPO='TDPCUSBAS' order by TDPHISDAT desc

select top 1 TDPHISVAL from TBS0311 (nolock)
 where TDPPROCOD='9870070' and TDPHISDAT<='20161231' and TDPHISCPO='TDPCUSBAS' order by TDPHISDAT desc

drop table #precos

with tab as (
   select TDPPROCOD as produto,
          max(TDPHISDAT) as data
     from TBS0311 (nolock) where TDPHISDAT<='20161231' and TDPHISCPO='TDPCUSBAS' group by TDPPROCOD)

select *,
       (select TDPHISVAL from TBS0311 (nolock)where TDPHISDAT=data and TDPPROCOD=produto and TDPHISCPO='TDPCUSBAS') as custo,
       isnull((select 18 from TBS010 (nolock) where PROCOD=produto and PROSTBB not in('30','40','41','50','60')),0) as icms
  into #precos 
  from tab

select sum(SINQTD*(custo-(custo*icms/100)))
  from TBS124 (nolock) inner join #precos on produto=SINPROCOD
 where SINDAT='20161231' and SINQTD > 0

select SINPROCOD,
       (select PRODES from TBS010 (nolock) where PROCOD=SINPROCOD) as descricao,
       (select PROUM1 from TBS010 (nolock) where PROCOD=SINPROCOD) as unidade,
       sum(SINQTD) as qtde,
       avg(custo-(custo*icms/100)) as custo
  from TBS124 (nolock) inner join #precos on produto=SINPROCOD
 where SINDAT='20161231' and SINQTD > 0
 group by SINPROCOD

select * from TBS039 (nolock) where CSTTAB='B' and CSTICMS='N'
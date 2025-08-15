select srvname,datasource from master..sysservers where subString(datasource,1,7)='192.168' order by srvname

select case when py.KESPROCOD is null then mi.KESPROCOD else py.KESPROCOD end from py.SIBD.dbo.TBS125 as py full outer join mi.SIBD.dbo.TBS125 as mi on py.KESPROCOD=mi.KESPROCOD

select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo into #produto
  from py.SIBD.dbo.TBS125 full outer join py.SIBD.dbo.TBS032 on TBS125.KESPROCOD=TBS032.PROCOD
 where ESTLOC=1 and ESTQTDATU > 0
union
select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo
  from mi.SIBD.dbo.TBS125 full outer join mi.SIBD.dbo.TBS032 on TBS125.KESPROCOD=TBS032.PROCOD
 where ESTLOC in(1,2) and ESTQTDATU <> 0
union
select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo into #produto
  from bb2.SIBD2.dbo.TBS125 full outer join bb2.SIBD2.dbo.TBS032 on TBS125.KESPROCOD=TBS032.PROCOD
 where ESTLOC in(1,2) and ESTQTDATU <> 0

select case when KESPROCOD is null then PROCOD else KESPROCOD end as codigo,
       row_number() over (order by case when KESPROCOD is null then PROCOD else KESPROCOD end) as n,
       ESTQTDATU as qtde,
       case when KESPROCOD is null then 'N' else 'S' end as mov
  into #produto
  from TBS125 (nolock) full outer join TBS032 (nolock) on TBS125.KESPROCOD=TBS032.PROCOD
 where ESTLOC in(1,2) and ESTQTDATU <> 0

select codigo, count(*) from #produto group by codigo having count(*) > 1 order by codigo

delete #produto where qtde=0 and mov='N'

delete #produto
 where codigo in(select codigo from #produto group by codigo having count(*) > 1) and
       not n in(select min(n) from #produto group by codigo having count(*) > 1)

select * from #produto order by codigo

insert into #produto select '12130099',0,0,'N'

drop table #produto
select * from #produto where qtde <> 0 or mov='S' order by codigo

select PROLOCFIS4 from py.SIBD.dbo.TBS010 where PROLOCFIS4<>''
select PROLOCFIS4 from mi.SIBD.dbo.TBS010 where PROLOCFIS4<>''
select PROLOCFIS4 from bb2.SIBD2.dbo.TBS010 where PROLOCFIS4<>''

select PROCOD,PROLOCFIS4 from TBS010 where PROLOCFIS4<>''

update TBS010 set PROLOCFIS4='' where PROLOCFIS4<>''

select PROCOD,codigo from py.SIBD.dbo.TBS010 right join #produto on PROCOD=codigo

update py.SIBD.dbo.TBS010 set PROLOCFIS4='1' from py.SIBD.dbo.TBS010 right join #produto on PROCOD=codigo

update TBS010 set PROLOCFIS4='1' from TBS010 right join #produto on PROCOD=codigo

update TBS010 set PROLOCFIS4='1' where PROCOD='12130099'

select count(*) from TBS010 (nolock) where PROLOCFIS4='1'

select top 1 * from TBS010 (nolock)

select count(*) from mi.SIBD.dbo.TBS010 where PROLOGID=0

update mi.SIBD.dbo.TBS010 set PROLOCFIS4='1' from mi.SIBD.dbo.TBS010 right join #produto on PROCOD=codigo

update bb2.SIBD2.dbo.TBS010 set PROLOCFIS4='1' from bb2.SIBD2.dbo.TBS010 right join #produto on PROCOD=codigo

select * from TBS010 (nolock) where PROCODBAR1='37898546002770'

select * from produto order by produtoCodigo

select * from TBS125 (nolock) where KESPROCOD='20910009'
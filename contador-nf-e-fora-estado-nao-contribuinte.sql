--select * from master..sysservers

drop table #FE

select 'ND' as emp,year(ENFDATEMI) as ano,month(ENFDATEMI) as mes,ENFESTDES as uf,count(*) as conta
  into #FE
  from TBS080 (nolock) inner join TBS002 (nolock) on TBS002.CLICOD=ENFCODDES
                       inner join TBS0671 (nolock) on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
 where ENFDATEMI >= '20170101' and ENFSIT=6 and ENFESTDES<>'SP' and (CLIINDIE=99 or NFSCFOP='6.404')
 group by year(ENFDATEMI),month(ENFDATEMI),ENFESTDES
union
select 'TTE' as emp,year(ENFDATEMI) as ano,month(ENFDATEMI) as mes,ENFESTDES as uf,count(*) as conta
  from tt.SIBD.dbo.TBS080 inner join tt.SIBD.dbo.TBS002 on TBS002.CLICOD=ENFCODDES
                          inner join tt.SIBD.dbo.TBS0671 on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
 where ENFDATEMI >= '20170101' and ENFSIT=6 and ENFESTDES<>'SP' and (CLIINDIE=99 or NFSCFOP='6.404')
 group by year(ENFDATEMI),month(ENFDATEMI),ENFESTDES
union
select 'BB' as emp,year(ENFDATEMI) as ano,month(ENFDATEMI) as mes,ENFESTDES as uf,count(*) as conta
  from bb.SIBD2.dbo.TBS080 inner join bb.SIBD2.dbo.TBS002 on TBS002.CLICOD=ENFCODDES
                           inner join bb.SIBD2.dbo.TBS0671 on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
 where ENFDATEMI >= '20170101' and ENFSIT=6 and ENFESTDES<>'SP' and (CLIINDIE=99 or NFSCFOP='6.404')
 group by year(ENFDATEMI),month(ENFDATEMI),ENFESTDES
union
select 'MI' as emp,year(ENFDATEMI) as ano,month(ENFDATEMI) as mes,ENFESTDES as uf,count(*) as conta
  from mi.SIBD.dbo.TBS080 inner join mi.SIBD.dbo.TBS002 on TBS002.CLICOD=ENFCODDES
                          inner join mi.SIBD.dbo.TBS0671 on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
 where ENFDATEMI >= '20170101' and ENFSIT=6 and ENFESTDES<>'SP' and (CLIINDIE=99 or NFSCFOP='6.404')
 group by year(ENFDATEMI),month(ENFDATEMI),ENFESTDES
union
select 'PY' as emp,year(ENFDATEMI) as ano,month(ENFDATEMI) as mes,ENFESTDES as uf,count(*)
  from py.SIBD.dbo.TBS080 inner join py.SIBD.dbo.TBS002 on TBS002.CLICOD=ENFCODDES
                          inner join py.SIBD.dbo.TBS0671 on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
 where ENFDATEMI >= '20170101' and ENFSIT=6 and ENFESTDES<>'SP' and (CLIINDIE=99 or NFSCFOP='6.404')
 group by year(ENFDATEMI),month(ENFDATEMI),ENFESTDES

select ano,
       mes,
       uf,
       coalesce(ND, '') matriz,
       coalesce(TTE, '') taubate,
       coalesce(BB, '') bestbag,
       coalesce(MI, '') misaspe,
       coalesce(PY, '') papelyna
from
(
  select ano,mes,uf,emp,conta
  from #FE
) d
pivot
(
  sum(conta)
  for emp in (ND,TTE,BB,MI,PY)

) piv
order by ano,mes,uf 

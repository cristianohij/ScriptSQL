--select TESCOD,count(*) as 'total' into #TIPOSAIDAS from TBS0671 (nolock) group by TESCOD order by total desc

--select * from #TIPOSAIDAS

select #TIPOSAIDAS.TESCOD,
       TBS042.TESDES,
       TBS041.COPCODDDE,
       TBS041.COPCODDFE,
       TBS042.TESTXT,
       TBS042.TESEST,
       TBS042.TESDPL,
       TBS042.TESCOMVEN,
       TBS042.TESICMS,
       TBS042.TESCNTVEN,
       TBS042.TESMSG
  from #TIPOSAIDAS join TBS042 on TBS042.TESCOD = #TIPOSAIDAS.TESCOD
                   join TBS041 on TBS041.COPCOD = TBS042.COPCOD and TBS041.COPTIP = 'S'
 order by #TIPOSAIDAS.total desc

--select * from TBS042 (nolock)
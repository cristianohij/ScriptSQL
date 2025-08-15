select * from TBS057 (nolock) where FORNOM Like('%LIBERMAC%') order by CPADATVEN desc

select PDPCOD,PRODES from TBS015 (nolock)
 where PDPDATATU <= '20141231' and
       (select count(*) from TBS032 (nolock) where PROCOD=PDPCOD and ESTLOC in(1,2,7) and ESTQTDATU > 0) > 1




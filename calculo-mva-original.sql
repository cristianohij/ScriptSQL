--((68.57-((1-0.04)/(1-0.18)-1)*100)/((1-0.04)/(1-0.18)*100))*100

insert into TBS0921
select NCM
       ,NCMEX
       ,UF
       ,MVA
       ,IPI
       ,ICMS
--  into #mva
  from
  (
select --NFEPROFOR
       --NFEPERMVAST
       NFENCMXML NCM
       ,'' NCMEX
       ,'SP' UF
       ,iif(NFEPERMVAST > 0, round(((NFEPERMVAST-((1-NFEPERICMS/100)/(1-(round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2))/100)-1)*100)) / ((1-NFEPERICMS/100)/(1-(round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2))/100)),2), 0) MVA
       ,NFEPERIPI IPI
--       ,NFEPERICMS
--       ,NFEPERICMSST
--       ,(1-NFEPERICMS/100)/(1-.18)
--       ,((1-NFEPERICMS/100)/(1-.18)-1)*100
--       ,(1-NFEPERICMS/100)/(1-.18)*100
--       ,((NFEPERMVAST-((1-NFEPERICMS/100)/(1-.18)-1)*100))
       ,round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2) ICMS
       --,row_number() over(order by NFENCMXML)
       ,row_number() over(partition by NFENCMXML order by NFEDATEFE desc) RANK
--       ,*
  from TBS0591 with (nolock) 
       inner join TBS059 with (nolock)
       on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
 where --NFENUM=1085089
       NFEDATEFE >= '20180101'
       and NFENCMXML <> ''
       and NFEPERICMSST > 0
       and NFEPERMVAST > 0
--       and NFEITE=19
       and not exists(select '' from TBS0921 with (nolock) where NCMCOD=NFENCMXML and UFESIG='SP')
 group by NFEDATEFE,NFENCMXML, NFEPERMVAST, NFEPERICMS, NFEPERICMSST, NFEPERRBISTXML, NFEPERIPI
-- group by NFEPRONCM, NFEPERMVAST, NFEPERICMS, NFEPERICMSST, NFEPERRBISTXML, NFEPERIPI
-- order by NFENCMXML
  ) tab
 where RANK=1
 order by NCM

select * from #mva where round(ICMS,0)<>18

select * from TBS0921 with (nolock) where UFESIG='SP'

begin tran
delete TBS0921 where UFESIG='SP'
commit tran

select * from TBS0921 with (nolock) where NCMCOD='85183000'

select NFEPRONCM
       ,NFEPERMVAST
       ,NFEPERICMS
       ,NFEPERICMSST
       ,NFEPERRBISTXML
       ,NFEPERIPI
  from TBS0591 with (nolock)
 where NFENUM=1085089
       and NFEITE=19
       --and NFEPERMVAST > 0
--       and not exists(select '' from TBS0921 with (nolock) where NCMCOD=NFEPRONCM and UFESIG='SP')
-- group by NFEPRONCM, NFEPERMVAST, NFEPERICMS, NFEPERICMSST, NFEPERRBISTXML, NFEPERIPI
 order by NFEITE

select NFEPRONCM
       ,NFEPERMVAST
       ,NFEPERICMS
       ,NFEPERICMSST
       ,NFEPERRBISTXML
       ,NFEPERIPI
       ,*
  from TBS0591 with (nolock)
 where NFENUM=234657
       and NFEITE=29
       --and NFEPERMVAST > 0
--       and not exists(select '' from TBS0921 with (nolock) where NCMCOD=NFEPRONCM and UFESIG='SP')
-- group by NFEPRONCM, NFEPERMVAST, NFEPERICMS, NFEPERICMSST, NFEPERRBISTXML, NFEPERIPI
 order by NFEITE

select *
  from TBS0921 with (nolock)
 where UFESIG='SP'
--       and NCMMVA < 10
       and round(NCMICMSINT,0)<>18

select NFEPROFOR
       ,NFEPERMVAST
       ,NFENCMXML NCM
       ,'' NCMEX
       ,'SP' UF
       ,iif(NFEPERMVAST > 0, round(((NFEPERMVAST-((1-NFEPERICMS/100)/(1-(round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2))/100)-1)*100)) / ((1-NFEPERICMS/100)/(1-(round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2))/100)),2), 0) MVA
       ,NFEPERIPI IPI
       ,NFEPERICMS
       ,NFEPERICMSST
       ,(1-NFEPERICMS/100)/(1-.18)
       ,((1-NFEPERICMS/100)/(1-.18)-1)*100
       ,(1-NFEPERICMS/100)/(1-.18)*100
       ,((NFEPERMVAST-((1-NFEPERICMS/100)/(1-.18)-1)*100))
       ,round(NFEPERICMSST * iif(NFEPERRBISTXML > 0, (100-NFEPERRBISTXML)/100, 1),2) ICMS
       ,*
  from TBS0591 with (nolock) 
 where NFENUM=36153
--       and NFENCMXML <> ''
--       and NFEPERICMSST > 0
--       and NFEPERMVAST > 0
--       and NFEITE=19
 order by NFEITE

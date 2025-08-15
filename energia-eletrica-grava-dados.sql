select FORNOM,* from TBS057 (nolock) where FORNOM Like('%ELETROPAULO%') and CPAVAL=42.95

select CPATIT,FORNOM,* from TBS057 (nolock) where FORNOM Like('BANDEIRANTE%') and CPATIT=1634077

select CPATIT,FORNOM,* from TBS057 (nolock) where FORNOM Like('BANDEIRANTE%') and CPAVAL=3572.62

select * from TBS057 (nolock) where FORNOM Like('BANDEIRANTE%') and FORCOD=761
 order by CPADATEMI desc

select FORNOM,* from TBS057 (nolock) where FORNOM Like('%ELETROPAULO%') and CPATIT=1692065

select * from TBS057 (nolock) where FORNOM Like('%ELETROPAULO%') and CPAVAL=2632.39

select * from TBS057 (nolock) where CPATIT in(430718)

select * from TBS057 (nolock) where FORNOM Like('%ELETROPAULO%') and CPAREFANO=2018 and CPAREFMES=1

select * from TBS057 (nolock) where FORNOM Like('%BANDEIRANTE%') and CPAREFANO=2018 and CPAREFMES=1

begin tran
update TBS057 set CTCCOD=4, CPAALICOFINS=7.6, CPAALIICMS=18, CPAALIPIS=1.65, CPABASCAL=2638.94, CPACFOP='1.253', CPAREFANO=2018, CPAREFMES=2 where CPATIT=9137907
rollback tran
commit tran

begin tran
update TBS057 set CPAREFMES=8 where CPATIT=1574917
rollback tran
commit tran

select * from TBS057 (nolock) where CPACFOP='1.253'

begin tran
update TBS057 set CPACFOP='1.253', CPAREFMES=6 where CPATIT in(1533833,1735926)
rollback tran
commit tran


begin tran
update TBS057 set CPACFOP='1.253' where CPATIT in(1526304)
rollback tran
commit tran


select * from TBS032 where ESTQTDATU < 0 or ESTQTDCMP < 0 or ESTQTDRES < 0 or ESTQTDPEN < 0

select * from TBS032
 where (ESTQTDATU < 0 or ESTQTDCMP < 0 or ESTQTDRES < 0 or ESTQTDPEN < 0) and
       exists(select 'ex' from TBS0551 where TBS0551.PROCOD=TBS032.PROCOD)

begin tran
update TBS032 set ESTQTDATU=0 where ESTQTDATU < 0
commit tran

select * from TBS032 where ESTQTDCMP > 0
select * from TBS0451 where not exists(select 'ne' from TBS032 where TBS032.PROCOD=TBS0451.PROCOD)

select * from TBS032 where ESTQTDATU > 0
select * from TBS032 where ESTQTDRES > 0
select * from TBS032 where ESTQTDPEN > 0
select * from TBS0551 where not exists(select 'ne' from TBS032 where TBS032.PROCOD=TBS0551.PROCOD)

select isnull(ESTQTDATU - ESTQTDRES ,0),* from TBS032 where ESTQTDRES > 0

select isnull(ESTQTDATU - ESTQTDRES ,0),* from TBS032 where ESTQTDPEN > 0

select PROCOD from TBS032 where ESTLOC = 1 and ESTQTDCMP <> (select isnull(sum(PDCQTD *PDCQTDEMB),0) from TBS0451
 where TBS0451.PROCOD=TBS032.PROCOD)


begin tran
update TBS032 set ESTQTDCMP = (select isnull(sum(PDCQTD *PDCQTDEMB),0) from TBS0451 where TBS0451.PROCOD=TBS032.PROCOD)
 where ESTLOC = 1 and ESTQTDCMP <> (select isnull(sum(PDCQTD *PDCQTDEMB),0) from TBS0451 where TBS0451.PROCOD=TBS032.PROCOD)
commit tran

select TBS0451.PROCOD,PDCQTD,PDCUNI,TBS032.PROCOD,ESTLOC,ESTQTDCMP
  from TBS0451 Left join TBS032 on TBS0451.PROCOD=TBS032.PROCOD where ESTLOC=1


select count(*) from TBS032 where ESTQTDCMP > 0

select FORPEDLIB,FORPEDBLQ,* from TBS006 where FORPEDLIB <> 0 or FORPEDBLQ <> 0


select PROCOD from TBS032
 where ESTQTDRES +ESTQTDPEN <> (select isnull(sum(PDVQTD *PDVQTDEMB),0) from TBS0551 where TBS0551.PROCOD=TBS032.PROCOD)

select PROCOD from TBS032
 where ESTLOC=1 and ESTQTDRES <> (select isnull(sum(PRPQTD *PRPQTDEMB),0) from TBS058
                                   where PRPMOVEST='S' and PRPSIT='R' and TBS058.PROCOD=TBS032.PROCOD)

select PROCOD from TBS032
 where ESTLOC=1 and ESTQTDPEN <> (select isnull(sum(PRPQTD *PRPQTDEMB),0) from TBS058
                                   where PRPMOVEST='S' and PRPSIT='P' and TBS058.PROCOD=TBS032.PROCOD)

--update TBS032 set ESTQTDRES=0 ,ESTQTDPEN=0 ,ESTQTDCMP=0
--update TBS032 set ESTQTDATU=50

select * from TBS058 where PRPSIT='R' and PROCOD='0040096'

select * from TBS0551 where PROCOD='0041688' and (PDVQTD-PDVQTDFAT) > 0
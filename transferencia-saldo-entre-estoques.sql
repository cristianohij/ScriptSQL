select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU > 0

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDATU > 0

select * into TBS032TRANSF from TBS032 with (nolock) where ESTLOC=1 and ESTQTDATU > 0

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDRES > 0

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDPEN > 0

select * from TBS032 with (nolock) where ESTLOC=1 and ESTQTDCMP > 0

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDCMP > 0

select top 1 * from TBS0371 with (nolock) 

select * from TBS032 with (nolock) where ESTLOC=2 and ESTQTDATU < 0

select 0 MVIEMPCOD
       ,58601 MVIDOC
       ,row_number() over(order by PROCOD) MVIITE
       ,0 PROEMPCOD
       ,PROCOD PROCOD
       ,PRODES MVIPRODES
       ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS032.PROCOD) MVIPROUNI
       ,ESTQTDATU MVIQTDPED
       ,ESTQTDATU MVIQTDATD
       ,1 MVIQTDEMB
       ,'N' MVIPROLOT
  into #TEMP
  from TBS032 with (nolock)
 where ESTLOC=1 and ESTQTDATU > 0 

drop table #TEMP

begin tran
delete TBS0371 where MVIDOC=58601
commit tran

insert into TBS0371 select * from #TEMP order by MVIITE

select * from TBS037 with (nolock) where MVIDOC=58601

update TBS037 set MVIULTITE=(select max(MVIITE) from TBS0371 with (nolock) where MVIDOC=58601) where MVIDOC=58601

select * from TBS0761 with (nolock) 
 where SDCPEN='S'
       and SDCQTDPED - (SDCQTDATD + SDCQTDRES) = 0

begin tran
update TBS0761 set SDCPEN='N'
 where SDCPEN='S'
       and SDCQTDPED - (SDCQTDATD + SDCQTDRES) = 0
commit tran

select * from TBS0761 with (nolock) 
 where SDCQTDATD > 0 and SDCQTDBAI = 0

select distinct SDCNUM from TBS0761 with (nolock) where LESCOD=2 and SDCQTDRES > 0

select * from TBS0761 with (nolock) 
 where SDCQTDPED - (SDCQTDATD + SDCQTDRES) > 0 --and SDCQTDATD > 0
       and LESCOD=1

update TBS0761 set LESCOD=2 where SDCNUM=11815 and PROCOD='20710001'

begin tran
update TBS0761 set LESCOD=2
 where SDCQTDPED - (SDCQTDATD + SDCQTDRES) > 0 --and SDCQTDATD > 0
       and LESCOD=1
commit tran

select * from TBS0451 with (nolock) where LESCOD=1 and PDCQTD-(PDCQTDENT+PDCQTDRES) > 0

begin tran
update TBS0451 set LESCOD=2 where LESCOD=1 and PDCQTD-(PDCQTDENT+PDCQTDRES) > 0
commit tran

update TBS032 set ESTQTDCMP=0 where ESTLOC=1 and ESTQTDCMP > 0

select * from TBS0161 with (nolock) where EMPCOD=1

select * from TBS0163 with (nolock) where LESCOD=2

select * into TBS0163EST1 from TBS0163 with (nolock) where LESCOD=1

begin tran
delete TBS0163 where LESCOD=1
commit tran


select * from TBS0761 with (nolock) where SDCNUM = 13849

select * from TBS0761 with (nolock) where SDCQTDATD - SDCQTDBAI > 0
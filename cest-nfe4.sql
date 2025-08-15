select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='18440002'

begin tran
update TBS010 set PROCEST='2805700' where PROCOD='18440002'
commit tran

select NFSCFOP,* from TBS0671 with (nolock) where SNESER=1 and NFSNUM=222946 order by NFSITE

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='0051349'

begin tran
update TBS010 set PROCEST='1101200' where PROCOD='0051349'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,*
  from TBS010 with (nolock)
 where PROCOD in(select PROCOD from TBS0671 with (nolock) where SNESER=1 and NFSNUM=222946)

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='7885725'

begin tran
update TBS010 set PROCEST='1903000' where PROCOD='7885725'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='25810001'

begin tran
update TBS010 set PROCEST='2805800' where PROCOD='25810001'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='7341000'

begin tran
update TBS010 set PROCEST='2806300' where PROCOD='7341000'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='18020001'

begin tran
update TBS010 set PROCEST='2805800' where PROCOD='18020001'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='0060052'

begin tran
update TBS010 set PROCEST='2806300' where PROCOD='0060052'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='4520538'

begin tran
update TBS010 set PROCEST='2806100' where PROCOD='4520538'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='1179953'

begin tran
update TBS010 set PROCEST='2101800' where PROCOD='1179953'
commit tran

select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,* from TBS010 with (nolock) where PROCOD='7440003'

begin tran
update TBS010 set PROCEST='0801800' where PROCOD='7440003'
commit tran




select *
  from TBS080 with (nolock)
       inner join TBS0671 with (nolock) on TBS0671.SNESER=TBS080.SNESER and TBS0671.NFSNUM=TBS080.ENFNUM
       inner join TBS010 with (nolock) on TBS0671.PROCOD=TBS010.PROCOD
 where ENFDATEMI='20180625'
       and PROCEST=''


select PROCEST,PROCLAFIS,PROSTBA,PROSTBB,*
  from TBS010 with (nolock)
 where PROCOD in(select PROCOD from TBS1172 with (nolock) where SNESER=1 and NFDNUM=222946)

select * from TBS1172 with (nolock) where NFDNUM=222946


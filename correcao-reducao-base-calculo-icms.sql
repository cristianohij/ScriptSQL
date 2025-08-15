select PROCOD,PRODES,PROPBISAI from TBS010 (nolock) where PROPBISAI > 0 order by PRODES

select PROCOD,PRODES,PROPBISAI from TBS010 (nolock) where PROPBISAI = 100 order by PRODES

begin tran
update TBS010 set PROPBISAI=0 where PROPBISAI in(.01,.1,1,10,12,18)
commit tran

select PROPBISAI,100-PROPBISAI,count(*) from TBS010 (nolock) where PROPBISAI > 0 group by PROPBISAI order by PROPBISAI

select PROSTBB,PROPBISAI,PROICMSINT,count(*) from TBS010 (nolock) where PROPBISAI > 0 and PROSTATUS='A' group by PROSTBB,PROPBISAI,PROICMSINT order by PROSTBB,PROPBISAI

select PROCOD,PRODES,PROPBISAI from TBS010 (nolock) where PROPBISAI = 10 order by PRODES

begin tran
update TBS010 set PROPBISAI=0 where PROPBISAI = 10
commit tran

select PROCOD,PRODES,PROPBISAI from TBS010 (nolock) where PROPBISAI = 48.8888 order by PRODES

begin tran
update TBS010 set PROPBISAI=48.880 where PROPBISAI = 48.8888
commit tran

select PROSTBB,count(*) from TBS010 (nolock) where PROPBISAI > 0 group by PROSTBB order by PROSTBB


select PROCOD,PRODES,PROCLAFIS,PROICMSINT,PROPBISAI,100-PROPBISAI,PROSTBA,PROSTBB,PROCSN,TGZCOD,
       (select TGZDES from MSL004 (nolock) where MSL004.TGZCOD=TBS010.TGZCOD)
  from TBS010 (nolock)
 where --PROPBISAI > 0
       TGZCOD > 9


select * from MSL004 (nolock)

select PROPBISAI,100-PROPBISAI,count(*) from TBS010 (nolock) where PROPBISAI > 0 and PROPBISAI<>26.67 group by PROPBISAI order by PROPBISAI

select * from TBS010 (nolock) where PROCOD='0055710'


select PROSTATUS,PROCOD,PROSTBB from TBS010 (nolock) where PROSTBB='0'

begin tran
update TBS010 set PROSTBB='00' where PROSTBB='0'
commit tran

select PROSTBB,PROREDBASICMS,PROICMSINT,count(*) from TBS010 (nolock) where PROREDBASICMS > 0 and PROSTATUS='A' group by PROSTBB,PROREDBASICMS,PROICMSINT order by PROSTBB,PROREDBASICMS

select PROPBISAI,100-PROPBISAI,count(*) from TBS010 (nolock) where PROPBISAI > 0 group by PROPBISAI order by PROPBISAI

begin tran
update TBS010 set PROREDBASICMS=26.6667 where PROPBISAI in(73.33,73.34)
commit tran
rollback tran

select PROREDBASICMS,count(*) from TBS010 (nolock) where PROREDBASICMS > 0 group by PROREDBASICMS

begin tran
update TBS010 set PROREDBASICMS=26.6667 where PROREDBASICMS=26.6666
commit tran


select PROREDBASICMS,count(*) from TBS010 (nolock) where PROREDBASICMS > 0 and PROPBISAI = 0 group by PROREDBASICMS

select PROREDBASICMS,count(*) from TBS010 (nolock) where PROREDBASICMS > 0 group by PROREDBASICMS

begin tran
update TBS010 set PROREDBASICMS=0 where PROREDBASICMS in(100)
commit tran
rollback tran

select count(*) from TBS010 (nolock) where PROREDBASICMS > 0
select count(*) from TBS010 (nolock) where PROPBISAI > 0


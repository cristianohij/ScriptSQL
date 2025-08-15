select SNESER,ENFNUM,ENFSIT from TBS080 (nolock) where SNESER=0 order by ENFNUM

select * from TBS104 (nolock)

begin tran
update TBS104 set SNENUM=3661 where SNESER=4
commit tran

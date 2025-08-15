select * from TBS0551 (nolock)
 where PDVBLQPRE='S' and
       not exists(select 'ne' from TBS053 where BCPTIPTRN='P' and BCPBLQPRE='S' and BCPNUM=PDVNUM)

select * from TBS053 where BCPNUM in(486,487) and BCPTIPTRN='P' and BCPBLQPRE='S'

begin tran
update TBS0551 set PDVBLQPRE='N'
 where PDVBLQPRE='S' and
       not exists(select 'ne' from TBS053 (nolock) where BCPTIPTRN='P' and BCPBLQPRE='S' and BCPNUM=PDVNUM)
commit tran


select * from TBS055 (nolock)
 where PDVBLQCRE='S' and
       not exists(select 'ne' from TBS053 where BCPTIPTRN='P' and BCPBLQCRE='S' and BCPNUM=PDVNUM)

begin tran
update TBS055 set PDVBLQCRE='N'
 where PDVBLQCRE='S' and
       not exists(select 'ne' from TBS053 (nolock) where BCPTIPTRN='P' and BCPBLQCRE='S' and BCPNUM=PDVNUM)
commit tran


select BCPTIPTRN,* from TBS053 (nolock)
 where BCPTIPTRN='P' and not exists(select 'ne' from TBS055 (noLock) where PDVNUM=BCPNUM)

begin tran
delete TBS053 from TBS053
 where BCPTIPTRN='P' and not exists(select 'ne' from TBS055 (nolock) where PDVNUM=BCPNUM)
commit tran

select * from TBS053 (nolock)
 where BCPTIPTRN='P' and BCPBLQCRE='S' and
       not exists(select 'ne' from TBS055 (noLock) where BCPNUM=PDVNUM)



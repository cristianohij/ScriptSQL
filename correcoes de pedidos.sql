select * from TBS055 A (noLock) join TBS0551 B (noLock) on A.PDVNUM=B.PDVNUM
 where A.PDVBLQCRE='S' and B.PDVQTD=B.PDVQTDFAT

select PDVNUM,PDVBLQCRE from TBS055 (noLock)
 where PDVBLQCRE='S' and
       exists(select * from TBS0551 (noLock)
               where TBS0551.PDVNUM=TBS055.PDVNUM and PDVQTD=PDVQTDFAT)

update TBS055 set PDVBLQCRE='N' from TBS055 (noLock)
 where PDVBLQCRE='S' and
       exists(select * from TBS0551 (noLock)
               where TBS0551.PDVNUM=TBS055.PDVNUM and PDVQTD=PDVQTDFAT)

select B.PDVNUM from TBS0551 as B (noLock) join TBS055 as A on B.PDVNUM=A.PDVNUM and A.PDVBLQCRE='S'
 group by B.PDVNUM
having sum(PDVQTD)=sum(PDVQTDFAT)

select 'N' from TBS0551 as B (noLock) join TBS055 as A on B.PDVNUM=A.PDVNUM and A.PDVBLQCRE='S'
 group by B.PDVNUM
having sum(PDVQTD)=sum(PDVQTDFAT)

begin tran
update TBS055 set PDVBLQCRE='N'
 where PDVNUM in(select A.PDVNUM from TBS055 as A (noLock) join TBS0551 as B on A.PDVNUM=B.PDVNUM and A.PDVBLQCRE='S'
                  group by A.PDVNUM
                 having sum(PDVQTD)=sum(PDVQTDFAT))
commit tran
rollback tran

select A.PDVNUM from TBS055 as A (noLock) join TBS0551 as B on A.PDVNUM=B.PDVNUM and A.PDVBLQCRE='S'
 group by A.PDVNUM
having sum(PDVQTD)=sum(PDVQTDFAT)




select A.PDVNUM from TBS055 as A (noLock) join TBS0551 as B on A.PDVNUM=B.PDVNUM
 where B.PDVQTDFAT > 0 and not exists(select 'ne' from TBS058 where PRPNUM=A.PDVNUM and PRPITEM=B.PDVITEM)
 group by A.PDVNUM
having sum(PDVQTD)<>sum(PDVQTDFAT)

select B.PDVNUM,B.PDVITEM from TBS0551 as B (noLock) join TBS055 as A on B.PDVNUM=A.PDVNUM
 where B.PDVQTDFAT > 0 and not exists(select 'ne' from TBS058 where PRPNUM=A.PDVNUM and PRPITEM=B.PDVITEM)
 group by B.PDVNUM,B.PDVITEM
having sum(PDVQTD)<>sum(PDVQTDFAT)

begin tran
update TBS0551 set PDVQTD=PDVQTDFAT
 where PDVQTD <> PDVQTDFAT and PDVQTDFAT > 0 and
       PDVNUM in(select A.PDVNUM from TBS055 as A (noLock) join TBS0551 as B on A.PDVNUM=B.PDVNUM
                  where B.PDVQTDFAT > 0 and not exists(select 'ne' from TBS058 where PRPNUM=A.PDVNUM)
                  group by A.PDVNUM
                 having sum(PDVQTD)<>sum(PDVQTDFAT))
commit tran
rollback tran



select PDVNUM from TBS0551
 where PDVQTDFAT = 0 and not exists(select 'ne' from TBS058 where PRPNUM=PDVNUM and PRPITEM=PDVITEM)

begin tran
delete TBS0551 where PDVQTDFAT = 0 and not exists(select 'ne' from TBS058 where PRPNUM=PDVNUM and PRPITEM=PDVITEM)
commit tran


select PRPNUM,PRPITEM from TBS058
 where not exists(select 'ne' from TBS0551 where PDVNUM=PRPNUM and PDVITEM=PRPITEM)

select PRPNUM from TBS058 (noLock)
 where not exists(select 'ne' from TBS055 (noLock) where PDVNUM=PRPNUM)
select A.PDVNUM from TBS055 as A (noLock) join TBS0551 as B on A.PDVNUM=B.PDVNUM
 where B.PDVQTDFAT > 0 and not exists(select 'ne' from TBS058 where PRPNUM=A.PDVNUM)
 group by A.PDVNUM
having sum(PDVQTD)<>sum(PDVQTDFAT)


select PDVNUM from TBS055 as A (noLock)
 where PDVDATCAD <= '20091231' and not exists(select 'ne' from TBS0551 as B (noLock) where B.PDVNUM=A.PDVNUM)

begin tran
delete TBS055
  from TBS055 as A (noLock)
 where PDVDATCAD <= '20091231' and not exists(select 'ne' from TBS0551 as B (noLock) where B.PDVNUM=A.PDVNUM)
commit tran


select BCPNUM from TBS053 where BCPTIPTRN='P' and not exists(select 'ne' from TBS055 where PDVNUM=BCPNUM)

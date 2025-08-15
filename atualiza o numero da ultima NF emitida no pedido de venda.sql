select NFSNUM,NFSPDVNUM,PDVNUM,PDVNFSNUM
  from TBS0672 (noLock) inner join TBS055 (noLock) on NFSPDVNUM=PDVNUM
 where PDVNFSNUM=0
 order by PDVNUM

begin tran
update TBS055 set PDVNFSNUM=(select max(NFSNUM) from TBS0672 (noLock) inner join TBS055 (noLock) on NFSPDVNUM=PDVNUM
                              where PDVNUM=292 and PDVNFSNUM=0)
 where PDVNUM=292 and PDVNFSNUM=0
commit tran
rollback tran

select PDVNUM,PDVNFSNUM from TBS055 where PDVNUM=292
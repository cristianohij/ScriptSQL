select SNESER,NFSCST,* from TBS0671 (nolock)
 where NFSNUM=3865
       and right(NFSCST,3)='101'
       and SNESER=3

begin tran
update TBS0671 set NFSCST=replace(NFSCST,'101','102') where SNESER=3 and NFSNUM=512 and right(NFSCST,3)='101'
commit tran
rollback tran

begin tran
update TBS0671 set NFSCST=replace(NFSCST,'101','102') where NFSNUM=3865 and right(NFSCST,3)='101'
commit tran
rollback tran

begin tran
update TBS0671 set NFSCST=replace(NFSCST,'101','102') where SNESER=1 and NFSNUM=3813 and right(NFSCST,3)='101'
commit tran
rollback tran

select PROSTBA,PROSTBB,PROCSN from TBS010 (nolock)
 where PROCOD in(
select PROCOD
  from TBS0671 (nolock)
 where NFSNUM=3804
)

begin tran
update TBS0671 set NFSCST=PROSTBA+PROCSN
  from TBS0671 (nolock)
       inner join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where NFSNUM=3804
commit tran


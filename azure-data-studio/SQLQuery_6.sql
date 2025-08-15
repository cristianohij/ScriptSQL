-- RETENCAO (IN RFB No. 1234 de 2012): IRRF 1,20% = 20,26

select *
  from TBS0675 with (nolock)
 where NFSNUM=246647

begin tran
update TBS0675
   set NFSDUPVAL=168.20
 where NFSNUM=246587

rollback tran
commit tran

select *
  from TBS056 with (nolock)
 where CRETIT=246587

begin tran
update TBS056
   set CREVAL=166.18
 where CRETIT=246587

rollback tran
commit tran
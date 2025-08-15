select * from TBS025 (nolock) where PARCHV=1137

select * from TBS0671 (nolock) where SNESER=3 and TESCOD=0

select count(*) from TBS0671 (nolock) where SNESER=3 and TESCOD=0 group by SNESER,NFSNUM

-- nd 543
-- tte 538
-- bb 512
-- misas 540

-- tanby matriz
begin tran
update TBS0671 set TESCOD=543 where SNESER=3 and TESCOD=0
commit tran
rollback tran


-- tanby taubaté
begin tran
update TBS0671 set TESCOD=538 where SNESER=3 and TESCOD=0
commit tran
rollback tran

-- best bag
begin tran
update TBS0671 set TESCOD=512 where SNESER=3 and TESCOD=0
commit tran
rollback tran

select * from TBS0671 (nolock) where SNESER=3 and TESCOD<>538

begin tran
update TBS0671 set TESCOD=538 where SNESER=3 and TESCOD<>538
commit tran



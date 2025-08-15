select * from TBS064

select COUNT(*) from TBS0594 where SERCOD = ''

begin tran
update TBS059 set SERCOD='NFE' where SERCOD=''
commit tran

begin tran
update TBS0593 set SERCOD=TBS059.SERCOD from TBS059 join TBS0593 on TBS059.NFETIP=TBS0593.NFETIP and TBS059.NFENUM=TBS0593.NFENUM and TBS059.NFECOD=TBS0593.NFECOD
 where TBS0593.SERCOD=''
commit tran
rollback tran

select distinct SERCOD from TBS059
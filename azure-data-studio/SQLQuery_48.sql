select *
  from TBS015 with (nolock)
 where PDPCOD=''

begin tran
delete TBS015
  where PDPCOD=''

rollback tran
commit tran 



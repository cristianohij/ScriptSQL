select *
  from TBS080 with (nolock)
 where ENFNUM=241141

begin tran
update TBS080
   set ENFSIT=5
 where ENFNUM=241141
commit tran

begin tran
update TBS080
   set ENFVALTOT=2422.43
 where ENFNUM=241141
commit tran

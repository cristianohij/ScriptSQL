select * from TBS104 (nolock)

select top 500 SNESER,ENFSER,ENFSIT,* from TBS080 (nolock) where SNESER=3 order by ENFDATEMI desc

begin tran
update TBS080 set ENFEMPCOD=9 where SNESER=4 and ENFNUM in(98945,98476,98477)
commit tran

select top 500 SNESER,ENFSER,ENFSIT,* from TBS080 (nolock) where SNESER=3 and ENFDATEMI between '20161201' and '20161228' order by ENFNUM desc
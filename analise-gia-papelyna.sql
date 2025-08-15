EXEC sp_GIA '02','2017'

select * from TBS080 (nolock) where ENFDATEMI between '20170201' and '20170228' order by ENFVALTOT

select * from TBS0801 (nolock)

select * from TBS080 (nolock) inner join TBS0801 (nolock) on TBS080.SNESER=TBS0801.SNESER and TBS080.ENFNUM=TBS0801.ENFNUM
 where ENFDATEMI between '20170225' and '20170228' order by ENFDATHOR desc


elect *
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
 where year(NFEDATENT)=2016 and month(NFEDATENT)=11 and NFECFOP='1.910' and NFEESTORI<>'SP'
 order by TBS0591.NFENUM

begin tran
update TBS0591 set NFECFOP='2.910' where NFENUM=119238 and NFECOD=1856 and NFECFOP='1.910'
commit tran
rollback tran

-- data do vencimento

select CREDATBAI,* from TBS056 (nolock) where CREDATEMI >= '20160101' and CREDATVEN = '17530101'

select * from TBS067 (nolock) where NFSNUM in(select CRETIT from TBS056 (nolock) where CREDATEMI >= '20160101' and CREDATVEN = '17530101')


-- data do vencimento real

select CREDATBAI,* from TBS056 (nolock) where CREDATEMI >= '20160101' and CREDATVENREA = '17530101'

select * from TBS067 (nolock) where NFSNUM in(select CRETIT from TBS056 (nolock) where CREDATEMI >= '20160101' and CREDATVENREA = '17530101')




select * from TBS008 (nolock)
 where CPGCOD in(select CPGCOD from TBS067 (nolock) where NFSNUM in(select CRETIT from TBS056 (nolock) where CREDATEMI >= '20160101' and CREDATVEN = '17530101'))

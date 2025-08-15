select d.NFSCFOP
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
       on c.NFSNUM=d.NFSNUM
 where c.NFSDATEMI >= '20150101'
 group by d.NFSCFOP




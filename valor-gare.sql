select sum(NFEGAREVALICMSST)
from TBS059 A (nolock) 
inner join TBS0591 B (nolock) on A.NFEEMPCOD = B.NFEEMPCOD and A.NFECOD = B.NFECOD and A.NFENUM = B.NFENUM and A.NFETIP = B.NFETIP and A.SERCOD = B.SERCOD and A.SEREMPCOD = B.SEREMPCOD
where NFEDATEFE between '20220101' and '20221231'

select d.*
  from TBS059 c with (nolock) 
 inner join TBS0591 d with (nolock)
    on d.NFEEMPCOD = c.NFEEMPCOD and d.NFECOD = c.NFECOD and d.NFENUM = c.NFENUM and d.NFETIP = c.NFETIP and d.SERCOD = c.SERCOD and d.SEREMPCOD = c.SEREMPCOD
 where c.NFEDATEFE >= '20240101'
       and NFEGARE='S' 

select *
  from TBS002 with (nolock)
 where (CLINOM Like ('%BEST BAG%')
        or CLINOM Like('%MISASPEL%')
        or CLINOM Like('%PAPELYNA%')
	    or CLINOM Like('%TANBY%'))
	   and CLIPORCOD in(0,237)



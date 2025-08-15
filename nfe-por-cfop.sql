select *
  from TBS0671 i with (nolock)
       inner join TBS067 c with (nolock)
          on i.NFSEMPCOD=c.NFSEMPCOD
             and i.NFSNUM=c.NFSNUM
       inner join TBS080 n with (nolock)
	      on n.ENFEMPCOD=c.NFSEMPCOD
		     and n.ENFNUM=c.NFSNUM
 where c.NFSCAN<>'S'
       and c.NFSDATEMI between '20211201' and '20211231'
	   and n.ENFSIT=6
	   and n.ENFCNPJCPF in('65069593000279','65069593000350')

select i.NFSNUM
       ,i.NFSCFOP
       ,count(*)
  from TBS0671 i with (nolock)
       inner join TBS067 c with (nolock)
          on i.NFSEMPCOD=c.NFSEMPCOD
		     and i.SNESER=c.SNESER
             and i.NFSNUM=c.NFSNUM
       inner join TBS080 n with (nolock)
	      on n.ENFEMPCOD=c.NFSEMPCOD
		     and n.SNESER=c.SNESER
		     and n.ENFNUM=c.NFSNUM
 where c.NFSCAN<>'S'
       and c.NFSDATEMI between '20211201' and '20211231'
	   and n.ENFSIT=6
	   and n.ENFCNPJCPF in('65069593000279','65069593000350')
	   and i.NFSCFOP in('5.409')
 group by i.NFSNUM,i.NFSCFOP

select *
  from TBS0671 i with (nolock)
--       inner join TBS067 c with (nolock)
          --on i.NFSEMPCOD=c.NFSEMPCOD
             --and i.NFSNUM=c.NFSNUM
 where SNESER=2
       and NFSNUM=26197
--       and c.NFSDATEMI between '20211201' and '20211231'

select *
  from TBS080 n with (nolock)
 where n.ENFCHAACE='35211265069593000198550020000261971581502767'
  




-- número de vendas por estado
select UFESIG,count(*) as 'qtde' from TBS067 (nolock) where NFSDATEMI >= '20130101' group by UFESIG order by 'qtde' desc

-- NCM utilizados
select TBS010.PROCLAFIS,count(*) as 'qtde'
  from TBS0671 (nolock) join TBS067 (nolock) on TBS0671.NFSEMPCOD=TBS067.NFSEMPCOD and TBS0671.NFSNUM=TBS067.NFSNUM
                        join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI >= '20130101'
 group by TBS010.PROCLAFIS
 order by 'qtde' desc
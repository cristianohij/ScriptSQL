declare @data as char(8)

set @data = '20160331'

select TBS010.PROCOD as codigo,
       TBS010.PRODES as descricao,
       TBS010.PROUM1 as un,
       isnull((select top 1 NFEPRE 
          from TBS0591 (nolock)
               right join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
         where TBS059.NFEDATENT <= @data and TBS0591.NFETIP='N' and TBS0591.SERCOD='NFE' and TBS059.NFECAN<>'S' and TBS0591.PROCOD=TBS010.PROCOD
         order by TBS059.NFEDATENT desc),0) as precoCompra,
       isnull((select top 1 NFEPERIPI
          from TBS0591 (nolock)
               right join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
         where TBS059.NFEDATENT <= @data and TBS0591.NFETIP='N' and TBS0591.SERCOD='NFE' and TBS059.NFECAN<>'S' and TBS0591.PROCOD=TBS010.PROCOD
         order by TBS059.NFEDATENT desc),0) as ipi,
       isnull((select top 1 NFEVALICMSST/NFEQTD
          from TBS0591 (nolock)
               right join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
         where TBS059.NFEDATENT <= @data and TBS0591.NFETIP='N' and TBS0591.SERCOD='NFE' and TBS059.NFECAN<>'S' and TBS0591.PROCOD=TBS010.PROCOD
         order by TBS059.NFEDATENT desc),0) as st,
       isnull((select TDPPRECOR1 from TBS031 (nolock) where TBS031.TDPPROCOD=TBS010.PROCOD),0) as precoVenda,
       isnull((select top 1 TBS0591.NFENUM
          from TBS0591 (nolock)
               right join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
         where TBS059.NFEDATENT <= @data and TBS0591.NFETIP='N' and TBS0591.SERCOD='NFE' and TBS059.NFECAN<>'S' and TBS0591.PROCOD=TBS010.PROCOD
         order by TBS059.NFEDATENT desc),0) as nf
    from TBS010
   where exists(select top 1 NFEPRE 
          from TBS0591 (nolock)
               right join TBS059 (nolock) on TBS0591.SERCOD=TBS059.SERCOD and TBS0591.NFETIP=TBS059.NFETIP and TBS0591.NFECOD=TBS059.NFECOD and TBS0591.NFENUM=TBS059.NFENUM
         where TBS059.NFEDATENT <= @data and TBS0591.NFETIP='N' and TBS0591.SERCOD='NFE' and TBS059.NFECAN<>'S' and TBS0591.PROCOD=TBS010.PROCOD
         order by TBS059.NFEDATENT desc)


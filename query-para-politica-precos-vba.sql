select top 100
       TBS015.PDPCOD,
       isnull(TBS0101.PROFORPRO,''),
       TBS010.PRODES,
       isnull(TBS0101.PROFORDES,''),
       TBS010.PROSTATUS,
       TBS010.PROCLAFIS,
       TBS010.PROSTBA+TBS010.PROSTBB,
       TBS010.PROSTBA+TBS010.PROCSN,
       TBS010.PROUM1,
       TBS010.PROUM1QTD,
       TBS010.PROUM2,
       TBS010.PROUM2QTD,
       TBS010.PROUM3,
       TBS010.PROUM3QTD,
       TBS010.PROUM4,
       TBS010.PROUM4QTD,
       TBS015.PDPPREFOR,
       TBS015.PDPUNI,
       TBS015.PDPQTDEMB,
       case when TBS015.PDPQTDEMB > 0 then TBS015.PDPPREFOR/TBS015.PDPQTDEMB end,
       -- aqui deve ser calculado o preço unitário
       TBS015.PDPIPI,
       TBS006.UFESIG,
       TBS001.UFEICM,
       TBS001.UFEICMPRO,
       TBS010.PROIVA,
       -- aqui deve ser calculado o MVA-ajustado
       -- aqui deve ser calculada a porcentagem da ST
       TBS015.PDPDIFICM,
       TBS015.PDPPIS,
       TBS015.PDPCOF,
       TBS015.PDPFRE,
       TBS015.PDPCUSADM,
       TBS015.PDPCMS,
       TBS015.PDPPDD1,
       TBS015.PDPPDD2,
       TBS015.PDPPDD3,
       TBS015.PDPPDD4,
       TBS015.PDPPDD5
       -- aqui deve ser calculado o custo unitário
  from TBS015 (nolock)
          left join TBS010 (nolock) on TBS010.PROCOD=TBS015.PDPCOD
          left join TBS0101 (nolock) on TBS0101.PROCOD=TBS010.PROCOD and TBS0101.PROFORCOD=TBS010.FORCOD
          left join TBS006 (nolock) on TBS006.FORCOD=TBS010.FORCOD
          left join TBS001 (nolock) on TBS001.UFESIG=TBS006.UFESIG
 where PDPCOD between '734' and '734Z'

select * from TBS015 (nolock) where PDPCOD='7346929'

select PROIVA,* from TBS010 (nolock) where PROIVA > 0
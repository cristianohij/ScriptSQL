select PDVORCNUM,*
  from TBS0551 (nolock) 
       join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
 where TBS055.PDVDATCAD >= '20150601' and
       TBS0551.PDVPRECUS=0


select *
  from TBS0551 (nolock) 
       join TBS055 (nolock) on TBS055.PDVNUM=TBS0551.PDVNUM
       join TBS042 (nolock) on TBS042.TESCOD=TBS0551.TESCOD
 where TBS055.PDVDATCAD >= '20150601' and
       TBS042.TESEST='S' and
       TBS0551.PDVMOVEST<>'S'
 order by TBS055.PDVDATCAD

select *
  from TBS0431 (nolock) 
       join TBS043 (nolock) on TBS043.ORCNUM=TBS0431.ORCNUM
 where TBS043.ORCDATCAD >= '20150601' and
       TBS0431.ORCPRECUS=0
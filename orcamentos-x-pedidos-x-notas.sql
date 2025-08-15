declare @datai char(8), @dataf char(8)

set @datai='20150801'
set @dataf='20150831'

/*
select ORCNUM,
       isnull((select PDVNUM from TBS055 (nolock) where PDVNUM=ORCPDVNUM),0)
 from TBS043 (nolock) where ORCDATCAD between @datai and @dataf
*/

select isnull((select rtrim(VENNOM)+' ('+Ltrim(str(VENCOD,4))+')' from TBS004 (nolock)
                where TBS004.VENCOD=case
                                       when TBS043.VENCOD > 0 then TBS043.VENCOD
                                       when TBS055.VENCOD > 0 then TBS055.VENCOD
                                       else TBS067.VENCOD
                                    end),'SEM VENDEDOR') as 'vendedor',
       isnull(ORCNUM,0) as 'NumeroOrcamento',
       case
          when ORCULTITE > 0 then dbo.ORCTOTLIQ(ORCEMPCOD, ORCNUM)
          else 0
       end as 'ValorOrcamento',
       isnull(PDVNUM,0) as 'NumeroPedido',
       isnull(NFSPDVVAL,0) as 'ValorPedido',
       isnull(TBS0672.NFSNUM,0) as 'NumeroNF',
       dbo.NFSTOTLIQ(TBS0672.NFSEMPCOD, TBS0672.NFSNUM, TBS0672.SNEEMPCOD, TBS0672.SNESER) as 'ValorNF',
       case 
          when (select count(*) from TBS0672 (nolock) where TBS0672.SNESER=TBS067.SNESER and TBS0672.NFSNUM=TBS067.NFSNUM) > 1 then 'S'
          else ''
       end as 'aglutinada'
  from TBS043 (nolock)
       full join TBS055 (nolock) on PDVNUM=ORCPDVNUM
       full join TBS0672 (nolock) on NFSPDVNUM=PDVNUM and SNESER=PDVNFSSER
       Left join TBS067 (nolock) on TBS067.SNESER=TBS0672.SNESER and TBS067.NFSNUM=TBS0672.NFSNUM
where (ORCDATCAD between @datai and @dataf and ORCULTITE > 0) or
      (PDVDATCAD between @datai and @dataf and PDVULTITE > 0) or
      (NFSDATEMI between @datai and @dataf)

--select top 500 * from TBS0672 (nolock)

-- 454644      1057.4900     342964      848.4900      3864        3283.7805     AGLUTINADA
-- 454644      1057.4900     342964      848.4900      3910        2017.6076     AGLUTINADA
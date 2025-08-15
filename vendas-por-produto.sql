-- retaguarda

declare @datai char(8),@dataf char(8)

-- tanby matriz/taubaté
--set @datai='20150301'
--set @dataf='20150731'

-- papelyna
--set @datai='20150101'
--set @dataf='20150731'

-- misaspel
set @datai='20150301'
set @dataf='20150731'

-- best bag
--set @datai='20150101'
--set @dataf='20150731'

-- best office
--set @datai='20150101'
--set @dataf='20150731'

--select PROCOD as 'Código',
--       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'Descrição',
--       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as 'Unidade',
--       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)/NFSQTDEMB) as 'Valor médio unitário',
--       sum(NFSQTD*NFSQTDEMB) as 'Quantidade',
--       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)) as 'Valor',
--       avg(NFSPRECUS/NFSQTDEMB) as 'Custo médio unitário',
--       (select TDPCUSBAS from TBS031 (nolock) where TBS031.TDPPROCOD=TBS0671.PROCOD) as 'Custo unitário atual',
--       (select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS0671.PROCOD) as 'Saldo disponível'
--  from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
--                                                      TBS067.NFSNUM=TBS0671.NFSNUM
--                          join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
-- where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and TESCNTVEN='S' and
--       NFSCLINOM not Like('%BEST BAG%') and NFSCLINOM not Like('%BEST OFFICE%') and NFSCLINOM not Like('%MISASPEL%') and NFSCLINOM not Like('%PAPELYNA%') and 
--       NFSCLINOM not Like('%TANBY%')
-- group by PROCOD


-- loja

--select M2_PROCOD as 'Código',
--       (select PRODES from TBS010 (nolock) where PROCOD=M2_PROCOD) as 'Descrição',
--       (select PROUM1 from TBS010 (nolock) where PROCOD=M2_PROCOD) as 'Unidade',
--       avg((M2_VALTOT-M2_ABT)/M2_QTD) as 'Valor mérdio unitário',
--      sum(M2_QTD) as 'Quantidade',
--       sum(M2_VALTOT-M2_ABT) as 'Valor',
--       avg(M2_PRECUS) as 'Custo médio unitário',
--       (select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=M2_PROCOD) as 'Custo unitário atual',
--       (select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=2 and PROCOD=M2_PROCOD) as 'Saldo disponível'
--  from MSL002 (nolock)
-- where M2_DAT between @datai and @dataf and
--       M2_REGCAN='F' and
--       M2_TIPREG='01'
-- group by M2_PROCOD


select PROCOD as 'Código',
       PRODES as 'Descrição',
       PROUM1 as 'Unidade',
       isnull((select avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)/NFSQTDEMB)
                 from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                                     TBS067.NFSNUM=TBS0671.NFSNUM
                                        left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and TESCNTVEN='S' and
                      NFSCLINOM not Like('%BEST BAG%') and NFSCLINOM not Like('%BEST OFFICE%') and NFSCLINOM not Like('%MISASPEL%') and NFSCLINOM not Like('%PAPELYNA%') and 
                      NFSCLINOM not Like('%TANBY%') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Valor médio unitário - Corporativo',
       isnull((select sum(NFSQTD*NFSQTDEMB)
                 from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                                     TBS067.NFSNUM=TBS0671.NFSNUM
                                        left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and TESCNTVEN='S' and
                      NFSCLINOM not Like('%BEST BAG%') and NFSCLINOM not Like('%BEST OFFICE%') and NFSCLINOM not Like('%MISASPEL%') and NFSCLINOM not Like('%PAPELYNA%') and 
                      NFSCLINOM not Like('%TANBY%') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Quantidade - Corporativo',
       isnull((select sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE))
                 from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                                     TBS067.NFSNUM=TBS0671.NFSNUM
                                        left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and TESCNTVEN='S' and
                      NFSCLINOM not Like('%BEST BAG%') and NFSCLINOM not Like('%BEST OFFICE%') and NFSCLINOM not Like('%MISASPEL%') and NFSCLINOM not Like('%PAPELYNA%') and 
                      NFSCLINOM not Like('%TANBY%') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Valor total - Corporativo',
       isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0)
          as 'Saldo disponível - Corporativo',
       isnull((select avg((M2_VALTOT-M2_ABT)/M2_QTD)
                 from MSL002 (nolock)
                where M2_DAT between @datai and @dataf and M2_REGCAN='F' and M2_TIPREG='01' and M2_PROCOD=PROCOD),0)
          as 'Valor médio unitário - Loja',
       isnull((select sum(M2_QTD)
                 from MSL002 (nolock)
                where M2_DAT between @datai and @dataf and M2_REGCAN='F' and M2_TIPREG='01' and M2_PROCOD=PROCOD),0)
          as 'Quantidade - Loja',
       isnull((select sum(M2_VALTOT-M2_ABT)
                 from MSL002 (nolock)
                where M2_DAT between @datai and @dataf and M2_REGCAN='F' and M2_TIPREG='01' and M2_PROCOD=PROCOD),0)
          as 'Valor total - Loja',
       isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=2 and TBS032.PROCOD=TBS010.PROCOD),0)
          as 'Saldo disponível - Loja',
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0)
          as 'Custo unitário atual'
  from TBS010 (nolock)
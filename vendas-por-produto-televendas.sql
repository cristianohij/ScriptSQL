-- retaguarda

declare @datai char(8),@dataf char(8)

-- tanby matriz/taubaté
--set @datai='20150301'
--set @dataf='20150731'

-- papelyna
--set @datai='20150101'
--set @dataf='20150731'

-- misaspel
set @datai='20151028'
set @dataf='20151030'

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
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and (TESCNTVEN='S' or NFSROPCNTVEN='S') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Valor médio unitário - Corporativo',
       isnull((select sum(NFSQTD*NFSQTDEMB)
                 from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                                     TBS067.NFSNUM=TBS0671.NFSNUM
                                        left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and (TESCNTVEN='S' or NFSROPCNTVEN='S') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Quantidade - Corporativo',
       isnull((select sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE))
                 from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.NFSEMPCOD=TBS0671.NFSEMPCOD and TBS067.SNEEMPCOD=TBS0671.SNEEMPCOD and TBS067.SNESER=TBS0671.SNESER and
                                                                     TBS067.NFSNUM=TBS0671.NFSNUM
                                        left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
                where NFSDATEMI between @datai and @dataf and NFSTIP='N' and NFSCAN='N' and (TESCNTVEN='S' or NFSROPCNTVEN='S') and TBS0671.PROCOD=TBS010.PROCOD),0)
          as 'Valor total - Corporativo',
       isnull((select ESTQTDATU-ESTQTDRES from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),0)
          as 'Saldo disponível - Corporativo',
       isnull((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD=PROCOD),0)
          as 'Custo unitário atual'
  from TBS010 (nolock)


--

declare @dataDe char(8), @dataAte char(8)

set @dataDe = '20151001'
set @dataAte = '20151031'

select TBS0671.PROCOD as 'codigo',
       isnull((select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'descricao',
       isnull((select PROUM1 from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD),'') as 'UN',
       avg(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)/NFSQTDEMB) as 'PrecoMedioUnitario',
       sum(NFSQTD*NFSQTDEMB) as 'quantidade',
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)) as 'total',
       avg(NFSPRECUS/NFSQTDEMB) as 'CustoMedioUnitario'
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
 where TBS067.NFSDATEMI between @dataDe and @dataAte and NFSTIP='N' and NFSCAN='N' and (TESCNTVEN='S' or NFSROPCNTVEN='S')
group by TBS0671.PROCOD

select NFSPRODES from TBS0671 (nolock)


--


select * from TBS0671 (nolock) right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20150901' and '20150930' and
       TBS0671.NFSQTDDEV > 0



declare @dataDe char(8), @dataAte char(8)

set @dataDe = '20151101'
set @dataAte = '20151130'

select 'NF-E',
       TBS0671.PROCOD as codigo,
       TBS0671.NFSPRODES as descricao,
       TBS010.PROUM1 as UN,
       NFSQTD*NFSQTDEMB as 'quantidade',
       round(dbo.NFSPRELIQ(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,NFSITE)/NFSQTDEMB,2) as PrecoUnitario,
       round(NFSPRECUS/NFSQTDEMB,4) as 'CustoUnitario',
       round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2) as TotalVendido,
       round(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2) as ICMS,
       case when TBS010.PROSTBPIS>='06' then 0 else round(round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2)*0.0165,2) end as PIS,
       case when TBS010.PROSTBCOFINS>='06' then 0 else round(round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2)*0.076,2) end as COFINS,
       round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2) -
       case when NFSPERICMSST > 0 then round(dbo.NFSVALICMS(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2) else 0 end +
       case when NFSPERICMSST = 0 then round(dbo.NFSVALICMSST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE),2) else 0 end -
       case when TBS010.PROSTBPIS>='06' then 0 else round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)*0.0165,2) end -
       case when TBS010.PROSTBCOFINS>='06' then 0 else round(dbo.NFSTOTITE(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)*0.076,2) end
       as VendaLiquida,
       TBS067.NFSDATEMI as emissao,
       TBS0671.NFSNUM as NF,
       TBS0671.SNESER as serie,
       TBS0671.NFSITE as item,
       TBS0671.NFSCST as cstICMS,
       TBS0671.NFSCFOP as CFOP
  from TBS0671 (nolock)
       right join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       Left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
       Left join TBS010 (nolock) on TBS010.PROCOD=TBS0671.PROCOD
 where TBS067.NFSDATEMI between @dataDe and @dataAte and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS0671.NFSCFOP in('5.102','6.102','5.116','6.116','5.403','6.403','5.405','6.404','5.922','6.922','6.108') and
       (TBS067.NFSCLINOM Like('%BEST BAG%') or NFSCLINOM Like('%BEST OFFICE%') or NFSCLINOM Like('%MISASPEL%') or NFSCLINOM Like('%PAPELYNA%'))
 order by TBS067.NFSDATEMI,TBS0671.NFSNUM,TBS0671.SNESER,TBS0671.NFSITE


--  GZ

declare @dataDe char(8), @dataAte char(8)

set @dataDe = '20151001'
set @dataAte = '20151031'

select 'ECF',
       MSL002.M2_PROCOD as codigo,
       TBS010.PRODES as descricao,
       TBS010.PROUM1 as UN,
       MSL002.M2_QTD as 'quantidade',
       round(MSL002.M2_VALUNI,2) as PrecoUnitario,
       round(MSL002.M2_PRECUS,4) as 'CustoUnitario',
       round(MSL002.M2_VALTOT-MSL002.M2_ABT,2) as TotalVendido,
       round((MSL002.M2_VALTOT-MSL002.M2_ABT)*convert(decimal(5,2),subString(MSL002.M2_TRB,2,4))/100,2) as ICMS,
       case when TBS010.PROSTBPIS>='06' then 0 else round((MSL002.M2_VALTOT-MSL002.M2_ABT)*0.0165,2) end as PIS,
       case when TBS010.PROSTBCOFINS>='06' then 0 else round((MSL002.M2_VALTOT-MSL002.M2_ABT)*0.076,2) end as COFINS,
       round(MSL002.M2_VALTOT-MSL002.M2_ABT,2)-
       round((MSL002.M2_VALTOT-MSL002.M2_ABT)*convert(decimal(5,2),subString(MSL002.M2_TRB,2,4))/100,2)-
       case when TBS010.PROSTBPIS>='06' then 0 else round((MSL002.M2_VALTOT-MSL002.M2_ABT)*0.0165,2) end -
       case when TBS010.PROSTBCOFINS>='06' then 0 else round((MSL002.M2_VALTOT-MSL002.M2_ABT)*0.076,2) end
       as VendaLiquida,
       MSL002.M2_DAT as emissao,
       MSL002.M2_NUMDOC as cupom,
       MSL002.M2_CXA as caixa,
       MSL002.M2_NUMORDITE as item
  from MSL002 (nolock)
       Left join TBS010 (nolock) on TBS010.PROCOD=MSL002.M2_PROCOD
 where MSL002.M2_DAT between @dataDe and @dataAte and
       MSL002.M2_TIPREG = '01' and
       MSL002.M2_REGCAN = 'F'
 order by MSL002.M2_DAT,MSL002.M2_NUMDOC,MSL002.M2_CXA,MSL002.M2_NUMORDITE


select top 10 convert(decimal(5,2),subString(MSL002.M2_TRB,2,4)),* from MSL002 (nolock) where M2_TRB<>''



-- devoluções

select TBS059.NFEDATENT,TBS0591.NFESNESER,TBS0591.NFENFSNUM,*
  from TBS0591 (nolock)
       right join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.NFECOD=TBS0591.NFECOD and TBS059.SERCOD=TBS0591.SERCOD
 where TBS0591.NFETIP='D' and
       TBS059.NFENOSFOR='S' and
       TBS0591.NFENFSNUM=0
 order by TBS059.NFEDATENT desc

declare @dataDe char(8), @dataAte char(8)

set @dataDe = '20151101'
set @dataAte = '20151130'

select 'DEV',
       TBS0591.PROCOD as codgo,
       TBS010.PRODES as descricao,
       TBS010.PROUM1 as UN,
       NFEQTD*NFEQTDEMB as 'quantidade',
       dbo.NFEPRELIQ(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) as PrecoUnitario,
       0 as 'CustoUnitario',
       -1*(round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2)) as TotalDevolvido,
       -1*(round(dbo.NFEVALICMS(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2)) as ICMS,
       case when TBS010.PROSTBPIS>='06' then 0 else -1*(round(round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2)*0.0165,2)) end as PIS,
       case when TBS010.PROSTBCOFINS>='06' then 0 else -1*(round(round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2)*0.076,2)) end as COFINS,
       -1*(round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2) -
       case when NFEPERICMSST > 0 then round(dbo.NFEVALICMS(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2) else 0 end +
       case when NFEPERICMSST = 0 then round(dbo.NFEVALICMS(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE),2) else 0 end -
       case when TBS010.PROSTBPIS>='06' then 0 else round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE)*0.0165,2) end -
       case when TBS010.PROSTBCOFINS>='06' then 0 else round(dbo.NFETOTITE(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS059.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE)*0.076,2) end)
       as DevolucaoLiquida,
       TBS059.NFEDATEMI as emissao,
       TBS059.NFETIP as tipo,
       TBS0591.NFENUM as NF,
       TBS0591.SERCOD as serie
  from TBS0591 (nolock)
       right join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFENUM=TBS0591.NFENUM and TBS059.NFECOD=TBS0591.NFECOD and TBS059.SERCOD=TBS0591.SERCOD
       Left join TBS010 (nolock) on TBS010.PROCOD=TBS0591.PROCOD
 where TBS059.NFEDATEMI between @dataDe and @dataAte and
       TBS0591.NFETIP='D' and
       TBS0591.NFENFSNUM > 0 and
       (TBS059.NFENOM Like('%BEST BAG%') or NFENOM Like('%BEST OFFICE%') or NFENOM Like('%MISASPEL%') or NFENOM Like('%PAPELYNA%'))

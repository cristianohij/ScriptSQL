select *
  into TBS067TR
  from TBS067 with (nolock)
 where NFSDATEMI between '20190101' and '20190131'
       and NFSTIP='N'
       and NFSCAN<>'S'
       and NFSCLINOM Like('TANBY%')

select * from TBS067TR with (nolock)

drop table TBS067TR

select TBS0671.*
  into TBS0671TR
  from TBS067 with (nolock)
       inner join TBS0671 with (nolock)
       on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20190101' and '20190131'
       and NFSTIP='N'
       and NFSCAN<>'S'
       and NFSCLINOM Like('TANBY%')

select * from TBS0671TR with (nolock) order by NFSNUM, NFSITE

drop table TBS0671TR

select NFSPRE
,NFSQTDEMB*(select top 1 NFEPRE
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where TBS0591.NFETIP='N'
       and TBS059.NFECAN<>'S'
       and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
       and right(NFECFOP,3) in('102','403','121','202','411')
       and TBS0591.PROCOD=TBS0671TR.PROCOD
 order by TBS059.NFEDATEFE desc)
  from TBS0671TR with (nolock)
 order by NFSNUM, NFSITE

alter table TBS0671TR add PRECOM decimal(12,6)
alter table TBS0671TR add PRECUS decimal(12,6)

update TBS0671TR set PRECOM=
NFSQTDEMB*(select top 1 (NFETOTOPEITE - NFEVALICMSST - NFEVALIPI) / NFEQTD
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where TBS0591.NFETIP='N'
       and TBS059.NFECAN<>'S'
       and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
       and right(NFECFOP,3) in('102','403','121','202','411')
       and TBS0591.PROCOD=TBS0671TR.PROCOD
 order by TBS059.NFEDATEFE desc)

select * from TBS0671TR with (nolock) where PRECOM is null

update TBS0671TR set PRECUS=
NFSQTDEMB*(select top 1 CUSTO
             from SALDOINICIAL s with (nolock)
            where DATA <= '20190201'
                  and s.CODIGO=PROCOD
                  and CUSTO > 0
            order by DATA desc)


select *
  from TBS0671TR with (nolock)
 where NFSPDDITE + NFSFREITE + NFSSEGITE + NFSDESITE > 0


select NFSCFOP
       ,sum(NFSQTD * NFSPRE) valor_normal
       ,sum(NFSQTD * NFSPRE * NFSPERICMS / 100) icms_valor_normal
       ,sum(NFSQTD * case PRECOM
                        when 0 then NFSPRE
                        else PRECOM
                     end) valor_compra
       ,sum(NFSQTD * case PRECOM
                        when 0 then NFSPRE
                        else PRECOM
                     end * NFSPERICMS / 100) icms_valor_compra
       ,sum(NFSQTD * case PRECUS
                        when 0 then NFSPRE
                        else PRECUS
                     end) valor_custo
       ,sum(NFSQTD * case PRECUS
                        when 0 then NFSPRE
                        else PRECUS
                     end * NFSPERICMS / 100) icms_valor_custo
  from TBS067TR with (nolock)
       inner join TBS0671TR with (nolock)
       on TBS0671TR.SNESER=TBS067TR.SNESER and TBS0671TR.NFSNUM=TBS067TR.NFSNUM
 group by NFSCFOP

select *
  from TBS0671TR with (nolock)
 where NFSCFOP='5.405'

update TBS0671TR set NFSCFOP='5.102'  where NFSCFOP='5.152'

select *
  from TBS067 with (nolock)
       inner join TBS0671 with (nolock)
       on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20190101' and '20190131'
       and NFSTIP='N'
       and NFSCLINOM Like('TANBY%')
       and NFSCFOP in('5.102','5.405')

select *
  from TBS0671TR with (nolock)
 where NFSREDBCICMS > 0


select PROCOD,NFSPRE,PRECOM
  from TBS0671TR with (nolock)

update TBS0671TR set PRECOM=
NFSQTDEMB*(select top 1 (NFETOTOPEITE - NFEVALICMSST - NFEVALIPI) / NFEQTD
  from TBS0591 (nolock)
       inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where TBS0591.NFETIP='N'
       and TBS059.NFECAN<>'S'
       and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
       and right(NFECFOP,3) in('102','403','121','202','411')
       and TBS0591.PROCOD=TBS0671TR.PROCOD
 order by TBS059.NFEDATEFE desc)

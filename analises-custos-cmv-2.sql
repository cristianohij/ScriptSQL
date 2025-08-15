select *
  from TBS067 with (nolock)
       inner join TBS0671 with (nolock)
       on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
 where NFSDATEMI between '20190101' and '20190131'
       and NFSCLINOM not Like('%TANBY%')

select NFSTIP,count(*)
  from TBS067 with (nolock)
 where NFSDATEMI between '20190101' and '20190131'
 group by NFSTIP

select NFETIP,count(*)
  from TBS059 with (nolock)
 where NFEDATEFE between '20190101' and '20190131'
 group by NFETIP

select top 1 * from TBS059 with (nolock)

select NFECFOP
       --,sum(dbo.NFETOTOPE(0, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD))
       ,sum(NFETOTOPEITE)
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
       and TBS059.NFECAN<>'S'
       and FORCGC in('65069593000198','65069593000279','65069593000350')
 group by NFECFOP

select *
  from TBS059 with (nolock)
 where NFEDATEFE between '20190101' and '20190131'
       and NFENOM Like('%TANBY%')

select NFECFOP
       --,sum(dbo.NFETOTOPE(0, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD))
       ,sum(NFETOTOPEITE)
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
       and TBS059.NFECAN<>'S'
       and FORCGC in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117')
 group by NFECFOP

select *
  from TBS059 with (nolock)
 where NFEDATEFE between '20190101' and '20190131'
       and (NFENOM Like('%BEST BAG%')
            or NFENOM Like('%MISASPEL%')
            or NFENOM Like('%PAPELYNA%'))

select top 1 * from TBS0591 with (nolock)

select LESCOD
       ,NFECFOP
       --,sum(dbo.NFETOTOPE(0, TBS059.NFETIP, TBS059.NFENUM, TBS059.NFECOD, 0, TBS059.SERCOD))
       ,sum(NFETOTOPEITE)
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
       and TBS059.NFECAN<>'S'
--       and FORCGC in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117')
 group by LESCOD,NFECFOP
 order by LESCOD,NFECFOP

select top 1 CUSTO
  from SALDOINICIAL s with (nolock)
 where DATA <= '20190201'
       and s.CODIGO='2130393'
       and CUSTO > 0
 order by DATA desc

select dbo.CUSTOPOLITICA(0,'2130393')

select PROCOD
  from TBS051 with (nolock)
 where convert(date,LMEDATHOR) between '20190101' and '20190131'
       and LMEINFALT='E'
       and LMEROT='PEST005'
       and PROCOD not in
('0051594',
'0060259',
'14000008',
'14000009',
'15100008',
'1070029',
'99988643',
'4520012',
'4520040',
'0060077',
'4520526',
'3250389',
'3251237',
'3252256',
'4520701',
'7881243',
'25310002',
'8060024',
'8060304',
'8060362',
'8060366',
'8061004',
'2130393',
'1440012',
'1440017',
'1440063',
'1440187',
'1440225',
'1440325',
'1440879',
'1448177',
'7653247',
'7653248',
'7653249',
'7653255',
'7653259',
'7653261',
'7653268',
'7653269',
'3794753',
'1083678',
'1083774',
'8490574')
group by PROCOD

select TBS0591.NFETIP
       ,TBS0591.NFENUM
       ,TBS0591.NFECOD
       ,TBS0591.PROCOD
       ,TBS0591.NFEQTD
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
       and TBS059.NFECAN<>'S'
       and NFEMOVEST='N'

select *
  from SALDOINICIAL with (nolock)
 where DATA='20190201'
       and CUSTO >= (select TDPPRECOR1 from TBS031 with (nolock) where TDPPROCOD=CODIGO)

drop table #ctenf

select TBS059.NFECHAACE chave_nf
       ,sum(NFEVALFREITECTE) valor_cte
  into #ctenf
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190105'
--       and TBS059.NFECAN<>'S'
 group by TBS059.NFECHAACE

select *
       ,isnull((select sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
           from TBS1301 with (nolock)
                inner join
                TBS130 with (nolock)
                on TBS130.CTEENTCHA=TBS1301.CTEENTCHA
          where CTEENTCHADOC=chave_nf),0)
  from #ctenf

select *
       ,isnull((select sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
           from TBS1301 with (nolock)
                inner join
                TBS130 with (nolock)
                on TBS130.CTEENTCHA=TBS1301.CTEENTCHA),0)
  from #ctenf
       inner join TBS1301 with (nolock)
       on CTEENTCHADOC=chave_nf
       
select chave_nf
       ,count(*)
  from #ctenf
 group by chave_nf
having count(*) > 1

select sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
       ,sum(dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
  from TBS130 with (nolock)
       inner join
       TBS1301 with (nolock)
       on TBS1301.CTEENTCHA=TBS130.CTEENTCHA
       inner join
       TBS059 with (nolock)
       on TBS059.NFECHAACE=TBS1301.CTEENTCHADOC
 where CTEENTDEFDOC between '20190101' and '20190105'
       and TBS059.NFECAN<>'S'

drop table #entradas

select NFECFOP
       ,sum(NFETOTOPEITE) valor_contabil
       ,sum
        (
           case
              when right(NFECFOP,3)='403' then 0
              else NFEVALICMS
           end
        ) valor_icms
       ,sum(NFEVALFREITECTE) frete_cte
       ,sum
        (
           case
              when right(NFECFOP,3) in('102','403') then NFETOTOPEITE - NFEVALICMSST
              else 0
           end
        ) * 1.65 / 100 pis
       ,sum
        (
           case
              when right(NFECFOP,3) in('102','403') then NFETOTOPEITE - NFEVALICMSST
              else 0
           end
        ) * 7.60 / 100 cofins
  into #entradas
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190102'
       and TBS059.NFECAN<>'S'
       --and NFEMOVEST='N'
 group by NFECFOP

select *
       ,NFETOTOPEITE valor_item
  from
  (
select (select PROSTBPIS from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) cst_pis
       ,TBS0591.*
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
       and TBS059.NFECAN<>'S'
       and right(NFECFOP,3) in('102','403')
  ) t
 where cst_pis <> ''

select TBS0671.NFSCFOP
       ,sum(dbo.NFSTOTITEST(0, TBS0671.NFSNUM, 0, TBS0671.SNESER, TBS0671.NFSITE)) valor_contabil
  from TBS0671 with (nolock)
       inner join TBS067 with (nolock)
       on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20190101' and '20190131'
 group by TBS0671.NFSCFOP

drop table #saidas

select CFOP
       ,sum(valor_item) contabil
       ,sum(valor_custo) custo
       ,sum(valor_icms) icms
  into #saidas
  from
  (
select TBS0671.NFSCFOP CFOP
       ,TBS0671.PROCOD produto
       ,dbo.NFSTOTITEST(0, TBS0671.NFSNUM, 0, TBS0671.SNESER, TBS0671.NFSITE) valor_item
       ,dbo.NFSVALICMS(0, TBS0671.NFSNUM, 0, TBS0671.SNESER, TBS0671.NFSITE) valor_icms
       ,sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) *
        case
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=TBS0671.PROCOD
                               and CUSTO > 0
                             order by DATA desc),0) > 0
           then isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=TBS0671.PROCOD
                               and CUSTO > 0
                         order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,TBS0671.PROCOD),0)
        end valor_custo
  from TBS0671 with (nolock)
       inner join TBS067 with (nolock)
       on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
 where TBS067.NFSDATEMI between '20190101' and '20190102'
       and TBS067.NFSCAN<>'S'
       and TBS0671.NFSMOVEST='S'
 group by TBS0671.NFSCFOP, TBS0671.SNESER, TBS0671.NFSNUM, TBS0671.NFSITE, TBS0671.PROCOD
  ) t
 group by CFOP

drop table #custo

select sum(valor_custo) custo
  into #custo
  from
  (
select PROCOD
       ,sum(ESTQTDATU) *
        case
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=PROCOD
                               and CUSTO > 0
                             order by DATA desc),0) > 0
           then isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=PROCOD
                               and CUSTO > 0
                         order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,PROCOD),0)
        end valor_custo
  from SALDODIARIO with (nolock)
 where ESTDATSAL='20190102'
       and ESTLOC in(1,2,3,4,7,9)
 group by PROCOD
  ) t

drop table #cte

select NFECFOP
       ,sum(NFETOTOPEITE) valor_contabil
       ,sum
        (
           case
              when right(NFECFOP,3)='403' then 0
              else NFEVALICMS
           end
        ) valor_icms
       ,sum(NFEVALFREITECTE) frete_cte
       ,sum
        (
           case
              when right(NFECFOP,3) in('102','403') then NFETOTOPEITE - NFEVALICMSST
              else 0
           end
        ) * 1.65 / 100 pis
       ,sum
        (
           case
              when right(NFECFOP,3) in('102','403') then NFETOTOPEITE - NFEVALICMSST
              else 0
           end
        ) * 7.60 / 100 cofins
  into #cte
  from TBS0591 (nolock)
       inner join TBS059 (nolock)
       on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       inner join TBS006 (nolock)
       on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD
 where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190102'
       and TBS059.NFECAN<>'S'
       --and NFEMOVEST='N'
 group by NFECFOP

select sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
       ,sum(dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
       ,sum(CTEENTBASICM)
  from TBS130 with (nolock)
       inner join
       TBS1301 with (nolock)
       on TBS1301.CTEENTCHA=TBS130.CTEENTCHA
       inner join
       TBS059 with (nolock)
       on TBS059.NFECHAACE=TBS1301.CTEENTCHADOC
 where CTEENTDEFDOC between '20190101' and '20190102'
       and TBS059.NFECAN<>'S'

select * from TBS059 with (nolock)

select * from #entradas

select * from #saidas

select * from #custo

select * from #cte

select sum(saldo * custo) custo_dez
  from
  (
select 
          (
             case when E1 > 0 then E1 else 0 end +
             case when E2 > 0 then E2 else 0 end +
             case when E3 > 0 then E3 else 0 end +
             case when E4 > 0 then E4 else 0 end +
             case when E7 > 0 then E7 else 0 end +
             case when E9 > 0 then E9 else 0 end
          ) saldo
          ,isnull(dbo.CUSTOPOLITICA(0,CODIGO),0) custo
  from INV1812 with (nolock)
 where
    (
       case when E1 > 0 then E1 else 0 end +
       case when E2 > 0 then E2 else 0 end +
       case when E3 > 0 then E3 else 0 end +
       case when E4 > 0 then E4 else 0 end +
       case when E7 > 0 then E7 else 0 end +
       case when E9 > 0 then E9 else 0 end
    ) > 0
  ) t

select sum(saldo * custo) custo_jan
  from
  (
select 
          (
             case when E1 > 0 then E1 else 0 end +
             case when E2 > 0 then E2 else 0 end +
             case when E3 > 0 then E3 else 0 end +
             case when E4 > 0 then E4 else 0 end +
             case when E7 > 0 then E7 else 0 end +
             case when E9 > 0 then E9 else 0 end
          ) saldo
          ,isnull(dbo.CUSTOPOLITICA(0,CODIGO),0) custo
  from INV1901 with (nolock)
 where
    (
       case when E1 > 0 then E1 else 0 end +
       case when E2 > 0 then E2 else 0 end +
       case when E3 > 0 then E3 else 0 end +
       case when E4 > 0 then E4 else 0 end +
       case when E7 > 0 then E7 else 0 end +
       case when E9 > 0 then E9 else 0 end
    ) > 0
  ) t

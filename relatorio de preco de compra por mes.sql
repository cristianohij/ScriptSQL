select max(NFEDATEMI),PROCOD, --avg(NFEPRE/case NFEQTDEMB when 0 then 1 else NFEQTDEMB end)
       (select NFEPRE from TBS0591 c (nolock)
         where c.NFEEMPCOD = a.NFEEMPCOD and c.NFETIP = a.NFETIP and c.NFENUM = a.NFENUM and c.NFECOD = a.NFECOD and
               c.SEREMPCOD = a.SEREMPCOD and c.SERCOD = a.SERCOD)
  from TBS0591 a (nolock) join TBS059 b (nolock) on b.NFEEMPCOD = a.NFEEMPCOD and b.NFETIP = a.NFETIP and
                                                    b.NFENUM = a.NFENUM and b.NFECOD = a.NFECOD and
                                                    b.SEREMPCOD = a.SEREMPCOD and b.SERCOD = a.SERCOD
 where NFEDATEMI >= '20121001'
 group by month(NFEDATEMI),PROCOD 
 order by PROCOD


select 'ano-mes','codigo-produto','descricao-produto','unidade-medida','preco-medio','preco-custo-atual','preco-venda-corporativo','preco-venda-loja'

select convert(char(7),NFEDATEMI,111) as 'ano-mes',
       TBS0591.PROCOD as 'codigo-produto',
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD = TBS0591.PROCOD) as 'descricao-produto',
       (select PROUM1 from TBS010 (nolock) where TBS010.PROCOD = TBS0591.PROCOD) as 'unidade-medida',
       --avg(NFEPRE/case NFEQTDEMB when 0 then 1 else NFEQTDEMB end) as 'preco-medio',
       isnull(round(avg(dbo.NFEPRELIQ(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) /
           case NFEQTDEMB when 0 then 1 else NFEQTDEMB end *
           case NFEPERIPI when 0 then 1 else NFEPERIPI/100 end),2),0) as 'preco-medio',
       isnull(round((select TDPCUSBAS from TBS031 (nolock) where TDPPROCOD = TBS0591.PROCOD),2),0) as 'preco-custo-atual',
       isnull(round((select TDPPRECOR1 from TBS031 (nolock) where TDPPROCOD = TBS0591.PROCOD),2),0) as 'preco-venda-corporativo',
       isnull(round((select TDPPRELOJ1 from TBS031 (nolock) where TDPPROCOD = TBS0591.PROCOD),2),0) as 'preco-venda-loja'
  from TBS0591 TBS0591 (nolock) join TBS059 TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and TBS0591.NFETIP = TBS059.NFETIP and
                                                               TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and
                                                               TBS0591.SEREMPCOD = TBS059.SEREMPCOD and TBS0591.SERCOD = TBS059.SERCOD
 where NFEDATEMI between '20120201' and '20130228' and --TBS0591.PROCOD = '1640054' and
       TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
       TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
 group by convert(char(7),NFEDATEMI,111),PROCOD 
 order by 'ano-mes'

select NFEDATEMI,NFEPRE,NFEPERIPI,NFEPRE*NFEPERIPI/100,NFEQTDEMB
  from TBS0591 (nolock) join TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and TBS0591.NFETIP = TBS059.NFETIP and
                                                TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and
                                                TBS0591.SEREMPCOD = TBS059.SEREMPCOD and TBS0591.SERCOD = TBS059.SERCOD
 where NFEDATEMI >= '20121001' and PROCOD = '1640054' and
       TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
       TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
 order by NFEDATEMI

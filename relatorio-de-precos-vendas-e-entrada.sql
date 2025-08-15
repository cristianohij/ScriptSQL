select TDPPROCOD as 'codigo',
       (select PRODES from TBS010 (nolock) where PROCOD = TDPPROCOD) as 'descricao',
       (select PROUM1 from TBS010 (nolock) where PROCOD = TDPPROCOD) as 'unidade-medida',
       TDPPRECOR1 as 'preco-corporativo',
       TDPPRELOJ1 as 'preco-loja',
       TDPCUSBAS as 'preco-custo',
       isnull((select top 1 
                      round(dbo.NFEPRELIQ(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,TBS0591.NFEITE) /
                            case NFEQTDEMB when 0 then 1 else NFEQTDEMB end *
                            case NFEPERIPI when 0 then 1 else NFEPERIPI/100 end,4)
                 from TBS0591 TBS0591 (nolock) join TBS059 TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and TBS0591.NFETIP = TBS059.NFETIP and
                                                                              TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and
                                                                              TBS0591.SEREMPCOD = TBS059.SEREMPCOD and TBS0591.SERCOD = TBS059.SERCOD
                where TBS059.NFETIP = 'N' and TBS059.NFECAN <> 'S' and TBS0591.PROCOD = TDPPROCOD and
                      TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
                      TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
                order by NFEDATEMI desc),0) as 'preco-compra',
       isnull((select top 1 NFEDATEMI
                 from TBS0591 TBS0591 (nolock) join TBS059 TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and TBS0591.NFETIP = TBS059.NFETIP and
                                                                              TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and
                                                                              TBS0591.SEREMPCOD = TBS059.SEREMPCOD and TBS0591.SERCOD = TBS059.SERCOD
                where TBS059.NFETIP = 'N' and TBS059.NFECAN <> 'S' and TBS0591.PROCOD = TDPPROCOD and
                      TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
                      TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
                order by NFEDATEMI desc),0) as 'data-recebimento'
  from TBS031 (nolock)

select TBS0591.NFENUM,NFEITE 
                 from TBS0591 TBS0591 (nolock) join TBS059 TBS059 (nolock) on TBS0591.NFEEMPCOD = TBS059.NFEEMPCOD and TBS0591.NFETIP = TBS059.NFETIP and
                                                                              TBS0591.NFENUM = TBS059.NFENUM and TBS0591.NFECOD = TBS059.NFECOD and
                                                                              TBS0591.SEREMPCOD = TBS059.SEREMPCOD and TBS0591.SERCOD = TBS059.SERCOD
                where TBS0591.PROCOD = '0472414' and
                      TBS059.NFENOM not Like('%BEST BAG%') and TBS059.NFENOM not Like('%BEST OFFICE%') and TBS059.NFENOM not Like('%MISASPEL%') and
                      TBS059.NFENOM not Like('%PAPELYNA%') and TBS059.NFENOM not Like('%TANBY%')
                order by NFEDATEMI desc

select anomes
       ,cfop
       ,sum(valor) custo
  from (
      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,NFECFOP cfop
             ,PROCOD codigo

             -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do mês

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do mês
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) qemb

--        into #TMP
        from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                              inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
             convert(char(6),TBS059.NFEDATEFE,112) = '201901'
             --and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             --and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
             --and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),NFECFOP,PROCOD
) tab
group by anomes,cfop
order by cfop

drop table #nfent

select cfop
       ,codigo
       ,custo custo_nf
       ,(select top 1 CUSTO
           from SALDOINICIAL s with (nolock)
          where DATA <= '20190201'
                and s.CODIGO=t.codigo
                and CUSTO > 0
          order by DATA desc) custo_medio
       ,qtde
       ,cte
       into #nfent

  from (
      select str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2) anomes
             ,NFECFOP cfop
             ,PROCOD codigo

             -- qtde compra na menor unidade * preço unitário (sem alguns impostos)
             ,sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)) -- valor total do mês
             /
             case sum(NFEQTD * NFEQTDEMB) when 0 then 1 else sum(NFEQTD * NFEQTDEMB) end as custo -- qtde total do mês

             ,isnull(sum(NFEQTD * NFEQTDEMB * dbo.NFECUSAQU(TBS0591.NFEEMPCOD,TBS0591.NFETIP,TBS0591.NFENUM,TBS0591.NFECOD,TBS0591.SEREMPCOD,TBS0591.SERCOD,NFEITE)),0) as valor
             ,isnull(sum(NFEQTD * NFEQTDEMB),0) as qtde -- qtde total do mês
             ,str(year(TBS059.NFEDATEFE),4)+right('00'+Ltrim(str(month(TBS059.NFEDATEFE),2)),2)+'01' data
             ,(select PROUM1 from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) uni
             ,(select PROUM1QTD from TBS010 with (nolock) where TBS010.PROCOD=TBS0591.PROCOD) qemb
             ,sum(NFEVALFREITECTE) cte

        from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                              inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --TBS059.NFEDATEFE between @dataDe and @dataAte
             convert(char(6),TBS059.NFEDATEFE,112) = '201901'
             --and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             --and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
             --and right(NFECFOP,3) in('102','403','121','202','411')
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),NFECFOP,PROCOD
) t

select *
       ,qtde*custo_nf qtde_custo_nf
       ,qtde*custo_medio qtde_custo_medio
  from #nfent

select cfop
       ,sum(qtde*custo_nf) custo
       ,sum(cte)
  from #nfent
 group by cfop

select * from SALDOINICIAL with (nolock) where CODIGO='18260041' order by DATA desc


----


select min(KESDAT),max(KESDAT) from TBS125 with (nolock)


select top 1 * from TBS125 with (nolock)

select sum(KESNFENT),sum(KESENTDEV),sum(KESCANNFSAI),sum(KESCANCUPFIS),sum(KESCANNFDEV)
       ,sum(KESNFSAI),sum(KESCUPFIS),sum(KESNFDEVSAI)
  from TBS125 with (nolock)
 where KESDAT between '20190101' and '20190131'
       and KESPROCOD='0050210'


select KESPROCOD codigo
       ,sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV) entrada
       ,sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI) saida
  from TBS125 with (nolock)
 where KESDAT between '20190101' and '20190131'
       and KESPROCOD='0050210'
 group by KESPROCOD

drop table #kardex

select *
       ,(saldo_inicial + entradas - saidas) saldo_final_calculo
--       ,(saldo_inicial_32 + entradas - saidas) saldo_final_32
  into #kardex
  from
  (
     select PROCOD codigo
            ,PRODES descricao
            ,isnull((select sum(ESTQTDATU)
                       from SALDODIARIO with (nolock)
                      where ESTLOC in(1,2,3,4,7,9)
                            and ESTDATSAL='20181231' and SALDODIARIO.PROCOD=TBS010.PROCOD),0) saldo_inicial
            --,isnull((select ( case when E1 > 0 then E1 else 0 end +
            --                  case when E2 > 0 then E2 else 0 end +
            --                  case when E3 > 0 then E3 else 0 end +
            --                  case when E4 > 0 then E4 else 0 end +
            --                  case when E7 > 0 then E7 else 0 end +
            --                  case when E9 > 0 then E9 else 0 end)
            --           from INV1812 with (nolock)
            --          where INV1812.CODIGO=TBS010.PROCOD),0) saldo_inicial_32
            ,isnull((select sum(KESNFENT + KESENTDEV + KESCANNFSAI + KESCANCUPFIS + KESCANNFDEV)
                       from TBS125 with (nolock)
                      where LESCOD in(1,2,3,4,7,9)
                            and KESDAT between '20190101' and '20190131'
                            and KESPROCOD=PROCOD
                      group by KESPROCOD),0) entradas
            ,isnull((select sum(KESNFSAI + KESCUPFIS + KESNFDEVSAI)
                       from TBS125 with (nolock)
                      where LESCOD in(1,2,3,4,7,9)
                            and KESDAT between '20190101' and '20190131'
                            and KESPROCOD=PROCOD
                      group by KESPROCOD),0) saidas
            ,isnull((select ( case when E1 > 0 then E1 else 0 end +
                              case when E2 > 0 then E2 else 0 end +
                              case when E3 > 0 then E3 else 0 end +
                              case when E4 > 0 then E4 else 0 end +
                              case when E7 > 0 then E7 else 0 end +
                              case when E9 > 0 then E9 else 0 end)
                       from INV1901 with (nolock)
                      where INV1901.CODIGO=TBS010.PROCOD),0) saldo_final_32
            ,case
                when isnull((select top 1 CUSTO
                               from SALDOINICIAL S with (nolock)
                              where DATA <= '20190201'
                                    and S.CODIGO=TBS010.PROCOD
                                    and CUSTO > 0
                              order by DATA desc),0) > 0
                   then isnull((select top 1 CUSTO
                                  from SALDOINICIAL S with (nolock)
                                 where DATA <= '20190201'
                                       and S.CODIGO=TBS010.PROCOD
                                       and CUSTO > 0
                                 order by DATA desc),0)
                else isnull(dbo.CUSTOPOLITICA(0,TBS010.PROCOD),0)
             end custo
       from TBS010 with (nolock)
--      where PROCOD='1640054'
   ) t

select top 1 * from INV1901 with (nolock)

select * from #kardex where codigo='1083774'

select * from #kardex where saldo_final > 0 order by saldo_final desc

select *
       ,saldo_final_calculo-saldo_final_32 divergencia_saldo
       ,custo * (saldo_final_calculo-saldo_final_32) custo_recalculo
  from #kardex
 where saldo_final_calculo <> saldo_final_32

select sum(custo_recalculo)
  from
  (
     select *
            ,saldo_final_calculo-saldo_final_32 divergencia_saldo
            ,custo * (saldo_final_calculo-saldo_final_32) custo_recalculo
       from #kardex
      where saldo_final_calculo <> saldo_final_32
  ) t

delete #kardex where saldo_inicial + entradas + saidas + saldo_final =0 

select top 100 * from TBS0591 with (nolock) where not NFEQTDCUP is null

select * from SALDODIARIO wiht (nolock) where ESTDATSAL='20181231' and PROCOD='1640054'

select *
       ,(
           case when E1 > 0 then E1 else 0 end +
           case when E2 > 0 then E2 else 0 end +
           case when E3 > 0 then E3 else 0 end +
           case when E4 > 0 then E4 else 0 end +
           case when E7 > 0 then E7 else 0 end +
           case when E9 > 0 then E9 else 0 end
        ) saldo
       ,case
           when CUSTO > 0
              then CUSTO
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=INV1901.CODIGO 
                               and CUSTO > 0
                         order by DATA desc),0) > 0
              then isnull((select top 1 CUSTO
                             from SALDOINICIAL S with (nolock)
                            where DATA <= '20190201'
                                  and S.CODIGO=INV1901.CODIGO 
                                  and CUSTO > 0
                            order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
        end custo
       ,(select saldo_final_32 from #kardex where #kardex.codigo=INV1901.CODIGO) kardex
  from INV1901 with (nolock)
 where
    (
       case when E1 > 0 then E1 else 0 end +
       case when E2 > 0 then E2 else 0 end +
       case when E3 > 0 then E3 else 0 end +
       case when E4 > 0 then E4 else 0 end +
       case when E7 > 0 then E7 else 0 end +
       case when E9 > 0 then E9 else 0 end
    ) <> (select saldo_final_32 from #kardex where #kardex.codigo=INV1901.CODIGO)


select sum(saldo * custo)
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
          ,
          case
             when CUSTO > 0
                then CUSTO
             when isnull((select top 1 CUSTO
                            from SALDOINICIAL S with (nolock)
                           where DATA <= '20190201'
                                 and S.CODIGO=INV1901.CODIGO 
                                 and CUSTO > 0
                           order by DATA desc),0) > 0
                then isnull((select top 1 CUSTO
                               from SALDOINICIAL S with (nolock)
                              where DATA <= '20190201'
                                    and S.CODIGO=INV1901.CODIGO 
                                    and CUSTO > 0
                              order by DATA desc),0)
             else isnull(dbo.CUSTOPOLITICA(0,CODIGO),0)
          end custo
  from INV1901 with (nolock)
 where
    (
       case when E1 > 0 then E1 else 0 end +
       case when E2 > 0 then E2 else 0 end +
       case when E3 > 0 then E3 else 0 end +
       case when E4 > 0 then E4 else 0 end +
       case when E7 > 0 then E7 else 0 end +
       case when E9 > 0 then E9 else 0 end
    ) <> (select saldo_final_32 from #kardex where #kardex.codigo=INV1901.CODIGO)
  ) t

select * from INV1901 with (nolock)

select *
       ,(select top 1 (
                  case when E1 > 0 then E1 else 0 end +
                  case when E2 > 0 then E2 else 0 end +
                  case when E3 > 0 then E3 else 0 end +
                  case when E4 > 0 then E4 else 0 end +
                  case when E7 > 0 then E7 else 0 end +
                  case when E9 > 0 then E9 else 0 end
                )
          from INV1901 with (nolock)
         where INV1901.CODIGO=#kardex.codigo) saldo_0119
  from #kardex
 where saldo_final <>
       (select top 1 (
                  case when E1 > 0 then E1 else 0 end +
                  case when E2 > 0 then E2 else 0 end +
                  case when E3 > 0 then E3 else 0 end +
                  case when E4 > 0 then E4 else 0 end +
                  case when E7 > 0 then E7 else 0 end +
                  case when E9 > 0 then E9 else 0 end
                )
          from INV1901 with (nolock)
         where INV1901.CODIGO=#kardex.codigo)

select CODIGO,count(*) from INV1901
 group by CODIGO
having count(*) > 1

-- custo política de preços

select '2019-01' referencia
       ,CODIGO produto
       ,(
           case when E1 > 0 then E1 else 0 end +
           case when E2 > 0 then E2 else 0 end +
           case when E3 > 0 then E3 else 0 end +
           case when E4 > 0 then E4 else 0 end +
           case when E7 > 0 then E7 else 0 end +
           case when E9 > 0 then E9 else 0 end
        ) saldo
       ,isnull(dbo.CUSTOPOLITICA(0,CODIGO),0) custo
  into #inventario
  from INV1901 a with (nolock)
 where (
          case when E1 > 0 then E1 else 0 end +
          case when E2 > 0 then E2 else 0 end +
          case when E3 > 0 then E3 else 0 end +
          case when E4 > 0 then E4 else 0 end +
          case when E7 > 0 then E7 else 0 end +
          case when E9 > 0 then E9 else 0 end
       ) > 0

select * from INV1901

select * from #inventario

select sum(saldo*custo) from #inventario


--

drop table #NFENT

      select TBS0591.PROCOD as CodigoProduto
             ,TBS0591.LESCOD as LocalEstoque
             ,sum(TBS0591.NFEQTD * TBS0591.NFEQTDEMB) as QTDE
        into #NFENT
        from TBS0591 (nolock)
             inner join TBS059 (nolock) on TBS059.NFETIP=TBS0591.NFETIP and TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
       where TBS059.NFEUSUEFE<>'' and
             TBS059.NFECAN<>'S' and
             TBS059.NFETIP<>'D' and
             TBS059.NFEDATEFE between '20190101' and '20190131' and
             TBS0591.NFEMOVEST='S'
       group by TBS0591.LESCOD,TBS0591.PROCOD

drop table #NFSAI

      select TBS0671.PROCOD as CodigoProduto
             ,TBS0671.LESCOD as LocalEstoque
             ,sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) as QTDE
        into #NFSAI
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSCAN<>'S' and
             TBS067.NFSDATEMI between '20190101' and '20190131' and
             TBS0671.NFSMOVEST='S'
       group by TBS0671.LESCOD,TBS0671.PROCOD

drop table #NFDEV

      select TBS117.NFDDATEMI as data,
             TBS1172.PROCOD as CodigoProduto,
             TBS1172.LESCOD as LocalEstoque,
             sum(TBS1172.NFDQTD * TBS1172.NFDQTDEMB) as QTDE
        into #NFDEV
        from TBS1172 (nolock) inner join TBS117 (nolock) on TBS117.SNESER=TBS1172.SNESER and TBS117.NFDNUM=TBS1172.NFDNUM
       where TBS117.NFDDATEMI between '20190101' and '20190131' and
             TBS117.NFDSTATUS='A' and
             TBS1172.NFDMOVEST='S'
       group by TBS117.NFDDATEMI,TBS1172.LESCOD,TBS1172.PROCOD

select * from #NFENT 

select * from #NFSAI

select (select case 
                  when #NFENT.LocalEstoque=1 then E1
                  when #NFENT.LocalEstoque=2 then E2
                  when #NFENT.LocalEstoque=3 then E3
                  when #NFENT.LocalEstoque=4 then E4
                  when #NFENT.LocalEstoque=7 then E7
                  when #NFENT.LocalEstoque=9 then E9
               end
          from INV1812 with (nolock)
         where INV1812.CODIGO=#NFENT.CodigoProduto
       ) saldo_inicial
       ,*
       ,(select case 
                   when #NFENT.LocalEstoque=1 then E1
                   when #NFENT.LocalEstoque=2 then E2
                   when #NFENT.LocalEstoque=3 then E3
                   when #NFENT.LocalEstoque=4 then E4
                   when #NFENT.LocalEstoque=7 then E7
                   when #NFENT.LocalEstoque=9 then E9
                end
           from INV1901 with (nolock)
          where INV1901.CODIGO=#NFENT.CodigoProduto
        ) saldo_final
  from #NFENT 
       full outer join #NFSAI
       on #NFSAI.CodigoProduto=#NFENT.CodigoProduto and #NFSAI.LocalEstoque=#NFENT.LocalEstoque
 where #NFENT.LocalEstoque in(1,2,3,4,7,9)

select (select case 
                  when #NFENT.LocalEstoque=1 then E1
                  when #NFENT.LocalEstoque=2 then E2
                  when #NFENT.LocalEstoque=3 then E3
                  when #NFENT.LocalEstoque=4 then E4
                  when #NFENT.LocalEstoque=7 then E7
                  when #NFENT.LocalEstoque=9 then E9
               end
          from INV1812 with (nolock)
         where INV1812.CODIGO=#NFENT.CodigoProduto
       ) saldo_inicial
       ,*
       ,(select case 
                   when #NFENT.LocalEstoque=1 then E1
                   when #NFENT.LocalEstoque=2 then E2
                   when #NFENT.LocalEstoque=3 then E3
                   when #NFENT.LocalEstoque=4 then E4
                   when #NFENT.LocalEstoque=7 then E7
                   when #NFENT.LocalEstoque=9 then E9
                end
           from INV1901 with (nolock)
          where INV1901.CODIGO=#NFENT.CodigoProduto
        ) saldo_final

select *
  from
  (       
     select PROCOD produto
            ,isnull((select ( case when E1 > 0 then E1 else 0 end +
                              case when E2 > 0 then E2 else 0 end +
                              case when E3 > 0 then E3 else 0 end +
                              case when E4 > 0 then E4 else 0 end +
                              case when E7 > 0 then E7 else 0 end +
                              case when E9 > 0 then E9 else 0 end)
                       from INV1812 with (nolock)
                      where INV1812.CODIGO=TBS010.PROCOD),0) saldo_inicial
            ,isnull((select sum(#NFENT.QTDE)
                       from #NFENT
                      where #NFENT.LocalEstoque in(1,2,3,4,7,9)
                            and #NFENT.CodigoProduto=TBS010.PROCOD),0) entradas
            ,isnull((select sum(#NFDEV.QTDE)
                       from #NFDEV
                      where #NFDEV.LocalEstoque in(1,2,3,4,7,9)
                            and #NFDEV.CodigoProduto=TBS010.PROCOD),0) devolucoes
            ,isnull((select sum(#NFSAI.QTDE)
                       from #NFSAI
                      where #NFSAI.LocalEstoque in(1,2,3,4,7,9)
                            and #NFSAI.CodigoProduto=TBS010.PROCOD),0) saidas
            ,isnull((select ( case when E1 > 0 then E1 else 0 end +
                              case when E2 > 0 then E2 else 0 end +
                              case when E3 > 0 then E3 else 0 end +
                              case when E4 > 0 then E4 else 0 end +
                              case when E7 > 0 then E7 else 0 end +
                              case when E9 > 0 then E9 else 0 end)
                       from INV1901 with (nolock)
                      where INV1901.CODIGO=TBS010.PROCOD),0) saldo_final
            ,case
                when isnull((select top 1 CUSTO
                               from SALDOINICIAL S with (nolock)
                              where DATA <= '20190201'
                                    and S.CODIGO=TBS010.PROCOD
                                    and CUSTO > 0
                              order by DATA desc),0) > 0
                   then isnull((select top 1 CUSTO
                                  from SALDOINICIAL S with (nolock)
                                 where DATA <= '20190201'
                                       and S.CODIGO=TBS010.PROCOD
                                       and CUSTO > 0
                                 order by DATA desc),0)
                else isnull(dbo.CUSTOPOLITICA(0,TBS010.PROCOD),0)
             end custo
       from TBS010 with (nolock)
  ) t
 where t.entradas + t.saidas > 0


-- transferências

      select TBS0671.PROCOD codigo
             ,sum(TBS0671.NFSQTD * TBS0671.NFSQTDEMB) qtde
        into #transf
        from TBS0671 (nolock)
             inner join TBS067 (nolock) on TBS067.SNESER=TBS0671.SNESER and TBS067.NFSNUM=TBS0671.NFSNUM
       where TBS067.NFSTIP='N' and
             TBS067.NFSCAN<>'S' and
             TBS067.NFSDATEMI between '20190101' and '20190131' and
             TBS0671.NFSMOVEST='S'
       group by TBS0671.LESCOD,TBS0671.PROCOD

select * from #transf

     select sum(NFETOTOPEITE) valor
            ,sum(NFETOTOPEITE*18/100) valor_icms
        from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                              inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where convert(date,TBS059.NFEDATEFE) between '20190101' and '20190131'
             and TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
             and right(NFECFOP,3) in('102','403','121','202','411')
             and PROCOD in(select codigo from #transf)
       group by year(TBS059.NFEDATEFE),month(TBS059.NFEDATEFE),NFECFOP,PROCOD


select *
       ,qtde*preco
       ,case
           when (select PROSTBB from TBS010 with (nolock) where TBS010.PROCOD=codigo) <> '60'
           then qtde*preco*18/100
           else 0
        end
  from
  (
select *
       ,(select top 1 NFEPRE
        from TBS0591 (nolock) inner join TBS059 (nolock) on TBS059.SERCOD=TBS0591.SERCOD and TBS059.NFETIP=TBS0591.NFETIP and TBS059.NFECOD=TBS0591.NFECOD and TBS059.NFENUM=TBS0591.NFENUM
                              inner join TBS006 (nolock) on TBS006.FOREMPCOD=TBS059.NFEEMPFC and TBS006.FORCOD=TBS059.NFECOD

       where --convert(date,TBS059.NFEDATEFE) between '20150101' and '20190131'
--             and 
TBS0591.NFETIP='N'
             and TBS059.NFECAN<>'S'
             and FORCGC not in('05118717000156','05118717000237','09135487000194','44125185000136','52080207000117','65069593000198','65069593000279','65069593000350')
             and right(NFECFOP,3) in('102','403','121','202','411')
             and PROCOD=codigo
       --group by TBS059.NFEDATEFE,PROCOD
       order by TBS059.NFEDATEFE desc) preco
from #transf
  ) t

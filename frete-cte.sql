select * from TBS130 with (nolock)

select * from TBS1301 with (nolock) where CTEENTCHADOC='31181201856241000361550040001085411000438789'

select *
  from TBS130 with (nolock)

select sum(dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
       ,sum(dbo.CTEENTVALICM(TBS130.CTEENTEMP, TBS130.CTEENTCHA))
  from TBS130 with (nolock)
       inner join
       TBS1301 with (nolock)
       on TBS1301.CTEENTCHA=TBS130.CTEENTCHA
--       inner join
--       TBS059 with (nolock)
--       on TBS059.NFECHAACE=TBS1301.CTEENTCHADOC
 where CTEENTDEFDOC between '20190101' and '20190105'
--       and TBS059.NFECAN<>'S'

select CTEENTCHADOC, count(*)
  from TBS1301 with (nolock)
 where CTEENTDEFDOC between '20190101' and '20190131'
 group by CTEENTCHADOC
having count(*) > 1

select CTEENTBASICM
       ,CTEENTFREPES + CTEENTFREVAL + CTEENTGRIS + CTEENTPED + CTEENTTRT + CTEENTTDE + CTEENTSECCAT + CTEENTDES + CTEENTSEG + CTEENTTAX + CTEENTOUT
       ,dbo.CTEENTTOTFRE(TBS130.CTEENTEMP, TBS130.CTEENTCHA)
  from TBS130 with (nolock)
       inner join
       TBS1301 with (nolock)
       on TBS1301.CTEENTCHA=TBS130.CTEENTCHA
 where CTEENTDEFDOC between '20190101' and '20190105'

select NFEVALFREITECTE
       ,*
  from TBS0591 with (nolock)
 where NFENUM=6644
       and NFECOD=2318
 order by NFEITE


select *
  from SALDODIARIO with (nolock)
 where ESTDATSAL='20190105'
       and ESTQTDATU > 0

select *
       ,case
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
        end custo_nf
       ,dbo.CUSTOPOLITICA(0,PROCOD) custo_politica
  into #estoque
  from
  (
     select PROCOD
            ,sum(ESTQTDATU) qtde
       from SALDODIARIO with (nolock)
      where ESTDATSAL='20190105'
            and ESTQTDATU > 0
      group by PROCOD
  ) t
order by qtde desc

select *
  from #estoque


select CODIGO
  into #produtos
  from SALDOINICIAL with (nolock)
 where DATA='20190101'
union
select CODIGO
  from SALDOINICIAL with (nolock)
 where DATA='20190201'

select * from #produtos

select *
       ,case
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190101'
                               and S.CODIGO=#produtos.CODIGO
                               and CUSTO > 0
                         order by DATA desc),0) > 0
           then isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190101'
                               and S.CODIGO=#produtos.CODIGO
                               and CUSTO > 0
                         order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,#produtos.CODIGO),0)
        end custo_dez
       ,case
           when isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=#produtos.CODIGO
                               and CUSTO > 0
                         order by DATA desc),0) > 0
           then isnull((select top 1 CUSTO
                          from SALDOINICIAL S with (nolock)
                         where DATA <= '20190201'
                               and S.CODIGO=#produtos.CODIGO
                               and CUSTO > 0
                         order by DATA desc),0)
           else isnull(dbo.CUSTOPOLITICA(0,#produtos.CODIGO),0)
        end custo_jan
  from #produtos

select *
  from SALDOINICIAL with (nolock)
 where CODIGO='9999999'
 order by DATA desc

select *
  from SALDODIARIO with (nolock)
 where PROCOD='9999999'
       and ESTQTDATU > 0
 order by ESTDATSAL desc

select *
  from INV1901 with (nolock)
 where CODIGO='9999999'

select *
  from INV1812 with (nolock)
 where CODIGO='9999999'

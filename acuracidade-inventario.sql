select max(ESTDATSAL) from SALDODIARIO with (nolock) where ESTDATSAL >= '20181130' and 

select * from INV05 with (nolock) where saldoAnterior > 0 and saldoEfetivo=0

select * from INV05 with (nolock)
 where lancar <> saldoAnterior

select * from TBS032 with (nolock)
 where ESTLOC=2 
       and PROCOD='3257959'
       and convert(date,ESTDATALT)='20181116'

SELECT ANO
, [1] AS JANEIRO
         , [2] AS FEVEREIRO
         , [3] AS MARÇO
, [4] AS ABRIL
         , [5] AS MAIO
         , [6] AS JUNHO
         , [7] AS JULHO
         , [8] AS AGOSTO
         , [9] AS SETEMBRO
         , [10] AS OUTUBRO
, [11] AS NOVEMBRO
         , [12] AS DEZEMBRO
FROM VENDAANUAIS PIVOT (SUM(VALOR) 
FOR MES IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]))P
ORDER BY 1;

select * from TBS049 with (nolock) where LESCOD=1 and MDSUSU='INTEGROS' and PROCOD='0040320'

select PROCOD as codigo
       ,(select PRODES from TBS010 t10 with (nolock) where t10.PROCOD=a.PROCOD)
       ,(select MARNOM from TBS010 t10 with (nolock) where t10.PROCOD=a.PROCOD)
       ,(select PROUM1 from TBS010 t10 with (nolock) where t10.PROCOD=a.PROCOD)
       ,isnull((select sum(MDSQTD) from TBS049 b with (nolock) where MDSTIP='S' and LESCOD=2 and MDSUSU='INTEGROS' and  b.PROCOD=a.PROCOD),0) as saida
       ,isnull((select sum(MDSQTD) from TBS049 b with (nolock) where MDSTIP='E' and LESCOD=2 and MDSUSU='INTEGROS' and  b.PROCOD=a.PROCOD),0) as entrada
  from TBS049 a with (nolock)
 where LESCOD=2
       and MDSUSU='INTEGROS'
group by PROCOD

--select codigoProduto into #tab from INV05 with (nolock) where localEstoque=2 and lancar > 0
select codigoProduto into #tab from INV05_FINAL_LOJA with (nolock) where localEstoque=2 and lancar > 0
union
select codigoProduto from INV04 with (nolock) where localEstoque=2

select * from #tab

drop table #tab

select distinct localEstoque from INV04 with (nolock)

select distinct localEstoque from INV05 with (nolock)

select distinct localEstoque from INV05_FINAL_LOJA with (nolock)

select codigoProduto
       ,(select PRODES from TBS010 with (nolock) where PROCOD=codigoProduto)
       ,(select MARNOM from TBS010 with (nolock) where PROCOD=codigoProduto)
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codigoProduto)
       ,isnull((select quantidade from INV04 with (nolock) where localEstoque=2 and INV04.codigoProduto=#tab.codigoProduto),0) as antes
       --,isnull((select lancar from INV05 with (nolock) where localEstoque=2 and INV05.codigoProduto=#tab.codigoProduto and lancar > 0),0) as depois
       ,isnull((select lancar from INV05_FINAL_LOJA with (nolock) where localEstoque=2 and INV05_FINAL_LOJA.codigoProduto=#tab.codigoProduto and lancar > 0),0) as depois
  from #tab

select * from INV04 with (nolock)

select * from INV05 with (nolock)
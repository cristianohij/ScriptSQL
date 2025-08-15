declare @datde char(10),@datate char(10),@pedde int,@pedate int,@prode char(8),@proate char(8)
set @datde=''
set @datate='2010-09-23'
set @pedde=6297
set @pedate=9160
set @prode='009'
set @proate='009Z'

select TBS0451.PROCOD as 'produto',
       TBS0451.PDCDES as 'descricao',
       TBS0451.PDCUNI as 'UM',
       TBS0451.PDCQTD as 'quantidade',
       TBS0451.PDCQTDENT as 'qtde_entregue',
       TBS0451.PDCQTDRES as 'qtde_residual',
       TBS0451.PDCPRE-TBS0451.PDCPRE*TBS0451.PDCPDDITE/100 as 'preco',
       TBS0451.PDCQTD*(TBS0451.PDCPRE-TBS0451.PDCPRE*TBS0451.PDCPDDITE/100) as 'total',
       TBS0451.PDCDATPRE as 'prev_entrega',
       TBS0451.PDCDATFAT as 'prev_faturamento'
  from TBS0451 (nolock) join TBS045 (nolock) on TBS0451.PDCNUM=TBS045.PDCNUM
 where TBS045.PDCDATCAD between @datde and @datate and
       TBS045.PDCNUM between @pedde and @pedate and
       TBS0451.PROCOD between @prode and @proate
       
       
       
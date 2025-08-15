declare @datai char(8) ,@dataf char(8) ,@clientei int ,@clientef int ,@vendedori int ,@vendedorf int

set @datai = '20121201'
set @dataf = '20130228'

set @clientei = 0
set @clientef = 99999

set @vendedori = 0
set @vendedorf = 9999

select TBS055.PDVCLICOD as 'codigo-cliente',
       isnull((select CLINOM from TBS002 (nolock) where TBS002.CLICOD = TBS055.PDVCLICOD),'') as 'nome-cliente',
       TBS055.VENCOD as 'codigo-vendedor',
       isnull((select VENNOM from TBS004 (nolock) where TBS004.VENCOD = TBS055.VENCOD),'') as 'nome-vendedor',
       str(sum(dbo.PDVTOTLIQ(TBS055.PDVEMPCOD,TBS055.PDVNUM)),12,2) as 'total-pedido',
       str(sum(dbo.PDVTOTFAT(TBS055.PDVEMPCOD,TBS055.PDVNUM)),12,2) as 'total-faturado',
       count(*) as 'qtde-pedidos'
  from TBS055 (nolock) join TBS0551 (nolock) on TBS055.PDVEMPCOD = TBS0551.PDVEMPCOD and TBS055.PDVNUM = TBS0551.PDVNUM
 where TBS055.PDVDATCAD between @datai and @dataf and
       TBS055.PDVCLICOD between @clientei and @clientef and
       TBS055.VENCOD between @vendedori and @vendedorf
 group by TBS055.PDVCLICOD,TBS055.VENCOD
 order by TBS055.PDVCLICOD ,TBS055.VENCOD


-- clientes sem pedidos no período
declare @datai char(8) ,@dataf char(8)

set @datai = '20140101'
set @dataf = '20140731'

select TBS002.CLICOD as 'codigo do cliente',
       TBS002.CLINOM as 'nome do cliente',
       TBS002.VENCOD as 'codigo do vendedor',
       isnull((select TBS004.VENNOM from TBS004 (nolock) where TBS004.VENCOD=TBS002.VENCOD),0) as 'nome do vendedor'
  from TBS002 (nolock) left join TBS055 (nolock) on TBS002.CLICOD=TBS055.PDVCLICOD
 where TBS055.PDVDATCAD between @datai and @dataf
 order by 'nome do vendedor','nome do cliente'
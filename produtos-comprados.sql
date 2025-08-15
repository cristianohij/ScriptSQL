if object_id('TempDB.dbo.#pedidos') is not null
    begin 
       drop table #pedidos
    end

select convert(char(6), c.PDCDATCAD, 112) as 'periodo'
       ,c.PDCNUM as 'nr_pedido'
       ,c.FORCOD as 'codi_fornecedor'
       ,c.COMCOD as 'codi_comprador'
       ,d.PROCOD as 'codi_produto'
       ,sum(d.PDCQTD * d.PDCQTDEMB) as 'qtde_pedido'
       ,sum(d.PDCQTDENT * d.PDCQTDEMB) as 'qtde_entregue'
       ,sum(d.PDCQTDRES * d.PDCQTDEMB) as 'qtde_residuo'
       -- preço médio do item por pedido
       --,sum(dbo.PDCPRELIQ(0, d.PDCNUM, d.PDCITE) / d.PDCQTDEMB) as 'preco_item'
       --,avg(dbo.PDCPRELIQ(0, d.PDCNUM, d.PDCITE) / d.PDCQTDEMB) as 'preco_item'
       ,round(sum(dbo.PDCTOTITE(0, d.PDCNUM, d.PDCITE)) / sum(d.PDCQTD * d.PDCQTDEMB),4) as 'preco_item'
  into #pedidos
  from TBS0451 d with (nolock)
 inner join TBS045 c with (nolock)
    on d.PDCEMPCOD=c.PDCEMPCOD
       and d.PDCNUM=c.PDCNUM
 where c.PDCDATCAD between '20230101' and '20231231'
       and d.PROCOD <> '99'
 group by convert(char(6), c.PDCDATCAD, 112)
          ,c.PDCNUM
          ,c.FORCOD
          ,c.COMCOD
          ,d.PROCOD

select *
  from #pedidos



declare @pedidos int, @pro_distintos int

-- quantidade de pedidos

select @pedidos=count(tab.qtde)
  from (
         select count(nr_pedido) as 'qtde'
           from #pedidos
          group by nr_pedido
       ) as tab

--select @pedidos

-- quantidade de produtos distintos

select @pro_distintos=count(tab.qtde)
  from (
         select count(*) as 'qtde'
           from #pedidos
          group by codi_produto
       ) as tab

--select @pro_distintos

if object_id('TempDB.dbo.#pedidos2') is not null
    begin 
       drop table #pedidos2
    end

select subString(periodo,1,4) as 'ano'
       ,subString(periodo,5,2) as 'mes'
       ,codi_fornecedor
       ,(select FORNOM from TBS006 f with (nolock) where f.FORCOD=a.codi_fornecedor) as 'nome_fornecedor'
       ,codi_comprador
       ,(select COMNOM from TBS046 c with (nolock) where c.COMCOD=a.codi_comprador) as 'nome_comprador'
       ,nr_pedido
       --,@pedidos as 'ocor_pedidos'
       ,codi_produto
       ,qtde_pedido
       ,qtde_entregue
       ,qtde_residuo
       ,preco_item
       ,qtde_pedido * preco_item as 'val_item_pedido'
       ,qtde_entregue * preco_item as 'val_item_entregue'
       ,qtde_residuo * preco_item as 'val_item_residuo'
       ,(select PRODES from TBS010 with (nolock) where PROCOD=codi_produto) as 'descricao'
       ,(select MARCOD from TBS010 with (nolock) where PROCOD=codi_produto) as 'codi_marca'
       ,(select MARNOM from TBS010 with (nolock) where PROCOD=codi_produto) as 'nome_marca'
       ,(select PROUM1 from TBS010 with (nolock) where PROCOD=codi_produto) as 'unidade'
       --,@pro_distintos as 'nr_produtos'

       -- contadores
       
       -- geral
       -- número pedidos no ano
       ,(select count(distinct nr_pedido) from #pedidos) as 'nr_geral_pedi'
       -- número pedidos entregues no ano
       ,(select count(distinct nr_pedido) from #pedidos where qtde_entregue > 0) as 'nr_geral_entg'
       -- número pedidos eliminados no ano
       ,(select count(distinct nr_pedido) from #pedidos where qtde_residuo > 0) as 'nr_geral_resi'

       -- número produtos pedidos no ano
       ,(select count(distinct codi_produto) from #pedidos) as 'nr_produtos_pedi'
       -- número produtos entregues no ano
       ,(select count(distinct codi_produto) from #pedidos where qtde_entregue > 0) as 'nr_produtos_entg'
       -- número produtos eliminados no ano
       ,(select count(distinct codi_produto) from #pedidos where qtde_residuo > 0) as 'nr_produtos_resi'

       -- número de pedidos no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo) as 'nr_pedidos_mes'
       -- número de pedidos entregues no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.qtde_entregue > 0) as 'nr_pedidos_entg_mes'
       -- número de pedidos eliminados no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.qtde_residuo > 0) as 'nr_pedidos_resi_mes'

       -- número de produtos pedidos o mês
       ,(select count(*) from #pedidos b where b.periodo=a.periodo) as 'nr_produtos_pedi_mes'
       -- número de produtos entregues no mês
       ,(select count(*) from #pedidos b where b.periodo=a.periodo and b.qtde_entregue > 0) as 'nr_produtos_entg_mes'
       -- número de produtos eliminados no mês
       ,(select count(*) from #pedidos b where b.periodo=a.periodo and b.qtde_residuo > 0) as 'nr_produtos_resi_mes'

       -- por forncedor
       -- número de produtos pedidos por fornecedor no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor) as 'nr_pro_pedi_fornec_mes'
       -- número de produtos entregues por fornecedor no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.qtde_entregue > 0) as 'nr_pro_entg_fornec_mes'
       -- número de produtos eliminados por fornecedor no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.qtde_residuo > 0) as 'nr_pro_resi_fornec_mes'

       -- número de pedidos por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo) as 'nr_pedi_fornec_mes'
       -- número de pedidos entregues por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.qtde_entregue > 0) as 'nr_pedi_entg_fornec_mes'
       -- número de pedidos eliminados por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.qtde_residuo > 0) as 'nr_pedi_resi_fornec_mes'

       -- número de pedidos do produto por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_fornec_mes'
       -- quantidade de pedidos entregues do produto por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_fornec_mes'
       -- quantidade de pedidos eliminados do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_fornec_mes'

       
       -- por comprador
       -- número de pedidos por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'nr_pedi_comprador_mes'
       -- número de pedidos entregues por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_entregue > 0) as 'nr_pedi_entg_comprador_mes'
       -- número de pedidos eliminados por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_residuo > 0) as 'nr_pedi_resi_comprador_mes'

       -- número de produtos pedidos por comprador no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador) as 'nr_pro_pedi_comprador_mes'
       -- número de produtos entregues por comprador no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador and b.qtde_entregue > 0) as 'nr_pro_entg_comprador_mes'
       -- número de produtos eliminados por comprador no mês
       ,(select count(distinct b.codi_produto) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador and b.qtde_residuo > 0) as 'nr_pro_resi_comprador_mes'

       -- número de pedidos do produto por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_comprador_mes'
       -- quantidade de pedidos entregues do produto por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_comprador_mes'
       -- quantidade de pedidos eliminados do produto por comprador no ano
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_comprador_mes'



       -- somadores

       -- valor total de pedidos no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.periodo=a.periodo) as 'val_pedi_mes'
       -- valor total de pedidos entregues no mês
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.periodo=a.periodo) as 'val_entg_mes'
       -- valor total de pedidos eliminados no mês
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.periodo=a.periodo) as 'val_resi_mes'

       -- valor total dos pedidos por fornecedor no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo) as 'val_pedi_fornecedor_mes'
       -- valor total dos pedidos entregues por fornecedor no mês
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.qtde_entregue > 0) as 'val_pedi_entg_fornecedor_mes'
       -- valor total dos pedidos eliminados por fornecedor no mês
       ,isnull((select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.qtde_residuo > 0),0) as 'val_pedi_resi_fornecedor_mes'

       -- quantidade do produto por fornecedor no ano
       ,(select sum(b.qtde_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_fornec_ano'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_fornec_ano'
       ,isnull((select sum(b.qtde_residuo) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_fornec_ano'

       -- valor total dos pedidos por comprador no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'val_pedi_comprador_mes'
       -- valor total dos pedidos entregues por comprador no mês
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_entregue > 0) as 'val_pedi_entg_comprador_mes'
       -- valor total dos pedidos eliminados por comprador no mês
       ,isnull((select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_residuo > 0),0) as 'val_pedi_resi_comprador_mes'

       -- quantidade do produto por fornecedor no mês
       ,(select sum(b.qtde_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_fornec_mes'
       -- quantidade do produto entregue por fornecedor no mês
       ,(select sum(b.qtde_entregue) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_fornec_mes'
       -- quantidade do produto eliminado por fornecedor no mês
       ,isnull((select sum(b.qtde_residuo) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_fornec_mes'

       -- quantidade do produto por comprador no ano
       ,(select sum(b.qtde_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_comprador_ano'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_comprador_ano'
       ,isnull((select sum(b.qtde_residuo) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_comprador_ano'

       -- valor total dos pedidos por comprador no mês
       --,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'val_pedi_comprador_mes'
       ---- valor total dos pedidos entregues por comprador no mês
       --,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_entregue > 0) as 'val_pedi_entg_comprador_mes'
       ---- valor total dos pedidos eliminados por comprador no mês
       --,isnull((select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.qtde_residuo > 0),0) as 'val_pedi_resi_comprador_mes'

       -- quantidade do produto por fornecedor no mês
       --,(select sum(b.qtde_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_fornec_mes'
       ---- quantidade do produto entregue por fornecedor no mês
       --,(select sum(b.qtde_entregue) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_fornec_mes'
       ---- quantidade do produto eliminado por fornecedor no mês
       --,isnull((select sum(b.qtde_residuo) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_fornec_mes'








       ,(select count(*) from #pedidos b where b.codi_produto=a.codi_produto) as 'ocor_produto'
       ,(select count(*) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'ocor_pro_pedi_mes'
       ,(select count(*) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'ocor_pro_entg_mes'
       ,(select count(*) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto and b.qtde_pedido > 0) as 'ocor_pro_resi_mes'

       -- ocorrências geral de produtos



       -- ocorrência do produto fornecedor/comprador
       ,(select count(*) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'ocor_pro_fornecedor'
       ,(select count(*) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'ocor_pro_comprador'
       
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador) as 'nr_pedidos_comprador'
       
       -- número de pedidos por comprador no mês
       ,(select count(distinct b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'nr_pedidos_comprad_mes'
       -- ocorrência do produto por fornecedor no mês
       ,(select count(b.nr_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'ocor_pro_fornec_mes'
       -- ocorrência do produto por comprador no mês
       ,(select count(b.nr_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'ocor_pro_comprad_mes'

       ,(select sum(b.qtde_pedido) from #pedidos b where b.codi_produto=a.codi_produto) as 'qtde_total_pedi_produto'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.codi_produto=a.codi_produto) as 'qtde_total_entg_produto'
       ,(select sum(b.qtde_residuo) from #pedidos b where b.codi_produto=a.codi_produto) as 'qtde_total_resi_produto'
       
       -- quantidade do produto por fornecedor no período
       --,(select sum(b.qtde_pedido) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_fornec_mes'
       --,(select sum(b.qtde_entregue) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_entg_fornec_mes'
       --,(select sum(b.qtde_residuo) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_resi_fornec_mes'
       -- quantidade do produto por comprador
       ,(select sum(b.qtde_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_comprador'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'qt_pro_entg_comprador'
       ,(select sum(b.qtde_residuo) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'qt_pro_resi_comprador'
       -- quantidade do produto por comprador no período
       ,(select sum(b.qtde_pedido) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_comprador_mes'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_entg_comprador_mes'
       ,(select sum(b.qtde_residuo) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qt_pro_resi_comprador_mes'

       ,(select sum(b.qtde_pedido) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qtde_pedi_periodo_produto'
       ,(select sum(b.qtde_entregue) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qtde_entg_periodo_produto'
       ,(select sum(b.qtde_residuo) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'qtde_resi_periodo_produto'

       -- preço médio por produto
       --,(select avg(b.preco_item) from #pedidos b where b.codi_produto=a.codi_produto) as 'pre_medio_produto'
       -- preço médio por produto no mês
       --,(select avg(b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'pre_medio_pro_mes'
       -- preço médio por fornecedor
       --,(select avg(b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'pre_medio_fornec'
       -- preço médio por fornecedor no mês
       --,(select avg(b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'pre_medio_fornec_mes'
       -- preço médio por comprador
       --,(select avg(b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'pre_medio_comprador'
       -- preço médio por comprador no mês
       --,(select avg(b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'pre_medio_comprador_mes'


       
       -- valor total dos pedidos por produto
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_produto=a.codi_produto) as 'total_pedi_produto'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_produto=a.codi_produto) as 'total_entg_produto'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_produto=a.codi_produto) as 'total_resi_produto'

       -- valor total dos pedidos por produto por mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'total_pedi_produto_mes'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'total_entg_produto_mes'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'total_resi_produto_mes'

       -- valor total dos produto por fornecedor
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_pedi_pro_fornec_ano'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_entg_pro_fornec_ano'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_resi_pro_fornec_ano'

       -- valor total dos produto por fornecedor no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_pedi_pro_fornecedor_mes'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_entg_pro_fornecedor_mes'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_fornecedor=a.codi_fornecedor and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_resi_pro_fornecedor_mes'

       -- valor total dos pedidos por comprador
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador) as 'total_pedi_comprador'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador) as 'total_entg_comprador'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador) as 'total_resi_comprador'

       -- valor total dos pedidos por comprador por mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'total_pedi_comprador_mes'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'total_entg_comprador_mes'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo) as 'total_resi_comprador_mes'

       -- valor total dos produto por comprador
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'val_pedi_pro_comprador_ano'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'val_entg_pro_comprador_ano'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'val_resi_pro_comprador_ano'

       -- valor total dos produto por comprador por mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_pedi_pro_comprador_mes'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_entg_pro_comprador_mes'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.codi_comprador=a.codi_comprador and b.periodo=a.periodo and b.codi_produto=a.codi_produto) as 'val_resi_pro_comprador_mes'

       -- valor total dos produto por fornecedor no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_pedi_pro_fornec_mes'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_entg_pro_fornec_mes'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos b where b.periodo=a.periodo and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'val_resi_pro_fornec_mes'


  into #pedidos2
  from #pedidos a
 
if object_id('SIBD.dbo.PEDI_COMPRAS') is not null
    begin
       drop table PEDI_COMPRAS
    end

select *
       
       -- ocorrências dos produtos por marca no mês
       ,(select count(*) from #pedidos2 b where b.codi_marca=a.codi_marca and b.ano=a.ano and b.mes=a.mes) as 'ocor_pro_marca_mes'
       ,(select sum(b.qtde_pedido) from #pedidos2 b where b.codi_marca=a.codi_marca) as 'qt_pedi_pro_marca'
       ,(select sum(b.qtde_entregue) from #pedidos2 b where b.codi_marca=a.codi_marca) as 'qt_entg_pro_marca'
       ,(select sum(b.qtde_residuo) from #pedidos2 b where b.codi_marca=a.codi_marca) as 'qt_resi_pro_marca'
       -- preço médio por produto
       ,total_pedi_produto / qtde_total_pedi_produto as 'pre_medio_produto'
       -- preço médio por produto no mês
       ,(select sum(total_pedi_produto_mes / qtde_pedi_periodo_produto) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_produto=a.codi_produto) as 'pre_medio_pro_mes'
       -- preço médio por fornecedor no ano
       ,val_pedi_pro_fornec_ano / qt_pro_pedi_fornec_ano 'pre_medio_fornec_ano'
       -- preço médio por fornecedor no mês
       ,(select sum(val_pedi_pro_fornecedor_mes / qt_pro_pedi_fornec_mes) from #pedidos2 b where b.codi_fornecedor=a.codi_fornecedor and b.ano=a.ano and b.mes=a.mes and b.codi_produto=a.codi_produto) as 'pre_medio_fornec_mes'
       -- preço médio por comprador no ano
       ,val_pedi_pro_comprador_ano / qt_pro_pedi_comprador as 'pre_medio_comprador_ano'
       -- preço médio por comprador no mês
       ,(select sum(val_pedi_pro_comprador_mes / qt_pro_pedi_comprador_mes) from #pedidos2 b where b.codi_comprador=a.codi_comprador and b.ano=a.ano and b.mes=a.mes and b.codi_produto=a.codi_produto) as 'pre_medio_comprador_mes'


       -- contadores

       -- por fornecedor
       -- número de pedidos por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor) as 'nr_pedi_fornec_ano'
       -- número de pedidos entregues por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_entregue > 0) as 'nr_pedi_entg_fornec_ano'
       -- número de pedidos eliminados por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_residuo > 0) as 'nr_pedi_resi_fornec_ano'

       -- número de produtos pedidos por fornecedor no ano
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor) as 'nr_pro_pedi_fornec_ano'
       -- número de produtos entregues no ano por fornecedor
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_entregue > 0) as 'nr_pro_entg_fornec_ano'
       -- número de produtos eliminados no ano por fornecedor
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_residuo > 0) as 'nr_pro_resi_fornec_ano'

       -- número de pedidos do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_fornec_ano'
       -- quantidade de pedidos entregues do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_fornec_ano'
       -- quantidade de pedidos eliminados do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_fornec_ano'


       -- por comprador
       -- número de pedidos por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca) as 'nr_pedi_marca_ano'
       -- número de produtos entregues por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_entregue > 0) as 'nr_pedi_entg_marca_ano'
       -- número de produtos eliminados por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_residuo >0) as 'nr_pedi_resi_marca_ano'

       -- número de produtos pedidos por marca no ano
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca) as 'nr_pro_pedi_marca_ano'
       -- número de produtos entregues por marca no ano
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_entregue > 0) as 'nr_pro_entg_marca_ano'
       -- número de produtos eliminados por marca no ano
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_residuo >0) as 'nr_pro_resi_marca_ano'

       -- número de pedidos por marcar no mês
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.codi_marca=a.codi_marca and b.mes=a.mes) as 'nr_pedi_marca_mes'
       -- número de pedidos entregues por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.codi_marca=a.codi_marca and b.mes=a.mes and b.qtde_entregue > 0) as 'nr_pedi_entg_marca_mes'
       -- número de pedidos eliminados por fornecedor no mês
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.codi_marca=a.codi_marca and b.mes=a.mes and b.qtde_residuo > 0) as 'nr_pedi_resi_marca_mes'

       -- número de produtos pedidos por marca no mês
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca) as 'nr_pro_pedi_marca_mes'
       -- número de produtos entregues por marca no mês
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_entregue > 0) as 'nr_pro_entg_marca_mes'
       -- número de produtos eliminados por marca no mês
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_residuo > 0) as 'nr_pro_resi_marca_mes'

       -- quantidade de pedidos do produto por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_marca_ano'
       -- quantidade de pedidos entregues do produto por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_marca_ano'
       -- quantidade de pedidos eliminados do produto por marca no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_marca_ano'

       -- número de pedidos por comprador no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador) as 'nr_pedi_comprador_ano'
       -- número de pedidos entregues por comprador no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_entregue > 0) as 'nr_pedi_entg_comprador_ano'
       -- número de pedidos eliminados por comprador no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_residuo > 0) as 'nr_pedi_resi_comprador_ano'

       -- número de produtos no ano por comprador
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador) as 'nr_pro_pedi_comprador_ano'
       -- número de produtos entregues no ano por comprador
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_entregue > 0) as 'nr_pro_entg_comprador_ano'
       -- número de produtos eliminados no ano por comprador
       ,(select count(distinct b.codi_produto) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_residuo > 0) as 'nr_pro_resi_comprador_ano'

       -- quantidade de pedidos do produto por marca no mês
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_marca_mes'
       -- quantidade de pedidos entregues do produto por marca no mês
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_marca_mes'
       -- quantidade de pedidos eliminados do produto por marca no mes
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_marca_mes'

       -- quantidade do produto por marca no mês
       ,(select sum(b.qtde_pedido) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_marca_mes'
       -- quantidade do produto entregue por marca no mês
       ,(select sum(b.qtde_entregue) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_marca_mes'
       -- quantidade do produto entregue por marca no mês
       ,isnull((select sum(b.qtde_residuo) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_marca_mes'

       -- quantidade de pedidos do produto por comprador no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto) as 'nr_pedi_pro_comprad_ano'
       -- quantidade de pedidos entregues do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'nr_pedi_pro_entg_comprad_ano'
       -- quantidade de pedidos eliminados do produto por fornecedor no ano
       ,(select count(distinct b.nr_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.codi_produto=a.codi_produto and b.qtde_residuo >0) as 'nr_pedi_pro_resi_comprad_ano'




       -- somadores

       -- total pedidos no ano
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano) as 'val_pedi_ano'
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano) as 'val_entg_ano'
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano) as 'val_resi_ano'

       -- valor pedidos por fornecedor no ano
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor) as 'val_pedi_fornecedor_ano'
       -- valor pedidos entregues por fornecedor no ano
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_entregue > 0) as 'val_entg_fornecedor_ano'
       -- valor pedidos eliminados por fornecedor no ano
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_fornecedor=a.codi_fornecedor and b.qtde_residuo > 0) as 'val_resi_fornecedor_ano'

       -- valor pedidos por marca no ano
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca) as 'val_pedi_marca_ano'
       -- valor pedidos entregues por marca no ano
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_entregue > 0) as 'val_entg_marca_ano'
       -- valor pedidos eliminados por marca no ano
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.qtde_residuo > 0) as 'val_resi_marca_ano'

       -- valor total dos pedidos por marca no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.mes=a.mes and b.codi_marca=a.codi_marca) as 'val_pedi_marca_mes'
       -- valor total dos pedidos entregues por marca no mês
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.mes=a.mes and b.codi_marca=a.codi_marca and b.qtde_entregue > 0) as 'val_pedi_entg_marca_mes'
       -- valor total dos pedidos eliminados por marca no mês
       ,isnull((select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.mes=a.mes and b.codi_marca=a.codi_marca and b.qtde_residuo > 0),0) as 'val_pedi_resi_marca_mes'

       -- valor pedidos por comprador no ano
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador) as 'val_pedi_comprador_ano'
       -- valor pedidos entregues por comprador no ano
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_entregue > 0) as 'val_entg_comprador_ano'
       -- valor pedidos eliminados por comprador no ano
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_comprador=a.codi_comprador and b.qtde_residuo > 0) as 'val_resi_comprador_ano'

       -- valor total dos produto por marca no ano
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_pedi_pro_marca_ano'
       -- valor total dos produto entregues por marca no ano
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_entg_pro_marca_ano'
       -- valor total dos produto eliminados por marca no ano
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_resi_pro_marca_ano'

       -- valor total dos produto por marca no mês
       ,(select sum(b.qtde_pedido * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_pedi_pro_marca_mes'
       -- valor total dos produto entregues por marca no mês
       ,(select sum(b.qtde_entregue * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_entg_pro_marca_mes'
       -- valor total dos produto eliminados por marca no mês
       ,(select sum(b.qtde_residuo * b.preco_item) from #pedidos2 b where b.ano=a.ano and b.mes=a.mes and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'val_resi_pro_marca_mes'

       -- quantidade do produto por marca no ano
       ,(select sum(b.qtde_pedido) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto) as 'qt_pro_pedi_marca_ano'
       -- quantidade do produto entregue por marca no ano
       ,(select sum(b.qtde_entregue) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_entregue > 0) as 'qt_pro_entg_marca_ano'
       -- quantidade do produto entregue por marca no ano
       ,isnull((select sum(b.qtde_residuo) from #pedidos2 b where b.ano=a.ano and b.codi_marca=a.codi_marca and b.codi_produto=a.codi_produto and b.qtde_residuo > 0),0) as 'qt_pro_resi_marca_ano'

  into PEDI_COMPRAS
  from #pedidos2 a

select *
  from #pedidos2

select top(100) *
  from PEDI_COMPRAS

select *
  from PEDI_COMPRAS
 where nr_pedido=75872

select nr_pedido
       ,sum(val_item_pedido)
  from PEDI_COMPRAS
 group by nr_pedido

select nr_pedido
       ,sum(val_item_pedido)
  from PEDI_COMPRAS
 where mes=11
 group by nr_pedido

select tot_pedi_prod_fornecedor_mes
       ,tot_pedi_prod_comprador_mes
       ,qt_pro_pedi_fornec_mes
       ,qt_pro_pedi_comprador_mes
       ,total_pedi_fornecedor_mes
       ,qt_pro_pedi_fornec_mes
       ,pre_medio_produto
       ,*
  from PEDI_COMPRAS
 where codi_produto='1080067'
       and codi_fornecedor=2358

select nr_pedido
       ,codi_produto
       ,qtde_pedido
       ,qtde_entregue
       ,qtde_residuo
       ,preco_item
       ,val_item_pedido
       ,val_item_entregue
       ,val_item_residuo
  from PEDI_COMPRAS with (nolock)

-- total de pedidos emitidos no ano

select distinct 
       nr_geral_pedi as 'pedidos_no_ano'
       ,nr_produtos_pedi as 'nr_produtos_pedidos'
       ,val_pedi_ano as 'val_pedidos_ano'
       ,nr_geral_entg as 'pedidos_entregues'
       ,nr_produtos_entg as 'nr_produtos_entregues'
       ,val_entg_ano as 'val_pedidos_entregues'
       ,nr_geral_resi as 'pedidos_eliminados'
       ,nr_produtos_resi as 'nr_produtos_eliminados'
       ,val_resi_ano as 'val_pedidos_eliminados'
  from PEDI_COMPRAS with (nolock)

-- número de pedidos emitidos no mês

select distinct 
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,nr_pedidos_mes as 'nr_pedidos_mes'
       ,nr_produtos_pedi_mes 'nr_produtos_pedidos'
       ,val_pedi_mes as 'val_pedidos'
       ,nr_pedidos_entg_mes as 'nr_pedidos_entregues_mes'
       ,nr_produtos_entg_mes  'nr_produtos_entregues_mes'
       ,val_entg_mes as 'val_pedidos_entregues'
       ,nr_pedidos_resi_mes as 'nr_pedidos_eliminados_mes'
       ,nr_produtos_resi_mes as 'nr_produtos_eliminados_mes'
       ,val_resi_mes as 'val_pedidos_eliminados'
  from PEDI_COMPRAS with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2)

-- número de pedidos emitidos por fornecedor no ano

select distinct 
       codi_fornecedor
       ,nome_fornecedor
       ,nr_pedi_fornec_ano
       ,nr_pro_pedi_fornec_ano
       ,val_pedi_fornecedor_ano
       ,nr_pedi_entg_fornec_ano
       ,nr_pro_entg_fornec_ano
       ,val_entg_fornecedor_ano
       ,nr_pedi_resi_fornec_ano
       ,nr_pro_resi_fornec_ano
       ,val_resi_fornecedor_ano
  from PEDI_COMPRAS with (nolock)
 order by nr_pedi_fornec_ano desc, nome_fornecedor, codi_fornecedor

-- número de pedidos emitidos por fornecedor no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_fornecedor
       ,nome_fornecedor
       ,nr_pedi_fornec_mes
       ,nr_pro_pedi_fornec_mes
       ,val_pedi_fornecedor_mes
       ,nr_pedi_entg_fornec_mes
       ,nr_pro_entg_fornec_mes
       ,val_pedi_entg_fornecedor_mes
       ,nr_pedi_resi_fornec_mes
       ,nr_pro_resi_fornec_mes
       ,val_pedi_resi_fornecedor_mes
  from PEDI_COMPRAS with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nr_pedi_fornec_mes desc, nome_fornecedor, codi_fornecedor

-- produtos comprados por fornecedor no ano

select distinct
       codi_fornecedor
       ,nome_fornecedor
       ,codi_produto
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,pre_medio_fornec_ano
       ,nr_pedi_pro_fornec_ano
       ,qt_pro_pedi_fornec_ano
       ,val_pedi_pro_fornec_ano
       ,nr_pedi_pro_entg_fornec_ano
       ,qt_pro_entg_fornec_ano
       ,val_entg_pro_fornec_ano
       ,nr_pedi_pro_resi_fornec_ano
       ,qt_pro_resi_fornec_ano
       ,val_resi_pro_fornec_ano
  from PEDI_COMPRAS a with (nolock)
 order by nome_fornecedor, val_entg_pro_fornec_ano desc

-- produtos comprados por fornecedor no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_fornecedor
       ,nome_fornecedor
       ,codi_produto
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,pre_medio_fornec_mes
       ,nr_pedi_pro_fornec_mes
       ,qt_pro_pedi_fornec_mes
       ,val_pedi_pro_fornec_mes
       ,nr_pedi_pro_entg_fornec_mes
       ,qt_pro_entg_fornec_mes
       ,val_entg_pro_fornec_mes
       ,nr_pedi_pro_resi_fornec_mes
       ,qt_pro_resi_fornec_mes
       ,val_resi_pro_fornec_mes
  from PEDI_COMPRAS a with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nome_fornecedor, val_entg_pro_fornec_mes desc

-- número de pedidos emitidos por marca no ano

select distinct 
       codi_marca
       ,nome_marca
       ,nr_pedi_marca_ano
       ,nr_pro_pedi_marca_ano
       ,val_pedi_marca_ano
       ,nr_pedi_entg_marca_ano
       ,nr_pro_entg_marca_ano
       ,val_entg_marca_ano
       ,nr_pedi_resi_marca_ano
       ,nr_pro_resi_marca_ano
       ,val_resi_marca_ano
  from PEDI_COMPRAS with (nolock)
 order by nr_pedi_marca_ano desc, nome_marca, codi_marca

-- número de pedidos emitidos por marca no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_marca
       ,nome_marca
       ,nr_pedi_marca_mes
       ,nr_pro_pedi_marca_mes
       ,val_pedi_marca_mes
       ,nr_pedi_entg_marca_mes
       ,nr_pro_entg_marca_mes
       ,val_pedi_entg_marca_mes
       ,nr_pedi_resi_marca_mes
       ,nr_pro_resi_marca_mes
       ,val_pedi_resi_marca_mes
  from PEDI_COMPRAS with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nr_pedi_marca_mes desc, nome_marca, codi_marca

-- produtos comprados por marca no ano

select distinct
       codi_marca
       ,nome_marca
       ,codi_produto
       ,descricao
       ,unidade
       ,val_pedi_pro_marca_ano / qt_pro_pedi_marca_ano as 'preco_medio'
       ,nr_pedi_pro_marca_ano
       ,qt_pro_pedi_marca_ano
       ,val_pedi_pro_marca_ano
       ,nr_pedi_pro_entg_marca_ano
       ,qt_pro_entg_marca_ano
       ,val_entg_pro_marca_ano
       ,nr_pedi_pro_resi_marca_ano
       ,qt_pro_resi_marca_ano
       ,val_resi_pro_marca_ano
  from PEDI_COMPRAS a with (nolock)
 order by nome_marca, val_entg_pro_marca_ano desc

-- produtos comprados por marca no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_marca
       ,nome_marca
       ,codi_produto
       ,descricao
       ,unidade
       ,val_pedi_pro_marca_mes / qt_pro_pedi_marca_mes as 'preco_medio'
       ,nr_pedi_pro_marca_mes
       ,qt_pro_pedi_marca_mes
       ,val_pedi_pro_marca_mes
       ,nr_pedi_pro_entg_marca_mes
       ,qt_pro_entg_marca_mes
       ,val_entg_pro_marca_mes
       ,nr_pedi_pro_resi_marca_mes
       ,qt_pro_resi_marca_mes
       ,val_resi_pro_marca_mes
  from PEDI_COMPRAS a with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nome_marca, val_entg_pro_marca_mes desc

-- número de pedidos emitidos por comprador no ano

select distinct 
       codi_comprador
       ,nome_comprador
       ,nr_pedi_comprador_ano
       ,nr_pro_pedi_comprador_ano
       ,val_pedi_comprador_ano
       ,nr_pedi_entg_comprador_ano
       ,nr_pro_entg_comprador_ano
       ,val_entg_comprador_ano
       ,nr_pedi_resi_comprador_ano
       ,nr_pro_resi_comprador_ano
       ,val_resi_comprador_ano
  from PEDI_COMPRAS with (nolock)
 order by nr_pedi_comprador_ano desc, nome_comprador, codi_comprador

-- número de pedidos emitidos por comprador no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_comprador
       ,nome_comprador
       ,nr_pedi_comprador_mes
       ,nr_pro_pedi_comprador_mes
       ,val_pedi_comprador_mes
       ,nr_pedi_entg_comprador_mes
       ,nr_pro_entg_comprador_mes
       ,val_pedi_entg_comprador_mes
       ,nr_pedi_resi_comprador_mes
       ,nr_pro_resi_comprador_mes
       ,val_pedi_resi_comprador_mes
  from PEDI_COMPRAS with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nr_pedi_comprador_mes desc, nome_comprador, codi_comprador

-- produtos comprados por comprador no ano

select distinct
       codi_comprador
       ,nome_comprador
       ,codi_produto
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,pre_medio_comprador_ano
       ,nr_pedi_pro_comprad_ano
       ,qt_pro_pedi_comprador_ano
       ,val_pedi_pro_comprador_ano
       ,nr_pedi_pro_entg_comprad_ano
       ,qt_pro_entg_comprador_ano
       ,val_entg_pro_comprador_ano
       ,nr_pedi_pro_resi_comprad_ano
       ,qt_pro_resi_comprador_ano
       ,val_resi_pro_comprador_ano
  from PEDI_COMPRAS a with (nolock)
 order by nome_comprador, val_entg_pro_comprador_ano desc

-- produtos comprados por comprador no mês

select distinct
       right('00'+Ltrim(str(mes,2)),2) as 'mes'
       ,codi_comprador
       ,nome_comprador
       ,codi_produto
       ,descricao
       ,codi_marca
       ,nome_marca
       ,unidade
       ,pre_medio_comprador_mes
       ,nr_pedi_pro_comprador_mes
       ,qt_pro_pedi_comprador_mes
       ,val_pedi_pro_comprador_mes
       ,nr_pedi_pro_entg_comprador_mes
       ,qt_pro_entg_comprador_mes
       ,val_entg_pro_comprador_mes
       ,nr_pedi_pro_resi_comprador_mes
       ,qt_pro_resi_comprador_mes
       ,val_resi_pro_comprador_mes
  from PEDI_COMPRAS a with (nolock)
 order by right('00'+Ltrim(str(mes,2)),2), nome_comprador, val_entg_pro_comprador_mes desc


-- *




-- *



-- produtos mais comprados por marca




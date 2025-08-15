select count(distinct x.PROCOD)
                    from TBS058 x with (nolock)
                   where x.PRPNUM in(select nr_pedido from tab)
                         and x.PRPSIT='R'
                 ) as 'qt_itens_reservados'


select *
       ,round(convert(decimal, tab2.qt_itens) / convert(decimal, tab2.nr_pedidos),2) as 'itens_por_pedido'
  from (
         select --[data]
                *
                ,(select count(distinct d.PROCOD)
                    from TBS0551 d with (nolock)
                         inner join TBS055 c with (nolock)
                            on c.PDVEMPCOD=d.PDVEMPCOD and c.PDVNUM=d.PDVNUM
                   where c.PDVDATCAD=tab.[data]
                 ) as 'qt_itens'
--                 ,(select count(distinct x.PROCOD)
--                    from TBS058 x with (nolock)
--                   where x.PRPNUM in(select nr_pedido from tab)
--                         and x.PRPSIT='R'
--                 ) as 'qt_itens_reservados'
           from (
                  select convert(char(8), c.PDVDATCAD, 112) as 'data'
                         ,count(c.PDVNUM) as 'nr_pedidos'
                    from TBS055 c with (nolock)
                   where PDVDATCAD >= '20230101'
                         and c.PDVDATCAD < convert(date, getdate())
                   group by convert(char(8), c.PDVDATCAD, 112)
                ) as tab
       ) as tab2
 order by tab2.[data]
 
select *
  from TBS058 with (nolock)


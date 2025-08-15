select c.PDCDATCAD as 'emissao'
       ,c.PDCNUM as 'pedido'
       ,c.FORCOD as 'cod_fornecedor'
       ,(select FORNOM from TBS006 f with (nolock) where f.FOREMPCOD=c.FOREMPCOD and f.FORCOD=c.FORCOD) as 'nome_fornecedor'
       ,c.COMCOD as 'cod_comprador'
       ,(select COMNOM from TBS046 p with (nolock) where p.COMEMPCOD=c.COMEMPCOD and p.COMCOD=c.COMCOD) as 'nome_comprador'
       ,c.PDCDATPFA as 'prev_faturamento'
       ,c.PDCDATPEN as 'prev_entrega'
       ,count(d.PDCITE) as 'q_itens'
       --,c.*
  from TBS045 c with (nolock)
  inner join TBS0451 d with (nolock)
        on d.PDCEMPCOD=c.PDCEMPCOD
           and d.PDCNUM=c.PDCNUM
 where d.PROCOD='99'
 group by c.PDCDATCAD
          ,c.PDCNUM
          ,c.FOREMPCOD
          ,c.FORCOD
          ,c.COMEMPCOD
          ,c.COMCOD
          ,c.PDCDATPFA
          ,c.PDCDATPEN
 order by c.PDCDATCAD
          ,c.PDCNUM
-- itens pendentes com atraso

if object_id('tempdb.dbo.#item_pedido') is not null 
begin 
	drop table #item_pedido
end

select i.PDCEMPCOD as 'empresa'
       ,i.PDCNUM as 'nr_pedido'
       ,i.PDCITE as 'item'
       ,i.PROEMPCOD as 'emp_produto'
       ,i.PROCOD as 'produto'
       ,i.PDCDES as 'descricao'
       ,i.PDCQTD - (PDCQTDENT+PDCQTDRES) as 'qt_pendente'
       ,i.PDCUNI as 'unidade'
       ,i.PDCQTDEMB as 'embalagem'
       ,isnull(i.PDCDATPRE,'19000101') as 'prev_entrega'
       ,isnull(i.PDCDATFAT,'19000101') as 'prev_faturamento'
       ,i.PDCQTD as 'qt_pedido'
       ,i.PDCQTDENT as 'qt_entregue'
       ,isnull((select MAREMPCOD from TBS010 p with (nolock) where p.PROEMPCOD=i.PROEMPCOD and p.PROCOD=i.PROCOD),0) as 'emp_marca'
       ,isnull((select MARCOD from TBS010 p with (nolock) where p.PROEMPCOD=i.PROEMPCOD and p.PROCOD=i.PROCOD),0) as 'cod_marca'
  into #item_pedido
  from TBS0451 i with (nolock)
 where PDCQTD - (PDCQTDENT+PDCQTDRES) > 0
       and PDCDATPRE < convert(date,getdate())

-- pedidos de compras

if object_id('tempdb.dbo.#pedido') is not null 
begin 
	drop table #pedido
end

select c.PDCNUM as 'nr_pedido'
       ,c.FORCOD as 'cod_fornecedor'
       ,isnull((select FORNOM from TBS006 f with (nolock) where f.FOREMPCOD=c.FOREMPCOD and f.FORCOD=c.FORCOD),'') as 'fornecedor'
       ,isnull(c.COMCOD,0) as 'cod_comprador'
       ,isnull((select COMNOM from TBS046 u with (nolock) where u.COMEMPCOD=c.COMEMPCOD and u.COMCOD=c.COMCOD),'') as 'comprador'
       ,isnull(c.PDCDATPEN,'19000101') as 'entrega'
       ,isnull(c.PDCDATPFA,'19000101') as 'faturamento'
       ,d.item
       ,d.produto
       ,d.descricao
       ,d.qt_pendente
       ,d.unidade
       ,d.embalagem
       ,d.prev_entrega
       ,d.prev_faturamento
       ,d.qt_pedido
       ,d.qt_entregue
       ,d.cod_marca
       ,isnull((select MARNOM from TBS014 m with (nolock) where m.MAREMPCOD=d.emp_marca and m.MARCOD=d.cod_marca),'') as 'marca'
  into #pedido
  from TBS045 c with (nolock)
  inner join #item_pedido d
        on d.empresa=c.PDCEMPCOD
           and d.nr_pedido=c.PDCNUM

select nr_pedido
       ,cod_fornecedor
       ,fornecedor
       ,cod_comprador
       ,comprador
       ,entrega
       ,faturamento
       ,item
       ,produto
       ,descricao
       ,qt_pendente
       ,unidade
       ,embalagem
       ,prev_entrega
       ,prev_faturamento
       ,qt_pedido
       ,qt_entregue
       ,cod_marca
       ,marca
  from #pedido
 where cod_comprador in(@compradores)
       and cod_fornecedor=case when @codFornecedor=0 then cod_fornecedor else @codFornecedor end
       and rtrim(fornecedor) Like(case when @nomeFornecedor='' then rtrim(fornecedor) else rtrim(upper(@nomeFornecedor)) end)
       and cod_marca=case when @codMarca=0 then cod_marca else @codMarca end
       and rtrim(marca) Like(case when @nomeMarca='' then rtrim(marca) else rtrim(upper(@nomeMarca)) end)
 order by prev_entrega
          ,nr_pedido
          ,descricao
 
select *
  from #item_pedido

select DATEADD(DAY, -3, GETDATE())

select COMCOD as 'codigo'
       ,COMNOM + Ltrim(str(COMCOD,4)) as 'comprador'
  from TBS046 with (nolock)
 where COMSTA='A'



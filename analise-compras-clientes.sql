if object_id('tempdb.dbo.#unidade2') is not null 
   begin 
      drop table #unidade2
   end

select PROCOD as 'codigo'
       ,PROUM2QTD as 'embalagem'
  into #unidade2
  from TBS010 with (nolock)
  where PROUM2QTD > 1

select *
  from #unidade2

select PROCOD
       ,PROUM1
       ,PROUM1QTD
       ,PROUM2
       ,PROUM2QTD
  from TBS010 with (nolock)
 where PROUM2 <> ''

select *
  from DWVendas with (nolock)
 where [data] between '20220901' and '20220930'
       and cancelado='N'
       and caixa=1

select *
  from DWVendas with (nolock)
 where [data] between '20220201' and '20220930'
       and cancelado='N'
       and caixa > 0
       and codigoProduto in('1070040','16280026','16280028','10390011','7870123','7041833','18520001','5970004','0310011','13710008','18620001')
       and embalagem2 > 0
       and quantidade >= embalagem2

-- vendas no período

select codigoProduto
       ,descricaoProduto
       ,sum(quantidade) as 'quantidade'
       ,sum(valorTotal) as 'valor_total'
       ,avg(precoUnitario) as 'preco_medio'
  from DWVendas with (nolock)
 where [data] between '20210201' and '20210930'
       and cancelado='N'
       and caixa > 0
       and codigoProduto in('1070040','16280026','16280028','10390011','7870123','7041833','18520001','5970004','0310011','13710008','18620001')
 group by codigoProduto, descricaoProduto

select PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where PROCOD in('20964689','20966104')

select PROCOD
       ,PRODES
  from TBS010 with (nolock)
 where PROCOD='99970077'

select *
  from DWVendas with (nolock)
 where --[data] between '20220901' and '20220930'
       --and 
       cancelado='N'
       and codigoProduto='99970077'


select top(10) *
  from DWVendas with (nolock)
 where caixa > 0

select codigoProduto
       ,descricaoProduto
       ,sum(quantidade) as 'quantidade'
       ,sum(valorTotal) as 'valor_total'
       ,avg(precoUnitario) as 'preco_medio'
       ,count(*)
       ,count(case when embalagem2 > 0 and quantidade < embalagem2 then 1 else 0 end)
  from DWVendas with (nolock)
 where [data] between '20220201' and '20220930'
       and cancelado='N'
       and caixa > 0
       and codigoProduto in('1070040','16280026','16280028','10390011','7870123','7041833','18520001','5970004','0310011','13710008','18620001')
 group by codigoProduto, descricaoProduto

select codigoProduto
       ,descricaoProduto
       ,sum(quantidade) as 'quantidade'
       ,sum(valorTotal) as 'valor_total'
       ,avg(precoUnitario) as 'preco_medio'
       ,count(*)
  from DWVendas with (nolock)
 where [data] between '20220201' and '20220930'
       and cancelado='N'
       and caixa > 0
       and codigoProduto in('1070040','16280026','16280028','10390011','7870123','7041833','18520001','5970004','0310011','13710008','18620001')
 group by numeroDocumento, codigoProduto, descricaoProduto

if object_id('tempdb.dbo.#produtos') is not null 
   begin 
      drop table #produtos
   end

-- comparativo atacado x varejo

select ven.codigoProduto
       ,(select PRODES from TBS010 with (nolock) where PROCOD=ven.codigoProduto) as 'descricaoProduto'
       ,(select PROUM2 from TBS010 with (nolock) where PROCOD=ven.codigoProduto) as 'UM2'
       ,(select PROUM2QTD from TBS010 with (nolock) where PROCOD=ven.codigoProduto) as 'qtde_embalagem'
       ,sum(quantidade) as 'quantidade'
       ,sum(valorTotal) as 'valor_total'
       ,avg(precoUnitario) as 'preco_medio'
       ,count(*)
       --,(select count(*)
           --from DWVendas b with (nolock)
          --where b.[data] between '20220201' and '20220930'
                --and b.cancelado='N'
                --and b.caixa > 0
                --and b.codigoProduto=a.codigoProduto
          --group by b.numeroDocumento, b.codigoProduto         
        --)
--       ,count(*)
       ,sum(case when embalagem2 > 0 and quantidade < embalagem2 then 1 else 0 end) as 'varejo'
       ,sum(case when embalagem2 > 0 and quantidade >= embalagem2 then 1 else 0 end) as 'atacado'
  --into #produtos
  from DWVendas ven with (nolock)
  --inner join TBS010 pro with (nolock)
     --on pro.PROCOD=ven.codigoProduto
 where [data] between '20220201' and '20220930'
       and cancelado='N'
       and caixa > 0
       and codigoProduto in('1070040','16280026','16280028','10390011','7870123','7041833','18520001','5970004','0310011','13710008','18620001')
 group by codigoProduto

select *
,(select count(*)
           from DWVendas b with (nolock)
          where b.[data] between '20220201' and '20220930'
                and b.cancelado='N'
               and b.caixa > 0
                and b.codigoProduto='1070040' --a.codigoProduto
          group by b.numeroDocumento, b.codigoProduto         
        )
  from #produtos a

select count(*)
  from (
select count(*) as 'registros'
           from DWVendas b with (nolock)
          where b.[data] between '20220201' and '20220930'
                and b.cancelado='N'
               and b.caixa > 0
                and b.codigoProduto='1070040' --a.codigoProduto
          group by b.numeroDocumento, b.codigoProduto ) tab

select count(*) as 'registros'
           from DWVendas b with (nolock)
          where b.[data] between '20220201' and '20220930'
                and b.cancelado='N'
               and b.caixa > 0
                and b.codigoProduto='1070040' --a.codigoProduto
          group by b.codigoProduto

-- clientes que não compraram em 2021 e compraram em 2022

select --count(*)
       CLICOD
       ,CLINOM
       ,(select sum(valorTotal)
           from DWVendas with (nolock)
          where cancelado='N'
                and [data] between '20220101' and '20221020'
                and codigoCliente=CLICOD 
        )
        ,(select VENNOM
            from TBS004 p with (nolock)
           where p.VENCOD=c.VENCOD 
         )
  from TBS002 c with (nolock)
 where not exists (select ''
                     from DWVendas with (nolock)
                    where cancelado='N'
                          and [data] between '20210101' and '20211231'
                          and codigoCliente=c.CLICOD
                  )
       and c.CLIUCPDAT between '20220101' and '20221020'
       and c.CLICGC not in('05118717000156','52080207000117','44125185000136','65069593000350','65069593000198','65069593000279','41952080000162')

select top(1) *
  from DWVendas with (nolock)
 where valorTotal <> valorProdutos

select *
  from DWVendas with (nolock)
 where codigoCliente in(25227)

select top(1) *
  from DWVendas with (nolock)

select sum(valorTotal)
       ,sum(custoTotal)
  from DWVendas with (nolock)
 where cancelado='N'
       and [data] between '20220901' and '20220930'



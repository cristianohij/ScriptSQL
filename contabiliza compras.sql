select convert(char(10),PDCDATCAD,103) as 'emissao',TBS045.PDCNUM as 'pedido',FORCOD as 'cod-fornecedor',
       (select FORNOM from TBS006 (nolock) where FORCOD = TBS045.FORCOD) as 'nome-fornecedor',
       str(isnull(round(sum(dbo.valTotLiquidoProdutoPC(TBS045.PDCEMPCOD,TBS045.PDCNUM,PDCITE)),2),0),11,2) as 'valor'
  from TBS045 (nolock) join TBS0451 on TBS0451.PDCEMPCOD = TBS045.PDCEMPCOD and TBS0451.PDCNUM = TBS045.PDCNUM
 where PDCDATCAD >= '20121001'
 group by PDCDATCAD,TBS045.PDCNUM,FORCOD
 order by PDCDATCAD
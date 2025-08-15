select --*,
       TBS0451.PDCPROFOR codigo,
       PDCQTD qtde,
       PDCPRE preco,
       dbo.PDCTOTITE(0,25170,PDCITE) total,
       dbo.PDCVDDITE(0,25170,PDCITE) desconto,
       PDCIPI ipi,
       dbo.PDCVALIPI(0,25170,PDCITE) valipi,
       PDCPORST porcentst,
       dbo.PDCVALST(0,25170,PDCITE) valst,
       dbo.PDCPRELIQ(0,25170,PDCITE) preCompra
  from TBS0451 with (nolock) where PDCNUM=25170 order by TBS0451.PDCPROFOR

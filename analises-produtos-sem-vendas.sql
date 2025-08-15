-- mudar para estoque 2 Best Bag

-- contagem dos produtos
select count(*) from TBS010 (nolock)

-- marcados como ativos
select count(*) from TBS010 (nolock) where PROSTATUS='A'

-- produtos sem movimentação de entrada e/ou saída no último ano
select count(*) from ProdutosInativosA6Meses (nolock)

--

-- produtos ativos
select count(*)
  from ProdutosInativosA6Meses (nolock)
       join TBS010 (nolock) on PROCOD=CodigoDoProduto
 where PROSTATUS='A'


-- produtos sem vendas e com saldo em estoque
select ESTLOC,count(*) from TBS032 (nolock) where ESTLOC in(1,2) and ESTQTDATU > 0 group by ESTLOC

select count(*)
  from ProdutosInativosA6Meses (nolock)
       join TBS010 (nolock) on TBS010.PROCOD=CodigoDoProduto
       join TBS032 (nolock) on TBS032.PROCOD=CodigoDoProduto
 where ESTLOC in(1,2) and 
       ESTQTDATU > 0

select count(*)
  from ProdutosInativosA6Meses (nolock)
       join TBS010 (nolock) on TBS010.PROCOD=CodigoDoProduto
       join TBS032 (nolock) on TBS032.PROCOD=CodigoDoProduto
 where ESTLOC in(1,2) and 
       ESTQTDATU > 0
group by TBS032.PROCOD

select TBS010.PROCOD,
       TBS010.PRODES,
       TBS012.GRUDES,
       TBS0121.SUBGRUDES,
       (select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and TBS032.PROCOD=TBS010.PROCOD),
       isnull((select ESTQTDATU from TBS032 (nolock) where ESTLOC=2 and TBS032.PROCOD=TBS010.PROCOD),0)
  from TBS010 (nolock)
       join TBS032 (nolock) on TBS032.PROCOD=TBS010.PROCOD
       join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD
       join TBS0121 (nolock) on TBS0121.GRUCOD=TBS012.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
 where ESTLOC in(1,2) and 
       ESTQTDATU > 0
 group by TBS010.PROCOD,
       TBS010.PRODES,
       TBS012.GRUDES,
       TBS0121.SUBGRUDES

select CodigoDoProduto,
       TBS010.PRODES,
       TBS012.GRUDES,
       TBS0121.SUBGRUDES,
       (select ESTQTDATU from TBS032 (nolock) where ESTLOC=1 and PROCOD=CodigoDoProduto),
       isnull((select ESTQTDATU from TBS032 (nolock) where ESTLOC=2 and PROCOD=CodigoDoProduto),0)
  from ProdutosInativosA6Meses (nolock)
       join TBS010 (nolock) on TBS010.PROCOD=CodigoDoProduto
       join TBS032 (nolock) on TBS032.PROCOD=CodigoDoProduto
       join TBS012 (nolock) on TBS012.GRUCOD=TBS010.GRUCOD
       join TBS0121 (nolock) on TBS0121.GRUCOD=TBS012.GRUCOD and TBS0121.SUBGRUCOD=TBS010.SUBGRUCOD
 where ESTLOC in(1,2) and 
       ESTQTDATU > 0
 group by CodigoDoProduto,
       TBS010.PRODES,
       TBS012.GRUDES,
       TBS0121.SUBGRUDES


-- produtos sem vendas, com saldo em estoque e com valor de custo e de vendas
select ESTLOC,sum(TDPCUSREA*ESTQTDATU) as 'custo',sum(TDPPRECOR1*ESTQTDATU) as 'venda'
  from ProdutosInativosA6Meses (nolock)
       join TBS010 (nolock) on TBS010.PROCOD=CodigoDoProduto
       join TBS032 (nolock) on TBS032.PROCOD=CodigoDoProduto
       join TBS031 (nolock) on TDPPROCOD=CodigoDoProduto
 where ESTLOC in(1,2) and 
       ESTQTDATU > 0
 group by ESTLOC




select CodigoDoProduto,count(*) from ProdutosSemGiro6Meses (nolock)
 group by CodigoDoProduto
having count(*) > 1

select count(*) from TBS032 (nolock) where ESTLOC=2 and ESTQTDATU < 0

select * from ProdutosSemGiro6Meses (nolock)
 where exists(select '' from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC in(1,2) and ESTQTDATU > 0)

select *,
       isnull((select ESTQTDATU from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC=1 and ESTQTDATU > 0),0) as 'E1'
       isnull((select ESTQTDATU from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC=2 and ESTQTDATU > 0),0) as 'E2'
  from ProdutosSemGiro6Meses (nolock)
 where exists(select '' from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC in(1,2) and ESTQTDATU > 0)



--


-- codigo;ultimaNFE;valorUltimaNFE;utilmaNFS;valorUltimaNFS;ultimoCF;valorUltimoCF;descricao;estoque1;estoque2;precoAtual;grupo;marca

select CodigoDoProduto as 'codigo',
       DataDaUltimaNFE as 'ultimaNFE',
       ValorDaUltimaNFE as 'valorUltimaNFE',
       DataDaUltimaNFS as 'utilmaNFS',
       ValorDaUltimaNFS as 'valorUltimaNFS',
       DataDoUltimoCF as 'ultimoCF',
       ValorDoUltimoCF as 'valorUltimoCF',
       PRODES as 'descricao',
       isnull((select ESTQTDATU from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC=1 and ESTQTDATU > 0),0) as 'estoque1',
       --isnull((select ESTQTDATU from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC=2 and ESTQTDATU > 0),0) as 'estoque2',
       isnull((select TDPPRECOR1 from TBS031 (nolock) where TDPPROCOD=CodigoDoProduto),0) as 'precoAtual',
       GRUDES as 'grupo',
       MARNOM as 'marca',
       PROUM1 as 'unidade',
       PROUM1QTD as 'embalagem'
  from ProdutosSemGiro (nolock)
       Left join TBS010 (nolock) on CodigoDoProduto=TBS010.PROCOD
       Left join TBS012 (nolock) on TBS010.GRUCOD =TBS012.GRUCOD
 where exists(select '' from TBS032 (nolock) where PROCOD=CodigoDoProduto and ESTLOC=1 and ESTQTDATU > 0)     

SELECT PROCOD, 
    ESTOQUE1 = ISNULL(SUM(CASE WHEN ESTLOC = 1 THEN ESTQTDATU END),0),
    ESTOQUE2 = ISNULL(SUM(CASE WHEN ESTLOC = 2 THEN ESTQTDATU END),0)
FROM TBS032
WHERE ESTQTDATU>0
GROUP BY PROCOD

select ESTLOC,COUNT(*) from TBS032 (nolock) where ESTLOC in(1,2) and ESTQTDATU > 0 group by ESTLOC


-- rodar no studio

select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [BestBag$]') 
union
select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [TanbyMatriz$]')

select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Unificacao$]') 
union
select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [TanbyTaubate$]') 

select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Unificacao$]') 
union
select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Misaspel$]') 

select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Unificacao$]') 
union
select codigo,descricao
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Papelyna$]') 

select codigo,count(*)
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 8.0;Database=C:\temp\ProdutosSemVendas.xlsx', 'select * from [Unificacao$]') 
 group by codigo
 having count(*) > 1



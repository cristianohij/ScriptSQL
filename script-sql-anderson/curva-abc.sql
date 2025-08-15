declare @dataDe char(8), @dataAte char(8), @produtoDe char(10), @produtoAte char(10)

set @dataDe='20150901'
set @dataAte='20150930'
set @produtoDe=''
set @produtoAte=''

select Identity(INT,1,1) as ordem,
       TBS0671.PROCOD as CodigoProduto,
       (select PRODES from TBS010 (nolock) where TBS010.PROCOD=TBS0671.PROCOD) as DescricaoProduto,
       sum(dbo.NFSTOTITEST(TBS0671.NFSEMPCOD,TBS0671.NFSNUM,TBS0671.SNEEMPCOD,TBS0671.SNESER,TBS0671.NFSITE)) as valor
       into #VENDAS
  from TBS067 (nolock)
          left join TBS0671 (nolock) on TBS0671.SNESER=TBS067.SNESER and TBS0671.NFSNUM=TBS067.NFSNUM
          left join TBS042 (nolock) on TBS042.TESCOD=TBS0671.TESCOD
          left join TBS002 (nolock) on TBS002.CLICOD=TBS067.NFSCLICOD
 where TBS067.NFSDATEMI between @dataDe and @dataAte and
       TBS0671.PROCOD between @produtoDe and case when @produtoAte='' then 'Z' else @produtoAte end and
       TBS067.NFSTIP='N' and
       TBS067.NFSCAN='N' and
       TBS067.NFSDEV='N' and
       (TBS0671.NFSROPCNTVEN='S' or TBS042.TESCNTVEN='S') and
       TBS067.NFSCLINOM not Like('%BEST BAG%') and
       TBS067.NFSCLINOM not Like('%BEST OFFICE%') and
       TBS067.NFSCLINOM not Like('%MISASPEL%') and
       TBS067.NFSCLINOM not Like('%PAPELYNA%') and 
       TBS067.NFSCLINOM not Like('%TANBY%')
 group by TBS0671.PROCOD
 order by valor desc

select * from #VENDAS

-- 1

;WITH Res (ordem, CodigoProduto, DescricaoProduto, valor, total)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, SUM(valor) OVER (PARTITION BY 1) As total FROM #VENDAS)

SELECT
    ordem, CodigoProduto, DescricaoProduto, valor, total,
    ROUND(valor / total * 100,4) As Perc
FROM Res

-- 2

;WITH Res (ordem, CodigoProduto, DescricaoProduto, valor, total)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, SUM(valor) OVER (PARTITION BY 1) As total FROM #VENDAS),

QPerc(ordem, CodigoProduto, DescricaoProduto, valor, total, Perc)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, total, valor / total As Perc FROM Res)

SELECT
    ordem, CodigoProduto, DescricaoProduto, valor, total, Perc,
    ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt
        WHERE TInt.ordem <= TOut.ordem),4) As PercAcum
FROM QPerc As TOut 

-- 3

CREATE VIEW vProdutos As
WITH Res (ordem, CodigoProduto, DescricaoProduto, valor, total)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, SUM(valor) OVER (PARTITION BY 1) As total FROM #VENDAS),

QPerc(ordem, CodigoProduto, DescricaoProduto, valor, total, Perc)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, total, valor / total As Perc FROM Res)

SELECT
    ordem, CodigoProduto, DescricaoProduto, valor, total, Perc,
    ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt
        WHERE TInt.ordem <= TOut.ordem),4) As PercAcum
FROM QPerc As TOut 

-- view não pode ser criada com base em tabela temporária

-- 4

drop table #VENDAS2

;WITH Res (ordem, CodigoProduto, DescricaoProduto, valor, total)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, SUM(valor) OVER (PARTITION BY 1) As total FROM #VENDAS),

QPerc(ordem, CodigoProduto, DescricaoProduto, valor, total, Perc)
As
(SELECT ordem, CodigoProduto, DescricaoProduto, valor, total, valor / total As Perc FROM Res),

QItens(itens)
as
(SELECT max(ordem) as itens FROM Res)

SELECT
    ordem, CodigoProduto, DescricaoProduto, valor, total, Perc,
    ROUND((SELECT SUM(TInt.Perc) FROM QPerc As TInt
        WHERE TInt.ordem <= TOut.ordem),4) As PercAcum,
    (select itens from QItens) as qtdeItens
into #VENDAS2        
FROM QPerc As TOut 

-- 5

;WITH Intervalos (grupo) As (
SELECT 0.80 UNION ALL	-- no exemplo estava 0.65
SELECT 0.95 UNION ALL	-- 0.90
SELECT 1.00)

SELECT
    ordem, CodigoProduto, DescricaoProduto, Valor, Perc*100 as porcent, PercAcum*100 as porcent_acumulado,
    MIN(grupo) As grupo, CASE
        WHEN MIN(grupo) = 0.80 THEN 'A'
        WHEN MIN(grupo) = 0.95 THEN 'B'
        ELSE 'C' END As Intervalo,
    qtdeItens as itens
into #VENDAS3
FROM #VENDAS2 As C
INNER JOIN Intervalos As I ON C.PercAcum <= I.grupo
GROUP BY ordem, CodigoProduto, DescricaoProduto, valor, Perc, PercAcum, qtdeItens

drop table #VENDAS3

select top 1 * from #VENDAS3

select * from #VENDAS3

select Intervalo,
       count(*)*100/itens,
       count(*),
       case when Intervalo='A' then max(porcent_acumulado) 
	when Intervalo='B' then max(porcent_acumulado) - 80 
	else max(porcent_acumulado) - 95 end,
       sum(Valor),
       max(porcent_acumulado)
  from #VENDAS3
 group by Intervalo, itens
 order by Intervalo


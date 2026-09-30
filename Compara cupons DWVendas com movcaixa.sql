DECLARE @dataDe date = '20250801', @dataAte date = '20250831'

;with 
	cancelamentos as(

	select sum(valorTotal) as cancel from DWVendas
	--select numeroDocumento[cupom], codigoProduto[produto], descricaoProduto[descricao], valorTotal, valorDescontoTotal, quantidade from DWVendas
	where data between @dataDe and @dataAte	
	and caixa > 0
	--and caixa = 5
	--and hora between '15:20' and '16:00'
	--and codigoProduto = '1640054'
	and cancelado = 'S'
),
vendas as(
	select sum(valorTotal) as vendas from DWVendas
--	select numeroDocumento[cupom], codigoProduto[produto], descricaoProduto[descricao], valorTotal, valorDescontoTotal, quantidade from DWVendas
	where data between @dataDe and @dataAte	
	and caixa > 0
	--and caixa = 5
	--and hora between '15:20' and '16:00'
	--and codigoProduto = '1640054'
	and cancelado = 'N'
),
vendasInt as (
	select 
	convert(decimal(10,2), vendas - isnull(cancel, 0)) as [liquido Int],
		vendas,
		isnull(cancel, 0) as TotalCan 		
	from cancelamentos, vendas
),
vendasGZ as(

select sum(valortot) - sum(descitem)- sum(desccupom) - sum(abatpgto) as [liquido GZ] from movcaixagz
-- select cupom, cdprod, descricao, valortot, quant, descitem, desccupom, hora from movcaixagz
where  data between @dataDe and @dataAte
and status = '01'
--and caixa = 2
--and hora between '15:20' and '16:00'
--and cdprod = '1640054'
and cancelado <> 'S'
--group by data
--order by data
)

select @dataDe'De',@dataAte'Ate', vendas, TotalCan, [liquido Int], [liquido GZ], [liquido Int] - [liquido GZ]'diferen�a INT' from vendasInt, vendasGZ

/* 
-- corrigir dados...

delete DWVendas where caixa > 0 and data = '20250409'

exec usp_AlimentaDWVendas_Cupons 2, '20250823', '20250823'

select cupom, data, hora, datahoraproc, valortot, caixa, cdprod, quant from movcaixagz
-- select sum(valortot) from movcaixagz
where data= '20250828' and 
datahoraproc >= '20250829'
and status = '03'
and cancelado = ''
order by cdprod
*/

-- select * from DWVendas where data  = '20250818'

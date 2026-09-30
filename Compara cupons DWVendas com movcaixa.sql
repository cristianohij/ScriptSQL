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

select top(100) *
  from movcaixagz mv with (nolock)

select sum(mv.valortot)		-- 800.227,52
  from movcaixagz mv with (nolock)
 where mv.[data] between '20260201' and '20260228'
       and mv.cancelado <> 'N'
	   and mv.[status] = '03'

select mv.cupom
       ,sum(mv.valortot)
  from movcaixagz mv with (nolock)
 where data between '20260201' and '20260228'
       and mv.cancelado = ''
       and mv.[status] = '03'
 group by mv.cupom
 having sum(mv.valortot) = 159.85

select count(*)
  from movcaixagz mv with (nolock)
 where mv.[data] between '20260201' and '20260228'
       and mv.cancelado <> 'N'
	   and mv.[status] = '03'
 group by mv.caixa, mv.cupom

SELECT COUNT(DISTINCT CONCAT(mv.caixa,'-',mv.cupom))
FROM movcaixagz mv with (nolock)
WHERE mv.[data] between '20260201' and '20260228'
      --and mv.cancelado <> 'N'
      and mv.[status] = '03'

select mv.nfce_chave -- 5.512
  from movcaixagz mv with (nolock)
 where mv.[data] between '20260201' and '20260228'
       and mv.cancelado <> 'N'
	   and mv.[status] = '03'
 group by mv.nfce_chave


DECLARE @xml XML

SELECT @xml = BulkColumn
FROM OPENROWSET(
    BULK 'c:\integros\temp\listagem-chaves.xml',
    SINGLE_BLOB
) AS x

--SELECT LEN(CONVERT(VARCHAR(MAX), @xml)) AS tamanho_xml

--SELECT CONVERT(VARCHAR(MAX), @xml)

;WITH XMLNAMESPACES (
'http://www.portalfiscal.inf.br/nfe' AS nfe
)

SELECT -- 5.490
    X.value('.', 'varchar(44)') AS ChaveNFCe
FROM @xml.nodes('//nfe:chNFCe') AS T(X)
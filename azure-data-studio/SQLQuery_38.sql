select 	chave
        ,numeroDocumento
	    ,caixa
        ,numeroSerieDocumento
        ,item
        ,codigoEmpresaProduto
        ,codigoProduto
        ,codigoEmpresaGrupoProduto
        ,codigoGrupo
        ,contabiliza
        ,[data]
        ,quantidade
        ,precoUnitario
        ,custoUnitario
        ,valorTotal
        ,valorSemDescontoIcms
        ,custoTotal
        --,*
  into #vendas
  from DWVendas with (nolock)
 where  [data] between '20220601' and '20220630'
	    and contabiliza = 'L'
	    and cancelado = 'N'
	    --and chave not in (select chave from #RegistroCanceladoVendas (nolock)) and 
	    and numeroSerieDocumento <> 3

select sum(valorTotal)
  from #vendas

if object_id('tempdb.dbo.#RegistroCanceladoVendas') is not null
begin
	drop table #RegistroCanceladoVendas
end

select 
	chave
    ,valorTotal
into #RegistroCanceladoVendas
from 
	DWVendas (nolock) 
where 
    data between '20220701' and '20220731' and 
	cancelado = 'S' and 
    contabiliza = 'L'
order by 
	data, 
	cancelado, 
	contabiliza

select sum(valorTotal)
  from #RegistroCanceladoVendas

select *
  from DWVendas with (nolock)
 where contabiliza='L'
       and [data] between '20220601' and '20220630'
       and cancelado='N'

select caixa
       ,sum(valorTotal)
  from DWVendas with (nolock)
 where --contabiliza='L'
       --caixa > 0
       [data] between '20220701' and '20220731'
       --and cancelado='N'
       and chave not in (select chave from #RegistroCanceladoVendas)
       --and numeroSerieDocumento<>3
 --group by caixa --rollup(caixa)
 group by rollup(caixa)

select *
  from DWVendas with (nolock)
 where [data] between '20220601' and '20220630'
       and contabiliza='L'
       and caixa > 0

if object_id('tempdb.dbo.#RegistroCanceladoVendas') is not null
begin
	drop table #RegistroCanceladoVendas
end

select 
	chave
    ,valorTotal

into #RegistroCanceladoVendas
	
from 
	DWVendas (nolock) 

where 
	--data between @dataDe and @dataAte and 
    data between '20220601' and '20220630' and 
	cancelado = 'S' and 
	--contabiliza = @contabiliza
    contabiliza = 'L'
	
order by 
	data, 
	cancelado, 
	contabiliza
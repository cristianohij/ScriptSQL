-- clientes atendidos no frente de loja

-- Variaveis internas

declare @menorData date, @comandogz varchar(8000) 
set @menorData = (select min(data) from movcaixagz (nolock))

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Criando estrutura da tabela a ser utilizada

if object_id('tempdb.dbo.#MSL002') is not null
begin 
	drop table #MSL002
end

create table #MSL002 (M2_DAT DATE, M2_HOR CHAR(10), M2_CXA INT, M2_OPE INT,M2_VAL decimal(10,3), M2_ABT decimal(10,3), M2_DESCUP decimal(10,3), M2_ACRCUP decimal(10,3))

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Verificando de onde tirar os dados

-- Se a menor data da movcaixagz for maior que dataAte, significa que não tem dados na movcaixagz, então tenho que buscar tudo da gz

if 	@menorData > @dataAte

begin

	set @comandogz = 'EXECUTE(''
	select 
	data,
	hora,
	caixa,
	operador,
	sum(valortot) as valor,
	sum(desccupom) as desconto,
	sum(abatpgto) as abatimento,
	sum(acrescupom) as acrescimo
	
	FROM movcaixa
	where
	data between "'+convert(char(8), @dataDe ,112)+'" and "'+convert(char(8), @dataAte,112)+'"  and 
	status = 03 and 
	cancelado <> "S"
	group by caixa,operador,data,hora '') at MYSQLGZ'
	
	insert into #MSL002
	exec(@comandogz)
	
end  

-- Se a menor data da movcaixagz estiver entre dataDe - dataAte, siginifica que tem dados na movcaixagz, preciso pegar os dados de lá e no campo data filtra menorData - dataAte

if (select top 1 1 from TBS001 (nolock) where @menorData between @dataDe and @dataAte) = 1 

begin 

	insert into #MSL002

	select 
	data,
	hora,
	caixa,
	operador,
	sum(valortot) as valor,
	sum(desccupom) as desconto,
	sum(abatpgto) as abatimento,
	sum(acrescupom) as acrescimo
	
	FROM movcaixagz
	where
	data between @menorData and @dataAte and
	status = '03' and 
	upper(cancelado) <> 'S'
	
	group by 
	caixa,
	operador,
	data,
	hora
	
	set @comandogz = 'EXECUTE(''
	select 
	data,
	hora,
	caixa,
	operador,
	sum(valortot) as valor,
	sum(desccupom) as desconto,
	sum(abatpgto) as abatimento,
	sum(acrescupom) as acrescimo
	
	FROM movcaixa
	where
	data between "'+convert(char(8), @dataDe ,112)+'" and "'+convert(char(8), dateadd(day,-1,@menorData),112)+'"  and
	status = 03 and 
	cancelado <> "S"
	group by caixa,operador,data,hora '') at MYSQLGZ'
	
	insert into #MSL002
	exec(@comandogz)

end 

if @dataDe > @menorData

begin 

	insert into #MSL002

	select 
	data,
	hora,
	caixa,
	operador,
	sum(valortot) as valor,
	sum(desccupom) as desconto,
	sum(abatpgto) as abatimento,
	sum(acrescupom) as acrescimo
	
	FROM movcaixagz
	where
	data between @dataDe and @dataAte and 
	status = '03' and 
	upper(cancelado) <> 'S'
	
	group by 
	caixa,
	operador,
	data,
	hora

end 

-- select * from #MSL002

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Tabela final

select  
convert(char(8),M2_DAT,3) as 'data',
subString(M2_HOR,1,2)+':00'+'~'+subString(M2_HOR,1,2)+':59' as 'hora',
M2_CXA as 'caixa',
M2_OPE as 'operador',
count(*) as 'clientes',
SUM(M2_VAL - M2_ABT - M2_DESCUP + M2_ACRCUP ) as 'valor'

FROM #MSL002 (nolock)

WHERE 
M2_CXA in(@caixa)

GROUP BY
M2_DAT,
subString(M2_HOR,1,2),
M2_CXA,
M2_OPE
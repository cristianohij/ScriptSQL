SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--
--estoque nd, loja nd, compras nd; estoque tt, loja tt, compras tt; estoque cd, loja cd, compras cd;
--estoque py, loja py, compras py; estoque bb, loja bb, compras bb; estoque mi, loja mi, compras mi


ALTER procedure [dbo].[SP_WYEST087] ( @empresa int output, @codigoProduto varchar(20) output, 
@estoqueNd decimal(10,4) output, @lojaNd decimal(10,4) output, @comprasNd decimal(10,4) output,
@estoqueTt decimal(10,4) output, @lojaTt decimal(10,4) output, @comprasTt decimal(10,4) output,
@estoqueCd decimal(10,4) output, @lojaCd decimal(10,4) output, @comprasCd decimal(10,4) output,
@estoquePy decimal(10,4) output, @lojaPy decimal(10,4) output, @comprasPy decimal(10,4) output,
@estoqueBb decimal(10,4) output, @lojaBb decimal(10,4) output, @comprasBb decimal(10,4) output,
@estoqueMi decimal(10,4) output, @lojaMi decimal(10,4) output, @comprasMi decimal(10,4) output,
@estoqueWp decimal(10,4) output, @lojaWp decimal(10,4) output, @comprasWp decimal(10,4) output
)

as 

begin 

	set nocount on;
	
	declare 
	@verificaLink int, @serverNd varchar(15), @serverTt varchar(15), @serverCd varchar(15), @serverPy varchar(15), @serverBb varchar(15), @serverMi varchar(15),
    @serverWp varchar(15), @comandoSql varchar(4000), @sqlVerificaTabela varchar(100)
		
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- Pegar os ips de cada servidor, pelo sys.servers
	set @serverNd = (select top 1 data_source from sys.servers where name = 'nd' order by name)
	set @serverTt = (select top 1 data_source from sys.servers where name = 'tt' order by name)
	set @serverCd = (select top 1 data_source from sys.servers where name = 'cd' order by name)
	set @serverPy = (select top 1 data_source from sys.servers where name = 'py' order by name)
	set @serverBb = (select top 1 data_source from sys.servers where name = 'bb2' order by name)
	set @serverMi = (select top 1 data_source from sys.servers where name = 'mi' order by name)
    set @serverWp = (select top 1 data_source from sys.servers where name = 'wp' order by name)
	
	-- select @serverNd, @serverTt, @serverCd, @serverPy, @serverBb, @serverMi
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- Tabela temp para obter o resultado do select nas empresas
	
	if object_id('tempdb.dbo.#Saldo') is not null 
	begin 
		drop table #Saldo
	end	
	
	create table #Saldo (estoque decimal(10,4), loja decimal(10,4), compras decimal(10,4))	
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- Verificar empresa por empresa, buscando tbm se a TBS032 é compartilhada ou exclusiva	
	
	-- nd 	
	
	exec VerificaLink3 @serverNd, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.1.205'';''integros'';''int3gro5@15387'','' select TBSMOD from SIBD.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.1.205'''';''''integros'''';''''int3gro5@15387'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 2 order by PROEMPCOD, PROCOD ) as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueNd = estoque, @lojaNd = loja, @comprasNd = compras from #Saldo
	
	delete #Saldo
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- tt 	
	
	exec VerificaLink3 @serverTt, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.3.205'';''si'';''123'','' select TBSMOD from SIBD.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.3.205'''';''''si'''';''''123'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 2 order by PROEMPCOD, PROCOD ) as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueTt = estoque, @lojaTt = loja, @comprasTt = compras from #Saldo
	
	delete #Saldo		
		
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- cd 	
	
	exec VerificaLink3 @serverCd, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.10.7'';''si'';''123'','' select TBSMOD from SIBD.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.10.7'''';''''integros'''';''''int3gro5@15387'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		0 as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueCd = estoque, @lojaCd = loja, @comprasCd = compras from #Saldo
	
	delete #Saldo	
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- py 	
	
	exec VerificaLink3 @serverPy, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.0.7'';''si'';''123'','' select TBSMOD from SIBD.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.0.7'''';''''si'''';''''123'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		0 as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoquePy = estoque, @lojaPy = loja, @comprasPy = compras from #Saldo
	
	delete #Saldo	
	
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- bb 	
	
	exec VerificaLink3 @serverBb, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.0.3'';''si'';''123'','' select TBSMOD from SIBD2.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.0.3'''';''''si'''';''''123'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD2.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD2.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 2 order by PROEMPCOD, PROCOD ) as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD2.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueBb = estoque, @lojaBb = loja, @comprasBb = compras from #Saldo
	
	delete #Saldo		
		
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- mi 	
	
	exec VerificaLink3 @serverMi, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.0.7'';''si'';''123'','' select TBSMOD from SIBD3.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.0.7'''';''''si'''';''''123'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD3.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD3.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 2 order by PROEMPCOD, PROCOD ) as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD3.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueMi = estoque, @lojaMi = loja, @comprasMi = compras from #Saldo
	
	delete #Saldo		
		
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- wp 	
	
	exec VerificaLink3 @serverWp, @verificaLink output	
	
	if @verificaLink = 1
	
	begin 
		set @comandoSql = '
		declare @empresaTBS032 int, @comando varchar(1000), @produto varchar(15)
		set @produto = ''' + @codigoProduto + '''
		select
		@empresaTBS032 = case when S.TBSMOD = ''C'' then 0 else ' + ltrim(str(@empresa)) +' end  from openrowset(''SQLNCLI'',''192.168.0.7'';''integros'';''int3gro5@15387'','' select TBSMOD from SIBD4.dbo.TBS024 A (nolock) where 
		TBSNOM = ''''TBS032'''' order by TBSNOM '') as S
		set @comando = ''select estoque, loja,compras
		from openrowset(''''SQLNCLI'''',''''192.168.0.7'''';''''integros'''';''''int3gro5@15387'''',''''
		select  
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD4.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 1 order by PROEMPCOD, PROCOD ) as estoque,
		(select top 1 ESTQTDATU - ESTQTDRES from SIBD4.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' and ESTLOC = 2 order by PROEMPCOD, PROCOD ) as loja, 
		(select top 1 sum(ESTQTDCMP) from SIBD4.dbo.TBS032 where PROEMPCOD = ''+ ltrim(str(@empresaTBS032)) +'' and PROCOD = '' + @produto + '' group by PROEMPCOD, PROCOD order by PROEMPCOD, PROCOD ) as compras '''') as S ''	
		exec(@comando)
		'
	end 
	
	else 
	begin 
		set @comandoSql = 'select -9999, -9999, -9999'
	end
	
	insert into #Saldo
	exec(@comandoSql)
	
	select @estoqueWp = estoque, @lojaWp = loja, @comprasWp = compras from #Saldo
	
	delete #Saldo		
		
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	return
	
end
GO

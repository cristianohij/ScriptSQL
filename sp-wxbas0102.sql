-- sp_WXBAS0102

USE [SIBD]
GO
/****** Object:  StoredProcedure [dbo].[sp_WXBAS0102]    Script Date: 18/01/2023 14:08:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_WXBAS0102] ( @empresa int, @registro int, @status varchar(10), @codigoProduto varchar(20), @descricao varchar(60), @codigoMarca int, @nomeMarca varchar(60),
@localEstoque int, @tabelaPreco int, @somenteSaldoDisponivel char(1) )

as 

begin 

	set nocount on;

	-- Verificar se a tabela é compartilhada ou exclusiva
	
	declare @empresaTBS010 int, @empresaTBS032 int, @empresaTBS014 int, @empresaTBS031 int, @empresaTMP020 int
	
	exec dbo.sp_GetCodigoEmpresaTabela @empresa, 'TBS010', @codigoEmpresa = @empresaTBS010 output;
	exec dbo.sp_GetCodigoEmpresaTabela @empresa, 'TBS032', @codigoEmpresa = @empresaTBS032 output;	
	exec dbo.sp_GetCodigoEmpresaTabela @empresa, 'TBS014', @codigoEmpresa = @empresaTBS014 output;	
	exec dbo.sp_GetCodigoEmpresaTabela @empresa, 'TBS031', @codigoEmpresa = @empresaTBS031 output;	
	exec dbo.sp_GetCodigoEmpresaTabela @empresa, 'TMP020', @codigoEmpresa = @empresaTMP020 output;	
	
	---------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- Apagar os registros antes de inserir novos. Para o caso do F5 quando mesmo usuariio.
	
	-- delete TMP020 (nolock) where T20_EMPRESA = @empresaTMP020 and T20_REGISTRO = @registro
	
	---------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- Verifica se os filtros: codigo, descricao, codigoMarca e nomeMarca se algum está preenchido, se todos estiverem vazio não insere nenhum registro 
	
	/*if rtrim(ltrim(@codigoProduto)) = '' and rtrim(ltrim(@descricao)) = '' and rtrim(ltrim(@nomeMarca)) = '' and @codigoMarca = 0
	begin 
		return;
	end 
	
	else */
	begin 
		
		-- Cria a tabela de status 
		
		if object_id('tempdb.dbo.#Status') is not null 
		begin 
			drop table #Status
		end
		
		create table #Status (status char(1))
	
		declare @qtdCaracter int, @i int
		set @qtdCaracter = len(@status)
		set @i = 1
		
		while @i <= @qtdCaracter
		begin 
			insert into #Status values ( upper(substring(@status, @i, 1)) )
			set @i += 1
		end 
			
		-- select * from #Status
		
		---------------------------------------------------------------------------------------------------------------------------------------------------
	
		-- Filtrar os produtos na TBS010, se não existe produto na TBS010 não tem porque existe nas outras
		
		if object_id('tempdb.dbo.#Produtos') is not null 
		begin 
			drop table #Produtos
		end 
		
		select 
		A.PROEMPCOD as empresa,
		A.PROCOD as codigo,
		A.PROSTATUS as status,
		A.PRODES as descricao,
		A.PROLOCFIS as localizacao,
		A.MARCOD as codigoMarca,
		A.MARNOM as nomeMarca,
		A.PROUM1 as unidade1,
		A.PROUM1QTD as embalagem1,
		A.PROUM2 as unidade2,
		A.PROUM2QTD as embalagem2,
		A.PROREFFOR as referenciaFornecedor,
		A.FORCOD as codigoFornecedor,
		A.FORNOM as nomeFornecedor
		
		into #Produtos
		from TBS010 A (nolock)
		
		where 
		A.PROEMPCOD = @empresaTBS010 and 
		A.PROSTATUS collate database_default in ( select * from #Status ) and 
		A.PROCOD = case when @codigoProduto = '' then A.PROCOD else @codigoProduto end and 
		A.PRODES like( case when @descricao = '' then A.PRODES else upper(@descricao) + '%' end ) and 
		A.MAREMPCOD = @empresaTBS014 and 
		A.MARCOD = case when @codigoMarca = 0 then A.MARCOD else @codigoMarca end and 
		A.MARNOM like( case when @nomeMarca = '' then A.MARNOM else upper(@nomeMarca) + '%' end )
				
		order by 
		A.PROEMPCOD,
		A.PROSTATUS, 
		A.PROCOD,
		A.PRODES, 
		A.MAREMPCOD,
		A.MARCOD, 
		A.MARNOM	
	
		-- select * from #Produtos
		
		---------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- Saldo dos produtos 
		
		if object_id('tempdb.dbo.#SaldoProdutos') is not null 
		begin 
			drop table #SaldoProdutos
		end 
		
		select 
		A.PROCOD as codigo, 
		A.ESTQTDATU - A.ESTQTDRES as disponivel,
		A.ESTQTDATU as atual, 
		A.ESTQTDRES as reservado,
		A.ESTQTDPEN as pendencia,
		A.ESTQTDCMP as compra
		
		into #SaldoProdutos
		from TBS032 A (nolock) 
		
		where
		A.PROEMPCOD = @empresaTBS032 and 
		A.ESTLOC = @localEstoque and 
		A.PROCOD in (select codigo from #Produtos) and 
		A.ESTQTDATU - A.ESTQTDRES > case when upper(@somenteSaldoDisponivel) = 'S' then 0 else -9999999 end 
		
		order by 
		A.PROEMPCOD, 
		A.ESTLOC, 
		A.PROCOD
		
		-- select * from #SaldoProdutos
		
		---------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- preco unitatrio, preco 2 unidade	
		/*
		TDPPROCOR as temPromocaoCorporativo,
		TDPPROLOJ as temPromocaoLoja,
		TDPPROREV as temPromocaoRevenda,
		TDPPROWE1 as temPromocaoWeb1,
		TDPPROWE2 as temPromocaoWeb2,
			
		TDPPRECOR1 as precoCorporativo1,
		TDPPRECOR2 as precoCorporativo2,	
		
		TDPCUSBAS as precoCusto,
		
		TDPPRELOJ1 as precoLoja1,
		TDPPRELOJ2 as precoLoja2,
		
		TDPPREREV1 as precoRevenda1,
		TDPPREREV2 as precoRevenda2,
		
		TDPPREWE11 as precoWeb11,
		TDPPREWE12 as precoWeb12,
		
		TDPPREWE21 as precoWeb21,
		TDPPREWE22 as precoWeb22	*/
		
		
		-- Preços atualizados dos produtos 
		
		if object_id('tempdb.dbo.#PrecosAtualizados') is not null 
		begin 
			drop table #PrecosAtualizados
		end
		
		select  
		TDPPROCOD as codigo,
		
		case when @tabelaPreco = 1 -- Corporativo
			then case when TDPPROCOR = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO1 else TDPPRECOR1 end 
			else 
				case when @tabelaPreco = 2 -- Custo
					then TDPCUSBAS
					else 
						case when @tabelaPreco = 3 -- Loja
							then case when TDPPROLOJ = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO1 else TDPPRELOJ1 end 
							else 
								case when @tabelaPreco = 4 -- Revenda
									then case when TDPPROREV = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO1 else TDPPREREV1 end 
									else 
										case when @tabelaPreco = 5 -- Web1 
											then case when TDPPROWE1 = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO1 else TDPPREWE11 end 
											else 
												case when @tabelaPreco = 6 -- Web2
													then case when TDPPROWE2 = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO1 else TDPPREWE21 end 
													else 0
												end
										end
								end 
						end 
				end 
		end as preco1,
		
		case when @tabelaPreco = 1 -- Corporativo
			then case when TDPPROCOR = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO2 else TDPPRECOR2 end 
			else 
				case when @tabelaPreco = 2 -- Custo
					then TDPCUSBAS
					else 
						case when @tabelaPreco = 3 -- Loja
							then case when TDPPROLOJ = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO2 else TDPPRELOJ2 end 
							else 
								case when @tabelaPreco = 4 -- Revenda
									then case when TDPPROREV = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO2 else TDPPREREV2 end 
									else 
										case when @tabelaPreco = 5 -- Web1 
											then case when TDPPROWE1 = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO2 else TDPPREWE12 end 
											else 
												case when @tabelaPreco = 6 -- Web2
													then case when TDPPROWE2 = 'S' and TDPVALPROI <= getdate() and TDPVALPROF >= getdate() then TDPPREPRO2 else TDPPREWE22 end 
													else 0
												end
										end
								end 
						end 
				end 
		end as preco2
	
		
		into #PrecosAtualizados
		from TBS031 (nolock)
		
		where 
		TDPEMPCOD = @empresaTBS031 and 
		TDPPROCOD in (select codigo from #Produtos)
		
		order by 
		TDPEMPCOD, 
		TDPPROCOD
		
		-- select * from #PrecosAtualizados
		
		---------------------------------------------------------------------------------------------------------------------------------------------------
		
		-- Tabela final
	
		insert into TMP020	
		
		select 
		
		isnull(@empresaTMP020,0) as T20_EMPRESA,
		@registro as T20_REGISTRO,
		a.empresa as T20_PROEMPCOD,
		a.codigo as T20_PROCOD,
		a.status as T20_PROSTATUS,
		a.descricao as T20_PRODES,
		a.codigoMarca as T20_MARCOD,
		a.nomeMarca as T20_MARNOM,
		a.unidade1 as T20_PROUM1,
		a.embalagem1 as T20_PROUM1QTD,
		isnull(c.preco1, 0) as T20_PREUM1,
		a.unidade2 as T20_PROUM2,
		a.embalagem2 as T20_PROUM2QTD,
		isnull(c.preco2, 0) * a.embalagem2 as T20_PREUM2,
		isnull(b.atual, 0) as T20_ESTQTDATU,
		isnull(b.reservado, 0) as T20_ESTQTDRES,
		isnull(b.pendencia, 0) as T20_ESTQTDPEN,
		isnull(b.compra, 0) as T20_ESTQTDCMP,
		a.referenciaFornecedor as T20_PROREFFOR,
		localizacao as T20_PROLOCFIS,
		a.codigoFornecedor as T20_FORCOD,
		a.nomeFornecedor as T20_FORNOM,
		isnull(disponivel,0) as T20_ESTQTDDIS
		
		from #Produtos a (nolock)
		left join #SaldoProdutos b (nolock) on a.codigo = b.codigo
		left join #PrecosAtualizados c (nolock) on a.codigo = c.codigo
		
		where 
		isnull(disponivel,0) > case when upper(@somenteSaldoDisponivel) = 'S' then 0 else -9999999 end 
		
		order by 
		a.codigo
	
	end
	
end
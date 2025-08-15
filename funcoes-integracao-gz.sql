-- functions

-------------------------------------------------------------------------------
-- retorna uma string de inser��o de dados do produto na tabela "estoque" do GZ


execute('select * from tributa;') at MYSQLGZ

drop function StringInsertProdutoGZ
go

create function StringInsertProdutoGZ(@empresa int, @produto varchar(15))
returns varchar(1000) as
begin
	declare @string varchar(1000)

	-- se produto sem pre�o para venda
	if isnull((select preco1 from PrecoLoja(@empresa,@produto)),0) = 0
		return ''

	-- se produto sem c�digo da tributa��o GZ
	if isnull((select 1 from TBS010 with (nolock) where PROEMPCOD=@empresa and PROCOD=@produto and TGZCOD > 0),0) = 0
		return ''

	--set @string = ( select rtrim(PROCOD) + ',' -- 01 C�digo Interno do Produto (PLU)
	--					   + '''''' + Left(rtrim(PRODES),40) + ''''',' -- 03 Descri��o Completa
	--					   + '''''' + Left(rtrim(PRODES),24) + ''''',' -- 04 Descri��o Resumida para o PDV
	--					   + '''''N'''',' -- 05 F�rmula
	--					   + '''''' + PROUM1 + ''''',' -- 06 Unidade de Refer�ncia
	--					   + Ltrim(str(isnull((select preco1 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0),10,3)) + ',' -- 09 Pre�o de Venda Padr�o
	--					   + '''''A'''',' -- 12 Desconto Padr�o
	--					   + '''''' + iif(PROPESAVEL='S','S','N') + ''''','  -- 13 Quantidade Vari�vel / Produto Pesado ?
	--					   + '''''N'''','  -- 14 Altera Pre�o de Venda no PDV ?
	--					   + '''''N'''','  -- 15 Bloqueia Multiplicador ?
	--					   + Ltrim(str(TGZCOD,2)) + ','  -- 17 C�digo da Tributa��o
	--					   + Ltrim(str(PROUM1QTD,8,3)) + ','  -- 19 Quantidade por Embalagem
	--					   + '''''N'''','  -- 20 Vende Somente Embalagem Fechada ?
	--					   + '''''N'''','  -- 22 Pede Descri��o Complementar ?
	--					   + '''''' + iif(PROPESAVEL='S','N','S') + ''''','  -- 25 Bloqueia Venda Fracionada ?
	--					   + '''''' + PROSTBA + PROSTBB + ''''','  -- 27 Situa��o Tribut�ria
	--					   + '''''A'''','  -- 28 Estado do Produto
	--					   + Ltrim(str(PROUM2QTD,8,3)) + ','  -- 32 Quantidade por Embalagem (Atacado)
	--					   + '''''' + iif(PROPESAVEL='S','N','S') + ''''','  -- 33 Vende S� Embal. Fechada ? (Atacado)
	--					   + '''''' + iif(Len(PROCLAFIS)=8,PROCLAFIS,'') + ''''','  -- 35 Classifica��o Fiscal
	--					   + '''''' + iif(PROPESAVEL='S','N','S') + ''''','  -- 40 Vende S� Embal. Fechada ? (Especial)
	--					   --+ Ltrim(str(GRUCOD,6))  -- 44 Grupo
	--					   --+ Ltrim(str(MARCOD,6))  -- 46 Marcao
	--					   + '''''N'''','  -- 56 Bloqueador de Venda
	--					   + '''''N'''','  -- 62 Solicita Senha para Libera��o de Venda
	--					   + '''''T'''','  -- 64 Indicador de Produ��o Pr�pria ou de Terceiro
	--					   + '''''A'''','  -- 65 Indicador de Arredondamento ou Truncamento
	--					   + '''''' + convert(char(10),getdate(),23) + ''''','  -- ultatu
	--					   + '0,' -- 67 Tipo do Produto
	--					   + Ltrim(str(isnull((select iif(TBS010.PROSTBA in('0','3','4','5'),NCMALINAC,NCMALIIMP)
	--											 from TBS092 with (nolock)
	--											where NCMEX=''
	--												  and NCMCOD=TBS010.PROCLAFIS),0),8,2)) + ','  -- 68 Carga Tribut�ria Federal
	--					   + '''''' + (select iif(EMPCRT=1,TBS010.PROSTBA+PROCSN,'')
	--									 from TBS023 with (nolock) 
	--									where EMPCOD=1) + ''''','  -- 69 CSOSN
	--					   + '''''N'''','  -- 70 Entreg�vel
	--					   + '''''' + rtrim(isnull((select NCMCHV
	--												  from TBS092 with (nolock)
	--												 where NCMEX=''
	--													   and NCMCOD=TBS010.PROCLAFIS),'')) + ''''','   -- 72 Chave Tabela IBPT
	--					   + '''''' + Ltrim(isnull((select cstpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),'')) + ''''','  -- 73 CST do PIS
	--					   + Ltrim(str(isnull((select aliqpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0),9,2)) + ','  -- 74 Al�quota do PIS
	--					   + '''''' + Ltrim(isnull((select cstcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),'')) + ''''','  -- 75 CST do COFINS
	--					   + Ltrim(str(isnull((select aliqcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0),9,2)) + ','  -- 76 Al�quota do COFINS
	--					   + '''''' + iif(Len(PROCEST)=7,PROCEST,'') + ''''','  -- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria
	--					   + Ltrim(str(isnull((select custo from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0),10,3))  -- 80 Pre�o de Custo

	set @string = ( select rtrim(PROCOD) + ',' -- 01 C�digo Interno do Produto (PLU)
						   + '''' + Left(rtrim(PRODES),40) + ''',' -- 03 Descri��o Completa
						   + '''' + Left(rtrim(PRODES),24) + ''',' -- 04 Descri��o Resumida para o PDV
						   + '''N'',' -- 05 F�rmula
						   + '''' + PROUM1 + ''',' -- 06 Unidade de Refer�ncia
						   + Ltrim(str(isnull((select preco1 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0),10,3)) + ',' -- 09 Pre�o de Venda Padr�o
						   + '''A'',' -- 12 Desconto Padr�o
						   + '''' + iif(PROPESAVEL='S','S','N') + ''','  -- 13 Quantidade Vari�vel / Produto Pesado ?
						   + '''N'','  -- 14 Altera Pre�o de Venda no PDV ?
						   + '''N'','  -- 15 Bloqueia Multiplicador ?
						   + Ltrim(str(TGZCOD,2)) + ','  -- 17 C�digo da Tributa��o
						   + Ltrim(str(PROUM1QTD,8,3)) + ','  -- 19 Quantidade por Embalagem
						   + '''N'','  -- 20 Vende Somente Embalagem Fechada ?
						   + '''N'','  -- 22 Pede Descri��o Complementar ?
						   + '''' + iif(PROPESAVEL='S','N','S') + ''','  -- 25 Bloqueia Venda Fracionada ?
						   + '''' + PROSTBA + PROSTBB + ''','  -- 27 Situa��o Tribut�ria
						   + '''A'','  -- 28 Estado do Produto
						   + Ltrim(str(PROUM2QTD,8,3)) + ','  -- 32 Quantidade por Embalagem (Atacado)
						   + '''' + iif(PROPESAVEL='S','N','S') + ''','  -- 33 Vende S� Embal. Fechada ? (Atacado)
						   + '''' + iif(Len(PROCLAFIS)=8,PROCLAFIS,'') + ''','  -- 35 Classifica��o Fiscal
						   + '''' + iif(PROPESAVEL='S','N','S') + ''','  -- 40 Vende S� Embal. Fechada ? (Especial)
						   --+ Ltrim(str(GRUCOD,6))  -- 44 Grupo
						   --+ Ltrim(str(MARCOD,6))  -- 46 Marcao
						   + '''N'','  -- 56 Bloqueador de Venda
						   + '''N'','  -- 62 Solicita Senha para Libera��o de Venda
						   + '''T'','  -- 64 Indicador de Produ��o Pr�pria ou de Terceiro
						   + '''A'','  -- 65 Indicador de Arredondamento ou Truncamento
						   + '''' + convert(char(10),getdate(),23) + ''','  -- ultatu
						   + '0,' -- 67 Tipo do Produto
						   + Ltrim(str(isnull((select iif(TBS010.PROSTBA in('0','3','4','5'),NCMALINAC,NCMALIIMP)
												 from TBS092 with (nolock)
												where NCMEX=''
													  and NCMCOD=TBS010.PROCLAFIS),0),8,2)) + ','  -- 68 Carga Tribut�ria Federal
						   + '''' + (select iif(EMPCRT=1,TBS010.PROSTBA+PROCSN,'')
										 from TBS023 with (nolock) 
										where EMPCOD=1) + ''','  -- 69 CSOSN
						   + '''N'','  -- 70 Entreg�vel
						   + '''' + rtrim(isnull((select NCMCHV
													  from TBS092 with (nolock)
													 where NCMEX=''
														   and NCMCOD=TBS010.PROCLAFIS),'')) + ''','   -- 72 Chave Tabela IBPT
						   + '''' + Ltrim(isnull((select cstpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),'')) + ''','  -- 73 CST do PIS
						   + Ltrim(str(isnull((select aliqpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0),9,2)) + ','  -- 74 Al�quota do PIS
						   + '''' + Ltrim(isnull((select cstcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),'')) + ''','  -- 75 CST do COFINS
						   + Ltrim(str(isnull((select aliqcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0),9,2)) + ','  -- 76 Al�quota do COFINS
						   + '''' + iif(Len(PROCEST)=7,PROCEST,'') + ''','  -- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria
						   + Ltrim(str(isnull((select custo from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0),10,3))  -- 80 Pre�o de Custo

					  from TBS010 with (nolock)
					 where PROEMPCOD=@empresa
						   and PROCOD=@produto
						   and isnull((select preco1 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
				  )

	return @string
end
go

-- exemplo de uso
print dbo.StringInsertProdutoGZ(0, '0090663')
select dbo.StringInsertProdutoGZ(0, '0040001') as stringProduto

-- exemplo de uso
declare @s varchar(1000)
execute @s=dbo.StringInsertProdutoGZ 0, '1640'
print @s



--------------------------------------------------------------------
-- retorna uma tabela de strings para inser��o dos c�digos de barras

drop function TableInsertBarrasGZ
go 

create function TableInsertBarrasGZ(@empresa int, @produto varchar(15))
returns @barras table (stringInsert varchar(200)) --(codigo varchar(15), barras varchar(20), embalagem smallmoney, preco smallmoney)
begin
	insert into @barras
	select rtrim(codigo) + ','  -- 1 C�digo do Produto Principal (PLU)
		   + rtrim(barras) + ','  -- 2 C�digo de Barras do Produto
		   + Ltrim(str(embalagem,9,3)) + ','  -- 4 M�ltiplos
		   + Ltrim(str(preco,9,3))  -- 5 Pre�o de Venda
	  from
	  (
		-- unidade 1
		select CBPPROCOD codigo
			   ,CBPCODBAR barras
			   ,CBPQTDEMB embalagem
			   ,0 preco
		  from TBS0103 with (nolock)
		 where CBPEMP=@empresa
			   and CBPPROCOD=@produto
			   and CBPQTDEMB=1
		union

		-- unidade 2
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
			   on TBS010.PROEMPCOD=TBS0103.CBPEMP 
			   and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPPROCOD=@produto
			   and TBS0103.CBPQTDEMB=TBS010.PROUM2QTD
			   and isnull((select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM2QTD not in(1,TBS010.PROUM3QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'2222'
			   ,PROUM2QTD
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROCOD=@produto
			   and PROUM2QTD > 1
			   and isnull((select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
		union

		-- unidade 3
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPPROCOD=@produto
			   and TBS0103.CBPQTDEMB=TBS010.PROUM3QTD
			   and isnull((select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM3QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'3333'
			   ,PROUM3QTD
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROCOD=@produto
			   and PROUM3QTD > 1
			   and isnull((select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
		union

		-- unidade 4
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPPROCOD=@produto
			   and TBS0103.CBPQTDEMB=TBS010.PROUM4QTD
			   and isnull((select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM4QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM3QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'4444'
			   ,PROUM4QTD
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROCOD=@produto
			   and PROUM4QTD > 1
			   and isnull((select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
	  ) tab

	return
end
go

-- exemplo de uso
select *
  from dbo.TableInsertBarrasGZ(0, '1640054')


--------------------------------------------------------------------
-- retorna uma tabela de strings para inser��o dos c�digos de barras - nova vers�o

drop index ITBS010BARRAS on TBS010

drop index ITBS010GZ2 on TBS010

CREATE NONCLUSTERED INDEX [ITBS010GZ2]
ON [dbo].[TBS010] ([PROEMPCOD],[PROUM3QTD])
INCLUDE ([PROCOD],[PROUM2QTD],[PROUM4QTD])
GO

CREATE NONCLUSTERED INDEX [ITBS010GZ3]
ON [dbo].[TBS010] ([PROEMPCOD],[PROUM3QTD])
INCLUDE ([PROCOD])
GO

CREATE NONCLUSTERED INDEX [ITBS010GZ4]
ON [dbo].[TBS010] ([PROEMPCOD],[PROUM4QTD])
INCLUDE ([PROCOD])
GO

drop function TabelaCodigosBarrasGZ	--TableInsertBarrasGZNova
go 

create function TabelaCodigosBarrasGZ(@empresa int)
returns @barras table (codigo varchar(15), barras varchar(20), embalagem smallmoney, preco smallmoney)
begin
	insert into @barras
	select rtrim(codigo) as codigo --+ ','  -- 1 C�digo do Produto Principal (PLU)
		   ,rtrim(barras) as barras --+ ','  -- 2 C�digo de Barras do Produto
		   ,Ltrim(str(embalagem,9,3)) as embalagem --+ ','  -- 4 M�ltiplos
		   ,Ltrim(str(preco,9,3)) as preco  -- 5 Pre�o de Venda
	  from
	  (
		-- unidade 1
		select CBPPROCOD codigo
			   ,CBPCODBAR barras
			   ,CBPQTDEMB embalagem
			   ,0 preco
		  from TBS0103 with (nolock)
		 where CBPEMP=@empresa
			   and CBPQTDEMB=1
			   and isnull((select preco1 from PrecoLoja(TBS0103.CBPEMP,TBS0103.CBPPROCOD)),0) > 0
		union

		-- unidade 2
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
			   on TBS010.PROEMPCOD=TBS0103.CBPEMP 
			   and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM2QTD
			   and TBS010.PROUM2QTD not in(1,TBS010.PROUM3QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'2222'
			   ,PROUM2QTD
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM2QTD > 1
		union

		-- unidade 3
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM3QTD
			   and TBS010.PROUM3QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'3333'
			   ,PROUM3QTD
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM3QTD > 1
		union

		-- unidade 4
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where TBS0103.CBPEMP=@empresa
			   and TBS0103.CBPQTDEMB=TBS010.PROUM4QTD
			   and TBS010.PROUM4QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM3QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'4444'
			   ,PROUM4QTD
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=@empresa
			   and PROUM4QTD > 1
	  ) tab
	 where embalagem=1 or (embalagem > 1 and preco > 0)

	return
end
go

-- exemplo de uso
select *
  from dbo.TabelaCodigosBarrasGZ(0)

drop table barras

select distinct codigo
  into barras
  from dbo.TableCodigosBarrasGZ(0)


-- outra vers�o

drop view DWCodigosBarrasGZ
go

create view DWCodigosBarrasGZ as
with tab as
(select CBPEMP as empresa
        ,CBPPROCOD as codigo
   from TBS0103 with (nolock)
	    Left join TBS010 with (nolock)
	    on TBS010.PROEMPCOD=TBS0103.CBPEMP 
	    and TBS010.PROCOD=TBS0103.CBPPROCOD
  --where MARCOD=847
		--and CBPDATALT between '17530101' and '20200525'
  group by CBPEMP, CBPPROCOD)

--select * from tab

		-- unidade 1
		select CBPPROCOD codigo
			   ,CBPCODBAR barras
			   ,CBPQTDEMB embalagem
			   ,0 preco
		  from TBS0103 with (nolock)
		 where CBPEMP=0
			   and CBPPROCOD in(select codigo from tab)
			   and CBPQTDEMB=1
		union

		-- unidade 2
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
			   on TBS010.PROEMPCOD=TBS0103.CBPEMP 
			   and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where CBPEMP=0
			   and CBPPROCOD in(select codigo from tab)
			   and TBS0103.CBPQTDEMB=TBS010.PROUM2QTD
			   and isnull((select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM2QTD not in(1,TBS010.PROUM3QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'2222'
			   ,PROUM2QTD
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=0
			   and PROCOD in(select codigo from tab)
			   and PROUM2QTD > 1
			   and isnull((select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
		union

		-- unidade 3
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where CBPEMP=0
			   and CBPPROCOD in(select codigo from tab)
			   and TBS0103.CBPQTDEMB=TBS010.PROUM3QTD
			   and isnull((select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM3QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM4QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'3333'
			   ,PROUM3QTD
			   ,(select preco2 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=0
			   and PROCOD in(select codigo from tab)
			   and PROUM3QTD > 1
			   and isnull((select preco3 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
		union

		-- unidade 4
		select CBPPROCOD
			   ,CBPCODBAR
			   ,CBPQTDEMB
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS0103 with (nolock)
			   inner join TBS010 with (nolock)
				  on TBS010.PROEMPCOD=TBS0103.CBPEMP 
					 and TBS010.PROCOD=TBS0103.CBPPROCOD
		 where CBPEMP=0
			   and CBPPROCOD in(select codigo from tab)
			   and TBS0103.CBPQTDEMB=TBS010.PROUM4QTD
			   and isnull((select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0
			   and TBS010.PROUM4QTD not in(1,TBS010.PROUM2QTD,TBS010.PROUM3QTD)
		union

		select PROCOD
			   ,rtrim(PROCOD)+'4444'
			   ,PROUM4QTD
			   ,(select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD))
		  from TBS010 with (nolock)
		 where PROEMPCOD=0
			   and PROCOD in(select codigo from tab)
			   and PROUM4QTD > 1
			   and isnull((select preco4 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0) > 0

select *
  from DWCodigosBarrasGZ
 where codigo='1640054'

select distinct codigo
  from DWCodigosBarrasGZ



------------------------------------------------------
-- retorna uma tabela dos pre�os de loja de um produto

drop function PrecoLoja
go

create function PrecoLoja(@empresa int, @produto varchar(15))
returns @dados table(codigo varchar(15), preco1 smallmoney, preco2 smallmoney, preco3 smallmoney, preco4 smallmoney, custo smallmoney, atualizado datetime) as
begin
	declare @vali date, @valf date, @ativada char(1), @datatual date

	select @vali='17530101', @valf='17530101', @datatual=getdate()

	--return 
	select @vali=TDPVALPROI
		   ,@valf=TDPVALPROF
		   ,@ativada=TDPPROLOJ
	  from TBS031 with (nolock)
	 where TDPEMPCOD=@empresa
		   and TDPPROCOD=@produto

	if (@vali <= @datatual and @datatual <= @valf and @ativada='S')
		insert into @dados
		-- pre�os da promo��o
		select TDPPROCOD
			   ,TDPPREPRO1
			   ,TDPPREPRO2
			   ,TDPPREPRO3
			   ,TDPPREPRO4
			   ,TDPCUSBAS
			   ,TDPDATATU
		  from TBS031 with (nolock)
		 where TDPEMPCOD=@empresa
			   and TDPPROCOD=@produto
	else
		insert into @dados
		-- pre�os normais
		select TDPPROCOD
			   ,TDPPRELOJ1
			   ,TDPPRELOJ2
			   ,TDPPRELOJ3
			   ,TDPPRELOJ4
			   ,TDPCUSBAS
			   ,TDPDATATU
		  from TBS031 with (nolock)
		 where TDPEMPCOD=@empresa
			   and TDPPROCOD=@produto

	return
end
go

-- exemplo de uso
select * 
  from PrecoLoja(0,'1640054')


------------------------------------------------------
-- retorna uma tabela dos pre�os de loja de todos os produtos

CREATE NONCLUSTERED INDEX [ITBS031GZ]
ON [dbo].[TBS031] ([TDPEMPCOD],[TDPPROLOJ],[TDPVALPROI],[TDPVALPROF])
INCLUDE ([TDPPROCOD],[TDPCUSBAS],[TDPPREPRO1],[TDPPREPRO2],[TDPPREPRO3],[TDPPREPRO4])
GO

drop function PrecoLojaGeral
go

create function PrecoLojaGeral(@empresa int)
returns @dados table(codigo varchar(15), preco1 smallmoney, preco2 smallmoney, preco3 smallmoney, preco4 smallmoney, custo smallmoney, atualizado date) as
begin
	declare @vali date, @valf date, @ativada char(1), @datatual date
	
	declare @tab table(codigo varchar(15)) 

	select @vali='17530101', @valf='17530101', @datatual=getdate()


	insert into @dados

	-- pre�os da promo��o
	select TDPPROCOD
		   ,TDPPREPRO1
		   ,TDPPREPRO2
		   ,TDPPREPRO3
		   ,TDPPREPRO4
		   ,TDPCUSBAS
		   ,convert(date,TDPDATATU)
	  from SIBD.dbo.TBS031 with (nolock)
	 where TDPEMPCOD=@empresa
	       and TDPPREPRO1+TDPPREPRO2+TDPPREPRO3+TDPPREPRO4+TDPCUSBAS > 0
	       and @datatual between TDPVALPROI and TDPVALPROF
		   and TDPPROLOJ='S'

	insert into @dados
	-- pre�os normais
	select TDPPROCOD
		   ,TDPPRELOJ1
		   ,TDPPRELOJ2
		   ,TDPPRELOJ3
		   ,TDPPRELOJ4
		   ,TDPCUSBAS
		   ,convert(date,TDPDATATU)
	  from SIBD.dbo.TBS031 with (nolock)
	 where TDPEMPCOD=@empresa
	       and TDPPREPRO1+TDPPREPRO2+TDPPREPRO3+TDPPREPRO4+TDPCUSBAS > 0
	       and not exists(select ''
		                    from @dados
						   where codigo=TDPPROCOD)
	return
end
go

-- exemplo de uso

drop table #precos

select *
  --into #precos
  from PrecoLojaGeral(0)
 --where preco1+preco2+preco3+preco4+custo = 0

select codigo
       ,count(*)
  from #precos
 group by codigo
having count(*) > 1

drop view DWPrecosLoja
go

create view DWPrecosLoja as
   select *
     from PrecoLojaGeral(0)
go

select *
  from DWPrecosLoja


------------------------------------------------------------------
-- retorna uma tabela com CST/al�quota do PIS/COFINS de um produto

drop function PisCofins
go

create function PisCofins(@empresa int, @produto varchar(15))
returns @dados table(codigo varchar(15), cstpis char(2), aliqpis smallmoney, cstcofins char(2), aliqcofins smallmoney) as
begin
	if (select top 1 EMPCRT from TBS023 with (nolock) order by EMPCOD desc) = 1
	begin
		insert into @dados
		select @produto
		       ,'49'
			   ,0
			   ,'49'
			   ,0

		return
	end

	declare @cstpis char(2), @cstcofins char(2), @aliqpis smallmoney, @aliqcofins smallmoney

	select @cstpis='', @cstcofins=''

	select @cstpis=isnull(PROSTBPIS,'')
	       ,@aliqpis=isnull(PROPIS,0)
		   ,@cstcofins=isnull(PROSTBCOFINS,'')
		   ,@aliqcofins=isnull(PROCOFINS,0)
	  from TBS010 with (nolock)
	 where PROEMPCOD=@empresa
	       and PROCOD=@produto

	if @cstpis between '06' and '09'
		set @aliqpis=0
	else
		if @cstpis=''
			select @cstpis=(select rtrim(PARVAL)
						   from TBS025 with (nolock)
						  where PARCHV=1113)
				   ,@aliqpis=(select rtrim(PARVAL)
						    from TBS025 with (nolock)
						   where PARCHV=1116)

	if @cstcofins between '06' and '09'
		set @aliqcofins=0
	else
		if @cstcofins=''
			select @cstcofins=(select rtrim(PARVAL)
								 from TBS025 with (nolock)
								where PARCHV=1114)
				   ,@aliqcofins=(select rtrim(PARVAL)
								from TBS025 with (nolock)
							   where PARCHV=1117)

	insert into @dados
	select @produto
		   ,@cstpis
		   ,@aliqpis
		   ,@cstcofins
		   ,@aliqcofins

	return
end
go

-- exemplo de uso
select * 
  from PisCofins(0,'00060007')


--------------------
-- stored procedures

-----------------------------------------------------
-- exclui produto/c�digos de barras das tabelas do GZ

drop procedure SP_ExcluiProdutoGZ
go

create procedure SP_ExcluiProdutoGZ @codigo varchar(15) as --, @retorno int output as
begin
	-- n�o exibe o n�mero de linhas afetadas
	set nocount on
	 
	declare @querySQL varchar(200), @result int

	-- seta resultado como zero
	set @result=0

	-- remove zeros a esquerda do c�digo
	 set @codigo = convert(varchar(15),convert(int, @codigo))

	-- elimina o registro da tabela estoque
	begin try
		set @querySQL = 'DELETE from estoque where cdprod=' + @codigo + ';'
		execute(@querySQL) at MYSQLGZTEST
	end try
	begin catch
		set @result = 1
	end catch

	-- elimina os registro da tabela de c�digos de barras
	begin try
		set @querySQL = 'DELETE from barrarel where cdprod=' + @codigo + ';'
		execute(@querySQL) at MYSQLGZTEST
	end try
	begin catch
		set @result += 2
	end catch

	-- ser @result retornar: 1 = erro no primeiro delete; 2 = erro no segundo e 3 = erro em ambos os delete
	return @result
end
go

-- exemplo de uso
declare @n int
execute @n=SP_ExcluiProdutoGZ '0018718'
print @n


-----------------------------------------------------
-- exclui produto/c�digos de barras das tabelas do GZ

drop procedure SP_ExcluiCodigoBarrasGZ
go

create procedure SP_ExcluiCodigoBarrasGZ @codigo varchar(15) as
begin
	-- n�o exibe o n�mero de linhas afetadas
	set nocount on
	 
	declare @querySQL varchar(200), @result smallint

	-- seta resultado como zero
	set @result=0

	-- remove zeros a esquerda do c�digo
	 set @codigo = convert(varchar(15),convert(int, @codigo))

	-- elimina os registro da tabela de c�digos de barras
	begin try
		set @querySQL = 'DELETE from barrarel where cdprod=' + @codigo + ';'
		execute(@querySQL) at MYSQLGZTEST
	end try
	begin catch
		set @result = 1
	end catch

	-- ser @result retornar: 1 = erro no delete
	return @result
end
go


-------------------------------------------
-- incluir produtos na tabela estoque do GZ - recebe uma string com select dos dados

drop procedure SP_GravaProdutoGZ
go

create procedure SP_GravaProdutoGZ @stringSQL varchar(500) as
begin
	declare @querySQL varchar(1000)

	set @querySQL  = 'insert into estoque (cdprod,descricao,descpdv,formula,unidade,termvenda,descpadrao,variavel,alterapre,multiplica,tributa,multiplos,embfechada,complement,sointeiro,st,situacao,multiatac,embfecatac,cfiscal,embfecesp,bloqvenda,solsenha,ippt,iat,ultatu,tipoitem,cargatrib,csosn,entregavel,chaveibpt,cstpis,aliqpis,cstcofins,aliqcofins,cest,precocusto)'
	set @querySQL += ' select ' + @stringSQL + ';'

	EXECUTE(@querySQL) at MYSQLGZTEST
end

declare @x varchar(500)
set @x = '0018718,''.'',''.'',''N'',''UN'',0.000,''A'',''N'',''N'',''N'',1,1.000,''N'',''N'',''S'',''160'',''A'',0.000,''S'','''',''S'',''N'',''N'',''T'',''A'',''2020-04-03'',0,0.00,'''',''N'','''',''01'',1.65,''01'',7.60,'''',0.000'
--print @x

execute SP_GravaProdutoGZ '0090663,''FITA SILVER TAPE-960 48X10 PRETA 0803080'',''FITA SILVER TAPE-960 48X'',''N'',''UN'',14.900,''A'',''N'',''N'',''N'',5,1.000,''N'',''N'',''S'',''000'',''A'',12.000,''S'',''59061000'',''S'',''N'',''N'',''T'',''A'',''2020-05-17'',0,5.56,'''',''N'',''6A098E'',''01'',1.65,''01'',7.60,''1900300'',7.610'

-- outra vers�o
-------------------------------------------
-- incluir produtos na tabela estoque do GZ - recebe a empresa e o c�digo do produto

drop procedure SP_InsertProdutoGZ
go

create procedure SP_InsertProdutoGZ @empresa smallint, @codigo varchar(15) as
begin
	declare @querySQL varchar(1500), @stringSQL varchar(1000), @result smallint

	select @stringSQL=dbo.StringInsertProdutoGZ(@empresa, @codigo)

	set @querySQL  = 'insert into estoque (cdprod,descricao,descpdv,formula,unidade,termvenda,descpadrao,variavel,alterapre,multiplica,tributa,multiplos,embfechada,complement,sointeiro,st,situacao,multiatac,embfecatac,cfiscal,embfecesp,bloqvenda,solsenha,ippt,iat,ultatu,tipoitem,cargatrib,csosn,entregavel,chaveibpt,cstpis,aliqpis,cstcofins,aliqcofins,cest,precocusto)'
	set @querySQL += ' select ' + @stringSQL + ';'

	begin try
		EXECUTE(@querySQL) at MYSQLGZTEST
	end try
	begin catch
		set @result = 0
	end catch

	return @result
end

execute SP_InsertProdutoGZ 0, '1640054'

-- outra vers�o com data type table

select * from temp
drop table temp

drop procedure SP_InsertProdutoGZ
go

create procedure SP_InsertProdutoGZ @estoque GZestoque readonly as
begin
	declare @querySQL varchar(1500), @stringSQL varchar(1000), @result smallint, @res varchar(20)

	begin try
		--set @res = (select codigo from @estoque)
		select * into temp from @estoque
	end try
	begin catch
		--set @result=100
		insert into temp select 'erro'
	end catch

	--select @stringSQL=dbo.StringInsertProdutoGZ(@empresa, @codigo)

	--set @querySQL  = 'insert into estoque (cdprod,descricao,descpdv,formula,unidade,termvenda,descpadrao,variavel,alterapre,multiplica,tributa,multiplos,embfechada,complement,sointeiro,st,situacao,multiatac,embfecatac,cfiscal,embfecesp,bloqvenda,solsenha,ippt,iat,ultatu,tipoitem,cargatrib,csosn,entregavel,chaveibpt,cstpis,aliqpis,cstcofins,aliqcofins,cest,precocusto)'
	--set @querySQL += ' select ' + @stringSQL + ';'

	--begin try
	--	EXECUTE(@querySQL) at MYSQLGZTEST
	--end try
	--begin catch
	--	set @result = 0
	--end catch

	--return @res
end


-------------------------------------------
-- incluir c�digos de barras na tabela barrarel do GZ - recebe uma string de dados

drop procedure SP_GravaCodigoBrrasGZ
go

create procedure SP_GravaCodigoBrrasGZ @stringSQL varchar(150) as
begin
	declare @querySQL varchar(1000)

	set @querySQL  = 'insert into barrarel (cdprod,codbarra,multiplos,termvenda)'
	set @querySQL += ' select ' + @stringSQL + ';'

	EXECUTE(@querySQL) at MYSQLGZTEST
end

declare @x varchar(500)
set @x = '0018718,''123456789012'',''10.000'',''15.45'''
--print @x

-- exemplo
execute SP_GravaCodigoBrrasGZ '0018718,''123456789012'',10.000,15.45'

-- outra vers�o
-------------------------------------------
-- elimina/incluir c�digos de barras na tabela barrarel do GZ - recebe uma empresa e c�digo de barras

drop procedure SP_InsertCodigoBarrasGZ
go

create procedure SP_InsertCodigoBarrasGZ @empresa smallint, @codigo varchar(15) as
begin
	declare @insert varchar(100), @n smallint, @i smallint, @comandoSQL varchar(300), @anterior varchar(100), @cbarras varchar(100)
	declare @barras table (strBarras varchar(200), reg smallint)

	-- inibe o contador de registros
	set nocount on

	-- insere dados na tabela tempor�ria com sequ�ncia num�rica
	insert into @barras select stringInsert,row_number() over(order by stringInsert) from dbo.TableInsertBarrasGZ(@empresa, @codigo)

	--  quantidade de registros da tabela
	set @n = @@rowcount

	if @n > 0
		-- elimina os c�digos de barras existentes na tabela [barrarel] do GZ
		execute dbo.SP_ExcluiCodigoBarrasGZ @codigo

		-- cabe�alho do comando de insert
		set @insert = 'insert into barrarel (cdprod,codbarra,multiplos,termvenda)'

		-- �ndice
		set @i = 1

		-- vari�vel "anterior"
		set @anterior=''

		-- percorre as linhas da tabela de c�digos de barras
		while @i <= @n
		begin
			select @cbarras=strBarras from @barras where reg=@i

			if @cbarras != @anterior
				-- comando com os dados da tabela para inser��o
				set @comandoSQL = @insert + ' select ' + @cbarras + ';'

			-- comando com os dados da tabela para inser��o
			--set @comandoSQL = @insert + ' select ' + (select strBarras from @barras where reg=@i) + ';'

			--print @comandoSQL

			begin try
				-- executa o comando
				execute(@comandoSQL) at MYSQLGZTEST
			end try
			begin catch
			end catch

			set @anterior=@cbarras

			-- incrementa o �ndice
			set @i += 1
		end
end

-- exemplo
execute SP_InsertCodigoBarrasGZ 0, '2870003'


-------------------------------------------
-- atualiza produtos na tabela estoque do GZ

drop procedure SP_UpdateProdutoGZ
go

create procedure SP_UpdateProdutoGZ @empresa smallint, @codigo varchar(15) as
	begin
		declare @querySQL varchar(1000), @update varchar(1000), @result smallint

		declare  @descricao char(40)
				,@descpdv varchar(24)
				,@formula char(1)
				,@unidade char(2)
				,@termvenda decimal(10,3)
				,@descpadrao char(1)
				,@variavel char(1)
				,@alterapre char(1)
				,@multiplica char(1)
				,@tributa int
				,@multiplos decimal(8,3)
				,@embfechada char(1)
				,@complement char(1)
				,@sointeiro char(1)
				,@st char(3)
				,@situacao char(1)
				,@multiatac decimal(8,3)
				,@embfecatac char(1)
				,@cfiscal varchar(10)
				,@embfecesp char(1)
				,@bloqvenda char(1)
				,@solsenha char(1)
				,@ippt char(1)
				,@iat char(1)
				,@ultatu date
				,@tipoitem int
				,@cargatrib decimal(5,2)
				,@csosn char(4)
				,@entregavel char(1)
				,@chaveibpt char(10)
				,@cstpis char(2)
				,@aliqpis decimal(9,2)
				,@cstcofins char(2)
				,@aliqcofins decimal(9,2)
				,@cest char(7)
				,@precocusto decimal(10,3)

		select   @descricao=Left(PRODES,40)	-- 01 C�digo Interno do Produto (PLU)
				,@descpdv=Left(PRODES,24)	-- 04 Descri��o Resumida para o PDV
				,@formula='N'	-- 05 F�rmula
				,@unidade=PROUM1	-- 06 Unidade de Refer�ncia
				,@termvenda=isnull((select preco1 from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0)	-- 09 Pre�o de Venda Padr�o
				,@descpadrao='A'	-- 12 Desconto Padr�o
				,@variavel=iif(PROPESAVEL='S','S','N')	-- 13 Quantidade Vari�vel / Produto Pesado ?
				,@alterapre='N'	-- 14 Altera Pre�o de Venda no PDV ?
				,@multiplica='N'	-- 15 Bloqueia Multiplicador ?
				,@tributa=TGZCOD	-- 17 C�digo da Tributa��o
				,@multiplos=PROUM1QTD	-- 19 Quantidade por Embalagem
				,@embfechada='N'	-- 20 Vende Somente Embalagem Fechada ?
				,@complement='N'	-- 22 Pede Descri��o Complementar ?
				,@sointeiro=iif(PROPESAVEL='S','N','S')	-- 25 Bloqueia Venda Fracionada ?
				,@st=PROSTBA+PROSTBB	-- 27 Situa��o Tribut�ria
				,@situacao='A'	-- 28 Estado do Produto
				,@multiatac=PROUM2QTD	-- 32 Quantidade por Embalagem (Atacado)
				,@embfecatac=iif(PROPESAVEL='S','N','S')	-- 33 Vende S� Embal. Fechada ? (Atacado)
				,@cfiscal=iif(Len(PROCLAFIS)=8,PROCLAFIS,'')	-- 35 Classifica��o Fiscal
				,@embfecesp=iif(PROPESAVEL='S','N','S')	-- 40 Vende S� Embal. Fechada ? (Especial)
				,@bloqvenda='N'	-- 56 Bloqueador de Venda
				,@solsenha='N'	-- 62 Solicita Senha para Libera��o de Venda
				,@ippt='T'	-- 64 Indicador de Produ��o Pr�pria ou de Terceiro
				,@iat='A'	-- 65 Indicador de Arredondamento ou Truncamento
				,@ultatu=convert(date,getdate())	-- ultatu
				,@tipoitem=0	-- 67 Tipo do Produto
				,@cargatrib=isnull((select iif(TBS010.PROSTBA in('0','3','4','5'),NCMALINAC,NCMALIIMP) from TBS092 with (nolock) where NCMEX='' and NCMCOD=TBS010.PROCLAFIS),0)	-- 68 Carga Tribut�ria Federal
				,@csosn=(select iif(EMPCRT=1,TBS010.PROSTBA+PROCSN,'') from TBS023 with (nolock) where EMPCOD=1)	-- 69 CSOSN
				,@entregavel='N'	-- 70 Entreg�vel
				,@chaveibpt=rtrim(isnull((select NCMCHV from TBS092 with (nolock) where NCMEX='' and NCMCOD=TBS010.PROCLAFIS),''))	-- 72 Chave Tabela IBPT
				,@cstpis=Ltrim(isnull((select cstpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),''))	-- 73 CST do PIS
				,@aliqpis=isnull((select aliqpis from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0)		-- 74 Al�quota do PIS
				,@cstcofins=Ltrim(isnull((select cstcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),''))		-- 75 CST do COFINS
				,@aliqcofins=isnull((select aliqcofins from PisCofins(TBS010.PROEMPCOD,TBS010.PROCOD)),0)	-- 76 Al�quota do COFINS
				,@cest=iif(Len(PROCEST)=7,PROCEST,'')	-- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria
				,@precocusto=isnull((select custo from PrecoLoja(TBS010.PROEMPCOD,TBS010.PROCOD)),0)	-- 80 Pre�o de Custo

		 from TBS010 with (nolock)
		where PROEMPCOD=@empresa
			  and PROCOD=@codigo
		order by PROEMPCOD, PROCOD

		set @querySQL = 'update estoque set descricao=''' + rtrim(@descricao) + ''',descpdv=''' + rtrim(@descpdv) + ''',formula=''' + rtrim(@formula) + ''',unidade=''' + rtrim(@unidade) + ''',termvenda=' + Ltrim(str(@termvenda,10,3)) + ',descpadrao=''' + rtrim(@descpadrao) + ''',variavel=''' + rtrim(@variavel) + ''',alterapre=''' + rtrim(@alterapre) + ''',multiplica=''' + rtrim(@multiplica) + ''',tributa=' + Ltrim(str(@tributa)) + ',multiplos=' + Ltrim(str(@multiplos,8,3)) + ',embfechada=''' + rtrim(@embfechada) + ''',complement=''' + rtrim(@complement) + ''',sointeiro=''' + rtrim(@sointeiro) + ''',st=''' + rtrim(@st) + ''',situacao=''' + rtrim(@situacao) + ''',multiatac=' + Ltrim(str(@multiatac,8,3)) + ',embfecatac=''' + rtrim(@embfecatac) + ''',cfiscal=''' + rtrim(@cfiscal) + ''',embfecesp=''' + rtrim(@embfecesp) + ''',bloqvenda=''' + rtrim(@bloqvenda) + ''',solsenha=''' + rtrim(@solsenha) + ''',ippt=''' + rtrim(@ippt) + ''',iat=''' + rtrim(@iat) + ''',ultatu=''' + convert(char(10),@ultatu,120) + ''',tipoitem=' + Ltrim(str(@tipoitem)) + ',cargatrib=' + Ltrim(str(@cargatrib,5,2)) + ',csosn=''' + rtrim(@csosn) + ''',entregavel=''' + rtrim(@entregavel) + ''',chaveibpt=''' + rtrim(@chaveibpt) + ''',cstpis=''' + rtrim(@cstpis) + ''',aliqpis=' + Ltrim(str(@aliqpis,9,2)) + ',cstcofins=''' + rtrim(@cstcofins) + ''',aliqcofins=' + Ltrim(str(@aliqcofins,9,2)) + ',cest=''' + rtrim(@cest) + ''',precocusto=' + Ltrim(str(@precocusto,10,3)) + ''
		set @querySQL += ' where cdprod=' + convert(varchar(15),convert(int, @codigo)) + ';'

		begin try
			EXECUTE(@querySQL) at MYSQLGZTEST

			set @result = 1
		end try
		begin catch
			set @result = 0
		end catch

		return @result
	end

execute dbo.SP_UpdateProdutoGZ 0, '1640054'

declare @n int
execute @n=SP_UpdateProdutoGZ 0, '1640054'
print @n

-------------------------------------------
-- verifica se o produto existe na tabela estoque do GZ

drop procedure SP_ExisteProdutoGZ
go

create procedure SP_ExisteProdutoGZ @codigo varchar(15) as
	begin
		declare @querySQL varchar(200)

		set @querySQL = 'select id from estoque where cdprod=' + convert(varchar(15),convert(int, @codigo))
		execute(@querySQL) at MYSQLGZTEST
	end

execute dbo.SP_ExisteProdutoGZ '1640054'


drop function ExisteProdutoGZ
go

create function ExisteProdutoGZ(@codigo varchar(20))
returns int as
begin
		declare @querySQL varchar(200), @id int

		set @id=0

		--set @querySQL='select id from estoque e where e.cdprod=' + convert(varchar(15),convert(int, @codigo) + 'limit 1;'

		set @id= (select id from OPENQUERY(MYSQLGZTEST, 'select * from estoque') where cdprod=convert(varchar(15),convert(int, @codigo)))

		return @id
end
go

-- exemplo de uso
select dbo.ExisteProdutoGZ('1640054')

drop function ProdutosExportacaoGZ
go

create function ProdutosExportacaoGZ(@empresa int)
returns @produtos table(texto varchar(max)) as
begin
SELECT * into ##precos from PrecoLojaGeral(0)

   select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)	-- 01 C�digo Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 02 C�digo de Barras - Observa��o 1
       + replace(Left(T10.PRODES,40),'''','')						-- 03 Descri��o Completa
       + replace(Left(T10.PRODES,24),'''','')						-- 04 Descri��o Resumida para o PDV
       + 'N'														-- 05 F�rmula - Observa��o 2
       + T10.PROUM1													-- 06 Unidade de Refer�ncia - Observa��o 3
	   + replicate('0',4)											-- 07 Arma��o / Localiza��o
	   + replicate('0',2)											-- 08 Setor ( Balan�a ) - Produto Pesado
	   
	   -- 09 Pre�o de Venda Padr�o
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)											-- 10 Pre�o de Venda Promocional - Observa��o 4
	   + replicate('0',12)											-- 11 Saldo em Estoque (Quantidade)
       + 'A'														-- 12 Desconto Padr�o - Observa��o 5
       + T10.PROPESAVEL												-- 13 Quantidade Vari�vel / Produto Pesado ? - S,N,E Observa��o 27
       + 'N'														-- 14 Altera Pre�o de Venda no PDV ? - S,N,T Observa��o 6
       + 'N'														-- 15 Bloqueia Multiplicador ? - Observa��o 7
	   + replicate(' ',6)											-- 16 Promo��o: Leve X Pague Y - Observa��o 8
       + right('00' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2)			-- 17 C�digo da Tributa��o
	   + ' '														-- 18 Reservado - Espa�o em Branco
       
	   -- 19 Quantidade por Embalagem - Observa��o 10
	   + right(replicate('0',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7)

       + 'N'														-- 20 Vende Somente Embalagem Fechada ? - Observa��o 11
	   + replicate('0',4)											-- 21 Desconto por Embalagem Fechada - Observa��o 12
	   + 'N'														-- 22 Pede Descri��o Complementar ? - S,N,P,T Obs. 13
	   + replicate(' ',80)											-- 23 Reservado - Espa�o em Branco
	   + replicate('0',9)											-- 24 Pre�o de Venda Atacado
       + iif(PROPESAVEL='S','N','S')								-- 25 Bloqueia Venda Fracionada ? - Observa��o 14
	   + replicate(' ',40)											-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB									-- 27 Situa��o Tribut�ria - Tabela 2
       + 'A'														-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)											-- 29 C�digo do Vasilhame - Observa��o 15
	   + replicate(' ',81)											-- 30 Reservado - Espa�o em Branco
	   + replicate('0',4)											-- 31 Percentual Desconto M�ximo Permitido - Observa��o 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observa��o 10
       
	   + iif(PROPESAVEL='S','N','S')													-- 33 Vende S� Embal. Fechada ? (Atacado) - Observa��o 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observa��o 12
       + Left(Ltrim(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'')) + replicate(' ',2),10)	-- 35 Classifica��o Fiscal
	   + replicate('0',12)																-- 36 Quantidade Pendente - Venda Balc�o
	   + replicate(' ',4)																-- 37 Validade da Quantidade Pendente - Venda Balc�o
	   + replicate('0',9)																-- 38 Pre�o de Venda Especial
	   + replicate('0',7)																-- 39 Quantidade por Embalagem (Especial) - Observa��o 10
	   + 'N'																			-- 40 Vende S� Embal. Fechada ? (Especial) - Observa��o 11
	   + replicate('0',4)																-- 41 Desconto por Embalagem Fechada (Especial) - Observa��o 12
	   + replicate('0',12)																-- 42 Quantidade M�nima para Pre�o Atacado - Observa��o 17
	   + replicate('0',12)																-- 43 Quantidade M�nima para Pre�o Especial - Observa��o 17
	   + replicate('0',6)																-- 44 Grupo
	   + replicate('0',6)																-- 45 Departamento
	   + replicate('0',6)																-- 46 Marca
	   + replicate('0',8)																-- 47 Pontos Clube Fidelidade - Observa��o 18
	   + replicate(' ',1)																-- 48 Base de C�lculo Clube Fidelidade - Observa��o 19
	   + replicate('0',20)																-- 49 C�digo Interno do Produto Associado - Observa��o 20
	   + replicate('0',3)																-- 50 Grupo de Finalizadores - Observa��o 21
	   + replicate('0',9)																-- 51 Desconto Finalizadores Espec�ficos - Observa��o 22
	   + replicate(' ',90)																-- 52 Finalizadores para Desconto - Observa��o 23
	   + replicate('0',2)																-- 53 1� Micro-Terminal de Impress�o - Observa��o 24
	   + replicate('0',6)																-- 54 Quantidade M�xima de Item por Compra
	   + replicate(' ',1)																-- 55 Cupom Vinculado - Observa��o 25
	   + replicate(' ',1)																-- 56 Bloqueador de Venda - Observa��o 26
	   + '0'																			-- 57 Tipo do Produto - 0 - Produto / 1 Servi�o
	   + replicate('0',2)																-- 58 2� Micro-Terminal de Impress�o - Observa��o 24
	   + replicate('0',2)																-- 59 3� Micro-Terminal de Impress�o - Observa��o 24
	   + replicate('0',2)																-- 60 4� Micro-Terminal de Impress�o - Observa��o 24
	   + replicate('0',2)																-- 61 5� Micro-Terminal de Impress�o - Observa��o 24
	   + 'N'																			-- 62 Solicita Senha para Libera��o de Venda - S - Sim / N - N�o
	   + replicate('0',3)																-- 63 Grupo de Balc�o - Observa��o 28
	   + 'T'																			-- 64 Indicador de Produ��o Pr�pria ou de Terceiro
	   + 'A'																			-- 65 Indicador de Arredondamento ou Truncamento - A - Arredondamento T - Truncamento
	   + replicate('0',9)																-- 66 Pre�o M�ximo de Venda ao Consumidor
	   + replicate('0',3)																-- 67 Tipo do Produto - Observa��o 29

	   -- 68 Carga Tribut�ria Federal - Observa��o 30
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN
	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'														-- 70 Entreg�vel - S - Sim / N - N�o - Observa��o 31
	   + replicate('0',4)											-- 71 Carga Tribut�ria Estadual - Observa��o 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1','49', isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2))))

       -- 74 Al�quota do PIS
	   + iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1',replicate('0',9), right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9))

	   -- 75 CST do COFINS
	   + Ltrim(iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1','49', isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2))))

       -- 76 Al�quota do COFINS
	   + iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1',replicate('0',9), right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9))

	   + iif(Len(T10.PROCEST)=7,T10.PROCEST, replicate(' ',7))						-- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria - Observa��o 32

	   + replicate('0',9)															-- 78 Valor Unit�rio PIS - SAIDA
	   + replicate('0',9)															-- 79 Valor Unit�rio COFINS - SAIDA

       -- 80 Pre�o de Custo
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto

  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0
 order by PROCOD
end

select *
  from TBS031 with (nolock)

select *
  from TBS031 pre with (nolock)
 where not exists(select 'ne' from TBS010 pro with (nolock) where pro.PROCOD=pre.TDPPROCOD)

select *
  from TBS010 with (nolock)
 where Left(PROCOD,2)='99' --10840095'

select *
  from movcaixagz with (nolock)
 where Left(cdprod,2)='99'
       and Len(cdprod) > 8
       and [data] >= '20230101'

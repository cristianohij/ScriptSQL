select 0 as empresa
       ,'1640054             ' as codigo
       ,convert(date,getdate(),112) as data
       ,convert(char(8),getdate(),14) as hora
  into LOG_EXPORTACAO_GZ

select * from LOG_EXPORTACAO_GZ

drop table #produtos

select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)							-- 01 Código Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)							-- 02 Código de Barras - Observação 1
       + replace(Left(T10.PRODES,40),'''','')											-- 03 Descrição Completa
       + replace(Left(T10.PRODES,24),'''','')											-- 04 Descrição Resumida para o PDV
       + 'N'																			-- 05 Fórmula - Observação 2
       + T10.PROUM1																		-- 06 Unidade de Referência - Observação 3
	   + replicate('0',4)																-- 07 Armação / Localização
	   + replicate('0',2)																-- 08 Setor ( Balança ) - Produto Pesado
	   
	   -- 09 Preço de Venda Padrão
       --+  str(isnull((select round(preco1,3) from PrecoLoja(0, T10.PROCOD)),0),9,3)
	   --+ right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from PrecoLoja(0, T10.PROCOD)),0)*1000,9,0)),9)
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)																-- 10 Preço de Venda Promocional - Observação 4
	   + replicate('0',12)																-- 11 Saldo em Estoque (Quantidade)
       + 'A'																			-- 12 Desconto Padrão - Observação 5
       + T10.PROPESAVEL																	-- 13 Quantidade Variável / Produto Pesado ? - S,N,E Observação 27
       + 'N'																			-- 14 Altera Preço de Venda no PDV ? - S,N,T Observação 6
       + 'N'																			-- 15 Bloqueia Multiplicador ? - Observação 7
	   + replicate(' ',6)																-- 16 Promoção: Leve X Pague Y - Observação 8
       + right('00' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2)								-- 17 Código da Tributação
	   + ' '																			-- 18 Reservado - Espaço em Branco
       
	   -- 19 Quantidade por Embalagem - Observação 10
	   --+ right(replicate('0',7) + Ltrim(str(round(T10.PROUM1QTD,3),7,3)),7)
	   + right(replicate('0',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7)

       + 'N'																			-- 20 Vende Somente Embalagem Fechada ? - Observação 11
	   + replicate('0',4)																-- 21 Desconto por Embalagem Fechada - Observação 12
	   + 'N'																			-- 22 Pede Descrição Complementar ? - S,N,P,T Obs. 13
	   + replicate(' ',80)																-- 23 Reservado - Espaço em Branco
	   + replicate('0',9)																-- 24 Preço de Venda Atacado
       + iif(PROPESAVEL='S','N','S')													-- 25 Bloqueia Venda Fracionada ? - Observação 14
	   + replicate(' ',40)																-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB														-- 27 Situação Tributária - Tabela 2
       + 'A'																			-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)																-- 29 Código do Vasilhame - Observação 15
	   + replicate(' ',81)																-- 30 Reservado - Espaço em Branco
	   + replicate('0',4)																-- 31 Percentual Desconto Máximo Permitido - Observação 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observação 10
       
	   + iif(PROPESAVEL='S','N','S')													-- 33 Vende Só Embal. Fechada ? (Atacado) - Observação 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observação 12
       + Left(Ltrim(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'')) + replicate(' ',2),10)	-- 35 Classificação Fiscal
	   + replicate('0',12)																-- 36 Quantidade Pendente - Venda Balcão
	   + replicate(' ',4)																-- 37 Validade da Quantidade Pendente - Venda Balcão
	   + replicate('0',9)																-- 38 Preço de Venda Especial
	   + replicate('0',7)																-- 39 Quantidade por Embalagem (Especial) - Observação 10
	   + 'N'																			-- 40 Vende Só Embal. Fechada ? (Especial) - Observação 11
	   + replicate('0',4)																-- 41 Desconto por Embalagem Fechada (Especial) - Observação 12
	   + replicate('0',12)																-- 42 Quantidade Mínima para Preço Atacado - Observação 17
	   + replicate('0',12)																-- 43 Quantidade Mínima para Preço Especial - Observação 17
	   + replicate('0',6)																-- 44 Grupo
	   + replicate('0',6)																-- 45 Departamento
	   + replicate('0',6)																-- 46 Marca
	   + replicate('0',8)																-- 47 Pontos Clube Fidelidade - Observação 18
	   + replicate(' ',1)																-- 48 Base de Cálculo Clube Fidelidade - Observação 19
	   + replicate('0',20)																-- 49 Código Interno do Produto Associado - Observação 20
	   + replicate('0',3)																-- 50 Grupo de Finalizadores - Observação 21
	   + replicate('0',9)																-- 51 Desconto Finalizadores Específicos - Observação 22
	   + replicate(' ',90)																-- 52 Finalizadores para Desconto - Observação 23
	   + replicate('0',2)																-- 53 1º Micro-Terminal de Impressão - Observação 24
	   + replicate('0',6)																-- 54 Quantidade Máxima de Item por Compra
	   + replicate(' ',1)																-- 55 Cupom Vinculado - Observação 25
	   + replicate(' ',1)																-- 56 Bloqueador de Venda - Observação 26
	   + '0'																			-- 57 Tipo do Produto - 0 - Produto / 1 Serviço
	   + replicate('0',2)																-- 58 2º Micro-Terminal de Impressão - Observação 24
	   + replicate('0',2)																-- 59 3º Micro-Terminal de Impressão - Observação 24
	   + replicate('0',2)																-- 60 4º Micro-Terminal de Impressão - Observação 24
	   + replicate('0',2)																-- 61 5º Micro-Terminal de Impressão - Observação 24
	   + 'N'																			-- 62 Solicita Senha para Liberação de Venda - S - Sim / N - Não
	   + replicate('0',3)																-- 63 Grupo de Balcão - Observação 28
	   + 'T'																			-- 64 Indicador de Produção Própria ou de Terceiro
	   + 'A'																			-- 65 Indicador de Arredondamento ou Truncamento - A - Arredondamento T - Truncamento
	   + replicate('0',9)																-- 66 Preço Máximo de Venda ao Consumidor
	   + replicate('0',3)																-- 67 Tipo do Produto - Observação 29

	   -- 68 Carga Tributária Federal - Observação 30
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN
	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'																							-- 70 Entregável - S - Sim / N - Não - Observação 31

	   + replicate('0',4)																				-- 71 Carga Tributária Estadual - Observação 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1','49', isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2))))

       -- 74 Alíquota do PIS
	   + iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1',replicate('0',9), right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9))

	   -- 75 CST do COFINS
	   + Ltrim(iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1','49', isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2))))

       -- 76 Alíquota do COFINS
	   + iif((select EMPCRT from TBS023 with (nolock) where EMPCOD=1)='1',replicate('0',9), right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9))

	   + iif(Len(T10.PROCEST)=7,T10.PROCEST, replicate(' ',7))											-- 77 CEST - Código Especificador da Substituição Tributária - Observação 32

	   + replicate('0',9)																				-- 78 Valor Unitário PIS - SAIDA
	   + replicate('0',9)																				-- 79 Valor Unitário COFINS - SAIDA

       -- 80 Preço de Custo
       --+ right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from PrecoLoja(0, T10.PROCOD)),0)*1000,9,0)),9)
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto

  --into #produtos
  from TBS010 T10 with (nolock)
 where --MARCOD=164
       --and
	   --(select round(preco1,3) from ##precos(0, T10.PROCOD)) > 0
	   TGZCOD > 0
	   and (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0
 order by PROCOD


EXEC master.dbo.xp_cmdshell 'bcp "select right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20) + right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20)+ replace(Left(T10.PRODES,40),'''','''') + replace(Left(T10.PRODES,24),'''','''') + ''N'' + T10.PROUM1 + replicate(''0'',4) + replicate(''0'',2) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) + replicate(''0'',9) + replicate(''0'',12) + ''A'' + T10.PROPESAVEL + ''N'' + ''N'' + replicate('' '',6) + right(''00'' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2) + '' '' + right(replicate(''0'',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7) + ''N'' + replicate(''0'',4) + ''N'' + replicate('' '',80) + replicate(''0'',9) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate('' '',40) + T10.PROSTBA+T10.PROSTBB + ''A'' + replicate(''0'',4) + replicate('' '',81) + replicate(''0'',4) + right(replicate(''0'',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate(''0'',4) + Left(Ltrim(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'''')) + replicate('' '',2),10) + replicate(''0'',12) + replicate('' '',4) + replicate(''0'',9) + replicate(''0'',7) + ''N'' + replicate(''0'',4) + replicate(''0'',12) + replicate(''0'',12) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',8) + replicate('' '',1) + replicate(''0'',20) + replicate(''0'',3) + replicate(''0'',9) + replicate('' '',90) + replicate(''0'',2)  + replicate(''0'',6) + replicate('' '',1) + replicate('' '',1) + ''0'' + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + ''N'' + replicate(''0'',3) + ''T'' + ''A'' + replicate(''0'',9) + replicate(''0'',3) + isnull((select iif(T10.PROSTBA in (''0'', ''3'', ''4'', ''5''), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),''.00'',''''))),4), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),''.00'',''''))),4)) from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),''000'') + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate('' '',4)) from SIBD.dbo.TBS023 with (nolock) where EMPCOD = 1) + ''N'' + replicate(''0'',4) + isnull((select NCMCHV from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),replicate('' '',10)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstpis from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstcofins from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + iif(Len(T10.PROCEST)=7,T10.PROCEST, replicate('' '',7)) + replicate(''0'',9) + replicate(''0'',9) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto from SIBD.dbo.TBS010 T10 with (nolock) where TGZCOD > 0 and (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0 order by PROCOD" queryout "c:\integros\exporta\proteste.txt" -c -t; -T'

select @@ROWCOUNT

declare @q1 int, @q2 int

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\exporta;HDR=No;/r'
		,'select * from [proteste.txt]'
	 )

--select @q1

select @q2=count(*)
  from TBS010 T10 with (nolock)
 where TGZCOD > 0 and (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0

set @q2=52431

-- se diferença for maior do que 1%
if (1-@q1/@q2) * 100 > 1
select @q1, @q2

exec xp_cmdshell 'del c:\integros\teste\estoque.txt'

select subString(texto,1,20)
       ,codigo
	   ,subString(texto,41,40)
  from #produtos
  full outer join barras
  on convert(int,codigo)=convert(int,subString(texto,1,20))
  where --subString(texto,1,20) is null or codigo is null 
        subString(texto,1,20) is null
		--codigo is null 

select subString(texto,1,20)
       ,codigo
	   ,subString(texto,41,40)
  from #produtos
  full outer join #precos
  on convert(int,codigo)=convert(int,subString(texto,1,20))
  where --subString(texto,1,20) is null or codigo is null 
        subString(texto,1,20) is null
		--codigo is null 

select *
  from ##precos
 wHere codigo='7981790'

drop table #precos

select *
  into ##precos
 from PrecoLojaGeral(0)

select *
  from #precos
 where preco1=0

select *
  from TBS092 with (nolock)
 where NCMCOD=(select PROCLAFIS
                 from TBS010 with (nolock)
                where PROCOD='1641606')

select right(replicate('0',4) + rtrim(replace(convert(char(9),round(4.20*100,0)),'.00','')),4)

select *
  from #stringao

drop table #stringao

  from TBS010 T10 with (nolock)
 where MARCOD=164
       and (select round(preco1,3) from PrecoLoja(0, T10.PROCOD)) > 0
 order by PROCOD


	select rtrim(codigo) + ','  -- 1 Código do Produto Principal (PLU)
		   + rtrim(barras) + ','  -- 2 Código de Barras do Produto
		   + Ltrim(str(embalagem,9,3)) + ','  -- 4 Múltiplos
		   + Ltrim(str(preco,9,3))  -- 5 Preço de Venda
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

-- versão antiga
-- EXEC master.dbo.xp_cmdshell 'bcp "select right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20) + right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20)+ replace(Left(T10.PRODES,40),'''','''') + replace(Left(T10.PRODES,24),'''','''') + ''N'' + T10.PROUM1 + replicate(''0'',4) + replicate(''0'',2) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) + replicate(''0'',9) + replicate(''0'',12) + ''A'' + T10.PROPESAVEL + ''N'' + ''N'' + replicate('' '',6) + right(''00'' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2) + '' '' + right(replicate(''0'',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7) + ''N'' + replicate(''0'',4) + ''N'' + replicate('' '',80) + replicate(''0'',9) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate('' '',40) + T10.PROSTBA+T10.PROSTBB + ''A'' + replicate(''0'',4) + replicate('' '',81) + replicate(''0'',4) + right(replicate(''0'',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate(''0'',4) + Left(Ltrim(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'''')) + replicate('' '',2),10) + replicate(''0'',12) + replicate('' '',4) + replicate(''0'',9) + replicate(''0'',7) + ''N'' + replicate(''0'',4) + replicate(''0'',12) + replicate(''0'',12) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',8) + replicate('' '',1) + replicate(''0'',20) + replicate(''0'',3) + replicate(''0'',9) + replicate('' '',90) + replicate(''0'',2)  + replicate(''0'',6) + replicate('' '',1) + replicate('' '',1) + ''0'' + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + ''N'' + replicate(''0'',3) + ''T'' + ''A'' + replicate(''0'',9) + replicate(''0'',3) + isnull((select iif(T10.PROSTBA in (''0'', ''3'', ''4'', ''5''), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),''.00'',''''))),4), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),''.00'',''''))),4)) from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),''000'') + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate('' '',4)) from SIBD.dbo.TBS023 with (nolock) where EMPCOD = 1) + ''N'' + replicate(''0'',4) + isnull((select NCMCHV from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),replicate('' '',10)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstpis from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstcofins from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + iif(Len(T10.PROCEST)=7,T10.PROCEST, replicate('' '',7)) + replicate(''0'',9) + replicate(''0'',9) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto from SIBD.dbo.TBS010 T10 with (nolock) where (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0 order by PROCOD" queryout "c:\integros\teste\estoque.txt" -c -t; -T';


-- versão atual

-- functions utilizadas

--> PrecoLojaGeral
--> PisCofins
--> TabelaCodigosBarrasGZ
--> PrecoLoja

-- CARGA GERAL DOS PRODUTOS

-- remove/recria a tabela temporária de preços

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
--if @q <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foi carregada a tabela ##precos'

      -- força um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com preços: ' + Ltrim(str(@q,9,0))

-- gera o arquivo temporário para exportação dos produtos

-- remove/recria a tabela temporária de produtos

if object_id('##produtos') is not null
   drop table ##produtos

-- lista de produtos exportados

select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 01 Código Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 02 Código de Barras - Observação 1
	   -- 03 Descrição Completa
       --+ replace(Left(replace(T10.PRODES collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   + replace(Left(replace(iif(T10.PRODESPDV='',T10.PRODES,T10.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   -- 04 Descrição Resumida para o PDV
       --+ replace(Left(replace(T10.PRODES collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
	   + replace(Left(replace(iif(T10.PRODESPDVRED='',T10.PRODES,T10.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
       + 'N'														-- 05 Fórmula - Observação 2
       + T10.PROUM1													-- 06 Unidade de Referência - Observação 3
	   + replicate('0',4)											-- 07 Armação / Localização
	   + replicate('0',2)											-- 08 Setor ( Balança ) - Produto Pesado
	   
	   -- 09 Preço de Venda Padrão
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)											-- 10 Preço de Venda Promocional - Observação 4
	   + replicate('0',12)											-- 11 Saldo em Estoque (Quantidade)
       + 'A'														-- 12 Desconto Padrão - Observação 5
       --+ T10.PROPESAVEL												-- 13 Quantidade Variável / Produto Pesado ? - S,N,E Observação 27
	   + iif(T10.PROUM1 in('KG','MT'),'S','N')						-- 13 Quantidade Variável / Produto Pesado ? - S,N,E Observação 27
       + 'N'														-- 14 Altera Preço de Venda no PDV ? - S,N,T Observação 6
       + 'N'														-- 15 Bloqueia Multiplicador ? - Observação 7
	   + replicate(' ',6)											-- 16 Promoção: Leve X Pague Y - Observação 8
       + right('00' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2)			-- 17 Código da Tributação
	   + ' '														-- 18 Reservado - Espaço em Branco
       
	   -- 19 Quantidade por Embalagem - Observação 10
	   + right(replicate('0',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7)

       + 'N'														-- 20 Vende Somente Embalagem Fechada ? - Observação 11
	   + replicate('0',4)											-- 21 Desconto por Embalagem Fechada - Observação 12
	   + 'N'														-- 22 Pede Descrição Complementar ? - S,N,P,T Obs. 13
	   + replicate(' ',80)											-- 23 Reservado - Espaço em Branco
	   + replicate('0',9)											-- 24 Preço de Venda Atacado
       --+ iif(PROPESAVEL='S','N','S')								-- 25 Bloqueia Venda Fracionada ? - Observação 14
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')						-- 25 Bloqueia Venda Fracionada ? - Observação 14
	   + replicate(' ',40)											-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB									-- 27 Situação Tributária - Tabela 2
       + 'A'														-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)											-- 29 Código do Vasilhame - Observação 15
	   + replicate(' ',81)											-- 30 Reservado - Espaço em Branco
	   + replicate('0',4)											-- 31 Percentual Desconto Máximo Permitido - Observação 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observação 10
       
	   --+ iif(PROPESAVEL='S','N','S')													-- 33 Vende Só Embal. Fechada ? (Atacado) - Observação 11
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')											-- 33 Vende Só Embal. Fechada ? (Atacado) - Observação 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observação 12
       
	   -- 35 Classificação Fiscal
	   + iif(Len(Ltrim(T10.PROCLAFIS))=8,rtrim(T10.PROCLAFIS)+'  ', replicate(' ',10))

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
	   --+ replicate('0',6)																-- 46 Marca
	   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)							-- 46 Marca
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
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'0000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'														-- 70 Entregável - S - Sim / N - Não - Observação 31
	   + replicate('0',4)											-- 71 Carga Tributária Estadual - Observação 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 74 Alíquota do PIS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   -- 75 CST do COFINS
	   + Ltrim(isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 76 Alíquota do COFINS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   + iif(Len(Ltrim(T10.PROCEST))=7,T10.PROCEST, replicate(' ',7))						-- 77 CEST - Código Especificador da Substituição Tributária - Observação 32

	   + replicate('0',9)															-- 78 Valor Unitário PIS - SAIDA
	   + replicate('0',9)															-- 79 Valor Unitário COFINS - SAIDA

       -- 80 Preço de Custo
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto

   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(preco1,3) from ##precos where codigo=T10.PROCOD) > 0
 order by PROCOD

-- elimina registro nulos
 
delete ##produtos
 where texto is null
 
-- select para o contador de registros abaixo

select count(*)
  from ##produtos

-- quantidade de produtos exportados

select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##produtos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##produtos'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\expgz\est.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de proudtos exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\expgz;HDR=No;/r'
		,'select * from [est.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de produtos exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS010): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
   begin
   	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Produtos. Arquivo c:\integros\expgz\est.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Produtos. Arquivo c:\integros\expgz\est.txt deletado.'
      exec xp_cmdshell 'del c:\integros\expgz\est.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go

-- fim carga geral




-- códigos de barras

-- remove/recria a tabela temporária de preços

if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go

if object_id('tempdb.dbo.##q2') is not null
   drop table tempdb.dbo.##q2
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select right(replicate('0',20) + Ltrim(rtrim(codigo)),20)							-- 01 Código do Produto Principal (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(barras)),20)							-- 02 Código de Barras do Produto
	   + replicate(' ',40)															-- 03 Observação
	   + right(replicate('0',9) + Ltrim(str(round(embalagem,3)*1000,9,0)),9)		-- 04 Múltiplos - Observação 1
	   + right(replicate('0',9) + Ltrim(str(round(preco,3)*1000,9,0)),9) as texto	-- 05 Preço de Venda - Observação 2
  into ##barras
  from dbo.TabelaCodigosBarrasGZ(0)
 
-- quantidade de registros processados
select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##barras'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##barras'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos códigos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\expgz\bar.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de códigos de barras exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\expgz;HDR=No;/r'
		,'select * from [bar.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de códigos de barras exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS0103): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Códigos de Barras. Arquivo c:\integros\expgz\bar.txt deletado'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Códigos de Barras.'

      exec xp_cmdshell 'del c:\integros\expgz\bar.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go


select *
  from ##barras
 order by texto

select *
  from dbo.TabelaCodigosBarrasGZ(0)
 order by codigo




-- renomeia os arquivos exportados

-- remove os arquivos
exec xp_cmdshell 'del c:\integros\expgz\estoque.txt';
go

exec xp_cmdshell 'del c:\integros\expgz\barrarel.txt';
go

-- renomeia os arquivos criados
exec xp_cmdshell 'ren c:\integros\expgz\est.txt estoque.txt';
go

exec xp_cmdshell 'ren c:\integros\expgz\bar.txt barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT renomeados com sucesso.';
go


-- best arts

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\est.txt \\192.168.7.210\carga\estoque.txt';
go

exec xp_cmdshell 'move /y c:\integros\expgz\bar.txt \\192.168.7.210\carga\barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT movidos com sucesso para a pasta \\192.168.7.210\carga';
go


-- tanby matriz

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\est.txt \\192.168.1.209\importa\estoque.txt';
go

exec xp_cmdshell 'move /y c:\integros\expgz\bar.txt \\192.168.1.209\importa\barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT movidos com sucesso para a pasta \\192.168.1.209\importa';
go


-- best bag

-- /opt/gz/importa

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\est.txt \\192.168.0.14\importa\estoque.txt';
go

exec xp_cmdshell 'move /y c:\integros\expgz\bar.txt \\192.168.0.14\importa\barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT movidos com sucesso para a pasta \\192.168.0.14\importa';
go


-- tanby taubaté

-- /opt/gz/importa

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\est.txt \\192.168.3.240\importa\estoque.txt';
go

exec xp_cmdshell 'move /y c:\integros\expgz\bar.txt \\192.168.3.240\importa\barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT movidos com sucesso para a pasta \\192.168.3.240\importa';
go


declare @SQLemail varchar(max), @@msg varchar(max)
	
set @@msg='<p>Nome do trabalho: Exporta produtos para integração com Sistema GZ'  + (select '<p>Executado em: ' + convert(varchar(max),getdate())) + '<p>Mensagem: Não foi carregada a tabela ##precos'

set @SQLemail = 'execute msdb.dbo.sp_send_dbmail
						@profile_name = ''Email'',
						@recipients = ''cristiano@integros.com.br'', 
						@body_format = ''html'',
						@subject = ''Testes de envio'',
						@body = ''' + @@msg + ''''

--print @sqlEmail
		
	exec(@sqlEmail)





-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CARGA PARCIAL DOS PRODUTOS

-- remove/recria a tabela temporária de preços

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foi carregada a tabela ##precos'

      -- força um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com preços: ' + Ltrim(str(@q,9,0))

-- lista de produtos exportados

select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 01 Código Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 02 Código de Barras - Observação 1
	   -- 03 Descrição Completa
	   + replace(Left(replace(iif(T10.PRODESPDV='',T10.PRODES,T10.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   -- 04 Descrição Resumida para o PDV
	   + replace(Left(replace(iif(T10.PRODESPDVRED='',T10.PRODES,T10.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
       + 'N'														-- 05 Fórmula - Observação 2
       + T10.PROUM1													-- 06 Unidade de Referência - Observação 3
	   + replicate('0',4)											-- 07 Armação / Localização
	   + replicate('0',2)											-- 08 Setor ( Balança ) - Produto Pesado
	   
	   -- 09 Preço de Venda Padrão
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)											-- 10 Preço de Venda Promocional - Observação 4
	   + replicate('0',12)											-- 11 Saldo em Estoque (Quantidade)
       + 'A'														-- 12 Desconto Padrão - Observação 5
       --+ T10.PROPESAVEL												-- 13 Quantidade Variável / Produto Pesado ? - S,N,E Observação 27
	   + iif(T10.PROUM1 in('KG','MT'),'S','N')						-- 13 Quantidade Variável / Produto Pesado ? - S,N,E Observação 27
       + 'N'														-- 14 Altera Preço de Venda no PDV ? - S,N,T Observação 6
       + 'N'														-- 15 Bloqueia Multiplicador ? - Observação 7
	   + replicate(' ',6)											-- 16 Promoção: Leve X Pague Y - Observação 8
       + right('00' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2)			-- 17 Código da Tributação
	   + ' '														-- 18 Reservado - Espaço em Branco
       
	   -- 19 Quantidade por Embalagem - Observação 10
	   + right(replicate('0',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7)

       + 'N'														-- 20 Vende Somente Embalagem Fechada ? - Observação 11
	   + replicate('0',4)											-- 21 Desconto por Embalagem Fechada - Observação 12
	   + 'N'														-- 22 Pede Descrição Complementar ? - S,N,P,T Obs. 13
	   + replicate(' ',80)											-- 23 Reservado - Espaço em Branco
	   + replicate('0',9)											-- 24 Preço de Venda Atacado
       --+ iif(PROPESAVEL='S','N','S')								-- 25 Bloqueia Venda Fracionada ? - Observação 14
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')						-- 25 Bloqueia Venda Fracionada ? - Observação 14
	   + replicate(' ',40)											-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB									-- 27 Situação Tributária - Tabela 2
       + 'A'														-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)											-- 29 Código do Vasilhame - Observação 15
	   + replicate(' ',81)											-- 30 Reservado - Espaço em Branco
	   + replicate('0',4)											-- 31 Percentual Desconto Máximo Permitido - Observação 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observação 10
       
	   --+ iif(PROPESAVEL='S','N','S')													-- 33 Vende Só Embal. Fechada ? (Atacado) - Observação 11
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')											-- 33 Vende Só Embal. Fechada ? (Atacado) - Observação 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observação 12
       
	   -- 35 Classificação Fiscal
	   + iif(Len(Ltrim(T10.PROCLAFIS))=8,rtrim(T10.PROCLAFIS)+'  ', replicate(' ',10))

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
	   --+ replicate('0',6)																-- 46 Marca
	   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)							-- 46 Marca
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
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'0000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'														-- 70 Entregável - S - Sim / N - Não - Observação 31
	   + replicate('0',4)											-- 71 Carga Tributária Estadual - Observação 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 74 Alíquota do PIS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   -- 75 CST do COFINS
	   + Ltrim(isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 76 Alíquota do COFINS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   + iif(Len(Ltrim(T10.PROCEST))=7,T10.PROCEST, replicate(' ',7))						-- 77 CEST - Código Especificador da Substituição Tributária - Observação 32

	   + replicate('0',9)															-- 78 Valor Unitário PIS - SAIDA
	   + replicate('0',9)															-- 79 Valor Unitário COFINS - SAIDA

       -- 80 Preço de Custo
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto

   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(preco1,3) from ##precos where codigo=T10.PROCOD) > 0
	   and (
	          T10.PRODATCAD >= convert(date,getdate())
			  or T10.PRODATALT >= convert(date,getdate())
			  or (select atualizado from ##precos where codigo=T10.PROCOD) >= convert(date,getdate())
           )
 order by PROCOD

-- elimina registro nulos
 
delete ##produtos
 where texto is null
 
-- select para o contador de registros abaixo

select count(*)
  from ##produtos

-- quantidade de produtos exportados

select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foram encontrados Produtos incluídos/alterados para serem exportados'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foram encontrados Produtos incluídos/alterados para serem exportados'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\expgz\estp.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de proudtos exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

-- quantidade de produtos gravados no arquivo

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\expgz;HDR=No;/r'
		,'select * from [estp.txt]'
	 )

-- quantidade de produtos exportados

set @q2=(select q from ##q2)

print 'Quantidade de produtos exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS010): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
   	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Produtos. Arquivo c:\integros\expgz\estp.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Produtos. Arquivo c:\integros\expgz\estp.txt deletado.'
      exec xp_cmdshell 'del c:\integros\expgz\estp.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go


-- códigos de barras

-- remove/recria a tabela temporária de preços

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
--if @q <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foi carregada a tabela ##precos'

      -- força um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com preços: ' + Ltrim(str(@q,9,0))

-- remove/recria a tabela temporária de preços

if object_id('##produtos') is not null
   drop table ##produtos
go
-- devido ao "go" acima, perde referência de variáveis


declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'


select T10.PROCOD
   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0
	   and (
	          T10.PRODATCAD >= convert(date,getdate())
			  or T10.PRODATALT >= convert(date,getdate())
			  or (select atualizado from ##precos where codigo=T10.PROCOD) >= convert(date,getdate())
           )
 order by PROCOD

set @q=@@ROWCOUNT

print 'Quantidade de produtos incluídos/alterados: ' + Ltrim(str(@q,9,0))

if @q=0
--if @q <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Não foram encontrados Produtos incluídos/alterados para serem exportados'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Não foram encontrados Produtos incluídos/alterados para serem exportados'

	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- remove/recria a tabela temporária de códigos de barras

if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go

if object_id('tempdb.dbo.##q2') is not null
   drop table tempdb.dbo.##q2
go

--declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'

select right(replicate('0',20) + Ltrim(rtrim(codigo)),20)							-- 01 Código do Produto Principal (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(barras)),20)							-- 02 Código de Barras do Produto
	   + replicate(' ',40)															-- 03 Observação
	   + right(replicate('0',9) + Ltrim(str(round(embalagem,3)*1000,9,0)),9)		-- 04 Múltiplos - Observação 1
	   + right(replicate('0',9) + Ltrim(str(round(preco,3)*1000,9,0)),9) as texto	-- 05 Preço de Venda - Observação 2
  into ##barras
  from dbo.TabelaCodigosBarrasGZ(0) b
  inner join ##produtos p on p.PROCOD=b.codigo

-- quantidade de registros processados
select convert(float,@@rowcount) as q into ##q2

if (select q from ##q2)=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha ao carregar a tabela ##barras'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha ao carregar a tabela ##barras'
      
	  -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos códigos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\expgz\barp.txt" -c -T';
go


-- daqui pra baixo perde a referência das variáveis criadas


-- valida a quantidade de códigos de barras exportados, diferença deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integração GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select @q1=count(*)
  from
     openrowset(
	    'Microsoft.ACE.OLEDB.12.0'
		,'Text;Database=c:\integros\expgz;HDR=No;/r'
		,'select * from [barp.txt]'
	 )

set @q2=(select q from ##q2)

print 'Quantidade de códigos de barras exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS0103): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exportação dos Códigos de Barras. Arquivo c:\integros\expgz\barp.txt deletado'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exportação dos Códigos de Barras. Arquivo c:\integros\expgz\barp.txt deletado'

      exec xp_cmdshell 'del c:\integros\expgz\barp.txt'

      -- FORÇA UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go



-- tanby matriz

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\estp.txt \\192.168.1.209\cargas\estoque.ite';
go

exec xp_cmdshell 'move /y c:\integros\expgz\barp.txt \\192.168.1.209\cargas\barrarel.ite';
go

print 'Arquivos ESTOQUE.ITE e BARRAREL.ITE movidos com sucesso para a pasta \\192.168.1.209\cargas';
go


-- best bag

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\estp.txt \\192.168.0.14\importa\estoque.ite';
go

exec xp_cmdshell 'move /y c:\integros\expgz\barp.txt \\192.168.0.14\importa\barrarel.ite';
go

print 'Arquivos ESTOQUE.ITE e BARRAREL.ITE movidos com sucesso para a pasta \\192.168.0.14\importa';
go


select *
  from ##barras
 order by texto

select *
  from dbo.TabelaCodigosBarrasGZ(0)
 order by codigo

drop table ##produtos

select *
  from ##produtos
 where Len(rtrim(texto)) < 740

select *
  from ##precos
 where codigo='16310003'

drop table ##barras

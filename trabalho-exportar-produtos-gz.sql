-- vers�o antiga
-- EXEC master.dbo.xp_cmdshell 'bcp "select right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20) + right(replicate(''0'',20) + Ltrim(rtrim(T10.PROCOD)),20)+ replace(Left(T10.PRODES,40),'''','''') + replace(Left(T10.PRODES,24),'''','''') + ''N'' + T10.PROUM1 + replicate(''0'',4) + replicate(''0'',2) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) + replicate(''0'',9) + replicate(''0'',12) + ''A'' + T10.PROPESAVEL + ''N'' + ''N'' + replicate('' '',6) + right(''00'' + Ltrim(str(isnull(T10.TGZCOD,0),2)),2) + '' '' + right(replicate(''0'',7) + Ltrim(str(round(T10.PROUM1QTD,3)*1000,7,0)),7) + ''N'' + replicate(''0'',4) + ''N'' + replicate('' '',80) + replicate(''0'',9) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate('' '',40) + T10.PROSTBA+T10.PROSTBB + ''A'' + replicate(''0'',4) + replicate('' '',81) + replicate(''0'',4) + right(replicate(''0'',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7) + iif(PROPESAVEL=''S'',''N'',''S'') + replicate(''0'',4) + Left(Ltrim(iif(Len(T10.PROCLAFIS)=8,T10.PROCLAFIS,'''')) + replicate('' '',2),10) + replicate(''0'',12) + replicate('' '',4) + replicate(''0'',9) + replicate(''0'',7) + ''N'' + replicate(''0'',4) + replicate(''0'',12) + replicate(''0'',12) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',6) + replicate(''0'',8) + replicate('' '',1) + replicate(''0'',20) + replicate(''0'',3) + replicate(''0'',9) + replicate('' '',90) + replicate(''0'',2)  + replicate(''0'',6) + replicate('' '',1) + replicate('' '',1) + ''0'' + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + replicate(''0'',2) + ''N'' + replicate(''0'',3) + ''T'' + ''A'' + replicate(''0'',9) + replicate(''0'',3) + isnull((select iif(T10.PROSTBA in (''0'', ''3'', ''4'', ''5''), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),''.00'',''''))),4), right(replicate(''0'',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),''.00'',''''))),4)) from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),''000'') + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate('' '',4)) from SIBD.dbo.TBS023 with (nolock) where EMPCOD = 1) + ''N'' + replicate(''0'',4) + isnull((select NCMCHV from SIBD.dbo.TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''''),replicate('' '',10)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstpis from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + Ltrim(iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',''49'', isnull((select cstcofins from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('' '',2)))) + iif((select EMPCRT from SIBD.dbo.TBS023 with (nolock) where EMPCOD=1)=''1'',replicate(''0'',9), right(replicate(''0'',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from SIBD.dbo.PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(''0'',9)),9)),9)) + iif(Len(T10.PROCEST)=7,T10.PROCEST, replicate('' '',7)) + replicate(''0'',9) + replicate(''0'',9) + right(replicate(''0'',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) as texto from SIBD.dbo.TBS010 T10 with (nolock) where (select round(custo,3) from ##precos where codigo=T10.PROCOD) > 0 order by PROCOD" queryout "c:\integros\teste\estoque.txt" -c -t; -T';


-- vers�o atual

-- functions utilizadas

--> PrecoLojaGeral
--> PisCofins
--> TabelaCodigosBarrasGZ
--> PrecoLoja

-- CARGA GERAL DOS PRODUTOS

-- remove/recria a tabela tempor�ria de pre�os

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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
				+ '<p>Mensagem: N�o foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'N�o foi carregada a tabela ##precos'

      -- for�a um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com pre�os: ' + Ltrim(str(@q,9,0))

-- gera o arquivo tempor�rio para exporta��o dos produtos

-- remove/recria a tabela tempor�ria de produtos

if object_id('##produtos') is not null
   drop table ##produtos

-- lista de produtos exportados

select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 01 C�digo Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 02 C�digo de Barras - Observa��o 1
	   -- 03 Descri��o Completa
       --+ replace(Left(replace(T10.PRODES collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   + replace(Left(replace(iif(T10.PRODESPDV='',T10.PRODES,T10.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   -- 04 Descri��o Resumida para o PDV
       --+ replace(Left(replace(T10.PRODES collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
	   + replace(Left(replace(iif(T10.PRODESPDVRED='',T10.PRODES,T10.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
       + 'N'														-- 05 F�rmula - Observa��o 2
       + T10.PROUM1													-- 06 Unidade de Refer�ncia - Observa��o 3
	   + replicate('0',4)											-- 07 Arma��o / Localiza��o
	   + replicate('0',2)											-- 08 Setor ( Balan�a ) - Produto Pesado
	   
	   -- 09 Pre�o de Venda Padr�o
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)											-- 10 Pre�o de Venda Promocional - Observa��o 4
	   + replicate('0',12)											-- 11 Saldo em Estoque (Quantidade)
       + 'A'														-- 12 Desconto Padr�o - Observa��o 5
       --+ T10.PROPESAVEL												-- 13 Quantidade Vari�vel / Produto Pesado ? - S,N,E Observa��o 27
	   + iif(T10.PROUM1 in('KG','MT'),'S','N')						-- 13 Quantidade Vari�vel / Produto Pesado ? - S,N,E Observa��o 27
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
       --+ iif(PROPESAVEL='S','N','S')								-- 25 Bloqueia Venda Fracionada ? - Observa��o 14
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')						-- 25 Bloqueia Venda Fracionada ? - Observa��o 14
	   + replicate(' ',40)											-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB									-- 27 Situa��o Tribut�ria - Tabela 2
       + 'A'														-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)											-- 29 C�digo do Vasilhame - Observa��o 15
	   + replicate(' ',81)											-- 30 Reservado - Espa�o em Branco
	   + replicate('0',4)											-- 31 Percentual Desconto M�ximo Permitido - Observa��o 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observa��o 10
       
	   --+ iif(PROPESAVEL='S','N','S')													-- 33 Vende S� Embal. Fechada ? (Atacado) - Observa��o 11
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')											-- 33 Vende S� Embal. Fechada ? (Atacado) - Observa��o 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observa��o 12
       
	   -- 35 Classifica��o Fiscal
	   + iif(Len(Ltrim(T10.PROCLAFIS))=8,rtrim(T10.PROCLAFIS)+'  ', replicate(' ',10))

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
	   --+ replicate('0',6)																-- 46 Marca
	   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)							-- 46 Marca
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
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'0000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'														-- 70 Entreg�vel - S - Sim / N - N�o - Observa��o 31
	   + replicate('0',4)											-- 71 Carga Tribut�ria Estadual - Observa��o 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 74 Al�quota do PIS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   -- 75 CST do COFINS
	   + Ltrim(isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 76 Al�quota do COFINS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   + iif(Len(Ltrim(T10.PROCEST))=7,T10.PROCEST, replicate(' ',7))						-- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria - Observa��o 32

	   + replicate('0',9)															-- 78 Valor Unit�rio PIS - SAIDA
	   + replicate('0',9)															-- 79 Valor Unit�rio COFINS - SAIDA

       -- 80 Pre�o de Custo
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
      
	  -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\expgz\est.txt" -c -T';
go


-- daqui pra baixo perde a refer�ncia das vari�veis criadas


-- valida a quantidade de proudtos exportados, diferen�a deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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
				+ '<p>Mensagem: Falha na exporta��o dos Produtos. Arquivo c:\integros\expgz\est.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exporta��o dos Produtos. Arquivo c:\integros\expgz\est.txt deletado.'
      exec xp_cmdshell 'del c:\integros\expgz\est.txt'

      -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go

-- fim carga geral




-- c�digos de barras

-- remove/recria a tabela tempor�ria de pre�os

if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go

if object_id('tempdb.dbo.##q2') is not null
   drop table tempdb.dbo.##q2
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Geral de Produtos Para Sistema GZ'

select right(replicate('0',20) + Ltrim(rtrim(codigo)),20)							-- 01 C�digo do Produto Principal (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(barras)),20)							-- 02 C�digo de Barras do Produto
	   + replicate(' ',40)															-- 03 Observa��o
	   + right(replicate('0',9) + Ltrim(str(round(embalagem,3)*1000,9,0)),9)		-- 04 M�ltiplos - Observa��o 1
	   + right(replicate('0',9) + Ltrim(str(round(preco,3)*1000,9,0)),9) as texto	-- 05 Pre�o de Venda - Observa��o 2
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
      
	  -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos c�digos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\expgz\bar.txt" -c -T';
go


-- daqui pra baixo perde a refer�ncia das vari�veis criadas


-- valida a quantidade de c�digos de barras exportados, diferen�a deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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

print 'Quantidade de c�digos de barras exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS0103): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exporta��o dos C�digos de Barras. Arquivo c:\integros\expgz\bar.txt deletado'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exporta��o dos C�digos de Barras.'

      exec xp_cmdshell 'del c:\integros\expgz\bar.txt'

      -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
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


-- tanby taubat�

-- /opt/gz/importa

-- move os arquivos criados
exec xp_cmdshell 'move /y c:\integros\expgz\est.txt \\192.168.3.240\importa\estoque.txt';
go

exec xp_cmdshell 'move /y c:\integros\expgz\bar.txt \\192.168.3.240\importa\barrarel.txt';
go

print 'Arquivos ESTOQUE.TXT e BARRAREL.TXT movidos com sucesso para a pasta \\192.168.3.240\importa';
go


declare @SQLemail varchar(max), @@msg varchar(max)
	
set @@msg='<p>Nome do trabalho: Exporta produtos para integra��o com Sistema GZ'  + (select '<p>Executado em: ' + convert(varchar(max),getdate())) + '<p>Mensagem: N�o foi carregada a tabela ##precos'

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

-- remove/recria a tabela tempor�ria de pre�os

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'

select * into ##precos from PrecoLojaGeral(0)

set @q=@@ROWCOUNT

if @q=0
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: N�o foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'N�o foi carregada a tabela ##precos'

      -- for�a um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com pre�os: ' + Ltrim(str(@q,9,0))

-- lista de produtos exportados

select right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 01 C�digo Interno do Produto (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(T10.PROCOD)),20)		-- 02 C�digo de Barras - Observa��o 1
	   -- 03 Descri��o Completa
	   + replace(Left(replace(iif(T10.PRODESPDV='',T10.PRODES,T10.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')
	   -- 04 Descri��o Resumida para o PDV
	   + replace(Left(replace(iif(T10.PRODESPDVRED='',T10.PRODES,T10.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')
       + 'N'														-- 05 F�rmula - Observa��o 2
       + T10.PROUM1													-- 06 Unidade de Refer�ncia - Observa��o 3
	   + replicate('0',4)											-- 07 Arma��o / Localiza��o
	   + replicate('0',2)											-- 08 Setor ( Balan�a ) - Produto Pesado
	   
	   -- 09 Pre�o de Venda Padr�o
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9)

	   + replicate('0',9)											-- 10 Pre�o de Venda Promocional - Observa��o 4
	   + replicate('0',12)											-- 11 Saldo em Estoque (Quantidade)
       + 'A'														-- 12 Desconto Padr�o - Observa��o 5
       --+ T10.PROPESAVEL												-- 13 Quantidade Vari�vel / Produto Pesado ? - S,N,E Observa��o 27
	   + iif(T10.PROUM1 in('KG','MT'),'S','N')						-- 13 Quantidade Vari�vel / Produto Pesado ? - S,N,E Observa��o 27
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
       --+ iif(PROPESAVEL='S','N','S')								-- 25 Bloqueia Venda Fracionada ? - Observa��o 14
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')						-- 25 Bloqueia Venda Fracionada ? - Observa��o 14
	   + replicate(' ',40)											-- 26 Referencia
       + T10.PROSTBA+T10.PROSTBB									-- 27 Situa��o Tribut�ria - Tabela 2
       + 'A'														-- 28 Estado do Produto - A - Ativo / I - Inativo
	   + replicate('0',4)											-- 29 C�digo do Vasilhame - Observa��o 15
	   + replicate(' ',81)											-- 30 Reservado - Espa�o em Branco
	   + replicate('0',4)											-- 31 Percentual Desconto M�ximo Permitido - Observa��o 16
	   
	   --+ str(round(T10.PROUM2QTD,3),7,3)
       + right(replicate('0',7) + Ltrim( str(round(T10.PROUM2QTD,3)*1000,7,0)),7)		-- 32 Quantidade por Embalagem (Atacado) - Observa��o 10
       
	   --+ iif(PROPESAVEL='S','N','S')													-- 33 Vende S� Embal. Fechada ? (Atacado) - Observa��o 11
	   + iif(T10.PROUM1 in('KG','MT'),'N','S')											-- 33 Vende S� Embal. Fechada ? (Atacado) - Observa��o 11
	   + replicate('0',4)																-- 34 Desconto por Embal. Fechada(Atacado) - Observa��o 12
       
	   -- 35 Classifica��o Fiscal
	   + iif(Len(Ltrim(T10.PROCLAFIS))=8,rtrim(T10.PROCLAFIS)+'  ', replicate(' ',10))

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
	   --+ replicate('0',6)																-- 46 Marca
	   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)							-- 46 Marca
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
	   + isnull((select iif(T10.PROSTBA in ('0', '3', '4', '5'), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALINAC*100,0)),'.00',''))),4), right(replicate('0',4) + Ltrim(rtrim(replace(convert(char(9),round(NCMALIIMP*100,0)),'.00',''))),4)) from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),'0000')

	   + (select iif(EMPCRT=1,T10.PROSTBA+T10.PROCSN, replicate(' ',4)) from TBS023 with (nolock) where EMPCOD = 1)	-- 69 CSOSN

	   + 'N'														-- 70 Entreg�vel - S - Sim / N - N�o - Observa��o 31
	   + replicate('0',4)											-- 71 Carga Tribut�ria Estadual - Observa��o 30

	   -- 72 Chave Tabela IBPT
	   + isnull((select NCMCHV from TBS092 with (nolock) where NCMCOD=T10.PROCLAFIS and NCMEX=''),replicate(' ',10))

	   -- 73 CST do PIS
	   + Ltrim(isnull((select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 74 Al�quota do PIS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqpis,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   -- 75 CST do COFINS
	   + Ltrim(isnull((select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate(' ',2)))

       -- 76 Al�quota do COFINS
	   + right(replicate('0',9) + Ltrim( str(isnull((select round(aliqcofins,2)*100 from PisCofins(T10.PROEMPCOD, T10.PROCOD)),replicate('0',9)),9)),9)

	   + iif(Len(Ltrim(T10.PROCEST))=7,T10.PROCEST, replicate(' ',7))						-- 77 CEST - C�digo Especificador da Substitui��o Tribut�ria - Observa��o 32

	   + replicate('0',9)															-- 78 Valor Unit�rio PIS - SAIDA
	   + replicate('0',9)															-- 79 Valor Unit�rio COFINS - SAIDA

       -- 80 Pre�o de Custo
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
				+ '<p>Mensagem: N�o foram encontrados Produtos inclu�dos/alterados para serem exportados'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'N�o foram encontrados Produtos inclu�dos/alterados para serem exportados'
      
	  -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\integros\expgz\estp.txt" -c -T';
go


-- daqui pra baixo perde a refer�ncia das vari�veis criadas


-- valida a quantidade de proudtos exportados, diferen�a deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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
				+ '<p>Mensagem: Falha na exporta��o dos Produtos. Arquivo c:\integros\expgz\estp.txt deletado.'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exporta��o dos Produtos. Arquivo c:\integros\expgz\estp.txt deletado.'
      exec xp_cmdshell 'del c:\integros\expgz\estp.txt'

      -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end
go


-- c�digos de barras

-- remove/recria a tabela tempor�ria de pre�os

if object_id('##precos') is not null
   drop table ##precos
go

declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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
				+ '<p>Mensagem: N�o foi carregada a tabela ##precos'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''', 
						@body_format = ''html'',
						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'N�o foi carregada a tabela ##precos'

      -- for�a um erro para parar o processo
      select * from parada_forcada
   end

print 'Quantidade de produtos com pre�os: ' + Ltrim(str(@q,9,0))

-- remove/recria a tabela tempor�ria de pre�os

if object_id('##produtos') is not null
   drop table ##produtos
go
-- devido ao "go" acima, perde refer�ncia de vari�veis


declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'


select T10.PROCOD
   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and T10.TGZCOD > 0
	   and (select round(custo,3) from dbo.vw_PrecoLojaGeral where codigo=T10.PROCOD) > 0
	   and (
	          T10.PRODATCAD >= convert(date,getdate())
			  or T10.PRODATALT >= convert(date,getdate())
			  or (select atualizado from dbo.vw_PrecoLojaGeral where codigo=T10.PROCOD) >= convert(date,getdate())
           )
 order by PROCOD

set @q=@@ROWCOUNT

print 'Quantidade de produtos inclu�dos/alterados: ' + Ltrim(str(@q,9,0))

if @q=0
--if @q <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: N�o foram encontrados Produtos inclu�dos/alterados para serem exportados'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'N�o foram encontrados Produtos inclu�dos/alterados para serem exportados'

	  -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- remove/recria a tabela tempor�ria de c�digos de barras

if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go

if object_id('tempdb.dbo.##q2') is not null
   drop table tempdb.dbo.##q2
go

--declare @q int
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
set @mailto='cristiano@integros.com.br'
set @empresa=(select '<p>Emprensa: ' + rtrim(EMPNOMFAN) from TBS023 with (nolock) where (EMPNOM Like('TANBY%') and EMPCOD=1) or (EMPNOM Like('BEST BAG%') and EMPCOD=2))
set @trabalho='<p>Nome do trabalho: Carga Parcial de Produtos Para Sistema GZ'

select right(replicate('0',20) + Ltrim(rtrim(codigo)),20)							-- 01 C�digo do Produto Principal (PLU)
       + right(replicate('0',20) + Ltrim(rtrim(barras)),20)							-- 02 C�digo de Barras do Produto
	   + replicate(' ',40)															-- 03 Observa��o
	   + right(replicate('0',9) + Ltrim(str(round(embalagem,3)*1000,9,0)),9)		-- 04 M�ltiplos - Observa��o 1
	   + right(replicate('0',9) + Ltrim(str(round(preco,3)*1000,9,0)),9) as texto	-- 05 Pre�o de Venda - Observa��o 2
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
      
	  -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
      select * from parada_forcada
   end

-- gera o arquivo texto dos c�digos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\expgz\barp.txt" -c -T';
go


-- daqui pra baixo perde a refer�ncia das vari�veis criadas


-- valida a quantidade de c�digos de barras exportados, diferen�a deve ser menor do que 1%

declare @q1 float, @q2 float
declare @SQLemail varchar(max), @msg varchar(max), @mailto varchar(max), @empresa varchar(60), @trabalho varchar(max), @titulo varchar(max)

set @titulo='Falha no Trabalho de Integra��o GZ'
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

print 'Quantidade de c�digos de barras exportados: ' + Ltrim(str(@q1,9,0))
print 'Quantidade de produtos no cadastro (TBS0103): ' + Ltrim(str(@q2,9,0))

if ((1-@q1/@q2) * 100) >= 1
--if ((1-@q1/@q2) * 100) <= 100000
   begin
	  set @msg=@trabalho
	            + (select '<p>Executado em: ' + convert(varchar(max),getdate()))
				+ '<p>Mensagem: Falha na exporta��o dos C�digos de Barras. Arquivo c:\integros\expgz\barp.txt deletado'
				+ @empresa

      set @SQLemail='execute msdb.dbo.sp_send_dbmail
                        @profile_name = ''Email'',
						@recipients = ''' + @mailto + ''',
						@body_format = ''html'',
   						@subject = ''' + @titulo + ''',
						@body = ''' + @msg + ''''

      exec(@sqlEmail)

      print 'Falha na exporta��o dos C�digos de Barras. Arquivo c:\integros\expgz\barp.txt deletado'

      exec xp_cmdshell 'del c:\integros\expgz\barp.txt'

      -- FOR�A UM ERRO PARA PARAR O PROCESSAMENTO
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


-- otimização exportação barrarel

drop table #produtos

select cast(getdate()-1 as date)

-- Define a data de hoje apenas uma vez
declare @hoje date = convert(date, getdate());

-- Seleciona produtos relevantes
select pro.PROCOD
       ,Left(iif(pro.PRODESPDV='', Ltrim(pro.PRODES), Ltrim(pro.PRODESPDV)),40) collate sql_latin1_general_cp1251_ci_as as PRODES
  into #produtos
  from TBS010 as pro with (nolock)
 inner join dbo.vw_PrecoLojaGeral as pre
         on pre.codigo = pro.PROCOD
 where pro.TGZCOD > 0
       and round(pre.custo, 3) > 0
       and (
             pro.PRODATCAD = '20251118'
             or pro.PRODATALT = '20251118'
             or pre.atualizado = '20251118'
           )
 order by pro.PROCOD

-- Gera tabela de barras com formatação
select Ltrim(rtrim(bar.barras)) as codigoBarras			            -- 1. codigoBarras
       ,Ltrim(rtrim(bar.codigo)) as codigoProduto                     -- 2. codigoProduto
	   ,pro.PRODES as descricao													-- 3. descricao
	   ,800 as lojas												-- 4. lojas
       ,round(bar.preco,3) as preco									-- 5. preco
	   ,round(bar.embalagem,3) as quantidade							-- 6. quantidade
--INTO #barras
  from dbo.vw_TabelaCodigosBarrasGZ as bar
 inner join #produtos as pro
         on pro.PROCOD = bar.codigo;

select barras as codigoBarras
  from #barras

-- código de barras novos

drop table #produtos

select pro.PROCOD
       ,iif(pro.PRODESPDV='', Ltrim(pro.PRODES), Ltrim(pro.PRODESPDV)) collate sql_latin1_general_cp1251_ci_as as PRODES
  into #produtos
  from TBS0103 bar with (nolock)
 inner join TBS010 as pro with (nolock)
         on pro.PROCOD = bar.CBPPROCOD
 inner join dbo.vw_PrecoLojaGeral as pre
         on pre.codigo = bar.CBPPROCOD
 where pro.TGZCOD > 0
       and round(pre.custo, 3) > 0
	   and bar.CBPDATCAD = '20251118'

-- códigos de barras ou preços alterados

select bar.CBPPROCOD
       ,iif(pro.PRODESPDV='', Ltrim(pro.PRODES), Ltrim(pro.PRODESPDV)) collate sql_latin1_general_cp1251_ci_as as PRODES
  --into #produtos
  from TBS0103 bar with (nolock)
 inner join TBS010 as pro with (nolock)
         on pro.PROCOD = bar.CBPPROCOD
 inner join dbo.vw_PrecoLojaGeral as pre
         on pre.codigo = bar.CBPPROCOD
 where pro.TGZCOD > 0
       and round(pre.custo, 3) > 0
       and (
             pro.PRODATALT >= '20251117'
             or pre.atualizado >= '20251117'
           )


-- 02/04/2026

-- Carga Geral de Produtos Para Sistema GZ

-- remove/recria a tabela temporária de preços

if object_id('tempdb.dbo.###precos') is not null
begin
	drop table ##precos
end

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

if object_id('tempdb.dbo.###produtos') is not null
begin
	drop table ##produtos
end

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
                   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)							   					-- 46 Marca
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
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) --as texto

	   + replicate('0',8)															-- 81 Data de Início de Promoção
	   + replicate('0',8)															-- 82 Data de Fim da Promoção
	   + replicate('0',5)															-- 83 Percentual de comissão
	   + replicate(' ',128)															-- 84 Mensagem complementar do Produto
	   + replicate('0',3)															-- 85 Loja
	   + replicate('0',9)															-- 86 Código de Produto ANP
	   + replicate('0',9)															-- 87 Alíquota de FCP
	   + replicate('0',9)															-- 88 Alíquota de FCP ST
	   + replicate('0',9)															-- 89 Alíquota de FCP Retido
	   + replicate('0',20)															-- 90 Código GTIN
	   + replicate('0',8)															-- 91 Data de alteração
	   + replicate('0',3)															-- 92 Dias de validade
	   + replicate('0',6)															-- 93 Código da informação nutricional
	   
	   -- 94 Código do Benefício Fiscal
	   + iif(T10.PROSTBB in ('20','30','40','41','50','51','70','90'), 'SEM CBENEF', replicate('',10)) as texto

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

--------------------------------------------
-- Carga Parcial de Produtos Para Sistema GZ

-- remove/recria a tabela temporária de preços

if object_id('tempdb.dbo.###precos') is not null
begin
	drop table ##precos
end

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

-- remove/recria a tabela temporária de produtos

if object_id('tempdb.dbo.###produtos') is not null
begin
	drop table ##produtos
end

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
	   + right('000000' + Ltrim(str(isnull(T10.MARCOD,0),4)),6)												-- 46 Marca
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
	   + right(replicate('0',9) + Ltrim(str(isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)*1000,9,0)),9) --as texto

	   + replicate('0',8)															-- 81 Data de Início de Promoção
	   + replicate('0',8)															-- 82 Data de Fim da Promoção
	   + replicate('0',5)															-- 83 Percentual de comissão
	   + replicate(' ',128)															-- 84 Mensagem complementar do Produto
	   + replicate('0',3)															-- 85 Loja
	   + replicate('0',9)															-- 86 Código de Produto ANP
	   + replicate('0',9)															-- 87 Alíquota de FCP
	   + replicate('0',9)															-- 88 Alíquota de FCP ST
	   + replicate('0',9)															-- 89 Alíquota de FCP Retido
	   + replicate('0',20)															-- 90 Código GTIN
	   + replicate('0',8)															-- 91 Data de alteração
	   + replicate('0',3)															-- 92 Dias de validade
	   + replicate('0',6)															-- 93 Código da informação nutricional
	   
	   -- 94 Código do Benefício Fiscal
	   + iif(T10.PROSTBB in ('20','30','40','41','50','51','70','90'), 'SEM CBENEF', replicate('',10)) as texto

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
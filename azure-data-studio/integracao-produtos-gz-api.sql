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

-- integração via api

select 0																																			--  1. aliqFcp
       ,0																																			--  2. aliqFcpRet
       ,0																																			--  3. aliqFcpSt
       ,0																																			--  4. aliquotaCofinsCompra
       ,(select aliqcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD))																				--  5. aliquotaCofinsVenda
       ,0																																			--  6. aliquotaIcmsCompra
       ,0																																			--  7. aliquotaIpiVenda
       ,0																																			--  8. aliquotaPisCompra
       ,(select aliqpis from PisCofins(T10.PROEMPCOD, T10.PROCOD))																					--  9. aliquotaPisVenda
       ,0																																			-- 10. armacao
       ,iif(Len(Ltrim(T10.PROCEST))=7,T10.PROCEST, '')																								-- 11. cest
       ,Ltrim(rtrim(T10.PROCOD))																													-- 12. codigo
       ,0																																			-- 13. codigoAnp
       ,''																																			-- 14. codigoBeneficiario
       ,''																																			-- 15. codigoParaEntidade
       ,'S'																																			-- 16. contSaldo
       ,''																																			-- 17. csosnIcmsCompra
       ,''																																			-- 18. cstCofinsCompra
       ,(select cstcofins from PisCofins(T10.PROEMPCOD, T10.PROCOD))																				-- 19. cstCofinsVenda
       ,0																																			-- 20. cstIcmsCompra
       ,''																																			-- 21. cstIpiVenda
       ,''																																			-- 22. cstPisCompra
       ,(select cstpis from PisCofins(T10.PROEMPCOD, T10.PROCOD))																					-- 23. cstPisVenda
       ,''																																			-- 24. dataInicioPromocao
       ,''																																			-- 25. dataTerminoPromocao
       ,0																																			-- 26. departamento
       ,replace(Left(replace(iif(T10.PRODESPDV='',T10.PRODES,T10.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','')			-- 27. descricao
       ,''																																			-- 28. descricaoBalanca
       ,replace(Left(replace(iif(T10.PRODESPDVRED='',T10.PRODES,T10.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','')		-- 29. descricaoResumida
       ,Ltrim(rtrim(T10.PROCOD))																																			-- 30. ean
       ,''																																			-- 31. eanParaEntidade
       ,''																																			-- 32. enquadramentoIpi
       ,0																																			-- 33. especie
       ,0																																			-- 34. fornecedor
       ,0																																			-- 35. grupo
	    ,''																																			-- 36. gtin
       ,''																																			-- 37. gtinParaEntidade
       ,''																																			-- 38. icmsCompra
       ,''																																			-- 39. icmsDesonerado
       ,'T'																																			-- 40. ippt
	   ,800																																			-- 41. lojas
       ,0																																			-- 42. marca
       ,'N'																																			-- 43. naoPesarSelf
       ,''																																			-- 44. natReceita
       ,iif(Len(Ltrim(T10.PROCLAFIS))=8,rtrim(T10.PROCLAFIS), '')																					-- 45. ncm
       ,T10.PROSTBA																																	-- 46. origem
       ,0																																			-- 47. percComissao
       ,0																																			-- 48. pesoBruto
       ,0																																			-- 49. pesoLiquido
       ,0																																			-- 50. precoAtacado
       ,0																																			-- 51. precoCaixa
       ,0																																			-- 52. precoCompra
       --,isnull((select round(custo,3) from ##precos where codigo=T10.PROCOD),0)																		-- 53. precoCusto
	   ,isnull((SELECT round(custo,3) from dbo.vw_PrecoLojaGeral where codigo=T10.PROCOD),0)
       ,0																																			-- 54. precoEspecial
       ,0																																			-- 55. precoMaximo
       ,0																																			-- 56. precoMinimo
       ,0																																			-- 57. precoPromocao
       --,isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)																	-- 58. precoTerminal
	   ,isnull((SELECT round(preco1,3) from dbo.vw_PrecoLojaGeral where codigo=T10.PROCOD),0)
       --,isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)																	-- 59. precoVenda
	   ,isnull((SELECT round(preco1,3) from dbo.vw_PrecoLojaGeral where codigo=T10.PROCOD),0)
       ,0																																			-- 60. quantidadeEstoque
       ,''																																			-- 61. referencia
       ,0																																			-- 62. setor
       ,'ATIVO'																																		-- 63. situacao
       ,'N'																																			-- 64. soInteiro
       ,'N'																																			-- 65. solicitaSenha
       ,0																																			-- 66. tipoCalcBcFcp
       ,0																																			-- 67. tipoCalcBcFcpSt
       ,1																																			-- 68. tributacao
       ,T10.PROUM1																																	-- 69. unidade
       ,0																																			-- 70. valorUnitCofinsCompra
       ,0																																			-- 71. valorUnitCofinsVenda
       ,0																																			-- 72. valorUnitPisCompra
       ,0																																			-- 73. valorUnitPisVenda
       ,''																																			-- 74. variavel

  from TBS010 T10 with (nolock)
 where T10.PRODATCAD = '20251112'

select *
  from dbo.vw_PrecoLojaGeral
 where codigo='1080067'

-- otimizada

select
       0                               as aliqFcp
      ,0                               as aliqFcpRet
      ,0                               as aliqFcpSt
      ,0.9                             as aliquotaCbs -- ***
      ,0                               as aliquotaCofinsCompra
      ,pc.aliqcofins                   as aliquotaCofinsVenda
      ,0.1                             as aliquotaIbsUf -- ***
      ,0                               as aliquotaIcmsCompra
      ,0                               as aliquotaIpiVenda
      ,0                               as aliquotaIs -- ***
      ,0                               as aliquotaPisCompra
      ,pc.aliqpis                      as aliquotaPisVenda
      ,0                               as armacao
      ,iif(len(ltrim(pro.PROCEST))=7, pro.PROCEST, '') AS cest
      --,(select cClassTrib from dbo.fn_RetornaTributacaoProduto(0, p.PROCOD))                              as classificacaoTributariaIbsCbs -- ***
      ,trib.cClassTrib                              as classificacaoTributariaIbsCbs -- ***
      ,''                              as classificacaoTributariaIs -- ***
      ,ltrim(rtrim(pro.PROCOD))        as codigo
      ,0                               as codigoAnp
      ,''                              as codigoBeneficiario
      ,''                              as codigoParaEntidade
      ,'S'                             as contSaldo
      ,''                              as csosnIcmsCompra
      ,''                              as cstCofinsCompra
      ,pc.cstcofins                    as cstCofinsVenda
      --,(select CST from dbo.fn_RetornaTributacaoProduto(0, p.PROCOD))                              as cstIbs -- ***
      ,trib.CST                              as cstIbs -- ***
      --,(select CST from dbo.fn_RetornaTributacaoProduto(0, p.PROCOD))                              as cstIbsUf -- ***
      ,trib.CST                              as cstIbsUf -- ***
      ,0                               as cstIcmsCompra
      ,''                              as cstIpiVenda
      ,''                              as cstIs -- ***
      ,''                              as cstPisCompra
      ,pc.cstpis                       as cstPisVenda
      ,''                              as dataInicioPromocao
      ,''                              as dataTerminoPromocao
      ,0                               as departamento
      --,replace(left(replace(iif(pro.PRODESPDV='',pro.PRODES,pro.PRODESPDV) collate sql_latin1_general_cp1251_ci_as,'''',''),40),'''','') as descricao
      ,Left(Ltrim(iif(pro.PRODESPDV='',pro.PRODES,pro.PRODESPDV)),40) collate sql_latin1_general_cp1251_ci_as as descricao
      ,'' as descricaoBalanca
      --,replace(left(replace(iif(pro.PRODESPDVRED='',pro.PRODES,pro.PRODESPDVRED) collate sql_latin1_general_cp1251_ci_as,'''',''),24),'''','') as descricaoResumida
      ,Left(Ltrim(iif(pro.PRODESPDVRED='',pro.PRODES,pro.PRODESPDVRED)),24) collate sql_latin1_general_cp1251_ci_as as descricaoResumida
      ,ltrim(rtrim(pro.PROCOD))        as ean
      ,''                              as eanParaEntidade
      ,''                              as enquadramentoIpi
      ,0                               as especie
      ,0                               as fornecedor
      ,0                               as grupo
      ,''                              as gtin
      ,''                              as gtinParaEntidade
      ,''                              as icmsCompra
      ,''                              as icmsDesonerado
      ,'T'                             as ippt
      ,800                             as lojas
      ,0                               as marca
      ,'N'                             as naoPesarSelf
      ,''                              as natReceita
      ,iif(len(ltrim(pro.PROCLAFIS))=8, rtrim(pro.PROCLAFIS), '') as ncm
      ,pro.PROSTBA                     as origem
      ,0                               as percComissao
      ,trib.redCBS                               as percentualReducaoDeBaseCbs -- ***
      ,trib.redIBS                               as percentualReducaoDeBaseIbsMunicipal -- ***
      ,trib.redIBS                               as percentualReducaoDeBaseIbsUf -- ***
      ,0                               as pesoBruto
      ,0                               as pesoLiquido
      ,0                               as precoAtacado
      ,0                               as precoCaixa
      ,0                               as precoCompra

      ,isnull( round(pre.custo,3), 0 )  as precoCusto
      ,0                               as precoEspecial
      ,0                               as precoMaximo
      ,0                               as precoMinimo
      ,0                               as precoPromocao

      ,isnull( round(pre.preco1,3), 0 ) as precoTerminal
      ,isnull( round(pre.preco1,3), 0 ) as precoVenda

      ,0                               as quantidadeEstoque
      ,''                              as referencia
      ,0                               as setor
      ,'ATIVO'                         as situacao
      ,iif(pro.PROUM1 in('KG','MT'),'S','N') as soInteiro
      ,'N'                             as solicitaSenha
      ,0                               as tipoCalcBcFcp
      ,0                               as tipoCalcBcFcpSt
      ,pro.TGZCOD                      as tributacao
      ,pro.PROUM1                      as unidade
      ,0                               as valorUnitCofinsCompra
      ,0                               as valorUnitCofinsVenda
      ,0                               as valorUnitPisCompra
      ,0                               as valorUnitPisVenda
      ,''                              as variavel

from TBS010 pro with (nolock)
left join dbo.vw_PrecoLojaGeral pre
       on pre.codigo = pro.PROCOD
outer apply dbo.fn_RetornaTributacaoProduto(0, pro.PROCOD) trib
outer apply PisCofins(pro.PROEMPCOD, pro.PROCOD) pc
where pre.preco1 > 0
      -- incluir
      and pro.PRODATCAD between '20251219' and '20251219'
      -- atualizar
      and (
            pro.PRODATALT between '20251212' and '20251212'
            or pre.atualizado between '20251212' and '20251212'
         )

--

-- trabalho atual

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


drop function fn_RetornaTributacaoProduto;
go

CREATE FUNCTION dbo.fn_RetornaTributacaoProduto
(
    @PROEMPCOD INT,
    @PROCOD    VARCHAR(15)
)
RETURNS TABLE
AS
RETURN
(
    WITH Produto AS
    (
        SELECT
            p.PROEMPCOD,
            p.PROCOD,
            p.PROANEIBSCBS,
            p.PROCLAFIS,
            p.CICCST,
            p.CICCCLASSTRIB
        FROM TBS010 p with (nolock)
        WHERE p.PROEMPCOD = @PROEMPCOD
          AND p.PROCOD    = @PROCOD
    ),
    TributacaoProduto AS
    (
        SELECT
            c.CICTRIBUT      AS Tributado,
            c.CICCST         AS CST,
            c.CICCCLASSTRIB  AS cClassTrib,
            c.CICREDIBS      AS redIBS,
            c.CICREDCBS      AS redCBS
        FROM TBS159 c with (nolock)
        INNER JOIN Produto p
            ON p.CICCST = c.CICCST
           AND p.CICCCLASSTRIB = c.CICCCLASSTRIB
        WHERE c.CICCST <> ''
          AND c.CICCCLASSTRIB <> ''
    ),
    TributacaoNCM AS
    (
        SELECT
            'S'                 AS Tributado,
            n.NCMCSTIBSCBS      AS CST,
            n.NCMCCLASTRIB      AS cClassTrib,
            n.NCMREDALIIBS      AS redIBS,
            n.NCMREDALICBS      AS redCBS
        FROM Produto p
        INNER JOIN TBS0922 n with (nolock)
            ON n.NCMCOD        = p.PROCLAFIS
           AND n.NCMEX         = ''
           AND n.NCMANEIBSCBS  = p.PROANEIBSCBS
        WHERE p.PROANEIBSCBS > 0
    ),
    TributacaoPadrao as
    (
      select cst.CICTRIBUT as Tributado
             ,rf.CICCST    as CST
             ,rf.CICCCLASSTRIB as cClassTrib
             ,cst.CICREDIBS    as redIBS
             ,cst.CICREDCBS    as redCBS
        from TBS158 rf with (nolock)
       inner join TBS159 cst with (nolock)
               on cst.CICCST = rf.CICCST
                  and cst.CICCCLASSTRIB = rf.CICCCLASSTRIB
       where rf.RFIEMPCOD = 0
             and rf.RFICOD = 1
    )
    -- prioridade:
    -- 1) tributação específica do produto
    -- 2) tributação por NCM
    SELECT *
    FROM TributacaoProduto

    UNION ALL

    SELECT *
    FROM TributacaoNCM
    WHERE NOT EXISTS (SELECT 1 FROM TributacaoProduto)

    union all
    select *
      from TributacaoPadrao
     where not exists (select 1 from TributacaoProduto)
           and not exists (select 1 from TributacaoNCM)
);
GO

SELECT *
FROM dbo.fn_RetornaTributacaoProduto(0, '0129048');


select top(100) *
  from TBS0103 B with (nolock)
 where B.CBPDATALT <> '17530101'

drop table #produtos

select pro.PROCOD
       ,Left(iif(pro.PRODESPDV='', Ltrim(pro.PRODES), Ltrim(pro.PRODESPDV)),40) collate sql_latin1_general_cp1251_ci_as as PRODES
  into #produtos
  from TBS0103 bar with (nolock)
 inner join TBS010 as pro with (nolock)
         on pro.PROCOD = bar.CBPPROCOD
 inner join dbo.vw_PrecoLojaGeral as pre
         on pre.codigo = bar.CBPPROCOD
 where pro.TGZCOD > 0
       and round(pre.custo, 3) > 0
       and bar.CBPDATALT between '20260201' and '20260304' --or pre.atualizado between '{data_de}' and '{data_ate}')"""

select *
  from #produtos



select
         0 as aliqFcp
        ,0 as aliqFcpRet
        ,0 as aliqFcpSt
        ,0.9                             as aliquotaCbs -- ***
        ,0 as aliquotaCofinsCompra
        ,pc.aliqcofins as aliquotaCofinsVenda
        ,0 as aliquotaIbsMunic
        ,0.1                             as aliquotaIbsUf -- ***
        ,0 as aliquotaIcmsCompra
        ,0 as aliquotaIpiVenda
        ,0                               as aliquotaIs -- ***
        ,0 as aliquotaPisCompra
        ,pc.aliqpis as aliquotaPisVenda
        ,0 as armacao
        ,iif(len(ltrim(pro.PROCEST))=7, pro.PROCEST, '') AS cest
        ,trib.cClassTrib                              as classificacaoTributariaIbsCbs -- ***
        ,''                              as classificacaoTributariaIs -- ***
        ,ltrim(rtrim(pro.PROCOD)) as codigo
        ,0 as codigoAnp
        ,'' as codigoBeneficiario
        ,'' as codigoParaEntidade
        ,'S' as contSaldo
        ,'' as csosnIcmsCompra
        ,'' as cstCofinsCompra
        ,pc.cstcofins as cstCofinsVenda
        --,trib.CST                              as cstIbs -- ***
        ,trib.CST                              as cstIbsUf -- ***
        ,0 as cstIcmsCompra
        ,'' as cstIpiVenda
        ,'98' as cstPisCompra
        ,pc.cstpis as cstPisVenda
        ,'' as dataInicioPromocao
        ,'' as dataTerminoPromocao
        ,0 as departamento
        ,Left(Ltrim(iif(pro.PRODESPDV='',pro.PRODES,pro.PRODESPDV)),40) collate sql_latin1_general_cp1251_ci_as as descricao
        ,'' as descricaoBalanca
        ,Left(Ltrim(iif(pro.PRODESPDVRED='',pro.PRODES,pro.PRODESPDVRED)),24) collate sql_latin1_general_cp1251_ci_as as descricaoResumida
        ,ltrim(rtrim(pro.PROCOD)) as ean
        ,'' as eanParaEntidade
        ,'' as enquadramentoIpi
        ,0 as especie
        ,0 as fornecedor
        ,0 as grupo
        ,'' as gtin
        ,'' as gtinParaEntidade
        ,'' as icmsCompra
        ,'' as icmsDesonerado
        ,'T' as ippt
        ,0 as lojas
        ,0 as marca
        ,'N' as naoPesarSelf
        ,'' as natReceita
        ,iif(len(ltrim(pro.PROCLAFIS))=8, rtrim(pro.PROCLAFIS), '') as ncm
        ,pro.PROSTBA as origem
        ,0 as percComissao
        ,trib.redCBS                               as percentualReducaoDeBaseCbs -- ***
        ,trib.redIBS                               as percentualReducaoDeBaseIbsMunicipal -- ***
        ,trib.redIBS                               as percentualReducaoDeBaseIbsUf -- ***
        ,0 as pesoBruto
        ,0 as pesoLiquido
        ,0 as precoAtacado
        ,0 as precoCaixa
        ,0 as precoCompra
        ,isnull(round(pre.custo,3), 0) as precoCusto
        ,0 as precoEspecial
        ,0 as precoMaximo
        ,0 as precoMinimo
        ,0 as precoPromocao
        ,isnull(round(pre.preco1,3), 0) as precoTerminal
        ,isnull(round(pre.preco1,3), 0) as precoVenda
        ,0 as quantidadeEstoque
        ,'' as referencia
        ,0 as setor
        ,'ATIVO' as situacao
        ,iif(pro.PROUM1 in('KG','MT'),'N','S') as soInteiro
        ,'N' as solicitaSenha
        ,0 as tipoCalcBcFcp
        ,0 as tipoCalcBcFcpSt
        ,pro.TGZCOD as tributacao
        ,pro.PROUM1 as unidade
        ,0 as valorUnitCofinsCompra
        ,0 as valorUnitCofinsVenda
        ,0 as valorUnitPisCompra
        ,0 as valorUnitPisVenda
        ,iif(pro.PROUM1 in('KG','MT'),'S','N') as variavel
    from TBS010 pro with (nolock)
    left join dbo.vw_PrecoLojaGeral pre on pre.codigo = pro.PROCOD
    outer apply dbo.fn_RetornaTributacaoProduto(0, pro.PROCOD) trib
    outer apply PisCofins(pro.PROEMPCOD, pro.PROCOD) pc
    where pre.preco1 > 0
          and cast(pro.PRODATALT as date) = '20250902'

select *
  from dbo.vw_PrecoLojaGeral

drop table #tab_estoque_gz

select --top(1000) cast(t.cdprod as char(20)) as cdprod
       top (1000)
       Ltrim(rtrim(t.cdprod))
       ,Ltrim(rtrim(t.codbarra))
       ,t.descricao
  --into #tab_estoque_gz
  from openrowset('Microsoft.ACE.OLEDB.12.0', 'Excel 12.0;Database=C:\integros\temp\estoque.xlsx', 'select * from [Estoque$]') t

select *
  from #tab_estoque_gz

select RIGHT('0000000' + LTRIM(RTRIM(t.cdprod)), 7) as cdprod
       ,LTRIM(RTRIM(t.codbarra)) as codbarra
       ,t.descricao
from openrowset(
       'Microsoft.ACE.OLEDB.12.0',
       'Excel 12.0;Database=C:\integros\temp\estoque.xlsx',
       'select * from [Estoque$]'
     ) t

select --top (1000)
       REPLICATE('0', CASE WHEN LEN(LTRIM(RTRIM(t.cdprod))) < 7 
                           THEN 7 - LEN(LTRIM(RTRIM(t.cdprod))) 
                           ELSE 0 END)
       + LTRIM(RTRIM(t.cdprod)) as cdprod,
       LTRIM(RTRIM(t.codbarra)) as codbarra,
       t.descricao
into #tab_estoque_gz       
from openrowset(
       'Microsoft.ACE.OLEDB.12.0',
       'Excel 12.0;Database=C:\integros\temp\estoque.xlsx',
       'select * from [Estoque$]'
     ) t

select p.PROCOD
       ,p.PRODES
  from TBS010 p with (nolock)
 where not exists (select 1 from #tab_estoque_gz g where g.cdprod collate database_default = p.PROCOD)






-- remove/recria a tabela temporária de clientes

if object_id('##clientes') is not null
   drop table ##clientes

select right(replicate('0',16) + Ltrim(rtrim(T2.CLICOD)),16)			-- 01 Código
       + Left(T2.CLINOM,50)												-- 02 Nome Completo
       + Left(T2.CLIEND,60)												-- 03 Endereço
       + Left(T2.CLIBAI,30)												-- 04 Bairro
       + Left(T3.MUNNOM,30)												-- 05 Cidade
       + Left(Ltrim(T2.UFESIG) + replicate(' ',2),2)					-- 06 Estado (UF)
	   + Left(Ltrim(replace(T2.CLICEP,'-','')) + replicate(' ',8),8)	-- 07 CEP
	   + Left(T2.CLITEL,15)												-- 08 Telefone

	   -- 09 CGC / CPF - Observação 1
	   + Left('0'+Ltrim(
	     iif(T2.CLITIPPES='J'
	        ,subString(T2.CLICGC,1,2)+'.'+subString(T2.CLICGC,3,3)+'.'+subString(T2.CLICGC,6,3)+'/'+subString(T2.CLICGC,9,4)+'-'+subString(T2.CLICGC,13,2)
		    ,subString(T2.CLICPF,1,3)+'.'+subString(T2.CLICPF,3,3)+'.'+subString(T2.CLICPF,7,3)+'-'+subString(T2.CLICPF,10,2)
		 )) + replicate(' ',19),19)

       + replicate('0',8)								-- 10 Data de Nascimento
	   + replicate('0',8)								-- 11 Data da Ultima Compra
	   + 'L'											-- 12 Situação
	   + replicate('0',12)								-- 13 Limite Total de Crédito para Compra Convênio (Fiado)
	   + replicate('0',12)								-- 14 Valor Total das Compras em Aberto no Convênio (Fiado)
	   + replicate('0',4)								-- 15 Percentual de Desconto Sobre o Cupom
	   + 'N'											-- 16 Desconto Sobre Produto em Promoção - S - Sim / N - Não
	   + 'N'											-- 17 Desconto Geral - Observação 3
	   + 'S'											-- 18 Permite Compra no Convênio (Fiado) - S - Sim / N - Não
	   + replicate(' ',80)								-- 19 Mensagem - Observação 4
	   + replicate('0',12)								-- 20 Limite Total de Crédito para Compra com Cheque (Valor)
	   + replicate('0',6)								-- 21 Limite Total de Crédito para Compra com Cheque (Quantidade)
	   + replicate('0',12)								-- 22 Valor Total das Compras em Aberto com Cheque (Valor)
	   + replicate('0',6)								-- 23 Valor Total das Compras em Aberto com Cheque (Quantidade)
	   + replicate(' ',80)								-- 24 Cartão / Código de Barras
	   + replicate(' ',40)								-- 25 Reservado - Espaço em Branco

	   -- 26 Inscrição Estadual / RG
	   + Left(Ltrim(iif(T2.CLITIPPES='J',T2.CLIIES,T2.CLIRG)) + replicate(' ',25),25)

	   + replicate('0',9)								-- 27 Pontuação Acumulada (Fidelidade)
	   + replicate(' ',2)								-- 28 Reservado - Espaço em Branco
	   + replicate(' ',10)								-- 29 Reservado - Espaço em Branco
	   + replicate('0',12)								-- 30 Valor da Ultima Compra
	   + replicate('0',12)								-- 31 Saldo para Recebimento de Conta
	   + replicate('0',6)								-- 32 Quantidade de Documentos em Aberto
	   + replicate(' ',90)								-- 33 Finalizadores de Venda Bloqueados - Observação 5
	   + 'P'											-- 34 Tabela de Preço a Utilizar - A – Atacado E – Especial P - Padrão
	   + replicate('0',2)								-- 35 Nível de Bloqueio - Observação 6
	   + Left(T2.CLINOMFAN,15)							-- 36 Nome Fantasia
	   + replicate(' ',20)								-- 37 Senha do Cliente - Observação 7
	   + replicate('0',2)								-- 38 Dia para Vencimento do Convênio - Observação 8
	   + replicate('0',3)								-- 39 Dias para Cálculo do Vencimento do Convênio - Observação 9
	   + replicate(' ',2)								-- 40 Condição para Cálculo do Vencimento - Observação 10
	   + replicate('0',2)								-- 41 Melhor Dia para Compra - Observação 11
	   + replicate(' ',40)								-- 42 Contato / 2ª Pessoa Autorizada
	   + replicate(' ',15)								-- 43 Tipo do Endereço - Rua, Avenida,Trav.,

	   -- 44 Numero do Endereço
	   + right(replicate('0',6) + Ltrim(rtrim(iif(isNumeric(T2.CLINUM)=1 and T2.CLINUM Like('%[0-9]%') and T2.CLINUM not Like('%E%') and T2.CLINUM not Like('%,%') and T2.CLINUM not Like('%.%'),T2.CLINUM,0))),6)

	   + Left(T2.CLICPLEND,20)							-- 45 Complemento - Casa, Apto, Bloco, ...
	   + replicate(' ',20)								-- 46 País - Nome do país
	   + replicate('0',4)								-- 47 Código do país - Código do país

	   -- 48 Código do município (IBGE)
	   + right(replicate('0',7) + Ltrim(rtrim(T2.MUNCOD)),7)

	   + Left(Ltrim(Lower(T2.CLIEMAIL)) + replicate(' ',100),100)	-- 49 E-mail
	   + 'N'														-- 50 Inclusão de Percentual de Acréscimo em vendas a PRAZO - S/N - Observação 12

   --into ##clientes
  from TBS002 T2 with (nolock)
       inner join TBS003 T3 with (nolock)
       on T2.MUNCOD=T3.MUNCOD
 where CLIDATCAD=convert(date,getdate())
       or CLIDATALT=convert(date,getdate())
 order by T2.CLICOD


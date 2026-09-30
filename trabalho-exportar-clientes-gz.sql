-- remove/recria a tabela tempor�ria de clientes

if object_id('##clientes') is not null
   drop table ##clientes

select right(replicate('0',16) + Ltrim(rtrim(T2.CLICOD)),16)			-- 01 C�digo
       + Left(T2.CLINOM,50)												-- 02 Nome Completo
       + Left(T2.CLIEND,60)												-- 03 Endere�o
       + Left(T2.CLIBAI,30)												-- 04 Bairro
       + Left(T3.MUNNOM,30)												-- 05 Cidade
       + Left(Ltrim(T2.UFESIG) + replicate(' ',2),2)					-- 06 Estado (UF)
	   + Left(Ltrim(replace(T2.CLICEP,'-','')) + replicate(' ',8),8)	-- 07 CEP
	   + Left(T2.CLITEL,15)												-- 08 Telefone

	   -- 09 CGC / CPF - Observa��o 1
	   + Left('0'+Ltrim(
	     iif(T2.CLITIPPES='J'
	        ,subString(T2.CLICGC,1,2)+'.'+subString(T2.CLICGC,3,3)+'.'+subString(T2.CLICGC,6,3)+'/'+subString(T2.CLICGC,9,4)+'-'+subString(T2.CLICGC,13,2)
		    ,subString(T2.CLICPF,1,3)+'.'+subString(T2.CLICPF,3,3)+'.'+subString(T2.CLICPF,7,3)+'-'+subString(T2.CLICPF,10,2)
		 )) + replicate(' ',19),19)

       + replicate('0',8)								-- 10 Data de Nascimento
	   + replicate('0',8)								-- 11 Data da Ultima Compra
	   + 'L'											-- 12 Situa��o
	   + replicate('0',12)								-- 13 Limite Total de Cr�dito para Compra Conv�nio (Fiado)
	   + replicate('0',12)								-- 14 Valor Total das Compras em Aberto no Conv�nio (Fiado)
	   + replicate('0',4)								-- 15 Percentual de Desconto Sobre o Cupom
	   + 'N'											-- 16 Desconto Sobre Produto em Promo��o - S - Sim / N - N�o
	   + 'N'											-- 17 Desconto Geral - Observa��o 3
	   + 'S'											-- 18 Permite Compra no Conv�nio (Fiado) - S - Sim / N - N�o
	   + replicate(' ',80)								-- 19 Mensagem - Observa��o 4
	   + replicate('0',12)								-- 20 Limite Total de Cr�dito para Compra com Cheque (Valor)
	   + replicate('0',6)								-- 21 Limite Total de Cr�dito para Compra com Cheque (Quantidade)
	   + replicate('0',12)								-- 22 Valor Total das Compras em Aberto com Cheque (Valor)
	   + replicate('0',6)								-- 23 Valor Total das Compras em Aberto com Cheque (Quantidade)
	   + replicate(' ',80)								-- 24 Cart�o / C�digo de Barras
	   + replicate(' ',40)								-- 25 Reservado - Espa�o em Branco

	   -- 26 Inscri��o Estadual / RG
	   + Left(Ltrim(iif(T2.CLITIPPES='J',T2.CLIIES,T2.CLIRG)) + replicate(' ',25),25)

	   + replicate('0',9)								-- 27 Pontua��o Acumulada (Fidelidade)
	   + replicate(' ',2)								-- 28 Reservado - Espa�o em Branco
	   + replicate(' ',10)								-- 29 Reservado - Espa�o em Branco
	   + replicate('0',12)								-- 30 Valor da Ultima Compra
	   + replicate('0',12)								-- 31 Saldo para Recebimento de Conta
	   + replicate('0',6)								-- 32 Quantidade de Documentos em Aberto
	   + replicate(' ',90)								-- 33 Finalizadores de Venda Bloqueados - Observa��o 5
	   + 'P'											-- 34 Tabela de Pre�o a Utilizar - A � Atacado E � Especial P - Padr�o
	   + replicate('0',2)								-- 35 N�vel de Bloqueio - Observa��o 6
	   + Left(T2.CLINOMFAN,15)							-- 36 Nome Fantasia
	   + replicate(' ',20)								-- 37 Senha do Cliente - Observa��o 7
	   + replicate('0',2)								-- 38 Dia para Vencimento do Conv�nio - Observa��o 8
	   + replicate('0',3)								-- 39 Dias para C�lculo do Vencimento do Conv�nio - Observa��o 9
	   + replicate(' ',2)								-- 40 Condi��o para C�lculo do Vencimento - Observa��o 10
	   + replicate('0',2)								-- 41 Melhor Dia para Compra - Observa��o 11
	   + replicate(' ',40)								-- 42 Contato / 2� Pessoa Autorizada
	   + replicate(' ',15)								-- 43 Tipo do Endere�o - Rua, Avenida,Trav.,

	   -- 44 Numero do Endere�o
	   + right(replicate('0',6) + Ltrim(rtrim(iif(isNumeric(T2.CLINUM)=1 and T2.CLINUM Like('%[0-9]%') and T2.CLINUM not Like('%E%') and T2.CLINUM not Like('%,%') and T2.CLINUM not Like('%.%'),T2.CLINUM,0))),6)

	   + Left(T2.CLICPLEND,20)							-- 45 Complemento - Casa, Apto, Bloco, ...
	   + replicate(' ',20)								-- 46 Pa�s - Nome do pa�s
	   + replicate('0',4)								-- 47 C�digo do pa�s - C�digo do pa�s

	   -- 48 C�digo do munic�pio (IBGE)
	   + right(replicate('0',7) + Ltrim(rtrim(T2.MUNCOD)),7)

	   + Left(Ltrim(Lower(T2.CLIEMAIL)) + replicate(' ',100),100)	-- 49 E-mail
	   + 'N'														-- 50 Inclus�o de Percentual de Acr�scimo em vendas a PRAZO - S/N - Observa��o 12

   --into ##clientes
  from TBS002 T2 with (nolock)
       inner join TBS003 T3 with (nolock)
       on T2.MUNCOD=T3.MUNCOD
 where CLIDATCAD=convert(date,getdate())
       or CLIDATALT=convert(date,getdate())
 order by T2.CLICOD

-- exportação de somente pessoa física

select rtrim(Left(Ltrim(cli.CLIBAI),30)) as bairro																							--  1. bairro
       ,rtrim(Left(Ltrim(replace(cli.CLICEP,'-','')),8)) as cep																				--  2. CEP
	   --,'' as cnpj																															--  3. cnpj
	   ,cli.CLICOD as codigo																												--  4. codigo
	   ,0 as codigoAcordo																													--  5. codigoAcordo
	   ,0 as codigoTabelaPreo																												--  6. codigoTabelaPreco
	   ,rtrim(Left(Ltrim(CLICPLEND),20)) as complemento																						--  7. complemento
	   	--  8. cpf
	   ,rtrim(replace(replace(Left(cli.CLICPF,3) + '.' + subString(cli.CLICPF,4,3) + '.' + subString(cli.CLICPF,7,3) + '-' + right(rtrim(cli.CLICPF),2),'.',''),'-','')) as cpf
       ,rtrim(Left(Ltrim(dbo.fn_ExtraiSomenteNumeros(CLITEL) + replicate('00',2)),2)) as dddTelefone											--  9. dddTelefone
	   ,rtrim(Left(Ltrim(cli.CLIEMAIL),100)) as email																						-- 10. email
	   ,right(cast(cli.MUNCOD as varchar),7) as ibgeMunicipio																				-- 11. ibgeMunicipio
	   ,'false' as identificaPlaca																											-- 12. identificaPlaca
	   --,replicate(' ',4) as ie																												-- 13. ie
	   --,'NAO_CONTRIBUINTE' as indicadorIe																					            	-- 14. indicadorIe
	   --,0 as limite																															-- 15. limite
	   ,rtrim(Left(Ltrim(cli.CLIEND),60)) as logradouro																						-- 16. logradouro
	   ,1 as loja																															-- 17. loja
	   ,rtrim(Left(Ltrim(cli.CLINOM),50)) as nome																							-- 18. nome
	   --,iif(cli.CLINOMFAN='',' ',rtrim(Left(Ltrim(cli.CLINOMFAN),15))) as nomeFantasia														-- 19. nomeFantasia
	   ,dbo.fn_ExtraiSomenteNumeros(Ltrim(rtrim(CLINUM))) as numero																											-- 20. numero
	   --,Left(Ltrim(cli.CLINOM),50) as razaoSocial																							-- 21. razaoSocial
	   ,iif(cli.CLIRG <> '',rtrim(cli.CLIRG) , replicate('0',8)) as rg																		-- 22. rg
	   ,'LIBERADO' as situacao																												-- 23. situacao
	   --,Left(Ltrim(replicate(replicate(replicate(cli.CLITEL,'(',''),')',''),'-','')),15) as telefone																							-- 24. telefone
	   ,iif(Len(Left(dbo.fn_formata_telefone(rtrim(Ltrim(dbo.fn_ExtraiSomenteNumeros(cli.CLITEL)))),9)) < 7 ,'0000000', Left(dbo.fn_formata_telefone(rtrim(Ltrim(dbo.fn_ExtraiSomenteNumeros(cli.CLITEL)))),9)) as telefone										-- 24. telefone
	   ,'FINAL' as tipoCliente																												-- 25. tipoCliente
	   --,'20391231' as validade																												-- 26. validade

  from TBS002 cli with (nolock)
 where cli.CLITIPPES = 'F'
       and dbo.fn_EmailValido(cli.CLIEMAIL) = 1
       and cli.CLIDATCAD between '20251201' and '20251210'
	   --and cli.CLIDATALT = '20250818'

-- extrai somente números de um campo do tipo carácter

CREATE FUNCTION dbo.fn_ExtraiSomenteNumeros (@str VARCHAR(1000))
RETURNS VARCHAR(1000)
AS
BEGIN
    DECLARE @result VARCHAR(1000) = ''
           ,@i INT = 1
           ,@len INT = LEN(@str);

    WHILE @i <= @len
    BEGIN
        IF SUBSTRING(@str, @i, 1) LIKE '[0-9]'
            SET @result += SUBSTRING(@str, @i, 1);

        SET @i += 1;
    END

    RETURN @result;
END;
GO

-- validação de e-mail: 0 = inválido; 1 = válido

CREATE FUNCTION dbo.fn_EmailValido (@email VARCHAR(320))
RETURNS BIT
AS
BEGIN
    -- e-mail NULL ou vazio = inválido
    IF @email IS NULL OR LTRIM(RTRIM(@email)) = ''
        RETURN 0;

    -- remove espaços externos
    SET @email = LTRIM(RTRIM(@email));

    -------------------------------------------------------------------
    -- REGRAS DE VALIDAÇÃO
    -------------------------------------------------------------------

    -- deve conter um e somente um arroba
    IF LEN(@email) - LEN(REPLACE(@email, '@', '')) <> 1
        RETURN 0;

    -- deve ter pelo menos um ponto após o @
    IF @email NOT LIKE '%@%._%'
        RETURN 0;

    -- não pode começar ou terminar com @ ou ponto
    IF @email LIKE '[@.]%' OR @email LIKE '%[@.]'
        RETURN 0;

    -- não pode ter dois pontos consecutivos
    IF @email LIKE '%..%'
        RETURN 0;

    -- não pode ter caracteres inválidos
    IF @email LIKE '%[^a-zA-Z0-9._%+-@]%'
        RETURN 0;

    -- domínio precisa ter pelo menos 2 letras após o último ponto
    DECLARE @dominio VARCHAR(255) = RIGHT(@email, CHARINDEX('.', REVERSE(@email)) - 1);

    IF LEN(@dominio) < 2
        RETURN 0;

    RETURN 1;
END;
GO

CREATE FUNCTION dbo.fn_formata_telefone
(
    @telefone VARCHAR(50)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @resultado VARCHAR(50);

    -- Remove espaços
    SET @resultado = LTRIM(RTRIM(@telefone));

    -- 1) Remove zero inicial
    IF LEFT(@resultado, 1) = '0'
        SET @resultado = SUBSTRING(@resultado, 2, LEN(@resultado));

    -- 2) Remove DDD se estiver na lista
    IF LEFT(@resultado, 2) IN (
        '11','12','13','14','15','16','17','18','19',
        '21','22','24',
        '31','32','33','34','35','37','38',
        '27','28',
        '41','42','43','44','45','46','47','48','49',
        '51','53','54','55',
        '61','62','63','64','65','66','67','68',
        '71','73','74','75','77','79'
    )
        SET @resultado = SUBSTRING(@resultado, 3, LEN(@resultado));

    RETURN @resultado;
END;
GO

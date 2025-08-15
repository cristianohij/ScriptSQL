if object_id('tempdb.dbo.##precos') is not null
   drop table ##precos
go

declare @q int

select *
  into ##precos
  from PrecoLojaGeral(0)

select *
  from ##precos

set @q=@@ROWCOUNT

print 'Quantidade de produtos com pre�os: ' + Ltrim(str(@q,9,0))

declare @crt int

select @crt=EMPCRT
  from TBS023 with (nolock)

-- gera o arquivo temporario para exportacao dos produtos

-- remove/recria a tabela temporaria de produtos

if object_id('tempdb.dbo.##produtos') is not null
   drop table ##produtos

-- lista de produtos exportados

select Left(Ltrim(rtrim(T10.PROCOD))+replicate(' ',20),20) -- Cód. Externo
       + Left(Ltrim(rtrim(T10.PROCOD))+replicate(' ',20),20) -- Cód. Barras
	     + Left(Ltrim(rtrim(T10.PRODES))+replicate(' ',40),40) -- Descrição
       + Left(rtrim(subString(T10.PRODES,41,19))+replicate(' ',20),20) -- Descrição
	     --+ replicate(' ',20) -- 'Complemento'
       + Left(Ltrim(rtrim(T10.PROUM1))+replicate(' ',4),4) -- Unidade
       -- Preço Venda
	     + right(replicate('0',12) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo=T10.PROCOD),0)*1000,12,0)),12)
	     + '000000' -- Desconto
       + iif(@crt=1, dbo.SituacaoTributaria(T10.PROCSN), dbo.SituacaoTributaria(T10.PROSTBB)) -- Situação Tributária
       -- ICMS
	     + right(replicate('0',4) + Ltrim(str(isnull(iif(T10.PROICMSINT=0,18,T10.PROICMSINT),0)*100,4,0)),4)
       --+ '0000' -- ICMS
       + replicate(' ',65) -- Obs PopUp
	     + 'N' --iif(T10.PROUM1 in('KG','MT'),'S','N') -- Calcula Quantidade (produto pesável)
       + iif(T10.PROUM1 in('KG','MT'),'N','S') -- BloqueiaQuantidadeFracionaria (produto pesável)
       + 'N' -- BloqueiaQuantidade
	     + 'S' -- Arredonda
       + 'N' -- Produção Própria
	     + replicate(' ',6) -- Cód. Grupo
       + replicate(' ',30) -- Descrição Grupo
       + replicate(' ',6) -- Cód.Departamento
       + replicate(' ',30) -- DescriçãoDepartamento
       + right(replicate(' ',6) + Ltrim(str(T10.MARCOD)),6) -- Cód. Marca
       + T10.MARNOM --) + replicate(' ',30) -- Descrição Marca
       + '     0' -- Cód.Tipo_Vasilhame
       + replicate(' ',30) -- DescriçãoTipo Vasilhame
       + replicate('0',6) -- RESERVADO
       + replicate('0',6) -- Flag
	     + Left(iif(Len(Ltrim(T10.PROCLAFIS))=8, Ltrim(T10.PROCLAFIS)+replicate(' ',20), replicate(' ',20)),20) -- NCM
       + replicate('0',6) -- Cód. TipoDescrição Adicional
       + replicate(' ',20) -- Gtin Contábil
       + replicate(' ',20) -- EX TIPI
       + replicate(' ',20) -- Gtin Tributável
       + iif(@crt=1, right(replicate(' ',6) + Ltrim(PROCSN),6), right(replicate(' ',6) + '9' + Ltrim(PROSTBA+PROSTBB),6)) -- ID_ICMS
       --+ replicate(' ',6) -- ID ICMS
       + right(replicate(' ',6) + '99',6) -- ID IPI
       + replicate(' ',6) -- ID ISSQN
       + replicate(' ',6) -- ID II
       + right(replicate(' ',6) + '49',6) -- ID PIS
       + replicate(' ',6) -- ID PIS ST
       + right(replicate(' ',6) + '49',6) -- ID COFINS
       + replicate(' ',6) -- ID COFINS ST
       + 'N' -- KIT
        -- Quantidade Estoque
       /*+ (select right(replicate('0',12) + Ltrim(str(isnull(ESTQTDATU-ESTQTDRES,0)*1000,12,0)),12)
           from TBS032 e with (nolock)
          where ESTLOC=1
                and e.PROCOD=T10.PROCOD)*/
       + right(replicate('0',12) + Ltrim(str(isnull((select ESTQTDATU-ESTQTDRES from TBS032 e with (nolock) where ESTLOC=1 and e.PROCOD=T10.PROCOD),0)*1000,12,0)),12)
	     + replicate('0',3) -- Prazo Devolução
	     + Left(iif(Len(Ltrim(T10.PROCEST))=7, Ltrim(T10.PROCEST)+replicate(' ',7), replicate(' ',7)),7) -- Cest
	     + 'S' -- Controla Estoque
       + replicate(' ',9) -- Código ANP
       + 'N' -- Dupla Pesagem
       + replicate('0',5) -- Margem Segurança
       + ' ' -- Indicador de Escala Relevante
       + replicate(' ',20) -- CNPJ do Fabricante da Mercadoria
       + replicate(' ',10) -- Código do Benefício Fiscal
       + replicate('0',7) -- Percentual do GLP derivado de petróleo do produto GLP (GLP)
       + replicate('0',7) -- Percentual de Gás Natural Nacional (GNn)
       + replicate('0',7) -- Percentual de Gás Natural Importado (GNi)
       + replicate('0',15) -- Valor do quilograma sem ICMS
       + 'P' -- Tipo Desconto
       + Left(Ltrim(rtrim(T10.PROUM1))+replicate(' ',4),4) -- Unidade Tributável
       + replicate('0',15) -- Quantidade Tributável
       + replicate(' ',20) -- Cód Externo Grupo Impressão
       + '010000' -- Desconto Máximo
       --+ Left(Ltrim(rtrim(T10.PRODES))+replicate(' ',80),80) as 'texto' -- Descrição Extra
       + replicate(' ',80) as 'texto' -- Descrição Extra

   into ##produtos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   --and T10.TGZCOD > 0
	   and (select round(preco1,3) from ##precos where codigo=T10.PROCOD) > 0
     --and T10.MARCOD=6
 order by PROCOD

select *
  from ##produtos

select *
  from TBS010 with (nolock)
 where MARCOD=368

-- elimina registro nulos
 
delete ##produtos
 where texto is null

-- gera o arquivo texto dos produtos
exec master.dbo.xp_cmdshell 'bcp "select texto from ##produtos" queryout "c:\temp\dj_produtos.txt" -c -T'
go


if object_id('tempdb.dbo.##barras') is not null
   drop table tempdb.dbo.##barras
go


select Left(Ltrim(rtrim(codigo)) + replicate(' ',20),20) -- Cód. Barras Produto
       + Left(Ltrim(rtrim(barras)) + replicate(' ',20),20) -- Cód. Barras Adicional
	     + 'D' -- Desconto/Acréscimo
	     + replicate('0',5) -- Porcentagem
	     + right(replicate('0',7) + Ltrim(str(round(embalagem,3)*100,7,0)),7) as texto
  into ##barras
  from dbo.TabelaCodigosBarrasGZ(0)
 where Left(codigo,4)='0006'

select *
  from ##barras

-- gera o arquivo texto dos c�digos de barras
exec master.dbo.xp_cmdshell 'bcp "select texto from ##barras order by texto" queryout "c:\integros\temp\barras.txt" -c -T';
go



-- CLIENTES

if object_id('tempdb.dbo.##clientes') is not null
   drop table tempdb.dbo.##clientes

-- lista de produtos exportados

--select replace(convert(char(10), getdate(), 103),'/','')+'0000'
--select convert(char(20), getdate(), 131)

select Left(Ltrim(str(c.CLICOD))+replicate(' ',20),20) -- Cód. Externo
       + c.CLITIPPES -- F_J
	     + Left(Ltrim(rtrim(c.CLINOM collate SQL_Latin1_General_CP1251_CI_AS))+replicate(' ',50),50) -- Nome
	     + Left(Ltrim(rtrim(c.CLINOMFAN collate SQL_Latin1_General_CP1251_CI_AS))+replicate(' ',30),30) -- Apelido/Fantasia
       + replace(convert(char(10), isnull(c.CLIDATCAD, getdate()), 103),'/','') -- Data Cadastro
       --+ replace(convert(char(10), isnull(c.CLIDATFUN, getdate()), 103),'/','') -- nascimento/fundação
       + replicate('0',8) -- nascimento/fundação
       --+ replace(convert(char(10), isnull(c.CLIUCPDAT, getdate()), 103),'/','') + '0000' -- última compra
       + replicate('0',12) -- última compra
       --+ replace(convert(char(10), isnull(c.CLIDATALT, getdate()), 103),'/','') + replace(Left(iif(c.CLIHORALT='' or c.CLIHORALT is null, '0000', c.CLIHORALT),5),':','') -- alterado
       + replicate('0',12) -- alterado
       + Left(replace(replace(replace(replace(replace(subString(c.CLITEL,1,14),'(',''),')',''),'-',''),'.',''),' ','') + replicate(' ',14),14) -- fone
       + replicate(' ',14) -- celular/fax
       --+ subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50) -- e-mail

       + case
            when subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50) LIKE '%_@__%.%' AND
                  charindex('..', subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50)) = 0 AND
                  charindex('.@', subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50)) = 0 AND
                  charindex('@.', subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50)) = 0 AND
                  charindex(',', subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50)) = 0 AND
                  charindex(';', subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50)) = 0
            then Lower(subString(c.CLIEMAIL collate SQL_Latin1_General_CP1251_CI_AS,1,50))
            else replicate(' ',50)
         end
       + subString(c.CLIEND collate SQL_Latin1_General_CP1251_CI_AS,1,50) -- endereço
          + subString(c.CLINUM collate SQL_Latin1_General_CP1251_CI_AS,1,6) -- número
       + subString(c.CLICPLEND collate SQL_Latin1_General_CP1251_CI_AS,1,30) -- complemento
       + subString(c.CLIBAI collate SQL_Latin1_General_CP1251_CI_AS,1,30) -- bairro
       + subString(isnull(m.MUNNOM collate SQL_Latin1_General_CP1251_CI_AS,replicate(' ',30)),1,30) -- cidade
       + c.UFESIG -- UF
       + isnull(c.CLICEP,replicate(' ',9)) -- CEP
       + replicate(' ',80) -- obs. local entrega
       + Left(iif(c.CLITIPPES='J', iif(c.CLIINDIE=1, iif(c.CLIIES is null or c.CLIIES='', '', Ltrim(rtrim(c.CLIIES))), ''), iif(c.CLIRG is null or c.CLIRG='', '', Ltrim(rtrim(c.CLIRG)))) + replicate(' ', 20),20)
       + Left(iif(c.CLITIPPES='J', isnull(c.CLICGC,''), isnull(c.CLICPF,'')) + replicate(' ',20), 20) -- cpf/cnpj
       + replicate(' ',65) -- obs popup
	     + replicate(' ',80) -- memo
	     + '9' -- nível crédito
       + replicate('0',10) -- limite crédito
	     + replicate(' ',16) -- senha
       + replicate(' ',6) -- cód. classe
	     + replicate(' ',30) -- descrilçao classe
       + replicate(' ',6) -- cód. convênio
       + replicate(' ',30) -- descrilçao convênio
	     + replicate('0',6) -- reservado
       + replicate(' ',6) -- flag
	     + replicate('0',9) -- saldo devedor
       + iif(c.CLIINDIE=1, '1', '9') -- contribuinte icms*/
       + replicate('0',6) -- 35 Código da Tabela de Preços
       + '0' -- 36 Tipo Cliente
       + replicate(' ',50) -- 37 Site
       + replicate(' ',50) -- 38 Tags
       + replicate('0',6) -- 39 ID Ramo de Atividade
       + replicate(' ',30) -- 40 Descrição do Ramo de Atividade
       + replicate('0',12) as 'texto' -- 41 Taxa de Entrega

  into ##clientes
  from TBS002 c with (nolock)
       Left join TBS003 m with (nolock)
                 on m.MUNCOD=c.MUNCOD
 where c.CLIEMPCOD=0
 order by c.CLICOD

select *
  from ##clientes

delete ##clientes
 where texto is null

-- gera o arquivo texto dos clientes
exec master.dbo.xp_cmdshell 'bcp "select texto from ##clientes" queryout "c:\integros\temp\dj_cliente.txt" -c -T'


select
    PATINDEX('%[a-zA-Z0-9._%+-]@[a-zA-Z0-9.-]%.[a-zA-Z]{2,4}%', 'MARILIA.CUNHA@BIOMABRASIL') > 0
    AND CHARINDEX('..', 'MARILIA.CUNHA@BIOMABRASIL') = 0 -- Verifica se não há '..' no e-mail
    AND CHARINDEX('.@', 'MARILIA.CUNHA@BIOMABRASIL') = 0 -- Verifica se não há '.@' no e-mail
    AND CHARINDEX('@.', 'MARILIA.CUNHA@BIOMABRASIL') = 0 -- Verifica se não há '@.' no e-mail

SELECT 
    CASE 
        WHEN Email LIKE '%_@__%.%' AND
             CHARINDEX('..', Email) = 0 AND
             CHARINDEX('.@', Email) = 0 AND
             CHARINDEX('@.', Email) = 0 AND
             CHARINDEX(',', Email) = 0 AND
             CHARINDEX(';', Email) = 0
        THEN 'Email Válido'
        ELSE 'Email Inválido'
    END AS ValidadeEmail
FROM 
    (SELECT 'compras@cmcruzeiro.gov.br,atadm@cmc.gov.br' AS Email) AS Teste


-- atualização de preços

if object_id('tempdb.dbo.##atuprecos') is not null
   drop table tempdb.dbo.##atuprecos

-- lista de preços exportados

select Left(Ltrim(rtrim(T10.PROCOD))+replicate(' ',20),20) -- Cód. Externo
       -- Preço Venda
	     + right(replicate('0',12) + Ltrim(str(isnull((select round(preco1,3) from dbo.PrecoLoja(0,T10.PROCOD)),0)*1000,12,0)),12) as 'texto'

   into ##atuprecos
  from TBS010 T10 with (nolock)
 where T10.PROEMPCOD=0
	   and (select convert(date,atualizado)  from dbo.PrecoLoja(0,T10.PROCOD)) >= '20240912'
 order by PROCOD

-- gera o arquivo texto dos preços
exec master.dbo.xp_cmdshell 'bcp "select texto from ##atuprecos" queryout "c:\integros\temp\dj_preco.txt" -c -T'

select *
  from ##atuprecos

delete ##clientes
 where texto is null



-- parâmetro: empresa/produto

select *
  from dbo.PrecoLoja(0,'')

-- parâmetro: empresa

select *
  from dbo.PrecoLojaGeral(0)


select TDPVALPROI
       ,TDPVALPROF
       ,TDPPRELOJ1
       ,*
  from TBS031 with (nolock)
 where TDPPROCOD='1640054'


-- testes

select right(replicate('0',12) + Ltrim(str(isnull((select round(preco1,3) from ##precos where codigo='03242450'),0)*1000,12,0)),12)


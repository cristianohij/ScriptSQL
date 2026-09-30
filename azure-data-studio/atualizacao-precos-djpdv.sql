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

  --into ##clientes
  from TBS002 c with (nolock)
       Left join TBS003 m with (nolock)
                 on m.MUNCOD=c.MUNCOD
 where c.CLIEMPCOD=0
       --and c.CLICOD = 34078
       /*and c.CLICOD in (SELECT s.CLICOD
                          FROM TBS002 s with (nolock)
                         WHERE NOT EXISTS (
                                            SELECT 1
                                              FROM OPENQUERY(DJMONITOR, 'SELECT CODEXTERNO FROM CLIENTE') f
                                             WHERE f.CODEXTERNO = s.CLICOD
                                          ))*/
 order by c.CLICOD

SELECT 
    s.CLICOD,
    s.CLINOM -- adicione aqui outros campos da TBS002 que desejar
FROM TBS002 s with (nolock)
WHERE NOT EXISTS (
    SELECT 1
    FROM OPENQUERY(DJMONITOR, 'SELECT CODEXTERNO FROM CLIENTE') f
    WHERE f.CODEXTERNO = s.CLICOD
);

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
	   and (select convert(date,atualizado)  from dbo.PrecoLoja(0,T10.PROCOD)) >= '20250910'
 order by PROCOD

-- gera o arquivo texto dos preços
exec master.dbo.xp_cmdshell 'bcp "select texto from ##atuprecos" queryout "c:\integros\temp\dj_preco.txt" -c -T'


-- atualização de preços

if object_id('tempdb.dbo.##atuprecos') is not null
   drop table tempdb.dbo.##atuprecos;

-- lista de produtos exportados
WITH PrecosComIndice AS (
    SELECT 
        rtrim(T.PROCOD) +  IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=2, '2222', IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=3, '3333', IIF(ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))=4, '4444', ''))) as PROCOD,
        iif(T.PROUM1 = UMs.UnidadeMedida, P.preco1 , iif(T.PROUM2 = UMs.UnidadeMedida, T.PROUM2QTD * P.preco2, iif(T.PROUM3 = UMs.UnidadeMedida, T.PROUM3QTD * P.preco3, T.PROUM4QTD * P.preco4))) as preco,        
        ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs (UnidadeMedida)
    --CROSS APPLY (VALUES (1), (T.PROUM2QTD), (T.PROUM3QTD)) AS EMBs (qtEmbalagem)
    CROSS APPLY (
        SELECT preco1, preco2, preco3, preco4
        FROM PrecoLoja(0, T.PROCOD)
        where --T.PROCOD='01730024' --'00560009' --'01560010'
        --and 
        UMs.UnidadeMedida <> '' -- (T.PROUM2 <> '' or T.PROUM3 <> '')
    ) AS P
    --where --T.PRODATCAD >= '20250910'
            --T.PROCOD in ('03300132','03300151')
    where (select convert(date,atualizado)  from dbo.PrecoLoja(0,T.PROCOD)) >= '20250409'

    UNION ALL

    SELECT 
        --pro.PROCOD,
        bar.CBPCODBAR as PROCOD,
                iif(bar.CBPQTDEMB = 1, preco.preco1, bar.CBPQTDEMB * iif(bar.CBPQTDEMB=pro.PROUM2QTD, preco.preco2, iif(bar.CBPQTDEMB=pro.PROUM3QTD, preco.preco3, iif(bar.CBPQTDEMB=pro.PROUM4QTD, preco.preco4, 0)))) as preco,
        ROW_NUMBER() OVER (PARTITION BY pro.PROCOD ORDER BY (SELECT NULL)) AS LinhaIndice
    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK)
        ON pro.PROCOD = bar.CBPPROCOD
    CROSS APPLY (
        SELECT preco1, preco2 ,preco3, preco4
        FROM PrecoLoja(0, pro.PROCOD)
    ) AS preco
    WHERE --pro.PROUM2 <> ''
      --AND 
      (bar.CBPQTDEMB=1 or bar.CBPQTDEMB = pro.PROUM2QTD or bar.CBPQTDEMB = pro.PROUM3QTD or bar.CBPQTDEMB = pro.PROUM4QTD)
      AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
      and right(rtrim(bar.CBPCODBAR),4) not in ('2222','3333','4444')

      --and pro.PRODATCAD >= '20250910'
      and (select convert(date,atualizado)  from dbo.PrecoLoja(0,pro.PROCOD)) >= '20250409'
      --and pro.PROCOD in ('03300132','03300151')
      
      --and pro.PROCOD='01730024' --'00560009'
)

--select *
--  from PrecosComIndice

select Left(Ltrim(rtrim(PROCOD))+replicate(' ',20),20) -- Cód. Externo
       -- Preço Venda
	     + right(replicate('0',12) + Ltrim(str(isnull(preco,0)*1000,12,0)),12) as 'texto'
  into ##atuprecos       
  from PrecosComIndice

-- gera o arquivo texto dos preços
exec master.dbo.xp_cmdshell 'bcp "select texto from ##atuprecos" queryout "c:\integros\temp\dj_preco.txt" -c -T'


select *
  from ##atuprecos

delete ##clientes
 where texto is null



-- parâmetro: empresa/produto

select *
  from dbo.PrecoLoja(0,'03240802')

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


-- otimização chatGPT

-- Atualização de preços otimizada

IF OBJECT_ID('tempdb.dbo.##atuprecos') IS NOT NULL
    DROP TABLE tempdb.dbo.##atuprecos;

WITH PrecosComIndice AS (
    --------------------------------------------------------------------
    -- Produtos da tabela principal (TBS010)
    --------------------------------------------------------------------
    SELECT 
        PROCOD = RTRIM(T.PROCOD) + 
                 CASE ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))
                      WHEN 2 THEN '2222'
                      WHEN 3 THEN '3333'
                      WHEN 4 THEN '4444'
                      ELSE ''
                 END,
        preco = CASE 
                    WHEN T.PROUM1 = UMs.UnidadeMedida THEN P.preco1
                    WHEN T.PROUM2 = UMs.UnidadeMedida THEN T.PROUM2QTD * P.preco2
                    WHEN T.PROUM3 = UMs.UnidadeMedida THEN T.PROUM3QTD * P.preco3
                    WHEN T.PROUM4 = UMs.UnidadeMedida THEN T.PROUM4QTD * P.preco4
                    ELSE 0
                END
    FROM TBS010 T WITH (NOLOCK)
    CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs(UnidadeMedida)
    CROSS APPLY (
        SELECT preco1, preco2, preco3, preco4, CONVERT(date, atualizado) AS atualizado
        FROM dbo.PrecoLoja(0, T.PROCOD)
    ) AS P
    WHERE UMs.UnidadeMedida <> ''
      AND P.atualizado >= '2025-04-09'

    UNION ALL

    --------------------------------------------------------------------
    -- Produtos vinculados à tabela de códigos de barras (TBS0103)
    --------------------------------------------------------------------
    SELECT 
        PROCOD = bar.CBPCODBAR,
        preco = CASE 
                    WHEN bar.CBPQTDEMB = 1 THEN preco.preco1
                    WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN bar.CBPQTDEMB * preco.preco2
                    WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN bar.CBPQTDEMB * preco.preco3
                    WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN bar.CBPQTDEMB * preco.preco4
                    ELSE 0
                END
    FROM TBS0103 bar WITH (NOLOCK)
    INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
    CROSS APPLY (
        SELECT preco1, preco2, preco3, preco4, CONVERT(date, atualizado) AS atualizado
        FROM dbo.PrecoLoja(0, pro.PROCOD)
    ) AS preco
    WHERE bar.CBPQTDEMB IN (1, pro.PROUM2QTD, pro.PROUM3QTD, pro.PROUM4QTD)
      AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
      AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222','3333','4444')
      AND preco.atualizado >= '2025-04-09'
)

-- Montagem final do arquivo
SELECT 
    texto = LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ', 20), 20) +
            RIGHT(REPLICATE('0', 12) + LTRIM(STR(ISNULL(preco, 0) * 1000, 12, 0)), 12)
INTO ##atuprecos
FROM PrecosComIndice;

-- Exportação do arquivo texto
EXEC master.dbo.xp_cmdshell 
    'bcp "SELECT texto FROM ##atuprecos" queryout "c:\integros\temp\dj_preco.txt" -c -T';

-- teste

select *
  from ##atuprecos

-- procedure criado pelo chatGPT

-- Elimina a procedure caso já exista

IF OBJECT_ID('dbo.usp_GerarArquivoPrecos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GerarArquivoPrecos;
GO

-- Criação da procedure
CREATE PROCEDURE dbo.usp_GerarArquivoPrecos
    @DataDe DATE,
    @DataAte DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Elimina tabela temporária caso já exista
    IF OBJECT_ID('tempdb..##atuprecos') IS NOT NULL
        DROP TABLE tempdb..##atuprecos;

    -- CTE com preços e índices
    WITH PrecosComIndice AS (
        --------------------------------------------------------------------
        -- Produtos da tabela principal (TBS010)
        --------------------------------------------------------------------
        SELECT 
            PROCOD = RTRIM(T.PROCOD) + 
                     CASE ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))
                          WHEN 2 THEN '2222'
                          WHEN 3 THEN '3333'
                          WHEN 4 THEN '4444'
                          ELSE ''
                     END,
            preco = CASE 
                        WHEN T.PROUM1 = UMs.UnidadeMedida THEN P.preco1
                        WHEN T.PROUM2 = UMs.UnidadeMedida THEN T.PROUM2QTD * P.preco2
                        WHEN T.PROUM3 = UMs.UnidadeMedida THEN T.PROUM3QTD * P.preco3
                        WHEN T.PROUM4 = UMs.UnidadeMedida THEN T.PROUM4QTD * P.preco4
                        ELSE 0
                    END
        FROM TBS010 T WITH (NOLOCK)
        CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs(UnidadeMedida)
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4, CONVERT(date, atualizado) AS atualizado
            FROM dbo.PrecoLoja(0, T.PROCOD)
        ) AS P
        WHERE UMs.UnidadeMedida <> ''
          AND P.atualizado BETWEEN @DataDe AND @DataAte

        UNION ALL

        --------------------------------------------------------------------
        -- Produtos vinculados à tabela de códigos de barras (TBS0103)
        --------------------------------------------------------------------
        SELECT 
            PROCOD = bar.CBPCODBAR,
            preco = CASE 
                        WHEN bar.CBPQTDEMB = 1 THEN preco.preco1
                        WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN bar.CBPQTDEMB * preco.preco2
                        WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN bar.CBPQTDEMB * preco.preco3
                        WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN bar.CBPQTDEMB * preco.preco4
                        ELSE 0
                    END
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4, CONVERT(date, atualizado) AS atualizado
            FROM dbo.PrecoLoja(0, pro.PROCOD)
        ) AS preco
        WHERE bar.CBPQTDEMB IN (1, pro.PROUM2QTD, pro.PROUM3QTD, pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222','3333','4444')
          AND preco.atualizado BETWEEN @DataDe AND @DataAte
    )

    -- Montagem final do arquivo
    SELECT 
        texto = LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ', 20), 20) +
                RIGHT(REPLICATE('0', 12) + LTRIM(STR(ISNULL(preco, 0) * 1000, 12, 0)), 12)
    INTO ##atuprecos
    FROM PrecosComIndice;

    -- Exportação do arquivo texto
    DECLARE @Cmd NVARCHAR(4000);
    SET @Cmd = 'bcp "SELECT texto FROM ##atuprecos" queryout "c:\integros\exporta\djpdv\dj_preco.txt" -c -T';
    EXEC master.dbo.xp_cmdshell @Cmd;
END
GO

-- teste

EXEC dbo.usp_GerarArquivoPrecos 
    @DataDe = '2025-12-20', 
    @DataAte = '2025-12-29';

-- fima da procedure criada


SELECT preco1, preco2, preco3, preco4, CONVERT(date, atualizado) AS atualizado
  FROM dbo.PrecoLoja(0, '00060011')


-- novo código

IF OBJECT_ID('dbo.usp_GerarArquivoPrecos', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_GerarArquivoPrecos;
GO

CREATE PROCEDURE dbo.usp_GerarArquivoPrecos
    @DataDe DATE,
    @DataAte DATE
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- Remove tabela temporária antiga, se existir
    --------------------------------------------------------------------
    IF OBJECT_ID('tempdb..##atuprecos') IS NOT NULL
        DROP TABLE tempdb..##atuprecos;

    --------------------------------------------------------------------
    -- CTE 1: Produtos atualizados no período informado
    --------------------------------------------------------------------
    ;WITH ProdutosAtualizados AS (
        SELECT DISTINCT
            T.PROCOD
        FROM TBS010 T WITH (NOLOCK)
        CROSS APPLY (
            SELECT CONVERT(date, atualizado) AS atualizado
            FROM dbo.PrecoLoja(0, T.PROCOD)
        ) AS P
        WHERE P.atualizado BETWEEN @DataDe AND @DataAte
    ),

    --------------------------------------------------------------------
    -- CTE 2: Preços com códigos e embalagens (unificada)
    --------------------------------------------------------------------
    PrecosComIndice AS (
        ----------------------------------------------------------------
        -- Parte 1: Produtos da TBS010
        ----------------------------------------------------------------
        SELECT 
            PROCOD = RTRIM(T.PROCOD) + 
                     CASE ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))
                          WHEN 2 THEN '2222'
                          WHEN 3 THEN '3333'
                          WHEN 4 THEN '4444'
                          ELSE ''
                     END,
            preco = CASE 
                        WHEN T.PROUM1 = UMs.UnidadeMedida THEN P.preco1
                        WHEN T.PROUM2 = UMs.UnidadeMedida THEN T.PROUM2QTD * P.preco2
                        WHEN T.PROUM3 = UMs.UnidadeMedida THEN T.PROUM3QTD * P.preco3
                        WHEN T.PROUM4 = UMs.UnidadeMedida THEN T.PROUM4QTD * P.preco4
                        ELSE 0
                    END
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosAtualizados A ON A.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs(UnidadeMedida)
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4
            FROM dbo.PrecoLoja(0, T.PROCOD)
        ) AS P
        WHERE UMs.UnidadeMedida <> ''

        UNION ALL

        ----------------------------------------------------------------
        -- Parte 2: Produtos da TBS0103 (códigos de barras vinculados)
        ----------------------------------------------------------------
        SELECT 
            PROCOD = bar.CBPCODBAR,
            preco = CASE 
                        WHEN bar.CBPQTDEMB = 1 THEN preco.preco1
                        WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN bar.CBPQTDEMB * preco.preco2
                        WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN bar.CBPQTDEMB * preco.preco3
                        WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN bar.CBPQTDEMB * preco.preco4
                        ELSE 0
                    END
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosAtualizados A ON A.PROCOD = pro.PROCOD
        CROSS APPLY (
            SELECT preco1, preco2, preco3, preco4
            FROM dbo.PrecoLoja(0, pro.PROCOD)
        ) AS preco
        WHERE bar.CBPQTDEMB IN (1, pro.PROUM2QTD, pro.PROUM3QTD, pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222','3333','4444')
    )

    --------------------------------------------------------------------
    -- Geração do conteúdo final a exportar
    --------------------------------------------------------------------
    SELECT 
        texto = LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ', 20), 20) +
                RIGHT(REPLICATE('0', 12) + LTRIM(STR(ISNULL(preco, 0) * 1000, 12, 0)), 12)
    INTO ##atuprecos
    FROM PrecosComIndice
    WHERE preco > 0;

    --------------------------------------------------------------------
    -- Exportação via BCP (gera o arquivo texto)
    --------------------------------------------------------------------
    DECLARE @Cmd NVARCHAR(4000);
    SET @Cmd = 'bcp "SELECT texto FROM ##atuprecos" queryout "c:\integros\exporta\djpdv\dj_preco.txt" -c -T';
    EXEC master.dbo.xp_cmdshell @Cmd;
END
GO

-- hobby

EXEC dbo.usp_GerarArquivoPrecos 
    @DataDe = '2026-01-23', 
    @DataAte = '2026-01-26';

select count(*)
  from TBS010 with (nolock)

-- novo código: 28/01/2026

IF OBJECT_ID('dbo.usp_Exporta_Precos_DJPDV', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Exporta_Precos_DJPDV;
GO

alter PROCEDURE dbo.usp_Exporta_Precos_DJPDV
    @DataDe DATE,
    @DataAte DATE
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------------------------
    -- Remove tabela temporária antiga, se existir
    --------------------------------------------------------------------
    IF OBJECT_ID('tempdb..##atuprecos') IS NOT NULL
        DROP TABLE tempdb..##atuprecos;

    --------------------------------------------------------------------
    -- CTE 1: Produtos atualizados no período informado
    --------------------------------------------------------------------
    ;WITH ProdutosAtualizados AS (
        SELECT DISTINCT
            T.PROCOD
        FROM TBS010 T WITH (NOLOCK)
        --CROSS APPLY (
            --SELECT CONVERT(date, atualizado) AS atualizado
            --FROM dbo.PrecoLoja(0, T.PROCOD)
        --) AS P
        cross apply (
            select cast(atualizado as date) as atualizado
              from dbo. vw_PrecoLojaGeral
             where codigo = T.PROCOD
        ) as P
        WHERE P.atualizado BETWEEN @DataDe AND @DataAte
    ),

    --------------------------------------------------------------------
    -- CTE 2: Preços com códigos e embalagens (unificada)
    --------------------------------------------------------------------
    PrecosComIndice AS (
        ----------------------------------------------------------------
        -- Parte 1: Produtos da TBS010
        ----------------------------------------------------------------
        SELECT 
            PROCOD = RTRIM(T.PROCOD) + 
                     CASE ROW_NUMBER() OVER (PARTITION BY T.PROCOD ORDER BY (SELECT NULL))
                          WHEN 2 THEN '2222'
                          WHEN 3 THEN '3333'
                          WHEN 4 THEN '4444'
                          ELSE ''
                     END,
            preco = CASE 
                        WHEN T.PROUM1 = UMs.UnidadeMedida THEN P.preco1
                        WHEN T.PROUM2 = UMs.UnidadeMedida THEN T.PROUM2QTD * P.preco2
                        WHEN T.PROUM3 = UMs.UnidadeMedida THEN T.PROUM3QTD * P.preco3
                        WHEN T.PROUM4 = UMs.UnidadeMedida THEN T.PROUM4QTD * P.preco4
                        ELSE 0
                    END
        FROM TBS010 T WITH (NOLOCK)
        INNER JOIN ProdutosAtualizados A ON A.PROCOD = T.PROCOD
        CROSS APPLY (VALUES (T.PROUM1), (T.PROUM2), (T.PROUM3), (T.PROUM4)) AS UMs(UnidadeMedida)
        --CROSS APPLY (
            --SELECT preco1, preco2, preco3, preco4
            --FROM dbo.PrecoLoja(0, T.PROCOD)
        --) AS P
        cross apply (
            select preco1, preco2, preco3, preco4
              from dbo. vw_PrecoLojaGeral
             where codigo = T.PROCOD
        ) as P        
        WHERE UMs.UnidadeMedida <> ''

        UNION ALL

        ----------------------------------------------------------------
        -- Parte 2: Produtos da TBS0103 (códigos de barras vinculados)
        ----------------------------------------------------------------
        SELECT 
            PROCOD = bar.CBPCODBAR,
            preco = CASE 
                        WHEN bar.CBPQTDEMB = 1 THEN preco.preco1
                        WHEN bar.CBPQTDEMB = pro.PROUM2QTD THEN bar.CBPQTDEMB * preco.preco2
                        WHEN bar.CBPQTDEMB = pro.PROUM3QTD THEN bar.CBPQTDEMB * preco.preco3
                        WHEN bar.CBPQTDEMB = pro.PROUM4QTD THEN bar.CBPQTDEMB * preco.preco4
                        ELSE 0
                    END
        FROM TBS0103 bar WITH (NOLOCK)
        INNER JOIN TBS010 pro WITH (NOLOCK) ON pro.PROCOD = bar.CBPPROCOD
        INNER JOIN ProdutosAtualizados A ON A.PROCOD = pro.PROCOD
        --CROSS APPLY (
            --SELECT preco1, preco2, preco3, preco4
            --FROM dbo.PrecoLoja(0, pro.PROCOD)
        --) AS preco
        cross apply (
            select preco1, preco2, preco3, preco4
              from dbo. vw_PrecoLojaGeral
             where codigo = pro.PROCOD
        ) as preco       
        WHERE bar.CBPQTDEMB IN (1, pro.PROUM2QTD, pro.PROUM3QTD, pro.PROUM4QTD)
          AND preco.preco1 + preco.preco2 + preco.preco3 + preco.preco4 > 0
          AND RIGHT(RTRIM(bar.CBPCODBAR), 4) NOT IN ('2222','3333','4444')
    )

    --------------------------------------------------------------------
    -- Geração do conteúdo final a exportar
    --------------------------------------------------------------------
    SELECT 
        texto = LEFT(LTRIM(RTRIM(PROCOD)) + REPLICATE(' ', 20), 20) +
                RIGHT(REPLICATE('0', 12) + LTRIM(STR(ISNULL(preco, 0) * 1000, 12, 0)), 12)
    --INTO ##atuprecos
    FROM PrecosComIndice
    WHERE preco > 0;

    --------------------------------------------------------------------
    -- Exportação via BCP (gera o arquivo texto)
    --------------------------------------------------------------------
    --DECLARE @Cmd NVARCHAR(4000);
    --SET @Cmd = 'bcp "SELECT texto FROM ##atuprecos" queryout "c:\integros\exporta\djpdv\dj_preco.txt" -c -T';
    --EXEC master.dbo.xp_cmdshell @Cmd;
END
GO

select *
  from vw_PrecoLojaGeral

        SELECT DISTINCT
            T.PROCOD
        FROM TBS010 T WITH (NOLOCK)
        --CROSS APPLY (
            --SELECT CONVERT(date, atualizado) AS atualizado
            --FROM dbo.PrecoLoja(0, T.PROCOD)
        --) AS P
        cross apply (
            select cast(atualizado as date) as atualizado
              from dbo. vw_PrecoLojaGeral
             where codigo = T.PROCOD
        ) as P
        WHERE P.atualizado BETWEEN '20260127' AND '20260128'

EXEC dbo.usp_Exporta_Precos_DJPDV @DataDe = '20260220', @DataAte = '20260226';

select distinct p.PROREDBASICMS
  from TBS010 p with (nolock)
 where p.PROREDBASICMS > 0

select distinct p.PROSTBB
  from TBS010 p with (nolock)



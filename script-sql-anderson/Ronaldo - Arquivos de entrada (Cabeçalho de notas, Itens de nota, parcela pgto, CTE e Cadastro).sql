-- contabilizo os valores de frete CTE ? SIM
-- entrada devoluçao que tem ST, tomo credito de ICMS ? a principio sim e-mail respondido pela contabilidade 28/02/2018
-- NF 2209 (simples nacional), nota com ST e com destaque nos dados adicionais de credito de ICMS, tomo credito de ICMS mesmo tendo ST ? segundo Ronaldo tem ST não gera credito ICMS

-- ARQUIVO TXT DE ENTRADA PARA REALIZAR SPED -- DADOS DA NF 

-- 05118717000156 -- BEST BAG
-- 65069593000350 -- CD
-- 52080207000117 -- Misaspel
-- 65069593000198 -- TANBY ND
-- 44125185000136 -- PAPELYNA
-- 65069593000279 -- TTE

-- FILTROS

DECLARE @Data_de DATETIME , @Data_ate DATETIME , @NFSTIP CHAR(1) , @CFOP CHAR(100), @NFSSUBTIP CHAR(13), @CNPJ CHAR(14),@anoDe varchar (4), @mesDe varchar (2), @MUNCOD INT

SET @Data_de = (select convert(date,dateadd(mm,-1,dateadd(dd,-day(getdate())+1,getdate()))) ) -- data de inicio do mes anterior a data de hoje
SET @Data_ate = (select convert(date,dateadd(dd,-day(getdate()),getdate())) ) -- ultimo dia do mes anterior a data de hoje
SET @CNPJ = (SELECT top 1 EMPCGC FROM TBS023 (nolock) order by EMPCOD DESC )
SET @anoDe = (select substring(convert(char(10),@Data_de,103),7,4))
SET @mesDe = (select substring(convert(char(10),@Data_de,103),4,2))
SET @MUNCOD = (SELECT EMPMUNCOD FROM TBS023 NOLOCK WHERE EMPCOD = 1)

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- cfop 2.910 e 1.910 não toma credito de ICMS, tenho que arrumar o select, para não contabilizar isso.

-- ESSES CFOP NÃO PODE APARECER NO RELATORIO DE ICMS

if object_id('tempdb.dbo.#CFOP') is not null
begin
	drop table #CFOP
end
   
create table #CFOP (TIPO CHAR (1), CFOP VARCHAR(5), PAGAR CHAR(1))

-- ENTRADAS '1.922','2.922', VALOR ANTECIPADO '1.403','2.403' -- PAGAR '1.252','1.352','2.352'
--INSERT INTO #CFOP VALUES ('E','1.403','N') -- ESSE VALOR TENHO QUE ZERAR NO RELATORIO -- VALOR ANTECIPADO
--INSERT INTO #CFOP VALUES ('E','2.403','N') -- ESSE VALOR TENHO QUE ZERAR NO RELATORIO -- VALOR ANTECIPADO
--INSERT INTO #CFOP VALUES ('E','1.922','N')
--INSERT INTO #CFOP VALUES ('E','2.922','N')

INSERT INTO #CFOP VALUES ('E','252','S') -- ESE VAI APARECER SOMENTE NO CONTAS A PAGAR
INSERT INTO #CFOP VALUES ('E','253','S')
INSERT INTO #CFOP VALUES ('E','352','S')

-- CFOP PIS COFINS

-- ENTRADAS

INSERT INTO #CFOP VALUES ('E','102','N')
INSERT INTO #CFOP VALUES ('E','117','N') -- PASSA A SER CONTABILIZADO SEGUNDO O CASTRO
INSERT INTO #CFOP VALUES ('E','202','N') 
INSERT INTO #CFOP VALUES ('E','403','N')
INSERT INTO #CFOP VALUES ('E','411','N')

-- SAIDAS 
INSERT INTO #CFOP VALUES ('S','102','N')
INSERT INTO #CFOP VALUES ('S','117','N') -- PASSA A SER CONTABILIZADO SEGUNDO O CASTRO
INSERT INTO #CFOP VALUES ('S','202','N')
INSERT INTO #CFOP VALUES ('S','405','N')
INSERT INTO #CFOP VALUES ('S','411','N')
INSERT INTO #CFOP VALUES ('S','108','N')
INSERT INTO #CFOP VALUES ('S','404','N')


-- SELECT * FROM TBS0591 WHERE SUBSTRING(NFECFOP,3,3) = '910'

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- TBS080 TABELA DE AUTORIZAÇÃO

if object_id('tempdb.dbo.#TBS080') is not null
begin
	drop table #TBS080
end
   
SELECT 
ENFNUM,
SNEEMPCOD,
SNESER,
ENFTIPDOC,
ENFFINEMI,
ENFCODDES

INTO #TBS080
FROM TBS080 (NOLOCK)

WHERE 
ENFDATEMI BETWEEN @Data_de AND @Data_ate AND 
ENFSIT = 6 AND 
ENFFINEMI IN (1,4) AND
ENFTIPDOC = 0 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- MARCAR NOTA DO SIMPLES NACIONAL

--if object_id('tempdb.dbo.#TBS059') is not null
--   drop table #TBS059
--
--SELECT 
--A.NFEEMPCOD,
--A.NFECOD ,
--A.NFENUM,
--A.NFETIP ,
--A.SERCOD ,
--A.SEREMPCOD,
--B.NFEDATEFE,
--B.NFECAN,
--B.NFENOSFOR
--
--INTO #TBS059
--FROM TBS0591 A (NOLOCK)
--INNER JOIN TBS059 B (NOLOCK) ON A.NFEEMPCOD = B.NFEEMPCOD AND A.NFECOD = B.NFECOD AND A.NFENUM = B.NFENUM AND 
--A.NFETIP = B.NFETIP AND A.SERCOD = B.SERCOD AND  A.SEREMPCOD = B.SEREMPCOD
--LEFT JOIN #TBS080 D (NOLOCK) ON A.NFENUM = D.ENFNUM AND A.NFECOD = D.ENFCODDES
--
--WHERE 
--(ENFNUM IS NOT NULL OR (NFENOSFOR <>'S' AND B.NFECAN <> 'S' AND NFEDATEFE <> '')) AND
--B.NFEDATEFE BETWEEN @Data_de AND @Data_ate 
--
---- AND LEN(NFECST) < 4 -- < 4 NÃO CONTABLIZA AS NOTAS DO SIMPLES NACIONAL ; >= 4 CONTABILIZA SOMENTE AS NOTAS DO SIMPLES
--
--GROUP BY 
--A.NFEEMPCOD,
--A.NFECOD ,
--A.NFENUM,
--A.NFETIP ,
--A.SERCOD ,
--A.SEREMPCOD,
--B.NFEDATEFE,
--B.NFECAN,
--B.NFENOSFOR

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PEGANDO OS PRODUTOS DA TBS010, SOMENTE OS QUE CONTANILIZAM PIS/COFINS, BASEADO NO PROSTBPIS 

if object_id('tempdb.dbo.#TBS010') is not null
begin
	drop table #TBS010
end

SELECT PROCOD INTO #TBS010 FROM TBS010 (NOLOCK) WHERE PROSTBPIS NOT IN ('06','07','08','09','49','70','71','72','73','74','98','99')

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- PEGANDO NCM DA TABELA DE PRODUTOS -- SOLICITAÇAO DO RONALDO 26/02/2018

if object_id('tempdb.dbo.#NCM') is not null
begin
	drop table #NCM
end

SELECT PROCOD, PROCLAFIS AS NCM INTO #NCM FROM TBS010 (NOLOCK)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DADOS DO FORNECEDOR 

if object_id('tempdb.dbo.#TBS006') is not null
begin
	drop table #TBS006
end

SELECT 
-- CHARINDEX(RTRIM(LTRIM(FORNUM)),RTRIM(FOREND)),
FORCOD,
CASE WHEN FORCGC = '' 
	THEN FORCPF
	ELSE FORCGC
END AS FORCGC,
FORNOM,
RTRIM(FOREND) + CASE WHEN CHARINDEX(RTRIM(LTRIM(FORNUM)),RTRIM(FOREND)) > 0 THEN '' ELSE ' - N° ' + RTRIM(LTRIM(FORNUM)) END AS FOREND,
FORBAI,
(SELECT MUNNOM FROM TBS003 B (NOLOCK) WHERE A.MUNCOD = B.MUNCOD) AS MUNNOM,
UFESIG AS UF,
FORCEP ,
CASE WHEN FORTIPPES = 'F' OR RTRIM(LTRIM(FORIES)) LIKE('ISE%')
	THEN ''
	ELSE RTRIM(LTRIM(FORIES)) 
END AS FORIES

INTO #TBS006
FROM TBS006 A (NOLOCK)  


---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DADOS DO CLIENTE 

if object_id('tempdb.dbo.#TBS002') is not null
begin
	drop table #TBS002
end

SELECT 
-- CHARINDEX(RTRIM(LTRIM(CLINUM)),RTRIM(CLIEND)),
CLICOD,
CASE WHEN CLICGC = '' 
	THEN CLICPF
	ELSE CLICGC
END CLICGC,
CLINOM,
RTRIM(CLIEND) + CASE WHEN CHARINDEX(RTRIM(LTRIM(CLINUM)),RTRIM(CLIEND)) > 0 THEN '' ELSE ' - N° ' + RTRIM(LTRIM(CLINUM)) END AS CLIEND,
CLIBAI,
(SELECT MUNNOM FROM TBS003 B (NOLOCK) WHERE A.MUNCOD = B.MUNCOD) AS MUNNOM,
UFESIG AS UF,
CLICEP ,
CLIIES

INTO #TBS002
FROM TBS002 A (NOLOCK)  


---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#NFE') is not null
begin
	drop table #NFE
end

SELECT
-- 0 AS REG,
A.NFEITE,
A.PROCOD,
REPLACE(A.NFEDES,';',' ') AS NFEDES,
A.NFEQTD,
A.NFEUNI,
A.NFEPRE,
A.NFECFOP,
G.NCM,
-- A.NFEQTD * A.NFEPRE AS NFETOTITEBRU,
-- A.NFEBASICMS AS NFEBASICMS,
CASE WHEN (NFEVALICMSST > 0 AND B.NFETIP NOT IN ('D')) OR SUBSTRING(NFECFOP,3,3) IN ('556','557') OR (A.LESCOD = 6 AND SUBSTRING(NFECFOP,3,3) IN ('910'))
	THEN 0
	ELSE 
		CASE WHEN NFEVCRESN > 0 
			THEN NFEPCRESN
			ELSE A.NFEPERICMS
		END 
END AS NFEPERICMS,
A.NFEBASIPI,
A.NFEPERIPI,
-- A.NFEVALIPI,
-- A.NFEVALICMSST,
A.NFEVALFREITE,
A.NFEVALOUTDES,
CASE WHEN ISNULL(CTEENTVALDOCFRE,0) > 0 
	THEN CTEENTVALDOCFRE / B.NFEULTITE
	ELSE 0
END AS NFEVALFREITECTE,
CASE WHEN A.NFETIP = 'T' AND A.NFESUBTIPITE = ''
	THEN 'TRANSFERENCIA'
	ELSE 
		CASE WHEN A.NFETIP = 'D' AND A.NFESUBTIPITE = 'V'
			THEN 'DEVOLUCAO DE VENDAS'
			ELSE
				CASE WHEN A.NFETIP = 'N' AND ( FORCGC LIKE('05118717000%') OR FORCGC LIKE('44125185000%') OR FORCGC LIKE('52080207000%') OR FORCGC LIKE('6506959300%') ) AND A.NFESUBTIPITE = 'R'				
					THEN 'COMPRA INTER COMPANY'
					ELSE
						CASE A.NFESUBTIPITE 
							WHEN 'R' THEN 'VENDA'
							WHEN 'A' THEN 'AMOSTRA'
							WHEN 'B' THEN 'BONIFICACAO'
							WHEN 'U' THEN 'USO E CONSUMO'
							WHEN 'O' THEN 'OUTRAS'
						END
				END
		END			
END AS 	NFESUBTIPITE,  -- A.NFESUBTIPITE,
A.NFEVALDESITE,
A.NFECST,
A.NFEBASICMSST,
@CNPJ AS CNPJEMP,
B.NFEDATEFE,
B.NFENUM,
0 AS SERIE,
CASE WHEN B.NFETIP = 'D' 
	THEN CLICGC
	ELSE FORCGC
END AS CNPJ,
B.NFEDATEMI,
B.SERCOD,
'E' AS TIPO,
B.NFECHAACE,
B.NFECAN,
CASE WHEN B.NFETIP = 'D' 
	THEN CLINOM
	ELSE E.FORNOM
END AS NOME,
CASE WHEN B.NFETIP = 'D' 
	THEN CLIEND 
	ELSE FOREND
END AS ENDERECO,
CASE WHEN B.NFETIP = 'D' 
	THEN CLIBAI 
	ELSE FORBAI
END AS BAIRRO,
CASE WHEN B.NFETIP = 'D'
	THEN F.MUNNOM 
	ELSE E.MUNNOM
END MUNICIPIO,
CASE WHEN B.NFETIP = 'D'
	THEN F.UF
	ELSE E.UF
END AS UF,
CASE WHEN B.NFETIP = 'D' 
	THEN CLICEP
	ELSE FORCEP
END AS CEP ,
CASE WHEN B.NFETIP = 'D' 
	THEN CLIIES
	ELSE FORIES
END IES,
dbo.NFETOTITEBRU(A.NFEEMPCOD, A.NFETIP, A.NFENUM, A.NFECOD, A.SEREMPCOD, A.SERCOD, A.NFEITE) AS NFETOTITEBRU, -- VALOR DOS PRODUTOS
NFETOTOPEITE AS NFETOTOPEITE,  -- VALOR TOTAL DA NOTA

CASE WHEN (NFEVALICMSST > 0 AND B.NFETIP NOT IN ('D')) OR SUBSTRING(NFECFOP,3,3) IN ('556','557') OR (A.LESCOD = 6 AND SUBSTRING(NFECFOP,3,3) IN ('910'))
	THEN 0
	ELSE 
		CASE WHEN NFEVCRESN > 0 
			THEN NFETOTOPEITE
			ELSE A.NFEBASICMS
		END
END AS NFEBASICMS, 

CASE WHEN (NFEVALICMSST > 0 AND B.NFETIP NOT IN ('D')) OR SUBSTRING(NFECFOP,3,3) IN ('556','557') OR (A.LESCOD = 6 AND SUBSTRING(NFECFOP,3,3) IN ('910'))
	THEN 0
	ELSE 
		CASE WHEN NFEVCRESN > 0 
			THEN NFEVCRESN
			ELSE A.NFEVALICMS
		END
END AS NFEVALICMS,

NFEVALIPI AS NFEVALIPI,

NFEVALICMSST AS NFEVALICMSST,

CASE WHEN SUBSTRING(A.NFECFOP,3,3) COLLATE DATABASE_DEFAULT IN (SELECT CFOP FROM #CFOP WHERE TIPO = 'E' AND PAGAR = 'N') AND A.PROCOD COLLATE DATABASE_DEFAULT IN (SELECT PROCOD FROM #TBS010)
	THEN NFETOTOPEITE * 0.0165 
	ELSE 0 
END AS PIS, 

CASE WHEN SUBSTRING(A.NFECFOP,3,3) COLLATE DATABASE_DEFAULT IN (SELECT CFOP FROM #CFOP WHERE TIPO = 'E' AND PAGAR = 'N') AND A.PROCOD COLLATE DATABASE_DEFAULT IN (SELECT PROCOD FROM #TBS010)
	THEN NFETOTOPEITE * 0.076 
	ELSE 0
END AS COFINS,

ISNULL((SELECT TRNMUNCOD FROM TBS005 I (NOLOCK) WHERE I.TRNCGC = SUBSTRING(H.CTEENTCHA,7,14)),0) AS TRNMUNCOD,
@MUNCOD AS EMPMUNCOD

INTO #NFE
FROM TBS0591 A (NOLOCK)
INNER JOIN TBS059 B (NOLOCK) ON A.NFEEMPCOD = B.NFEEMPCOD AND A.NFECOD = B.NFECOD AND A.NFENUM = B.NFENUM AND A.NFETIP = B.NFETIP AND A.SERCOD = B.SERCOD AND  A.SEREMPCOD = B.SEREMPCOD
LEFT JOIN #TBS080 D ON A.NFENUM = D.ENFNUM AND A.NFECOD = D.ENFCODDES
LEFT JOIN #TBS006 E ON A.NFECOD = E.FORCOD
LEFT JOIN #TBS002 F ON A.NFECOD = F.CLICOD
LEFT JOIN #NCM    G ON A.PROCOD = G.PROCOD
LEFT JOIN TBS1301 H (NOLOCK) ON B.NFECHAACE = H.CTEENTCHADOC

WHERE 
(ENFNUM IS NOT NULL OR (NFENOSFOR <>'S' AND B.NFECAN <> 'S' AND NFEDATEFE <> '')) AND
B.NFEDATEFE BETWEEN @Data_de AND @Data_ate 

--GROUP BY 
--B.NFEDATEMI,
--B.SERCOD,
--B.NFEDATEFE,
--B.NFENUM,
--B.NFECHAACE,
--B.NFECAN,
--CLICGC,
--FORCGC,
--CLINOM,
--E.FORNOM,
--CLIEND ,
--FOREND,
--CLIBAI, 
--FORBAI,
--F.MUNNOM,
--E.MUNNOM,
--F.UF,
--E.UF,
--CLICEP,
--FORCEP,
--CLIIES,
--FORIES,
--NFECFOP,
--B.NFETIP

UNION 

-- BUSCAR VALORES NO CONTAS A PAGAR

SELECT 
-- 0 AS REG,
0 AS NFEITE,
'' COLLATE DATABASE_DEFAULT AS PROCOD,
'' COLLATE DATABASE_DEFAULT AS NFEDES,
0 AS NFEQTD,
'' COLLATE DATABASE_DEFAULT AS NFEUNI,
0 AS NFEPRE,
CPACFOP COLLATE DATABASE_DEFAULT  AS NFECFOP,
'' COLLATE DATABASE_DEFAULT AS NCM,
CPAALIICMS AS NFEPERICMS,
0 AS NFEBASIPI,
0 AS NFEPERIPI,
0 AS NFEVALFREITE,
0 AS NFEVALOUTDES,
0 AS NFEVALFREITECTE,
'' COLLATE DATABASE_DEFAULT AS NFESUBTIPITE,  
0 AS NFEVALDESITE,
'' COLLATE DATABASE_DEFAULT AS NFECST,
0 AS NFEBASICMSST,
@CNPJ COLLATE DATABASE_DEFAULT AS CNPJEMP,
CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103) AS DATALANCAMENTO,
CPATIT,
0,
FORCGC,
CPADATEMI,
'ENE',
'E',
'',
'N',
E.FORNOM AS NOME,
FOREND AS ENDERECO,
FORBAI AS BAIRRO,
E.MUNNOM AS MUNICIPIO,
E.UF AS UF,
FORCEP AS CEP ,
FORIES AS IES,
CPAVAL AS NFETOTOPEITE,
CPAVAL AS NFETOTOPEITE,
CPABASCAL AS NFEBASCAL,
CPABASCAL*  CPAALIICMS / 100 AS NFEVALICMS,
0,
0,
0 AS COFINS, -- energia não contabiliza PiS e COfins segundo o Ronaldo 21/02/2018
0 AS PIS,
0,
0

FROM TBS057 A (NOLOCK) 
LEFT JOIN #TBS006 E ON A.FORCOD = E.FORCOD

WHERE 
CASE WHEN CPAREFMES > 0 
	THEN CONVERT(DATETIME,CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103))
	ELSE CONVERT(DATETIME,'17530101')
END BETWEEN @Data_de AND @Data_ate AND 
SUBSTRING(CPACFOP,3,3) COLLATE DATABASE_DEFAULT IN (SELECT CFOP FROM #CFOP WHERE TIPO = 'E' AND PAGAR = 'S')

--GROUP BY 
--CONVERT(CHAR(10),'02/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103),
--CPATIT,
--FORCGC,
--CPADATEMI,
--E.FORNOM ,
--FOREND ,
--FORBAI ,
--E.MUNNOM ,
--E.UF ,
--FORCEP  ,
--FORIES ,
--CPAALIICMS,
--CPAALICOFINS,
--CPAALIPIS,
--CPAREFMES,
--CPAREFANO

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#TXT') is not null
begin
	drop table #TXT
end

SELECT 
0 as REG,
CNPJEMP,
NFEDATEFE,
NFENUM,
SERIE,
CNPJ,
NFEDATEMI,
SERCOD,
TIPO,
NFECHAACE,
NFECAN,
RTRIM(REPLACE(NOME,';',' ')) AS NOME ,
RTRIM(REPLACE(ENDERECO,';',' ')) AS ENDERECO,
RTRIM(REPLACE(BAIRRO,';',' ')) AS BAIRRO,
RTRIM(REPLACE(MUNICIPIO,';',' ')) AS MUNICIPIO,
RTRIM(REPLACE(UF,';',' ')) AS UF,
RTRIM(REPLACE(CEP,';',' ')) AS CEP,
RTRIM(REPLACE(IES,';',' ')) AS IES,
ROUND(SUM(NFETOTITEBRU),2) AS NFETOTITEBRU,
ROUND(SUM(NFETOTOPEITE),2) AS NFETOTOPEITE,
ROUND(SUM(NFEBASICMS),2) AS NFEBASICMS, 
ROUND(SUM(NFEVALICMS),2) AS NFEVALICMS,
ROUND(SUM(NFEVALIPI),2) AS NFEVALIPI,
ROUND(SUM(NFEVALICMSST),2) AS NFEVALICMSST,
ROUND(SUM(PIS),2) AS PIS , 
ROUND(SUM(COFINS),2) AS COFINS,
ROUND(SUM(NFEVALFREITECTE),2) AS NFEVALFREITECTE,
TRNMUNCOD, 
CASE WHEN TRNMUNCOD > 0 THEN EMPMUNCOD ELSE 0 END AS EMPMUNCOD

INTO #TXT
FROM #NFE

GROUP BY 
CNPJEMP,
NFEDATEFE,
NFENUM,
SERIE,
CNPJ,
NFEDATEMI,
SERCOD,
TIPO,
NFECHAACE,
NFECAN,
NOME,
ENDERECO,
BAIRRO,
MUNICIPIO,
UF,
CEP ,
IES,
TRNMUNCOD, 
EMPMUNCOD

-- SELECT * FROM #TXT

--SELECT CHARINDEX(';',NOME) AS NOME ,
--CHARINDEX(';',ENDERECO) AS ENDERECO, 
--CHARINDEX(';',BAIRRO) AS BAIRRO,
--CHARINDEX(';',MUNICIPIO) AS MUNICIPIO, 
--CHARINDEX(';',UF) AS UF,
--CHARINDEX(';',CEP) AS CEP, 
--CHARINDEX(';',IES) AS IES
--
--FROM #NFE 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ARQUIVOS DO CABEÇALHO

SELECT 
LTRIM(STR(REG))+';'+					-- Tipo do Registro
CNPJEMP+';'+							-- CNPJ da Tanby
CONVERT(CHAR(10),NFEDATEFE,103)+';'+	-- Data de Entrada (efetivação)
LTRIM(STR(NFENUM))+';'+					-- Numero Nota
LTRIM(STR(SERIE))+';'+					-- Serie
CNPJ COLLATE DATABASE_DEFAULT+';'+		-- Cnpj do Cliente/fornecedor
CONVERT(CHAR(10),NFEDATEMI,103)+';'+	-- Data de Emissao
SERCOD+';'+								-- Especie (NF/NFE/CTR/A-SERVICOS)
TIPO+';'+								-- Tipo Nota Fiscal E-entrada S-saida
NFECHAACE+';'+							-- Chave nfe
NFECAN+';'+								-- Cancelada
NOME+';'+								-- Razão Social
ENDERECO+';'+							-- Endereco
BAIRRO+';'+								-- Bairro
MUNICIPIO+';'+							-- Cidade
UF+';'+									-- Sigla da UF
CEP+';'+								-- Cep
IES+';'+								-- Inscricao Estadual		
LTRIM(NFETOTITEBRU)+';'+				-- Valor Total Produto
LTRIM(NFETOTOPEITE)+';'+				-- Total da Nota Fiscal
LTRIM(NFEBASICMS)+';'+					-- Base de Icms
LTRIM(NFEVALICMS)+';'+					-- Valor do Icms
LTRIM(NFEVALIPI)+';'+					-- Valor do Ipi	
LTRIM(NFEVALICMSST)+';'+				-- Valor da ST
LTRIM(PIS)+';'+							-- Pis 
LTRIM(COFINS)+';'+						-- Cofins
ltrim(str(0))+';'+						-- Imposto de Renda Retido na Fonte (IRRF)
LTRIM(NFEVALFREITECTE)+';'+				-- FRETE POR NOTA 
LTRIM(TRNMUNCOD)+';'+					-- MUNICIPIO DA TRANSPORTADORA (INICIO) 
LTRIM(EMPMUNCOD)+';'					-- MUNICIPIO DO DESTINATARIO (FIM)

FROM #TXT

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ARQUIVOS DOS ITENS

SELECT 
LTRIM(STR(1))+';'+						-- Tipo do Registro
CNPJEMP+';'+								-- CNPJ da Tanby
CONVERT(CHAR(10),NFEDATEFE,103)+';'+		-- Data de Entrada (efetivação)
LTRIM(STR(NFENUM))+';'+						-- Numero Nota
LTRIM(STR(SERIE))+';'+						-- Serie
CNPJ COLLATE DATABASE_DEFAULT+';'+			-- Cnpj do Cliente/fornecedor
LTRIM(STR(NFEITE))+';'+						-- Sequencia
LTRIM(RTRIM(PROCOD))+';'+					-- Codigo do produto
LTRIM(RTRIM(NFEDES))+';'+					-- Descrição do produto
LTRIM(STR(NFEQTD))+';'+						-- QUANTIDADE
LTRIM(NFEUNI)+';'+							-- Unidade de Medida
LTRIM(NFEPRE)+';'+							-- Valor Unitario
LTRIM(NFECFOP)+';'+							-- CFOP
LTRIM(NCM) +';'+							-- Ncm conforme nota fiscal, a partir de 26/02/018 conforme ao cadastro solicitação do ronaldo
LTRIM(NFETOTITEBRU)+';'+					-- Valor total do Item
LTRIM(NFEBASICMS)+';'+						-- BASE ICMS
LTRIM(NFEPERICMS)+';'+						-- % de Icms AliquotaIcms
LTRIM(NFEVALICMS)+';'+						-- Valor do Icms
LTRIM(NFEBASIPI)+';'+						-- Base do Ipi
LTRIM(NFEPERIPI)+';'+						-- % de Ipi AliquotaIpi
LTRIM(NFEVALIPI)+';'+						-- Valor do Ipi
LTRIM(NFEVALICMSST)+';'+					-- Valor da ST
LTRIM(NFEVALFREITE)+';'+					-- Valor do Frete
LTRIM(NFEVALOUTDES)+';'+					-- Valor de Outras Despesas
LTRIM(NFESUBTIPITE)+';'+					-- Classificacao REVENDA/IMOBILIZADO/CONSUMO/SERVIÇO/OUTROS
LTRIM(NFEVALDESITE)+';'+					-- desconto por item 
LTRIM(NFECST)+';'+							-- cst por item 
LTRIM(NFEBASICMSST)+';'						-- cst por item 

FROM #NFE

WHERE 
SERCOD <> 'ENE'

-- SELECT * FROM #NFE

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#NFE3') is not null
begin
	drop table #NFE3
end

SELECT
2 AS REG,
@CNPJ AS CNPJEMP,
B.NFEDATEFE,
B.NFENUM,
0 AS SERIE,
CASE WHEN B.NFETIP = 'D' 
	THEN CLICGC
	ELSE FORCGC
END AS CNPJ,
ROW_NUMBER() OVER (Partition by A.NFEEMPCOD,A.NFECOD,A.NFENUM,A.NFETIP,A.SERCOD,A.SEREMPCOD order by A.NFEDATVEN) AS PARCELA,
A.NFEDATVEN, 
NFEVALPAR

INTO #NFE3
FROM TBS0593 A (NOLOCK)
INNER JOIN TBS059 B (NOLOCK) ON A.NFEEMPCOD = B.NFEEMPCOD AND A.NFECOD = B.NFECOD AND A.NFENUM = B.NFENUM AND 
A.NFETIP COLLATE DATABASE_DEFAULT = B.NFETIP AND A.SERCOD COLLATE DATABASE_DEFAULT = B.SERCOD AND  A.SEREMPCOD = B.SEREMPCOD
LEFT JOIN TBS080 D (NOLOCK) ON A.NFENUM = D.ENFNUM AND A.NFECOD = D.ENFCODDES
LEFT JOIN #TBS006 E ON A.NFECOD = E.FORCOD
LEFT JOIN #TBS002 F ON A.NFECOD = F.CLICOD

WHERE 
((D.ENFSIT = 6 AND D.ENFFINEMI = 4 AND D.ENFTIPDOC = 0) OR ((NFENOSFOR = 'N' OR NFENOSFOR = '') AND (B.NFECAN = 'N' OR B.NFECAN = '') AND NFEDATEFE <> '' )) AND
B.NFEDATEFE BETWEEN @Data_de AND @Data_ate 
--AND LEN(A.NFECST) >= 4 

UNION 

-- BUSCAR VALORES NO CONTAS A PAGAR

SELECT 
2 AS REG,
@CNPJ AS CNPJEMP,
CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103) AS DATALANCAMENTO,
CPATIT,
0,
FORCGC,
1,
CPADATVENREA,
ROUND(CPAVAL,2) AS NFETOTOPEITE

FROM 
TBS057 A (NOLOCK) 
LEFT JOIN #TBS006 E ON A.FORCOD = E.FORCOD

WHERE
CASE WHEN CPAREFMES > 0 
	THEN CONVERT(DATETIME,CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103))
	ELSE CONVERT(DATETIME,'17530101')
END BETWEEN @Data_de AND @Data_ate AND 
CPACFOP COLLATE DATABASE_DEFAULT IN (SELECT CFOP FROM #CFOP WHERE TIPO = 'E' AND PAGAR = 'S')

-- SELECT DISTINCT NFESUBTIPITE FROM TBS0591 NOLOCK
-- SELECT * FROM TBS0591 NOLOCK WHERE NFESUBTIPITE = 'V' AND NFETIP <> 'D'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- ARQUIVOS DE PARCELA DE PAGAMENTOS

SELECT 
LTRIM(STR(REG))+';'+					-- Tipo do Registro
CNPJEMP+';'+							-- CNPJ da Tanby
CONVERT(CHAR(10),NFEDATEFE,103)+';'+	-- Data de Entrada (efetivação)
LTRIM(STR(NFENUM))+';'+					-- Numero Nota
LTRIM(STR(SERIE))+';'+					-- Serie
CNPJ COLLATE DATABASE_DEFAULT+';'+		-- Cnpj do Cliente/fornecedor
LTRIM(STR(PARCELA))+';'+				-- Parcela
CONVERT(CHAR(10),NFEDATVEN,103)+';'+	-- Data do vencimento
LTRIM(NFEVALPAR)+';'					-- Valor Parcela

FROM #NFE3

-- SELECT * FROM #NFE

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Arquivos CTE

if object_id('tempdb.dbo.#TBS059') is not null
   drop table #TBS059

SELECT NFECHAACE, NFEDATEFE, NFECOD, NFECAN INTO #TBS059 FROM TBS059 (nolock) 

WHERE 
NFENOSFOR <>'S' AND NFECAN <> 'S' AND NFEDATEFE <> '' AND
NFEDATEFE BETWEEN @Data_de AND @Data_ate AND 
NFECHAACE <> ''

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DADOS DA TRANSPORTADORA 

if object_id('tempdb.dbo.#TBS005') is not null
begin
	drop table #TBS005
end

SELECT 
TRNCOD,
TRNCGC,
TRNNOM,
RTRIM(TRNEND) + CASE WHEN CHARINDEX(RTRIM(LTRIM(TRNNUM)),RTRIM(TRNEND)) > 0 THEN '' ELSE ' - N° ' + RTRIM(LTRIM(TRNNUM)) END AS TRNEND,
TRNBAI,
TRNMUNCOD,
(SELECT MUNNOM FROM TBS003 B (NOLOCK) WHERE A.TRNMUNCOD = B.MUNCOD) AS MUNNOM,
TRNUFESIG AS UF,
TRNCEP ,
CASE WHEN RTRIM(LTRIM(TRNIES)) LIKE('ISE%')
	THEN ''
	ELSE RTRIM(LTRIM(TRNIES)) 
END AS TRNIES

INTO #TBS005
FROM TBS005 A (NOLOCK)  

-- SELECT * FROM #TBS005

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#CTE') is not null
begin
	drop table #CTE
end

SELECT
@CNPJ AS CNPJEMP,
NFEDATEFE,
CTEENTNUM AS NFENUM,
CTEENTSER AS SERIE,
TRNCGC AS CNPJ,
CTEENTDATEMI AS NFEDATEMI,
'CTE' AS SERCOD,
'E' AS TIPO,
H.CTEENTCHA AS NFECHAACE,
B.NFECAN,
TRNNOM AS NOME,
TRNEND AS ENDERECO,
TRNBAI AS BAIRRO,
MUNNOM AS MUNICIPIO,
UF,
TRNCEP AS CEP,
TRNIES AS IES,
CTEENTFREVAL AS NFETOTITEBRU,
CTEENTVALDOCFRE as NFETOTOPEITE,
CASE WHEN CTEENTBASICM > 0 
	THEN CTEENTVALDOCFRE
	ELSE 0
END AS NFEBASICMS,
CASE WHEN CTEENTBASICM > 0 
	THEN (CTEENTVALDOCFRE * ((100 - CTEENTBASRED) / 100)) * CTEENTPERICM / 100
	ELSE 0
END AS NFEVALICMS,
0 AS NFEVALIPI,
0 AS NFEVALICMSST,
ROUND(CTEENTVALDOCFRE * 0.0165,2)   AS PIS,				-- VALOR PIS
ROUND(CTEENTVALDOCFRE * 0.076,2) 	AS COFINS,			-- VALOR COFINS
0 AS NFEVALFREITECTE,
TRNMUNCOD,
@MUNCOD AS EMPMUNCOD,
CTEENTNUMDOC AS NFENUMFRETE

INTO #CTE
FROM #TBS059 B (NOLOCK)
INNER JOIN TBS1301 H (NOLOCK) ON B.NFECHAACE = H.CTEENTCHADOC
INNER JOIN TBS130 I (NOLOCK) ON H.CTEENTEMP = I.CTEENTEMP AND H.CTEENTCHA = I.CTEENTCHA
LEFT JOIN #TBS005 E ON I.TRNCOD = E.TRNCOD

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('tempdb.dbo.#TXTCTE') is not null
begin
	drop table #TXTCTE
end

SELECT 
0 as REG,
CNPJEMP,
NFEDATEFE,
NFENUM,
SERIE,
CNPJ,
NFEDATEMI,
SERCOD,
TIPO,
NFECHAACE,
NFECAN,
RTRIM(REPLACE(NOME,';',' ')) AS NOME ,
RTRIM(REPLACE(ENDERECO,';',' ')) AS ENDERECO,
RTRIM(REPLACE(BAIRRO,';',' ')) AS BAIRRO,
RTRIM(REPLACE(MUNICIPIO,';',' ')) AS MUNICIPIO,
RTRIM(REPLACE(UF,';',' ')) AS UF,
RTRIM(REPLACE(CEP,';',' ')) AS CEP,
RTRIM(REPLACE(IES,';',' ')) AS IES,
ROUND(SUM(NFETOTITEBRU),2) AS NFETOTITEBRU,
ROUND(SUM(NFETOTOPEITE),2) AS NFETOTOPEITE,
ROUND(SUM(NFEBASICMS),2) AS NFEBASICMS, 
ROUND(SUM(NFEVALICMS),2) AS NFEVALICMS,
ROUND(SUM(NFEVALIPI),2) AS NFEVALIPI,
ROUND(SUM(NFEVALICMSST),2) AS NFEVALICMSST,
ROUND(SUM(PIS),2) AS PIS , 
ROUND(SUM(COFINS),2) AS COFINS,
ROUND(SUM(NFEVALFREITECTE),2) AS NFEVALFREITECTE,
TRNMUNCOD, 
CASE WHEN TRNMUNCOD > 0 THEN EMPMUNCOD ELSE 0 END AS EMPMUNCOD,
NFENUMFRETE

INTO #TXTCTE
FROM #CTE

GROUP BY 
CNPJEMP,
NFEDATEFE,
NFENUM,
SERIE,
CNPJ,
NFEDATEMI,
SERCOD,
TIPO,
NFECHAACE,
NFECAN,
NOME,
ENDERECO,
BAIRRO,
MUNICIPIO,
UF,
CEP ,
IES,
TRNMUNCOD, 
EMPMUNCOD,
NFENUMFRETE

-- SELECT * FROM #TXT

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Arquivos TXT dos CTEs

SELECT 
LTRIM(STR(REG))+';'+					-- Tipo do Registro
CNPJEMP+';'+							-- CNPJ da Tanby
CONVERT(CHAR(10),NFEDATEFE,103)+';'+	-- Data de Entrada (efetivação)
LTRIM(STR(NFENUM))+';'+					-- Numero Nota
LTRIM(STR(SERIE))+';'+					-- Serie
CNPJ COLLATE DATABASE_DEFAULT+';'+		-- Cnpj do Cliente/fornecedor
CONVERT(CHAR(10),NFEDATEMI,103)+';'+	-- Data de Emissao
SERCOD+';'+								-- Especie (NF/NFE/CTR/A-SERVICOS)
TIPO+';'+								-- Tipo Nota Fiscal E-entrada S-saida
NFECHAACE+';'+							-- Chave nfe
NFECAN+';'+								-- Cancelada
NOME+';'+								-- Razão Social
ENDERECO+';'+							-- Endereco
BAIRRO+';'+								-- Bairro
MUNICIPIO+';'+							-- Cidade
UF+';'+									-- Sigla da UF
CEP+';'+								-- Cep
IES+';'+								-- Inscricao Estadual		
LTRIM(NFETOTITEBRU)+';'+				-- Valor Total Produto
LTRIM(NFETOTOPEITE)+';'+				-- Total da Nota Fiscal
LTRIM(NFEBASICMS)+';'+					-- Base de Icms
LTRIM(NFEVALICMS)+';'+					-- Valor do Icms
LTRIM(NFEVALIPI)+';'+					-- Valor do Ipi	
LTRIM(NFEVALICMSST)+';'+				-- Valor da ST
LTRIM(PIS)+';'+							-- Pis 
LTRIM(COFINS)+';'+						-- Cofins
ltrim(str(0))+';'+						-- Imposto de Renda Retido na Fonte (IRRF)
LTRIM(NFEVALFREITECTE)+';'+				-- FRETE POR NOTA 
LTRIM(TRNMUNCOD)+';'+					-- MUNICIPIO DA TRANSPORTADORA (INICIO) 
LTRIM(EMPMUNCOD)+';'+					-- MUNICIPIO DO DESTINATARIO (FIM)
LTRIM(NFENUMFRETE)+';'					-- NUMERO DA NOTA VINCULADA AO FRETE

FROM #TXTCTE

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Cadastro Contmatic

SELECT 
PROCOD AS 'COD_ITEM',
PRODES AS 'DESCR_ITEM',
PROCODBAR1 AS 'COD_BARRA',
'' AS 'COD_ANT_ITEM',
PROUM1 AS 'UNID-INV',
'REVENDA' AS 'TIPO_ITEM', -- 			= Tipo do Item(Característica. Ex: Matéria Prima, Merc. para Rev., Embalagem e etc.)
SUBSTRING(PROCLAFIS,1,4)+'.'+SUBSTRING(PROCLAFIS,5,2)+'.'+SUBSTRING(PROCLAFIS,6,2) AS 'COD_NCM', --			= Código da Nomenclatura Comum do MERCOSUL

'' AS EX_IPI, -- 		= Código EX, conforme a TIPI
'' AS COD_LST, --		= Código do Serviço(conforme lista do anexo I da Lei Complementar Federal nº116/03)
'' AS COD_SERV_BLOCO_P, -- NÃO TEM NO WORD

CASE WHEN PROALIICMSINT = 0
	THEN '0'
	ELSE STR(REPLACE(PROALIICMSINT,'.',','))
END AS 'ALIQ_ICMS', -- 			= Alíquota do ICMS

'' AS COD_GRUPO	,--		= Código do Grupo(Inventário)
'' AS DESC_GRUPO ,--	= Descrição do Grupo(Inventário)
'' AS COD_SEFAZ	,--		= Código SEFAZ(Combustível)

CASE WHEN RTRIM(LTRIM(STR(PROSTBA)))+RTRIM(LTRIM(STR(PROCSN))) = '00'
	THEN '000'
	ELSE RTRIM(LTRIM(STR(PROSTBA)))+RTRIM(LTRIM(STR(PROCSN)))
END AS 'CSOSN', --		= Código de Situação da Operação do Simples Nacional

CASE WHEN RTRIM(LTRIM(STR(PROSTBA)))+RTRIM(LTRIM(STR(PROSTBB))) = '00'
	THEN '000'
	ELSE RTRIM(LTRIM(STR(PROSTBA)))+RTRIM(LTRIM(STR(PROSTBB)))
END AS 'CST_ICMS', --			= Código de Situação Tributaria do ICMS

REPLACE(PROREDBASICMS,'.',',') AS 'PER_RED_BC_ICMS', --		= Percentual de Redução da Base de Cálculo do ICMS

'' AS BC_ICMS_ST, --			= Base de Cálculo do ICMS de Substituição Tributária

PROSTBIPIE AS 'CST_IPI_ENTRADA', -- 	= Código de Situação Tributaria do IPI para Entrada
PROSTBIPI AS 'CST_IPI_SAIDA',    --		= Código de Situação Tributaria do IPI para Saída

'' AS ALIQ_IPI, --			= Alíquota de IPI

CASE WHEN PROSTBPIS = ''
	THEN '01'
	ELSE PROSTBPIS
END AS 'CST_PIS_COFINS_SAIDA' ,-- 	= Código de Situação Tributaria do PIS/COFINS para Saída

'' AS 'CST_PIS_COFINS_ENTRADA', -- 	= Código de Situação Tributaria do PIS/COFINS para Entrada

'' AS AT_REC_PIS_COFINS, --	= Natureza da Receita de PIS/COFINS(Conforme tabelas 4.3.10 à 4.3.16 do SPED)

REPLACE(PROPIS,'.',',')    AS 'ALIQ_PIS', -- 		= Alíquota do PIS
REPLACE(PROCOFINS,'.',',') AS 'ALIQ_COFINS', -- 	= Alíquota da COFINS

'' AS CC,	--			= Conta Contábil do Item
'' AS OBSERVACAO, --	= Observação para o Item

PROCEST AS 'COD_CEST' -- 	= Código CEST (Código Especificador da Substituição Tributária)

FROM TBS010 (nolock) 

order by 
PROCOD


--SELECT * FROM TBS010 WHERE PROSTBB>0


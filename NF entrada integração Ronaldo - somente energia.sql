-- ARQUIVO TXT DE ENTRADA PARA REALIZAR SPED -- DADOS DA NF 

-- 05118717000156 -- BEST BAG
-- 65069593000350 -- CD
-- 52080207000117 -- Misaspel
-- 65069593000198 -- TANBY ND
-- 44125185000136 -- PAPELYNA
-- 65069593000279 -- TTE

-- FILTROS
DECLARE @Data_de DATETIME , @Data_ate DATETIME , @NFSTIP CHAR(1) , @CFOP CHAR(100), @NFSSUBTIP CHAR(13), @CNPJ CHAR(14),@anoDe varchar (4), @mesDe varchar (2)
SET @Data_de = '20171101'
SET @Data_ate = '20171130'
SET @CNPJ = '65069593000350'
SET @anoDe = (select substring(convert(char(10),@Data_de,103),7,4))
SET @mesDe = (select substring(convert(char(10),@Data_de,103),4,2))

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- ESSES CFOP NÃO PODE APARECER NO RELATORIO DE ICMS

if object_id('TempDB.dbo.#CFOP') is not null
   drop table #CFOP
   
create table #CFOP (TIPO CHAR (1), CFOP CHAR(5), PAGAR CHAR(1))

-- ENTRADAS '1.922','2.922', VALOR ANTECIPADO '1.403','2.403' -- PAGAR '1.252','1.352','2.352'
--INSERT INTO #CFOP VALUES ('E','1.403','N') -- ESSE VALOR TENHO QUE ZERAR NO RELATORIO -- VALOR ANTECIPADO
--INSERT INTO #CFOP VALUES ('E','2.403','N') -- ESSE VALOR TENHO QUE ZERAR NO RELATORIO -- VALOR ANTECIPADO
--INSERT INTO #CFOP VALUES ('E','1.922','N')
--INSERT INTO #CFOP VALUES ('E','2.922','N')
INSERT INTO #CFOP VALUES ('E','1.252','S') -- ESE VAI APARECER SOMENTE NO CONTAS A PAGAR
INSERT INTO #CFOP VALUES ('E','1.253','S')
INSERT INTO #CFOP VALUES ('E','1.352','S') -- ESE VAI APARECER
INSERT INTO #CFOP VALUES ('E','2.352','S') -- ESE VAI APARECER
--
---- SAIDAS '5.922','6.922'
--INSERT INTO #CFOP VALUES ('S','5.922','N')
--INSERT INTO #CFOP VALUES ('S','6.922','N')

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DADOS DO FORNECEDOR 

if object_id('TempDB.dbo.#TBS006') is not null
   drop table #TBS006

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
FORIES

INTO #TBS006
FROM TBS006 A (NOLOCK)  


---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DADOS DO CLIENTE 

if object_id('TempDB.dbo.#TBS002') is not null
   drop table #TBS002

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

if object_id('TempDB.dbo.#NFE') is not null
   drop table #NFE


-- BUSCAR VALORES NO CONTAS A PAGAR

SELECT 
0 AS REG,
@CNPJ AS CNPJEMP,
CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103) AS NFEDATEFE,
CPATIT as NFENUM,
0 as SERIE,
FORCGC AS CNPJ,
CPADATEMI AS NFEDATEMI, 
'ENE' AS SERCOD,
'E' AS TIPO,
'' AS NFECHAACE,
'N' AS NFECAN,
E.FORNOM AS NOME,
FOREND AS ENDERECO,
FORBAI AS BAIRRO,
E.MUNNOM AS MUNICIPIO,
E.UF AS UF,
FORCEP AS CEP ,
FORIES AS IES,
SUM(ROUND(CPAVAL,2)) AS NFETOTITE,
SUM(ROUND(CPAVAL,2)) AS NFETOTOPEITE,
SUM(ROUND(CPABASCAL,2)) AS NFEBASICMS,
ROUND(SUM(ROUND(CPABASCAL,2)) *  CPAALIICMS / 100 ,2) AS NFEVALICMS,
0 AS NFEVALIPI,
0 AS NFEVALICMSST ,
ROUND(SUM(ROUND(CPAVAL,2)) * CPAALICOFINS /100,2) AS COFINS,
ROUND(SUM(ROUND(CPAVAL,2)) * CPAALIPIS /100 ,2) AS PIS

INTO #NFE
FROM 
TBS057 A (NOLOCK) 
LEFT JOIN #TBS006 E ON A.FORCOD = E.FORCOD

WHERE 
CASE WHEN CPAREFMES > 0 
	THEN CONVERT(DATETIME,CONVERT(CHAR(10),CASE WHEN CPAREFMES = 2 THEN '28' ELSE '30' END + '/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103))
	ELSE CONVERT(DATETIME,'17530101')
END BETWEEN @Data_de AND @Data_ate AND 
CPACFOP COLLATE DATABASE_DEFAULT IN (SELECT CFOP FROM #CFOP WHERE TIPO = 'E' AND PAGAR = 'S')

GROUP BY 
CONVERT(CHAR(10),'02/'+right(('0' + ltrim(str(CPAREFMES))),2)+'/'+LTRIM(STR(CPAREFANO)),103),
CPATIT,
FORCGC,
CPADATEMI,
E.FORNOM ,
FOREND ,
FORBAI ,
E.MUNNOM ,
E.UF ,
FORCEP  ,
FORIES ,
CPAALIICMS,
CPAALICOFINS,
CPAALIPIS,
CPAREFMES,
CPAREFANO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------

if object_id('TempDB.dbo.#TXT') is not null
   drop table #TXT

SELECT 
REG,
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
SUM(NFETOTITE) AS NFETOTITE,
SUM(NFETOTOPEITE) AS NFETOTOPEITE,
SUM(NFEBASICMS) AS NFEBASICMS, 
SUM(NFEVALICMS) AS NFEVALICMS,
SUM(NFEVALIPI) AS NFEVALIPI,
SUM(NFEVALICMSST) AS NFEVALICMSST,
SUM(PIS) AS PIS , -- TOTAL NOTA - IPI * 0.0165 = PIS
SUM(COFINS) AS COFINS

INTO #TXT
FROM #NFE

GROUP BY 
REG,
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
IES

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
LTRIM(NFETOTITE)+';'+					-- Valor Total Produto
LTRIM(NFETOTOPEITE)+';'+				-- Total da Nota Fiscal
LTRIM(NFEBASICMS)+';'+					-- Base de Icms
LTRIM(NFEVALICMS)+';'+					-- Valor do Icms
LTRIM(NFEVALIPI)+';'+					-- Valor do Ipi	
LTRIM(NFEVALICMSST)+';'+				-- Valor da ST
LTRIM(PIS)+';'+							-- Pis 
LTRIM(COFINS)+';'+						-- Cofins
ltrim(str(0))+';'						-- Imposto de Renda Retido na Fonte (IRRF)

FROM #TXT



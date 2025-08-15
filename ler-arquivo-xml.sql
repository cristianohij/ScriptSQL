DECLARE @XML XML
SET @XML = (
SELECT CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK N'C:\temp\nfe\35150465069593000198550010001571361746007406-procNfe.xml', SINGLE_BLOB) -- Informe onde se encontra o arquivo XML
AS Arquivo)

-- Este ponto deve ser informado o NAMESPACE (xmlns), senão informar esta linha ele não retorna.
;WITH XMLNAMESPACES(DEFAULT 'http://www.portalfiscal.inf.br/nfe') 
SELECT
NFe.value('cUF[1]', 'int') AS cUF
,      NFe.value('cNF[1]', 'int') AS cNF
,      NFe.value('../emit[1]/CNPJ[1]','varchar(20)') AS CNPJ
,      NFe.value('../emit[1]/enderEmit[1]/xLgr[1]','varchar(max)') AS xLgr
,      NFe.value('../emit[1]/enderEmit[1]/nro[1]','varchar(50)') AS nro
,      NFe.value('../emit[1]/enderEmit[1]/xBairro[1]','varchar(max)') AS xBairro
FROM @XML.nodes('//infNFe/ide') AS NFes(NFe) 


DECLARE @XML XML
SET @XML = (
SELECT CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK N'C:\temp\nfe\35150465069593000198550010001571361746007406-procNfe.xml', SINGLE_BLOB) -- Informe onde se encontra o arquivo XML
AS Arquivo)

-- Este ponto deve ser informado o NAMESPACE (xmlns), senão informar esta linha ele não retorna.
;WITH XMLNAMESPACES(DEFAULT 'http://www.portalfiscal.inf.br/nfe') 
SELECT
NFe.value('../det[8]/prod[1]/cProd[1]', 'varchar(15)') AS cProd
FROM @XML.nodes('//infNFe/ide') AS NFes(NFe) 

SELECT
    X.ide.query('cUF').value('.', 'CHAR(2)')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\nfe\35150465069593000198550010001571361746007406-procNfe.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('NFe/infNFe/ide') AS X(ide)

SELECT cast(BulkColumn as XML) FROM
OPENROWSET(BULK N'C:\temp\xml-nfe.xml', SINGLE_BLOB)
AS Arquivo

DECLARE @XML XML
SET @XML = (
SELECT CAST(BulkColumn AS XML)
FROM OPENROWSET(BULK N'C:\temp\xml-nfe.xml', SINGLE_BLOB)
AS Arquivo);

WITH XMLNAMESPACES(DEFAULT 'http://www.portalfiscal.inf.br/nfe')
SELECT
NFe.value('cUF[1]', 'int') AS cUF
,      NFe.value('cNF[1]', 'int') AS cNF
,      NFe.value('../emit[1]/CNPJ[1]','varchar(20)') AS CNPJ
,      NFe.value('../emit[1]/enderEmit[1]/xLgr[1]','varchar(max)') AS xLgr
,      NFe.value('../emit[1]/enderEmit[1]/nro[1]','varchar(50)') AS nro
,      NFe.value('../emit[1]/enderEmit[1]/xBairro[1]','varchar(max)') AS xBairro
FROM @XML.nodes('//infNFe/ide') AS NFes(NFe)

WITH XMLNAMESPACES(DEFAULT 'http://www.portalfiscal.inf.br/nfe')
SELECT
--    X.Prestador.query('CPF').value('.', 'CHAR(14)'),
--    X.Prestador.query('NomeProfissional').value('.', 'VARCHAR(50)'),
--    X.Prestador.query('Empresa').value('.', 'VARCHAR(50)'),
--    X.Prestador.query('CNPJ').value('.', 'CHAR(18)'),
--    X.Prestador.query('Cidade').value('.', 'VARCHAR(40)'),
--    X.Prestador.query('Estado').value('.', 'CHAR(2)'),
--    X.Prestador.query('InscricaoEstadual').value('.', 'VARCHAR(20)')
	X.Prestador.query('cUF').value('.','char(2)')
FROM
( 	
    SELECT CAST(X AS XML)
    FROM OPENROWSET(
        BULK 'C:\temp\xml-nfe.xml',
        SINGLE_BLOB) AS T(X)
) AS T(X)
CROSS APPLY X.nodes('ide') AS X(Prestador);
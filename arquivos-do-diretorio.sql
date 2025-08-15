/*
1) Pasta inicial: caminho da pasta inicial para pesquisa
2) Nivel da busca: 1 é somente a pasta inicial, 0 ou Null são todas as pastas a partir da pasta inicial informada, qualquer valor > 1 é a quantidade de niveis de subpastas a partir da pasta inicial informada.
3) Inclui arquivo: 1 Inclui arquivos e pastas; 0 ou Null só pastas.
*/

EXEC master.dbo.xp_dirtree N'c:\temp', 1, 1

create table #arquivo (arq varchar(500),d smallint,f smallint)

insert into #arquivo EXEC master.dbo.xp_dirtree N'c:\integros\temp', 1, 1

drop table #arquivo

select * from #arquivo

declare @XML XML

--set @XML = (select cast(BulkColumn as XML) from openRowSet(Bulk N'c:\integros\temp\nfe.xml', SINGLE_BLOB) as arquivo)

set @XML = (select cast(arq as XML) from #arquivo where arq='nfe.XML')

-- Informe onde se encontra o arquivo XML AS Arquivo)

-- Este ponto deve ser informado o NAMESPACE (xmlns), senão informar esta linha ele não retorna.
;with XMLnameSpaces(default 'http://www.portalfiscal.inf.br/nfe')
select
NFe.value('cUF[1]','int') as cUF,
NFe.value('cNF[1]','int') as cNF
from @XML.nodes('//infNFe/ide') as NFes(NFe)

;WITH XMLNAMESPACES(DEFAULT ‘http://www.portalfiscal.inf.br/nfe’)
SELECT
NFe.value(‘cUF[1]‘, ‘int’) AS cUF
,      NFe.value(‘cNF[1]‘, ‘int’) AS cNF
,      NFe.value(‘../emit[1]/CNPJ[1]‘,’varchar(20)’) AS CNPJ
,      NFe.value(‘../emit[1]/enderEmit[1]/xLgr[1]‘,’varchar(max)’) AS xLgr
,      NFe.value(‘../emit[1]/enderEmit[1]/nro[1]‘,’varchar(50)’) AS nro
,      NFe.value(‘../emit[1]/enderEmit[1]/xBairro[1]‘,’varchar(max)’) AS xBairro
FROM @XML.nodes(‘//infNFe/ide‘) AS NFes(NFe) -- Caminho que ira iniciar a varredura

select * from @XML
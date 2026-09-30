-- duplicidade entre os cadastros dos clientes

-- CTE para normalizar os endereços das duas tabelas
WITH Enderecos AS (
    -- Endereço principal do cliente (faturamento)
    SELECT
        CLIEMPCOD,
        CLICOD,
        'Principal' AS TipoEndereco,
        RTRIM(LTRIM(CLIEND)) AS Endereco
    FROM TBS002
    WHERE CLIEND IS NOT NULL AND CLIEND <> ''

    UNION ALL

    -- Endereços da tabela TBS0021 (cobrança e entrega)
    SELECT
        CLIEMPCOD,
        CLICOD,
        CASE CLIENDTIP
            WHEN 'C' THEN 'Cobranca'
            WHEN 'E' THEN 'Entrega'
            ELSE 'Outro'
        END AS TipoEndereco,
        RTRIM(LTRIM(CLILOG)) AS Endereco
    FROM TBS0021
    WHERE CLILOG IS NOT NULL AND CLILOG <> ''
)

-- Verifica duplicidades por endereço
SELECT
    e.Endereco,
    COUNT(*) AS QtdeOcorrencias,
    STUFF((
        SELECT ', ' + CAST(e2.CLIEMPCOD AS VARCHAR(5)) + '-' + CAST(e2.CLICOD AS VARCHAR(10)) + ' (' + e2.TipoEndereco + ')'
        FROM Enderecos e2
        WHERE e2.Endereco = e.Endereco
        FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
    , 1, 2, '') AS Clientes
FROM Enderecos e
GROUP BY Endereco
HAVING COUNT(*) > 1
ORDER BY QtdeOcorrencias DESC, Endereco;

-- duplicidade interna do cadastro de cada cliente

-- Verifica duplicidade interna de endereço, número e bairro por cliente

SELECT 
    c.CLIEMPCOD,
    c.CLICOD,
    RTRIM(LTRIM(c.CLIEND)) AS EnderecoPrincipal,
    RTRIM(LTRIM(c.CLINUM)) AS NumeroPrincipal,
    RTRIM(LTRIM(c.CLIBAI)) AS BairroPrincipal,
    rtrim(Ltrim(c.MUNCOD)) as MunicipioPrincipal,
    e.CLIENDTIP,
    RTRIM(LTRIM(e.CLILOG)) AS EnderecoAdicional,
    RTRIM(LTRIM(e.CLIENDNUM)) AS NumeroAdicional,
    RTRIM(LTRIM(e.CLIENDBAI)) AS BairroAdicional,
    rtrim(Ltrim(e.CLIENDMUNCOD)) as MunicipioAdicional
FROM TBS002 c
INNER JOIN TBS0021 e
    ON c.CLIEMPCOD = e.CLIEMPCOD
   AND c.CLICOD   = e.CLICOD
WHERE 
    e.CLILOG IS NOT NULL
    AND (
        RTRIM(LTRIM(c.CLIEND)) = RTRIM(LTRIM(e.CLILOG))     -- verifica endereço
        AND RTRIM(LTRIM(c.CLINUM)) = RTRIM(LTRIM(e.CLIENDNUM)) -- verifica número
        AND RTRIM(LTRIM(c.CLIBAI)) = RTRIM(LTRIM(e.CLIENDBAI)) -- verifica bairro
        and rtrim(Ltrim(c.MUNCOD)) = rtrim(Ltrim(e.CLIENDMUNCOD)) -- verifica município
    )
ORDER BY c.CLIEMPCOD, c.CLICOD, e.CLIENDTIP;

/*
Agora você quer evoluir a verificação de duplicidade exata para duplicidade por similaridade fonética, usando funções como SOUNDEX e DIFFERENCE no SQL Server, para capturar casos onde o endereço, bairro ou município parecem iguais mas têm pequenas diferenças de digitação.
Segue uma versão adaptada do seu script usando SOUNDEX e DIFFERENCE:
*/

SELECT      
    c.CLIEMPCOD,     
    c.CLICOD,     
    RTRIM(LTRIM(c.CLIEND)) AS EnderecoPrincipal,     
    RTRIM(LTRIM(c.CLINUM)) AS NumeroPrincipal,     
    RTRIM(LTRIM(c.CLIBAI)) AS BairroPrincipal,     
    RTRIM(LTRIM(c.MUNCOD)) AS MunicipioPrincipal,     
    e.CLIENDTIP,     
    RTRIM(LTRIM(e.CLILOG)) AS EnderecoAdicional,     
    RTRIM(LTRIM(e.CLIENDNUM)) AS NumeroAdicional,     
    RTRIM(LTRIM(e.CLIENDBAI)) AS BairroAdicional,     
    RTRIM(LTRIM(e.CLIENDMUNCOD)) AS MunicipioAdicional
FROM TBS002 c
INNER JOIN TBS0021 e
    ON c.CLIEMPCOD = e.CLIEMPCOD
   AND c.CLICOD   = e.CLICOD
WHERE e.CLILOG IS NOT NULL
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIEND)), RTRIM(LTRIM(e.CLILOG))) >= 3
  AND RTRIM(LTRIM(c.CLINUM)) = RTRIM(LTRIM(e.CLIENDNUM))
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIBAI)), RTRIM(LTRIM(e.CLIENDBAI))) >= 3
  AND DIFFERENCE(RTRIM(LTRIM(c.MUNCOD)), RTRIM(LTRIM(e.CLIENDMUNCOD))) >= 3
ORDER BY c.CLIEMPCOD, c.CLICOD, e.CLIENDTIP;

/*
A função DIFFERENCE retorna um índice de similaridade de 0 a 4, baseado no SOUNDEX de duas strings:
4 → quase idêntico
3 → razoavelmente semelhante
0-2 → pouco semelhante

Podemos incluir esse índice no SELECT para cada comparação (Endereço, Bairro, Município) e assim visualizar quão próxima é a correspondência.
*/

/*
Para deixar a detecção de duplicidade mais robusta, podemos combinar:
DIFFERENCE para similaridade fonética (SOUNDEX)
COLLATE Latin1_General_CI_AI para ignorar acentos e diferenças de maiúsculas/minúsculas

Segue a versão final do script T-SQL:
*/

SELECT      
    c.CLIEMPCOD,     
    c.CLICOD,     
    RTRIM(LTRIM(c.CLIEND)) AS EnderecoPrincipal,     
    RTRIM(LTRIM(c.CLINUM)) AS NumeroPrincipal,     
    RTRIM(LTRIM(c.CLIBAI)) AS BairroPrincipal,     
    RTRIM(LTRIM(c.MUNCOD)) AS MunicipioPrincipal,     
    e.CLIENDTIP,     
    RTRIM(LTRIM(e.CLILOG)) AS EnderecoAdicional,     
    RTRIM(LTRIM(e.CLIENDNUM)) AS NumeroAdicional,     
    RTRIM(LTRIM(e.CLIENDBAI)) AS BairroAdicional,     
    RTRIM(LTRIM(e.CLIENDMUNCOD)) AS MunicipioAdicional,
    DIFFERENCE(RTRIM(LTRIM(c.CLIEND)) COLLATE Latin1_General_CI_AI, 
               RTRIM(LTRIM(e.CLILOG)) COLLATE Latin1_General_CI_AI) AS DiffEndereco,
    DIFFERENCE(RTRIM(LTRIM(c.CLIBAI)) COLLATE Latin1_General_CI_AI, 
               RTRIM(LTRIM(e.CLIENDBAI)) COLLATE Latin1_General_CI_AI) AS DiffBairro,
    DIFFERENCE(RTRIM(LTRIM(c.MUNCOD)) COLLATE Latin1_General_CI_AI, 
               RTRIM(LTRIM(e.CLIENDMUNCOD)) COLLATE Latin1_General_CI_AI) AS DiffMunicipio
FROM TBS002 c
INNER JOIN TBS0021 e
    ON c.CLIEMPCOD = e.CLIEMPCOD
   AND c.CLICOD   = e.CLICOD
WHERE e.CLILOG IS NOT NULL
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIEND)) COLLATE Latin1_General_CI_AI, 
                 RTRIM(LTRIM(e.CLILOG)) COLLATE Latin1_General_CI_AI) >= 3
  AND RTRIM(LTRIM(c.CLINUM)) = RTRIM(LTRIM(e.CLIENDNUM))
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIBAI)) COLLATE Latin1_General_CI_AI, 
                 RTRIM(LTRIM(e.CLIENDBAI)) COLLATE Latin1_General_CI_AI) >= 3
  AND DIFFERENCE(RTRIM(LTRIM(c.MUNCOD)) COLLATE Latin1_General_CI_AI, 
                 RTRIM(LTRIM(e.CLIENDMUNCOD)) COLLATE Latin1_General_CI_AI) >= 3
ORDER BY c.CLIEMPCOD, c.CLICOD, e.CLIENDTIP;

-- se considerar a comparação exata do município, deixa de registros cujo município em outros endereços estejam com valor "0" (zero)

SELECT      
    c.CLIEMPCOD,     
    c.CLICOD,     
    RTRIM(LTRIM(c.CLIEND)) AS EnderecoPrincipal,     
    RTRIM(LTRIM(c.CLINUM)) AS NumeroPrincipal,     
    RTRIM(LTRIM(c.CLIBAI)) AS BairroPrincipal,     
    c.MUNCOD AS MunicipioPrincipal,     
    e.CLIENDTIP,     
    RTRIM(LTRIM(e.CLILOG)) AS EnderecoAdicional,     
    RTRIM(LTRIM(e.CLIENDNUM)) AS NumeroAdicional,     
    RTRIM(LTRIM(e.CLIENDBAI)) AS BairroAdicional,     
    e.CLIENDMUNCOD AS MunicipioAdicional,
    DIFFERENCE(RTRIM(LTRIM(c.CLIEND)) COLLATE Latin1_General_CI_AI, 
               RTRIM(LTRIM(e.CLILOG)) COLLATE Latin1_General_CI_AI) AS DiffEndereco,
    DIFFERENCE(RTRIM(LTRIM(c.CLIBAI)) COLLATE Latin1_General_CI_AI, 
               RTRIM(LTRIM(e.CLIENDBAI)) COLLATE Latin1_General_CI_AI) AS DiffBairro
FROM TBS002 c
INNER JOIN TBS0021 e
    ON c.CLIEMPCOD = e.CLIEMPCOD
   AND c.CLICOD   = e.CLICOD
WHERE e.CLILOG IS NOT NULL
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIEND)) COLLATE Latin1_General_CI_AI, 
                 RTRIM(LTRIM(e.CLILOG)) COLLATE Latin1_General_CI_AI) >= 3
  AND RTRIM(LTRIM(c.CLINUM)) = RTRIM(LTRIM(e.CLIENDNUM))
  AND DIFFERENCE(RTRIM(LTRIM(c.CLIBAI)) COLLATE Latin1_General_CI_AI, 
                 RTRIM(LTRIM(e.CLIENDBAI)) COLLATE Latin1_General_CI_AI) >= 3
  AND c.MUNCOD = e.CLIENDMUNCOD
ORDER BY c.CLIEMPCOD, c.CLICOD, e.CLIENDTIP;

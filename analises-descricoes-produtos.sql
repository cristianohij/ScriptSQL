-- muito lento

SELECT 
    p1.PROCOD AS PROD1_COD,
    p1.PRODES AS PROD1_DESCR,
    p2.PROCOD AS PROD2_COD,
    p2.PRODES AS PROD2_DESCR,
    DIFFERENCE(p1.PRODES, p2.PRODES) AS DIF
FROM TBS010 p1 with (nolock)
JOIN TBS010 p2 with (nolock)
    ON p1.PROCOD <> p2.PROCOD -- evita comparar o mesmo produto
WHERE 
  DIFFERENCE(p1.PRODES, p2.PRODES) >= 3
ORDER BY DIF DESC

-- Cria tabela temporária com produtos ativos

IF OBJECT_ID('tempdb..#ProdutosAtivos') IS NOT NULL
    DROP TABLE #ProdutosAtivos;

SELECT PROCOD, PRODES
INTO #ProdutosAtivos
FROM TBS010
WHERE PROSTATUS = 'A';

-- Query de comparação
SELECT 
    p1.PROCOD AS PROD1_COD,
    p1.PRODES AS PROD1_DESCR,
    p2.PROCOD AS PROD2_COD,
    p2.PRODES AS PROD2_DESCR,
    DIFFERENCE(p1.PRODES, p2.PRODES) AS DIF
FROM #ProdutosAtivos p1
JOIN #ProdutosAtivos p2
    ON p1.PROCOD <> p2.PROCOD  -- evita duplicação
WHERE DIFFERENCE(p1.PRODES, p2.PRODES) >= 3
ORDER BY DIF DESC;

-- Vou criar uma função Levenshtein Distance em T-SQL para você usar no SQL Server. Ela calcula a distância de edição entre duas strings, ou seja, quantas alterações (inserções, deleções ou substituições) são necessárias para transformar uma string na outra.

CREATE FUNCTION dbo.Levenshtein(@s NVARCHAR(MAX), @t NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
    DECLARE @sLen INT = LEN(@s),
            @tLen INT = LEN(@t),
            @i INT,
            @j INT,
            @cost INT;

    DECLARE @d TABLE (i INT, j INT, val INT, PRIMARY KEY(i,j));

    -- Inicializa primeira linha e coluna
    SET @i = 0
    WHILE @i <= @sLen
    BEGIN
        INSERT INTO @d (i,j,val) VALUES (@i, 0, @i)
        SET @i = @i + 1
    END

    SET @j = 0
    WHILE @j <= @tLen
    BEGIN
        INSERT INTO @d (i,j,val) VALUES (0, @j, @j)
        SET @j = @j + 1
    END

    -- Preenche a matriz
    SET @i = 1
    WHILE @i <= @sLen
    BEGIN
        SET @j = 1
        WHILE @j <= @tLen
        BEGIN
            IF SUBSTRING(@s, @i, 1) = SUBSTRING(@t, @j, 1)
                SET @cost = 0
            ELSE
                SET @cost = 1

            DECLARE @val INT

            SELECT @val = MIN(v) FROM
            (
                SELECT val + 1 AS v FROM @d WHERE i = @i - 1 AND j = @j
                UNION ALL
                SELECT val + 1 AS v FROM @d WHERE i = @i AND j = @j - 1
                UNION ALL
                SELECT val + @cost AS v FROM @d WHERE i = @i - 1 AND j = @j - 1
            ) AS x

            INSERT INTO @d (i,j,val) VALUES (@i,@j,@val)

            SET @j = @j + 1
        END
        SET @i = @i + 1
    END

    DECLARE @result INT
    SELECT @result = val FROM @d WHERE i = @sLen AND j = @tLen
    RETURN @result
END
GO

WITH Produtos AS (
    SELECT PROCOD, PRODES
    FROM TBS010
    WHERE PROSTATUS = 'A'
),
Distancias AS (
    SELECT 
        p1.PROCOD AS PROD1_COD,
        p1.PRODES AS PROD1_DESCR,
        p2.PROCOD AS PROD2_COD,
        p2.PRODES AS PROD2_DESCR,
        dbo.Levenshtein(p1.PRODES, p2.PRODES) AS Distancia
    FROM Produtos p1
    JOIN Produtos p2
        ON p1.PROCOD <> p2.PROCOD -- evita comparar o mesmo produto e pares duplicados
)
SELECT *
FROM Distancias
WHERE Distancia <= 5
ORDER BY Distancia ASC;

CREATE FUNCTION dbo.LevenshteinFast
(
    @s NVARCHAR(MAX),
    @t NVARCHAR(MAX)
)
RETURNS INT
AS
BEGIN
    DECLARE @sLen INT = LEN(@s),
            @tLen INT = LEN(@t),
            @i INT,
            @j INT,
            @cost INT,
            @prevRow NVARCHAR(MAX),
            @currRow NVARCHAR(MAX),
            @tempRow NVARCHAR(MAX);

    -- Se algum texto estiver vazio, a distância é o tamanho do outro
    IF @sLen = 0 RETURN @tLen;
    IF @tLen = 0 RETURN @sLen;

    -- Inicializa a primeira linha
    SET @prevRow = '';
    SET @i = 0;
    WHILE @i <= @tLen
    BEGIN
        SET @prevRow = @prevRow + NCHAR(@i); -- cada posição representa um número
        SET @i = @i + 1;
    END

    SET @i = 1;
    WHILE @i <= @sLen
    BEGIN
        SET @currRow = NCHAR(@i); -- primeira coluna da linha atual
        SET @j = 1;
        WHILE @j <= @tLen
        BEGIN
            IF SUBSTRING(@s, @i, 1) = SUBSTRING(@t, @j, 1)
                SET @cost = 0;
            ELSE
                SET @cost = 1;

            -- Calcula o mínimo entre inserção, deleção e substituição
            DECLARE @a INT = UNICODE(SUBSTRING(@currRow, @j, 1)) + 1;
            DECLARE @b INT = UNICODE(SUBSTRING(@prevRow, @j + 1, 1)) + 1;
            DECLARE @c INT = UNICODE(SUBSTRING(@prevRow, @j, 1)) + @cost;

            DECLARE @min INT = @a;
            IF @b < @min SET @min = @b;
            IF @c < @min SET @min = @c;

            SET @currRow = @currRow + NCHAR(@min);

            SET @j = @j + 1;
        END

        -- Troca as linhas
        SET @tempRow = @prevRow;
        SET @prevRow = @currRow;
        SET @currRow = @tempRow;

        SET @i = @i + 1;
    END

    RETURN UNICODE(RIGHT(@prevRow, 1));
END
GO

select PROCOD
       ,PRODES
  into #p1
  from TBS010 with (nolock)
 where PROSTATUS = 'A'

SELECT 
    p1.PROCOD AS PROD1_COD,
    p1.PRODES AS PROD1_DESCR,
    p2.PROCOD AS PROD2_COD,
    p2.PRODES AS PROD2_DESCR,
    dbo.LevenshteinFast(p1.PRODES, p2.PRODES) AS Distancia
FROM #p1 p1 with (nolock)
JOIN #p1 p2 with (nolock)
    ON p1.PROCOD <> p2.PROCOD
WHERE dbo.LevenshteinFast(p1.PRODES, p2.PRODES) <= 5
ORDER BY Distancia ASC;

SELECT 
    p1.PROCOD AS PROD1_COD,
    p1.PRODES AS PROD1_DESCR,
    p2.PROCOD AS PROD2_COD,
    p2.PRODES AS PROD2_DESCR,
    dbo.LevenshteinFast(p1.PRODES, p2.PRODES) AS Distancia
FROM #p1 p1 with (nolock), #p1 p2 with (nolock)
WHERE p1.PROCOD <> p2.PROCOD and dbo.LevenshteinFast(p1.PRODES, p2.PRODES) <= 5
ORDER BY Distancia ASC;

select *
  from #p1

-- produtos com a mesma descrição e marca

SELECT 
    p1.PROCOD AS PROD1_COD,
    p1.PRODES AS PROD1_DESCR,
    p2.PROCOD AS PROD2_COD
    ,p1.PROUM1 + ' ' + p1.PROUM2 + ' ' + p1.PROUM3 + ' ' + p1.PROUM4
    ,p2.PROUM1 + ' ' + p2.PROUM2 + ' ' + p2.PROUM3 + ' ' + p2.PROUM4
FROM TBS010 p1
JOIN TBS010 p2
    ON p1.PRODES = p2.PRODES    -- mesma descrição
   AND p1.PROCOD <> p2.PROCOD   -- evita comparar o mesmo produto ou repetir pares
   and p1.MARCOD = p2.MARCOD
   and p1.PRODES not in ('#USAR#','USAR')
   and p2.PRODES not in ('#USAR#','USAR')
ORDER BY p1.PRODES, p1.PROCOD;

-- contador

SELECT PRODES, COUNT(*) AS Qtde_Produtos
FROM TBS010
GROUP BY PRODES, MARCOD
HAVING COUNT(*) > 1
ORDER BY Qtde_Produtos DESC;

-- lista os códigos de barras por cada registro do produto (única linha)

select p.PROCOD as codigo
       ,p.PRODES as descricao
       ,p.PROSTBA + p.PROSTBB as CST_ICMS
       ,p.PROCLAFIS as NCM
       ,p.PROCEST as CEST
       ,codigos_barras = isnull(STUFF((select ', ' + rtrim(b.CBPCODBAR)
                                         from TBS0103 b with (nolock)
                                        where b.CBPPROCOD = p.PROCOD
                                          for XML path(''), type).value('.', 'nvarchar(max)'), 1, 2, ''),'')
  from TBS010 p with (nolock)
 where p.PROSTATUS = 'A'  
 order by p.PRODES;

-- lista a descrição base sem as variações, por exemplo, de cores

;WITH BASE AS (
    SELECT 
        PROCOD,
        PRODES,
        MARCOD,

        -- Normalização inicial
        UPPER(
            LTRIM(RTRIM(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(replace(
                PRODES,
                ' AZUL',''),
                ' PRETA',''),
                ' VERDE',''),
                ' VERMELHA',''),
                ' PT',''),
                ' VM',''),
                ' VD',''),
                ' LILAS','')
            ))
        ) AS DESCRICAO_BASE
    FROM TBS010
   where MARCOD = 108
),
GRUPO AS (
    SELECT 
        DESCRICAO_BASE,
        MARCOD,
        MIN(PROCOD) AS CODIGO_PAI,
        COUNT(*) AS QTDE
    FROM BASE
    GROUP BY DESCRICAO_BASE, MARCOD
    HAVING COUNT(*) > 1
)
SELECT 
    B.PROCOD,
    B.PRODES,
    B.DESCRICAO_BASE,
    G.CODIGO_PAI,
    G.QTDE
FROM BASE B
JOIN GRUPO G 
    ON B.DESCRICAO_BASE = G.DESCRICAO_BASE
    AND B.MARCOD = G.MARCOD
ORDER BY G.CODIGO_PAI, B.PROCOD;

-- Listar apenas os grupos que possuem repetição

SELECT 
    LEFT(PRODES, 20) AS PREFIXO_20,
    COUNT(*) AS QTDE
FROM TBS010
GROUP BY LEFT(PRODES, 20)
HAVING COUNT(*) > 1
ORDER BY QTDE DESC;

-- Listar os produtos detalhados desses grupos

;WITH GRUPOS AS (
    SELECT LEFT(PRODES, 20) AS PREFIXO_20
    FROM TBS010
    GROUP BY LEFT(PRODES, 20)
    HAVING COUNT(*) > 1
)
SELECT 
    T.PROCOD,
    T.PRODES,
    LEFT(T.PRODES, 20) AS PREFIXO_20
FROM TBS010 T
JOIN GRUPOS G 
    ON LEFT(T.PRODES, 20) = G.PREFIXO_20
ORDER BY PREFIXO_20, PRODES;

-- Versão apenas para visualização (não altera nada)

;WITH BASE AS (
    SELECT 
        PROCOD,
        PRODES,
        LEFT(PRODES, 20) AS PREFIXO_20
    FROM TBS010
),
GRUPOS AS (
    SELECT DISTINCT PREFIXO_20
    FROM BASE
)
SELECT 
    B.PROCOD,
    B.PRODES,
    B.PREFIXO_20,
    DENSE_RANK() OVER (ORDER BY B.PREFIXO_20) AS CODIGO_GRUPO
FROM BASE B
ORDER BY CODIGO_GRUPO, B.PRODES;












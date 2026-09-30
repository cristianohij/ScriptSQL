DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_RS_CmvCorporativoLoja]
		@empcod = 1,
		@dataDe = '01/07/25',
		@dataAte = '31/07/25',
		@pGrupoBMPT = N'S'

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_Get_DWVendas]
		@empcod = 2,
		@pdataDe = '20250701',
		@pdataAte = '20250731'

select precoUnitario
       ,custoUnitario
       ,*
  from ##DWVendas
 where  precoUnitario > custoUnitario * 2.5

select precoUnitario
       ,custoUnitario
       ,*
  from DWVendas with (nolock)
 where [data] between '20250501' and '20250531'
       and precoUnitario > custoUnitario * 2

select *
  from ##DWVendas

select *
  from TBS0671 with (nolock)
 where NFSNUM in (337031,337033)
       and PROCOD = '4270037'

select *
  from SALDOINICIAL with (nolock)
 where CODIGO = '16280026'


-- Usando Mediana e IQR (Intervalo Interquartil) – Estatística Robusta
-- para encontrar possíveis Outlier (valores discrepantes)

/*  O que esse script faz
    Calcula Q1, Mediana (Q2) e Q3 para cada CODIGO.
    Calcula o IQR = Q3 - Q1.
    Marca como outlier qualquer CUSTO que esteja fora de [Q1 - 1.5IQR ; Q3 + 1.5IQR].
    Lista somente os registros que são possíveis outliers. */

;WITH Dados AS (
    SELECT 
        CODIGO,
        CUSTO,
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY CUSTO) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY CUSTO DESC) AS RowDesc,
        COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt
    FROM SALDOINICIAL WITH (NOLOCK)
)
, Quartis AS (
    SELECT
        CODIGO,
        MAX(CASE WHEN RowAsc = (Cnt+1)/4 THEN CUSTO END) AS Q1,
        MAX(CASE WHEN RowAsc = (Cnt+1)/2 THEN CUSTO END) AS Q2, -- Mediana
        MAX(CASE WHEN RowAsc = 3*(Cnt+1)/4 THEN CUSTO END) AS Q3
    FROM Dados
    GROUP BY CODIGO
)
SELECT 
    d.CODIGO,
    d.CUSTO,
    q.Q1,
    q.Q2 AS Mediana,
    q.Q3,
    (q.Q3 - q.Q1) AS IQR,
    CASE 
        WHEN d.CUSTO < q.Q1 - 1.5*(q.Q3 - q.Q1) 
          OR d.CUSTO > q.Q3 + 1.5*(q.Q3 - q.Q1) 
        THEN 'Possível Outlier'
        ELSE 'OK'
    END AS Status
FROM Dados d
JOIN Quartis q ON d.CODIGO = q.CODIGO
WHERE d.CUSTO < q.Q1 - 1.5*(q.Q3 - q.Q1) 
   OR d.CUSTO > q.Q3 + 1.5*(q.Q3 - q.Q1)
ORDER BY d.CODIGO, d.CUSTO;


-- Para todos os códigos (cada um com seus últimos 12 por DATA, listando apenas outliers)
/*
  Observações rápidas
  PERCENTILE_CONT (SQL Server 2012+) calcula quartis com interpolação — é o ponto-chave que faltou antes.
  Se houver poucos registros (ex.: menos de 4), o IQR pode ficar 0. No script tratei para ainda marcar valores fora de [Q1, Q3].
  Usei [DATA] entre colchetes por segurança contra conflitos de nomes.
*/

;WITH Base AS (
    SELECT 
        CODIGO,
        CUSTO,
        [DATA],
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
    FROM SALDOINICIAL WITH (NOLOCK)
),
Ultimos12 AS (
    SELECT CODIGO, CUSTO, [DATA]
    FROM Base
    WHERE rn <= 12
),
Stats AS (
    SELECT
        CODIGO,
        [DATA],
        CUSTO,
        COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
    FROM Ultimos12
),
Final AS (
    SELECT
        CODIGO, [DATA], CUSTO, Cnt, Q1, Mediana, Q3,
        (Q3 - Q1) AS IQR,
        CASE 
            WHEN (Q3 - Q1) = 0 
                THEN CASE WHEN CUSTO < Q1 OR CUSTO > Q3 THEN 1 ELSE 0 END
            ELSE CASE 
                    WHEN CUSTO < Q1 - 1.5*(Q3 - Q1) OR CUSTO > Q3 + 1.5*(Q3 - Q1) THEN 1 
                    ELSE 0 
                 END
        END AS IsOutlier
    FROM Stats
)
SELECT 
    CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, (Q3 - Q1) AS IQR
FROM Final
WHERE IsOutlier = 1
ORDER BY CODIGO, [DATA] DESC;


-- 1) Para um único CODIGO = X (últimos 12 por DATA)

DECLARE @CODIGO VARCHAR(50) = '0040011'; -- ajuste o tipo/valor conforme seu esquema

;WITH Base AS (
    SELECT 
        CODIGO,
        CUSTO,
        [DATA],
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
    FROM SALDOINICIAL WITH (NOLOCK)
    WHERE CODIGO = @CODIGO
),
Ultimos12 AS (
    SELECT CODIGO, CUSTO, [DATA]
    FROM Base
    WHERE rn <= 12
),
Stats AS (
    SELECT
        CODIGO,
        [DATA],
        CUSTO,
        COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
    FROM Ultimos12
),
Final AS (
    SELECT
        CODIGO, [DATA], CUSTO, Cnt, Q1, Mediana, Q3,
        (Q3 - Q1) AS IQR,
        CASE 
            WHEN (Q3 - Q1) = 0 
                THEN CASE WHEN CUSTO < Q1 OR CUSTO > Q3 THEN 1 ELSE 0 END
            ELSE CASE 
                    WHEN CUSTO < Q1 - 1.5*(Q3 - Q1) OR CUSTO > Q3 + 1.5*(Q3 - Q1) THEN 1 
                    ELSE 0 
                 END
        END AS IsOutlier
    FROM Stats
)
SELECT 
    CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, IQR,
    CASE WHEN IsOutlier = 1 THEN 'Possível Outlier' ELSE 'OK' END AS Status
FROM Final
WHERE IsOutlier = 1
ORDER BY [DATA] DESC;


-- Função (1) Para um único CODIGO = X (últimos 12 por DATA))

CREATE FUNCTION dbo.fn_Outliers_Custo
(
    @CODIGO VARCHAR(50) -- ajuste o tipo conforme sua tabela
)
RETURNS TABLE
AS
RETURN
(
    WITH Base AS (
        SELECT 
            CODIGO,
            CUSTO,
            [DATA],
            ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
        FROM SALDOINICIAL WITH (NOLOCK)
        WHERE CODIGO = @CODIGO
    )
    , Ultimos12 AS (
        SELECT CODIGO, CUSTO, [DATA]
        FROM Base
        WHERE rn <= 12
    )
    , Stats AS (
        SELECT
            CODIGO,
            [DATA],
            CUSTO,
            COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
        FROM Ultimos12
    )
    , Final AS (
        SELECT
            CODIGO, [DATA], CUSTO, Cnt, Q1, Mediana, Q3,
            (Q3 - Q1) AS IQR,
            CASE 
                WHEN (Q3 - Q1) = 0 
                    THEN CASE WHEN CUSTO < Q1 OR CUSTO > Q3 THEN 1 ELSE 0 END
                ELSE CASE 
                        WHEN CUSTO < Q1 - 1.5*(Q3 - Q1) OR CUSTO > Q3 + 1.5*(Q3 - Q1) THEN 1 
                        ELSE 0 
                     END
            END AS IsOutlier
        FROM Stats
    )
    SELECT 
        CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, IQR
    FROM Final
    WHERE IsOutlier = 1
);
GO

-- Como usar a função

SELECT * 
FROM dbo.fn_Outliers_Custo('0040011'); -- substitua 'X' pelo código desejado

-- Esse retorno vai listar apenas os registros suspeitos de outlier para o código informado, considerando apenas os últimos 12 registros por DATA.


-- 1. Versão com fator maior (3*IQR)

CREATE FUNCTION dbo.fn_Outliers_Custo_IQR3
(
    @CODIGO VARCHAR(50) -- ajuste o tipo conforme sua tabela
)
RETURNS TABLE
AS
RETURN
(
    WITH Base AS (
        SELECT 
            CODIGO,
            CUSTO,
            [DATA],
            ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
        FROM SALDOINICIAL WITH (NOLOCK)
        WHERE CODIGO = @CODIGO
    )
    , Ultimos12 AS (
        SELECT CODIGO, CUSTO, [DATA]
        FROM Base
        WHERE rn <= 12
    )
    , Stats AS (
        SELECT
            CODIGO,
            [DATA],
            CUSTO,
            COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
        FROM Ultimos12
    )
    , Final AS (
        SELECT
            CODIGO, [DATA], CUSTO, Q1, Mediana, Q3,
            (Q3 - Q1) AS IQR,
            CASE 
                WHEN (Q3 - Q1) = 0 
                    THEN CASE WHEN CUSTO < Q1 OR CUSTO > Q3 THEN 1 ELSE 0 END
                ELSE CASE 
                        WHEN CUSTO < Q1 - 3*(Q3 - Q1) OR CUSTO > Q3 + 3*(Q3 - Q1) THEN 1 
                        ELSE 0 
                     END
            END AS IsOutlier
        FROM Stats
    )
    SELECT 
        CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, IQR
    FROM Final
    WHERE IsOutlier = 1
);
GO


-- 2. Versão Híbrida

CREATE FUNCTION dbo.fn_Outliers_Custo_Hibrida
(
    @CODIGO VARCHAR(50) -- ajuste o tipo conforme sua tabela
)
RETURNS TABLE
AS
RETURN
(
    WITH Base AS (
        SELECT 
            CODIGO,
            CUSTO,
            [DATA],
            ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
        FROM SALDOINICIAL WITH (NOLOCK)
        WHERE CODIGO = @CODIGO
    )
    , Ultimos12 AS (
        SELECT CODIGO, CUSTO, [DATA]
        FROM Base
        WHERE rn <= 12
    )
    , Stats AS (
        SELECT
            CODIGO,
            [DATA],
            CUSTO,
            COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
        FROM Ultimos12
    )
    , Final AS (
        SELECT
            CODIGO, [DATA], CUSTO, Q1, Mediana, Q3,
            (Q3 - Q1) AS IQR,
            CASE 
                -- Caso 1: IQR muito pequeno (menor que 1) → fallback ±20% da Mediana
                WHEN (Q3 - Q1) < 1 
                    THEN CASE 
                            WHEN CUSTO < Mediana * 0.8 OR CUSTO > Mediana * 1.2 THEN 1 
                            ELSE 0 
                         END
                -- Caso 2: IQR normal → regra padrão (1.5 * IQR)
                ELSE CASE 
                        WHEN CUSTO < Q1 - 1.5*(Q3 - Q1) OR CUSTO > Q3 + 1.5*(Q3 - Q1) THEN 1 
                        ELSE 0 
                     END
            END AS IsOutlier
        FROM Stats
    )
    SELECT 
        CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, IQR
    FROM Final
    WHERE IsOutlier = 1
);
GO

-- Como usar

-- Versão com fator maior
SELECT * FROM dbo.fn_Outliers_Custo_IQR3('0040007');

-- Versão híbrida
SELECT * FROM dbo.fn_Outliers_Custo_Hibrida('0040007');


-- consegue ajustar esse script, para a versão híbrida: "Usa IQR normalmente, mas se o IQR for muito pequeno (ex.: < 1), cai para um critério de ±20% da Mediana." ?
-- Segue o script ajustado:

;WITH Base AS (
    SELECT 
        CODIGO,
        CUSTO,
        [DATA],
        ROW_NUMBER() OVER (PARTITION BY CODIGO ORDER BY [DATA] DESC) AS rn
    FROM SALDOINICIAL WITH (NOLOCK)
),
Ultimos12 AS (
    SELECT CODIGO, CUSTO, [DATA]
    FROM Base
    WHERE rn <= 12
),
Stats AS (
    SELECT
        CODIGO,
        [DATA],
        CUSTO,
        COUNT(*) OVER (PARTITION BY CODIGO) AS Cnt,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Mediana,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CUSTO) OVER (PARTITION BY CODIGO) AS Q3
    FROM Ultimos12
),
Final AS (
    SELECT
        CODIGO, [DATA], CUSTO, Cnt, Q1, Mediana, Q3,
        (Q3 - Q1) AS IQR,
        CASE 
            -- fallback quando IQR < 1 → usa ±20% da mediana
            WHEN (Q3 - Q1) < 1 
                THEN CASE 
                        WHEN CUSTO < Mediana * 0.8 OR CUSTO > Mediana * 1.2 THEN 1 
                        ELSE 0 
                     END
            -- regra padrão do IQR
            ELSE CASE 
                    WHEN CUSTO < Q1 - 1.5*(Q3 - Q1) OR CUSTO > Q3 + 1.5*(Q3 - Q1) THEN 1 
                    ELSE 0 
                 END
        END AS IsOutlier
    FROM Stats
)
SELECT 
    CODIGO, [DATA], CUSTO, Q1, Mediana, Q3, (Q3 - Q1) AS IQR
FROM Final
WHERE IsOutlier = 1
ORDER BY CODIGO, [DATA] DESC;

/*
  Esse script agora roda para todos os códigos de uma vez, pega os últimos 12 por DATA, e só marca como outlier quando:
  O IQR for confiável → usa a regra clássica (±1.5 IQR)
  O IQR for muito pequeno (<1) → aplica critério mais flexível de ±20% da mediana
*/

/*
  Vou preparar a função parametrizada que você pode chamar passando:
  @Codigo → o código que deseja analisar
  @Metodo → 'IQR', 'PERCENT' ou 'HYBRIDO'
  @Fator → fator usado para o método escolhido (ex.: 3 para 3*IQR, ou 0.2 para 20% da mediana no método percentual)
  @QtdRegistros → quantidade de registros mais recentes a considerar (ex.: 12)
*/

CREATE FUNCTION dbo.fn_GetOutliers
(
    @Codigo INT,
    @Metodo VARCHAR(20),       -- 'IQR', 'PERCENT', 'HYBRIDO'
    @Fator FLOAT,              -- Ex: 3 para IQR; 0.2 para Percentual
    @QtdRegistros INT          -- Ex: 12
)
RETURNS @Resultado TABLE
(
    Codigo INT,
    DataRegistro DATE,
    Valor DECIMAL(18,2),
    IsOutlier BIT
)
AS
BEGIN
    ;WITH Base AS
    (
        SELECT TOP (@QtdRegistros)
            CODIGO,
            DATA,
            VALOR
        FROM SUA_TABELA
        WHERE CODIGO = @Codigo
        ORDER BY DATA DESC
    ),
    Stats AS
    (
        SELECT 
            MIN(VALOR) AS MinVal,
            MAX(VALOR) AS MaxVal,
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY VALOR) 
                OVER() AS Q1,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY VALOR) 
                OVER() AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY VALOR) 
                OVER() AS Q3
        FROM Base
    )
    INSERT INTO @Resultado
    SELECT 
        b.CODIGO,
        b.DATA,
        b.VALOR,
        CASE 
            WHEN @Metodo = 'IQR' THEN
                CASE 
                    WHEN b.VALOR < (s.Q1 - @Fator * (s.Q3 - s.Q1)) 
                      OR b.VALOR > (s.Q3 + @Fator * (s.Q3 - s.Q1)) 
                    THEN 1 ELSE 0 END

            WHEN @Metodo = 'PERCENT' THEN
                CASE 
                    WHEN b.VALOR < (s.Mediana * (1 - @Fator)) 
                      OR b.VALOR > (s.Mediana * (1 + @Fator)) 
                    THEN 1 ELSE 0 END

            WHEN @Metodo = 'HYBRIDO' THEN
                CASE 
                    WHEN (s.Q3 - s.Q1) > 0.0001 -- se há variação real
                        THEN CASE 
                                WHEN b.VALOR < (s.Q1 - @Fator * (s.Q3 - s.Q1)) 
                                  OR b.VALOR > (s.Q3 + @Fator * (s.Q3 - s.Q1)) 
                                THEN 1 ELSE 0 END
                        ELSE CASE 
                                WHEN b.VALOR < (s.Mediana * (1 - @Fator)) 
                                  OR b.VALOR > (s.Mediana * (1 + @Fator)) 
                                THEN 1 ELSE 0 END
                     END
            ELSE 0
        END AS IsOutlier
    FROM Base b
    CROSS JOIN Stats s;

    RETURN;
END;
GO

-- Exemplos de uso

-- Últimos 12 registros, IQR com fator 3

SELECT * 
FROM dbo.fn_GetOutliers(123, 'IQR', 3, 12)
WHERE IsOutlier = 1;

-- Últimos 12 registros, Percentual (±20% da mediana)

SELECT * 
FROM dbo.fn_GetOutliers(123, 'PERCENT', 0.2, 12)
WHERE IsOutlier = 1;

-- Últimos 12 registros, Híbrido (IQR com fallback para mediana ±20%)

SELECT * 
FROM dbo.fn_GetOutliers(123, 'HYBRIDO', 0.2, 12)
WHERE IsOutlier = 1;


-- Função Escalar – Últimos 12 registros de um código

CREATE FUNCTION dbo.fn_GetOutliersUltimos12
(
    @Codigo INT,
    @Metodo VARCHAR(10) = 'IQR',  -- 'IQR' ou 'HYBRID'
    @Fator FLOAT = 3.0,           -- fator multiplicador do IQR
    @PctFallback FLOAT = 0.2      -- % da mediana para fallback (20% = 0.2)
)
RETURNS @Resultado TABLE
(
    Codigo INT,
    Data DATE,
    Valor DECIMAL(18,2),
    IsOutlier BIT
)
AS
BEGIN
    ;WITH Ultimos AS (
        SELECT TOP 12 *
        FROM Tabela
        WHERE Codigo = @Codigo
        ORDER BY Data DESC
    ),
    Stats AS (
        SELECT 
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Valor) OVER() AS Q1,
            PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY Valor) OVER() AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Valor) OVER() AS Q3
        FROM Ultimos
    ),
    Parametros AS (
        SELECT DISTINCT 
            Q1, Q3, Mediana,
            (Q3-Q1) AS IQR,
            CASE 
                WHEN @Metodo = 'IQR' 
                    THEN Q1 - @Fator*(Q3-Q1)
                WHEN @Metodo = 'HYBRID' AND (Q3-Q1) > 0.00001
                    THEN Q1 - @Fator*(Q3-Q1)
                ELSE Mediana - (Mediana * @PctFallback)
            END AS LimiteInf,
            CASE 
                WHEN @Metodo = 'IQR' 
                    THEN Q3 + @Fator*(Q3-Q1)
                WHEN @Metodo = 'HYBRID' AND (Q3-Q1) > 0.00001
                    THEN Q3 + @Fator*(Q3-Q1)
                ELSE Mediana + (Mediana * @PctFallback)
            END AS LimiteSup
        FROM Stats
    )
    INSERT INTO @Resultado
    SELECT 
        u.Codigo,
        u.Data,
        u.Valor,
        CASE WHEN u.Valor < p.LimiteInf OR u.Valor > p.LimiteSup THEN 1 ELSE 0 END AS IsOutlier
    FROM Ultimos u
    CROSS JOIN Parametros p
    ORDER BY u.Data DESC;

    RETURN;
END
GO


-- Exemplo de uso:

SELECT * 
FROM dbo.fn_GetOutliersUltimos12(123, 'HYBRID', 3, 0.15);


-- Stored Procedure – Últimos 12 registros de um código

CREATE PROCEDURE dbo.sp_GetOutliersUltimos12
(
    @Codigo INT,
    @Metodo VARCHAR(10) = 'IQR',  -- 'IQR' ou 'HYBRID'
    @Fator FLOAT = 3.0,           -- fator multiplicador do IQR
    @PctFallback FLOAT = 0.2      -- % da mediana para fallback
)
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH Ultimos AS (
        SELECT TOP 12 *
        FROM Tabela
        WHERE Codigo = @Codigo
        ORDER BY Data DESC
    ),
    Stats AS (
        SELECT 
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Valor) OVER() AS Q1,
            PERCENTILE_CONT(0.5)  WITHIN GROUP (ORDER BY Valor) OVER() AS Mediana,
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Valor) OVER() AS Q3
        FROM Ultimos
    ),
    Parametros AS (
        SELECT DISTINCT 
            Q1, Q3, Mediana,
            (Q3-Q1) AS IQR,
            CASE 
                WHEN @Metodo = 'IQR' 
                    THEN Q1 - @Fator*(Q3-Q1)
                WHEN @Metodo = 'HYBRID' AND (Q3-Q1) > 0.00001
                    THEN Q1 - @Fator*(Q3-Q1)
                ELSE Mediana - (Mediana * @PctFallback)
            END AS LimiteInf,
            CASE 
                WHEN @Metodo = 'IQR' 
                    THEN Q3 + @Fator*(Q3-Q1)
                WHEN @Metodo = 'HYBRID' AND (Q3-Q1) > 0.00001
                    THEN Q3 + @Fator*(Q3-Q1)
                ELSE Mediana + (Mediana * @PctFallback)
            END AS LimiteSup
        FROM Stats
    )
    SELECT 
        u.Codigo,
        u.Data,
        u.Valor,
        CASE WHEN u.Valor < p.LimiteInf OR u.Valor > p.LimiteSup THEN 1 ELSE 0 END AS IsOutlier
    FROM Ultimos u
    CROSS JOIN Parametros p
    WHERE u.Valor < p.LimiteInf OR u.Valor > p.LimiteSup -- já retorna só os outliers
    ORDER BY u.Data DESC;
END
GO

-- Exemplo de chamada:

EXEC dbo.sp_GetOutliersUltimos12 
     @Codigo = 123, 
     @Metodo = 'HYBRID', 
     @Fator = 3, 
     @PctFallback = 0.15;

select d.NFSQTD * d.NFSQTDEMB
       ,dbo.NFSTOTITEST(0, d.NFSNUM, 0 ,d.SNESER, d.NFSITE) / d.NFSQTD  / d.NFSQTDEMB
       ,d.NFSPRE / d.NFSQTDEMB
       ,*
  from TBS0671 d with (nolock)
 inner join TBS067 c with (nolock)
         on d.NFSNUM = c.NFSNUM
 where c.NFSDATEMI between '20250701' and '20250731'
       and c.NFSCAN = 'N'
       and d.PROCOD = '16280026'

select *
  from master..spt_values


	-- Cria tabela de datas para contabilizar vendas por ano e mes (no CMV)

declare @data_De date, @data_Ate date

select @data_De = '20250101', @data_Ate = '20250731'

	IF OBJECT_ID('tempdb.dbo.#DATAS') IS NOT NULL	
		DROP TABLE #DATAS;

	SELECT
		DISTINCT CONVERT(CHAR(7), DATEADD(DAY, number + 1, @data_De), 102) AS MES

	INTO #DATAS FROM master..spt_values

	WHERE
		type = 'P' AND 
		DATEADD(DAY, number + 1, @data_De) <= @data_Ate

	UNION 
	SELECT
		CONVERT(CHAR(7), @data_De, 102) AS MES

select *
  from #DATAS

-- reescrito no chatGPT

-- Cria tabela de datas para contabilizar vendas por ano e mes

declare @data_De date, @data_Ate date

select @data_De = '20250101', @data_Ate = '20250731'

IF OBJECT_ID('tempdb.dbo.#DATAS') IS NOT NULL
    DROP TABLE #DATAS;

;WITH CTE_MESES AS (
    -- Começa no mês inicial
    SELECT CAST(DATEFROMPARTS(YEAR(@data_De), MONTH(@data_De), 1) AS DATE) AS MES_INICIO
    UNION ALL
    -- Vai somando 1 mês até a data final
    SELECT DATEADD(MONTH, 1, MES_INICIO)
    FROM CTE_MESES
    WHERE DATEADD(MONTH, 1, MES_INICIO) <= DATEFROMPARTS(YEAR(@data_Ate), MONTH(@data_Ate), 1)
)
SELECT CONVERT(CHAR(7), MES_INICIO, 102) AS MES
INTO #DATAS
FROM CTE_MESES
OPTION (MAXRECURSION 0); -- Permite gerar mais de 100 meses se precisar

select *
  from #DATAS








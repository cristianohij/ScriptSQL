-- Relatório de Desempenho de Itinerários:

SELECT
    ITISTATUS AS StatusItinerario,
    COUNT(*) AS QuantidadeItinerarios,
    AVG(DATEDIFF(HOUR, ITIDATEMI + ITIHOREMI, ITIDATSAI + ITIHORSAI)) AS MediaTempoEmissaoSaida
FROM
    TBS109
GROUP BY
    ITISTATUS;

-- Relatório de Kilometragem:

SELECT
    ITICARPLA AS PlacaVeiculo,
    SUM(ITIKMFIN - ITIKMATU) AS KilometragemTotal,
    AVG(ITIKMFIN - ITIKMATU) AS MediaKilometragem
FROM
    TBS109
GROUP BY
    ITICARPLA;

-- Análise de Status de Entregas:

SELECT
    ITISTATUS AS StatusItinerario,
    COUNT(*) AS QuantidadeItinerarios,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM TBS109)) AS PercentualTotal
FROM
    TBS109
GROUP BY
    ITISTATUS;

WITH TotalPorMesAno AS (
    SELECT
        YEAR(ITIDATEMI) AS Ano,
        MONTH(ITIDATEMI) AS Mes,
        COUNT(*) AS TotalItinerarios
    FROM
        TBS109
    WHERE
        ITIDATEMI >= '20240101'  -- Filtra dados a partir de 01/01/2024
    GROUP BY
        YEAR(ITIDATEMI), MONTH(ITIDATEMI)
)
SELECT
    YEAR(T1.ITIDATEMI) AS Ano,
    MONTH(T1.ITIDATEMI) AS Mes,
    CASE
        WHEN T1.ITISTATUS = 'F' THEN 'Finalizado'
        WHEN T1.ITISTATUS = 'A' THEN 'Em aberto'
        ELSE 'Outro Status'  -- Caso queira tratar outros valores de status
    END AS StatusItinerario,
    COUNT(*) AS QuantidadeItinerarios,
    FORMAT(COUNT(*) * 100.0 / T2.TotalItinerarios, 'N2', 'en-US') + '%' AS PercentualTotal
FROM
    TBS109 T1
JOIN
    TotalPorMesAno T2 ON YEAR(T1.ITIDATEMI) = T2.Ano AND MONTH(T1.ITIDATEMI) = T2.Mes
WHERE
    T1.ITIDATEMI >= '20240101'  -- Filtra dados a partir de 01/01/2024
GROUP BY
    YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI), T1.ITISTATUS, T2.TotalItinerarios
ORDER BY
    Ano DESC, Mes DESC, StatusItinerario;

-- Desempenho por Região:

SELECT
    T2.ITIREGENT AS RegiaoEntrega,
    COUNT(*) AS QuantidadeEntregas,
    AVG(CAST(DATEDIFF(HOUR, T1.ITIDATSAI + T1.ITIHORSAI, T1.ITIHORRET) AS DECIMAL(18, 2))) AS MediaTempoEntrega
FROM
    TBS109 T1
JOIN
    TBS1091 T2 ON T1.ITINUM = T2.ITINUM
GROUP BY
    T2.ITIREGENT;

-- Análise Financeira:

SELECT
    ITINUM,
    SUM(ITITOTDOC) AS ValorTotalNotas,
    AVG(ITITOTDOC) AS MediaValorNota
FROM
    TBS1091
GROUP BY
    ITINUM;

-- Relatório de Clientes:

SELECT
    ITINOMDES AS NomeCliente,
    COUNT(*) AS QuantidadeEntregas
FROM
    TBS1091
GROUP BY
    ITINOMDES;

-- Análise de Peso:

SELECT
    ITINUM,
    AVG(ITIPESBRU) AS MediaPesoBruto,
    AVG(ITIPESLIQ) AS MediaPesoLiquido
FROM
    TBS1091
GROUP BY
    ITINUM;

-- Itens por Itinerário:

SELECT
    ITINUM,
    SUM(ITIQTDVOL) AS QuantidadeItens,
    AVG(ITIQTDVOL) AS MediaItens
FROM
    TBS1091
GROUP BY
    ITINUM;

-- Histórico de Itinerários:

SELECT
    ITINUM,
    ITIDATEMI + ' ' + ITIHOREMI AS DataHoraEmissao,
    ITIDATSAI + ' ' + ITIHORSAI AS DataHoraSaida,
    ITIHORRET AS HorarioRetorno
FROM
    TBS109;

-- Avaliação de Clientes e Regiões:

SELECT
    ITIREGENT AS RegiaoEntrega,
    ITINOMDES AS NomeCliente,
    AVG(AvaliacaoCliente) AS MediaAvaliacao
FROM
    SuaTabelaDeFeedback  -- Substitua pela tabela de feedback
GROUP BY
    ITIREGENT, ITINOMDES;




-- novos relatórios

-- valor total por veículo

WITH TotalPorMesAno AS (
    SELECT
        YEAR(T1.ITIDATEMI) AS Ano,
        MONTH(T1.ITIDATEMI) AS Mes,
        SUM(T2.ITITOTDOC) AS ValorTotalMesAno
    FROM
        TBS109 T1
    JOIN
        TBS1091 T2 ON T1.ITINUM = T2.ITINUM
    WHERE
        T1.ITIDATEMI >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)  -- Filtra dados desde o início deste ano ********************************
    GROUP BY
        YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI)
)
SELECT
    YEAR(T1.ITIDATEMI) AS Ano,
    MONTH(T1.ITIDATEMI) AS Mes,
    T1.ITICARPLA AS PlacaVeiculo,
    FORMAT(SUM(T2.ITITOTDOC), 'N2', 'en-US') AS ValorTotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC) * 100.0 / T3.ValorTotalMesAno, 'N2', 'en-US') + '%' AS PercentualTotal
FROM
    TBS109 T1
JOIN
    TBS1091 T2 ON T1.ITINUM = T2.ITINUM
JOIN
    TotalPorMesAno T3 ON YEAR(T1.ITIDATEMI) = T3.Ano AND MONTH(T1.ITIDATEMI) = T3.Mes
WHERE
    T1.ITIDATEMI >= DATEFROMPARTS(YEAR(GETDATE()), 1, 1)  -- Filtra dados desde o início deste ano
GROUP BY
    YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI), T1.ITICARPLA, T3.ValorTotalMesAno
ORDER BY
    Ano DESC, Mes DESC, PlacaVeiculo;


WITH TotalPorMesAno AS (
    SELECT
        YEAR(T1.ITIDATEMI) AS Ano,
        MONTH(T1.ITIDATEMI) AS Mes,
        SUM(T2.ITITOTDOC) AS ValorTotalMesAno
    FROM
        TBS109 T1
    JOIN
        TBS1091 T2 ON T1.ITINUM = T2.ITINUM
    WHERE
        T1.ITIDATEMI >= '20240601'  -- Filtra dados a partir de 01/06/2024
    GROUP BY
        YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI)
)
SELECT
    YEAR(T1.ITIDATEMI) AS Ano,
    MONTH(T1.ITIDATEMI) AS Mes,
    T1.ITICARPLA AS PlacaVeiculo,
    FORMAT(SUM(T2.ITITOTDOC), 'N2', 'en-US') AS ValorTotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC) * 100.0 / T3.ValorTotalMesAno, 'N2', 'en-US') + '%' AS PercentualTotal
FROM
    TBS109 T1
JOIN
    TBS1091 T2 ON T1.ITINUM = T2.ITINUM
JOIN
    TotalPorMesAno T3 ON YEAR(T1.ITIDATEMI) = T3.Ano AND MONTH(T1.ITIDATEMI) = T3.Mes
WHERE
    T1.ITIDATEMI >= '20240601'  -- Filtra dados a partir de junho de 2024
GROUP BY
    YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI), T1.ITICARPLA, T3.ValorTotalMesAno
ORDER BY
    Ano DESC, Mes DESC, PlacaVeiculo;

select top(100) *
  from TBS109 with (nolock)
 where ITIDATEMI >= '20240601'

-- total por região

WITH TotalPorMesAno AS (
    SELECT
        YEAR(T1.ITIDATEMI) AS Ano,
        MONTH(T1.ITIDATEMI) AS Mes,
        COUNT(T1.ITINUM) AS TotalEntregasMes,
        SUM(T2.ITITOTDOC) AS ValorTotalMes
    FROM
        TBS109 T1
    JOIN
        TBS1091 T2 ON T1.ITINUM = T2.ITINUM
    WHERE
        T1.ITIDATEMI >= '20240101'  -- Filtra dados desde o início do ano
    GROUP BY
        YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI)
)
SELECT
    YEAR(T1.ITIDATEMI) AS Ano,
    MONTH(T1.ITIDATEMI) AS Mes,
    T2.ITIREGENT AS Regiao,
    COUNT(T1.ITINUM) AS TotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC), 'N2', 'en-US') AS ValorTotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC) * 100.0 / T3.ValorTotalMes, 'N2', 'en-US') + '%' AS PercentualTotal
FROM
    TBS109 T1
JOIN
    TBS1091 T2 ON T1.ITINUM = T2.ITINUM
JOIN
    TotalPorMesAno T3 ON YEAR(T1.ITIDATEMI) = T3.Ano AND MONTH(T1.ITIDATEMI) = T3.Mes
WHERE
    T1.ITIDATEMI >= '20240101'  -- Filtra dados desde o início do ano
GROUP BY
    YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI), T2.ITIREGENT, T3.ValorTotalMes
ORDER BY
    Ano DESC, Mes DESC, T2.ITIREGENT;

WITH TotalPorMesAno AS (
    SELECT
        YEAR(T1.ITIDATEMI) AS Ano,
        MONTH(T1.ITIDATEMI) AS Mes,
        COUNT(T1.ITINUM) AS TotalEntregasMes,
        SUM(T2.ITITOTDOC) AS ValorTotalMes
    FROM
        TBS109 T1
    JOIN
        TBS1091 T2 ON T1.ITINUM = T2.ITINUM
    WHERE
        T1.ITIDATEMI >= '20240101'  -- Filtra dados desde o início do ano
    GROUP BY
        YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI)
)
SELECT
    YEAR(T1.ITIDATEMI) AS Ano,
    MONTH(T1.ITIDATEMI) AS Mes,
    T2.ITIMUNENT AS Municipio,
    COUNT(T1.ITINUM) AS TotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC), 'N2', 'en-US') AS ValorTotalEntregas,
    FORMAT(SUM(T2.ITITOTDOC) * 100.0 / T3.ValorTotalMes, 'N2', 'en-US') + '%' AS PercentualTotal
FROM
    TBS109 T1
JOIN
    TBS1091 T2 ON T1.ITINUM = T2.ITINUM
JOIN
    TotalPorMesAno T3 ON YEAR(T1.ITIDATEMI) = T3.Ano AND MONTH(T1.ITIDATEMI) = T3.Mes
WHERE
    T1.ITIDATEMI >= '20240101'  -- Filtra dados desde o início do ano
GROUP BY
    YEAR(T1.ITIDATEMI), MONTH(T1.ITIDATEMI), T2.ITIMUNENT, T3.ValorTotalMes
ORDER BY
    Ano DESC, Mes DESC, T2.ITIMUNENT;

begin tran
update TBS1091
   set ITIMUNENT='JACAREI'
 where ITIMUNENT='JACAREI,'

rollback tran
commit tran

select ITIMUNENT
  from TBS1091 with (nolock)
 group by ITIMUNENT
 order by ITIMUNENT

begin tran
update TBS1091
   set ITIMUNENT=Ltrim(ITIMUNENT)

rollback tran
commit tran

begin tran
update TBS1091
   set ITIMUNENT='CACAPAVA'
 where ITIMUNENT='CAÇAPAVA'

rollback tran
commit tran


-- valores totais por cliente

SELECT
    YEAR(T2.ITIDATEMI) AS Ano,
    MONTH(T2.ITIDATEMI) AS Mes,
    T1.ITINOMDES AS NomeCliente,
    COUNT(*) AS QuantidadeEntregas,
    FORMAT(SUM(T1.ITITOTDOC), 'N2', 'en-US') AS ValorTotalEntregas
FROM
    TBS1091 T1
JOIN
    TBS109 T2 ON T1.ITINUM = T2.ITINUM
WHERE
    T2.ITIDATEMI >= '20240101'  -- Filtra dados a partir de 01/01/2024
GROUP BY
    YEAR(T2.ITIDATEMI), MONTH(T2.ITIDATEMI), T1.ITINOMDES
ORDER BY
    Ano DESC, Mes DESC, SUM(T1.ITITOTDOC) DESC;





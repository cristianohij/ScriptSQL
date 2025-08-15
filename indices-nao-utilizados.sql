USE TEMPDB

;WITH IndicesNaoUtilizados As (
SELECT
    DB_NAME(database_id) As Banco, OBJECT_NAME(I.object_id) As Tabela, I.Name As Indice,
    U.User_Seeks As Pesquisas, U.User_Scans As Varreduras, U.User_Lookups As LookUps,
    U.Last_User_Seek As UltimaPesquisa, U.Last_User_Scan As UltimaVarredura,
    U.Last_User_LookUp As UltimoLookUp, U.Last_User_Update As UltimaAtualizacao
FROM
    sys.indexes As I
    LEFT OUTER JOIN sys.dm_db_index_usage_stats As U
    ON I.object_id = U.object_id AND I.index_id = U.index_id
WHERE database_id = DB_ID('SIBD'))

SELECT
    Banco, Tabela, Indice, Pesquisas, Varreduras, LookUps,
    UltimaPesquisa, UltimaVarredura, UltimoLookUp
FROM IndicesNaoUtilizados
WHERE
    (Pesquisas + Varreduras + LookUps) = 0


SELECT
    DB_NAME(database_id) As Banco, OBJECT_NAME(I.object_id) As Tabela, I.Name As Indice,
    U.User_Seeks As Pesquisas, U.User_Scans As Varreduras, U.User_Lookups As LookUps,
    U.Last_User_Seek As UltimaPesquisa, U.Last_User_Scan As UltimaVarredura,
    U.Last_User_LookUp As UltimoLookUp, U.Last_User_Update As UltimaAtualizacao
FROM
    sys.indexes As I
    LEFT OUTER JOIN sys.dm_db_index_usage_stats As U
    ON I.object_id = U.object_id AND I.index_id = U.index_id
WHERE I.object_id = OBJECT_ID('TBS0431')



SELECT DB_NAME(), OBJECT_NAME(i.object_id) AS 'Table', ISNULL(i.name, 'heap') AS 'Index', x.used_page_count AS 'SizeKB'
FROM sys.objects o
INNER JOIN sys.indexes i
ON i.[object_id] = o.[object_id]
LEFT JOIN sys.dm_db_index_usage_stats s
ON i.index_id = s.index_id and s.object_id = i.object_id
LEFT JOIN sys.dm_db_partition_stats x
ON i.[object_id] = x.[object_id] AND i.index_id = x.index_id
WHERE OBJECT_NAME(o.object_id) IS NOT NULL AND OBJECT_NAME(s.object_id) IS NULL
AND o.[type] = 'U' AND ISNULL(i.name, 'heap') <> 'heap'

UNION ALL

/*
Parte(B) identifica índices que não são mais utilizados desde a inicialização
da instância do SQL Server
*/
SELECT DB_NAME(), OBJECT_NAME(i.object_id) AS 'Table', ISNULL(i.name, 'heap') AS 'Index', x.used_page_count AS 'SizeKB'
FROM sys.objects o
INNER JOIN sys.indexes i
ON i.[object_id] = o.[object_id]
LEFT JOIN sys.dm_db_index_usage_stats s
ON i.index_id = s.index_id and s.object_id = i.object_id
LEFT JOIN sys.dm_db_partition_stats x
ON i.[object_id] = x.[object_id] AND i.index_id = x.index_id
WHERE user_seeks = 0 AND user_scans = 0 AND user_lookups = 0
AND o.[type] = 'U' AND ISNULL(i.name, 'heap') <> 'heap'
ORDER BY 2 ASC

SELECT
  s.[name]
, t.[name]
, p.[rows]
FROM sys.schemas s
INNER JOIN sys.tables t
  ON t.[schema_id] = s.[schema_id]
INNER JOIN sys.indexes i
  ON i.[object_id] = t.[object_id]
  AND i.[type] IN (0,1)
INNER JOIN sys.partitions p
  ON p.[object_id] = t.[object_id]
  AND p.[index_id] = i.[index_id]
ORDER BY
  s.[name]
, t.[name]

-- desativando um ìndice

ALTER INDEX nome_índice ON tabela DISABLE 
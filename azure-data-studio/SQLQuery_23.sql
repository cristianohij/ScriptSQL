-- intervalo de uso do reporting services

SELECT 
    MIN(TimeStart) AS Execucao_Mais_Antiga,
    MAX(TimeStart) AS Execucao_Mais_Nova
FROM 
    ReportServer..ExecutionLog3
WHERE
    RequestType = 'Interactive' 
    AND ItemAction LIKE 'Render%'

-- relatórios mais acessados

SELECT 
    A.[Path], 
    COUNT(DISTINCT B.TimeStart) AS [Quantidade de Views],
    MIN(B.TimeStart) AS Execucao_Mais_Antiga,
    MAX(B.TimeStart) AS Execucao_Mais_Nova
FROM 
    ReportServer..[Catalog] A
    LEFT JOIN ReportServer..ExecutionLog3 B ON A.[Path] = B.ItemPath AND B.RequestType = 'Interactive' AND B.ItemAction LIKE 'Render%'
WHERE 
    A.[Type] IN (2, 12)
GROUP BY 
    A.[Path]
ORDER BY 
    2 DESC
	
SELECT * 
FROM ReportServer.dbo.ExecutionLog

-- quantidade de execuções de cada relatório

SELECT
  c.Name,
  c.[Path],
  COUNT(*) AS TimesRun
FROM [dbo].[ExecutionLog] AS l
INNER JOIN [dbo].[Catalog] AS c
  ON l.ReportID = C.ItemID
WHERE c.Type = 2
GROUP BY l.ReportId,
         c.Name,
         c.[Path]
ORDER BY TimesRun DESC

-- tempo médio e data da última execução de cada relatório

SELECT
  ReportID,
  C.Name,
  CAST(AVG(
  (TimeDataRetrieval + TimeProcessing + TimeRendering) / 1000.0)
  AS decimal(10, 2)) AS TotalRenderingTime,
  CAST(MAX(l.TimeStart) AS date) AS [LastRun]
FROM dbo.ExecutionLog AS l
INNER JOIN [dbo].[Catalog] AS c
  ON l.ReportID = C.ItemID
WHERE c.Type = 2
GROUP BY l.ReportId,
         C.Name
ORDER BY TotalRenderingTime DESC

-- tabelas mais acessadas

SELECT
       db_name(ius.database_id) [Database],
       t.NAME [Tabela],
      SUM(ius.user_seeks + ius.user_scans + ius.user_lookups) [#Acessos]
    FROM
       sys.dm_db_index_usage_stats ius INNER JOIN sys.tables t
         ON ius.OBJECT_ID = t.object_id
    WHERE
       database_id = DB_ID('SIBD') 
    GROUP BY
       database_id,
       t.name
    ORDER BY
       SUM(ius.user_seeks + ius.user_scans + ius.user_lookups) DESC

-- índices mais utilizados

SELECT
       db_name(ius.database_id) [Database],
       t.NAME [Tabela],
       i.NAME [Indice],
       i.type_desc [TipoIndice],
       ius.user_seeks + ius.user_scans + ius.user_lookups [#Acessos]
    FROM
       sys.dm_db_index_usage_stats ius INNER JOIN sys.indexes i
         ON ius.OBJECT_ID = i.OBJECT_ID
         AND ius.index_id = i.index_id INNER JOIN sys.tables t
           ON i.OBJECT_ID = t.object_id
   WHERE
       database_id = DB_ID('SIBD')
   ORDER BY
       ius.user_seeks + ius.user_scans + ius.user_lookups DESC

-- quando foi o último acesso a tabela

USE NOME_DO_SEU_BANCO_DE_DADOS;
   WITH ultimos AS
   (
   SELECT SCHEMA_NAME(B.schema_id) +'.'+object_name(b.object_id) [Tabela],
   (   SELECT MAX(last_user_dt)
   FROM (VALUES (last_user_seek),(last_user_scan),(last_user_lookup)) AS all_val(last_user_dt)) [Acessos]
   FROM sys.dm_db_index_usage_stats a RIGHT OUTER JOIN sys.tables b
     ON a.object_id = b.object_id
   )
   SELECT
      [Acessos],
      MAX([Accessed]) [UltimoAcesso]
   FROM
      ultimos 
   GROUP BY
      [Tabela]
   ORDER BY
      [UltimoAcesso] DESC

-- quando SQL foi iniciado

SELECT sqlserver_start_time FROM sys.dm_os_sys_info

-- informações sobre a memória alocada atualmente

SELECT 
  physical_memory_in_use_kb/1024 AS sql_physical_memory_in_use_MB, 
   large_page_allocations_kb/1024 AS sql_large_page_allocations_MB, 
   locked_page_allocations_kb/1024 AS sql_locked_page_allocations_MB,
   virtual_address_space_reserved_kb/1024 AS sql_VAS_reserved_MB, 
   virtual_address_space_committed_kb/1024 AS sql_VAS_committed_MB, 
   virtual_address_space_available_kb/1024 AS sql_VAS_available_MB,
   page_fault_count AS sql_page_fault_count,
   memory_utilization_percentage AS sql_memory_utilization_percentage, 
   process_physical_memory_low AS sql_process_physical_memory_low, 
   process_virtual_memory_low AS sql_process_virtual_memory_low
FROM sys.dm_os_process_memory


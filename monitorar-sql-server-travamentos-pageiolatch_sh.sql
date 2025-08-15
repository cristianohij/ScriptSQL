-- Usar DMVs para análise em tempo real

SELECT
    r.session_id,
    r.wait_type,
    r.wait_time,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time,
    r.reads,
    r.writes,
    t.text AS query_text,
    s.program_name,
    s.host_name,
    s.login_name
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.wait_type = 'PAGEIOLATCH_SH';

SELECT name, event_session_id, startup_state
FROM sys.server_event_sessions;

-- Usar Extended Events (leve e poderoso)

CREATE EVENT SESSION MonitorIOReads
ON SERVER
ADD EVENT sqlserver.sql_statement_completed
(
    ACTION (
        sqlserver.sql_text,
        sqlserver.session_id,
        sqlserver.client_hostname,
        sqlserver.username
    )
    WHERE (logical_reads > 10000) -- ajuste conforme sua realidade
)
ADD TARGET package0.ring_buffer
WITH (STARTUP_STATE = OFF);
GO

-- Iniciar a sessão
ALTER EVENT SESSION MonitorIOReads ON SERVER STATE = START;

-- Para visualizar os dados coletados:

SELECT 
    DATEADD(ms, (event_data.value('(event/@timestamp)[1]', 'bigint') / 1000), '1970-01-01') AS [EventTime],
    event_data.value('(event/data[@name="wait_type"]/text)[1]', 'varchar(50)') AS [WaitType],
    event_data.value('(event/data[@name="duration"]/value)[1]', 'bigint') AS [Duration],
    event_data.value('(event/data[@name="resource_address"]/value)[1]', 'varchar(100)') AS [ResourceAddress]
FROM 
(
    SELECT CAST(target_data AS XML) AS TargetData
    FROM sys.dm_xe_sessions AS s
    JOIN sys.dm_xe_session_targets AS t 
        ON s.address = t.event_session_address
    WHERE s.name = 'Monitor_PageIOLatch'
) AS Data
CROSS APPLY TargetData.nodes('//event') AS X(event_data)
ORDER BY [EventTime] DESC;

-- Como verificar se as estatísticas estão desatualizadas?

SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    i.name AS IndexName,
    STATS_DATE(i.object_id, i.index_id) AS StatsLastUpdated
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE i.type > 0  -- Ignora heaps (sem índice)
ORDER BY StatsLastUpdated;

-- Isso atualiza todas as estatísticas com base em mudanças recentes de dados. O ideal é fazer isso em horários de baixo uso do servidor, pois pode causar carga.

-- Como atualizar estatísticas manualmente?

UPDATE STATISTICS NomeDaTabela;

-- Ou de todo o banco de dados:

EXEC sp_updatestats;

-- Verifique se a atualização automática de estatísticas está ativada (deveria estar por padrão):

SELECT name, is_auto_update_stats_on
FROM sys.databases
WHERE name = 'SIBD';

-- Se estiver desligado (0), ative com:

ALTER DATABASE SeuBancoDeDados SET AUTO_UPDATE_STATISTICS ON;














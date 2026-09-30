-- listar os Jobs (schedules, commands, steps)

SELECT
    [sJOB].[name] AS [JobName] ,
    CASE [sJOB].[enabled]
      WHEN 1 THEN 'Yes'
      WHEN 0 THEN 'No'
    END AS [IsEnabled] ,
    [sJOB].[date_created] AS [JobCreatedOn] ,
    [sJOB].[date_modified] AS [JobLastModifiedOn] ,
    [sJSTP].[step_id] AS [StepNo] ,
    [sJSTP].[step_name] AS [StepName] ,
    [sDBP].[name] AS [JobOwner] ,
    [sCAT].[name] AS [JobCategory] ,
    [sJOB].[description] AS [JobDescription] ,
    CASE [sJSTP].[subsystem]
      WHEN 'ActiveScripting' THEN 'ActiveX Script'
      WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
      WHEN 'PowerShell' THEN 'PowerShell'
      WHEN 'Distribution' THEN 'Replication Distributor'
      WHEN 'Merge' THEN 'Replication Merge'
      WHEN 'QueueReader' THEN 'Replication Queue Reader'
      WHEN 'Snapshot' THEN 'Replication Snapshot'
      WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
      WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
      WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
      WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
      WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
      ELSE sJSTP.subsystem
    END AS [StepType] ,
    [sPROX].[name] AS [RunAs] ,
    [sJSTP].[database_name] AS [Database] ,
    REPLACE(REPLACE(REPLACE([sJSTP].[command], CHAR(10) + CHAR(13), ' '), CHAR(13), ' '), CHAR(10), ' ') AS [ExecutableCommand] ,
    CASE [sJSTP].[on_success_action]
      WHEN 1 THEN 'Quit the job reporting success'
      WHEN 2 THEN 'Quit the job reporting failure'
      WHEN 3 THEN 'Go to the next step'
      WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) + ' ' + [sOSSTP].[step_name]
    END AS [OnSuccessAction] ,
    [sJSTP].[retry_attempts] AS [RetryAttempts] ,
    [sJSTP].[retry_interval] AS [RetryInterval (Minutes)] ,
    CASE [sJSTP].[on_fail_action]
      WHEN 1 THEN 'Quit the job reporting success'
      WHEN 2 THEN 'Quit the job reporting failure'
      WHEN 3 THEN 'Go to the next step'
      WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) + ' ' + [sOFSTP].[step_name]
    END AS [OnFailureAction],
    CASE
        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
        ELSE 'Yes'
      END AS [IsScheduled],
    [sSCH].[name] AS [JobScheduleName],
    CASE 
        WHEN [sSCH].[freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN [sSCH].[freq_type] = 128 THEN 'Start whenever the CPUs become idle'
        WHEN [sSCH].[freq_type] IN (4,8,16,32) THEN 'Recurring'
        WHEN [sSCH].[freq_type] = 1 THEN 'One Time'
    END [ScheduleType], 
    CASE [sSCH].[freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
  END [Occurrence], 
  CASE [sSCH].[freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' week(s) on '
                + CASE WHEN [sSCH].[freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                + CASE WHEN [sSCH].[freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                 + CASE [sSCH].[freq_relative_interval]
                    WHEN 1 THEN 'First'
                    WHEN 2 THEN 'Second'
                    WHEN 4 THEN 'Third'
                    WHEN 8 THEN 'Fourth'
                    WHEN 16 THEN 'Last'
                   END
                 + ' ' 
                 + CASE [sSCH].[freq_interval]
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                    WHEN 8 THEN 'Day'
                    WHEN 9 THEN 'Weekday'
                    WHEN 10 THEN 'Weekend day'
                   END
                 + ' of every ' + CAST([sSCH].[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
    END AS [Recurrence], 
    CASE [sSCH].[freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' + CAST([sSCH].[freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST([sSCH].[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
    END [Frequency], 
    STUFF(STUFF(CAST([sSCH].[active_start_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageStartDate], 
    STUFF(STUFF(CAST([sSCH].[active_end_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageEndDate], 
    [sSCH].[date_created] AS [ScheduleCreatedOn], 
    [sSCH].[date_modified] AS [ScheduleLastModifiedOn],
    CASE [sJOB].[delete_level]
        WHEN 0 THEN 'Never'
        WHEN 1 THEN 'On Success'
        WHEN 2 THEN 'On Failure'
        WHEN 3 THEN 'On Completion'
    END AS [JobDeletionCriterion]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
    LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
    LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
    LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
ORDER BY
    [JobName] ,
    [StepNo]

-- Identificar locks (sessões que estão travando recursos, mas não tem nenhuma sessão sendo travada ainda)

SELECT
    A.request_session_id AS session_id,
    COALESCE(G.start_time, F.last_request_start_time) AS start_time,
    COALESCE(G.open_transaction_count, F.open_transaction_count) AS open_transaction_count,
    A.resource_database_id,
    DB_NAME(A.resource_database_id) AS dbname,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.[name] ELSE E.[name] END) AS ObjectName,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) AS is_ms_shipped,
    --B.index_id,
    --C.[name] AS index_name,
    --A.resource_type,
    --A.resource_description,
    --A.resource_associated_entity_id,
    A.request_mode,
    A.request_status,
    F.login_name,
    F.[program_name],
    F.[host_name],
    G.blocking_session_id
FROM
    sys.dm_tran_locks A WITH(NOLOCK)
    LEFT JOIN sys.partitions B WITH(NOLOCK) ON B.hobt_id = A.resource_associated_entity_id
    LEFT JOIN sys.indexes C WITH(NOLOCK) ON C.[object_id] = B.[object_id] AND C.index_id = B.index_id
    LEFT JOIN sys.objects D WITH(NOLOCK) ON A.resource_associated_entity_id = D.[object_id]
    LEFT JOIN sys.objects E WITH(NOLOCK) ON B.[object_id] = E.[object_id]
    LEFT JOIN sys.dm_exec_sessions F WITH(NOLOCK) ON A.request_session_id = F.session_id
    LEFT JOIN sys.dm_exec_requests G WITH(NOLOCK) ON A.request_session_id = G.session_id
WHERE
    A.resource_associated_entity_id > 0
    AND A.resource_database_id = DB_ID()
    AND A.resource_type = 'OBJECT'
    AND (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) = 0
ORDER BY
    A.request_session_id,
    A.resource_associated_entity_id

-- Identificar blocks (sessões que estão travando outras)

DECLARE @Monitoramento_Locks TABLE
(
    [nested_level] INT,
    [session_id] SMALLINT,
    [wait_info] NVARCHAR(4000),
    [wait_time_ms] BIGINT,
    [blocking_session_id] SMALLINT,
    [blocked_session_count] INT,
    [open_transaction_count] INT,
    [sql_text] XML,
    [sql_command] XML,
    [total_elapsed_time] INT,
    [deadlock_priority] INT,
    [transaction_isolation_level] VARCHAR(50),
    [last_request_start_time] DATETIME,
    [login_name] NVARCHAR(128),
    [nt_user_name] NVARCHAR(128),
    [original_login_name] NVARCHAR(128),
    [host_name] NVARCHAR(128),
    [program_name] NVARCHAR(128)
)

INSERT INTO @Monitoramento_Locks
SELECT
    NULL AS nested_level,
    A.session_id AS session_id,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGE%LATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info,
    COALESCE(E.wait_duration_ms, B.wait_time) AS wait_time_ms,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(F.blocked_session_count, 0) AS blocked_session_count,
    A.open_transaction_count,
    CAST('<?query --' + CHAR(10) + (
    SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                        WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                        ELSE B.statement_end_offset
                                                                    END
                                                                    ) - B.statement_start_offset
                                                                ) / 2 + 1
                    )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
    CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
    A.total_elapsed_time,
    A.[deadlock_priority],
    (CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
    A.last_request_start_time,
    A.login_name,
    A.nt_user_name,
    A.original_login_name,
    A.[host_name],
    (CASE WHEN D.name IS NOT NULL THEN 'SQLAgent - TSQL Job (' + D.[name] + ' - ' + SUBSTRING(A.[program_name], 67, LEN(A.[program_name]) - 67) +  ')' ELSE A.[program_name] END) AS [program_name]
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    LEFT JOIN msdb.dbo.sysjobs AS D ON RIGHT(D.job_id, 10) = RIGHT(SUBSTRING(A.[program_name], 30, 34), 10)
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGE%LATCH%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM
            sys.dm_exec_requests
        WHERE
            blocking_session_id <> 0
        GROUP BY
            blocking_session_id
    ) F ON A.session_id = F.blocking_session_id
    LEFT JOIN sys.sysprocesses AS G WITH(NOLOCK) ON A.session_id = G.spid
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], G.[sql_handle])) AS X
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND (
        (NULLIF(B.blocking_session_id, 0) IS NOT NULL OR COALESCE(F.blocked_session_count, 0) > 0)
        OR (A.session_id IN (SELECT NULLIF(blocking_session_id, 0) FROM sys.dm_exec_requests))
    )


------------------------------------------------
-- Gera o nível dos locks
------------------------------------------------

UPDATE @Monitoramento_Locks
SET nested_level = 1
WHERE blocking_session_id IS NULL


DECLARE @Contador INT = 2

WHILE(EXISTS(SELECT NULL FROM @Monitoramento_Locks WHERE nested_level IS NULL) AND @Contador < 50)
BEGIN
        

    UPDATE A
    SET 
        A.nested_level = @Contador
    FROM 
        @Monitoramento_Locks A
        JOIN @Monitoramento_Locks B ON A.blocking_session_id = B.session_id
    WHERE 
        A.nested_level IS NULL
        AND B.nested_level = (@Contador - 1)


    SET @Contador += 1


END


UPDATE @Monitoramento_Locks
SET nested_level = @Contador
WHERE nested_level IS NULL


SELECT * 
FROM @Monitoramento_Locks
ORDER BY nested_level, blocked_session_count DESC, blocking_session_id, wait_time_ms DESC

-- Identificar eventos de deadlock

DECLARE @TimeZone INT = DATEDIFF(HOUR, GETUTCDATE(), GETDATE())

SELECT
    DATEADD(HOUR, @TimeZone, xed.value('@timestamp', 'datetime2(3)')) AS CreationDate,
    xed.query('.') AS XEvent
FROM
(
    SELECT 
        CAST(st.[target_data] AS XML) AS TargetData
    FROM 
        sys.dm_xe_session_targets AS st
        INNER JOIN sys.dm_xe_sessions AS s ON s.[address] = st.event_session_address
    WHERE 
        s.[name] = N'system_health'
        AND st.target_name = N'ring_buffer'
) AS [Data]
CROSS APPLY TargetData.nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData (xed)
ORDER BY 
    CreationDate DESC

-- Consulta a configuração de energia do servidor

DECLARE
    @value VARCHAR(64),
    @key VARCHAR(512) = 'SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes'
 
EXEC master..xp_regread
    @rootkey = 'HKEY_LOCAL_MACHINE',
    @key = @key,
    @value_name = 'ActivePowerScheme',
    @value = @value OUTPUT;
 
SELECT (CASE 
    WHEN @value = '381b4222-f694-41f0-9685-ff5bb260df2e' THEN '(Balanced)'
    WHEN @value = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' THEN '(High performance)'
    WHEN @value = 'a1841308-3541-4fab-bc81-f71556f20b4a' THEN '(Power saver)'
END)

-- alterar a configuração de energia do servidor

DECLARE @Fl_Xp_CmdShell_Ativado BIT = (SELECT (CASE WHEN CAST([value] AS VARCHAR(MAX)) = '1' THEN 1 ELSE 0 END) FROM sys.configurations WHERE [name] = 'xp_cmdshell')
 
IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN
 
    EXECUTE sp_configure 'show advanced options', 1;
    RECONFIGURE WITH OVERRIDE;
    
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE WITH OVERRIDE;
    
END


-- 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c (High Performance = Alta Performance)
-- 381b4222-f694-41f0-9685-ff5bb260df2e (Balanced = Balanceado)
-- a1841308-3541-4fab-bc81-f71556f20b4a (Power saver = Economia de Energia)

EXEC sys.xp_cmdshell 'powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c' -- High Performance


IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN
 
    EXEC sp_configure 'xp_cmdshell', 0;
    RECONFIGURE WITH OVERRIDE;
 
    EXECUTE sp_configure 'show advanced options', 0;
    RECONFIGURE WITH OVERRIDE;
 
END

-- Histórico do consumo de CPU (últimos 256 minutos)

DECLARE @ts_now BIGINT =
        (
            SELECT
                cpu_ticks / ( cpu_ticks / ms_ticks )
            FROM
                sys.dm_os_sys_info WITH ( NOLOCK )
        );

SELECT TOP ( 256 )
    SQLProcessUtilization AS [SQL Server Process CPU Utilization],
    SystemIdle AS [System Idle Process],
    100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization],
    DATEADD(ms, -1 * ( @ts_now - [timestamp] ), GETDATE()) AS [Event Time]
FROM
(
    SELECT
        record.value('(./Record/@id)[1]', 'int') AS record_id,
        record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle],
        record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [SQLProcessUtilization],
        [timestamp]
    FROM
    (
        SELECT
            [timestamp],
            CONVERT(XML, record) AS [record]
        FROM
            sys.dm_os_ring_buffers WITH ( NOLOCK )
        WHERE
            ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE N'%<SystemHealth>%'
    ) AS x
) AS y
ORDER BY
    record_id DESC
OPTION ( RECOMPILE );

-- 

SELECT
    DB_NAME(fs.database_id) AS [Database Name],
    mf.physical_name,
    io_stall_read_ms,
    num_of_reads,
    CAST(io_stall_read_ms / ( 1.0 + num_of_reads ) AS NUMERIC(10, 1)) AS [avg_read_stall_ms],
    io_stall_write_ms,
    num_of_writes,
    CAST(io_stall_write_ms / ( 1.0 + num_of_writes ) AS NUMERIC(10, 1)) AS [avg_write_stall_ms],
    io_stall_read_ms + io_stall_write_ms AS [io_stalls],
    num_of_reads + num_of_writes AS [total_io],
    CAST(( io_stall_read_ms + io_stall_write_ms ) / ( 1.0 + num_of_reads + num_of_writes ) AS NUMERIC(10, 1)) AS [avg_io_stall_ms]
FROM
    sys.dm_io_virtual_file_stats(NULL, NULL) AS fs
    INNER JOIN sys.master_files AS mf WITH ( NOLOCK ) ON fs.database_id = mf.database_id AND fs.[file_id] = mf.[file_id]
ORDER BY
    avg_io_stall_ms DESC;

-- Análise de eventos de wait

SELECT *
FROM sys.dm_os_wait_stats
ORDER BY wait_time_ms DESC

-- verão aperfeiçoada

;WITH [Waits]
AS ( SELECT
         [wait_type],
         [wait_time_ms] / 1000.0 AS [WaitS],
         ( [wait_time_ms] - [signal_wait_time_ms] ) / 1000.0 AS [ResourceS],
         [signal_wait_time_ms] / 1000.0 AS [SignalS],
         [waiting_tasks_count] AS [WaitCount],
         100.0 * [wait_time_ms] / SUM([wait_time_ms]) OVER () AS [Percentage],
         ROW_NUMBER() OVER ( ORDER BY
                                 [wait_time_ms] DESC
                           ) AS [RowNum]
     FROM
         sys.dm_os_wait_stats
     WHERE
         [wait_type] NOT IN (
                                -- These wait types are almost 100% never a problem and so they are
                                -- filtered out to avoid them skewing the results. Click on the URL
                                -- for more information.
                                N'BROKER_EVENTHANDLER', -- https://www.sqlskills.com/help/waits/BROKER_EVENTHANDLER
                                N'BROKER_RECEIVE_WAITFOR', -- https://www.sqlskills.com/help/waits/BROKER_RECEIVE_WAITFOR
                                N'BROKER_TASK_STOP', -- https://www.sqlskills.com/help/waits/BROKER_TASK_STOP
                                N'BROKER_TO_FLUSH', -- https://www.sqlskills.com/help/waits/BROKER_TO_FLUSH
                                N'BROKER_TRANSMITTER', -- https://www.sqlskills.com/help/waits/BROKER_TRANSMITTER
                                N'CHECKPOINT_QUEUE', -- https://www.sqlskills.com/help/waits/CHECKPOINT_QUEUE
                                N'CHKPT', -- https://www.sqlskills.com/help/waits/CHKPT
                                N'CLR_AUTO_EVENT', -- https://www.sqlskills.com/help/waits/CLR_AUTO_EVENT
                                N'CLR_MANUAL_EVENT', -- https://www.sqlskills.com/help/waits/CLR_MANUAL_EVENT
                                N'CLR_SEMAPHORE', -- https://www.sqlskills.com/help/waits/CLR_SEMAPHORE
                                N'CXCONSUMER', -- https://www.sqlskills.com/help/waits/CXCONSUMER

                                -- Maybe comment these four out if you have mirroring issues
                                N'DBMIRROR_DBM_EVENT', -- https://www.sqlskills.com/help/waits/DBMIRROR_DBM_EVENT
                                N'DBMIRROR_EVENTS_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_EVENTS_QUEUE
                                N'DBMIRROR_WORKER_QUEUE', -- https://www.sqlskills.com/help/waits/DBMIRROR_WORKER_QUEUE
                                N'DBMIRRORING_CMD', -- https://www.sqlskills.com/help/waits/DBMIRRORING_CMD

                                N'DIRTY_PAGE_POLL', -- https://www.sqlskills.com/help/waits/DIRTY_PAGE_POLL
                                N'DISPATCHER_QUEUE_SEMAPHORE', -- https://www.sqlskills.com/help/waits/DISPATCHER_QUEUE_SEMAPHORE
                                N'EXECSYNC', -- https://www.sqlskills.com/help/waits/EXECSYNC
                                N'FSAGENT', -- https://www.sqlskills.com/help/waits/FSAGENT
                                N'FT_IFTS_SCHEDULER_IDLE_WAIT', -- https://www.sqlskills.com/help/waits/FT_IFTS_SCHEDULER_IDLE_WAIT
                                N'FT_IFTSHC_MUTEX', -- https://www.sqlskills.com/help/waits/FT_IFTSHC_MUTEX

                                -- Maybe comment these six out if you have AG issues
                                N'HADR_CLUSAPI_CALL', -- https://www.sqlskills.com/help/waits/HADR_CLUSAPI_CALL
                                N'HADR_FILESTREAM_IOMGR_IOCOMPLETION', -- https://www.sqlskills.com/help/waits/HADR_FILESTREAM_IOMGR_IOCOMPLETION
                                N'HADR_LOGCAPTURE_WAIT', -- https://www.sqlskills.com/help/waits/HADR_LOGCAPTURE_WAIT
                                N'HADR_NOTIFICATION_DEQUEUE', -- https://www.sqlskills.com/help/waits/HADR_NOTIFICATION_DEQUEUE
                                N'HADR_TIMER_TASK', -- https://www.sqlskills.com/help/waits/HADR_TIMER_TASK
                                N'HADR_WORK_QUEUE', -- https://www.sqlskills.com/help/waits/HADR_WORK_QUEUE

                                N'KSOURCE_WAKEUP', -- https://www.sqlskills.com/help/waits/KSOURCE_WAKEUP
                                N'LAZYWRITER_SLEEP', -- https://www.sqlskills.com/help/waits/LAZYWRITER_SLEEP
                                N'LOGMGR_QUEUE', -- https://www.sqlskills.com/help/waits/LOGMGR_QUEUE
                                N'MEMORY_ALLOCATION_EXT', -- https://www.sqlskills.com/help/waits/MEMORY_ALLOCATION_EXT
                                N'ONDEMAND_TASK_QUEUE', -- https://www.sqlskills.com/help/waits/ONDEMAND_TASK_QUEUE
                                N'PARALLEL_REDO_DRAIN_WORKER', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_DRAIN_WORKER
                                N'PARALLEL_REDO_LOG_CACHE', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_LOG_CACHE
                                N'PARALLEL_REDO_TRAN_LIST', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_TRAN_LIST
                                N'PARALLEL_REDO_WORKER_SYNC', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_SYNC
                                N'PARALLEL_REDO_WORKER_WAIT_WORK', -- https://www.sqlskills.com/help/waits/PARALLEL_REDO_WORKER_WAIT_WORK
                                N'PREEMPTIVE_XE_GETTARGETSTATE', -- https://www.sqlskills.com/help/waits/PREEMPTIVE_XE_GETTARGETSTATE
                                N'PWAIT_ALL_COMPONENTS_INITIALIZED', -- https://www.sqlskills.com/help/waits/PWAIT_ALL_COMPONENTS_INITIALIZED
                                N'PWAIT_DIRECTLOGCONSUMER_GETNEXT', -- https://www.sqlskills.com/help/waits/PWAIT_DIRECTLOGCONSUMER_GETNEXT
                                N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP', -- https://www.sqlskills.com/help/waits/QDS_PERSIST_TASK_MAIN_LOOP_SLEEP
                                N'QDS_ASYNC_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_ASYNC_QUEUE
                                N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP', -- https://www.sqlskills.com/help/waits/QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP
                                N'QDS_SHUTDOWN_QUEUE', -- https://www.sqlskills.com/help/waits/QDS_SHUTDOWN_QUEUE
                                N'REDO_THREAD_PENDING_WORK', -- https://www.sqlskills.com/help/waits/REDO_THREAD_PENDING_WORK
                                N'REQUEST_FOR_DEADLOCK_SEARCH', -- https://www.sqlskills.com/help/waits/REQUEST_FOR_DEADLOCK_SEARCH
                                N'RESOURCE_QUEUE', -- https://www.sqlskills.com/help/waits/RESOURCE_QUEUE
                                N'SERVER_IDLE_CHECK', -- https://www.sqlskills.com/help/waits/SERVER_IDLE_CHECK
                                N'SLEEP_BPOOL_FLUSH', -- https://www.sqlskills.com/help/waits/SLEEP_BPOOL_FLUSH
                                N'SLEEP_DBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DBSTARTUP
                                N'SLEEP_DCOMSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_DCOMSTARTUP
                                N'SLEEP_MASTERDBREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERDBREADY
                                N'SLEEP_MASTERMDREADY', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERMDREADY
                                N'SLEEP_MASTERUPGRADED', -- https://www.sqlskills.com/help/waits/SLEEP_MASTERUPGRADED
                                N'SLEEP_MSDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_MSDBSTARTUP
                                N'SLEEP_SYSTEMTASK', -- https://www.sqlskills.com/help/waits/SLEEP_SYSTEMTASK
                                N'SLEEP_TASK', -- https://www.sqlskills.com/help/waits/SLEEP_TASK
                                N'SLEEP_TEMPDBSTARTUP', -- https://www.sqlskills.com/help/waits/SLEEP_TEMPDBSTARTUP
                                N'SNI_HTTP_ACCEPT', -- https://www.sqlskills.com/help/waits/SNI_HTTP_ACCEPT
                                N'SP_SERVER_DIAGNOSTICS_SLEEP', -- https://www.sqlskills.com/help/waits/SP_SERVER_DIAGNOSTICS_SLEEP
                                N'SQLTRACE_BUFFER_FLUSH', -- https://www.sqlskills.com/help/waits/SQLTRACE_BUFFER_FLUSH
                                N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP', -- https://www.sqlskills.com/help/waits/SQLTRACE_INCREMENTAL_FLUSH_SLEEP
                                N'SQLTRACE_WAIT_ENTRIES', -- https://www.sqlskills.com/help/waits/SQLTRACE_WAIT_ENTRIES
                                N'WAIT_FOR_RESULTS', -- https://www.sqlskills.com/help/waits/WAIT_FOR_RESULTS
                                N'WAITFOR', -- https://www.sqlskills.com/help/waits/WAITFOR
                                N'WAITFOR_TASKSHUTDOWN', -- https://www.sqlskills.com/help/waits/WAITFOR_TASKSHUTDOWN
                                N'WAIT_XTP_RECOVERY', -- https://www.sqlskills.com/help/waits/WAIT_XTP_RECOVERY
                                N'WAIT_XTP_HOST_WAIT', -- https://www.sqlskills.com/help/waits/WAIT_XTP_HOST_WAIT
                                N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG', -- https://www.sqlskills.com/help/waits/WAIT_XTP_OFFLINE_CKPT_NEW_LOG
                                N'WAIT_XTP_CKPT_CLOSE', -- https://www.sqlskills.com/help/waits/WAIT_XTP_CKPT_CLOSE
                                N'XE_DISPATCHER_JOIN', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_JOIN
                                N'XE_DISPATCHER_WAIT', -- https://www.sqlskills.com/help/waits/XE_DISPATCHER_WAIT
                                N'XE_TIMER_EVENT' -- https://www.sqlskills.com/help/waits/XE_TIMER_EVENT
                            )
         AND [waiting_tasks_count] > 0 )
SELECT
    MAX([W1].[wait_type]) AS [WaitType],
    CAST(MAX([W1].[WaitS]) AS DECIMAL(16, 2)) AS [Wait_S],
    CAST(MAX([W1].[ResourceS]) AS DECIMAL(16, 2)) AS [Resource_S],
    CAST(MAX([W1].[SignalS]) AS DECIMAL(16, 2)) AS [Signal_S],
    MAX([W1].[WaitCount]) AS [WaitCount],
    CAST(MAX([W1].[Percentage]) AS DECIMAL(5, 2)) AS [Percentage],
    CAST(( MAX([W1].[WaitS]) / MAX([W1].[WaitCount])) AS DECIMAL(16, 4)) AS [AvgWait_S],
    CAST(( MAX([W1].[ResourceS]) / MAX([W1].[WaitCount])) AS DECIMAL(16, 4)) AS [AvgRes_S],
    CAST(( MAX([W1].[SignalS]) / MAX([W1].[WaitCount])) AS DECIMAL(16, 4)) AS [AvgSig_S],
    CAST('https://www.sqlskills.com/help/waits/' + MAX([W1].[wait_type]) AS XML) AS [Help/Info URL]
FROM
    [Waits] AS [W1]
    INNER JOIN [Waits] AS [W2] ON [W2].[RowNum] <= [W1].[RowNum]
GROUP BY
    [W1].[RowNum]
HAVING
    SUM([W2].[Percentage]) - MAX([W1].[Percentage]) < 95; -- percentage threshold
GO

-- Identificar consultas pesadas utilizando a plancache

SELECT TOP(100)
    DB_NAME(C.[dbid]) as [database],
    B.[text],
    (SELECT CAST(SUBSTRING(B.[text], (A.statement_start_offset/2)+1,   
        (((CASE A.statement_end_offset  
            WHEN -1 THEN DATALENGTH(B.[text]) 
            ELSE A.statement_end_offset  
        END) - A.statement_start_offset)/2) + 1) AS NVARCHAR(MAX)) FOR XML PATH(''), TYPE) AS [TSQL],
    C.query_plan,

    A.last_execution_time,
    A.execution_count,
 
    A.total_elapsed_time / 1000 AS total_elapsed_time_ms,
    A.last_elapsed_time / 1000 AS last_elapsed_time_ms,
    A.min_elapsed_time / 1000 AS min_elapsed_time_ms,
    A.max_elapsed_time / 1000 AS max_elapsed_time_ms,
    ((A.total_elapsed_time / A.execution_count) / 1000) AS avg_elapsed_time_ms,
 
    A.total_worker_time / 1000 AS total_worker_time_ms,
    A.last_worker_time / 1000 AS last_worker_time_ms,
    A.min_worker_time / 1000 AS min_worker_time_ms,
    A.max_worker_time / 1000 AS max_worker_time_ms,
    ((A.total_worker_time / A.execution_count) / 1000) AS avg_worker_time_ms,
   
    A.total_physical_reads,
    A.last_physical_reads,
    A.min_physical_reads,
    A.max_physical_reads,
   
    A.total_logical_reads,
    A.last_logical_reads,
    A.min_logical_reads,
    A.max_logical_reads,
   
    A.total_logical_writes,
    A.last_logical_writes,
    A.min_logical_writes,
    A.max_logical_writes
FROM
    sys.dm_exec_query_stats A
    CROSS APPLY sys.dm_exec_sql_text(A.[sql_handle]) B
    OUTER APPLY sys.dm_exec_query_plan (A.plan_handle) AS C
ORDER BY
    A.total_elapsed_time DESC

-- Identificar as Stored Procedures pesadas utilizando a plancache

SELECT TOP(100)
    B.[name] AS rotina,
    A.cached_time,
    A.last_execution_time,
    A.execution_count,

    A.total_elapsed_time / 1000 AS total_elapsed_time_ms,
    A.last_elapsed_time / 1000 AS last_elapsed_time_ms,
    A.min_elapsed_time / 1000 AS min_elapsed_time_ms,
    A.max_elapsed_time / 1000 AS max_elapsed_time_ms,
    ((A.total_elapsed_time / A.execution_count) / 1000) AS avg_elapsed_time_ms,

    A.total_worker_time / 1000 AS total_worker_time_ms,
    A.last_worker_time / 1000 AS last_worker_time_ms,
    A.min_worker_time / 1000 AS min_worker_time_ms,
    A.max_worker_time / 1000 AS max_worker_time_ms,
    ((A.total_worker_time / A.execution_count) / 1000) AS avg_worker_time_ms,
    
    A.total_physical_reads,
    A.last_physical_reads,
    A.min_physical_reads,
    A.max_physical_reads,
    
    A.total_logical_reads,
    A.last_logical_reads,
    A.min_logical_reads,
    A.max_logical_reads,
    
    A.total_logical_writes,
    A.last_logical_writes,
    A.min_logical_writes,
    A.max_logical_writes
FROM
    sys.dm_exec_procedure_stats                 A
    JOIN sys.objects                            B    ON  A.[object_id] = B.[object_id]
ORDER BY
    A.execution_count DESC

-- Listar os jobs em execução

SELECT
    F.session_id,
    A.job_id,
    C.name AS job_name,
    F.login_name,
    F.[host_name],
    F.[program_name],
    A.start_execution_date,
    CONVERT(VARCHAR, CONVERT(VARCHAR, DATEADD(ms, ( DATEDIFF(SECOND, A.start_execution_date, GETDATE()) % 86400 ) * 1000, 0), 114)) AS time_elapsed,
    ISNULL(A.last_executed_step_id, 0) + 1 AS current_executed_step_id,
    D.step_name,
    H.[text]
FROM
    msdb.dbo.sysjobactivity                     A   WITH(NOLOCK)
    LEFT JOIN msdb.dbo.sysjobhistory            B   WITH(NOLOCK)    ON A.job_history_id = B.instance_id
    JOIN msdb.dbo.sysjobs                       C   WITH(NOLOCK)    ON A.job_id = C.job_id
    JOIN msdb.dbo.sysjobsteps                   D   WITH(NOLOCK)    ON A.job_id = D.job_id AND ISNULL(A.last_executed_step_id, 0) + 1 = D.step_id
    JOIN (
        SELECT CAST(CONVERT( BINARY(16), SUBSTRING([program_name], 30, 34), 1) AS UNIQUEIDENTIFIER) AS job_id, MAX(login_time) login_time
        FROM sys.dm_exec_sessions WITH(NOLOCK)
        WHERE [program_name] LIKE 'SQLAgent - TSQL JobStep (Job % : Step %)'
        GROUP BY CAST(CONVERT( BINARY(16), SUBSTRING([program_name], 30, 34), 1) AS UNIQUEIDENTIFIER)
    )                                           E                   ON C.job_id = E.job_id
    LEFT JOIN sys.dm_exec_sessions              F   WITH(NOLOCK)    ON E.job_id = (CASE WHEN BINARY_CHECKSUM(SUBSTRING(F.[program_name], 30, 34)) > 0 THEN CAST(TRY_CONVERT( BINARY(16), SUBSTRING(F.[program_name], 30, 34), 1) AS UNIQUEIDENTIFIER) ELSE NULL END) AND E.login_time = F.login_time
    LEFT JOIN sys.dm_exec_connections           G   WITH(NOLOCK)    ON F.session_id = G.session_id
    OUTER APPLY sys.dm_exec_sql_text(most_recent_sql_handle) H
WHERE
    A.session_id = ( SELECT TOP 1 session_id FROM msdb.dbo.syssessions	WITH(NOLOCK) ORDER BY agent_start_date DESC ) 
    AND A.start_execution_date IS NOT NULL 
    AND A.stop_execution_date IS NULL

-- Histórico de execução dos Jobs

SELECT 
    A.job_id,
    A.[name],
    msdb.dbo.agent_datetime(B.run_date, B.run_time) AS execution_date,
    A.[enabled],
    B.step_id,
    B.step_name,
    B.[message],
    (CASE B.run_status
        WHEN 0 THEN '0 - Failed'
        WHEN 1 THEN '1 - Succeeded'
        WHEN 2 THEN '2 - Retry'
        WHEN 3 THEN '3 - Canceled'
        WHEN 4 THEN '4 - In Progress'
    END) AS run_status,
    B.run_duration
FROM
    msdb.dbo.sysjobs A
    JOIN msdb.dbo.sysjobhistory B ON B.job_id = A.job_id

-- Histórico da atividade da execução dos jobs

SELECT 
    A.job_id,
    A.[name],
    B.session_id,
    B.run_requested_date,
    B.run_requested_source,
    B.queued_date,
    B.start_execution_date,
    B.last_executed_step_id,
    B.last_executed_step_date,
    B.stop_execution_date,
    B.job_history_id,
    B.next_scheduled_run_date	
FROM
    msdb.dbo.sysjobs A
    JOIN msdb.dbo.sysjobactivity B ON B.job_id = A.job_id

-- Procurando uma string em um job (ou step) no SQL Server

DECLARE @String VARCHAR(100) = '192.168.0.28'

SELECT
    [sJOB].[name] AS [JobName] ,
    CASE [sJOB].[enabled]
        WHEN 1 THEN 'Yes'
        WHEN 0 THEN 'No'
    END AS [IsEnabled] ,
    [sJOB].[date_created] AS [JobCreatedOn] ,
    [sJOB].[date_modified] AS [JobLastModifiedOn] ,
    [sJSTP].[step_id] AS [StepNo] ,
    [sJSTP].[step_name] AS [StepName] ,
    [sDBP].[name] AS [JobOwner] ,
    [sCAT].[name] AS [JobCategory] ,
    [sJOB].[description] AS [JobDescription] ,
    CASE [sJSTP].[subsystem]
        WHEN 'ActiveScripting' THEN 'ActiveX Script'
        WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
        WHEN 'PowerShell' THEN 'PowerShell'
        WHEN 'Distribution' THEN 'Replication Distributor'
        WHEN 'Merge' THEN 'Replication Merge'
        WHEN 'QueueReader' THEN 'Replication Queue Reader'
        WHEN 'Snapshot' THEN 'Replication Snapshot'
        WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
        WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
        WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
        WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
        WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
        ELSE sJSTP.subsystem
    END AS [StepType] ,
    [sPROX].[name] AS [RunAs] ,
    [sJSTP].[database_name] AS [Database] ,
    [sJSTP].[command] AS [ExecutableCommand] ,
    CASE [sJSTP].[on_success_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) + ' ' + [sOSSTP].[step_name]
    END AS [OnSuccessAction] ,
    [sJSTP].[retry_attempts] AS [RetryAttempts] ,
    [sJSTP].[retry_interval] AS [RetryInterval (Minutes)] ,
    CASE [sJSTP].[on_fail_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) + ' ' + [sOFSTP].[step_name]
    END AS [OnFailureAction],
    CASE
        WHEN [sSCH].[schedule_uid] IS NULL THEN 'No'
        ELSE 'Yes'
        END AS [IsScheduled],
    [sSCH].[name] AS [JobScheduleName],
    CASE [sJOB].[delete_level]
        WHEN 0 THEN 'Never'
        WHEN 1 THEN 'On Success'
        WHEN 2 THEN 'On Failure'
        WHEN 3 THEN 'On Completion'
        END AS [JobDeletionCriterion]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB] ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP] ON [sJSTP].[job_id] = [sOSSTP].[job_id] AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP] ON [sJSTP].[job_id] = [sOFSTP].[job_id] AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX] ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
    LEFT JOIN [msdb].[dbo].[syscategories] AS [sCAT] ON [sJOB].[category_id] = [sCAT].[category_id]
    LEFT JOIN [msdb].[sys].[database_principals] AS [sDBP] ON [sJOB].[owner_sid] = [sDBP].[sid]
    LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] ON [sJOB].[job_id] = [sJOBSCH].[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id]
WHERE
    [sJSTP].[command] LIKE '%' + @String + '%'
    OR [sJOB].[name] LIKE '%' + @String + '%'
ORDER BY
    [JobName] ,
    [StepNo]

-- Buscar uma string no código de SP’s que são chamadas por jobs do SQL Agent

DECLARE
    @Ds_Busca VARCHAR(200) = 'CLIUCPDAT'


IF (OBJECT_ID('tempdb..#Resultado') IS NOT NULL) DROP TABLE #Resultado
CREATE TABLE #Resultado (
    Ds_Database SYSNAME NULL,
    Ds_Objeto SYSNAME NULL,
    Ds_Schema SYSNAME NULL,
    Ds_Tipo VARCHAR(100) NULL
)
 
    
DECLARE @Query VARCHAR(MAX) = '
SELECT 
    DB_NAME(DB_ID(''?''))       AS Ds_Database,
    B.name                      AS Ds_Objeto,
    C.name                      AS Ds_Schema,
    B.type_desc                 AS Ds_Tipo
FROM 
    [?].sys.sql_modules         A   WITH(NOLOCK)
    JOIN [?].sys.objects        B   WITH(NOLOCK)    ON A.object_id = B.object_id
    JOIN [?].sys.schemas        C   WITH(NOLOCK)    ON B.schema_id = C.schema_id
WHERE
    A.definition LIKE ''%' + @Ds_Busca + '%''
'
 
 
INSERT INTO #Resultado
EXEC master.sys.sp_msforeachdb @Query
 
 
SELECT
    C.Ds_Database,
    C.Ds_Schema,
    C.Ds_Objeto,
    A.[name] AS job_name,
    A.[enabled],
    B.step_id,
    B.step_name,
    B.[database_name],
    (CASE WHEN B.last_run_date != 0 THEN msdb.dbo.agent_datetime(B.last_run_date, B.last_run_time) ELSE NULL END) AS last_run,
    REPLACE(REPLACE(REPLACE(B.[command], CHAR(10) + CHAR(13), ' '), CHAR(13), ' '), CHAR(10), ' ') AS [ExecutableCommand],
    E.[name] AS [JobScheduleName],
    CASE 
        WHEN E.[freq_type] = 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN E.[freq_type] = 128 THEN 'Start whenever the CPUs become idle'
        WHEN E.[freq_type] IN (4,8,16,32) THEN 'Recurring'
        WHEN E.[freq_type] = 1 THEN 'One Time'
    END [ScheduleType], 
    CASE E.[freq_type]
        WHEN 1 THEN 'One Time'
        WHEN 4 THEN 'Daily'
        WHEN 8 THEN 'Weekly'
        WHEN 16 THEN 'Monthly'
        WHEN 32 THEN 'Monthly - Relative to Frequency Interval'
        WHEN 64 THEN 'Start automatically when SQL Server Agent starts'
        WHEN 128 THEN 'Start whenever the CPUs become idle'
    END [Occurrence], 
    CASE E.[freq_type]
        WHEN 4 THEN 'Occurs every ' + CAST([freq_interval] AS VARCHAR(3)) + ' day(s)'
        WHEN 8 THEN 'Occurs every ' + CAST([freq_recurrence_factor] AS VARCHAR(3)) + ' week(s) on '
                + CASE WHEN E.[freq_interval] & 1 = 1 THEN 'Sunday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 2 = 2 THEN ', Monday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 4 = 4 THEN ', Tuesday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 8 = 8 THEN ', Wednesday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 16 = 16 THEN ', Thursday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 32 = 32 THEN ', Friday' ELSE '' END
                + CASE WHEN E.[freq_interval] & 64 = 64 THEN ', Saturday' ELSE '' END
        WHEN 16 THEN 'Occurs on Day ' + CAST([freq_interval] AS VARCHAR(3)) + ' of every ' + CAST(E.[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
        WHEN 32 THEN 'Occurs on '
                    + CASE E.[freq_relative_interval]
                    WHEN 1 THEN 'First'
                    WHEN 2 THEN 'Second'
                    WHEN 4 THEN 'Third'
                    WHEN 8 THEN 'Fourth'
                    WHEN 16 THEN 'Last'
                    END
                    + ' ' 
                    + CASE E.[freq_interval]
                    WHEN 1 THEN 'Sunday'
                    WHEN 2 THEN 'Monday'
                    WHEN 3 THEN 'Tuesday'
                    WHEN 4 THEN 'Wednesday'
                    WHEN 5 THEN 'Thursday'
                    WHEN 6 THEN 'Friday'
                    WHEN 7 THEN 'Saturday'
                    WHEN 8 THEN 'Day'
                    WHEN 9 THEN 'Weekday'
                    WHEN 10 THEN 'Weekend day'
                    END
                    + ' of every ' + CAST(E.[freq_recurrence_factor] AS VARCHAR(3)) + ' month(s)'
    END AS [Recurrence], 
    CASE E.[freq_subday_type]
        WHEN 1 THEN 'Occurs once at ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 2 THEN 'Occurs every ' + CAST(E.[freq_subday_interval] AS VARCHAR(3)) + ' Second(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 4 THEN 'Occurs every ' + CAST(E.[freq_subday_interval] AS VARCHAR(3)) + ' Minute(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
        WHEN 8 THEN 'Occurs every ' + CAST(E.[freq_subday_interval] AS VARCHAR(3)) + ' Hour(s) between ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_start_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')+ ' & ' + STUFF(STUFF(RIGHT('000000' + CAST(E.[active_end_time] AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
    END [Frequency], 
    STUFF(STUFF(CAST(E.[active_start_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageStartDate], 
    STUFF(STUFF(CAST(E.[active_end_date] AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS [ScheduleUsageEndDate]
FROM 
    msdb.dbo.sysjobs A WITH(NOLOCK)
    JOIN msdb.dbo.sysjobsteps B WITH(NOLOCK) ON A.job_id = B.job_id
    JOIN #Resultado C ON B.command LIKE '%' + C.Ds_Objeto + '%'
    LEFT JOIN [msdb].[dbo].[sysjobschedules] AS D ON [A].[job_id] = D.[job_id]
    LEFT JOIN [msdb].[dbo].[sysschedules] AS E ON D.[schedule_id] = E.[schedule_id]
WHERE
    C.Ds_Database = B.[database_name]

-- Query utilizadada (Ordenando por tempo de execução)

/*
   Vale lembrar que, como estamos consultando dados de estatísticas do banco, caso o serviço seja reiniciado, esses dados são perdidos.
   Por este motivo, sugiro criar uma rotina que colete esses dados de tempos em tempos e armazene em uma tabela física, para quando isso acontecer,
   você possa continuar sua análise de onde parou e não precise esperar por horas ou dias para ter dados para continuar analisando.
*/

SELECT TOP 100
    DB_NAME(C.[dbid]) as [database],
    B.[text],
    (SELECT CAST(SUBSTRING(B.[text], (A.statement_start_offset/2)+1,   
        (((CASE A.statement_end_offset  
            WHEN -1 THEN DATALENGTH(B.[text]) 
            ELSE A.statement_end_offset  
        END) - A.statement_start_offset)/2) + 1) AS NVARCHAR(MAX)) FOR XML PATH(''), TYPE) AS [TSQL],
    C.query_plan,

    A.last_execution_time,
    A.execution_count,
 
    A.total_elapsed_time / 1000 AS total_elapsed_time_ms,
    A.last_elapsed_time / 1000 AS last_elapsed_time_ms,
    A.min_elapsed_time / 1000 AS min_elapsed_time_ms,
    A.max_elapsed_time / 1000 AS max_elapsed_time_ms,
    ((A.total_elapsed_time / A.execution_count) / 1000) AS avg_elapsed_time_ms,
 
    A.total_worker_time / 1000 AS total_worker_time_ms,
    A.last_worker_time / 1000 AS last_worker_time_ms,
    A.min_worker_time / 1000 AS min_worker_time_ms,
    A.max_worker_time / 1000 AS max_worker_time_ms,
    ((A.total_worker_time / A.execution_count) / 1000) AS avg_worker_time_ms,
   
    A.total_physical_reads,
    A.last_physical_reads,
    A.min_physical_reads,
    A.max_physical_reads,
   
    A.total_logical_reads,
    A.last_logical_reads,
    A.min_logical_reads,
    A.max_logical_reads,
   
    A.total_logical_writes,
    A.last_logical_writes,
    A.min_logical_writes,
    A.max_logical_writes
FROM
    sys.dm_exec_query_stats A
    CROSS APPLY sys.dm_exec_sql_text(A.[sql_handle]) B
    OUTER APPLY sys.dm_exec_query_plan (A.plan_handle) AS C
ORDER BY
    A.total_elapsed_time DESC

-- Stored Procedure para armazenar as consultas Ad-hoc de todos os databases

USE [dirceuresende]
GO

CREATE PROCEDURE [dbo].[stpCarga_Historico_Execucao_Consultas]
AS BEGIN


    IF (OBJECT_ID('dirceuresende.dbo.Historico_Execucao_Consultas') IS NULL)
    BEGIN
    
        -- DROP TABLE dirceuresende.dbo.Historico_Execucao_Consultas
        CREATE TABLE dirceuresende.dbo.Historico_Execucao_Consultas
        (
            Id_Coleta BIGINT IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
            Dt_Coleta datetime NOT NULL,
            [database] sys.sysname NOT NULL,
            [text] NVARCHAR(MAX) NULL,
            [TSQL] XML NULL,
            [query_plan] XML NULL,
            last_execution_time datetime NULL,
            execution_count bigint NOT NULL,
            total_elapsed_time_ms bigint NULL,
            last_elapsed_time_ms bigint NULL,
            min_elapsed_time_ms bigint NULL,
            max_elapsed_time_ms bigint NULL,
            avg_elapsed_time_ms bigint NULL,
            total_worker_time_ms bigint NULL,
            last_worker_time_ms bigint NULL,
            min_worker_time_ms bigint NULL,
            max_worker_time_ms bigint NULL,
            avg_worker_time_ms bigint NULL,
            total_physical_reads bigint NOT NULL,
            last_physical_reads bigint NOT NULL,
            min_physical_reads bigint NOT NULL,
            max_physical_reads bigint NOT NULL,
            total_logical_reads bigint NOT NULL,
            last_logical_reads bigint NOT NULL,
            min_logical_reads bigint NOT NULL,
            max_logical_reads bigint NOT NULL,
            total_logical_writes bigint NOT NULL,
            last_logical_writes bigint NOT NULL,
            min_logical_writes bigint NOT NULL,
            max_logical_writes bigint NOT NULL
        ) WITH(DATA_COMPRESSION=PAGE)

        CREATE INDEX SK01_Historico_Execucao_Consultas ON dirceuresende.dbo.Historico_Execucao_Consultas(Dt_Coleta, [database])

    END

    
    DECLARE 
        @Dt_Referencia DATETIME = GETDATE(),
        @Query VARCHAR(MAX)


    SET @Query = '
IF (''?'' NOT IN (''master'', ''model'', ''msdb'', ''tempdb''))
BEGIN

    INSERT INTO dirceuresende.dbo.Historico_Execucao_Consultas
    SELECT
        ''' + CONVERT(VARCHAR(19), @Dt_Referencia, 120) + ''' AS Dt_Coleta,
        ''?'' AS [database],
        B.[text],
        (SELECT CAST(SUBSTRING(B.[text], (A.statement_start_offset/2)+1, (((CASE A.statement_end_offset WHEN -1 THEN DATALENGTH(B.[text]) ELSE A.statement_end_offset END) - A.statement_start_offset)/2) + 1) AS NVARCHAR(MAX)) FOR XML PATH(''''),TYPE) AS [TSQL],
        C.query_plan,

        A.last_execution_time,
        A.execution_count,

        A.total_elapsed_time / 1000 AS total_elapsed_time_ms,
        A.last_elapsed_time / 1000 AS last_elapsed_time_ms,
        A.min_elapsed_time / 1000 AS min_elapsed_time_ms,
        A.max_elapsed_time / 1000 AS max_elapsed_time_ms,
        ((A.total_elapsed_time / A.execution_count) / 1000) AS avg_elapsed_time_ms,

        A.total_worker_time / 1000 AS total_worker_time_ms,
        A.last_worker_time / 1000 AS last_worker_time_ms,
        A.min_worker_time / 1000 AS min_worker_time_ms,
        A.max_worker_time / 1000 AS max_worker_time_ms,
        ((A.total_worker_time / a.execution_count) / 1000) AS avg_worker_time_ms,
    
        A.total_physical_reads,
        A.last_physical_reads,
        A.min_physical_reads,
        A.max_physical_reads,
    
        A.total_logical_reads,
        A.last_logical_reads,
        A.min_logical_reads,
        A.max_logical_reads,
    
        A.total_logical_writes,
        A.last_logical_writes,
        A.min_logical_writes,
        A.max_logical_writes
    FROM
        [?].sys.dm_exec_query_stats A
        CROSS APPLY [?].sys.dm_exec_sql_text(A.[sql_handle]) B
        OUTER APPLY [?].sys.dm_exec_query_plan (A.plan_handle) AS C

END'

    
    EXEC master.dbo.sp_MSforeachdb
        @command1 = @Query


END
GO

-- listar as maiores tabelas do banco de dados e retornar o tamanho de cada tabela

SELECT TOP 100
    s.[name] AS [schema],
    t.[name] AS [table_name],
    p.[rows] AS [row_count],
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [size_mb],
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [used_mb], 
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS [unused_mb]
FROM 
    sys.tables t
    JOIN sys.indexes i ON t.[object_id] = i.[object_id]
    JOIN sys.partitions p ON i.[object_id] = p.[object_id] AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.[partition_id] = a.container_id
    LEFT JOIN sys.schemas s ON t.[schema_id] = s.[schema_id]
WHERE 
    t.is_ms_shipped = 0
    AND i.[object_id] > 255 
GROUP BY
    t.[name], 
    s.[name], 
    p.[rows]
ORDER BY 
    [size_mb] DESC

-- lista dos maiores índices do banco de dados

SELECT TOP(100)
    s.[name] AS [schema],
    t.[name] AS [table_name],
    i.[name] AS [index_name],
    i.[type_desc],
    p.[rows] AS [row_count],
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [size_mb],
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [used_mb], 
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00, 2) AS NUMERIC(36, 2)) AS [unused_mb]
FROM
    sys.tables t
    JOIN sys.indexes i ON t.[object_id] = i.[object_id]
    JOIN sys.partitions p ON i.[object_id] = p.[object_id] AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.[partition_id] = a.container_id
    LEFT JOIN sys.schemas s ON t.[schema_id] = s.[schema_id]
WHERE 
    t.is_ms_shipped = 0
    AND i.[object_id] > 255 
GROUP BY
    t.[name], 
    s.[name],
    i.[name],
    i.[type_desc],
    p.[rows]
ORDER BY 
    [size_mb] DESC

-- Como retornar o uso de CPU utilizando T-SQL

DECLARE @ts_now BIGINT = (
    SELECT
        cpu_ticks / ( cpu_ticks / ms_ticks )
    FROM
        sys.dm_os_sys_info
);

SELECT
    SQLProcessUtilization AS [SQL Server Process CPU Utilization],
    SystemIdle AS [System Idle Process],
    100 - SystemIdle - SQLProcessUtilization AS [Other Process CPU Utilization],
    DATEADD(ms, -1 * ( @ts_now - [timestamp] ), GETDATE()) AS [Event Time]
FROM
(
    SELECT
        record.value('(./Record/@id)[1]', 'int') AS record_id,
        record.value('(./Record/SchedulerMonitorEvent/SystemHealth/SystemIdle)[1]', 'int') AS [SystemIdle],
        record.value('(./Record/SchedulerMonitorEvent/SystemHealth/ProcessUtilization)[1]', 'int') AS [SQLProcessUtilization],
        [timestamp]
    FROM
    (
        SELECT
            [timestamp],
            CONVERT(XML, record) AS [record]
        FROM
            sys.dm_os_ring_buffers
        WHERE
            ring_buffer_type = N'RING_BUFFER_SCHEDULER_MONITOR'
            AND record LIKE N'%<SystemHealth>%'
    ) AS x
) AS y
ORDER BY
    record_id DESC
OPTION ( RECOMPILE );

-- Como retornar o uso de Memória utilizando T-SQL

/*
Para retornar o uso de Memória do servidor utilizando T-SQL, utilize o script abaixo. Com ele, é possível identificar se está havendo pressão de memória e se ela está sendo causada pelo SO ou pelo próprio SQL Server.

O primeiro ponto que deve ser observado, é a coluna “RmNotification”, que nos indica o tipo de notificação gerada:

RESOURCE_MEMPHYSICAL_HIGH – SQL tem espaço para alocar mais memória
RESOURCE_MEMPHYSICAL_LOW – Memória física interna ou de sistema baixa
RESOURCE_MEM_STEADY
RESOURCE_MEMVIRTUAL_LOW – Range de endereços virtuais para o SQL Server estão se esgotando
Se a coluna “RmNotification” apresentar uma mensagem de “RESOURCE_MEMPHYSICAL_LOW”, quer dizer que a memória estava baixa e isso gerou esse alerta na Ring Buffer.

Para entender o que estava baixo, vamos observar as colunas “IndicatorsProcess” e “IndicatorsSystem”.

Se a coluna “IndicatorsProcess” retornar 0 e a coluna “IndicatorsSystem” retornar um valor diferente de 0, quer dizer que o problema de pressão de memória afetou todo o sistema. Mas se o contrário acontecer, quer dizer que somente um processo que sofreu pressão de memória e não o sistema todo (mas não fala qual processo foi).

Possívels valores para as colunas “IndicatorsProcess” e “IndicatorsSystem”:

IDX_MEMPHYSICAL_HIGH (High Physical Memory) = 1
IDX_MEMPHYSICAL_LOW (Low Physical Memory) = 2
IDX_MEMVIRTUALL_LOW (Low Virtual Memory) = 4
*/

-- https://blogs.msdn.microsoft.com/mvpawardprogram/2012/06/04/using-sys-dm_os_ring_buffers-to-diagnose-memory-issues-in-sql-server/
WITH RingBuffer AS ( 
    SELECT
        CAST(dorb.record AS XML) AS xRecord,
        dorb.[timestamp]
    FROM
        sys.dm_os_ring_buffers AS dorb
    WHERE
        dorb.ring_buffer_type = 'RING_BUFFER_RESOURCE_MONITOR' 
)
SELECT
    xr.value('(ResourceMonitor/Notification)[1]', 'varchar(75)') AS RmNotification,
    DATEADD (ss, (-1 * ((B.cpu_ticks / CONVERT (FLOAT, (B.cpu_ticks/ B.ms_ticks))) - A.[timestamp]) / 1000), GETDATE()) AS RmDateTime,
    xr.value('(ResourceMonitor/IndicatorsProcess)[1]', 'tinyint') AS IndicatorsProcess,
    xr.value('(ResourceMonitor/IndicatorsSystem)[1]', 'tinyint') AS IndicatorsSystem,
    xr.value('(MemoryNode/TargetMemory)[1]', 'bigint') AS TargetMemory,
    xr.value('(MemoryNode/ReserveMemory)[1]', 'bigint') AS ReserveMemory,
    xr.value('(MemoryNode/CommittedMemory)[1]', 'bigint') AS CommitedMemory,
    xr.value('(MemoryNode/SharedMemory)[1]', 'bigint') AS SharedMemory,
    xr.value('(MemoryNode/PagesMemory)[1]', 'bigint') AS PagesMemory,
    xr.value('(MemoryRecord/MemoryUtilization)[1]', 'bigint') AS MemoryUtilization,
    xr.value('(MemoryRecord/TotalPhysicalMemory)[1]', 'bigint') AS TotalPhysicalMemory,
    xr.value('(MemoryRecord/AvailablePhysicalMemory)[1]', 'bigint') AS AvailablePhysicalMemory,
    xr.value('(MemoryRecord/TotalPageFile)[1]', 'bigint') AS TotalPageFile,
    xr.value('(MemoryRecord/AvailablePageFile)[1]', 'bigint') AS AvailablePageFile,
    xr.value('(MemoryRecord/TotalVirtualAddressSpace)[1]', 'bigint') AS TotalVirtualAddressSpace,
    xr.value('(MemoryRecord/AvailableVirtualAddressSpace)[1]', 'bigint') AS AvailableVirtualAddressSpace,
    xr.value('(MemoryRecord/AvailableExtendedVirtualAddressSpace)[1]', 'bigint') AS AvailableExtendedVirtualAddressSpace
FROM
    RingBuffer AS A
    CROSS APPLY A.xRecord.nodes('Record') record(xr)
    CROSS JOIN sys.dm_os_sys_info AS B

-- Se precisar de uma query mais simples, pode também utilizar a DMV “dm_os_process_memory”

SELECT * 
FROM sys.dm_os_process_memory

-- Como identificar o espaço total, livre e utilizado dos databases

IF (OBJECT_ID('tempdb..#Datafile_Size ') IS NOT NULL) DROP TABLE #Datafile_Size
SELECT
    B.database_id AS database_id,
    B.[name] AS [database_name],
    A.state_desc,
    A.[type_desc],
    A.[file_id],
    A.[name],
    A.physical_name,
    CAST(C.total_bytes / 1073741824.0 AS NUMERIC(18, 2)) AS disk_total_size_GB,
    CAST(C.available_bytes / 1073741824.0 AS NUMERIC(18, 2)) AS disk_free_size_GB,
    CAST(A.size / 128 / 1024.0 AS NUMERIC(18, 2)) AS size_GB,
    CAST(A.max_size / 128 / 1024.0 AS NUMERIC(18, 2)) AS max_size_GB,
    CAST(
        (CASE
	    WHEN A.growth <= 0 THEN A.size / 128 / 1024.0
            WHEN A.max_size <= 0 THEN C.total_bytes / 1073741824.0
            WHEN A.max_size / 128 / 1024.0 > C.total_bytes / 1073741824.0 THEN C.total_bytes / 1073741824.0
            ELSE A.max_size / 128 / 1024.0 
        END) AS NUMERIC(18, 2)) AS max_real_size_GB,
    CAST(NULL AS NUMERIC(18, 2)) AS free_space_GB,
    (CASE WHEN A.is_percent_growth = 1 THEN A.growth ELSE CAST(A.growth / 128 AS NUMERIC(18, 2)) END) AS growth_MB,
    A.is_percent_growth,
	(CASE WHEN A.growth <= 0 THEN 0 ELSE 1 END) AS is_autogrowth_enabled,
    CAST(NULL AS NUMERIC(18, 2)) AS percent_used,
    CAST(NULL AS INT) AS growth_times
INTO
    #Datafile_Size 
FROM
    sys.master_files        A   WITH(NOLOCK)
    JOIN sys.databases      B   WITH(NOLOCK)    ON  A.database_id = B.database_id
    CROSS APPLY sys.dm_os_volume_stats(A.database_id, A.[file_id]) C

	
UPDATE A
SET
    A.free_space_GB = (
    (CASE 
        WHEN max_size_GB <= 0 THEN A.disk_free_size_GB
        WHEN max_real_size_GB > disk_free_size_GB THEN A.disk_free_size_GB 
        ELSE max_real_size_GB - size_GB
    END)),
    A.percent_used = (size_GB / (CASE WHEN max_real_size_GB > disk_total_size_GB THEN A.disk_total_size_GB ELSE max_real_size_GB END)) * 100
FROM 
    #Datafile_Size A
	

UPDATE A
SET
    A.growth_times = 
    (CASE 
        WHEN A.growth_MB <= 0 THEN 0 
        WHEN A.is_percent_growth = 0 THEN (A.max_real_size_GB - A.size_GB) / (A.growth_MB / 1024.0) 
        ELSE NULL 
    END)
FROM 
    #Datafile_Size A


SELECT * 
FROM #Datafile_Size

-- Informações do disco utilizando DMV’s

SELECT DISTINCT
    VS.volume_mount_point [Montagem] ,
    VS.logical_volume_name AS [Volume] ,
    CAST(CAST(VS.total_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Total (GB)] ,
    CAST(CAST(VS.available_bytes AS DECIMAL(19, 2)) / 1024 / 1024 / 1024 AS DECIMAL(10, 2)) AS [Espaço Disponível (GB)] ,
    CAST(( CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço Disponível ( % )] ,
    CAST(( 100 - CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 ) AS DECIMAL(10, 2)) AS [Espaço em uso ( % )]
FROM
    sys.master_files AS MF
    CROSS APPLY [sys].[dm_os_volume_stats](MF.database_id, MF.file_id) AS VS
WHERE
    CAST(VS.available_bytes AS DECIMAL(19, 2)) / CAST(VS.total_bytes AS DECIMAL(19, 2)) * 100 < 100;

-- Informações do disco utilizando xp_cmdshell e WMIC

--------------------------------------------------------------------------------
-- Habilitando o xp_cmdshell (Se não estiver ativado)
--------------------------------------------------------------------------------

DECLARE @Fl_Xp_CmdShell_Ativado BIT = (SELECT (CASE WHEN CAST([value] AS VARCHAR(MAX)) = '1' THEN 1 ELSE 0 END) FROM sys.configurations WHERE [name] = 'xp_cmdshell')

IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN

    EXECUTE SP_CONFIGURE 'show advanced options', 1;
    RECONFIGURE WITH OVERRIDE;
    
    EXEC sp_configure 'xp_cmdshell', 1;
    RECONFIGURE WITH OVERRIDE;
    
END


--------------------------------------------------------------------------------
-- Código fonte
--------------------------------------------------------------------------------

IF (OBJECT_ID('tempdb..#Retorno_CmdShell') IS NOT NULL) DROP TABLE #Retorno_CmdShell
CREATE TABLE #Retorno_CmdShell (
    Id INT IDENTITY(1, 1),
    Descricao VARCHAR(MAX)
)

INSERT INTO #Retorno_CmdShell
EXEC master.dbo.xp_cmdshell 'wmic logicaldisk where drivetype=3 get Caption,FreeSpace,Size,FileSystem,VolumeName /FORMAT:list'


IF (OBJECT_ID('tempdb..#Informacoes_Disco') IS NOT NULL) DROP TABLE #Informacoes_Disco
CREATE TABLE #Informacoes_Disco (
    Ds_Drive NVARCHAR (256) COLLATE Latin1_General_CI_AI NULL,
    Ds_Volume NVARCHAR (256) COLLATE Latin1_General_CI_AI NULL,
    Ds_FileSystem NVARCHAR (128) COLLATE Latin1_General_CI_AI NULL,
    Qt_Tamanho NUMERIC(18, 2) NULL,
    Qt_Utilizado NUMERIC(18, 2) NULL,
    Qt_Livre NUMERIC(18, 2) NULL,
    Perc_Utilizado NUMERIC(18, 2) NULL,
    Perc_Livre NUMERIC(18, 2) NULL
)

DECLARE 
    @Contador INT = 3, 
    @Total INT = (SELECT COUNT(*) FROM #Retorno_CmdShell),
    @Ds_Drive VARCHAR(100),
    @Ds_Volume VARCHAR(100),
    @Ds_Filesystem VARCHAR(100),
    @Qt_Tamanho FLOAT,
    @Qt_Utilizado FLOAT,
    @Qt_Livre FLOAT,
    @Perc_Utilizado FLOAT,
    @Perc_Livre FLOAT
    
    
WHILE(@Contador <= @Total)
BEGIN
    

    SELECT @Ds_Drive = REPLACE(SUBSTRING(Descricao, CHARINDEX('=', Descricao) + 1, 99999999), CHAR(13), '')
    FROM #Retorno_CmdShell
    WHERE Id = @Contador


    -- Se chegou ao final, força sair do WHILE
    IF (NULLIF(@Ds_Drive, '') IS NULL)
        BREAK


    SELECT @Ds_Filesystem = REPLACE(SUBSTRING(Descricao, CHARINDEX('=', Descricao) + 1, 99999999), CHAR(13), '')
    FROM #Retorno_CmdShell
    WHERE Id = @Contador + 1

    SELECT @Qt_Livre = REPLACE(SUBSTRING(Descricao, CHARINDEX('=', Descricao) + 1, 99999999), CHAR(13), '')
    FROM #Retorno_CmdShell
    WHERE Id = @Contador + 2

    SELECT @Qt_Tamanho = REPLACE(SUBSTRING(Descricao, CHARINDEX('=', Descricao) + 1, 99999999), CHAR(13), '')
    FROM #Retorno_CmdShell
    WHERE Id = @Contador + 3

    SELECT @Ds_Volume = REPLACE(SUBSTRING(Descricao, CHARINDEX('=', Descricao) + 1, 99999999), CHAR(13), '')
    FROM #Retorno_CmdShell
    WHERE Id = @Contador + 4

    
    SELECT
        @Qt_Utilizado = @Qt_Tamanho - @Qt_Livre,
        @Perc_Utilizado = @Qt_Utilizado / @Qt_Tamanho,
        @Perc_Livre = @Qt_Livre / @Qt_Tamanho


    INSERT INTO #Informacoes_Disco (
        Ds_Drive ,
        Ds_Volume ,
        Ds_FileSystem ,
        Qt_Tamanho ,
        Qt_Utilizado ,
        Qt_Livre ,
        Perc_Utilizado ,
        Perc_Livre
    )
    VALUES  (
        @Ds_Drive, -- Ds_Drive - nvarchar(256)
        @Ds_Volume, -- Ds_Volume - nvarchar(256)
        @Ds_Filesystem, -- Ds_FileSystem - nvarchar(128)
        @Qt_Tamanho / 1073741824.0, -- Qt_Tamanho - float
        @Qt_Utilizado / 1073741824.0, -- Qt_Utilizado - float
        @Qt_Livre / 1073741824.0, -- Qt_Livre - float
        @Perc_Utilizado, -- Perc_Utilizado - float
        @Perc_Livre -- Perc_Livre - float
    )


    SET @Contador += 7


END


SELECT * FROM #Informacoes_Disco


--------------------------------------------------------------------------------
-- Desativando o xp_cmdshell (Se não estava habilitado antes)
--------------------------------------------------------------------------------

IF (@Fl_Xp_CmdShell_Ativado = 0)
BEGIN

    EXEC sp_configure 'xp_cmdshell', 0;
    RECONFIGURE WITH OVERRIDE;

    EXECUTE SP_CONFIGURE 'show advanced options', 0;
    RECONFIGURE WITH OVERRIDE;

END

--

sp_configure 'clr enabled', 1  
GO  
RECONFIGURE  
GO  


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
    

    --Memória por índice
SELECT COUNT(*) AS cached_pages_count,COUNT(*)/128.0000 MB,
name AS BaseTableName, IndexName,
IndexTypeDesc
FROM sys.dm_os_buffer_descriptors AS bd
	INNER JOIN	(
				SELECT s_obj.name, s_obj.index_id,
				s_obj.allocation_unit_id, s_obj.OBJECT_ID,
				i.name IndexName, i.type_desc IndexTypeDesc
				FROM
					(SELECT OBJECT_NAME(OBJECT_ID) AS name,	index_id ,
						allocation_unit_id, OBJECT_ID
					 FROM sys.allocation_units AS au
					    INNER JOIN sys.partitions AS p ON au.container_id = p.hobt_id	AND (au.TYPE = 1 OR au.TYPE = 3)
					 UNION ALL
					 SELECT OBJECT_NAME(OBJECT_ID) AS name,
						index_id, allocation_unit_id, OBJECT_ID
					 FROM sys.allocation_units AS au
						INNER JOIN sys.partitions AS p ON au.container_id = p.partition_id	AND au.TYPE = 2
					) AS s_obj
					LEFT JOIN sys.indexes i ON i.index_id = s_obj.index_id
			    	AND i.OBJECT_ID = s_obj.OBJECT_ID 
			    ) AS obj ON bd.allocation_unit_id = obj.allocation_unit_id
WHERE database_id = DB_ID()
GROUP BY name, index_id, IndexName, IndexTypeDesc
ORDER BY cached_pages_count DESC;


-- UltimoAcessoBaseDados

SELECT name [Banco de Dados], MAX(CAST(dt AS SMALLDATETIME)) [Último Acesso]
FROM (
	SELECT d.name, MAX(last_user_seek) DT1, MAX(last_user_scan) DT2
		, MAX(last_user_lookup) DT3, MAX(last_user_update) DT4
		, (SELECT create_date FROM sys.databases WHERE database_id = 2) DT5
	FROM sys.dm_db_index_usage_stats v
		RIGHT JOIN sys.databases d
			ON v.database_id = d.database_id
	WHERE d.database_id > 4
	GROUP BY d.name
	) P
	UNPIVOT (dt FOR a IN (DT1, DT2, DT3, DT4, DT5)) AS UP
GROUP BY name
ORDER BY 2
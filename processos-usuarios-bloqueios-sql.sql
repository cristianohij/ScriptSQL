-- processos ativos

-- runnable = em execução
-- suspended = em processo de retorno

SELECT
	Processo      = spid
	,Computador   = hostname
	,Usuario      = loginame
	,Status       = status
	,BloqueadoPor = blocked
	,TipoComando  = cmd
	,Aplicativo   = program_name
FROM
	master..sysprocesses
WHERE
    blocked<>0
	--and status in ('runnable', 'suspended')
ORDER BY
	blocked desc, status, spid



SELECT
    --s.session_id As Sessao,
    program_name As Aplicacao,
    R.status As StatusRequisicao, blocking_session_id As SessaoBloqueadora
FROM sys.dm_exec_sessions As S
LEFT OUTER JOIN sys.dm_exec_requests As R ON S.session_id = R.session_id
WHERE S.session_id > 50 and S.session_id != @@spid  


 select total_worker_time/execution_count as MediaCPU
, total_worker_time AS TotalCPU
, total_elapsed_time/execution_count as MediaDuration
, total_elapsed_time AS TotalDuration
, total_logical_reads/execution_count as MediaLogicalReads
, total_logical_reads AS TotalLogicalReads
, total_physical_reads/execution_count as MediaPhysicalReads
, total_physical_reads AS TotalPhysicalReads
, execution_count 
, substring(st.text, (qs.statement_start_offset/2)+1
, ((case qs.statement_end_offset  when -1 then datalength(st.text)
else qs.statement_end_offset
end - qs.statement_start_offset)/2) + 1) as txt
, query_plan
from sys.dm_exec_query_stats as qs
cross apply sys.dm_exec_sql_text(qs.sql_handle) as st
cross apply sys.dm_exec_query_plan(qs.plan_handle) as qp
order by 1 desc



SELECT TOP 20
GETDATE() AS 'Collection Date',
qs.execution_count AS 'Execution Count',
SUBSTRING(qt.text,qs.statement_start_offset/2 +1,
(CASE WHEN qs.statement_end_offset = -1
THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
ELSE qs.statement_end_offset END -
qs.statement_start_offset
)/2
) AS 'Query Text',
DB_NAME(qt.dbid) AS 'DB Name',
qs.total_worker_time AS 'Total CPU Time',
qs.total_worker_time/qs.execution_count AS 'Avg CPU Time (ms)',
qs.total_physical_reads AS 'Total Physical Reads',
qs.total_physical_reads/qs.execution_count AS 'Avg Physical Reads',
qs.total_logical_reads AS 'Total Logical Reads',
qs.total_logical_reads/qs.execution_count AS 'Avg Logical Reads',
qs.total_logical_writes AS 'Total Logical Writes',
qs.total_logical_writes/qs.execution_count AS 'Avg Logical Writes',
qs.total_elapsed_time AS 'Total Duration',
qs.total_elapsed_time/qs.execution_count AS 'Avg Duration (ms)',
qp.query_plan AS 'Plan'
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE
qs.execution_count > 50 OR
qs.total_worker_time/qs.execution_count > 100 OR
qs.total_physical_reads/qs.execution_count > 1000 OR
qs.total_logical_reads/qs.execution_count > 1000 OR
qs.total_logical_writes/qs.execution_count > 1000 OR
qs.total_elapsed_time/qs.execution_count > 1000
ORDER BY
qs.execution_count DESC,
qs.total_elapsed_time/qs.execution_count DESC,
qs.total_worker_time/qs.execution_count DESC,
qs.total_physical_reads/qs.execution_count DESC,
qs.total_logical_reads/qs.execution_count DESC,
qs.total_logical_writes/qs.execution_count DESC


SELECT
    *
FROM
    MASTER.DBO.SYSPROCESSES
WHERE
    BLOCKED > 0



select spid, blocked, hostname=left(hostname,20), program_name=left(program_name,20),
       WaitTime_Seg = convert(int,(waittime/1000))  ,open_tran, status
From master.dbo.sysprocesses 
where blocked > 0
order by spid

insert into #monitor exec sp_who2 

--

drop table #TMP_HistoricoProcessos
go

CREATE TABLE #TMP_HistoricoProcessos
(
    SPID SMALLINT,
    Status NCHAR(30),
    Login NVARCHAR(128),
    HostName NVARCHAR(128),
    BlkBy NVARCHAR(128),
    DBName NVARCHAR(256),
    Command NVARCHAR(128),
    CPUTime INT,
    DiskIO BIGINT,
    LastBatch VARCHAR(20),
    ProgramName NVARCHAR(128),
    SPID_2 SMALLINT,
    RequestId INT
)
go

set nocount on
go
 
insert into #TMP_HistoricoProcessos exec dbo.sp_who2
go

set nocount off
go

select SPID,
       BlkBy as BloqueadoPor,
       HostName as Host,
       Command as Comando,
       LastBatch as UltimaExecucao,
       ProgramName as Programa
  from #TMP_HistoricoProcessos
 where DBName='SIBD'

-- informar o número do SPID que deseja desconectar
kill 50


dbcc memorystatus;
go

select type
       ,memory_node_id
	   ,pages_kb
  from sys.dm_os_memory_clerks;
go

dbcc sqlperf(logspace)

-- quantidade de espaço vazio na memória
select count(*) * 8 / 1024 as [MBUsed]
       ,sum([free_space_in_bytes]) / (1024 * 1024) as [MBEmpty]
  from sys.dm_os_buffer_descriptors;
go

-- quantidade de memória disperdiçada por banco de dados
select (case when ([database_id]=32767)
             then N'Resource Database'
			 else db_name ([database_id]) end) as [DatabaseName]
			 ,count(*) * 8 / 1024 as [MBUsed]
             ,sum([free_space_in_bytes]) / (1024 * 1024) as [MBEmpty]
  from sys.dm_os_buffer_descriptors
 group by [database_id]
go

-- Qual o maior consumidor do TEMPDB na sua instância?
SELECT
sys.dm_exec_sessions.session_id AS [SESSION ID],
(user_objects_alloc_page_count * 8) AS [SPACE Allocated FOR USER Objects (in KB)],
(internal_objects_alloc_page_count * 8) AS [SPACE Allocated FOR Internal Objects (in KB)],
DB_NAME(sys.dm_exec_sessions.database_id) AS [DATABASE Name],
HOST_NAME AS [System Name],
program_name AS [Program Name],
login_name AS [USER Name],
status,
row_count AS [ROW COUNT]
FROM
sys.dm_db_session_space_usage
INNER join
sys.dm_exec_sessions
ON
sys.dm_db_session_space_usage.session_id = sys.dm_exec_sessions.session_id
WHERE
sys.dm_exec_sessions.Session_id > 50

-- analizar uma conexão
dbcc inputbuffer(56)

dbcc opentran

sp_spaceused 'TBS010'

-- analisando um transação em detalhes

select [Current LSN]
       ,[Transaction ID]
	   ,[Operation]
	   ,[Transaction Name]
	   ,[Context]
	   ,[AllocUnitName]
	   ,[Page ID]
	   ,[Slot ID]
	   ,[Begin Time]
	   ,[End Time]
	   ,[Number of Locks]
	   ,[Lock Information]
  from sys.fn_dblog(null,null)
 where Operation in('LOP_INSERT_ROWS','LOP_MODIFY_ROWS','LOP_DELETE_ROWS','LOP_BEGIN_XACT','LOP_COMMIT_XACT')
 order by [Begin Time] desc


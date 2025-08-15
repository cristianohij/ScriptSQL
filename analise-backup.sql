-- log do sql por banco de dados

exec sp_readerrorlog 0, 1, 'SIBD'

-- andamento de um backup

SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE')

SELECT TOP 100 s.database_name As NomeDobanco, 
CASE s.[type] 
WHEN 'D' THEN 'Full'
WHEN 'I' THEN 'Differential'
WHEN 'L' THEN 'Transaction Log'
END AS TipoDeBackup, 
m.physical_device_name AS CaminhoFisicoDoArquivo, 
Cast(Cast(s.backup_size / 1000000 AS INT) AS VARCHAR(14)) 
+ ' ' + 'MB' AS TamanhoDoBackup, 
Cast(Datediff(second, s.backup_start_date, s.backup_finish_date) 
AS VARCHAR(4)) 
+ ' ' + 'Segundos' AS TempoDoBackup, 
s.backup_start_date AS DataInicioDoBackup, 
s.server_name AS Servidor, 
s.recovery_model 
FROM msdb.dbo.backupset s 
INNER JOIN msdb.dbo.backupmediafamily m 
ON s.media_set_id = m.media_set_id 
ORDER BY backup_start_date DESC, 
backup_finish_date 
go 

-- versão do sql server

select @@version


select @@CPU_BUSY
select @@CONNECTIONS
select @@PACKET_ERRORS

SELECT o.name, i.name, bd.*
 FROM sys.dm_os_buffer_descriptors bd
 INNER JOIN sys.allocation_units a
 ON bd.allocation_unit_id = a.allocation_unit_id
 INNER JOIN
 sys.partitions p
 ON (a.container_id = p.hobt_id AND a.type IN (1, 3))
 OR (a.container_id = p.partition_id AND a.type = 2)
 INNER JOIN sys.objects o ON p.object_id = o.object_id
 INNER JOIN sys.indexes i
 ON p.object_id = i.object_id AND p.index_id = i.index_id 
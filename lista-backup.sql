SELECT

SERVERPROPERTY('SERVER2012') AS 'Servidor',

msdb.dbo.backupset.database_name As 'Database',

CASE msdb..backupset.type

WHEN 'D' THEN 'Database'

WHEN 'L' THEN 'Log'

WHEN 'I' THEN 'Diferencial'

WHEN 'F' THEN 'File ou Filegroup'

WHEN 'G' THEN 'Diferencial Arquivo'

WHEN 'P' THEN 'Parcial'

WHEN 'Q' THEN 'Diferencial Parcial'

END AS 'Tipo do Backup',

msdb.dbo.backupset.backup_start_date As 'Data Execuo',

msdb.dbo.backupset.backup_finish_date As 'Data Encerramento',

msdb.dbo.backupset.expiration_date As 'Data de Expirao',

(msdb.dbo.backupset.backup_size / 1024) As 'Tamanho do  Backup em MBs',

msdb.dbo.backupmediafamily.logical_device_name As 'Dispositivo ou Local de Backup',

msdb.dbo.backupmediafamily.physical_device_name As 'Caminho do Arquivo',

msdb.dbo.backupset.description As 'Descrio',

Case msdb.dbo.backupset.compatibility_level

When 80 Then 'SQL Server 2000'

When 90 Then 'SQL Server 2005'

When 100 Then 'SQL Server 2008 ou SQL Server 2008 R2'

When 110 Then 'SQL Server 2012'

End As 'Nvel de Compatibilidade',

msdb.dbo.backupset.name AS 'Backup Set'

FROM

msdb.dbo.backupmediafamily INNER JOIN msdb.dbo.backupset

ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id

WHERE

(CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 103) >= GETDATE()- 15) AND 
msdb.dbo.backupset.database_name='SIBD'

ORDER

BY msdb.dbo.backupset.database_name, msdb.dbo.backupset.backup_finish_date desc



----

-- Exemplo: C�digo 1 � Obtendo informa��es sobre o Backup

SELECT command,

               'EstimatedEndTime' = Dateadd(ms,estimated_completion_time,Getdate()),

               'EstimatedSecondsToEnd' = estimated_completion_time / 1000,

               'EstimatedMinutesToEnd' = estimated_completion_time / 1000 / 60,

               'BackupStartTime' = start_time,

               'TimeExecution'=  DateDiff(minute,Getdate(),Start_time),

               'PercentComplete' = percent_complete

FROM sys.dm_exec_requests

 WHERE session_id = @@SPID


---


SELECT sdb.Name AS DatabaseName,
COALESCE(CONVERT(VARCHAR(12), MAX(bus.backup_finish_date), 101),'-') AS LastBackUpTime,*
FROM sys.sysdatabases sdb
LEFT OUTER JOIN msdb.dbo.backupset bus ON bus.database_name = sdb.name
GROUP BY sdb.Name

select * from sys.sysdatabases

select * from msdb.dbo.backupset where database_name='SIBD' order by backup_start_date desc



-- informa��es da restaura��o

SELECT  [rs].[destination_database_name] ,
        [rs].[restore_date] ,
        [bs].[backup_start_date] ,
        [bs].[backup_finish_date] ,
        [bs].[database_name] AS [source_database_name] ,
        [bmf].[physical_device_name] AS [backup_file_used_for_restore]
FROM    msdb..restorehistory rs
        INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]
        INNER JOIN msdb..backupmediafamily bmf ON [bs].[media_set_id] = [bmf].[media_set_id]
ORDER BY [rs].[restore_date] DESC




DECLARE @dbname sysname, @days int
SET @dbname = 'SIBD' --substitute for whatever database name you want
SET @days = -30 --previous number of days, script will default to 30
SELECT
 rsh.destination_database_name AS [Database],
 rsh.user_name AS [Restored By],
 CASE WHEN rsh.restore_type = 'D' THEN 'Database'
  WHEN rsh.restore_type = 'F' THEN 'File'
  WHEN rsh.restore_type = 'G' THEN 'Filegroup'
  WHEN rsh.restore_type = 'I' THEN 'Differential'
  WHEN rsh.restore_type = 'L' THEN 'Log'
  WHEN rsh.restore_type = 'V' THEN 'Verifyonly'
  WHEN rsh.restore_type = 'R' THEN 'Revert'
  ELSE rsh.restore_type 
 END AS [Restore Type],
 rsh.restore_date AS [Restore Started],
 bmf.physical_device_name AS [Restored From], 
 rf.destination_phys_name AS [Restored To]
FROM msdb.dbo.restorehistory rsh
 INNER JOIN msdb.dbo.backupset bs ON rsh.backup_set_id = bs.backup_set_id
 INNER JOIN msdb.dbo.restorefile rf ON rsh.restore_history_id = rf.restore_history_id
 INNER JOIN msdb.dbo.backupmediafamily bmf ON bmf.media_set_id = bs.media_set_id
WHERE rsh.restore_date >= DATEADD(dd, ISNULL(@days, -30), GETDATE()) --want to search for previous days
AND destination_database_name = ISNULL(@dbname, destination_database_name) --if no dbname, then return all
ORDER BY rsh.restore_history_id DESC
GO
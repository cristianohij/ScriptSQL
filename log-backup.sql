-- retore de backup
SELECT * FROM msdb.dbo.restorehistory ORDER BY restore_history_id DESC;

-- log de backups
SELECT
  logical_name
, physical_name
, file_type
, [filegroup_name]
, file_size
, backup_set_id
FROM msdb.dbo.backupfile

SELECT
  backupset.[name]
, backupset.[description]
, [type]
, expiration_date
, is_compressed
, Device_Type
, [user_name]
, server_name
, [database_name]
, is_copy_only
, backup_start_date
, backup_finish_date
, backup_size
, compressed_backup_size
, physical_device_name
, [backup_set_id]
, backupset.media_set_id
FROM msdb.dbo.backupset
  INNER JOIN msdb.dbo.backupmediaset ON backupset.media_set_id = backupmediaset.media_set_id
  INNER JOIN msdb.dbo.backupmediafamily ON backupset.media_set_id = backupmediafamily.media_set_id
WHERE database_name = 'SIBD'

--------------------------------------------------------------------------------- 
--Database Backups for all databases For Previous Week 
--------------------------------------------------------------------------------- 
SELECT 
CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
msdb.dbo.backupset.database_name, 
msdb.dbo.backupset.backup_start_date, 
msdb.dbo.backupset.backup_finish_date, 
msdb.dbo.backupset.expiration_date, 
CASE msdb..backupset.type 
WHEN 'D' THEN 'Database' 
WHEN 'L' THEN 'Log' 
END AS backup_type, 
msdb.dbo.backupset.backup_size, 
msdb.dbo.backupmediafamily.logical_device_name, 
msdb.dbo.backupmediafamily.physical_device_name, 
msdb.dbo.backupset.name AS backupset_name, 
msdb.dbo.backupset.description 
FROM msdb.dbo.backupmediafamily 
INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY 
msdb.dbo.backupset.database_name, 
msdb.dbo.backupset.backup_finish_date 
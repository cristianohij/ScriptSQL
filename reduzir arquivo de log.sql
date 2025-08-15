-- em options na propriedade do banco, marcar somente:
-- recover model = simple
-- auto close
-- auto shrink

BACKUP LOG SIBD WITH TRUNCATE_ONLY
sp_helpfile
DBCC SHRINKFILE(TRANSF_Log,2)
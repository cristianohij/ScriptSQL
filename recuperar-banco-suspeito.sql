Alter Database SIBD

Set Emergency

Go

ALTER DATABASE SIBD SET SINGLE_USER
Go

DBCC CHECKDB (SIBD, REPAIR_ALLOW_DATA_LOSS)

WITH NO_INFOMSGS, ALL_ERRORMSGS

Go

 

ALTER DATABASE SIBD SET read_write

ALTER DATABASE SIBD SET multi_user

Go


-- testar essa:

dbcc rebuild_log(db_NomeBanco)
  go

--- 

use master
  go

  sp_configure 'allow updates', 1
  go

  reconfigure with override
  go

use master
  go

  sp_configure 'allow updates', 0
  go

  reconfigure with override
  go

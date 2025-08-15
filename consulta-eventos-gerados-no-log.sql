-- consulta eventos gerados no Log
select convert(numeric(18,2), sum("Log Record Length") / 1024. / 1024.) as MBs
  from ::fn_dblog(null,null)
go